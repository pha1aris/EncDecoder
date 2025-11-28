`timescale 1ns / 1ps

//
// 这是一个鲁棒的仿真平台 (V2)
// 1. 移除了 "training_mode"，bit_aligner 直接锁定数据帧的 Preamble
// 2. 增加了 "channel_model" 模块，用于真正模拟 GTH 的“随机比特偏移”
// 3. Aligner 的 o_rxslide 现在真正地控制信道模型，构成了闭环
//
module tb_fso_system;

    // --------------------------------------------------------------------
    // 参数设置
    // --------------------------------------------------------------------
    localparam integer W             = 32;
    localparam integer PAYLOAD_WORDS = 16;
    localparam integer BIT_OFFSET_W  = $clog2(W); // = 5
    parameter          USE_SCRAM = 1; //加扰-1 不加扰-0
    parameter          PRBS_MODE = 1; // 0-cnt模式 1-prbs模式
    // 仿真时钟、复位
    reg clk;
    reg rst_n;

    // GTH 状态信号 (现在是 reg, 可以在仿真中控制)
    reg rx_reset_done = 1'b0;
    reg rx_cdr_stable = 1'b0;

    // --------------------- TX 侧信号（framer） --------------------------
    wire [W-1:0] tx_data;
    wire         tx_valid;
    wire [15:0]  tx_frame_index;

    reg  [W-1:0] payload_data;
    wire         payload_ready;
    wire         payload_valid;

    // --------------------- Channel Model 信号 -----------------------
    wire [W-1:0] rx_data_to_aligner; // (已偏移)
    wire         rx_valid_to_aligner;

    // --------------------- bit_aligner 输出 ------------------------------
    wire [W-1:0] aligned_data;      // (aligner 的 pass-through 输出)
    wire         aligned_valid;     // link_up
    wire         rxslide;           // (控制 Channel Model)

    // --------------------- deframer 输出 --------------------------------
    wire         realign_req;
    wire         frame_start;
    wire [15:0]  rx_frame_index;
    wire [W-1:0] rx_payload_data;
    wire         rx_payload_valid;


    // --------------------------------------------------------------------
    // 时钟、复位
    // --------------------------------------------------------------------
    initial begin
        clk   = 1'b0;
        forever #5 clk = ~clk;  // 100MHz
    end

    // --- 仿真测试序列 ---
    initial begin
        rst_n <= 1'b0;
        #100;
        rst_n <= 1'b1;
        
        // 1. 等待 GTH "稳定"
        #50;
        rx_reset_done <= 1'b1;
        rx_cdr_stable <= 1'b1;
        
        // 2. 等待 bit_aligner (L1) 和 fso_deframer (L2) 锁定
        // (此时 channel_model 的偏移是随机的, aligner 必须工作)
        $display("[%0t ns] TB: GTH 稳定。等待 Aligner (L1) 和 Deframer (L2) 锁定...", $time);
        wait (frame_start == 1'b1);
        $display("[%0t ns] TB: 链路完全锁定! (L1+L2)", $time);
        
        // 3. 正常运行一段时间
        #20000;
        
        // 4. 模拟 FSO 闪烁 (CDR 失锁)
        $display("[%0t ns] TB: === 模拟 FSO 闪烁 (CDR 失锁) ===", $time);
        rx_cdr_stable <= 1'b0;
        #500; // 衰落 500ns
        rx_cdr_stable <= 1'b1;
        $display("[%0t ns] TB: === FSO 闪烁结束 (CDR 重锁) ===", $time);

        // 5. 再次等待 L1 和 L2 锁定
        wait (frame_start == 1'b1);
        $display("[%0t ns] TB: 链路重新锁定! (L1+L2)", $time);

        #10000;
        $finish;
    end

    // --------------------------------------------------------------------
    // 简单 payload 生成器：一个递增计数器
    // --------------------------------------------------------------------
    assign payload_valid = payload_ready; 
    always @(posedge clk) begin
        if (!rst_n) begin
            payload_data <= {W{1'b0}};
        end else if (payload_ready) begin
            payload_data <= payload_data + 1'b1;
        end
    end

    wire [31:0] prbs_data;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (0),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (32)
    ) prbs_gen_inst (
        .RST                (~rst_n), // 使用 GTH TX 激活信号
        .CLK                (clk), // 使用 GTH TX 时钟
        .DATA_IN            ('d0),
        .EN                 (payload_ready), //  修改: 由 Frame Gen 反压
        .DATA_OUT           (prbs_data)                     //  连接到 Frame Gen
    );

    wire [W-1:0] test_data;
    assign test_data = PRBS_MODE ? prbs_data : payload_data;
    // --------------------------------------------------------------------
    // TX：FSO Framer 实例
    // --------------------------------------------------------------------

    fso_framer #(
        .W                  (W),
        .PAYLOAD_WORDS      (PAYLOAD_WORDS)
    ) u_fso_framer (
        .clk                (clk),
        .rst_n              (rst_n),
        .i_payload_data     (test_data),    
        .i_payload_valid    (payload_valid),

        .scrambler_en       (USE_SCRAM),
        .o_payload_ready    (payload_ready),
        .i_tx_ready         (1),
        .o_tx_data          (tx_data),
        .o_tx_valid         (tx_valid),
        .o_frame_index      (tx_frame_index)
    );


    // --------------------------------------------------------------------
    // 关键！信道模型 (Channel Model)
    // 模拟 GTH SIPO 的“随机边界切割”和“手动滑移”
    // --------------------------------------------------------------------
    channel_model #(
        .W                  (W)  
        // .BIT_ERR_INV_PROB (20000),  // 误码概率约 1e-4 / bit / word
        // .FADE_INV_PROB    (3000),   // 大约每 3000 个 word 来一次衰落
        // .FADE_LEN_MIN     (20),
        // .FADE_LEN_MAX     (80)
    ) u_channel_model (
        .clk            (clk),
        .rst_n          (rst_n),
        // 来自 Framer
        .i_tx_data      (tx_data),
        .i_tx_valid     (tx_valid),
        // 来自 Aligner 的控制
        .i_rxslide      (rxslide),
        // 去往 Aligner
        .o_rx_data      (rx_data_to_aligner),
        .o_rx_valid     (rx_valid_to_aligner)
    );

    // --------------------------------------------------------------------
    // Bit Aligner 实例
    // --------------------------------------------------------------------
    wire o_bit_locked;

    // bit_aligner #(
    //     .W                  (W),
    //     .VERIFY_CNT_MAX     (8),
    //     .SLIDE_COOLDOWN     (5),
    //     .ERR_TH             (0),
    //     .CHECK_TIMEOUT_MAX  (2048)
    // ) u_bit_aligner (
    //     .clk                (clk),
    //     .rst_n              (rst_n),
    //     .rx_reset_done      (rx_reset_done),
    //     .rx_cdr_stable      (rx_cdr_stable),
    //     .i_rx_data          (rx_data_to_aligner), // <-- 来自信道模型
    //     .i_rx_valid         (rx_valid_to_aligner),// <-- 来自信道模型
    //     .i_realign_req      (realign_req),
    //     .o_rxslide          (rxslide),            // --> 去往信道模型
    //     .o_aligned_valid    (aligned_valid),
    //     .o_bit_locked       (o_bit_locked),
    //     .o_data_aligned     (aligned_data)        // (这是 aligner 的 pass-through)
    // );

         bit_aligner_gth #(
            .W               (32),
            .VERIFY_CNT_MAX(4),    // 连续匹配 4 次才锁 
            .MISS_CNT_MAX  (10),   // 连续错 10 次才失锁 
            .SLIDE_COOLDOWN(32),   // GTH 物理层滑动需要的等待周期
            .ERR_TH        (2),    // 汉明距离容错 (2 bit)
            .SCAN_WINDOW   (64)   // 盲搜窗口 (大于最大帧长)
        )u_bit_aligner_gth(
                .clk                (clk),
                .rst_n              (rst_n),
                .rx_reset_done      (rx_reset_done),
                .rx_cdr_stable      (rx_cdr_stable),
            
                .i_rx_data          (rx_data_to_aligner), // <-- 来自信道模型
                .i_rx_valid         (rx_valid_to_aligner),// <-- 来自信道模型
            
            // input wire i_realign_req, // 工业级设计通常由本模块自行判断失锁，不需要外部请求
            
                .o_rxslide          (rxslide),            // --> 去往信道模型
                .o_aligned_valid    (aligned_valid),
                .o_bit_locked       (o_bit_locked),
                .o_data_aligned     (aligned_data)   
        );

    // --------------------------------------------------------------------
    // Deframer 实例
    // --------------------------------------------------------------------

    wire [15:0] o_block_id;
    wire        o_blk_soft_rst;
    wire [15:0] o_frame_in_block;

    fso_deframer #(
        .W                  (W),
        .PAYLOAD_WORDS      (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX  (64)
    ) u_fso_deframer (
        .clk                (clk),
        .rst_n              (rst_n),
        .i_link_up          (o_bit_locked),
        .i_rx_data          (aligned_data),         
        .i_rx_valid         (aligned_valid),  
        .scrambler_en       (USE_SCRAM),
        .o_realign_req      (realign_req),
        .o_frame_start      (frame_start),
        .o_frame_index      (rx_frame_index),


        .o_block_id         (o_block_id),
        .o_blk_soft_rst     (o_blk_soft_rst),
        .o_frame_in_block   (o_frame_in_block),

        .o_payload_data     (rx_payload_data),
        .o_payload_valid    (rx_payload_valid)
    );



    wire [31:0] rx_prbs_data;
    wire prbs_match = ~|rx_prbs_data;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (1),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (32)
    ) prbs_chk_inst (
        .RST                (~rst_n), // 使用 GTH TX 激活信号
        .CLK                (clk), // 使用 GTH TX 时钟
        .DATA_IN            (rx_payload_data),
        .EN                 (rx_payload_valid&&PRBS_MODE), //  修改: 由 Frame Gen 反压
        .DATA_OUT           (rx_prbs_data)      //  连接到 Frame Gen
    );


    // --------------------------------------------------------------------
    // 仿真监视
    // --------------------------------------------------------------------
    always @(posedge clk) begin
        if (frame_start) begin
            $display("[%0t ns] FRAME_START: RX_FRAME_INDEX=%0d (TX 侧当前为 %0d)",
                     $time, rx_frame_index, tx_frame_index);
            // 检查数据是否一致
            if (rx_payload_data !== (payload_data - PAYLOAD_WORDS)) begin
                 $error("[%0t ns] !!! DATA MISMATCH !!!", $time);
            end
        end
    end
    
    initial begin
        $dumpfile("tb_fso_system.vcd");
        $dumpvars(0, tb_fso_system);
    end

endmodule

// // ------------------------------------------------------------------------
// // 简化版信道模型： 32bit 循环位移 + RXSLIDE 控制偏移量
// // ------------------------------------------------------------------------
module channel_model #(
    parameter integer W = 32
)(
    input              clk,
    input              rst_n,
    
    input      [W-1:0] i_tx_data,
    input              i_tx_valid,
    
    input              i_rxslide,   // 来自 Aligner 的命令
    
    output reg [W-1:0] o_rx_data,
    output reg         o_rx_valid
);
    localparam integer BIT_OFFSET_W = $clog2(W);

    // 当前的 bit 偏移量：0..W-1
    reg [BIT_OFFSET_W-1:0] bit_offset;

    // 计算循环右移 r bit 的函数（右移 r，相当于采样相位超前 r bit）
    function [W-1:0] rotate_right;
        input [W-1:0] d;
        input [BIT_OFFSET_W-1:0] r;
        begin
            rotate_right = (d >> r) | (d << (W - r));
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            bit_offset <= $urandom_range(0, W-1);  // 上电一个随机偏移
            o_rx_data  <= {W{1'b0}};
            o_rx_valid <= 1'b0;
        end else begin
            // 收到 aligner 的 RXSLIDE 命令，就把偏移量 +1 (mod W)
            if (i_rxslide) begin
                if (bit_offset == W-1)
                    bit_offset <= 0;
                else
                    bit_offset <= bit_offset + 1'b1;
            end

            // 直接对 TX 的 32bit 做循环位移
            if (i_tx_valid) begin
                o_rx_data  <= rotate_right(i_tx_data, bit_offset);
                o_rx_valid <= 1'b1;
            end else begin
                o_rx_valid <= 1'b0;
            end
        end
    end

endmodule


// ------------------------------------------------------------------------
// 信道模型 (带误码 + 衰落)
// ------------------------------------------------------------------------

// module channel_model #(
//     parameter integer W = 32,
//     // 每 bit 的翻转“倒数概率”，约等于 1 / BIT_ERR_INV_PROB
//     parameter integer BIT_ERR_INV_PROB   = 20000,
//     // 每个 word 触发一次衰落的“倒数概率”，约等于 1 / FADE_INV_PROB
//     parameter integer FADE_INV_PROB      = 3000,
//     // 单次衰落的最小/最大持续 word 数
//     parameter integer FADE_LEN_MIN       = 20,
//     parameter integer FADE_LEN_MAX       = 80
// )
// (
//     input              clk,
//     input              rst_n,
    
//     input      [W-1:0] i_tx_data,
//     input              i_tx_valid,
    
//     input              i_rxslide,   // 来自 Aligner 的命令
    
//     output reg [W-1:0] o_rx_data,
//     output reg         o_rx_valid
// );

//     localparam integer BIT_OFFSET_W = $clog2(W);

//     // 当前的 bit 偏移量：0..W-1
//     reg [BIT_OFFSET_W-1:0] bit_offset;

//     // 衰落相关
//     reg                     fading;
//     integer                 fade_cnt;

//     // 中间变量：旋转后的数据、加噪后的数据
//     reg [W-1:0] rotated_word;
//     reg [W-1:0] noisy_word;

//     integer j;

//     // 计算循环右移 r bit 的函数（右移 r，相当于采样相位超前 r bit）
//     function [W-1:0] rotate_right;
//         input [W-1:0] d;
//         input [BIT_OFFSET_W-1:0] r;
//         begin
//             rotate_right = (d >> r) | (d << (W - r));
//         end
//     endfunction

//     always @(posedge clk) begin
//         if (!rst_n) begin
//             bit_offset <= $urandom_range(0, W-1);  // 上电一个随机偏移
//             o_rx_data  <= {W{1'b0}};
//             o_rx_valid <= 1'b0;
//             fading     <= 1'b0;
//             fade_cnt   <= 0;
//         end else begin
//             // 收到 aligner 的 RXSLIDE 命令，就把偏移量 +1 (mod W)
//             if (i_rxslide) begin
//                 if (bit_offset == W-1)
//                     bit_offset <= 0;
//                 else
//                     bit_offset <= bit_offset + 1'b1;
//             end

//             // 默认无效
//             o_rx_valid <= 1'b0;

//             if (i_tx_valid) begin
//                 // 1) 先做循环位移 (模拟 GTH 的 bit 边界)
//                 rotated_word = rotate_right(i_tx_data, bit_offset);

//                 // 2) 再在 rotated_word 上做随机 bit 翻转 (模拟轻微误码)
//                 noisy_word = rotated_word;
//                 for (j = 0; j < W; j = j + 1) begin
//                     if (BIT_ERR_INV_PROB > 0) begin
//                         if ($urandom_range(0, BIT_ERR_INV_PROB-1) == 0)
//                             noisy_word[j] = ~noisy_word[j];
//                     end
//                 end

//                 // 3) 更新衰落状态机
//                 if (!fading) begin
//                     // 当前不在衰落，有小概率触发一次衰落
//                     if (FADE_INV_PROB > 0 && $urandom_range(0, FADE_INV_PROB-1) == 0) begin
//                         fading   <= 1'b1;
//                         // 随机一个衰落长度
//                         fade_cnt <= $urandom_range(FADE_LEN_MIN, FADE_LEN_MAX);
//                     end
//                 end else begin
//                     // 正在衰落
//                     if (fade_cnt <= 0) begin
//                         fading   <= 1'b0;   // 衰落结束
//                     end else begin
//                         fade_cnt <= fade_cnt - 1;
//                     end
//                 end

//                 // 4) 根据是否衰落决定输出
//                 if (fading) begin
//                     // 衰落期间：输出“垃圾数据”但保持 valid=1
//                     // 你可以选择全 0、全 1 或随机，这里用随机更接近 FSO 中的乱跳
//                     o_rx_data  <= $urandom;
//                     o_rx_valid <= 1'b1;
//                 end else begin
//                     // 正常期间：输出“旋转+少量误码”的数据
//                     o_rx_data  <= noisy_word;
//                     o_rx_valid <= 1'b1;
//                 end
//             end
//         end
//     end

// endmodule