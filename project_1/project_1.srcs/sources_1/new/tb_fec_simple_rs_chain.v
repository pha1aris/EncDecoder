`timescale 1ns/1ps
`define SIM

module tb_fec_simple_rs_chain;

    // ------------------------------------------------------------
    // 参数
    // ------------------------------------------------------------
    localparam integer W             = 32;
    localparam integer PAYLOAD_WORDS = 16;
    localparam integer RS_K          = 229;
    localparam integer RS_N          = 255;

    localparam TEST_PRBS     = 0;  // 0: 计数器模式, 1: PRBS7
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

    wire rst = ~rst_n;
    wire line_clk = core_clk;   // 这里 TX/RX 共用一个时钟

    // ------------------------------------------------------------
    // 上游激励：计数器 / PRBS7
    // ------------------------------------------------------------
    wire use_prbs = (TEST_PRBS != 0);

    reg [7:0] cnt_data;
    wire [7:0] prbs7_data;
    wire [7:0] src_data;
    wire       src_valid;
    wire       src_ready;

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

    // PRBS7 发生器（和你原来 tb 用的一样）
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
    assign src_valid = src_ready;  // 简化：ready=1 时才产生有效数据

    // ============================================================
    // TX 端：RS 编码前端 + RS 编码 IP + 8→32 Gearbox + Framer
    // ============================================================

    // ---------- RS 编码前端 ----------
    wire [7:0] enc_data;
    wire       enc_valid;
    wire       enc_last;
    wire       enc_ready;  // 作为 gearbox 的 in_ready
    wire [W-1:0] tx_payload_data;
    wire         tx_payload_valid;
    wire         gb_in_ready;
    wire [W-1:0] tx32_data;
    wire         tx32_valid;
    wire [15:0]  tx_frame_index;
    wire         tx_payload_ready;
    wire [W-1:0] rx_payload_data;
    wire         rx_payload_valid;
    wire [15:0]  rx_frame_index;
    wire [15:0]  rx_block_id;
    wire [15:0]  rx_frame_in_block;
    wire         blk_soft_rst;
    wire         realign_req_unused;
    wire         frame_locked_unused;

    assign enc_ready = gb_in_ready;

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

        // 下游 RS Encoder 的 AXIS（我们把 tready 直接给 gearbox）
        .m_axis_output_tready   (gb_in_ready),
        .m_axis_output_tdata    (enc_data),
        .m_axis_output_tvalid   (enc_valid),
        .m_axis_output_tlast    (enc_last)
    );

    // ---------- 绕过交织器：enc_data 直接进 8→32 gearbox ----------

    gearbox_8to32_bs u_gb_8to32 (
        .clk            (core_clk),
        .rst            (rst),

        .in_data        (enc_data),
        .in_valid       (enc_valid),
        .in_block_start (1'b0),     // 先不管 block_start
        .in_ready       (gb_in_ready),

        .out_ready      (tx_payload_ready),
        .out_data       (tx_payload_data),
        .out_valid      (tx_payload_valid),
        .out_block_start()
    );

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
    // “信道”：Stage1 直接 TX→RX，不要 bit_aligner / channel_model
    // ============================================================

    wire [W-1:0] rx32_data  = tx32_data;
    wire         rx32_valid = tx32_valid;

    // ============================================================
    // RX 端：Deframer + 32→8 Gearbox + RS 解码前端 + RS 解码
    // ============================================================

    // ---------- Deframer ----------
    wire bit_locked = 1'b1;

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

    // ---------- Stage1：RS 解码前端，只做 mod 255 计数 ----------
    wire [7:0]  rs_in_data;
    wire        rs_in_valid;
    wire        rs_in_ready;
    wire        rs_in_fire;
    reg  [7:0]  rs_byte_cnt;
    wire        rs_tlast;

    assign rs_in_data  = gb8_data;
    assign rs_in_valid = gb8_valid;

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

    // ---------- RS 解码后端（你已有的 rs_decode_backend） ----------
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

    // ============================================================
    // RX 端检查：计数器模式验证（你原来的 cnt_match / cnt_err 逻辑）
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
    initial begin
        // 等复位结束
        @(posedge rst_n);
        $display("[%0t] Reset deasserted, start simulation.", $time);

        // 跑一段时间
        #200000;

        $display("======================================");
        $display("Stage1 Simple RS Chain Test");
        $display("TEST_PRBS     = %0d", TEST_PRBS);
        $display("Counter errors= %0d", cnt_err);
        $display("======================================");

        $stop;
    end

endmodule
