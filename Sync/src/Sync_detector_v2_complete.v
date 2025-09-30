`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: Sync_detector_v2_complete
//
// Description:
//   v2版本 - 高容错同步检测器 (完整实现版)
//   - 补全了汉明距离计算和多数投票逻辑。
//   - 补全了 S_PRESUMED_LOCK "飞轮"状态机的完整逻辑。
//   - 补全了FIFO例化和标准的AXI-Stream输出握手逻辑。
//
//////////////////////////////////////////////////////////////////////////////////
module Sync_detector_v2_complete(
    input  wire        rst,
    input  wire        core_clk,
    input  wire [31:0] data_i,
    input  wire        data_valid_i,

    // 新增! 用于复位下游解交织器
    output reg         start_of_frame_o, 

    // 标准AXI-Stream输出
    output wire [7:0]  m_axis_output_tdata,
    output wire        m_axis_output_tvalid,
    output wire        m_axis_output_tlast,
    input  wire        m_axis_output_tready
);

    // --- 参数定义 (必须与发送端 Sync_v2.v 严格匹配) ---
    parameter [63:0] SYNC_MARKER         = 64'hB1699558_A53333A8;
    parameter integer  SYNC_REPETITION     = 3;
    localparam integer SYNC_LEN_BYTES      = 8 * SYNC_REPETITION;
    parameter integer  PAYLOAD_LEN         = 255;
    localparam integer PADDING_LEN         = (4 - ((SYNC_LEN_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam integer PAYLOAD_TOTAL_LEN   = PAYLOAD_LEN + PADDING_LEN;

    // 容错参数
    parameter integer  ERROR_THRESHOLD     = 10; // 单个64位同步头的汉明距离容错阈值
    parameter integer  VOTE_THRESHOLD      = 2;  // 3个拷贝中至少需要2个匹配
    parameter integer  PRESUMED_LOCK_LIMIT = 5;  // 飞轮状态最多维持5帧

    // --- FSM 状态定义 ---
    localparam S_SEARCH          = 3'd0;
    localparam S_PASS            = 3'd1;
    localparam S_PRESUMED_LOCK   = 3'd2;

    // --- 内部信号 ---
    reg [2:0]  state;
    reg [SYNC_LEN_BYTES*8-1:0] shift_reg;
    reg [8:0]  byte_cnt; // 计数器需要能计到 PAYLOAD_TOTAL_LEN
    reg [3:0]  presumed_lock_cnt;

    // --- FIFO ---
    wire [7:0] fifo_dout_8b;
    wire       fifo_empty;
    wire       fifo_rd_en;
    wire       fifo_can_read = !fifo_empty;
    
    // [补全] FIFO例化与连接
    fifo_32w_8r fifo_inst (
        .srst         (rst),
        .wr_clk       (core_clk),
        .rd_clk       (core_clk),
        .din          (data_i),
        .wr_en        (data_valid_i),
        .dout         (fifo_dout_8b),
        .rd_en        (fifo_rd_en),
        .empty        (fifo_empty),
        .full         (), // full 信号在此处未使用
        .wr_rst_busy  (),
        .rd_rst_busy  ()
    );

    // --- AXI-Stream 输出寄存器 ---
    reg [7:0]  m_axis_output_tdata_reg;
    reg        m_axis_output_tvalid_reg;
    reg        m_axis_output_tlast_reg;
    assign m_axis_output_tdata = m_axis_output_tdata_reg;
    assign m_axis_output_tvalid = m_axis_output_tvalid_reg;
    assign m_axis_output_tlast = m_axis_output_tlast_reg;
    
    // --- [补全] 汉明距离计算与多数投票 ---
    wire [2:0] match_votes;
    wire       sync_match;

    // 使用 generate 循环并行处理3个同步头拷贝
    genvar i;
    generate
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin : SYNC_CHECK_LOOP
            wire [63:0] received_sync_word = shift_reg[(i+1)*64-1 -: 64];
            wire [63:0] diff = received_sync_word ^ SYNC_MARKER;
            
            // 使用 $countones 系统函数计算汉明距离 (综合工具会将其优化为加法树)
            wire [6:0] hamming_distance = $countones(diff);

            assign match_votes[i] = (hamming_distance <= ERROR_THRESHOLD);
        end
    endgenerate

    // 多数投票逻辑
    assign sync_match = ($countones(match_votes) >= VOTE_THRESHOLD);
    
    // --- 主状态机与数据处理逻辑 ---
    // FIFO读使能: 只要下游准备好接收或当前未在发送，就从FIFO读数据以填充移位寄存器
    assign fifo_rd_en = fifo_can_read && (!m_axis_output_tvalid_reg || m_axis_output_tready);

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            state <= S_SEARCH;
            start_of_frame_o <= 1'b0;
            m_axis_output_tvalid_reg <= 1'b0;
            shift_reg <= 0;
            byte_cnt <= 0;
            presumed_lock_cnt <= 0;
        end else begin
            start_of_frame_o <= 1'b0; // 脉冲信号，默认拉低
            if (m_axis_output_tvalid_reg && m_axis_output_tready) begin
                m_axis_output_tvalid_reg <= 1'b0; // 握手成功后拉低
            end
            
            // 移位寄存器持续更新
            if (fifo_rd_en) begin
                shift_reg <= {shift_reg[SYNC_LEN_BYTES*8-9:0], fifo_dout_8b};
            end

            case(state)
                S_SEARCH: begin
                    if (sync_match && fifo_rd_en) begin
                        state <= S_PASS;
                        start_of_frame_o <= 1'b1; // 找到帧头,发出对齐脉冲!
                        byte_cnt <= 0;
                        presumed_lock_cnt <= 0;
                    end
                end
                
                S_PASS: begin
                    if (fifo_rd_en && (!m_axis_output_tvalid_reg || m_axis_output_tready)) begin
                        // 输出数据
                        m_axis_output_tdata_reg <= fifo_dout_8b;
                        m_axis_output_tvalid_reg <= 1'b1;
                        m_axis_output_tlast_reg <= (byte_cnt == PAYLOAD_TOTAL_LEN - 1);
                        
                        if (byte_cnt == PAYLOAD_TOTAL_LEN - 1) begin // 当前是最后一个字节
                            byte_cnt <= 0; // 字节计数器复位
                            if (sync_match) begin // 成功重捕，保持在S_PASS
                                start_of_frame_o <= 1'b1;
                            end else begin // 未能重捕，进入飞轮状态
                                state <= S_PRESUMED_LOCK;
                                start_of_frame_o <= 1'b1; // 按预期位置发出脉冲
                                presumed_lock_cnt <= 1;
                            end
                        end else begin
                            byte_cnt <= byte_cnt + 1;
                        end
                    end
                end
                
                // [补全] 飞轮状态逻辑
                S_PRESUMED_LOCK: begin
                    if (fifo_rd_en && (!m_axis_output_tvalid_reg || m_axis_output_tready)) begin
                        // 逻辑与 S_PASS 几乎相同，继续输出数据
                        m_axis_output_tdata_reg <= fifo_dout_8b;
                        m_axis_output_tvalid_reg <= 1'b1;
                        m_axis_output_tlast_reg <= (byte_cnt == PAYLOAD_TOTAL_LEN - 1);
                        
                        if (byte_cnt == PAYLOAD_TOTAL_LEN - 1) begin
                            byte_cnt <= 0;
                            if (sync_match) begin // 成功重捕，返回S_PASS
                                state <= S_PASS;
                                start_of_frame_o <= 1'b1;
                                presumed_lock_cnt <= 0;
                            end else begin // 仍然没找到
                                start_of_frame_o <= 1'b1; // 继续按预期位置发出脉冲
                                if (presumed_lock_cnt >= PRESUMED_LOCK_LIMIT - 1) begin // 超出飞轮极限
                                    state <= S_SEARCH; // 彻底失锁，返回搜索
                                else begin // 继续飞轮
                                    presumed_lock_cnt <= presumed_lock_cnt + 1;
                                end
                            end
                        end else begin
                            byte_cnt <= byte_cnt + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule

