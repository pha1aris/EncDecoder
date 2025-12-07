`timescale 1ns / 1ps

module fso_tx_top(
    input  wire        sys_clk_p,       // 板载系统时钟
    input  wire        sys_clk_n,
    input  wire        sys_rst_n,       // 物理按键复位 (低有效)
    output wire [1:0]  tx_disable,      // SFP 光模块禁用控制
    
    input  wire        mgtrefclk0_x1y1_p,    
    input  wire        mgtrefclk0_x1y1_n,

    // GTH 串行数据
    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out,

    // 调试 / LED
    output wire        o_tx_active      // ★ 新增：TX 链路 up 指示
);

    //================================================================
    // 1. GTH 时钟 & 复位
    //================================================================
    wire        tx_usr_clk;      // GTH 用户时钟 (32-bit域)
    wire        tx_active;       // TX 初始化完成
    wire        tx_rst_n_sync;   // 同步后的复位 (低有效)

    // 对于 PRBS/FEC 内部逻辑，建议用“TX active”做软复位
    wire        logic_rst = ~tx_active;  // ★ 修改：用 tx_active 来复位 PRBS

    //================================================================
    // 2. PRBS 8bit 生成 & FEC TX 编码
    //================================================================
    wire [7:0]  prbs_data_raw;
    wire        fec_ready;       // FEC 反压信号
    wire [31:0] fec_tx_data;     // FEC 输出数据
    wire        fec_tx_valid;    // FEC 输出有效

    wire        scrambler_en = 1'b1; // TX 端启用扰码，RX 端要一致

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0), // 0 = 生成模式
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen (
        .RST      (logic_rst),
        .CLK      (tx_usr_clk),
        .DATA_IN  (8'd0),
        .EN       (fec_ready),   // 受 FEC 流控控制
        .DATA_OUT (prbs_data_raw)
    );

    fec_tx #(
        .W                (32),
        .PAYLOAD_WORDS    (16),
        .RS_K             (229),
        .RS_N             (255),
        .INTLV_D          (64),    // ★ 与 RX 端一致
        .INTLV_N          (255),
        .FRAMES_PER_BLOCK (255)
    ) u_fec_tx (
        .line_clk         (tx_usr_clk), 
        .core_clk         (tx_usr_clk), 
        .rst_n            (tx_rst_n_sync),

        .scrambler_en     (scrambler_en),

        // 上游 8bit PRBS
        .i_data           (prbs_data_raw),
        .i_valid          (1'b1),       // PRBS 始终“想”发，真流控由 i_ready 决定
        .i_ready          (fec_ready),  // 输出给 PRBS

        // 输出给 GTH TX 的 32bit 数据（经过 Store & Forward FIFO）
        .o_tx_data        (),           // 仅内部用
        .o_tx_valid       (),           // 仅内部用
        .o_tx_data_line   (fec_tx_data),
        .o_tx_valid_line  (fec_tx_valid),
        .o_tx_frame_index ()            // 调试用，可悬空
    );

    // GTH 用户侧并行数据
    wire [31:0] gth_tx_data = fec_tx_valid ? fec_tx_data : 32'h0000_0000;

    //================================================================
    // 3. GTH 物理层实例
    //================================================================
    // 根据 Xilinx 文档，loopback[2:0] 编码类似：
    // 000 = normal
    // 010/100 = near-end / far-end loopback
    // 这里给一个参数方便你改
    localparam [2:0] GTH_LOOPBACK_MODE = 3'b000; // 单板光纤环回：用 000; 内部环回：改成 010/100

    wire gt_pll_locked;
    wire gt_rx_active;
    wire [31:0] gt_rx_data;
    wire gt_cdr_stable;

    gth_raw_top #(
        .W(32)
    ) u_gth_phy (
        .sys_clk_p        (sys_clk_p),
        .sys_clk_n        (sys_clk_n),
        .sys_rst_n        (sys_rst_n),
        .tx_disable       (tx_disable),
        
        .mgtrefclk0_x1y1_p(mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n(mgtrefclk0_x1y1_n),
        
        .gthrxp_in        (gthrxp_in),
        .gthrxn_in        (gthrxn_in),
        .gthtxp_out       (gthtxp_out),
        .gthtxn_out       (gthtxn_out),

        .i_loopback       (GTH_LOOPBACK_MODE),

        .o_pll_locked     (gt_pll_locked),            
        
        .o_tx_clk         (tx_usr_clk),
        .o_tx_rst_n       (tx_rst_n_sync),
        .o_tx_active      (tx_active),
        .o_tx_done        (),          // 未用
        .i_tx_data        (gth_tx_data),

        .o_rx_clk         (),          // TX-only 测试暂不使用 RX
        .o_rx_rst_n       (),
        .o_rx_done        (),
        .o_rx_active      (gt_rx_active),
        .o_cdr_stable     (gt_cdr_stable),
        .o_rx_data        (gt_rx_data),
        .i_rx_slide       (1'b0)
    );

    // TX 链路 up 指示
    assign o_tx_active = tx_active;

endmodule
