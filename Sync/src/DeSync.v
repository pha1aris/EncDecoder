`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2025/09/05 12:00:00 (精炼优化版)
// Design Name:
// Module Name: DeSync
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   作为 Sync 模块的对应模块，执行逆操作。
//   输入一个32-bit AXI-Stream数据流。
//   在数据流中搜索 32-bit 同步头 (SYNC_MARKER)。
//   找到同步头后，提取并输出后续 255 字节的有效载荷 (Payload)。
//   丢弃帧末尾的填充字节。
//   输出为标准的8-bit AXI-Stream接口，包含 TDATA, TVALID, TREADY, TLAST。
//
// Revision:
//   1.00 - 采用两级流水线结构，解耦“同步检测”和“数据输出”逻辑。
//        - 增加了专门的状态来处理和丢弃填充字节。
//        - 实现了健壮的反压处理机制。
//
//////////////////////////////////////////////////////////////////////////////////

module DeSync(
    input  wire         rst,        // 高有效复位
    input  wire         wr_clk,     // 输入数据时钟
    input  wire         core_clk,   // 时钟

    // 32-bit AXI-Stream Slave Interface (Input)
    input  wire [31:0]  s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    output wire         s_axis_input_tready,

    // 8-bit AXI-Stream Master Interface (Output)
    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    output wire         m_axis_output_tlast,
    input  wire         m_axis_output_tready
);

// ============================================================================
// 参数定义 (Parameters) - 必须与 Sync 模块保持一致
// ============================================================================
    parameter [31:0] SYNC_MARKER   = 32'h1ACFFC1D;
    parameter integer  PAYLOAD_LEN   = 255;
    localparam integer SYNC_LEN      = 4;

    // 自动计算填充字节数，以便正确丢弃它们
    localparam integer PADDING_LEN   = (4 - ((SYNC_LEN + PAYLOAD_LEN) % 4)) % 4;


// ============================================================================
// 阶段一: 同步检测与载荷提取 (Sync Detection & Payload Extraction)
// 职责: 从FIFO中读取字节，搜索同步头，然后门控出有效的载荷字节流
// ============================================================================

    // 内部8-bit字节流接口 (连接阶段一和阶段二)
    wire [7:0]  internal_payload_data;
    wire        internal_payload_valid;
    wire        internal_payload_tlast;
    wire        internal_payload_ready; // 由阶段二提供，用于反压

    // 状态定义
    localparam [1:0] FSM_SEARCH_SYNC  = 2'b00;
    localparam [1:0] FSM_PASS_PAYLOAD = 2'b01;
    localparam [1:0] FSM_DROP_PADDING = 2'b10;

    reg [1:0]  state, n_state;
    reg [31:0] shift_reg; // 用于匹配同步头的移位寄存器
    reg [7:0]  payload_byte_cnt;
    reg [1:0]  padding_byte_cnt;
    wire       sync_match = (shift_reg == SYNC_MARKER);

    // FIFO 接口 (32-bit写入, 8-bit读出)
    wire       fifo_rd_en;
    wire [7:0] fifo_dout;
    wire       fifo_full;
    wire       fifo_empty;

    // 只有当FIFO未满时，才接收上游数据
    assign s_axis_input_tready = !fifo_full;

    fifo_32w_8r fifo_inst (
        .srst       (rst),
        .wr_clk     (wr_clk),
        .rd_clk     (core_clk),
        .din        (s_axis_input_tdata),
        .wr_en      (s_axis_input_tvalid && s_axis_input_tready),
        .full       (fifo_full),
        .wr_rst_busy(),
        .dout       (fifo_dout),
        .rd_en      (fifo_rd_en),
        .empty      (fifo_empty),
        .rd_rst_busy()
    );

    // 状态机 - 时序逻辑
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            state <= FSM_SEARCH_SYNC;
        end else begin
            state <= n_state;
        end
    end

    // 状态机 - 组合逻辑 (状态转移)
    always @(*) begin
        n_state = state;
        case(state)
            FSM_SEARCH_SYNC: begin
                // 找到同步头，且下游准备好接收时，进入下一状态
                if (sync_match && fifo_rd_en) begin
                    n_state = FSM_PASS_PAYLOAD;
                end
            end
            FSM_PASS_PAYLOAD: begin
                // 传输完所有载荷字节后，进入丢弃填充状态
                if (payload_byte_cnt == PAYLOAD_LEN - 1 && fifo_rd_en) begin
                    n_state = (PADDING_LEN > 0) ? FSM_DROP_PADDING : FSM_SEARCH_SYNC;
                end
            end
            FSM_DROP_PADDING: begin
                // 丢弃完所有填充字节后，返回搜索状态
                if (padding_byte_cnt == PADDING_LEN - 1 && fifo_rd_en) begin
                    n_state = FSM_SEARCH_SYNC;
                end
            end
        endcase
    end

    // 控制FIFO读取和移位寄存器更新
    // 只有当本阶段可以处理数据时才读FIFO (下游准备好且FIFO非空)
    assign fifo_rd_en = internal_payload_ready && !fifo_empty;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 32'd0;
            payload_byte_cnt <= 8'd0;
            padding_byte_cnt <= 2'd0;
        end else if (fifo_rd_en) begin // 仅当成功从FIFO读取一个字节时才更新
            shift_reg <= {shift_reg[23:0], fifo_dout};

            case(state)
                FSM_SEARCH_SYNC: begin
                    if (sync_match) begin
                        payload_byte_cnt <= 'd0; // 准备开始计数
                    end
                end
                FSM_PASS_PAYLOAD: begin
                    if (payload_byte_cnt == PAYLOAD_LEN - 1) begin
                        payload_byte_cnt <= 'd0; // 完成后清零
                        padding_byte_cnt <= 'd0; // 准备开始计数
                    end else begin
                        payload_byte_cnt <= payload_byte_cnt + 1;
                    end
                end
                FSM_DROP_PADDING: begin
                    if (padding_byte_cnt == PADDING_LEN - 1) begin
                        padding_byte_cnt <= 'd0; // 完成后清零
                    end else begin
                        padding_byte_cnt <= padding_byte_cnt + 1;
                    end
                end
                default: begin
                    payload_byte_cnt <= 'd0;
                    padding_byte_cnt <= 'd0;
                end
            endcase
        end
    end

    // 生成内部的、纯净的载荷字节流
    assign internal_payload_data  = fifo_dout;
    assign internal_payload_valid = (state == FSM_PASS_PAYLOAD) && !fifo_empty;
    assign internal_payload_tlast = (payload_byte_cnt == PAYLOAD_LEN - 1) && internal_payload_valid;

// ============================================================================
// 阶段二: 输出级 (Output Stage)
// 职责: 将内部纯净的8-bit载荷流注册输出，并处理下游反压
// ============================================================================
    reg [7:0]  m_axis_output_tdata_reg;
    reg        m_axis_output_tvalid_reg;
    reg        m_axis_output_tlast_reg;

    // 反压信号: 这是流水线设计的关键，将下游反压情况反馈给上游
    assign internal_payload_ready = !m_axis_output_tvalid_reg || m_axis_output_tready;

    // 核心输出逻辑
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tvalid_reg <= 1'b0;
            m_axis_output_tdata_reg  <= 8'd0;
            m_axis_output_tlast_reg  <= 1'b0;
        end else begin
            // 当本级输出寄存器空闲时(下游已接收或本就无效)，从上游加载新数据
            if (internal_payload_ready) begin
                m_axis_output_tvalid_reg <= internal_payload_valid;
                m_axis_output_tdata_reg  <= internal_payload_data;
                m_axis_output_tlast_reg  <= internal_payload_tlast;
            end
        end
    end

    // 连接到最终输出端口
    assign m_axis_output_tdata  = m_axis_output_tdata_reg;
    assign m_axis_output_tvalid = m_axis_output_tvalid_reg;
    assign m_axis_output_tlast  = m_axis_output_tlast_reg;

endmodule
