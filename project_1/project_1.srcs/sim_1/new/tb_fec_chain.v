`timescale 1ns/1ps

module tb_fec_chain;

    //============================================================
    // 选择测试模式
    // TEST_PRBS = 0 → 8bit 计数器
    // TEST_PRBS = 1 → PRBS7（8bit）
    //============================================================
    localparam TEST_PRBS = 1;

    //============================================================
    // 时钟 & 复位
    //============================================================
    reg core_clk;
    reg line_clk;
    reg rst_n;
    initial begin
        line_clk = 0;
        forever #25 line_clk = ~line_clk;  // 20MHz
    end
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

    //============================================================
    // TX 侧：FEC 发送链路（fec_tx）
    //============================================================
    localparam integer W             = 32;
    localparam integer PAYLOAD_WORDS = 16;

    // 源数据（8bit）
    wire [7:0] src_data;
    wire       src_valid;
    wire       src_ready;

    // fec_tx 输出到“光口”的 32bit 数据
    wire [W-1:0] tx_data;
    wire         tx_valid;
    wire [15:0]  tx_frame_index;

    fec_tx #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS),
        .RS_K          (229),
        .RS_N          (255),
        .INTLV_D       (4),      // 联调建议先用小 D，跑通再改大
        .INTLV_N       (255)
    ) u_fec_tx (
        .core_clk         (core_clk),
        .rst_n            (rst_n),

        .i_data           (src_data),
        .i_valid          (src_valid),
        .i_ready          (src_ready),

        .o_tx_data        (tx_data),
        .o_tx_valid       (tx_valid),
        .o_tx_frame_index (tx_frame_index)
    );

    //============================================================
    // RX 侧：FEC 接收链路（fec_rx）
    //============================================================

    // 模拟 GTH 状态
    reg rx_reset_done;
    reg rx_cdr_stable;

    initial begin
        rx_reset_done = 1'b0;
        rx_cdr_stable = 1'b0;

        @(posedge rst_n);
        #50;
        rx_reset_done = 1'b1;
        rx_cdr_stable = 1'b1;
    end

    // fec_rx 输出 8bit 解码数据
    wire [7:0] rx_data;
    wire       rx_valid;
    wire       rxslide;
    wire       bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

    fec_rx #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS),
        .RS_N          (255),
        .INTLV_D       (4),       // 和 TX 保持一致
        .INTLV_N       (255)
    ) u_fec_rx (
        .core_clk        (core_clk),
        .rst_n           (rst_n),

        .i_rx_data       (rx_data_to_aligner),  // 下面的 channel_model 输出
        .i_rx_valid      (rx_valid_to_aligner),
        .rx_reset_done   (rx_reset_done),
        .rx_cdr_stable   (rx_cdr_stable),

        .o_data          (rx_data),
        .o_valid         (rx_valid),

        .o_rxslide       (rxslide),
        .o_bit_locked    (bit_locked),
        .o_frame_index   (rx_frame_index),
        .o_block_id      (rx_block_id),
        .o_frame_in_block(rx_frame_in_block)
    );

    //============================================================
    // 中间：Channel Model（只做 bit 环移，和你之前一样）
    //============================================================
    wire [W-1:0] rx_data_to_aligner;
    wire         rx_valid_to_aligner;

    channel_model #(
        .W (W)
    ) u_channel_model (
        .clk        (core_clk),
        .rst_n      (rst_n),

        .i_tx_data  (tx_data),
        .i_tx_valid (tx_valid),

        .i_rxslide  (rxslide),
        .o_rx_data  (rx_data_to_aligner),
        .o_rx_valid (rx_valid_to_aligner)
    );

    //============================================================
    // 上游激励：计数器 / PRBS7 选择
    //============================================================
    wire use_prbs = (TEST_PRBS != 0);

    reg [7:0] cnt_data;

    // 计数器
    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n)
            cnt_data <= 8'd0;
        else if (!use_prbs && src_ready)
            cnt_data <= cnt_data + 1'b1;
    end

    // PRBS7（8bit）
    wire [7:0] prbs7_data;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen (
        .RST      (~rst_n),
        .CLK      (line_clk),
        .DATA_IN  (8'd0),
        .EN       (use_prbs && src_ready),
        .DATA_OUT (prbs7_data)
    );

    assign src_data  = use_prbs ? prbs7_data : cnt_data;
    assign src_valid = src_ready;      // 简化：只在 ready=1 时产生数据

    //============================================================
    // RX 端检查：计数器 / PRBS7
    //============================================================
    integer cnt_err;
    integer prbs_err;

    // 计数器期望值
    reg [7:0] exp_cnt;

    // PRBS7 Checker
    wire [7:0] prbs_err_vec;
    wire       prbs_match;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST      (~rst_n),
        .CLK      (line_clk),
        .DATA_IN  (rx_data),
        .EN       (use_prbs && rx_valid),
        .DATA_OUT (prbs_err_vec)
    );

    assign prbs_match = ~|prbs_err_vec;

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_err  <= 0;
            prbs_err <= 0;
            exp_cnt  <= 8'd0;
        end else if (rx_valid) begin
            if (!use_prbs) begin
                // 计数器模式检查：RX 是否等于 TX 的计数序列
                if (rx_data !== exp_cnt) begin
                    cnt_err <= cnt_err + 1;
                    $display("[%0t] CNT ERROR: expect=%0d got=%0d, total_err=%0d",
                             $time, exp_cnt, rx_data, cnt_err);
                end
                exp_cnt <= exp_cnt + 1'b1;
            end else begin
                // PRBS 模式检查
                if (!prbs_match) begin
                    prbs_err <= prbs_err + 1;
                    $display("[%0t] PRBS ERROR: data=%02x err_vec=%02x, total_err=%0d",
                             $time, rx_data, prbs_err_vec, prbs_err);
                end
            end
        end
    end

    //============================================================
    // 仿真流程 & 打印信息
    //============================================================
    initial begin
        $dumpfile("tb_fec_chain.vcd");
        $dumpvars(0, tb_fec_chain);

        // 等到 bit_aligner 锁定 + 首帧 deframer 输出再提示
        wait (bit_locked == 1'b1);
        $display("[%0t] Bit Aligner Locked.", $time);

        wait (rx_frame_index == 16'd0);
        $display("[%0t] First frame received.", $time);

        // 正常跑一段时间
        #200000;

        $display("======================================");
        $display("TEST_PRBS = %0d", TEST_PRBS);
        $display("Counter errors = %0d", cnt_err);
        $display("PRBS7   errors = %0d", prbs_err);
        $display("======================================");

        $finish;
    end

endmodule
