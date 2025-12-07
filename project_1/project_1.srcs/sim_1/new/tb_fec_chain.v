`timescale 1ns/1ps
`define  SIM
module tb_fec_chain;

    //============================================================
    // 选择测试模式
    // TEST_PRBS = 0 → 8bit 计数器
    // TEST_PRBS = 1 → PRBS7（8bit）
    //============================================================
    localparam TEST_PRBS     = 0;
    localparam INJECT_ERR_EN = 0;
    localparam SCRAMBLER_EN  = 0; //扰码使能
    //============================================================
    // 时钟 & 复位
    //============================================================
    reg core_clk;
    wire line_clk;
    reg rst_n;
    // initial begin
    //     line_clk = 0;
    //     forever #8 line_clk = ~line_clk;  // 20MHz
    // end
    assign line_clk = core_clk;
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
        .line_clk         (core_clk),
        .core_clk         (core_clk),
        .rst_n            (rst_n),   //复位信号跨时钟域
        .scrambler_en     (SCRAMBLER_EN),
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
        .scrambler_en    (SCRAMBLER_EN),
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

    // reg [7:0] expected_data;
    // wire [7:0] rx_diff;
    // assign rx_diff = rx_data ^ expected_data;
    // wire cnt_mode_match;
    // assign cnt_mode_match =  ~|rx_diff; 

    // always@(posedge core_clk or negedge rst_n)begin //rs 解码后得到的数据应该是0-229
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


//误码插入逻辑
    reg [7:0] inject_err_mask;
    always@(posedge line_clk or negedge rst_n)begin
        if(!rst_n)
            inject_err_mask <= 'd0;
        else begin
            if(INJECT_ERR_EN)begin
                inject_err_mask <= 8'b0000_0001;
            end
        end 
    end

    wire inject_err_prbsdata;
    assign inject_err_prbsdata = INJECT_ERR_EN ? ~(inject_err_mask&prbs7_data) : prbs7_data;
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
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (use_prbs && src_ready),
        .DATA_OUT (prbs7_data)
    );

    assign src_data  = use_prbs ? prbs7_data : cnt_data;
    assign src_valid = src_ready;      // 简化：只在 ready=1 时产生数据

    //============================================================
    // RX 端检查：计数器 / PRBS7
    //============================================================
    // integer cnt_err;
    integer prbs_err;

    // 计数器期望值
    // reg [7:0] exp_cnt;

    // PRBS7 Checker
    wire [7:0] prbs_err_vec;
    wire       prbs_match;

    reg [7:0] rx_data_d0;
    reg       rx_valid_d0;

    always@(posedge core_clk or negedge rst_n)begin
        if(!rst_n)begin
            rx_data_d0 <= 'd0;
            rx_valid_d0 <= 1'b0;
        end else begin
            rx_data_d0 <= rx_data;
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
        .DATA_IN  (rx_data_d),
        .EN       (use_prbs && rx_valid_d),
        .DATA_OUT (prbs_err_vec)
    );

    // ------------------------------------------------
    // PRBS 错误屏蔽与锁定逻辑
    // ------------------------------------------------
    reg [3:0] prbs_mask_cnt;    // 屏蔽计数器
    reg       prbs_lock_latched; // 锁定标志

    wire chk_en = use_prbs && rx_valid;   // 或者再 & bit_locked

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            prbs_mask_cnt     <= 0;
            prbs_lock_latched <= 0;
            prbs_err          <= 0; 
        end else if (use_prbs && rx_valid) begin
            if (prbs_mask_cnt < 4) begin
                prbs_mask_cnt <= prbs_mask_cnt + 1;
            end 
            else begin
                // 屏蔽期过后，正式开始检查
                if (|prbs_err_vec) begin
                    prbs_err <= prbs_err + 1;
                end
                // 如果当前周期无错，认为已锁定
                if (prbs_err_vec == 0)
                    prbs_lock_latched <= 1'b1;
            end
        end
    end
    // ------------------------------------------------
    // prbs_match：只在 rx_valid 且过了 mask 期时，反映当前 symbol 是否无错
    // ------------------------------------------------
    wire prbs_match_sym = (prbs_err_vec == 8'h00);

    reg prbs_match_r;
    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            prbs_match_r <= 1'b0;
        end else if (use_prbs) begin
            if (chk_en && (prbs_mask_cnt >= 4))
                prbs_match_r <= prbs_match_sym;
            else
                prbs_match_r <= 1'b0;   // 没有有效数据 / 未过屏蔽期 → 拉低
        end else begin
            prbs_match_r <= 1'b0;
        end
    end

    assign prbs_match = prbs_match_r;

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
            // 先打一拍，把“100ps 更新”的 rx_data / rx_valid 收到寄存器里
            rx_data_d  <= rx_data;
            rx_valid_d <= rx_valid;

            if (!use_prbs) begin
                if (rx_valid_d) begin
                    // 1) 当前这个 symbol 是否匹配
                    cnt_match <= cnt_match_sym;

                    // 2) 统计错误
                    if (!cnt_match_sym) begin
                        cnt_err <= cnt_err + 1;
                        if (cnt_err == 0) begin
                            // $display("[%0t] FIRST CNT ERROR !!!", $time);
                            // $display("  exp_cnt        = %0d, rx_data = %0d", exp_cnt, rx_data_d);
                            // $display("  rx_frame_index = %0d", rx_frame_index);
                            // $display("  rx_block_id    = %0d", rx_block_id);
                            // $display("  rx_frame_in_block = %0d", rx_frame_in_block);
                            // 这里如果想停仿真就 $stop;
                        end
                    end

                    // 3) 更新下一拍的期望计数：0..228 (0x00..0xE4) 循环
                    if (exp_cnt == 8'd228)
                        exp_cnt <= 8'd0;
                    else
                        exp_cnt <= exp_cnt + 1'b1;
                end else begin
                    // 没有有效数据时，让 match 拉低，波形更清晰
                    cnt_match <= 1'b0;
                end
            end else begin
                // PRBS 模式下不用计数器检查
                cnt_match <= 1'b0;
                exp_cnt   <= 8'd0;
            end
        end
    end

    //============================================================
    // 仿真流程 & 打印信息
    //============================================================
    initial begin
        // $dumpfile("tb_fec_chain.vcd");
        // $dumpvars(0, tb_fec_chain);

        // 等到 bit_aligner 锁定 + 首帧 deframer 输出再提示
        wait (bit_locked == 1'b1);
        // $display("[%0t] Bit Aligner Locked.", $time);

        wait (rx_frame_index == 16'd0);
        // $display("[%0t] First frame received.", $time);

        // 正常跑一段时间
        #200000;

        // $display("======================================");
        // $display("TEST_PRBS = %0d", TEST_PRBS);
        // $display("Counter errors = %0d", cnt_err);
        // $display("PRBS7   errors = %0d", prbs_err);
        // $display("======================================");

//        $finish;
    end

endmodule
