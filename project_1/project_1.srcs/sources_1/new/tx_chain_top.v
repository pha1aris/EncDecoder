`timescale 1ns/1ps

module tx_chain_top #(
   parameter integer W = 32
)(
    // 系统时钟 (用于各种逻辑控制/VIO/ILA)
    input  wire         sys_clk_p,
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,  // 板载复位按键

    // GTH 参考时钟
    input  wire         mgtrefclk_p,
    input  wire         mgtrefclk_n,

    // GTH 差分串行口
    output wire         gthtxp_out,
    output wire         gthtxn_out,
    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    
    // 光模块控制
    output wire [1:0]   tx_disable,

    // 状态 LED
    output wire         led_pll_locked,
    output wire         led_tx_active,
    output wire         led_heartbeat
);

    // =========================================================
    // 1. 信号声明
    // =========================================================
    wire        tx_usr_clk;     // GTH 输出给 FPGA 逻辑的时钟 (32bit域)
    wire        tx_usr_rst_n;   // GTH 输出的复位完成信号
    wire        tx_active;
    wire        pll_locked;

    wire        core_clk_100m; 

    // PRBS -> FEC 接口 (8-bit)
    wire [7:0]  prbs_data;
    wire        prbs_valid;   // 我们让 PRBS 一直由 ready 驱动
    wire        fec_ready;    // FEC 反压 PRBS

    // FEC -> GTH 接口 (32-bit)
    wire [W-1:0] tx_data_gth;
    wire         tx_valid_gth; // 注意：GTH Raw 接口通常没有 valid 输入，需要填充 IDLE
    wire [15:0]  tx_frame_idx;

    
    wire clk_100m_buf;
    IBUFDS u_sys_clk_buf (.I(sys_clk_p), .IB(sys_clk_n), .O(clk_100m_buf));
    assign core_clk_100m = clk_100m_buf; 

    // LED 状态
    assign led_pll_locked = pll_locked;
    assign led_tx_active  = tx_active;

    // 心跳灯 (由 TX User Clock 驱动，证明时钟活着)
    reg [26:0] beat_cnt;
    always @(posedge tx_usr_clk) beat_cnt <= beat_cnt + 1;
    assign led_heartbeat = beat_cnt[26];

    wire prbs_en = fec_ready & tx_usr_rst_n;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0), // Generate Mode
        .INV_PATTERN (0),
        .POLY_LENGHT (7), // PRBS7
        .POLY_TAP    (6),
        .NBITS       (8)  // ★ 关键：修改为 8-bit 以匹配 FEC 输入
    ) u_prbs_gen (
        .RST      (~tx_usr_rst_n), // 模块内部高复位
        .CLK      (tx_usr_clk),    // 使用 GTH 用户时钟
        .DATA_IN  (8'd0),          // Gen 模式下用于注入错误，这里置 0
        .EN       (prbs_en),       // 流控
        .DATA_OUT (prbs_data)
    );
    
    assign prbs_valid = prbs_en; // 如果使能了，输出就有效

    fec_tx #(
        .W                (32),
        .PAYLOAD_WORDS    (16),
        .RS_K             (229),
        .RS_N             (255),
        .INTLV_D          (64),   // 联调先用小 D
        .INTLV_N          (255),
        .FRAMES_PER_BLOCK (255)
    ) u_fec_tx (
        // 时钟分配
        .line_clk         (tx_usr_clk),    // GTH 的用户时钟作为线路时钟
        .core_clk         (core_clk_100m), // 系统时钟作为核心处理时钟
        
        // 复位 (低有效)
        .rst_n            (tx_usr_rst_n),  // GTH 准备好后才释放 FEC 复位
        
        // 设置
        .scrambler_en     (1'b0),          // 此时暂时关闭加扰以便观察 PRBS
        
        // 8-bit 输入 (来自 PRBS)
        .i_data           (prbs_data),
        .i_valid          (prbs_valid),
        .i_ready          (fec_ready),
        
        // 32-bit 输出 (去往 GTH)
        // 注意：连接 _line 后缀的信号，这些才是同步到 line_clk 的
        .o_tx_data        (), 
        .o_tx_valid       (), 
        .o_tx_data_line   (tx_data_gth),
        .o_tx_valid_line  (tx_valid_gth), // GTH Raw 不看这个，但我们可以观察
        .o_tx_frame_index (tx_frame_idx)
    );

    // =========================================================
    // 5. GTH Raw Wrapper
    // =========================================================
    
    gth_raw_top #(
        .W (32)
    ) u_gth_top (
        .sys_clk_p      (sys_clk_p),
        .sys_clk_n      (sys_clk_n),
        .sys_rst_n      (sys_rst_n),
        .tx_disable     (tx_disable),
        
        .mgtrefclk_p    (mgtrefclk_p),
        .mgtrefclk_n    (mgtrefclk_n),
        
        .gthrxp_in      (gthrxp_in),
        .gthrxn_in      (gthrxn_in),
        .gthtxp_out     (gthtxp_out),
        .gthtxn_out     (gthtxn_out),
        
        .i_loopback     (3'b000),      // 000: Normal, 010: Near-End PMA Loopback (自环测试可用)
        .o_pll_locked   (pll_locked),
        
        // TX 用户接口
        .o_tx_clk       (tx_usr_clk),  // ★ 输出时钟给上面用
        .o_tx_rst_n     (tx_usr_rst_n),// ★ 输出复位给上面用
        .o_tx_done      (),
        .o_tx_active    (tx_active),
        
        // 数据输入：直接连 data，因为 fec_tx 内部已经处理了 IDLE 填充
        .i_tx_data      (tx_data_gth), 
        
        // RX 接口 (暂时悬空或接 ILA)
        .o_rx_clk       (),
        .o_rx_rst_n     (),
        .o_rx_done      (),
        .o_rx_active    (),
        .o_cdr_stable   (),
        .o_rx_data      (),
        .i_rx_slide     (1'b0)
    );

    // =========================================================
    // 6. ILA 
    // =========================================================
    /*
    ila_0 u_ila_tx (
        .clk    (tx_usr_clk),
        .probe0 (prbs_data),     // [7:0]
        .probe1 (prbs_valid),    // [0:0]
        .probe2 (fec_ready),     // [0:0]
        .probe3 (tx_data_gth),   // [31:0]
        .probe4 (tx_valid_gth),  // [0:0]
        .probe5 (tx_frame_idx),  // [15:0]
        .probe6 (tx_active)      // [0:0]
    );
    */

endmodule