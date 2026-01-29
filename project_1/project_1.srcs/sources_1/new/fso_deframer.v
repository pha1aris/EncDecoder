`timescale 1ns/1ps
// `include "global_defines.vh" 

module fso_deframer #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256,
    parameter integer FRAMES_PER_BLOCK  = 255 
)(
    input                                 clk,
    input                                 rst_n,
    input                                 i_link_up,

    // ===== 输入 =====
    input        [W-1:0]                  s_axis_tdata,
    input                                 s_axis_tvalid,
    output wire                           s_axis_tready,

    input                                 scrambler_en,

    // ===== 输出 =====
    output reg   [W-1:0]                  m_axis_tdata,
    output reg   [1:0]                    m_axis_tuser,
    output reg                            m_axis_tvalid,
    input                                 m_axis_tready,

    // 反馈/调试
    output reg                            o_realign_req,
    output reg                            o_frame_start,
    output reg   [15:0]                   o_frame_index,
    output reg   [15:0]                   o_block_id,
    output reg   [15:0]                   o_frame_in_block,
    output reg                            o_blk_soft_rst,
    output reg                            o_frame_locked,
    output wire                           o_block_aligned,

    input      [15:0]                     cfg_frame_timeout_max,
    input       [7:0]                     cfg_crc_bad_th,
    input       [7:0]                     cfg_pre_bad_th,
    input                                 cfg_realign_or
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;
    
    localparam [5:0]  PRE_TOLERANCE = 6'd4; 
    localparam [3:0]  MAX_FLYWHEEL_TOLERANCE = 4'd5; 

    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;
    localparam [2:0] S_RECV_CRC         = 3'd5;

    reg [2:0]  state;
    reg [15:0] payload_cnt;
    reg        flywheel_lock;      
    reg [3:0]  flywheel_err_cnt;   

    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;
    wire [FRAME_TIMEOUT_WIDTH-1:0] cfg_frame_timeout_max_trunc = cfg_frame_timeout_max[FRAME_TIMEOUT_WIDTH-1:0];
    wire frame_to_hit = (frame_timeout_cnt == cfg_frame_timeout_max_trunc);

    // ★ 关键：必须记录上一帧的 Frame ID 用于比对
    reg [15:0] last_block_id;
    reg [15:0] last_frame_in_block; 
    reg [15:0] frame_index;

    wire [15:0] rx_block_id       = s_axis_tdata[31:16];
    wire [15:0] rx_frame_in_block = s_axis_tdata[15:0];

    reg         pending_rst;
    reg         block_aligned;
    assign o_block_aligned = block_aligned;

    reg        blk_rigid_active;       
    reg [15:0] blk_rigid_frame_cnt;    

    // ... (Helper Functions & Sub-modules) ...
    function [5:0] calc_dist;
        input [31:0] a, b;
        integer i;
        begin
            calc_dist = 0;
            for(i=0; i<32; i=i+1) calc_dist = calc_dist + (a[i] ^ b[i]);
        end
    endfunction
    wire [5:0] dist_hi = calc_dist(s_axis_tdata, PREAMBLE_HI);
    wire [5:0] dist_lo = calc_dist(s_axis_tdata, PREAMBLE_LO);
    wire match_hi = (dist_hi <= PRE_TOLERANCE);
    wire match_lo = (dist_lo <= PRE_TOLERANCE);

    wire          scram_rst;
    wire          scram_en;
    wire [W-1:0]  scram_din;
    wire [W-1:0]  scram_dout;
    wire fire_in = s_axis_tvalid && s_axis_tready;
    assign scram_rst = (state == S_RECV_HEADER) && fire_in;
    assign scram_en  = (state == S_RECV_PAYLOAD) && fire_in && scrambler_en;
    assign scram_din = s_axis_tdata;
    scrambler de_scrambler( .clk(clk), .rst(!rst_n), .scram_rst(scram_rst), .scram_en(scram_en), .data_in(scram_din), .data_out(scram_dout) );

    wire        crc_en;
    wire        crc_clr;
    wire [31:0] crc_din;
    wire [31:0] crc_dout;
    assign crc_clr = (state == S_RECV_HEADER) && fire_in;
    assign crc_en  = (state == S_RECV_PAYLOAD) && fire_in;
    assign crc_din = scrambler_en ? scram_dout : s_axis_tdata;
    wire   crc_match = (s_axis_tdata == crc_dout);
    crc32 u_crc32( .clk(clk), .rst(!rst_n || crc_clr), .data_in(crc_din), .crc_en(crc_en), .crc_out(crc_dout) );

    // 统计逻辑 (略，保持原样)
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
    
    wire out_stall = m_axis_tvalid && !m_axis_tready;
    assign s_axis_tready = rst_n && i_link_up && !out_stall && ( (state == S_RECV_PAYLOAD) ? m_axis_tready : 1'b1 );

    // Frame Locked 信号
    reg frame_locked_w;
    always @(*) begin
        if (state == S_RECV_HEADER || state == S_RECV_PAYLOAD || state == S_RECV_CRC)
            frame_locked_w = 1'b1;
        else if ((state == S_SEARCH_PREAMBLE1 || state == S_SEARCH_PREAMBLE2) && flywheel_lock)
            frame_locked_w = 1'b1;
        else
            frame_locked_w = 1'b0;
    end
    always @(posedge clk) begin
        if (!rst_n || !i_link_up) o_frame_locked <= 1'b0;
        else o_frame_locked <= frame_locked_w;
    end

    // ============================================================
    // 主状态机
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
            frame_index       <= 16'd0;
            last_block_id     <= 16'd0;
            last_frame_in_block <= 16'd0;
            pending_rst       <= 1'b0;
            block_aligned     <= 1'b0;
            
            // ... (统计变量复位略) ...
            crc_win_cnt <= 'd0; crc_bad_cnt <= 'd0; need_realign <= 1'b0;
            pre_win_cnt <= 'd0; pre_bad_cnt <= 'd0; pre_need_realign <= 1'b0;

            m_axis_tvalid     <= 1'b0;
            m_axis_tdata      <= {W{1'b0}};
            m_axis_tuser      <= 2'b00;

            flywheel_lock     <= 1'b0;
            flywheel_err_cnt  <= 4'd0;
            blk_rigid_active  <= 1'b0;
            blk_rigid_frame_cnt <= 16'd0;
        end else begin
            if (!i_link_up) begin
                state            <= S_WAIT_LINK;
                flywheel_lock    <= 1'b0;
                blk_rigid_active <= 1'b0; 
                block_aligned    <= 1'b0;
            end else begin
                o_realign_req  <= 1'b0;
                o_frame_start  <= 1'b0;
                o_blk_soft_rst <= 1'b0;
                if (m_axis_tvalid && m_axis_tready) m_axis_tvalid <= 1'b0;

                case (state)
                    S_WAIT_LINK: begin
                        payload_cnt       <= 16'd0;
                        frame_timeout_cnt <= 'd0;
                        pending_rst       <= 1'b0;
                        state             <= S_SEARCH_PREAMBLE1;
                        flywheel_lock     <= 1'b0;
                        flywheel_err_cnt  <= 4'd0;
                        blk_rigid_active  <= 1'b0;
                    end

                    // ... S_SEARCH_PREAMBLE1 & 2 (与之前一致，略) ...
                    S_SEARCH_PREAMBLE1: begin
                        if (fire_in) begin
                            if (match_hi || (flywheel_lock && flywheel_err_cnt < MAX_FLYWHEEL_TOLERANCE)) begin
                                state <= S_SEARCH_PREAMBLE2; frame_timeout_cnt <= 'd0;
                            end else frame_timeout_cnt <= 'd0;
                        end else begin
                            if (!s_axis_tvalid) begin
                                if (frame_to_hit) begin
                                    if (realign_cond) begin
                                        o_realign_req <= 1'b1; state <= S_WAIT_LINK;
                                        flywheel_lock <= 1'b0; blk_rigid_active <= 1'b0; 
                                    end
                                    frame_timeout_cnt <= 'd0;
                                end else frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                            end
                        end
                    end

                    S_SEARCH_PREAMBLE2: begin
                        if (fire_in) begin
                            if (match_lo || (flywheel_lock && flywheel_err_cnt < MAX_FLYWHEEL_TOLERANCE)) begin
                                state <= S_RECV_HEADER; frame_timeout_cnt <= 'd0;
                                // 统计逻辑略...
                                if (pre_win_cnt == PRE_WIN-1) begin pre_need_realign<=(pre_bad_cnt>=cfg_pre_bad_th); pre_win_cnt<=0; pre_bad_cnt<=0; end
                                else begin pre_win_cnt<=pre_win_cnt+1; if(!match_lo && !flywheel_lock) pre_bad_cnt<=pre_bad_cnt+1; end
                            end else begin
                                state <= S_SEARCH_PREAMBLE1; frame_timeout_cnt <= 'd0;
                                // 统计逻辑略...
                                if (pre_win_cnt == PRE_WIN-1) begin pre_need_realign<=(pre_bad_cnt+1>=cfg_pre_bad_th); pre_win_cnt<=0; pre_bad_cnt<=0; end
                                else begin pre_win_cnt<=pre_win_cnt+1; pre_bad_cnt<=pre_bad_cnt+1; end
                            end
                        end
                    end

                    S_RECV_HEADER: begin
                        if (fire_in) begin
                            o_block_id       <= rx_block_id;
                            o_frame_in_block <= rx_frame_in_block;
                            o_frame_index    <= frame_index;
                            frame_index      <= frame_index + 1'b1;

                            // ★ 记录：供下一帧检查连续性
                            last_frame_in_block <= rx_frame_in_block;

                            // =====================================================
                            // ★★★ 修复：严进宽出策略 ★★★
                            // =====================================================
                            if (blk_rigid_active) begin
                                // --- 1. 刚性模式 (已锁定) ---
                                // 盲操作，不信外部
                                if (blk_rigid_frame_cnt == 16'd0) 
                                    pending_rst <= 1'b1;
                                else 
                                    pending_rst <= 1'b0;

                                // 计数器维护
                                if (blk_rigid_frame_cnt == FRAMES_PER_BLOCK - 1)
                                    blk_rigid_frame_cnt <= 16'd0;
                                else
                                    blk_rigid_frame_cnt <= blk_rigid_frame_cnt + 1'b1;
                                    
                                block_aligned <= 1'b1;

                            end else begin
                                // --- 2. 搜索模式 (Strict Entry) ---
                                // ★ 关键修改：不再只看 Frame 0。
                                // 必须满足：(上一帧 == 254) 且 (当前帧 == 0)
                                // 这样可以 100% 过滤掉噪声中的伪造 0
                                if (rx_frame_in_block == 16'd0 && last_frame_in_block == (FRAMES_PER_BLOCK - 16'd1)) begin
                                    
                                    // 确信找到了块头，进入刚性模式
                                    blk_rigid_active    <= 1'b1;
                                    blk_rigid_frame_cnt <= 16'd1; // 下一帧期望是 1
                                    
                                    pending_rst         <= 1'b1;  // 本帧产生复位
                                    block_aligned       <= 1'b1;
                                    
                                end else begin
                                    pending_rst         <= 1'b0;
                                    block_aligned       <= 1'b0;
                                end
                            end

                            payload_cnt       <= 16'd0;
                            frame_timeout_cnt <= 'd0;
                            state             <= S_RECV_PAYLOAD;
                        end
                    end

                    S_RECV_PAYLOAD: begin
                        if (fire_in) begin
                            m_axis_tvalid <= 1'b1;
                            m_axis_tdata  <= (scrambler_en) ? scram_dout : s_axis_tdata;
                            
                            m_axis_tuser[1] <= (payload_cnt == 16'd0);
                            m_axis_tuser[0] <= (payload_cnt == 16'd0) && pending_rst;

                            if (payload_cnt == 16'd0) begin
                                o_frame_start <= 1'b1;
                                if (pending_rst) begin
                                    o_blk_soft_rst <= 1'b1;
                                    pending_rst    <= 1'b0;
                                end
                            end
                            
                            if (payload_cnt == PAYLOAD_WORDS - 1) begin
                                payload_cnt <= 16'd0; state <= S_RECV_CRC;
                            end else payload_cnt <= payload_cnt + 1'b1;
                        end
                    end

                    S_RECV_CRC: begin
                        if (fire_in) begin
                            // CRC 统计 (保持原样)
                            if (crc_win_cnt == CRC_WIN-1) begin
                                if ( (!crc_match && (crc_bad_cnt+1 >= cfg_crc_bad_th)) || (crc_match && (crc_bad_cnt >= cfg_crc_bad_th)) )
                                    need_realign <= 1'b1;
                                else need_realign <= 1'b0;
                                crc_win_cnt <= 0; crc_bad_cnt <= 0;
                            end else begin
                                crc_win_cnt <= crc_win_cnt + 1;
                                if (!crc_match) crc_bad_cnt <= crc_bad_cnt + 1;
                            end

                            // ★ 飞轮维护与自动解锁
                            if (crc_match) begin
                                flywheel_lock    <= 1'b1;
                                flywheel_err_cnt <= 4'd0;
                            end else begin
                                if (flywheel_lock) begin
                                    if (flywheel_err_cnt < MAX_FLYWHEEL_TOLERANCE)
                                        flywheel_err_cnt <= flywheel_err_cnt + 1'b1;
                                    else begin
                                        // ★ 关键修改：如果连帧头/CRC都连续错了，说明信号彻底丢了
                                        // 此时必须复位刚性 Block 锁，防止假锁
                                        flywheel_lock    <= 1'b0;
                                        blk_rigid_active <= 1'b0; 
                                        block_aligned    <= 1'b0;
                                    end
                                end
                            end
                            state <= S_SEARCH_PREAMBLE1;
                        end
                    end

                    default: state <= S_WAIT_LINK;
                endcase
            end
        end
    end

endmodule