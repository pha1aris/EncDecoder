`timescale 1ns / 1ps

module fso_deframer_ind #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256 
)(
    input                         clk,
    input                         rst_n,

    input                         i_link_up,
    input        [W-1:0]          i_rx_data,
    input                         i_rx_valid,

    input                         scrambler_en,  //扰码使能
    output reg                    o_realign_req,
    output reg                    o_frame_start,    
    output reg   [15:0]           o_frame_index,
    output reg   [15:0]           o_block_id,
    output reg   [15:0]           o_frame_in_block,
    
    output reg                    o_blk_soft_rst,   
    output reg                    o_frame_locked,   // ★ 新增：帧级锁定标志

    output reg   [W-1:0]          o_payload_data,
    output reg                    o_payload_valid

    // CRC 标志监控：
    // ,output reg                  o_crc_ok
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;
    localparam [2:0] S_RECV_CRC         = 3'd5;   // 接收 CRC32

    reg [2:0]  state;
    reg [15:0] payload_cnt; 
    
    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;

    reg [15:0] last_block_id;
    reg [15:0] last_frame_in_block;
    reg        block_sync_valid;     
    reg [15:0] frame_index;          

    wire [15:0] rx_block_id       = i_rx_data[31:16];
    wire [15:0] rx_frame_in_block = i_rx_data[15:0];

    reg         pending_rst;          // 暂存复位请求
    reg         block_aligned;        // 已经对齐过块标志

    // CRC 接收端比较结果（内部用）
    reg         crc_ok;
    reg [31:0]  crc_rx_word;

    //================================================================
    // 解扰部分
    //================================================================
    wire          scram_rst;
    wire          scram_en;
    wire [W-1:0]  scram_din;
    wire [W-1:0]  scram_dout;

    assign scram_rst = (state == S_RECV_HEADER) && i_rx_valid;  // 每帧起始复位扰码器
    assign scram_en  = (state == S_RECV_PAYLOAD) && i_rx_valid && scrambler_en;
    assign scram_din = i_rx_data;

    scrambler de_scrambler(
      .clk       (clk),
      .rst       (!rst_n),
      .scram_rst (scram_rst),
      .scram_en  (scram_en),
      .data_in   (scram_din),
      .data_out  (scram_dout) 
    );

    //================================================================
    // CRC32 部分：对 “解扰后的 payload”做 CRC
    //================================================================
    wire        crc_en;
    wire        crc_clr;
    wire [31:0] crc_din;
    wire [31:0] crc_dout;

    assign crc_clr = (state == S_RECV_HEADER) && i_rx_valid;
    assign crc_en  = (state == S_RECV_PAYLOAD) && i_rx_valid;
    assign crc_din = scrambler_en ? scram_dout : i_rx_data;
    wire   crc_match = (i_rx_data == crc_dout);

    crc32 u_crc32(
      .clk     (clk),
      .rst     (!rst_n || crc_clr),  // 异步复位：全局或者“帧起始”
      .data_in (crc_din),
      .crc_en  (crc_en),
      .crc_out (crc_dout)
    );

    //================================================================
    // CRC 窗口统计
    //================================================================
    localparam integer CRC_WIN    = 256;   // 统计 256 帧
    localparam integer CRC_BAD_TH = 64;    // 坏帧数超过 64 就认为 CRC 很差
    localparam integer CRC_CNT_W  = $clog2(CRC_WIN + 1);

    reg [CRC_CNT_W-1:0] crc_win_cnt;   // 窗口内总帧数计数
    reg [CRC_CNT_W-1:0] crc_bad_cnt;   // 窗口内 CRC 错帧数
    reg                 need_realign;  // 由 CRC 统计得出的“建议重对齐”标志

    //================================================================
    // 前导命中率统计
    //================================================================
    localparam integer PRE_WIN    = 256;   // 统计 256 次“前导尝试”
    localparam integer PRE_BAD_TH = 64;    // 坏的/缺失的前导超过 64 次认为前导很差
    localparam integer PRE_CNT_W  = $clog2(PRE_WIN + 1);

    reg [PRE_CNT_W-1:0] pre_win_cnt;      // 前导尝试次数
    reg [PRE_CNT_W-1:0] pre_bad_cnt;      // 前导失败/超时次数
    reg                 pre_need_realign; // 由前导统计得出的“建议重对齐”标志

    wire realign_cond = need_realign & pre_need_realign;
    // wire realign_cond = need_realign | pre_need_realign; // 更激进一点也可以

    //================================================================
    // 主状态机
    //================================================================
    always @(posedge clk) begin
        if (!rst_n) begin
            state               <= S_WAIT_LINK;
            frame_index         <= 16'd0;
            payload_cnt         <= 16'd0;
            o_payload_data      <= {W{1'b0}};
            o_payload_valid     <= 1'b0;
            o_frame_start       <= 1'b0;
            o_frame_index       <= 16'd0;
            frame_timeout_cnt   <= {FRAME_TIMEOUT_WIDTH{1'b0}};
            o_realign_req       <= 1'b0;
            last_block_id       <= 16'd0;
            last_frame_in_block <= 16'd0;
            block_sync_valid    <= 1'b0;
            o_block_id          <= 16'd0;
            o_frame_in_block    <= 16'd0;
            o_blk_soft_rst      <= 1'b0;

            pending_rst         <= 1'b0;
            block_aligned       <= 1'b0;
            crc_ok              <= 1'b0;
            crc_rx_word         <= 32'd0;

            crc_win_cnt      <= 'd0;
            crc_bad_cnt      <= 'd0;
            need_realign     <= 1'b0;

            pre_win_cnt      <= 'd0;
            pre_bad_cnt      <= 'd0;
            pre_need_realign <= 1'b0;

            o_frame_locked   <= 1'b0;
        end else begin
            o_payload_valid <= 1'b0;
            o_frame_start   <= 1'b0;
            o_realign_req   <= 1'b0;
            o_blk_soft_rst  <= 1'b0;
            // o_crc_ok      <= crc_ok;  

            case (state)
                //------------------------------------------------
                // 等待链路 up
                //------------------------------------------------
                S_WAIT_LINK: begin
                    payload_cnt       <= 16'd0;
                    frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                    block_sync_valid  <= 1'b0;    
                    pending_rst       <= 1'b0;
                    crc_ok            <= 1'b0;

                    crc_win_cnt      <= 'd0;
                    crc_bad_cnt      <= 'd0;
                    need_realign     <= 1'b0;

                    pre_win_cnt      <= 'd0;
                    pre_bad_cnt      <= 'd0;
                    pre_need_realign <= 1'b0;

                    o_frame_locked   <= 1'b0;

                    if (i_link_up)
                        state <= S_SEARCH_PREAMBLE1;
                end

                //------------------------------------------------
                // 搜索前导高字 PREAMBLE_HI
                //------------------------------------------------
                S_SEARCH_PREAMBLE1: begin
                    o_frame_locked <= 1'b0;

                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_HI) begin
                            state             <= S_SEARCH_PREAMBLE2;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            if (realign_cond) begin
                                o_realign_req <= 1'b1;
                                state         <= S_WAIT_LINK;  
                            end
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                //------------------------------------------------
                // 搜索前导低字 PREAMBLE_LO
                //------------------------------------------------
                S_SEARCH_PREAMBLE2: begin
                    o_frame_locked <= 1'b0;

                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_LO) begin
                            state             <= S_RECV_HEADER;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            state             <= S_SEARCH_PREAMBLE1; 
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end
                    end else begin 
                        if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            if(realign_cond)begin
                                o_realign_req     <= 1'b1;
                                state             <= S_WAIT_LINK;
                            end
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                //------------------------------------------------
                // 接收 HEADER：{block_id, frame_in_block}
                //------------------------------------------------
                S_RECV_HEADER: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_block_id        <= rx_block_id;
                        o_frame_in_block  <= rx_frame_in_block;
                        o_frame_index     <= frame_index;
                        frame_index       <= frame_index + 1'b1;

                        // 块对齐 & blk_soft_rst 判定逻辑
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
                        end

                        payload_cnt       <= 16'd0;
                        frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        crc_ok            <= 1'b0;   // 新帧，先清 CRC 标志
                        state             <= S_RECV_PAYLOAD;
                    end
                end

                //------------------------------------------------
                // 接收 PAYLOAD：并解扰 & 做 CRC
                //------------------------------------------------
                S_RECV_PAYLOAD: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_payload_valid <= 1'b1;

                        if (scrambler_en) 
                            o_payload_data  <= scram_dout;  // 解扰输出
                        else 
                            o_payload_data  <= i_rx_data;   // 无解扰输出

                        if (payload_cnt == 0) begin
                            o_frame_start <= 1'b1; 
                            if (pending_rst) begin
                                o_blk_soft_rst <= 1'b1; 
                                pending_rst    <= 1'b0; 
                            end
                        end

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            payload_cnt       <= 16'd0;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                            state             <= S_RECV_CRC;   // 接收 CRC
                        end else begin
                            payload_cnt       <= payload_cnt + 1'b1;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}}; 
                        end
                    end
                end

                //------------------------------------------------
                // 接收 CRC32 字并比较 + CRC 窗口统计
                //------------------------------------------------
                S_RECV_CRC: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        crc_rx_word <= i_rx_data;
                        crc_ok      <= crc_match;  // 当前帧是否通过

                        // ===== CRC 窗口统计 =====
                        if (crc_win_cnt == CRC_WIN - 1) begin
                            // 窗口最后一帧，也要把当前帧计入坏帧数
                            if ( (!crc_match && (crc_bad_cnt + 1'b1 >= CRC_BAD_TH)) ||
                                 ( crc_match && (crc_bad_cnt         >= CRC_BAD_TH)) )
                                need_realign <= 1'b1;
                            else
                                need_realign <= 1'b0;

                            // 窗口结束，清零计数，准备下一个窗口
                            crc_win_cnt <= {CRC_CNT_W{1'b0}};
                            crc_bad_cnt <= {CRC_CNT_W{1'b0}};
                        end else begin
                            // 窗口中间
                            crc_win_cnt <= crc_win_cnt + 1'b1;
                            if (!crc_match)
                                crc_bad_cnt <= crc_bad_cnt + 1'b1;
                        end

                        frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        state             <= S_SEARCH_PREAMBLE1;
                    end else begin
                        // 等待 CRC 字的过程中超时
                        if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            if (realign_cond) begin
                                o_realign_req <= 1'b1;
                                state         <= S_WAIT_LINK;
                            end
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                default: state <= S_WAIT_LINK;
            endcase

            //========================================================
            // 帧级锁定标志：i_link_up && 不处于 WAIT/SEARCH，且当前没有 realign 请求
            //========================================================
            if (!i_link_up || realign_cond ||
                state == S_WAIT_LINK ||
                state == S_SEARCH_PREAMBLE1 ||
                state == S_SEARCH_PREAMBLE2) begin
                o_frame_locked <= 1'b0;
            end else if (state == S_RECV_PAYLOAD || state == S_RECV_CRC) begin
                o_frame_locked <= 1'b1;
            end
        end
    end

    //================================================================
    // 前导命中率统计：在 S_SEARCH_PREAMBLE2 中统计前导成功/失败
    //================================================================
    always @(posedge clk) begin
        if (!rst_n) begin
            pre_win_cnt      <= 'd0;
            pre_bad_cnt      <= 'd0;
            pre_need_realign <= 1'b0;
        end else if (state == S_WAIT_LINK) begin
            // 在 WAIT_LINK 状态下清空窗口
            pre_win_cnt      <= 'd0;
            pre_bad_cnt      <= 'd0;
        end else begin
            // 1) S_SEARCH_PREAMBLE2 有有效数据
            if (state == S_SEARCH_PREAMBLE2 && i_rx_valid) begin
                if (i_rx_data == PREAMBLE_LO) begin
                    // ===== 前导成功事件 =====
                    if (pre_win_cnt == PRE_WIN - 1) begin
                        if (pre_bad_cnt >= PRE_BAD_TH)
                            pre_need_realign <= 1'b1;
                        else
                            pre_need_realign <= 1'b0;

                        pre_win_cnt <= {PRE_CNT_W{1'b0}};
                        pre_bad_cnt <= {PRE_CNT_W{1'b0}};
                    end else begin
                        pre_win_cnt <= pre_win_cnt + 1'b1;
                        // pre_bad_cnt 不变
                    end
                end else begin
                    // ===== 前导失败事件（HI 对了但 LO 不对） =====
                    if (pre_win_cnt == PRE_WIN - 1) begin
                        if (pre_bad_cnt + 1'b1 >= PRE_BAD_TH)
                            pre_need_realign <= 1'b1;
                        else
                            pre_need_realign <= 1'b0;

                        pre_win_cnt <= {PRE_CNT_W{1'b0}};
                        pre_bad_cnt <= {PRE_CNT_W{1'b0}};
                    end else begin
                        pre_win_cnt <= pre_win_cnt + 1'b1;
                        pre_bad_cnt <= pre_bad_cnt + 1'b1;
                    end
                end
            end
            // 2) 在 S_SEARCH_PREAMBLE2 没数据但 timeout 了，也认为是“前导失败事件”
            else if (state == S_SEARCH_PREAMBLE2 && !i_rx_valid && frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                if (pre_win_cnt == PRE_WIN - 1) begin
                    if (pre_bad_cnt + 1'b1 >= PRE_BAD_TH)
                        pre_need_realign <= 1'b1;
                    else
                        pre_need_realign <= 1'b0;

                    pre_win_cnt <= {PRE_CNT_W{1'b0}};
                    pre_bad_cnt <= {PRE_CNT_W{1'b0}};
                end else begin
                    pre_win_cnt <= pre_win_cnt + 1'b1;
                    pre_bad_cnt <= pre_bad_cnt + 1'b1;
                end
            end
        end
    end

    //================================================================
    // Debug 打印（保留）
    //================================================================
    always @(posedge clk) begin
        if (i_rx_valid) begin
            $display("RX Data - i_rx_data: %h, i_rx_valid: %b", i_rx_data, i_rx_valid);
        end
        if (o_payload_valid) begin
            $display("PAYLOAD - o_payload_data: %h, o_payload_valid: %b", o_payload_data, o_payload_valid);
        end
    end

endmodule
