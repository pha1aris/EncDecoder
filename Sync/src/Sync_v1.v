`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: Sync
//
// Description:
//   v2版本 - 发送端同步头添加模块，为高鲁棒性接收端设计。
//   - 上游模块：一个8位的AXI-Stream加扰器。
//   - [增强] 使用64位的伪随机序列(PN)作为同步头。
//   - [增强] 将同步头重复发送3次，以抵抗突发错误。
//   - [自动] 自动计算帧长与填充，以保证输出帧的32-bit对齐。
//
//////////////////////////////////////////////////////////////////////////////////
module Sync (
    input  wire        rst,
    input  wire        core_clk,

    // AXI Stream Input (来自加扰器)
    input  wire [7:0]  s_axis_input_tdata,
    input  wire        s_axis_input_tvalid,
    input  wire        s_axis_input_tlast, // 仍然未使用
    output wire        s_axis_input_tready,

    // AXI Stream Output (送往交织器)
    output reg  [7:0]  m_axis_output_tdata,
    output reg         m_axis_output_tvalid,
    input  wire        m_axis_output_tready
);

    // --- 参数定义 (必须与接收端 Sync_detector_v3_improved.v 严格匹配) ---
    parameter [63:0] SYNC_MARKER         = 64'hB1699558_A53333A8;
    parameter integer  SYNC_REPETITION     = 3;
    localparam integer SYNC_LEN_BYTES      = 8 * SYNC_REPETITION; // 8字节/次 * 3次 = 24字节
    
    parameter integer  PAYLOAD_LEN         = 255;
    
    // [自动] 自动计算需要填充的字节数
    localparam integer TOTAL_LEN_NO_PAD  = SYNC_LEN_BYTES + PAYLOAD_LEN;
    localparam integer PADDING_LEN         = (4 - (TOTAL_LEN_NO_PAD % 4)) % 4;

    // --- 状态机 ---
    localparam IDLE         = 2'b00;
    localparam SEND_SYNC    = 2'b01;
    localparam SEND_DATA    = 2'b10;
    localparam SEND_PADDING = 2'b11;

    reg [1:0] state, next_state;

    // --- FIFO 接口 ---
    wire [7:0] fifo_dout;
    wire       fifo_full;
    wire       fifo_empty;
    wire       fifo_rd_en;
    wire       fifo_can_read = !fifo_empty;
    assign s_axis_input_tready = !fifo_full;

    // FIFO 实例 (用于缓冲上游加扰器的数据)
    fifo_8w_8r input_fifo (
      .rst(rst), .wr_clk(core_clk), .rd_clk(core_clk),
      .din(s_axis_input_tdata), .wr_en(s_axis_input_tvalid && s_axis_input_tready),
      .rd_en(fifo_rd_en), .dout(fifo_dout),
      .full(fifo_full), .empty(fifo_empty)
    );

    // --- 计数器 ---
    reg [4:0] sync_byte_cnt; // 计数范围需要扩大以支持24字节 (0 to 23)
    reg [7:0] data_byte_cnt;
    reg [1:0] pad_byte_cnt;

    // --- 握手与FIFO读使能 ---
    wire m_axis_fire = m_axis_output_tvalid && m_axis_output_tready;
    assign fifo_rd_en = (state == SEND_DATA) && (!m_axis_output_tvalid || m_axis_fire) && fifo_can_read;

    // --- FSM (状态分离设计) ---
    always @(posedge core_clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (fifo_can_read) next_state = SEND_SYNC;
            end
            SEND_SYNC: begin
                if (m_axis_fire && (sync_byte_cnt == SYNC_LEN_BYTES - 1))
                    next_state = SEND_DATA;
            end
            SEND_DATA: begin
                if (m_axis_fire && (data_byte_cnt == PAYLOAD_LEN - 1))
                    next_state = (PADDING_LEN > 0) ? SEND_PADDING : IDLE;
            end
            SEND_PADDING: begin
                if (m_axis_fire && (pad_byte_cnt == PADDING_LEN - 1))
                    next_state = IDLE;
            end
        endcase
    end

    // --- 计数器逻辑 ---
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            sync_byte_cnt <= 0; data_byte_cnt <= 0; pad_byte_cnt <= 0;
        end else begin
            if (state == SEND_SYNC && m_axis_fire)
                sync_byte_cnt <= sync_byte_cnt + 1;
            else if (next_state != SEND_SYNC) // 在状态切换时复位
                sync_byte_cnt <= 0;

            if (state == SEND_DATA && m_axis_fire)
                data_byte_cnt <= data_byte_cnt + 1;
            else if (next_state != SEND_DATA)
                data_byte_cnt <= 0;
            
            if (state == SEND_PADDING && m_axis_fire)
                pad_byte_cnt <= pad_byte_cnt + 1;
            else if (next_state != SEND_PADDING)
                pad_byte_cnt <= 0;
        end
    end

    // --- AXI-Stream 输出逻辑 ---
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tdata  <= 8'd0;
            m_axis_output_tvalid <= 1'b0;
        end else begin
            if (m_axis_fire) begin
                m_axis_output_tvalid <= 1'b0;
            end

            case (state)
                SEND_SYNC: begin
                    if (!m_axis_output_tvalid || m_axis_fire) begin
                        // 根据 sync_byte_cnt 输出重复的64位同步头字节
                        // sync_byte_cnt[2:0] 在 0-7 之间循环3次
                        case (sync_byte_cnt[2:0]) 
                            3'd0: m_axis_output_tdata <= SYNC_MARKER[63:56];
                            3'd1: m_axis_output_tdata <= SYNC_MARKER[55:48];
                            3'd2: m_axis_output_tdata <= SYNC_MARKER[47:40];
                            3'd3: m_axis_output_tdata <= SYNC_MARKER[39:32];
                            3'd4: m_axis_output_tdata <= SYNC_MARKER[31:24];
                            3'd5: m_axis_output_tdata <= SYNC_MARKER[23:16];
                            3'd6: m_axis_output_tdata <= SYNC_MARKER[15:8];
                            default: m_axis_output_tdata <= SYNC_MARKER[7:0];
                        endcase
                        m_axis_output_tvalid <= 1'b1;
                    end
                end
                SEND_DATA: begin
                    if (fifo_rd_en) begin
                        m_axis_output_tdata  <= fifo_dout;
                        m_axis_output_tvalid <= 1'b1;
                    end
                end
                SEND_PADDING: begin
                    if (!m_axis_output_tvalid || m_axis_fire) begin
                        m_axis_output_tdata  <= 8'h00; // 填充0
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
