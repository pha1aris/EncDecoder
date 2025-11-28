`timescale 1ns / 1ps

module rx_chain_top #(
    parameter integer W = 32
)(
    // 系统时钟 (用于 Core Logic / ILA)
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,

    // GTH 参考时钟
    input  wire         mgtrefclk_p,
    input  wire         mgtrefclk_n,

    // GTH 串行接口
    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out, // 即使是 RX 测试，通常也连接 TX 保持物理链路活跃
    output wire         gthtxn_out,

    // 状态 LED
    output wire         led_pll_locked,
    output wire         led_rx_active,
    output wire         led_bit_locked, // Bit Aligner 锁定
    output wire         led_prbs_error, // 亮起代表检测到误码
    output wire         led_heartbeat
);
    
    // Core Clock 生成 (假设 100MHz)
    wire core_clk_100m;
    IBUFDS u_sys_clk_buf (.I(sys_clk_p), .IB(sys_clk_n), .O(core_clk_100m));

    wire pll_locked;
    wire rx_usr_clk;    // GTH 恢复出来的时钟 (Line Clock)
    wire rx_usr_rst_n;  // GTH 输出的 RX 复位信号
    wire rx_active;
    wire cdr_stable;
    wire [W-1:0] rx_data_gth;
    wire         rxslide_req; // 来自 FEC 的滑动请求
    wire [W-1:0] tx_idle_data = 32'h07070707; 

    gth_raw_top #(
        .W (32)
    ) u_gth_top (
        .sys_clk_p      (sys_clk_p),
        .sys_clk_n      (sys_clk_n),
        .sys_rst_n      (sys_rst_n),
        .tx_disable     (), // 如果有光模块控制引脚，可在此连接

        .mgtrefclk_p    (mgtrefclk_p),
        .mgtrefclk_n    (mgtrefclk_n),

        .gthrxp_in      (gthrxp_in),
        .gthrxn_in      (gthrxn_in),
        .gthtxp_out     (gthtxp_out),
        .gthtxn_out     (gthtxn_out),

        .i_loopback     (3'b000), // 000: Normal, 010: Near-End Loopback
        .o_pll_locked   (pll_locked),

        // TX (仅作为 Dummy 驱动)
        .o_tx_clk       (), 
        .o_tx_rst_n     (),
        .o_tx_done      (),
        .o_tx_active    (),
        .i_tx_data      (tx_idle_data),

        // RX 接口
        .o_rx_clk       (rx_usr_clk),   // -> 连接 FEC line_clk
        .o_rx_rst_n     (rx_usr_rst_n), // -> 连接 FEC rst_n
        .o_rx_done      (),             // PMA 复位完成，可用于调试
        .o_rx_active    (rx_active),    
        .o_cdr_stable   (cdr_stable),   // -> 连接 FEC
        .o_rx_data      (rx_data_gth),  // -> 连接 FEC
        .i_rx_slide     (rxslide_req)   // <- 来自 FEC 的对其请求
    );

    
    wire [7:0]  dec_data_8b;
    wire        dec_valid;
    wire        bit_locked;
    wire [15:0] rx_frame_index;
    wire [15:0] rx_block_id;
    wire [15:0] rx_frame_in_blk;

    // fec_rx 内部包含 Bit Aligner -> Async FIFO -> Deframer -> RS Decoder
    fec_rx #(
        .W                (32),
        .PAYLOAD_WORDS    (16),
        .RS_N             (255),
        .INTLV_D          (64),    // 必须与发送端保持一致！
        .INTLV_N          (255)
    ) u_fec_rx (
        .line_clk         (rx_usr_clk),    // GTH 恢复时钟
        .core_clk         (core_clk_100m), // 系统处理时钟
        .rst_n            (rx_usr_rst_n),  // GTH 复位释放后启动

        // GTH 接口
        .i_rx_data        (rx_data_gth),
        .i_rx_valid       (1'b1),          // GTH Raw 数据始终有效
        .rx_reset_done    (rx_usr_rst_n),  // 使用复位信号作为 reset_done
        .rx_cdr_stable    (cdr_stable),
        .scrambler_en     (1'b0),          // 暂时关闭加扰

        // 输出 (8-bit)
        .o_data           (dec_data_8b),
        .o_valid          (dec_valid),
        .i_data_ready     (1'b1),          // PRBS Checker 始终准备好接收

        // 控制与调试
        .o_rxslide        (rxslide_req),   // ★ 关键：控制 GTH 滑动
        .o_bit_locked     (bit_locked),
        .o_frame_index    (rx_frame_index),
        .o_block_id       (rx_block_id),
        .o_frame_in_block (rx_frame_in_blk)
    );

    
    wire [7:0] prbs_err_vec; // 每一位的错误指示
    wire       prbs_err_flag = |prbs_err_vec; // 只要有任意一位错，置1
    reg [31:0] err_count;
    
    
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1), // ★ Check Mode
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)  // ★ 8-bit
    ) u_prbs_chk (
        .RST      (~rx_usr_rst_n), // 模块内部高复位
        .CLK      (core_clk_100m), // 与 FEC 输出时钟一致
        .DATA_IN  (dec_data_8b),   // 接收到的数据
        .EN       (dec_valid),     // 仅在有效数据时检查
        .DATA_OUT (prbs_err_vec)   // 输出错误向量
    );

    // 简单的错误计数器 (为了防止溢出，可以加饱和逻辑，这里简单循环)
    always @(posedge core_clk_100m or negedge rx_usr_rst_n) begin
        if (!rx_usr_rst_n) begin
            err_count <= 0;
        end else if (dec_valid && prbs_err_flag) begin
            err_count <= err_count + 1;
        end
    end

    // 错误状态锁存 (LED 用，一旦出错就亮住，直到复位)
    reg err_latched;
    always @(posedge core_clk_100m or negedge rx_usr_rst_n) begin
        if (!rx_usr_rst_n) 
            err_latched <= 1'b0;
        else if (dec_valid && prbs_err_flag) 
            err_latched <= 1'b1;
    end

    
    assign led_pll_locked = pll_locked;
    assign led_rx_active  = rx_active;
    assign led_bit_locked = bit_locked;
    assign led_prbs_error = err_latched; // 红色 LED，亮了说明有错

    reg [26:0] beat_cnt;
    always @(posedge core_clk_100m) beat_cnt <= beat_cnt + 1;
    assign led_heartbeat = beat_cnt[26];

    /*
    ila_rx_debug u_ila_rx (
        .clk    (core_clk_100m),
        .probe0 (dec_data_8b),     // [7:0]  最终解码数据
        .probe1 (dec_valid),       // [0:0]
        .probe2 (prbs_err_vec),    // [7:0]  PRBS 错误向量
        .probe3 (err_count),       // [31:0] 累计错误数
        .probe4 (bit_locked),      // [0:0]  对齐锁定状态
        .probe5 (rx_frame_index),  // [15:0]
        .probe6 (rx_frame_in_blk), // [15:0]
        .probe7 (rxslide_req)      // [0:0]  (如果需要抓line_clk信号，需要第二个ILA或跨时钟)
    );
    
    // 如果想看 GTH 原始数据，需要另一个 ILA 在 line_clk 域
    ila_gth_raw u_ila_gth (
        .clk    (rx_usr_clk),
        .probe0 (rx_data_gth),     // [31:0]
        .probe1 (rxslide_req),     // [0:0]
        .probe2 (cdr_stable)
    );
    */

endmodule