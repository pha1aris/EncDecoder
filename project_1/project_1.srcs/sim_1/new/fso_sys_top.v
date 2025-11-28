`timescale 1ns / 1ps

module fso_sys_top(
    // =========================================================================
    // 1. 物理层接口 (PCB IO)
    // =========================================================================
    input  wire         sys_clk_p,        // 板载差分时钟输入
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,        // 外部复位
    output wire [1:0]   tx_disable,       
    
    input  wire         mgtrefclk0_x1y1_p,    
    input  wire         mgtrefclk0_x1y1_n,
    
    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,       
    output wire         gthtxn_out,

    // =========================================================================
    // 2. 状态指示
    // =========================================================================
    output wire         o_rx_active,      
    output wire         o_bit_locked,     
    output wire         o_prbs_locked,    
    output wire         o_error_detect,   

    // =========================================================================
    // 3. AXI4-Lite Slave 接口
    // =========================================================================
    input  wire         s_axi_aclk,
    input  wire         s_axi_aresetn,
    input  wire [31:0]  s_axi_awaddr,
    input  wire         s_axi_awvalid,
    output wire         s_axi_awready,
    input  wire [31:0]  s_axi_wdata,
    input  wire [3:0]   s_axi_wstrb,
    input  wire         s_axi_wvalid,
    output wire         s_axi_wready,
    output wire [1:0]   s_axi_bresp,
    output wire         s_axi_bvalid,
    input  wire         s_axi_bready,
    input  wire [31:0]  s_axi_araddr,
    input  wire         s_axi_arvalid,
    output wire         s_axi_arready,
    output wire [31:0]  s_axi_rdata,
    output wire [1:0]   s_axi_rresp,
    output wire         s_axi_rvalid,
    input  wire         s_axi_rready
);

    // =========================================================================
    // 1. 时钟架构 (Clocking Architecture)
    // =========================================================================
    wire w_freerun_clk; // 50MHz-100MHz, 给 GTH 复位逻辑
    wire w_core_clk;    // 系统核心频率 (e.g. 200MHz), 给 FEC/PRBS
    wire sys_pll_locked;
    
    clk_wiz_sys  u_sys_pll (
        .clk_in1_p (sys_clk_p),
        .clk_in1_n (sys_clk_n),
        .reset     (!sys_rst_n),      
        .clk_out1  (w_freerun_clk),
        .clk_out2  (w_core_clk),
        .locked    (sys_pll_locked)
    );

    // GTH Line Clocks (由 PHY 恢复/生成)
    wire rx_usr_clk;      
    wire tx_usr_clk;      

    // =========================================================================
    // 2. 复位逻辑 (Reset Tree)
    // =========================================================================
    wire rx_active;       // GTH RX Ready (Async)
    wire tx_active;       // GTH TX Ready (Async)
    wire rx_rst_n_gth;    // GTH Output Reset (Line Domain)
    wire tx_rst_n_gth;    
    
    // 将 GTH 的状态同步到 Core Domain 用作逻辑复位
    wire logic_rst_rx_core; // rx_active 取反并同步到 core_clk
    wire logic_rst_tx_core; // tx_active 取反并同步到 core_clk

    // XPM 异步复位同步器 (将 Active=0 视为复位)
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(4), 
        .RST_ACTIVE_HIGH(1)
    ) u_rst_sync_rx (
        .src_arst(~rx_active), 
        .dest_clk(w_core_clk), 
        .dest_arst(logic_rst_rx_core)
    );

    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(4), 
        .RST_ACTIVE_HIGH(1)
    ) u_rst_sync_tx (
        .src_arst(~tx_active), 
        .dest_clk(w_core_clk),         
        .dest_arst(logic_rst_tx_core)
    );

    // =========================================================================
    // 3. AXI 控制信号解码与 CDC
    // =========================================================================
    wire [31:0] slv_reg0_ctrl;
    wire        axi_prbs_clear_raw = slv_reg0_ctrl[0]; 
    wire        cdc_capture_req    = slv_reg0_ctrl[1]; 
    wire [2:0]  ctrl_loopback      = slv_reg0_ctrl[4:2];

    wire prbs_clr_sync;
    // 将 AXI 的 Clear 脉冲同步到 Core Clk
    xpm_cdc_single #(
        .DEST_SYNC_FF(3), 
        .SRC_INPUT_REG(0)) 
    u_cdc_clear (
        .src_clk(s_axi_aclk), 
        .src_in(axi_prbs_clear_raw), 
        .dest_clk(w_core_clk), 
        .dest_out(prbs_clr_sync)
    );

    wire [7:0]  tx_prbs_data;
    wire        tx_fec_ready;
    wire [31:0] tx_fec_data;
    wire        tx_fec_valid;
    wire [31:0] gth_tx_data;

    // PRBS 生成 (Core Domain)
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE(0), .INV_PATTERN(0), .POLY_LENGHT(7), .POLY_TAP(6), .NBITS(8)
    ) u_prbs_gen_tx (
        .RST(logic_rst_tx_core), 
        .CLK(w_core_clk), 
        .DATA_IN(8'd0), 
        .EN(tx_fec_ready), 
        .DATA_OUT(tx_prbs_data)
    );

    // FEC TX (跨时钟域: Core -> Line)
    fec_tx #(
        .W(32), .PAYLOAD_WORDS(16), .RS_K(229), .RS_N(255), 
        .INTLV_D(64), .INTLV_N(255), .FRAMES_PER_BLOCK(255)
    ) u_fec_tx (
        .line_clk       (tx_usr_clk),   // 写到 GTH 的时钟
        .core_clk       (w_core_clk),   // 逻辑处理时钟
        .rst_n          (~logic_rst_tx_core), 
        
        .scrambler_en   (1'b0),
        .i_data         (tx_prbs_data),
        .i_valid        (1'b1),
        .i_ready        (tx_fec_ready),
        .o_tx_data_line (tx_fec_data),  
        .o_tx_valid_line(tx_fec_valid),
        .o_tx_frame_index(), .o_tx_data(), .o_tx_valid()
    );

    assign gth_tx_data = tx_fec_valid ? tx_fec_data : 32'h00000000;

    wire cdr_stable;
    wire [31:0] gth_rx_data;
    wire rx_slide_req;

    gth_raw_top #(
        .W(32)
    ) u_gth_phy (
        .freerun_clk        (w_freerun_clk),  // ★ 使用生成的 FreeRun Clk
        .gth_reset_all      (~sys_pll_locked),// PLL 失锁时复位 GTH
        
        .tx_disable         (tx_disable),
        .mgtrefclk0_x1y1_p  (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n  (mgtrefclk0_x1y1_n),
        .gthrxp_in          (gthrxp_in),
        .gthrxn_in          (gthrxn_in),
        .gthtxp_out         (gthtxp_out),
        .gthtxn_out         (gthtxn_out),
        
        .i_loopback         (ctrl_loopback),      
        .o_pll_locked       (), // 内部 PLL 状态，可不接
        
        .o_tx_clk           (tx_usr_clk),
        .o_tx_rst_n         (tx_rst_n_gth), 
        .o_tx_active        (tx_active),
        .o_tx_done          (),
        .i_tx_data          (gth_tx_data),
        
        .o_rx_clk           (rx_usr_clk),
        .o_rx_rst_n         (rx_rst_n_gth), 
        .o_rx_done          (),           
        .o_rx_active        (rx_active),  
        .o_cdr_stable       (cdr_stable), 
        .o_rx_data          (gth_rx_data),
        .i_rx_slide         (rx_slide_req) 
    );

    wire [7:0]  fec_out_data;    
    wire        fec_out_valid;   
    wire        fec_bit_locked;  
    wire [15:0] frame_index, block_id, frame_in_block;

    assign o_rx_active  = rx_active;
    assign o_bit_locked = fec_bit_locked;

    // FEC RX (跨时钟域: Line -> Core)
    fec_rx #(
        .W(32), 
        .PAYLOAD_WORDS(16), 
        .RS_N(255), 
        .INTLV_D(64), 
        .INTLV_N(255)
    ) u_fec_rx (
        .line_clk       (rx_usr_clk), // GTH 恢复时钟
        .core_clk       (w_core_clk), // 系统核心时钟
        .rst_n          (~logic_rst_rx_core),      
        .scrambler_en   (1'b0), 
        .i_rx_data      (gth_rx_data),
        .i_rx_valid     (1'b1),           
        .rx_reset_done  (rx_active),      
        .rx_cdr_stable  (cdr_stable),     
        .o_data         (fec_out_data),   // Output in Core Domain
        .o_valid        (fec_out_valid), 
        .i_data_ready   (1'b1),           
        .o_rxslide      (rx_slide_req),   
        .o_bit_locked   (fec_bit_locked), 
        .o_frame_index  (frame_index),
        .o_block_id     (block_id),
        .o_frame_in_block(frame_in_block)
    );

    // =========================================================================
    // 7. 统计与监控 (Core Domain)
    // =========================================================================
    wire [7:0] prbs_err_vec;
    
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE(1), .INV_PATTERN(0), .POLY_LENGHT(7), .POLY_TAP(6), .NBITS(8)
    ) u_prbs_chk (
        .RST(logic_rst_rx_core), .CLK(w_core_clk), .DATA_IN(fec_out_data), .EN(fec_out_valid), .DATA_OUT(prbs_err_vec)
    );

    reg [3:0]  mask_cnt;
    reg        link_locked_reg;
    reg        err_detect_reg;         
    reg [63:0] prbs_rxtotal_err_bits;  
    reg [63:0] prbs_rxtotal_rx_bits;   
    
    wire [3:0] current_err_bits_cnt;
    assign current_err_bits_cnt = prbs_err_vec[0] + prbs_err_vec[1] + prbs_err_vec[2] + prbs_err_vec[3] + 
                                  prbs_err_vec[4] + prbs_err_vec[5] + prbs_err_vec[6] + prbs_err_vec[7];

    wire do_clear = logic_rst_rx_core | prbs_clr_sync; 

    // ★ 全部运行在 Core Clock
    always @(posedge w_core_clk) begin
        if (do_clear) begin
            mask_cnt <= 0; link_locked_reg <= 0; err_detect_reg <= 0;
            prbs_rxtotal_err_bits <= 0; prbs_rxtotal_rx_bits <= 0;
        end else begin
            if (fec_out_valid && (mask_cnt >= 4)) begin
                err_detect_reg <= (|prbs_err_vec);
                link_locked_reg <= 1'b1;
            end else err_detect_reg <= 0;

            if (fec_out_valid) begin
                if (mask_cnt < 4) mask_cnt <= mask_cnt + 1;
                else begin
                    prbs_rxtotal_rx_bits <= prbs_rxtotal_rx_bits + 8;
                    if (|prbs_err_vec) prbs_rxtotal_err_bits <= prbs_rxtotal_err_bits + current_err_bits_cnt;
                end
            end
        end
    end

    assign o_prbs_locked  = link_locked_reg; 
    assign o_error_detect = err_detect_reg;  

    // =========================================================================
    // 8. 监控数据上报 (CDC: Core -> AXI)
    // =========================================================================
    wire [223:0] monitor_data_fast;
    wire [223:0] monitor_data_synced;
    
    assign monitor_data_fast = {
        prbs_rxtotal_rx_bits[63:32], prbs_rxtotal_rx_bits[31:0], 
        prbs_rxtotal_err_bits[63:32], prbs_rxtotal_err_bits[31:0], 
        {16'b0, frame_in_block}, {16'b0, block_id}, {16'b0, frame_index}        
    };

    monitor_cdc_wrapper #(
        .DATA_WIDTH(224)) 
    u_mon_cdc (
        .src_clk          (w_core_clk),
        .src_rst          (logic_rst_rx_core), 
        .src_data_in      (monitor_data_fast), 
        .dest_clk         (s_axi_aclk),
        .dest_capture_req (cdc_capture_req),   
        .dest_data_out    (monitor_data_synced)
    );

    axi4_lite_slave #(
        .ADDRESS_WIDTH(32), 
        .DATA_WIDTH(32), 
        .NUM_RO_REGS(7)
    ) u_axi_slave (
        .ACLK(s_axi_aclk), .ARESETN(s_axi_aresetn),
        .S_AWADDR(s_axi_awaddr), .S_AWVALID(s_axi_awvalid), .S_AWREADY(s_axi_awready),    
        .S_WDATA(s_axi_wdata), .S_WSTRB(s_axi_wstrb), .S_WVALID(s_axi_wvalid), .S_WREADY(s_axi_wready),    
        .S_BRESP(s_axi_bresp), .S_BVALID(s_axi_bvalid), .S_BREADY(s_axi_bready),    
        .S_ARADDR(s_axi_araddr), .S_ARVALID(s_axi_arvalid), .S_ARREADY(s_axi_arready),    
        .S_RDATA(s_axi_rdata), .S_RRESP(s_axi_rresp), .S_RVALID(s_axi_rvalid), .S_RREADY(s_axi_rready),
        .monitor_data_flat(monitor_data_synced),
        .o_slv_reg0(slv_reg0_ctrl) 
    );

endmodule