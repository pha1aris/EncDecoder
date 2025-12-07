`timescale 1ns/1ps

module fso_rx_top(
    // =========================================================================
    // 1. 物理层接口 (PCB IO)
    // =========================================================================
    input  wire         sys_clk_p,        // 板载系统时钟
    input  wire         sys_clk_n,
    input  wire         sys_rst_n,        // 物理按键复位 (低有效)
    output wire [1:0]   tx_disable,       // SFP 光模块控制 (拉低使能)
    
    // GTH 参考时钟
    input   wire        mgtrefclk0_x1y1_p,    
    input   wire        mgtrefclk0_x1y1_n,
    
    // GTH 串行数据
    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,       // TX 端口 (RX 模式下发送空闲/0)
    output wire         gthtxn_out,

    // =========================================================================
    // 2. 状态指示 LED (输出到板卡 LED)
    // =========================================================================
    output wire         o_rx_active,      // GTH 初始化完成
    output wire         o_bit_locked,     // FEC 对齐锁定
    output wire         o_prbs_locked,    // PRBS 锁定
    output wire         o_error_detect,   // 瞬时误码指示 (闪烁代表有错)

    // =========================================================================
    // 3. AXI4-Lite Slave 接口 (连接 Zynq PS 或 MicroBlaze)
    // =========================================================================
    input  wire         s_axi_aclk,
    input  wire         s_axi_aresetn,
    
    // 写地址
    input  wire [31:0]  s_axi_awaddr,
    // 如果你的 AXI BFM/PS 带 PROT，这里建议加上：
    input  wire [2:0]   s_axi_awprot,   // ★ 新增：AWPROT
    input  wire         s_axi_awvalid,
    output wire         s_axi_awready,
    // 写数据
    input  wire [31:0]  s_axi_wdata,
    input  wire [3:0]   s_axi_wstrb,
    input  wire         s_axi_wvalid,
    output wire         s_axi_wready,
    // 写响应
    output wire [1:0]   s_axi_bresp,
    output wire         s_axi_bvalid,
    input  wire         s_axi_bready,
    // 读地址
    input  wire [31:0]  s_axi_araddr,
    input  wire [2:0]   s_axi_arprot,   // ★ 新增：ARPROT
    input  wire         s_axi_arvalid,
    output wire         s_axi_arready,
    // 读数据
    output wire [31:0]  s_axi_rdata,
    output wire [1:0]   s_axi_rresp,
    output wire         s_axi_rvalid,
    input  wire         s_axi_rready
);

    // =========================================================================
    // 内部信号声明
    // =========================================================================

    // GTH 接口
    wire        rx_usr_clk;      // GTH 恢复时钟 (32-bit域, Fast Clock)
    wire        rx_rst_n_gth;    // GTH 输出的复位 (低有效)
    wire        rx_active;       // RX 初始化完成标志
    wire        cdr_stable;      // CDR 锁定标志
    
    wire [31:0] gth_rx_data;     // GTH 接收的原始数据
    wire        rx_slide_req;    // 来自 FEC 的滑动请求
    
    // FEC 接口
    wire [7:0]  fec_out_data;    // 解码后的数据 (8-bit)
    wire        fec_out_valid;   // 数据有效
    wire        fec_bit_locked;  // 比特对齐锁定状态
    
    // scrambler 使能：要与 TX 端保持一致
    wire        scrambler_en = 1'b1;

    // 状态输出分配
    assign o_rx_active  = rx_active;
    assign o_bit_locked = fec_bit_locked;

    // =========================================================================
    // PHY GTH 实例
    // =========================================================================
    gth_raw_top #(
        .W(32)
    ) u_gth_phy (
        .sys_clk_p              (sys_clk_p),
        .sys_clk_n              (sys_clk_n),
        .sys_rst_n              (sys_rst_n),
        .tx_disable             (tx_disable),

        .mgtrefclk0_x1y1_p      (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n      (mgtrefclk0_x1y1_n),

        .gthrxp_in              (gthrxp_in),
        .gthrxn_in              (gthrxn_in),
        .gthtxp_out             (gthtxp_out),
        .gthtxn_out             (gthtxn_out),

        .i_loopback             (3'b000),      // RX-only 模式，正常接收

        .o_pll_locked           (),            
        .o_tx_clk               (),            // RX-only，TX 不用
        .o_tx_rst_n             (),
        .o_tx_active            (),
        .o_tx_done              (),
        .i_tx_data              (32'd0),

        .o_rx_clk               (rx_usr_clk),
        .o_rx_rst_n             (rx_rst_n_gth),
        .o_rx_done              (),           
        .o_rx_active            (rx_active),  
        .o_cdr_stable           (cdr_stable), 
        .o_rx_data              (gth_rx_data),
        .i_rx_slide             (rx_slide_req)
    );

    // =========================================================================
    // FEC RX 实例（line_clk/core_clk 均为 rx_usr_clk，当前只有一个时钟域）
    // =========================================================================

    // 对 FEC 来说的“系统复位”：
    //   GTH 复位正常 + RX 初始化完成 + CDR 稳定
    wire fec_rst_n = rx_rst_n_gth & rx_active & cdr_stable;

    wire [15:0] frame_index;
    wire [15:0] block_id;
    wire [15:0] frame_in_block;

    fec_rx #(
        .W                (32),
        .PAYLOAD_WORDS    (16),
        .RS_N             (255),
        .INTLV_D          (64),   // ★ 必须与 TX 端一致
        .INTLV_N          (255)
    ) u_fec_rx (
        .line_clk         (rx_usr_clk),
        .core_clk         (rx_usr_clk),
        .rst_n            (fec_rst_n),

        .i_rx_data        (gth_rx_data),
        .i_rx_valid       (1'b1),           // GTH 每拍都有数据
        .rx_reset_done    (rx_active),      
        .rx_cdr_stable    (cdr_stable),
        .scrambler_en     (scrambler_en),

        .o_data           (fec_out_data),
        .o_valid          (fec_out_valid),
        .i_data_ready     (1'b1),           // 后端 PRBS 不反压

        .o_rxslide        (rx_slide_req),   
        .o_bit_locked     (fec_bit_locked), 
        .o_frame_index    (frame_index),
        .o_block_id       (block_id),
        .o_frame_in_block (frame_in_block)
    );

    // =========================================================================
    // PRBS 检查器
    // =========================================================================

    // 建议：PRBS / 误码统计的复位，除了链路 active 外，也参考 bit_locked
    wire logic_rst = ~rx_active | ~cdr_stable | ~fec_bit_locked;

    wire [7:0]  prbs_err_vec;    // 错误向量

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1), 
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST         (logic_rst),
        .CLK         (rx_usr_clk),
        .DATA_IN     (fec_out_data),
        .EN          (fec_out_valid), 
        .DATA_OUT    (prbs_err_vec)
    );

    // =========================================================================
    // 统计与监控逻辑 (Fast Clock Domain: rx_usr_clk)
    // =========================================================================
    
    reg [3:0]  mask_cnt;
    reg        link_locked_reg;
    reg        err_detect_reg;         
    reg [63:0] prbs_rxtotal_err_bits;  
    reg [63:0] prbs_rxtotal_rx_bits;   
    
    wire        prbs_clr;
    wire [3:0]  current_err_bits_cnt;
    
    assign current_err_bits_cnt = prbs_err_vec[0] + prbs_err_vec[1] + 
                                  prbs_err_vec[2] + prbs_err_vec[3] + 
                                  prbs_err_vec[4] + prbs_err_vec[5] + 
                                  prbs_err_vec[6] + prbs_err_vec[7];

    wire do_clear = logic_rst | prbs_clr; 

    always @(posedge rx_usr_clk) begin
        if (do_clear) begin
            mask_cnt              <= 0;
            link_locked_reg       <= 0;
            err_detect_reg        <= 0;
            prbs_rxtotal_err_bits <= 'd0;
            prbs_rxtotal_rx_bits  <= 'd0;
        end else begin
            // 锁定状态与瞬时错误指示
            if (fec_out_valid && (mask_cnt >= 4)) begin
                if (|prbs_err_vec) 
                    err_detect_reg <= 1'b1;
                else
                    err_detect_reg <= 1'b0; 

                link_locked_reg <= 1'b1;
            end else begin
                err_detect_reg <= 1'b0;
            end

            // 核心统计逻辑
            if (fec_out_valid) begin
                if (mask_cnt < 4) begin
                    mask_cnt <= mask_cnt + 1;
                end 
                else begin
                    prbs_rxtotal_rx_bits <= prbs_rxtotal_rx_bits + 8;
                    if (|prbs_err_vec) begin
                        prbs_rxtotal_err_bits <= prbs_rxtotal_err_bits + current_err_bits_cnt;
                    end
                end
            end
        end
    end

    assign o_prbs_locked  = link_locked_reg; 
    assign o_error_detect = err_detect_reg;  

    // =========================================================================
    // 监控数据打包 & CDC 到 AXI 域
    // =========================================================================

    wire [31:0] raw_err_lo = prbs_rxtotal_err_bits[31:0];
    wire [31:0] raw_err_hi = prbs_rxtotal_err_bits[63:32];
    wire [31:0] raw_rx_lo  = prbs_rxtotal_rx_bits[31:0];
    wire [31:0] raw_rx_hi  = prbs_rxtotal_rx_bits[63:32];
    
    wire [223:0] monitor_data_fast;
    assign monitor_data_fast = {
        raw_rx_hi,                  // Index 22
        raw_rx_lo,                  // Index 21
        raw_err_hi,                 // Index 20
        raw_err_lo,                 // Index 19
        {16'b0, frame_in_block},    // Index 18
        {16'b0, block_id},          // Index 17
        {16'b0, frame_index}        // Index 16
    };

    wire [223:0] monitor_data_synced;
    wire [31:0]  slv_reg0_ctrl;
    wire         cdc_capture_req = slv_reg0_ctrl[1]; // AXI Bit 1 控制快照
    
    wire vio_prbs_ctrl_en;
    wire vio_prbs_clr;
    wire axi_prbs_clear = slv_reg0_ctrl[0]; 

    assign prbs_clr        = vio_prbs_ctrl_en ? vio_prbs_clr : axi_prbs_clear;
    assign vio_prbs_ctrl_en = 1'b0;
    assign vio_prbs_clr     = 1'b0;

    monitor_cdc_wrapper #(
        .DATA_WIDTH (224) 
    ) u_mon_cdc (
        .src_clk          (rx_usr_clk),
        .src_rst          (~rx_active),      
        .src_data_in      (monitor_data_fast),
        .dest_clk         (s_axi_aclk),
        .dest_capture_req (cdc_capture_req),
        .dest_data_out    (monitor_data_synced)
    );

    axi4_lite_slave #(
        .ADDRESS_WIDTH(32),
        .DATA_WIDTH   (32),
        .NUM_RO_REGS  (7)
    ) u_axi_slave (
        .ACLK              (s_axi_aclk),
        .ARESETN           (s_axi_aresetn),

        .S_AWADDR          (s_axi_awaddr),
        .S_AWPROT          (s_axi_awprot),  // ★ 新增：PROT 透传
        .S_AWVALID         (s_axi_awvalid),
        .S_AWREADY         (s_axi_awready),    

        .S_WDATA           (s_axi_wdata),
        .S_WSTRB           (s_axi_wstrb),
        .S_WVALID          (s_axi_wvalid),
        .S_WREADY          (s_axi_wready),    

        .S_BRESP           (s_axi_bresp),
        .S_BVALID          (s_axi_bvalid),
        .S_BREADY          (s_axi_bready),    

        .S_ARADDR          (s_axi_araddr),
        .S_ARPROT          (s_axi_arprot),  // ★ 新增
        .S_ARVALID         (s_axi_arvalid),
        .S_ARREADY         (s_axi_arready),    

        .S_RDATA           (s_axi_rdata),
        .S_RRESP           (s_axi_rresp),
        .S_RVALID          (s_axi_rvalid),
        .S_RREADY          (s_axi_rready),
        
        .monitor_data_flat (monitor_data_synced),
        
        .o_slv_reg0        (slv_reg0_ctrl)
    );

endmodule
