`timescale 1ns / 1ps

module gth_raw_top #(
    parameter integer W = 32
)(
    // 1. 时钟与复位 (外部输入)
    input   wire          freerun_clk,      // [输入] 自由运行始终 (50M/100M)
    input   wire          gth_reset_all,    // [输入] GTH 全局复位 (高有效)
    
    // 2. 物理接口
    output  wire [1:0]    tx_disable,       
    input   wire          mgtrefclk0_x1y1_p,    
    input   wire          mgtrefclk0_x1y1_n,
    input   wire          gthrxp_in,
    input   wire          gthrxn_in,
    output  wire          gthtxp_out,
    output  wire          gthtxn_out,
    
    // 3. 状态指示
    input   wire [2:0]    i_loopback,       
    output  wire          o_pll_locked,     // 这里固定输出 1 (因 PLL 已移至外部)

    // 4. TX 用户接口
    output  wire          o_tx_clk,         
    output  wire          o_tx_rst_n,       
    output  wire          o_tx_done,        
    output  wire          o_tx_active,      
    input   wire [W-1:0]  i_tx_data,        

    // 5. RX 用户接口
    output  wire          o_rx_clk,         
    output  wire          o_rx_rst_n,       
    output  wire          o_rx_done,        
    output  wire          o_rx_active,      
    output  wire          o_cdr_stable,     
    output  wire [W-1:0]  o_rx_data,        
    input   wire          i_rx_slide        
);

    assign tx_disable = 2'b00; 
    assign o_tx_clk   = txusrclk2;
    assign o_rx_clk   = rxusrclk2;
    
    // 既然移除了内部 PLL，我们假设外部时钟是稳定的
    assign o_pll_locked = 1'b1; 

    wire        gtrefclk_int;
    wire        txusrclk2, rxusrclk2;
    
    wire [0:0]  txpmaresetdone_vec;
    wire [0:0]  rxpmaresetdone_vec;
    wire [0:0]  tx_active_vec;          
    wire [0:0]  rx_active_vec;          
    wire [0:0]  txoutclk_vec;
    wire [0:0]  rxoutclk_vec;
    wire [0:0]  cdr_stable_vec;
    wire [0:0]  gtpowergood_vec;
    
    assign o_tx_done    = txpmaresetdone_vec[0];
    assign o_rx_done    = rxpmaresetdone_vec[0];
    assign o_tx_active  = tx_active_vec[0]; 
    assign o_rx_active  = rx_active_vec[0]; 
    assign o_cdr_stable = cdr_stable_vec[0];

    // =========================================================================
    // 1. 参考时钟缓冲 (IBUFDS_GTE4)
    // =========================================================================
    IBUFDS_GTE4 #(
        .REFCLK_EN_TX_PATH (1'b0),
        .REFCLK_HROW_CK_SEL(2'b00),
        .REFCLK_ICNTL_RX   (2'b00)
    ) u_ibufds_refclk (
        .I(mgtrefclk0_x1y1_p), .IB(mgtrefclk0_x1y1_n), .CEB(1'b0), .O(gtrefclk_int), .ODIV2()
    );
    
    // =========================================================================
    // 2. 复位同步 (Synchronize gth_reset_all to freerun_clk)
    // =========================================================================
    wire gth_reset_in_sync;
    
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(4),    
        .RST_ACTIVE_HIGH(1) // 复位高有效
    ) u_rst_sync_main (
        .src_arst(gth_reset_all), // 使用外部输入的复位
        .dest_clk(freerun_clk),
        .dest_arst(gth_reset_in_sync)
    );

    // =========================================================================
    // 3. 用户时钟缓冲 (BUFG_GT)
    // =========================================================================
    BUFG_GT u_bufg_tx (.I(txoutclk_vec[0]), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(txusrclk2));
    BUFG_GT u_bufg_rx (.I(rxoutclk_vec[0]), .CE(1'b1), .CEMASK(0), .CLR(0), .CLRMASK(0), .DIV(0), .O(rxusrclk2));

    // =========================================================================
    // 4. GTH IP 实例化
    // =========================================================================
    gtwizard_ultrascale_0 u_gth (
        .gtwiz_reset_clk_freerun_in      ({1{freerun_clk}}),     
        .gtwiz_reset_all_in              ({1{gth_reset_in_sync}}), 
        
        .gtwiz_userclk_tx_active_in      (1'b1),                 
        .gtwiz_userclk_rx_active_in      (1'b1),                 
        
        .gtwiz_reset_rx_cdr_stable_out   (cdr_stable_vec),       
        .txpmaresetdone_out              (txpmaresetdone_vec),   
        .rxpmaresetdone_out              (rxpmaresetdone_vec),   
        
        // 状态信号
        .gtwiz_reset_tx_done_out         (tx_active_vec),        
        .gtwiz_reset_rx_done_out         (rx_active_vec),        
        .gtpowergood_out                 (gtpowergood_vec),      
        
        // 数据接口
        .gtwiz_userdata_tx_in            (i_tx_data),            
        .gtwiz_userdata_rx_out           (o_rx_data),            
        
        // 时钟接口
        .gtrefclk01_in                   ({1{gtrefclk_int}}),    // 确保这里连的是 01 (根据你之前的报错修正)
        
        // PLL 输出 (未连接)
        .qpll1outclk_out                 (),                     
        .qpll1outrefclk_out              (),                     

        // 时钟输出
        .txoutclk_out                    (txoutclk_vec),         
        .rxoutclk_out                    (rxoutclk_vec),         
        
        // 用户时钟输入
        .txusrclk_in                     ({1{txusrclk2}}),       
        .txusrclk2_in                    ({1{txusrclk2}}),       
        .rxusrclk_in                     ({1{rxusrclk2}}),       
        .rxusrclk2_in                    ({1{rxusrclk2}}),       
        
        // 串行 IO
        .gthrxp_in                       ({1{gthrxp_in}}),       
        .gthrxn_in                       ({1{gthrxn_in}}),       
        .gthtxp_out                      (gthtxp_out),           
        .gthtxn_out                      (gthtxn_out),           
        
        // 控制接口
        .loopback_in                     (i_loopback),           
        .rxslide_in                      ({1{i_rx_slide}}),      
        
        // 默认配置
        .rxcdrhold_in                    (1'b0), 
        .rxlpmen_in                      (1'b0), 
        .txdiffctrl_in                   (5'b11000),             
        .txpostcursor_in                 (5'b00000), 
        .txprecursor_in                  (5'b00000), 
        
        // 复位控制
        .gtwiz_reset_tx_pll_and_datapath_in (1'b0),
        .gtwiz_reset_tx_datapath_in         (1'b0),
        .gtwiz_reset_rx_pll_and_datapath_in (1'b0),
        .gtwiz_reset_rx_datapath_in         (1'b0),
        
        .rxsliderdy_out                     ()                   
    );

    // =========================================================================
    // 5. 用户侧复位生成
    // =========================================================================
    
    // TX 复位 (基于 PMA Reset Done)
    xpm_cdc_single #(
        .DEST_SYNC_FF(4),
        .SRC_INPUT_REG(0)
    ) u_rst_gen_tx (
        .src_clk (freerun_clk),          
        .src_in  (txpmaresetdone_vec[0]), 
        .dest_clk(txusrclk2),
        .dest_out(o_tx_rst_n)             
    );

    // RX 复位 (基于 PMA Reset Done)
    xpm_cdc_single #(
        .DEST_SYNC_FF(4),
        .SRC_INPUT_REG(0)
    ) u_rst_gen_rx (
        .src_clk (freerun_clk),
        .src_in  (rxpmaresetdone_vec[0]),
        .dest_clk(rxusrclk2),
        .dest_out(o_rx_rst_n)
    );

endmodule