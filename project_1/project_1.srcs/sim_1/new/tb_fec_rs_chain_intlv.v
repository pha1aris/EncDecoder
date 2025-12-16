`timescale 1ns/1ps
`define SIM

module tb_fec_rs_chain_intlv;

    // ------------------------------------------------------------
    // 参数
    // ------------------------------------------------------------
    localparam integer W             = 32;
    localparam integer PAYLOAD_WORDS = 16;
    localparam integer RS_K          = 229;
    localparam integer RS_N          = 255;

    localparam integer INTLV_D       = 64;   // 先用小 D，确认逻辑正确再换 4808
    localparam integer INTLV_N       = 255;

    localparam TEST_PRBS     = 1;  // 0: 计数器模式, 1: PRBS7
    localparam SCRAMBLER_EN  = 0;  // 先关掉扰码，方便观察

    // ------------------------------------------------------------
    // 时钟 & 复位
    // ------------------------------------------------------------
    reg core_clk;
    reg rst_n;

    initial begin
        core_clk = 1'b0;
        forever #5 core_clk = ~core_clk;   // 100MHz
    end

    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
    end

    wire rst      = ~rst_n;
    wire line_clk = core_clk;   // 这里 TX/RX 共用一个时钟

    // ------------------------------------------------------------
    // 上游激励：计数器 / PRBS7
    // ------------------------------------------------------------
    wire use_prbs = (TEST_PRBS != 0);

    reg  [7:0] cnt_data;
    wire [7:0] prbs7_data;
    wire [7:0] src_data;
    wire       src_valid;
    wire       src_ready;
    wire [7:0] enc_data;
    wire       enc_valid;
    wire       enc_last;
    // 交织器输入 ready
    wire       intlv_in_ready;
    wire        intlv_valid;
    wire [7:0]  intlv_data;
    wire        intlv_block_start;
    wire        intlv_out_ready;
    wire [W-1:0] tx_payload_data;
    wire         tx_payload_valid;
    wire         gb_in_ready;      // gearbox in_ready
    wire [W-1:0] tx32_data;
    wire         tx32_valid;
    wire [15:0]  tx_frame_index;
    wire         tx_payload_ready;

    // 计数器：0..228 循环
    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n)
            cnt_data <= 8'd0;
        else if (!use_prbs && src_ready) begin
            if (cnt_data == 8'd228)
                cnt_data <= 8'd0;
            else
                cnt_data <= cnt_data + 1'b1;
        end
    end

    // PRBS7 发生器
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen (
        .RST      (~rst_n),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (use_prbs && src_ready),
        .DATA_OUT (prbs7_data)
    );

    assign src_data  = use_prbs ? prbs7_data : cnt_data;
    assign src_valid = src_ready;  // ready=1 时才产生有效数据

    // ============================================================
    // TX 端：RS 编码前端 + RS Encoder IP + 交织器 + 8→32 Gearbox + Framer
    // ============================================================

    // ---------- RS 编码前端 ----------

    rs_encode_frontend #(
        .RS_K (RS_K)
    ) u_rs_encode_frontend (
        .clk                    (core_clk),   // 上游 8bit 时钟
        .enc_clk                (core_clk),   // RS Encoder 也用同一个时钟
        .rst                    (rst),
        // 上游 8bit 输入
        .fifo_input_rdy         (src_ready),
        .data_i                 (src_data),
        .data_valid_i           (src_valid),
        // 下游 RS Encoder 的 AXIS（tready 来自交织器 in_ready）
        .m_axis_output_tready   (intlv_in_ready),
        .m_axis_output_tdata    (enc_data),
        .m_axis_output_tvalid   (enc_valid),
        .m_axis_output_tlast    (enc_last)
    );

    // ---------- 交织器（TX） ----------

    rs_interleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_interleaver (
        .clk            (core_clk),
        .rst            (rst),

        .in_valid       (enc_valid),
        .in_data        (enc_data),
        .in_ready       (intlv_in_ready),     // 反馈给 RS 编码前端

        .out_ready      (intlv_out_ready),    // 由 8→32 gearbox 的 in_ready 决定
        .out_valid      (intlv_valid),
        .out_data       (intlv_data),
        .out_block_start(intlv_block_start)
    );

    // ---------- 8→32 Gearbox ----------

    gearbox_8to32_bs u_gb_8to32 (
        .clk            (core_clk),
        .rst            (rst),

        .in_data        (intlv_data),
        .in_valid       (intlv_valid),
        .in_block_start (intlv_block_start),
        .in_ready       (gb_in_ready),        // 反馈给交织器 out_ready

        .out_ready      (tx_payload_ready),   // 来自 framer
        .out_data       (tx_payload_data),
        .out_valid      (tx_payload_valid),
        .out_block_start()
    );

    assign intlv_out_ready = gb_in_ready;

    // ---------- Framer ----------

    fso_framer #(
        .W                  (W),
        .PAYLOAD_WORDS      (PAYLOAD_WORDS),
        .FRAMES_PER_BLOCK   (255)
    ) u_fso_framer (
        .clk                (core_clk),
        .rst_n              (rst_n),
        
        .i_payload_data     (tx_payload_data),
        .i_payload_valid    (tx_payload_valid),
        .scrambler_en       (SCRAMBLER_EN),
        .o_payload_ready    (tx_payload_ready),

        .i_tx_ready         (1'b1),          // 仿真中下游一直 ready
        .o_tx_data          (tx32_data),
        .o_tx_valid         (tx32_valid),
        .o_frame_index      (tx_frame_index)
    );

    // ============================================================
    // “信道”：仍然直接 TX→RX，不要 bit_aligner / channel_model
    // ============================================================

    wire [W-1:0] rx32_data  = tx32_data;
    wire         rx32_valid = tx32_valid;

    // ============================================================
    // RX 端：Deframer + 32→8 Gearbox + 去交织器 + RS 解码前端 + RS 解码
    // ============================================================

    // ---------- Deframer ----------
    wire [W-1:0] rx_payload_data;
    wire         rx_payload_valid;
    wire [15:0]  rx_frame_index;
    wire [15:0]  rx_block_id;
    wire [15:0]  rx_frame_in_block;
    wire         blk_soft_rst;
    wire         realign_req_unused;
    wire         frame_locked_unused;

    wire bit_locked = 1'b1;  // 物理层直接认为锁定

    fso_deframer #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (64)
    ) u_fso_deframer (
        .clk              (core_clk),
        .rst_n            (rst_n),

        .i_link_up        (bit_locked),
        .i_rx_data        (rx32_data),
        .i_rx_valid       (rx32_valid),

        .scrambler_en     (SCRAMBLER_EN),
        .o_realign_req    (realign_req_unused),
        .o_frame_start    (),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_block),
        .o_blk_soft_rst   (blk_soft_rst),

        .o_frame_locked   (frame_locked_unused),

        .o_payload_data   (rx_payload_data),
        .o_payload_valid  (rx_payload_valid)
    );

    // ---------- 32→8 Gearbox ----------
    wire [7:0] gb8_data;
    wire       gb8_valid;
    wire       gb8_sync_rst;

    gearbox_32to8 u_gb_32to8 (
        .clk         (core_clk),
        .rst         (rst),

        .in_sync_rst (blk_soft_rst),     // 帧起点同步标志先照你原来的连法
        .in_data     (rx_payload_data),
        .in_valid    (rx_payload_valid),

        .out_data    (gb8_data),
        .out_sync_rst(gb8_sync_rst),
        .out_valid   (gb8_valid)
    );

    // ---------- 去交织器（RX） ----------
    wire        deintlv_valid;
    wire [7:0]  deintlv_data;
    wire        deintlv_block_start;
    wire [7:0]  rs_in_data;
    wire        rs_in_valid;
    wire        rs_in_ready;
    wire        rs_in_fire;
    reg  [7:0]  rs_byte_cnt;
    wire        rs_tlast;

    rs_deinterleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_deinterleaver (
        .clk         (core_clk),
        .rst         (rst),
        // 先不做块对齐实验，可以继续绑 0
        .blk_soft_rst(1'b0),

        .in_valid    (gb8_valid),
        .in_data     (gb8_data),
        .in_ready    (),                 // 目前 gearbox32→8 没有 ready，先空着没关系

        .out_valid   (deintlv_valid),
        .out_data    (deintlv_data),
        .block_start (deintlv_block_start),
        .out_ready   (rs_in_ready)       // ★ 新增：真正的反压从 RS decoder 传回来
    );

    // ---------- RS 解码前端：只做 mod 255 计数 ----------

    assign rs_in_data  = deintlv_data;
    assign rs_in_valid = deintlv_valid;

    assign rs_in_fire  = rs_in_valid && rs_in_ready;
    assign rs_tlast    = (rs_byte_cnt == RS_N-1) && rs_in_fire;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            rs_byte_cnt <= 8'd0;
        end else if (rs_in_fire) begin
            if (rs_byte_cnt == RS_N-1)
                rs_byte_cnt <= 8'd0;
            else
                rs_byte_cnt <= rs_byte_cnt + 1'b1;
        end
    end

    // ---------- RS 解码后端 ----------
    wire [7:0] dec_data;
    wire       dec_valid;

    rs_decode_backend u_rs_decode_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (core_clk),

        .s_axis_input_tdata  (rs_in_data),
        .s_axis_input_tvalid (rs_in_valid),
        .s_axis_input_tlast  (rs_tlast),
        .s_axis_input_tready (rs_in_ready),

        .output_tdata        (dec_data),
        .output_tvalid       (dec_valid),
        .output_tready       (1'b1)
    );

    wire [7:0] prbs_result;
    wire prbs_match = ~|prbs_result;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST      (~rst_n),
        .CLK      (core_clk),
        .DATA_IN  (dec_data),
        .EN       (dec_valid),
        .DATA_OUT (prbs_result)
    );

    // ============================================================
    // RX 端检查：计数器模式验证
    // ============================================================
    reg  [7:0] exp_cnt;
    integer    cnt_err;
    wire [7:0] cnt_err_vec   = dec_data ^ exp_cnt;
    wire       cnt_match_sym = ~|cnt_err_vec;

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            exp_cnt   <= 8'd0;
            cnt_err   <= 0;
        end else if (!use_prbs) begin
            if (dec_valid) begin
                if (!cnt_match_sym) begin
                    cnt_err <= cnt_err + 1;
                    if (cnt_err == 0) begin
                        $display("[%0t] FIRST CNT ERROR !!!", $time);
                        $display("  exp_cnt        = %0d, dec_data = %0d", exp_cnt, dec_data);
                        $display("  rx_frame_index = %0d", rx_frame_index);
                        $display("  rx_block_id    = %0d", rx_block_id);
                        $display("  rx_frame_in_block = %0d", rx_frame_in_block);
                    end
                end

                if (exp_cnt == 8'd228)
                    exp_cnt <= 8'd0;
                else
                    exp_cnt <= exp_cnt + 1'b1;
            end
        end else begin
            // PRBS 模式下暂时不做计数器检查
            exp_cnt <= 8'd0;
        end
    end


    // ============================================================
    // 仿真流程控制
    // ============================================================
    // initial begin
    //     @(posedge rst_n);
    //     $display("[%0t] Reset deasserted, start INTLV simulation.", $time);

    //     #200000;

    //     $display("======================================");
    //     $display("Stage2 RS + Interleaver/Deinterleaver Test");
    //     $display("TEST_PRBS     = %0d", TEST_PRBS);
    //     $display("INTLV_D       = %0d", INTLV_D);
    //     $display("Counter errors= %0d", cnt_err);
    //     $display("======================================");

    //     // $stop;
    // end
    // ============================================================
    // Monitor 1: RS Encoder 输出每个码字长度是否为 255 字节
    // 接口：enc_valid / enc_last / intlv_in_ready
    // ============================================================
    wire        enc_fire = enc_valid && intlv_in_ready;
    reg  [8:0]  mon_enc_sym_cnt;
    integer     mon_enc_cw_idx;
    
    localparam integer INTLV_TOTAL_SYM = INTLV_D * INTLV_N;  // 每个交织 block 的总符号数

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            mon_enc_sym_cnt <= 0;
            mon_enc_cw_idx  <= 0;
        end else if (enc_fire) begin
            if (enc_last) begin
                // 注意：此时 mon_enc_sym_cnt 是 "最后一个 symbol 之前已经数到多少"
                if (mon_enc_sym_cnt != RS_N-1) begin
                    $display("[%0t] MON_RS_ENC_LEN_ERR: cw=%0d len=%0d (expect %0d)",
                             $time, mon_enc_cw_idx, mon_enc_sym_cnt+1, RS_N);
                    $stop;
                end
                mon_enc_sym_cnt <= 0;
                mon_enc_cw_idx  <= mon_enc_cw_idx + 1;
            end else begin
                mon_enc_sym_cnt <= mon_enc_sym_cnt + 1'b1;
            end
        end
    end
    // ============================================================
    // Monitor 2: 去交织器每个 block 符号数是否为 INTLV_TOTAL_SYM
    // 接口：deintlv_valid / deintlv_block_start
    // ============================================================
    reg [31:0] mon_de_blk_sym_cnt;
    integer    mon_de_blk_idx;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            mon_de_blk_sym_cnt <= 0;
            mon_de_blk_idx     <= 0;
        end else if (deintlv_valid) begin
            if (deintlv_block_start) begin
                // 遇到一个新的 block_start，先检查上一块（第一块时计数为 0，跳过）
                if (mon_de_blk_sym_cnt != 0 && mon_de_blk_sym_cnt != INTLV_TOTAL_SYM) begin
                    $display("[%0t] MON_DEINTLV_BLK_ERR: blk=%0d len=%0d (expect %0d)",
                             $time, mon_de_blk_idx, mon_de_blk_sym_cnt, INTLV_TOTAL_SYM);
                    $stop;
                end
                // 进入下一块，从当前这个 symbol 开始计数
                mon_de_blk_idx     <= mon_de_blk_idx + 1;
                mon_de_blk_sym_cnt <= 1;
            end else begin
                mon_de_blk_sym_cnt <= mon_de_blk_sym_cnt + 1'b1;
            end
        end
    end

    // 仿真结束前再检查最后一块（防止刚好没遇到下一次 block_start）
    initial begin
        @(posedge rst_n);
        #190000;  // 比主 initial 的 #200000 略小一点
        if (mon_de_blk_sym_cnt != 0 && mon_de_blk_sym_cnt != INTLV_TOTAL_SYM) begin
            $display("[%0t] MON_DEINTLV_LAST_BLK_ERR: blk=%0d len=%0d (expect %0d)",
                     $time, mon_de_blk_idx, mon_de_blk_sym_cnt, INTLV_TOTAL_SYM);
        end
    end
    // ============================================================
    // Monitor 3: 交织器输出 / 去交织器输入 / 去交织器输出 总符号数
    // 用于粗定位是否在中间某级丢数据
    // ============================================================
    reg [31:0] mon_intlv_out_cnt;
    reg [31:0] mon_deintlv_in_cnt;
    reg [31:0] mon_deintlv_out_cnt;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            mon_intlv_out_cnt   <= 0;
            mon_deintlv_in_cnt  <= 0;
            mon_deintlv_out_cnt <= 0;
        end else begin
            // 交织器输出：已经完成握手的 symbol 数
            if (intlv_valid && intlv_out_ready)
                mon_intlv_out_cnt <= mon_intlv_out_cnt + 1;

            // 去交织器输入：32→8 gearbox 输出到 deinterleaver 的 8bit 流
            // 注意：这里没有 ready，真实硬件就是“不看 ready”，所以可以看见是否比上游多/少
            if (gb8_valid)
                mon_deintlv_in_cnt <= mon_deintlv_in_cnt + 1;

            // 去交织器输出：deintlv_valid 有效的符号数
            if (deintlv_valid)
                mon_deintlv_out_cnt <= mon_deintlv_out_cnt + 1;
        end
    end

endmodule
