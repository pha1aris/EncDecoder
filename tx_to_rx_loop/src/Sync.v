`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2025/09/05 11:30:00 (精炼优化版)
// Design Name:
// Module Name: Sync
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   将输入的8-bit AXI-Stream数据流打包成32-bit。
//   在每 255 字节的数据前插入一个 32-bit 同步头 (SYNC_MARKER)。
//   在数据帧末尾添加填充字节，以确保输出的字节总数是4的倍数。
//   输出为标准的32-bit AXI-Stream接口，包含 TDATA, TVALID, TREADY, TLAST。
//
// Revision:
//   3.10 - (在 3.00 版本基础上) 增加了更详细的注释，阐明流水线工作原理。
//        - 移除了未使用的内部寄存器，清理了代码。
//        - 明确了对 s_axis_input_tlast 的处理方式。
//
//////////////////////////////////////////////////////////////////////////////////

module Sync (
    input  wire         rst,        // 高有效复位
    input wire          wr_clk,     // 输入数据时钟
    input  wire         core_clk,   // 时钟

    // 8-bit AXI-Stream Slave Interface (Input)
    input  wire [7:0]   s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    input  wire         s_axis_input_tlast,  // 注意: 当前逻辑将输入视为连续流, tlast未用于帧同步
    output wire         s_axis_input_tready,

    // 32-bit AXI-Stream Master Interface (Output)
    output wire [31:0]  m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    output wire         m_axis_output_tlast,
    input  wire         m_axis_output_tready
);

// ============================================================================
// 参数定义 (Parameters)
// ============================================================================
    parameter [31:0] SYNC_MARKER   = 32'h1ACFFC1D;
    parameter integer  PAYLOAD_LEN   = 255;
    parameter [7:0]  PADDING_BYTE  = 8'hAC;
    localparam integer SYNC_LEN      = 4; // 同步头为4字节

    // 自动计算需要填充的字节数, 确保 (SYNC_LEN + PAYLOAD_LEN + PADDING_LEN) % 4 == 0
    localparam integer PADDING_LEN   = (4 - ((SYNC_LEN + PAYLOAD_LEN) % 4)) % 4;
    localparam integer FRAME_LEN_BYTES = SYNC_LEN + PAYLOAD_LEN + PADDING_LEN;


// ============================================================================
// 阶段一: 字节生成器 (Byte Generation Stage)
// 职责: 根据状态机，生成一个内部的8-bit字节流 (同步头/数据/填充)
// ============================================================================

    // 内部8-bit字节流接口 (连接阶段一和阶段二)
    wire [7:0]  internal_byte_data;
    wire        internal_byte_valid;
    wire        internal_byte_tlast;
    wire        internal_byte_ready; // 由阶段二提供，用于反压

    // 状态定义
    localparam [1:0] FSM_IDLE         = 2'b00;
    localparam [1:0] FSM_SEND_SYNC    = 2'b01;
    localparam [1:0] FSM_SEND_DATA    = 2'b10;
    localparam [1:0] FSM_SEND_PADDING = 2'b11;

    reg [1:0] state, n_state;
    reg [$clog2(FRAME_LEN_BYTES)-1:0] frame_byte_cnt; // 统一的帧内字节计数器

    // FIFO 接口
    wire input_fifo_rden;
    wire [7:0] input_fifo_dout;
    wire input_fifo_full;
    wire input_fifo_empty;

    assign s_axis_input_tready = !input_fifo_full;
    assign input_fifo_rden = (state == FSM_SEND_DATA) && internal_byte_ready;

    dec_fifo_8w_8r input_fifo (
        .rst        (rst),
        .wr_clk     (wr_clk),
        .rd_clk     (core_clk),
        .din        (s_axis_input_tdata),
        .wr_en      (s_axis_input_tvalid && s_axis_input_tready),
        .rd_en      (input_fifo_rden),
        .dout       (input_fifo_dout),
        .full       (input_fifo_full),
        .empty      (input_fifo_empty),
        .wr_rst_busy(), // 假设的端口，实际使用时请匹配您的FIFO IP
        .rd_rst_busy()
    );

    // 状态机 - 时序逻辑
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            state <= FSM_IDLE;
        end else begin
            state <= n_state;
        end
    end

    // 状态机 - 组合逻辑 (状态转移)
    always @(*) begin
        n_state = state;
        case (state)
            FSM_IDLE: begin
                // 只要输入FIFO中有数据，就启动一个新的帧处理流程
                if (!input_fifo_empty) begin
                    n_state = FSM_SEND_SYNC;
                end
            end
            FSM_SEND_SYNC: begin
                if (internal_byte_ready && frame_byte_cnt == SYNC_LEN - 1) begin
                   n_state = FSM_SEND_DATA;
                end
            end
            FSM_SEND_DATA: begin
                if (internal_byte_ready && frame_byte_cnt == SYNC_LEN + PAYLOAD_LEN - 1) begin
                    n_state = (PADDING_LEN > 0) ? FSM_SEND_PADDING : FSM_IDLE;
                end
            end
            FSM_SEND_PADDING: begin
                if (internal_byte_ready && frame_byte_cnt == FRAME_LEN_BYTES - 1) begin
                    n_state = FSM_IDLE;
                end
            end
        endcase
    end

    // 帧内字节计数器
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            frame_byte_cnt <= 'd0;
        end else if (state == FSM_IDLE && n_state == FSM_IDLE) begin // 在IDLE状态保持清零
             frame_byte_cnt <= 'd0;
        end else if (internal_byte_ready && internal_byte_valid) begin // 仅当字节被下游接收时才计数
             if (frame_byte_cnt == FRAME_LEN_BYTES - 1) begin
                 frame_byte_cnt <= 'd0; // 帧结束，计数器清零
             end else begin
                 frame_byte_cnt <= frame_byte_cnt + 1;
             end
        end
    end

    // 字节数据源选择
    assign internal_byte_data = (state == FSM_SEND_SYNC)    ? SYNC_MARKER >> (8 * (SYNC_LEN - 1 - frame_byte_cnt[1:0])) : // 大端字节序
                                (state == FSM_SEND_DATA)    ? input_fifo_dout :
                                (state == FSM_SEND_PADDING) ? PADDING_BYTE :
                                8'h00;

    // 字节流的 valid 和 tlast 信号
    assign internal_byte_valid = (state != FSM_IDLE) && ((state != FSM_SEND_DATA) || !input_fifo_empty);
    assign internal_byte_tlast = (frame_byte_cnt == FRAME_LEN_BYTES - 1) && internal_byte_valid;


// ============================================================================
// 阶段二: 位宽转换器 (Width Converter Stage)
// 职责: 将内部8-bit字节流打包成32-bit AXI-Stream输出
// ============================================================================
    localparam RATIO = 32 / 8;
    reg [1:0] pack_cnt; // 0..3
    reg [23:0] pack_buffer; // 仅需存储前3个字节

    reg [31:0] m_axis_output_tdata_reg;
    reg        m_axis_output_tvalid_reg;
    reg        m_axis_output_tlast_reg;
    
    // 反压信号: 只有当转换器准备好接收下一个字节时，才拉高 ready
    // 这是流水线设计的关键：当输出寄存器被下游占用时 (tvalid=1, tready=0), 
    // ready信号会变低，从而暂停上游的字节生成器。
    assign internal_byte_ready = !m_axis_output_tvalid_reg || m_axis_output_tready;

    // 核心打包逻辑
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tvalid_reg <= 1'b0;
            m_axis_output_tdata_reg  <= 32'd0;
            m_axis_output_tlast_reg  <= 1'b0;
            pack_cnt                 <= 2'd0;
            pack_buffer              <= 24'd0;
        end else begin
            // 当下游接收了数据(tready=1)，或者当前输出本就无效时(tvalid=0)，我们就可以处理新的字节
            if (internal_byte_ready) begin
                // 默认将输出valid拉低，只有在打包满一个字时才置高
                m_axis_output_tvalid_reg <= 1'b0;

                // 如果此时有新的字节进来，进行打包
                if (internal_byte_valid) begin
                    if (pack_cnt == RATIO - 1) begin
                        // 这是第4个字节，已集满一个32-bit字
                        m_axis_output_tvalid_reg <= 1'b1;
                        // 将之前缓存的3个字节与当前字节拼接成一个完整的32-bit字
                        m_axis_output_tdata_reg  <= {pack_buffer, internal_byte_data};
                        m_axis_output_tlast_reg  <= internal_byte_tlast;
                        pack_cnt                 <= 2'd0;
                    end else begin
                        // 还未集满，将当前字节存入缓存区
                        pack_buffer <= {pack_buffer[15:0], internal_byte_data};
                        pack_cnt    <= pack_cnt + 1;
                    end
                end
            end
            // else: 下游反压 (tvalid=1, tready=0), 所有寄存器保持不变，实现暂停
        end
    end

    // 连接到最终输出端口
    assign m_axis_output_tdata  = m_axis_output_tdata_reg;
    assign m_axis_output_tvalid = m_axis_output_tvalid_reg;
    assign m_axis_output_tlast  = m_axis_output_tlast_reg;

endmodule
