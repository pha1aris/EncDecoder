`timescale 1ns/1ps

module tb_fec_chain;

    //============================================================
    // 选择测试模式
    // TEST_PRBS = 0 → 8bit 计数器
    // TEST_PRBS = 1 → PRBS7（8bit）
    //============================================================
    localparam TEST_PRBS = 0;

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

    // 源数据（8bit）
    wire [7:0] src_data;
    wire       src_valid;
    wire       src_ready;

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

        .i_data           (src_data),
        .i_valid          (src_valid),
        .i_ready          (src_ready),

        // .o_tx_data        (tx_data),
        // .o_tx_valid       (tx_valid),
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

    // fec_rx 输出 8bit 解码数据
    wire [7:0] rx_data;
    wire       rx_valid;
    wire       rxslide;
    wire       bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_block;

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

        .o_data          (rx_data),
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
    // 上游激励：计数器 / PRBS7 选择
    //============================================================
    wire use_prbs = (TEST_PRBS != 0);

    reg [7:0] cnt_data;

    // 计数器
    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n)
            cnt_data <= 8'd0;
        else if (!use_prbs && src_ready)
            if(cnt_data == 'd229-1)
                cnt_data <= 'd0;
            else 
                cnt_data <= cnt_data + 1'b1;
    end

    reg [7:0] expected_data;
    wire [7:0] rx_diff;
    assign rx_diff = rx_data ^ expected_data;
    wire cnt_mode_match;
    assign cnt_mode_match =  ~|rx_diff; 

    // always@(posedge line_clk or negedge rst_n)begin //rs 解码后得到的数据应该是0-229
    //     if(!rst_n)begin
    //         expected_data <= 'd0;
    //     end else begin
    //         if(rx_valid)begin
    //             if(expected_data == 'd229-1)
    //                 expected_data <= 'd0;
    //             else 
    //                 expected_data <= expected_data + 1'b1;
    //         end
    //     end
    // end

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

    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_err       <= 0;
            expected_data <= 8'd0;
        end else if (rx_valid) begin
            if (!use_prbs) begin
                // 1) 先比较当前收到的 rx_data 和当前期望值 expected_data
                if (rx_data !== expected_data) begin
                    cnt_err <= cnt_err + 1;

                    // 使用旧值的 cnt_err == 0 来判断“第一颗错误”
                    if (cnt_err == 0) begin
                        $display("[%0t] FIRST CNT ERROR !!!", $time);
                        $display("  expected_data    = %0d, rx_data = %0d",
                                  expected_data, rx_data);
                        $display("  rx_frame_index   = %0d", rx_frame_index);
                        $display("  rx_block_id      = %0d", rx_block_id);
                        $display("  rx_frame_in_block= %0d", rx_frame_in_block);
                        // 这里可以再加：当前交织器 / 解交织器的一些状态信号
                        $stop;   // 在第一颗错停下来
                    end
                end

                // 2) 再更新下一拍的 expected_data（0..228 循环）
                if (expected_data == 8'd228)
                    expected_data <= 8'd0;
                else
                    expected_data <= expected_data + 1'b1;
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
