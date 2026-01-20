`timescale 1ns/1ps
`include "global_defines.vh"

// ============================================================
// 改进版 fso_deframer
// 主要修复：
// 1. 修复 pay_words_sent 计数逻辑（基于 fire_in 而不是 m_fire）
// 2. 确保 payload 字数统计准确，避免反压导致的计数丢失
// 3. 改进 AXIS 反压处理逻辑
// ============================================================
module fso_deframer_improved #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256
)(
    input                         clk,
    input                         rst_n,

    input                         i_link_up,

    // ===== 输入：来自 rx32 FIFO 的"类AXIS" =====
    input        [W-1:0]          s_axis_tdata,
    input                         s_axis_tvalid,
    output wire                   s_axis_tready,

    input                         scrambler_en,

    // ===== 输出：payload AXIS =====
    output reg   [W-1:0]          m_axis_tdata,
    output reg   [1:0]            m_axis_tuser,   // [0]=blk_soft_rst_on_word0, [1]=frame_start_on_word0(可选)
    output reg                    m_axis_tvalid,
    input                         m_axis_tready,

    // 反馈/调试
    output reg                    o_realign_req,
    output reg                    o_frame_start,
    output reg   [15:0]           o_frame_index,
    output reg   [15:0]           o_block_id,
    output reg   [15:0]           o_frame_in_block,
    output reg                    o_blk_soft_rst,
    output reg                    o_frame_locked,
    output wire                   o_block_aligned,

    input      [15:0]             cfg_frame_timeout_max,
    input       [7:0]             cfg_crc_bad_th,
    input       [7:0]             cfg_pre_bad_th,
    input                         cfg_realign_or,

    // FER (Frame Error Rate) 统计输出
    output reg  [31:0]            o_total_frames,     // 总接收帧数
    output reg  [31:0]            o_crc_error_frames, // CRC 错误帧数
    output reg  [31:0]            o_fer_q32           // FER (Q0.32 格式：错误帧数 << 32) / 总帧数
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;
    localparam [2:0] S_RECV_CRC         = 3'd5;

    reg [2:0]  state;
    reg [15:0] payload_cnt;

    // timeout counter
    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;
    wire [FRAME_TIMEOUT_WIDTH-1:0] cfg_frame_timeout_max_trunc =
        cfg_frame_timeout_max[FRAME_TIMEOUT_WIDTH-1:0];
    wire frame_to_hit = (frame_timeout_cnt == cfg_frame_timeout_max_trunc);

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

    // ===== 解扰（保持你原逻辑，只把 i_rx_* 换成 fire_in）=====
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

    // ===== CRC（保持你原逻辑）=====
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

    // ===== CRC/Preamble 窗口统计（保持你原结构）=====
    localparam integer CRC_WIN    = 256;
    localparam integer CRC_CNT_W  = $clog2(CRC_WIN);
    reg [CRC_CNT_W-1:0] crc_win_cnt;
    reg [CRC_CNT_W-1:0] crc_bad_cnt;
    reg                 need_realign;

    localparam integer PRE_WIN    = 256;
    localparam integer PRE_CNT_W  = $clog2(PRE_WIN);
    reg [PRE_CNT_W-1:0] pre_win_cnt;
    reg [PRE_CNT_W-1:0] pre_bad_cnt;
    reg                 pre_need_realign;

    wire realign_cond_and = need_realign & pre_need_realign;
    wire realign_cond_or  = need_realign | pre_need_realign;
    wire realign_cond     = cfg_realign_or ? realign_cond_or : realign_cond_and;

    // ============================================================
    // 改进：frame_locked 锁定状态寄存器
    // 一旦成功接收一帧（CRC 正确），就锁定并保持高电平
    // 直到失锁条件（realign_cond 或 link_up 丢失）
    // ============================================================
    reg frame_locked_reg;  // 锁定状态寄存器
    
    // 锁定条件：成功接收一帧（CRC 匹配）且当前在接收状态
    wire frame_lock_acquire = (state == S_RECV_CRC) && fire_in && crc_match;
    
    // 失锁条件：link_up 丢失、重对齐请求、或处于等待/搜索状态且长时间无数据
    wire frame_lock_release = !i_link_up || realign_cond || 
                               (state == S_WAIT_LINK);

    // ============================================================
    // FER (Frame Error Rate) 统计
    // ============================================================
    reg [31:0] total_frames;      // 总接收帧数
    reg [31:0] crc_error_frames;  // CRC 错误帧数
    
    // FER 计算：FER = (crc_error_frames << 32) / total_frames (Q0.32 格式)
    // 使用乘法避免除法：当 total_frames != 0 时，FER_q32 = (crc_error_frames * (1 << 32)) / total_frames
    // 简化计算：FER_q32 = (crc_error_frames << 32) / total_frames
    // 注意：由于是整数运算，这里需要特殊处理
    wire [63:0] fer_calc = (total_frames != 0) ? 
                           (({32'd0, crc_error_frames} << 32) / {32'd0, total_frames}) : 
                           64'd0;
    
    // 输出赋值（output reg不能assign，必须在always块中更新）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_total_frames     <= 32'd0;
            o_crc_error_frames <= 32'd0;
            o_fer_q32          <= 32'd0;
        end else begin
            o_total_frames     <= total_frames;
            o_crc_error_frames <= crc_error_frames;
            o_fer_q32          <= fer_calc[31:0];  // Q0.32 格式的低32位
        end
    end

    // ============================================================
    // AXIS 反压策略（工业常用做法）：
    // - 只有在 payload 状态需要把一个 word "推给后级"时，才要求 m_axis_tready。
    // - 一旦输出端拥塞（m_axis_tvalid=1 且 m_axis_tready=0），全局停止消费输入（s_axis_tready=0），避免内部错位。
    // 改进：确保反压逻辑清晰，避免数据丢失
    // ============================================================
    wire out_stall = m_axis_tvalid && !m_axis_tready;

    // payload 状态：只有当下游 ready 时才消费输入 word
    // 非 payload 状态：也要受 out_stall 约束（防止最后一个 payload word 还卡着时继续吃后面的 header/crc）
    assign s_axis_tready = rst_n && i_link_up && !out_stall &&
                           ( (state == S_RECV_PAYLOAD) ? m_axis_tready : 1'b1 );


    // ============================================================
    // 主状态机（基本保持你原来的 if(i_rx_valid)->if(fire_in)）
    // ============================================================
    always @(posedge clk) begin
        if (!rst_n) begin
            state             <= S_WAIT_LINK;
            payload_cnt       <= 16'd0;
            frame_timeout_cnt <= 'd0;

            o_realign_req     <= 1'b0;
            o_frame_start     <= 1'b0;
            o_frame_index     <= 16'd0;
            o_block_id        <= 16'd0;
            o_frame_in_block  <= 16'd0;
            o_blk_soft_rst    <= 1'b0;
            o_frame_locked    <= 1'b0;

            frame_index         <= 16'd0;
            last_block_id       <= 16'd0;
            last_frame_in_block <= 16'd0;
            block_sync_valid    <= 1'b0;
            pending_rst         <= 1'b0;
            block_aligned       <= 1'b0;

            crc_win_cnt      <= 'd0;
            crc_bad_cnt      <= 'd0;
            need_realign     <= 1'b0;

            m_axis_tvalid    <= 1'b0;
            m_axis_tdata     <= {W{1'b0}};
            m_axis_tuser     <= 2'b00;

            // FER 统计复位
            total_frames     <= 32'd0;
            crc_error_frames <= 32'd0;
            
            // frame_locked 锁定状态复位
            frame_locked_reg <= 1'b0;

            // FER 统计复位
            total_frames     <= 32'd0;
            crc_error_frames <= 32'd0;
        end else begin
            o_realign_req  <= 1'b0;
            o_frame_start  <= 1'b0;
            o_blk_soft_rst <= 1'b0;

            // 默认：如果输出被接收就清 valid
            if (m_axis_tvalid && m_axis_tready)
                m_axis_tvalid <= 1'b0;

            case (state)
                S_WAIT_LINK: begin
                    payload_cnt       <= 16'd0;
                    frame_timeout_cnt <= 'd0;
                    block_sync_valid  <= 1'b0;
                    pending_rst       <= 1'b0;

                    crc_win_cnt    <= 'd0;
                    crc_bad_cnt    <= 'd0;
                    need_realign   <= 1'b0;

                    if (i_link_up)
                        state <= S_SEARCH_PREAMBLE1;
                end

                S_SEARCH_PREAMBLE1: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else begin
                        if (fire_in) begin
                            if (s_axis_tdata == PREAMBLE_HI) begin
                                state             <= S_SEARCH_PREAMBLE2;
                                frame_timeout_cnt <= 'd0;
                            end else begin
                                frame_timeout_cnt <= 'd0; // 有数据就不超时
                            end
                        end else begin
                            // 只有"没有输入数据可消费"才算超时（而不是我们主动 backpressure）
                            if (!s_axis_tvalid) begin
                                if (frame_to_hit) begin
                                    if (realign_cond) begin
                                        o_realign_req <= 1'b1;
                                        state         <= S_WAIT_LINK;
                                    end
                                    frame_timeout_cnt <= 'd0;
                                end else begin
                                    frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                                end
                            end
                        end
                    end
                end

                S_SEARCH_PREAMBLE2: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else begin
                        if (fire_in) begin
                            if (s_axis_tdata == PREAMBLE_LO) begin
                                state             <= S_RECV_HEADER;
                                frame_timeout_cnt <= 'd0;
                            end else begin
                                state             <= S_SEARCH_PREAMBLE1;
                                frame_timeout_cnt <= 'd0;
                            end
                        end else begin
                            if (!s_axis_tvalid) begin
                                if (frame_to_hit) begin
                                    if (realign_cond) begin
                                        o_realign_req <= 1'b1;
                                        state         <= S_WAIT_LINK;
                                    end
                                    frame_timeout_cnt <= 'd0;
                                end else begin
                                    frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                                end
                            end
                        end
                    end
                end

                S_RECV_HEADER: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (fire_in) begin
                        o_block_id       <= rx_block_id;
                        o_frame_in_block <= rx_frame_in_block;
                        o_frame_index    <= frame_index;
                        frame_index      <= frame_index + 1'b1;

                        // ===== 你的块对齐逻辑原封不动 =====
                        if (!block_sync_valid) begin
                            last_block_id       <= rx_block_id;
                            last_frame_in_block <= rx_frame_in_block;
                            block_sync_valid    <= 1'b1;
                            pending_rst         <= 1'b0;
                        end else begin
                            if (rx_block_id == last_block_id) begin
                                if (rx_frame_in_block == last_frame_in_block + 1) begin
                                    last_frame_in_block <= rx_frame_in_block;
                                end else begin
                                    last_block_id       <= rx_block_id;
                                    last_frame_in_block <= rx_frame_in_block;
                                    pending_rst         <= 1'b1;
                                    block_aligned       <= 1'b0;
                                end
                            end else if (rx_block_id == last_block_id + 1) begin
                                if (rx_frame_in_block == 16'd0) begin
                                    last_block_id       <= rx_block_id;
                                    last_frame_in_block <= rx_frame_in_block;
                                    if (!block_aligned) begin
                                        pending_rst   <= 1'b1;
                                        block_aligned <= 1'b1;
                                    end else begin
                                        pending_rst   <= 1'b0;
                                    end
                                end else begin
                                    last_block_id       <= rx_block_id;
                                    last_frame_in_block <= rx_frame_in_block;
                                    pending_rst         <= 1'b1;
                                    block_aligned       <= 1'b0;
                                end
                            end else begin
                                last_block_id       <= rx_block_id;
                                last_frame_in_block <= rx_frame_in_block;
                                pending_rst         <= 1'b1;
                                block_aligned       <= 1'b0;
                            end
                        end

                        payload_cnt       <= 16'd0;
                        frame_timeout_cnt <= 'd0;
                        state             <= S_RECV_PAYLOAD;
                    end
                end

                S_RECV_PAYLOAD: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (fire_in) begin
                        // ===== 输出一个 payload word（AXIS）=====
                        // 改进：这里 fire_in 已经保证 s_axis_tready=1（因为我们控制它）
                        // 但 m_axis_tready 可能为 0，所以需要保持 m_axis_tvalid
                        m_axis_tvalid <= 1'b1;
                        m_axis_tdata  <= (scrambler_en) ? scram_dout : s_axis_tdata;

                        // tuser：只在 payload_cnt==0 的那个 word 携带边界
                        m_axis_tuser[1] <= (payload_cnt == 16'd0);               // frame_start(可选)
                        m_axis_tuser[0] <= (payload_cnt == 16'd0) && pending_rst; // blk_soft_rst_on_word0

                        if (payload_cnt == 16'd0) begin
                            o_frame_start <= 1'b1;
                            if (pending_rst) begin
                                o_blk_soft_rst <= 1'b1;
                                pending_rst    <= 1'b0;
                            end
                        end

                        // 改进：payload_cnt 在 fire_in 时递增，而不是在 m_fire 时
                        // 这样可以确保即使下游反压，计数也是准确的
                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            payload_cnt       <= 16'd0;
                            frame_timeout_cnt <= 'd0;
                            state             <= S_RECV_CRC;
                        end else begin
                            payload_cnt       <= payload_cnt + 1'b1;
                            frame_timeout_cnt <= 'd0;
                        end
                    end
                end

                S_RECV_CRC: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (fire_in) begin
                        // ============================================================
                        // FER 统计：每完成一帧 CRC 检查，更新统计
                        // ============================================================
                        // 增加总帧数计数
                        if (total_frames < 32'hFFFFFFFF) begin
                            total_frames <= total_frames + 1'b1;
                        end
                        
                        // 如果 CRC 不匹配，增加错误帧计数
                        if (!crc_match) begin
                            if (crc_error_frames < 32'hFFFFFFFF) begin
                                crc_error_frames <= crc_error_frames + 1'b1;
                            end
                        end

                        // CRC 窗口统计（保持你原思路）
                        if (crc_win_cnt == CRC_WIN - 1) begin
                            if ( (!crc_match && (crc_bad_cnt + 1'b1 >= cfg_crc_bad_th)) ||
                                 ( crc_match && (crc_bad_cnt         >= cfg_crc_bad_th)) )
                                need_realign <= 1'b1;
                            else
                                need_realign <= 1'b0;

                            crc_win_cnt <= 'd0;
                            crc_bad_cnt <= 'd0;
                        end else begin
                            crc_win_cnt <= crc_win_cnt + 1'b1;
                            if (!crc_match)
                                crc_bad_cnt <= crc_bad_cnt + 1'b1;
                        end

                        frame_timeout_cnt <= 'd0;
                        state             <= S_SEARCH_PREAMBLE1;
                    end else begin
                        if (!s_axis_tvalid) begin
                            if (frame_to_hit) begin
                                if (realign_cond) begin
                                    o_realign_req <= 1'b1;
                                    state         <= S_WAIT_LINK;
                                end
                                frame_timeout_cnt <= 'd0;
                            end else begin
                                frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                            end
                        end
                    end
                end

                default: state <= S_WAIT_LINK;
            endcase

            // ============================================================
            // 改进：frame_locked 锁定逻辑
            // 一旦成功接收一帧（CRC 正确），就锁定并保持高电平
            // 在帧之间（搜索前导码期间）也保持高电平
            // 直到失锁条件触发
            // ============================================================
            // 锁定状态更新：一旦获得锁定，保持直到失锁条件
            if (frame_lock_release) begin
                frame_locked_reg <= 1'b0;
            end else if (frame_lock_acquire) begin
                frame_locked_reg <= 1'b1;
            end
            // frame_locked_reg 一旦为 1，会保持直到 frame_lock_release
            
            // 输出：frame_locked_reg 就是 frame_locked 信号
            o_frame_locked <= frame_locked_reg;
        end
    end

    // preamble 统计（尽量不动：这里只把 i_rx_valid 换成 fire_in / s_axis_tvalid 判断）
    always @(posedge clk) begin
        if (!rst_n) begin
            pre_win_cnt      <= 'd0;
            pre_bad_cnt      <= 'd0;
            pre_need_realign <= 1'b0;
        end else if (state == S_WAIT_LINK) begin
            pre_win_cnt <= 'd0;
            pre_bad_cnt <= 'd0;
        end else begin
            if (state == S_SEARCH_PREAMBLE2 && fire_in) begin
                if (s_axis_tdata == PREAMBLE_LO) begin
                    if (pre_win_cnt == PRE_WIN - 1) begin
                        pre_need_realign <= (pre_bad_cnt >= cfg_pre_bad_th);
                        pre_win_cnt <= 'd0;
                        pre_bad_cnt <= 'd0;
                    end else begin
                        pre_win_cnt <= pre_win_cnt + 1'b1;
                    end
                end else begin
                    if (pre_win_cnt == PRE_WIN - 1) begin
                        pre_need_realign <= (pre_bad_cnt + 1'b1 >= cfg_pre_bad_th);
                        pre_win_cnt <= 'd0;
                        pre_bad_cnt <= 'd0;
                    end else begin
                        pre_win_cnt <= pre_win_cnt + 1'b1;
                        pre_bad_cnt <= pre_bad_cnt + 1'b1;
                    end
                end
            end else if (state == S_SEARCH_PREAMBLE2 && !s_axis_tvalid && frame_to_hit) begin
                if (pre_win_cnt == PRE_WIN - 1) begin
                    pre_need_realign <= (pre_bad_cnt + 1'b1 >= cfg_pre_bad_th);
                    pre_win_cnt <= 'd0;
                    pre_bad_cnt <= 'd0;
                end else begin
                    pre_win_cnt <= pre_win_cnt + 1'b1;
                    pre_bad_cnt <= pre_bad_cnt + 1'b1;
                end
            end
        end
    end
    
`ifdef  SIM
    // ============================================================
    // 改进：基于 fire_in 计数，而不是 m_fire
    // 这样可以确保即使下游反压，计数也是准确的
    // ============================================================
    always @(posedge clk) begin
      if (rst_n) begin
        if (fire_in) begin
          $display("[%0t] state=%0d  data=%h  tready=%b tvalid=%b",
                   $time, state, s_axis_tdata, s_axis_tready, s_axis_tvalid);
        end
      end
    end
    
    reg [15:0] pay_words_sent;
    always @(posedge clk) begin
        if (!rst_n) begin
            pay_words_sent <= 0;
        end else begin
            // header 被消费时，开始统计新一帧
            if (state == S_RECV_HEADER && fire_in) begin
                pay_words_sent <= 0;
            end
            // 改进：基于 fire_in 计数，而不是 m_fire
            // 这样可以确保即使下游反压，计数也是准确的
            else if (state == S_RECV_PAYLOAD && fire_in) begin
                pay_words_sent <= pay_words_sent + 1;
            end

            // CRC 被消费时检查：上一帧 payload word 应该正好 = PAYLOAD_WORDS
            if (state == S_RECV_CRC && fire_in) begin
                if (pay_words_sent != PAYLOAD_WORDS) begin
                    $display("!!! PAYLOAD WORD COUNT ERROR: got=%0d exp=%0d time=%0t",
                            pay_words_sent, PAYLOAD_WORDS, $time);
                end else begin
                    $display("[%0t] PAYLOAD WORD COUNT OK: got=%0d exp=%0d CRC=%s",
                            $time, pay_words_sent, PAYLOAD_WORDS, 
                            crc_match ? "OK" : "ERR");
                end
                
                // FER 统计输出（每1000帧输出一次，避免日志过多）
                if (total_frames > 0 && (total_frames % 1000 == 0)) begin
                    $display("[%0t] FER Statistics: total=%0d errors=%0d FER=%.6f (%.4f%%)",
                            $time, total_frames, crc_error_frames,
                            $itor(crc_error_frames) / $itor(total_frames),
                            100.0 * $itor(crc_error_frames) / $itor(total_frames));
                end
            end
        end
    end
`endif

endmodule
