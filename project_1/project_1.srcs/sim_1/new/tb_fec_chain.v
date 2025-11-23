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
        forever #8 line_clk = ~line_clk;  // 20MHz
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

    parameter INTLV_D = 64;
    parameter INTLV_N = 255;
    parameter FRAMES_PER_BLOCK = 255;

    // 源数据（8bit） - 这里是“扰码前”的数据
    wire [7:0] src_data;
    wire       src_valid;
    wire       src_ready;

    // *** TX 加扰后的数据 ***
    wire [7:0] tx_data_scr;

    // fec_tx 输出到“光口”的 32bit 数据
    wire [W-1:0] tx_data;
    wire         tx_valid;
    wire [15:0]  tx_frame_index;

    fec_tx #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .RS_K             (229),
        .RS_N             (255),
        .INTLV_D          (INTLV_D),      // 联调建议先用小 D，跑通再改大
        .INTLV_N          (INTLV_N),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_fec_tx (
        .line_clk         (line_clk),
        .core_clk         (core_clk),
        .rst_n            (rst_n),   //复位信号跨时钟域

        // *** 原来接 src_data，现在接加扰后的 tx_data_scr ***
        .i_data           (tx_data_scr),
        .i_valid          (src_valid),
        .i_ready          (src_ready),

        .o_tx_data_line   (tx_data),
        .o_tx_valid_line  (tx_valid),
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

    // *** fec_rx 输出的先叫 rx_data_scr（被扰码的） ***
    wire [7:0] rx_data_scr;
    wire       rx_valid;
    wire       rxslide;
    wire       bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

    // *** 解扰后的数据再叫 rx_data，后面检查模块用它 ***
    wire [7:0] rx_data;

    fec_rx #(
        .W               (W),
        .PAYLOAD_WORDS   (PAYLOAD_WORDS),
        .RS_N            (255),
        .INTLV_D         (INTLV_D),       // 和 TX 保持一致
        .INTLV_N         (INTLV_N)
    ) u_fec_rx (
        .line_clk        (line_clk),
        .core_clk        (core_clk),
        .rst_n           (rst_n),

        .i_rx_data       (rx_data_to_aligner),  // 下面的 channel_model 输出
        .i_rx_valid      (rx_valid_to_aligner),
        .rx_reset_done   (rx_reset_done),
        .rx_cdr_stable   (rx_cdr_stable),

        .o_data          (rx_data_scr),   // *** 注意：改名 ***
        .o_valid         (rx_valid),
        .i_data_ready    (1'b1),

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
        .clk        (line_clk),
        .rst_n      (rst_n),

        .i_tx_data  (tx_data),
        .i_tx_valid (tx_valid),

        .i_rxslide  (rxslide),
        .o_rx_data  (rx_data_to_aligner),
        .o_rx_valid (rx_valid_to_aligner)
    );

    //============================================================
    // 上游激励：计数器 / PRBS7 选择（扰码前的数据）
    //============================================================
    wire use_prbs = (TEST_PRBS != 0);

    reg [7:0] cnt_data;

    // 计数器
    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n)
            cnt_data <= 8'd0;
        else if (!use_prbs && src_ready)
            if (cnt_data == 'd229-1)
                cnt_data <= 'd0;
            else 
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

    // *** 扰码前的数据选择 ***
    assign src_data  = use_prbs ? prbs7_data : cnt_data;
    assign src_valid = src_ready;      // 简化：只在 ready=1 时产生数据

    //============================================================
    // ★ TX 侧加性扰码器 ★
    //============================================================
    AdditiveScrambler #(
        .POLY_LENGHT (16),
        .POLY_TAP_1  (5),
        .POLY_TAP_2  (4),
        .POLY_TAP_3  (3),
        .NBITS       (8)
    ) u_tx_scrambler (
        .CLK        (line_clk),
        .RST        (~rst_n),
        .EN         (src_valid & src_ready),   // 每送入一个 symbol 时前进一步
        .SEED_LOAD  (1'b0),                    // 目前只靠全局复位对齐
        .SEED_VALUE (16'hACE1),
        .DATA_IN    (src_data),
        .DATA_OUT   (tx_data_scr)
    );

    //============================================================
    // ★ RX 侧加性解扰器 ★
    //============================================================
    AdditiveScrambler #(
        .POLY_LENGHT (16),
        .POLY_TAP_1  (5),
        .POLY_TAP_2  (4),
        .POLY_TAP_3  (3),
        .NBITS       (8)
    ) u_rx_descrambler (
        .CLK        (core_clk),
        .RST        (~rst_n),
        .EN         (rx_valid),        // 每收到一个解码 symbol 时前进一步
        .SEED_LOAD  (1'b0),            // 同样只靠复位对齐
        .SEED_VALUE (16'hACE1),
        .DATA_IN    (rx_data_scr),
        .DATA_OUT   (rx_data)
    );

    //============================================================
    // RX 端检查：计数器 / PRBS7
    //============================================================
    integer prbs_err;

    // PRBS7 Checker
    wire [7:0] prbs_err_vec;
    wire       prbs_match;

    reg [7:0] rx_data_d0;
    reg       rx_valid_d0;

    // *** 注意：这里用的是“解扰后的 rx_data” ***
    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_data_d0  <= 'd0;
            rx_valid_d0 <= 1'b0;
        end else begin
            rx_data_d0  <= rx_data;
            rx_valid_d0 <= rx_valid;
        end
    end

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST      (~rst_n),
        .CLK      (core_clk),
        .DATA_IN  (rx_data_d0),
        .EN       (use_prbs && rx_valid_d0),
        .DATA_OUT (prbs_err_vec)
    );

    assign prbs_match = ~|prbs_err_vec;

    //============================================================
    // RX 端计数器模式检查（core_clk 域） - 同样用解扰后的数据
    //============================================================
    reg  [7:0] exp_cnt;
    reg  [7:0] rx_data_d;      // 把 rx_data 打一拍
    reg        rx_valid_d;     // 把 rx_valid 打一拍
    wire [7:0] cnt_err_vec;
    wire       cnt_match_sym;  // 单个 symbol 是否正确
    reg        cnt_match;      // 类似 prbs_match 的信号
    integer    cnt_err;

    assign cnt_err_vec   = rx_data_d ^ exp_cnt;  // 逐比特比较
    assign cnt_match_sym = ~|cnt_err_vec;        // 当前 symbol 是否完全匹配

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_data_d  <= 8'd0;
            rx_valid_d <= 1'b0;
            exp_cnt    <= 8'd0;
            cnt_err    <= 0;
            cnt_match  <= 1'b0;
        end else begin
            rx_data_d  <= rx_data;   // *** 解扰后的数据 ***
            rx_valid_d <= rx_valid;

            if (!use_prbs) begin
                if (rx_valid_d) begin
                    cnt_match <= cnt_match_sym;

                    if (!cnt_match_sym) begin
                        cnt_err <= cnt_err + 1;
                        if (cnt_err == 0) begin
                            $display("[%0t] FIRST CNT ERROR !!!", $time);
                            $display("  exp_cnt        = %0d, rx_data = %0d", exp_cnt, rx_data_d);
                            $display("  rx_frame_index = %0d", rx_frame_index);
                            $display("  rx_block_id    = %0d", rx_block_id);
                            $display("  rx_frame_in_block = %0d", rx_frame_in_block);
                        end
                    end

                    if (exp_cnt == 8'd228)
                        exp_cnt <= 8'd0;
                    else
                        exp_cnt <= exp_cnt + 1'b1;
                end else begin
                    cnt_match <= 1'b0;
                end
            end else begin
                cnt_match <= 1'b0;
                exp_cnt   <= 8'd0;
            end
        end
    end

    //============================================================
    // 仿真流程 & 打印信息
    //============================================================
    initial begin
        $dumpfile("tb_fec_chain.vcd");
        $dumpvars(0, tb_fec_chain);

        wait (bit_locked == 1'b1);
        $display("[%0t] Bit Aligner Locked.", $time);

        wait (rx_frame_index == 16'd0);
        $display("[%0t] First frame received.", $time);

        #200000;

        $display("======================================");
        $display("TEST_PRBS = %0d", TEST_PRBS);
        $display("Counter errors = %0d", cnt_err);
        $display("PRBS7   errors = %0d", prbs_err);
        $display("======================================");
    end

endmodule
