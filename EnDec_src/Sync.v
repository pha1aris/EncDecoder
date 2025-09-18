`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 2025/09/05 09:52:38 (改进版)
// Design Name: 
// Module Name: rs_enc_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//   在每 255 字节的 RS 编码码字前插入 32'h1ACFFC1D 同步头。
//   在数据末尾填充字节以确保输出为 32-bit 对齐。
//   将 8-bit 数据流打包成 32-bit 字输出。
//   输出 sync_data_o 在每 4 个字节对齐时有效，sync_valid_o 拉高一拍。
//
// Revision:
//   1.00 - 修正了状态机逻辑、数据打包错误和帧对齐问题。
//        - 增加了 PADDING 状态以确保输出数据是 32-bit 对齐的。
//        - 优化了代码结构和可读性。
//
//////////////////////////////////////////////////////////////////////////////////

module Sync (
    input                 rst,                  // 高有效复位
    input                 core_clk,             // 时钟

    // AXI Stream Input
    input      [7:0]      s_axis_input_tdata,
    input                 s_axis_input_tvalid,
    input                 s_axis_input_tlast,   // tlast 信号当前未被使用，逻辑依赖于固定的 PAYLOAD_LEN
    output                s_axis_input_tready,

    // 32-bit Aligned Output
    output reg [31:0]     sync_data_o,
    output reg            sync_valid_o
);

// 参数定义
    parameter [31:0] SYNC_MARKER = 32'h1ACFFC1D;
    parameter integer  PAYLOAD_LEN = 255;
    // 计算需要填充的字节数, 确保 (4 + 255 + PADDING_LEN) % 4 == 0
    localparam integer PADDING_LEN = (4 - ((4 + PAYLOAD_LEN) % 4)) % 4;

// 状态定义 (使用 3-bit 以包含 PADDING 状态)
    localparam IDLE         = 3'b000;
    localparam SEND_SYNC    = 3'b001;
    localparam SEND_DATA    = 3'b010;
    localparam SEND_PADDING = 3'b011;

// FIFO 接口信号 (假设已例化名为 dec_fifo_8w_8r 的 FIFO)
    wire                  input_fifo_rden;
    wire [7:0]            input_fifo_dout;
    wire                  input_fifo_full;
    wire                  input_fifo_empty;
    wire                  input_fifo_wrrbsy;
    wire                  input_fifo_rdrbsy;
    wire                  input_fifo_output_rdy; // FIFO 有数据可读的标志

// 内部寄存器和线网
    reg [2:0]  state, n_state;
    reg [1:0]  sync_byte_cnt;        // 同步头字节计数 (0-3)
    reg [7:0]  data_byte_cnt;        // 数据字节计数 (0-254)
    reg [1:0]  pad_byte_cnt;         // 填充字节计数
    reg [1:0]  pack_byte_cnt;        // 8-bit -> 32-bit 打包计数 (0-3)
    
    reg       output_valid;         // 内部单字节有效信号
    reg [7:0] output_data;          // 内部单字节数据总线

// 模块连接
    assign s_axis_input_tready = !input_fifo_full && !input_fifo_wrrbsy;
    assign input_fifo_output_rdy = !input_fifo_empty && !input_fifo_rdrbsy;
    // 仅在 SEND_DATA 状态且 FIFO 有数据时，才使能读 FIFO
    assign input_fifo_rden = (state == SEND_DATA) && input_fifo_output_rdy;

// FIFO 实例 (请确保你的工程中有此模块)
    dec_fifo_8w_8r input_fifo (
      .rst          (rst),
      .wr_clk       (core_clk),
      .rd_clk       (core_clk),
      .din          (s_axis_input_tdata),
      .wr_en        (s_axis_input_tvalid && s_axis_input_tready),
      .rd_en        (input_fifo_rden),
      .dout         (input_fifo_dout),
      .full         (input_fifo_full),
      .empty        (input_fifo_empty),
      .wr_rst_busy  (input_fifo_wrrbsy),
      .rd_rst_busy  (input_fifo_rdrbsy)
    );

// 状态寄存器 (时序逻辑)
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= n_state;
        end
    end

// 状态转移逻辑 (组合逻辑)
    always @(*) begin
        n_state = state;
        case (state)
            IDLE: begin
                if (input_fifo_output_rdy) begin
                    n_state = SEND_SYNC;
                end
            end
            SEND_SYNC: begin
                // 发送完 4 字节同步头后 (计数器为3是最后一字节), 进入 SEND_DATA
                if (sync_byte_cnt == 2'd3) begin
                    n_state = SEND_DATA;
                end
            end
            SEND_DATA: begin
                // 成功读取最后一个数据字节后, 进入 PADDING 或 IDLE
                if (input_fifo_rden && (data_byte_cnt == PAYLOAD_LEN - 1)) begin
                    n_state = (PADDING_LEN > 0) ? SEND_PADDING : IDLE;
                end
            end
            SEND_PADDING: begin
                // 发送完所有填充字节后，返回 IDLE
                if (pad_byte_cnt == PADDING_LEN - 1) begin
                    n_state = IDLE;
                end
            end
            default: n_state = IDLE;
        endcase
    end

// 计数器更新 (时序逻辑)
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            sync_byte_cnt <= 2'd0;
            data_byte_cnt <= 8'd0;
            pad_byte_cnt  <= 2'd0;
        end else begin
            // sync_byte_cnt: 只在 SEND_SYNC 状态下计数
            if (state == SEND_SYNC) begin
                sync_byte_cnt <= sync_byte_cnt + 1'b1;
            end else begin
                sync_byte_cnt <= 2'd0;
            end

            // data_byte_cnt: 只在 SEND_DATA 状态且成功读 FIFO 时计数
            if (state == SEND_DATA && input_fifo_rden) begin
                data_byte_cnt <= data_byte_cnt + 1'b1;
            end else if (state != SEND_DATA) begin // 离开 SEND_DATA 状态时复位
                data_byte_cnt <= 8'd0;
            end

            // pad_byte_cnt: 只在 SEND_PADDING 状态下计数
            if (state == SEND_PADDING) begin
                pad_byte_cnt <= pad_byte_cnt + 1'b1;
            end else begin
                pad_byte_cnt <= 2'd0;
            end
        end
    end

// 字节输出选择逻辑 (组合逻辑)
    always @(*) begin
        case (state)
            SEND_SYNC: begin
                output_valid = 1'b1;
                case (sync_byte_cnt)
                    2'd0:    output_data = SYNC_MARKER[31:24];
                    2'd1:    output_data = SYNC_MARKER[23:16];
                    2'd2:    output_data = SYNC_MARKER[15:8];
                    default: output_data = SYNC_MARKER[7:0];
                endcase
            end
            SEND_DATA: begin
                // 当 FIFO 可读时，输出数据有效
                output_valid = input_fifo_rden;
                output_data  = input_fifo_dout;
            end
            SEND_PADDING: begin
                output_valid = 1'b1;
                output_data  = 8'h00; // 填充 0
            end
            default: begin // IDLE
                output_valid = 1'b0;
                output_data  = 8'd0;
            end
        endcase
    end

// 8-bit -> 32-bit 打包逻辑 (时序逻辑)
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            sync_data_o   <= 32'd0;
            sync_valid_o  <= 1'b0;
            pack_byte_cnt <= 2'd0;
        end else begin
            sync_valid_o <= 1'b0; // 默认无效，仅在打满一包时拉高一拍

            if (output_valid) begin
                // [正确] 根据字节位置，将数据放入 32-bit 字的正确位置
                case (pack_byte_cnt)
                    2'd0: sync_data_o[31:24] <= output_data;
                    2'd1: sync_data_o[23:16] <= output_data;
                    2'd2: sync_data_o[15:8]  <= output_data;
                    2'd3: sync_data_o[7:0]   <= output_data;
                endcase

                if (pack_byte_cnt == 2'd3) begin
                    // 已拼满 4 字节，输出有效信号，并复位打包计数器
                    sync_valid_o  <= 1'b1;
                    pack_byte_cnt <= 2'd0;
                end else begin
                    pack_byte_cnt <= pack_byte_cnt + 1'b1;
                end
            end
        end
    end

endmodule