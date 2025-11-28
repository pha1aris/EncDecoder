`timescale 1ns / 1ps

module fso_tx_top(
    input  wire        sys_clk_p,       // 板载系统时钟
    input  wire        sys_clk_n,
    input  wire        sys_rst_n,       // 物理按键复位 (低有效)
    output wire [1:0]  tx_disable,      // SFP 光模块禁用控制
    
    input   wire       mgtrefclk0_x1y1_p,    
    input   wire       mgtrefclk0_x1y1_n,
    // GTH 串行数据
    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out
);

    wire        tx_usr_clk;      // GTH 用户时钟 (32-bit域)
    wire        tx_active;       // TX 初始化完成
    wire        tx_rst_n_sync;   // 同步后的复位 (低有效)
    wire        logic_rst = ~tx_rst_n_sync;
    wire [7:0]  prbs_data_raw;
    wire [7:0]  prbs_data_with_err;
    wire        fec_ready;       // FEC 反压信号
    wire [31:0] fec_tx_data;     // FEC 输出数据
    wire        fec_tx_valid;    // FEC 输出有效
    
    assign o_link_up = tx_active;

    wire scrambler_en ;
    assign scrambler_en = 1;

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
        .INTLV_D          (64),  // ★ 与仿真参数一致
        .INTLV_N          (255),
        .FRAMES_PER_BLOCK (255)
    ) u_fec_tx (
        
        .line_clk         (tx_usr_clk), 
        .core_clk         (tx_usr_clk), 
        .rst_n            (tx_rst_n_sync),

        .scrambler_en     (scrambler_en),
        // 输入
        .i_data           (prbs_data_raw),
        .i_valid          (1'b1),       // PRBS 始终有数据 (受 ready 控制)
        .i_ready          (fec_ready),  // 输出给 PRBS

        // 输出
        .o_tx_data_line   (fec_tx_data),
        .o_tx_valid_line  (fec_tx_valid),
        .o_tx_frame_index ()            // 调试用，可悬空
    );

    wire [31:0] gth_tx_data = fec_tx_valid ? fec_tx_data : 32'h00000000;

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

        .i_loopback       (3'b000),     // 000 = 正常模式
        .o_pll_locked     (gt_pll_locked),           
        
        .o_tx_clk         (tx_usr_clk),
        .o_tx_rst_n       (tx_rst_n_sync),
        .o_tx_active      (tx_active),
        .o_tx_done        (),
        .i_tx_data        (gth_tx_data),

        .o_rx_clk         (),
        .o_rx_rst_n       (),
        .o_rx_done        (),
        .o_rx_active      (gt_rx_active),
        .o_cdr_stable     (gt_cdr_stable),
        .o_rx_data        (gt_rx_data),
        .i_rx_slide       (1'b0)
    );

endmodule