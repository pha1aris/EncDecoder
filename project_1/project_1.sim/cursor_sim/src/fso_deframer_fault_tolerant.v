`timescale 1ns/1ps
`include "global_defines.vh"

// ============================================================
// 容错帧同步模块 - 适用于激光通信深度衰落场景
// 主要特性：
// 1. 软失锁（Soft Lock Loss）：短时间中断时保持锁定状态，但标记数据无效
// 2. 硬失锁（Hard Lock Loss）：长时间中断时才真正失锁
// 3. 数据有效性标记：在软失锁期间，输出 valid 信号被抑制
// 4. 容忍窗口：可配置的中断容忍时间（基于解交织器恢复能力）
// ============================================================
module fso_deframer_fault_tolerant #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256,
    // 容错参数
    parameter integer SOFT_LOSS_TIMEOUT = 1000,   // 软失锁超时（拍数）：约 6.4us @ 156.25MHz
    parameter integer HARD_LOSS_TIMEOUT = 5000    // 硬失锁超时（拍数）：约 32us @ 156.25MHz
)(
    input                         clk,
    input                         rst_n,

    input                         i_link_up,
    input                         i_bit_locked_soft,  // 来自 bit_aligner 的软锁定状态

    // ===== 输入：来自 rx32 FIFO 的"类AXIS" =====
    input        [W-1:0]          s_axis_tdata,
    input                         s_axis_tvalid,
    output wire                   s_axis_tready,

    input                         scrambler_en,

    // ===== 输出：payload AXIS =====
    output reg   [W-1:0]          m_axis_tdata,
    output reg   [1:0]            m_axis_tuser,
    output reg                    m_axis_tvalid,
    input                         m_axis_tready,

    // 反馈/调试
    output reg                    o_realign_req,
    output reg                    o_frame_start,
    output reg   [15:0]           o_frame_index,
    output reg   [15:0]           o_block_id,
    output reg   [15:0]           o_frame_in_block,
    output reg                    o_blk_soft_rst,
    output reg                    o_frame_locked,        // 硬锁定状态
    output reg                    o_frame_locked_soft,   // 软锁定状态（包括软失锁期间）
    output reg                    o_data_valid,          // 数据有效性标记
    output wire                   o_block_aligned,

    input      [15:0]             cfg_frame_timeout_max,
    input       [7:0]             cfg_crc_bad_th,
    input       [7:0]             cfg_pre_bad_th,
    input                         cfg_realign_or,
    // 容错配置
    input      [19:0]             cfg_soft_loss_to,      // 软失锁超时（可配置）
    input      [19:0]             cfg_hard_loss_to,      // 硬失锁超时（可配置）

    // FER 统计输出
    output reg  [31:0]            o_total_frames,
    output reg  [31:0]            o_crc_error_frames,
    output reg  [31:0]            o_fer_q32
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;
    localparam [2:0] S_RECV_CRC         = 3'd5;

    // 锁定状态定义
    localparam [1:0] LOCK_STATE_HARD_LOCKED = 2'd0;  // 硬锁定（正常）
    localparam [1:0] LOCK_STATE_SOFT_LOSS   = 2'd1;  // 软失锁（容忍窗口内）
    localparam [1:0] LOCK_STATE_HARD_LOSS   = 2'd2;  // 硬失锁（需要重新搜索）

    reg [2:0]  state;
    reg [15:0] payload_cnt;
    reg [1:0]  lock_state;              // 锁定状态机

    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    localparam integer SOFT_LOSS_WIDTH    = $clog2(SOFT_LOSS_TIMEOUT + 1);
    localparam integer HARD_LOSS_WIDTH    = $clog2(HARD_LOSS_TIMEOUT + 1);

    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;
    reg [SOFT_LOSS_WIDTH-1:0]    soft_loss_cnt;    // 软失锁计数器
    reg [HARD_LOSS_WIDTH-1:0]     hard_loss_cnt;    // 硬失锁计数器

    wire [FRAME_TIMEOUT_WIDTH-1:0] cfg_frame_timeout_max_trunc =
        cfg_frame_timeout_max[FRAME_TIMEOUT_WIDTH-1:0];
    wire frame_to_hit = (frame_timeout_cnt == cfg_frame_timeout_max_trunc);

    wire [SOFT_LOSS_WIDTH-1:0] cfg_soft_loss_to_trunc =
        cfg_soft_loss_to[SOFT_LOSS_WIDTH-1:0];
    wire [HARD_LOSS_WIDTH-1:0] cfg_hard_loss_to_trunc =
        cfg_hard_loss_to[HARD_LOSS_WIDTH-1:0];

    // header fields
    reg [15:0] last_block_id;
    reg [15:0] last_frame_in_block;
    reg        block_sync_valid;
    reg [15:0] frame_index;

    wire [15:0] rx_block_id       = s_axis_tdata[31:16];
    wire [15:0] rx_frame_in_block = s_axis_tdata[15:0];

    reg         pending_rst;
    reg         block_aligned;

    assign o_block_aligned = block_aligned;

    // ===== 解扰 =====
    wire          scram_rst;
    wire          scram_en;
    wire [W-1:0]  scram_din;
    wire [W-1:0]  scram_dout;

    wire fire_in = s_axis_tvalid && s_axis_tready;
    assign scram_rst = (state == S_RECV_HEADER) && fire_in;
    assign scram_en  = (state == S_RECV_PAYLOAD) && fire_in && scrambler_en;
    assign scram_din = s_axis_tdata;

    scrambler de_scrambler(
      .clk       (clk),
      .rst       (!rst_n),
      .scram_rst (scram_rst),
      .scram_en  (scram_en),
      .data_in   (scram_din),
      .data_out  (scram_dout)
    );

    // ===== CRC =====
    wire        crc_en;
    wire        crc_clr;
    wire [31:0] crc_din;
    wire [31:0] crc_dout;

    assign crc_clr = (state == S_RECV_HEADER) && fire_in;
    assign crc_en  = (state == S_RECV_PAYLOAD) && fire_in;
    assign crc_din = scrambler_en ? scram_dout : s_axis_tdata;
    wire   crc_match = (s_axis_tdata == crc_dout);

    crc32 u_crc32(
      .clk     (clk),
      .rst     (!rst_n || crc_clr),
      .data_in (crc_din),
      .crc_en  (crc_en),
      .crc_out (crc_dout)
    );

    // ============================================================
    // 锁定状态机（容错版本）
    // ============================================================
    wire data_available = i_link_up && i_bit_locked_soft && s_axis_tvalid;
    wire frame_received = (state == S_RECV_CRC) && fire_in && crc_match;
    wire recovery_from_soft_loss = (lock_state == LOCK_STATE_SOFT_LOSS) && frame_received;

    wire soft_loss_timeout_hit = (soft_loss_cnt >= cfg_soft_loss_to_trunc);
    wire hard_loss_timeout_hit = (hard_loss_cnt >= cfg_hard_loss_to_trunc);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lock_state <= LOCK_STATE_HARD_LOSS;
            o_frame_locked <= 1'b0;
            o_frame_locked_soft <= 1'b0;
            o_data_valid <= 1'b0;
            soft_loss_cnt <= 'd0;
            hard_loss_cnt <= 'd0;
        end else begin
            // 硬复位条件
            if (!i_link_up || !i_bit_locked_soft) begin
                lock_state <= LOCK_STATE_HARD_LOSS;
                o_frame_locked <= 1'b0;
                o_frame_locked_soft <= 1'b0;
                o_data_valid <= 1'b0;
                soft_loss_cnt <= 'd0;
                hard_loss_cnt <= 'd0;
            end else begin
                case (lock_state)
                    LOCK_STATE_HARD_LOCKED: begin
                        if (frame_received) begin
                            // 成功接收帧，保持硬锁定
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                            o_data_valid <= 1'b1;
                        end else if (data_available) begin
                            // 有数据但未完成帧接收，可能进入软失锁
                            if (soft_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_SOFT_LOSS;
                                o_frame_locked_soft <= 1'b1;
                                o_data_valid <= 1'b0;
                                soft_loss_cnt <= 'd0;
                            end else begin
                                soft_loss_cnt <= soft_loss_cnt + 1'b1;
                            end
                        end else begin
                            // 无数据，进入软失锁
                            if (soft_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_SOFT_LOSS;
                                o_frame_locked_soft <= 1'b1;
                                o_data_valid <= 1'b0;
                                soft_loss_cnt <= 'd0;
                            end else begin
                                soft_loss_cnt <= soft_loss_cnt + 1'b1;
                            end
                        end
                    end

                    LOCK_STATE_SOFT_LOSS: begin
                        if (recovery_from_soft_loss) begin
                            // 从软失锁恢复
                            lock_state <= LOCK_STATE_HARD_LOCKED;
                            o_frame_locked <= 1'b1;
                            o_frame_locked_soft <= 1'b1;
                            o_data_valid <= 1'b1;
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                        end else if (data_available) begin
                            // 继续软失锁，检查是否超过硬失锁阈值
                            if (hard_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_HARD_LOSS;
                                o_frame_locked <= 1'b0;
                                o_frame_locked_soft <= 1'b0;
                                o_data_valid <= 1'b0;
                                hard_loss_cnt <= 'd0;
                            end else begin
                                hard_loss_cnt <= hard_loss_cnt + 1'b1;
                            end
                        end else begin
                            // 无数据，继续软失锁
                            if (hard_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_HARD_LOSS;
                                o_frame_locked <= 1'b0;
                                o_frame_locked_soft <= 1'b0;
                                o_data_valid <= 1'b0;
                                hard_loss_cnt <= 'd0;
                            end else begin
                                hard_loss_cnt <= hard_loss_cnt + 1'b1;
                            end
                        end
                    end

                    LOCK_STATE_HARD_LOSS: begin
                        // 硬失锁，需要重新搜索
                        o_frame_locked <= 1'b0;
                        o_frame_locked_soft <= 1'b0;
                        o_data_valid <= 1'b0;
                        soft_loss_cnt <= 'd0;
                        hard_loss_cnt <= 'd0;
                    end

                    default: lock_state <= LOCK_STATE_HARD_LOSS;
                endcase
            end
        end
    end

    // ============================================================
    // 主状态机（简化版，主要逻辑保持不变）
    // ============================================================
    // 注意：这里只展示关键部分，完整实现需要包含原有的所有状态逻辑
    // 主要修改：在软失锁期间，状态机可以继续运行，但数据输出被抑制

    // ... (原有的状态机逻辑，但添加软失锁期间的容错处理) ...

    // 输出数据有效性控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_axis_tvalid <= 1'b0;
            m_axis_tdata <= {W{1'b0}};
            m_axis_tuser <= 2'b00;
        end else begin
            // 只有在硬锁定且数据有效时才输出
            if (o_data_valid && (state == S_RECV_PAYLOAD) && fire_in) begin
                m_axis_tvalid <= 1'b1;
                m_axis_tdata <= scrambler_en ? scram_dout : s_axis_tdata;
                m_axis_tuser[1] <= (payload_cnt == 16'd0);
                m_axis_tuser[0] <= (payload_cnt == 16'd0) && pending_rst;
            end else if (m_axis_tvalid && m_axis_tready) begin
                m_axis_tvalid <= 1'b0;
            end
        end
    end

    // FER 统计（只在硬锁定期间统计）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            total_frames <= 32'd0;
            crc_error_frames <= 32'd0;
            fer_q32 <= 32'd0;
        end else begin
            if (state == S_RECV_CRC && fire_in && o_data_valid) begin
                if (total_frames < 32'hFFFFFFFF) begin
                    total_frames <= total_frames + 1'b1;
                end
                if (!crc_match) begin
                    if (crc_error_frames < 32'hFFFFFFFF) begin
                        crc_error_frames <= crc_error_frames + 1'b1;
                    end
                end
                if (total_frames > 0) begin
                    o_fer_q32 <= (crc_error_frames << 32) / total_frames;
                end else begin
                    o_fer_q32 <= 32'h0;
                end
            end
        end
    end

    // ... (其他原有逻辑) ...

endmodule
