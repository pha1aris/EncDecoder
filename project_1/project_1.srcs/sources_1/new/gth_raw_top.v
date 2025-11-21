`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: gth_raw_wrapper
// Description: Xilinx UltraScale GTH Raw Mode 纯净封装
//              包含: IBUFDS_GTE4, BUFG_GT, Reset Sync, GTH IP
//              不包含: 任何协议逻辑 (Framer/Deframer/PRBS)
//////////////////////////////////////////////////////////////////////////////////

module gth_raw_top #(
    parameter integer W = 32
)(
    // =========================================================================
    // 1. 物理层接口 (PCB IO)
    // =========================================================================
    input  wire        sys_clk_p,       // 板载系统时钟 (用于状态机/复位)
    input  wire        sys_clk_n,
    input  wire        sys_rst_n,       // 物理按键复位 (低有效)

    output wire [1:0]  tx_disable,      // SFP 光模块禁用控制

    // GTH 参考时钟 (差分)
    input  wire        mgtrefclk0_x1y1_p,
    input  wire        mgtrefclk0_x1y1_n,

    // GTH 串行数据 (差分)
    input  wire        gthrxp_in,
    input  wire        gthrxn_in,
    output wire        gthtxp_out,
    output wire        gthtxn_out,

    // =========================================================================
    // 2. 用户逻辑接口 (FPGA Internal Logic)
    // =========================================================================
    
    // --- 通用控制 ---
    input  wire [2:0]  i_loopback,      // 000:Normal, 001:PCS Loopback
    output wire        o_pll_locked,    // 系统时钟PLL锁定指示

    // --- 发送端接口 (TX Domain) ---
    output wire        o_tx_clk,        // [输出] TX用户时钟 (用于驱动你的发送逻辑)
    output wire        o_tx_rst_n,      // [输出] TX复位信号 (低有效, 已同步)
    output wire        o_tx_done,       // [输出] TX初始化完成 (PMA Reset Done)
    
    input  wire [W-1:0] i_tx_data,      // [输入] 发送数据 (raw data)

    // --- 接收端接口 (RX Domain) ---
    output wire        o_rx_clk,        // [输出] RX用户时钟 (恢复时钟)
    output wire        o_rx_rst_n,      // [输出] RX复位信号 (低有效, 已同步)
    output wire        o_rx_done,       // [输出] RX初始化完成 (PMA Reset Done)
    output wire        o_cdr_stable,    // [输出] CDR 频率锁定指示
    
    output wire [W-1:0] o_rx_data,      // [输出] 接收数据 (raw data)
    
    input  wire        i_rx_slide       // [输入] 比特滑动控制 (来自你的 Bit Aligner)
);

    // =========================================================================
    // 0. 基础配置
    // =========================================================================
    assign tx_disable = 2'b00; // 强制开启光模块
    assign o_tx_clk   = txusrclk2;
    assign o_rx_clk   = rxusrclk2;
    
    // 内部信号
    wire        freerun_clk;
    wire        gtrefclk0;
    wire        txusrclk2, rxusrclk2;
    wire [0:0]  txpmaresetdone, rxpmaresetdone;
    wire [0:0]  txoutclk_out, rxoutclk_out;
    wire [0:0]  gtwiz_reset_rx_cdr_stable_out;
    
    assign o_tx_done    = txpmaresetdone;
    assign o_rx_done    = rxpmaresetdone;
    assign o_cdr_stable = gtwiz_reset_rx_cdr_stable_out;

    // =========================================================================
    // 1. 时钟与复位基础电路
    // =========================================================================
    
    // 系统时钟 PLL (产生自由运行时钟)
    clk_wiz_2 u_clk_wiz (
        .clk_out1 (freerun_clk),
        .reset    (~sys_rst_n), 
        .locked   (o_pll_locked),
        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );

    // GTH 参考时钟缓冲 (IBUFDS_GTE4)
    IBUFDS_GTE4 #(
        .REFCLK_EN_TX_PATH (1'b0),
        .REFCLK_HROW_CK_SEL(2'b00),
        .REFCLK_ICNTL_RX   (2'b00)
    ) u_ibufds_refclk (
        .I(mgtrefclk0_x1y1_p), .IB(mgtrefclk0_x1y1_n), .CEB(1'b0), .O(gtrefclk0), .ODIV2()
    );

    // GTH 总复位同步 (异步按键 -> 同步信号)
    wire gth_reset_in_raw = ~(sys_rst_n & o_pll_locked);
    wire gth_reset_in_sync;
    
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(4),    
        .RST_ACTIVE_HIGH(1)
    ) u_rst_sync_main (
        .src_arst(gth_reset_in_raw),
        .dest_clk(freerun_clk),
        .dest_arst(gth_reset_in_sync)
    );

    // =========================================================================
    // 2. GTH IP Core 实例化
    // =========================================================================

    // 时钟缓冲 (BUFG_GT) - 必须组件
    BUFG_GT u_bufg_tx (.I(txoutclk_out), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(txusrclk2));
    BUFG_GT u_bufg_rx (.I(rxoutclk_out), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(rxusrclk2));

    gtwizard_ultrascale_0 u_gth (
        // 时钟与复位
        .gtwiz_reset_clk_freerun_in      (freerun_clk),
        .gtwiz_reset_all_in              (gth_reset_in_sync),
        
        // 用户时钟回环 (Active 信号)
        .gtwiz_userclk_tx_active_in      (txpmaresetdone),
        .gtwiz_userclk_rx_active_in      (rxpmaresetdone),
        
        // 状态输出
        .gtwiz_reset_rx_cdr_stable_out   (gtwiz_reset_rx_cdr_stable_out),
        .txpmaresetdone_out              (txpmaresetdone),
        .rxpmaresetdone_out              (rxpmaresetdone),
        
        // 数据接口
        .gtwiz_userdata_tx_in            (i_tx_data),
        .gtwiz_userdata_rx_out           (o_rx_data),
        
        // 物理时钟接口
        .gtrefclk01_in                   (gtrefclk0),
        .txoutclk_out(txoutclk_out), .rxoutclk_out(rxoutclk_out),
        .txusrclk_in(txusrclk2),     .txusrclk2_in(txusrclk2),
        .rxusrclk_in(rxusrclk2),     .rxusrclk2_in(rxusrclk2),
        
        // 串行 IO
        .gthrxp_in(gthrxp_in),       .gthrxn_in(gthrxn_in),
        .gthtxp_out(gthtxp_out),     .gthtxn_out(gthtxn_out),
        
        // 控制接口
        .loopback_in                     (i_loopback),
        .rxslide_in                      (i_rx_slide),
        
        // 默认配置 (未使用端口置0)
        .rxcdrhold_in(0), .rxlpmen_in(0), 
        .txdiffctrl_in(5'b11000), .txpostcursor_in(0), .txprecursor_in(0), 
        .gtwiz_reset_tx_pll_and_datapath_in(0), .gtwiz_reset_tx_datapath_in(0),
        .gtwiz_reset_rx_pll_and_datapath_in(0), .gtwiz_reset_rx_datapath_in(0)
    );

    // =========================================================================
    // 3. 用户复位同步生成 (User Reset Generation)
    // =========================================================================
    // 这里的复位信号已经同步到 o_tx_clk / o_rx_clk，可以直接给逻辑使用

    // --- TX 复位 (低有效) ---
    // 当 GTH 初始化完成(done=1)时，释放复位(rst_n=1)
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(2),
        .RST_ACTIVE_HIGH(0) // src_arst=0时为复位状态
    ) u_rst_sync_tx (
        .src_arst(txpmaresetdone), // done=0 -> rst_out=0; done=1 -> rst_out=1
        .dest_clk(txusrclk2),
        .dest_arst(o_tx_rst_n)
    );

    // --- RX 复位 (低有效) ---
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(2),
        .RST_ACTIVE_HIGH(0)
    ) u_rst_sync_rx (
        .src_arst(rxpmaresetdone),
        .dest_clk(rxusrclk2),
        .dest_arst(o_rx_rst_n)
    );

endmodule