`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 2025/09/05
// Module Name: Sync_axis
// Description:
//   在每 255 字节的 RS 编码码字前插入 32'h1ACFFC1D 同步头。
//   在数据末尾填充字节以确保输出为 32-bit 对齐。
//   使用 AXI4-Stream 接口，严格遵守 tvalid/tready 协议。
//////////////////////////////////////////////////////////////////////////////////

module Sync_axis (
    input     wire            rst,
    input     wire            core_clk,

    // AXI Stream Input (8-bit)
    input     wire  [7:0]     s_axis_input_tdata,
    input     wire            s_axis_input_tvalid,
    input     wire            s_axis_input_tlast, // 未使用
    output    wire            s_axis_input_tready,

    // AXI Stream Output (8-bit)
    output    reg   [7:0]     m_axis_output_tdata,
    output    reg             m_axis_output_tvalid,
    input     wire            m_axis_output_tready
);

    // 参数
    parameter [31:0] SYNC_MARKER = 32'h1ACFFC1D;
    parameter integer PAYLOAD_LEN = 255;
    localparam integer PADDING_LEN = (4 - ((4 + PAYLOAD_LEN) % 4)) % 4;

    // 状态机
    localparam IDLE         = 3'b000;
    localparam SEND_SYNC    = 3'b001;
    localparam SEND_DATA    = 3'b010;
    localparam SEND_PADDING = 3'b011;

    reg [2:0] state, n_state;

    // FIFO 接口
    wire                  input_fifo_rden;
    wire [7:0]            input_fifo_dout;
    wire                  input_fifo_full;
    wire                  input_fifo_empty;
    wire                  input_fifo_wrrbsy;
    wire                  input_fifo_rdrbsy;

    wire input_fifo_output_rdy = !input_fifo_empty && !input_fifo_rdrbsy;
    assign s_axis_input_tready = !input_fifo_full && !input_fifo_wrrbsy;

    // FIFO 实例
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

    // 计数器
    reg [1:0] sync_byte_cnt;
    reg [7:0] data_byte_cnt;
    reg [1:0] pad_byte_cnt;

    // Handshake
    wire m_axis_fire = m_axis_output_tvalid && m_axis_output_tready;

    // 状态机更新
    always @(posedge core_clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= n_state;
    end

    // 状态转移
    always @(*) begin
        n_state = state;
        case (state)
            IDLE: begin
                if (input_fifo_output_rdy) n_state = SEND_SYNC;
            end
            SEND_SYNC: begin
                if (m_axis_fire && (sync_byte_cnt == 2'd3))
                    n_state = SEND_DATA;
            end
            SEND_DATA: begin
                if (m_axis_fire && (data_byte_cnt == PAYLOAD_LEN-1))
                    n_state = (PADDING_LEN>0) ? SEND_PADDING : IDLE;
            end
            SEND_PADDING: begin
                if (m_axis_fire && (pad_byte_cnt == PADDING_LEN-1))
                    n_state = IDLE;
            end
        endcase
    end

    // 计数器逻辑（只在 handshake 成功时递增）
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            sync_byte_cnt <= 0;
            data_byte_cnt <= 0;
            pad_byte_cnt  <= 0;
        end else begin
            if (state == SEND_SYNC && m_axis_fire)
                sync_byte_cnt <= sync_byte_cnt + 1'b1;
            else if (state != SEND_SYNC)
                sync_byte_cnt <= 0;

            if (state == SEND_DATA && m_axis_fire)
                data_byte_cnt <= data_byte_cnt + 1'b1;
            else if (state != SEND_DATA)
                data_byte_cnt <= 0;

            if (state == SEND_PADDING && m_axis_fire)
                pad_byte_cnt <= pad_byte_cnt + 1'b1;
            else if (state != SEND_PADDING)
                pad_byte_cnt <= 0;
        end
    end

    // FIFO 读使能（仅在 SEND_DATA 且需要新字节时）
    assign input_fifo_rden = (state == SEND_DATA) && (!m_axis_output_tvalid || m_axis_fire) && input_fifo_output_rdy;

    // 输出数据与 tvalid 保持
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tdata  <= 8'd0;
            m_axis_output_tvalid <= 1'b0;
        end else begin
            if (m_axis_fire) begin
                m_axis_output_tvalid <= 1'b0; // handshake 完成，清零，等待下一个数据
            end

            case (state)
                SEND_SYNC: begin
                    if (!m_axis_output_tvalid || m_axis_fire) begin
                        case (sync_byte_cnt)
                            2'd0: m_axis_output_tdata <= SYNC_MARKER[31:24];
                            2'd1: m_axis_output_tdata <= SYNC_MARKER[23:16];
                            2'd2: m_axis_output_tdata <= SYNC_MARKER[15:8];
                            2'd3: m_axis_output_tdata <= SYNC_MARKER[7:0];
                        endcase
                        m_axis_output_tvalid <= 1'b1;
                    end
                end

                SEND_DATA: begin
                    if (input_fifo_rden) begin
                        m_axis_output_tdata  <= input_fifo_dout;
                        m_axis_output_tvalid <= 1'b1;
                    end
                end

                SEND_PADDING: begin
                    if (!m_axis_output_tvalid || m_axis_fire) begin
                        m_axis_output_tdata  <= 8'h00;
                        m_axis_output_tvalid <= 1'b1;
                    end
                end

                default: begin
                    if (m_axis_fire)
                        m_axis_output_tvalid <= 1'b0;
                end
            endcase
        end
    end

endmodule
