`timescale 1ns / 1ps

module tb_fso_sys_top;

    // =========================================================================
    // 1. 参数定义
    // =========================================================================
    // 系统时钟 100MHz
    parameter SYS_CLK_PERIOD = 5.0;     
    parameter MGT_REF_PERIOD = 8.0;  
    parameter AXI_CLK_PERIOD = 10.0; 

    // =========================================================================
    // 2. 信号声明
    // =========================================================================
    reg sys_clk_p, sys_clk_n;
    reg sys_rst_n;
    wire [1:0] tx_disable;
    
    reg mgtrefclk_p, mgtrefclk_n;
    
    // GTH 串行信号 (在 TB 中回环)
    wire gth_tx_p, gth_tx_n;
    wire gth_rx_p, gth_rx_n;

    // 状态信号
    wire o_rx_active;
    wire o_bit_locked;
    wire o_prbs_locked;
    wire o_error_detect;

    // AXI4-Lite 接口信号 (TB 模拟 Master)
    reg         s_axi_aclk;
    reg         s_axi_aresetn;
    reg  [31:0] s_axi_awaddr;
    reg         s_axi_awvalid;
    wire        s_axi_awready;
    reg  [31:0] s_axi_wdata;
    reg  [3:0]  s_axi_wstrb;
    reg         s_axi_wvalid;
    wire        s_axi_wready;
    wire [1:0]  s_axi_bresp;
    wire        s_axi_bvalid;
    reg         s_axi_bready;
    reg  [31:0] s_axi_araddr;
    reg         s_axi_arvalid;
    wire        s_axi_arready;
    wire [31:0] s_axi_rdata;
    wire [1:0]  s_axi_rresp;
    wire        s_axi_rvalid;
    reg         s_axi_rready;

    // =========================================================================
    // 3. 时钟生成
    // =========================================================================
    // 100MHz Sys Clk
    initial begin
        sys_clk_p = 0; sys_clk_n = 1;
        forever #(SYS_CLK_PERIOD/2) begin sys_clk_p = ~sys_clk_p; sys_clk_n = ~sys_clk_n; end
    end

    // 125MHz MGT Ref Clk
    initial begin
        mgtrefclk_p = 0; mgtrefclk_n = 1;
        forever #(MGT_REF_PERIOD/2) begin mgtrefclk_p = ~mgtrefclk_p; mgtrefclk_n = ~mgtrefclk_n; end
    end

    // 50MHz AXI Clk
    initial begin
        s_axi_aclk = 0;
        forever #(AXI_CLK_PERIOD/2) s_axi_aclk = ~s_axi_aclk;
    end

    // =========================================================================
    // 4. 物理环回连接 (External Loopback Simulation)
    // =========================================================================
    // 模拟外部光纤自环：直接将发送端连接到接收端
    assign gth_rx_p = gth_tx_p;
    assign gth_rx_n = gth_tx_n;

    // =========================================================================
    // 5. DUT 实例化
    // =========================================================================
    fso_sys_top u_dut (
        .sys_clk_p          (sys_clk_p),
        .sys_clk_n          (sys_clk_n),
        .sys_rst_n          (sys_rst_n),
        .tx_disable         (tx_disable),
        
        .mgtrefclk0_x1y1_p  (mgtrefclk_p),
        .mgtrefclk0_x1y1_n  (mgtrefclk_n),
        
        .gthrxp_in          (gth_rx_p),
        .gthrxn_in          (gth_rx_n),
        .gthtxp_out         (gth_tx_p),
        .gthtxn_out         (gth_tx_n),
        
        .o_rx_active        (o_rx_active),
        .o_bit_locked       (o_bit_locked),
        .o_prbs_locked      (o_prbs_locked),
        .o_error_detect     (o_error_detect),
        
        // AXI 连接
        .s_axi_aclk         (s_axi_aclk),
        .s_axi_aresetn      (s_axi_aresetn),
        .s_axi_awaddr       (s_axi_awaddr),
        .s_axi_awvalid      (s_axi_awvalid),
        .s_axi_awready      (s_axi_awready),
        .s_axi_wdata        (s_axi_wdata),
        .s_axi_wstrb        (s_axi_wstrb),
        .s_axi_wvalid       (s_axi_wvalid),
        .s_axi_wready       (s_axi_wready),
        .s_axi_bresp        (s_axi_bresp),
        .s_axi_bvalid       (s_axi_bvalid),
        .s_axi_bready       (s_axi_bready),
        .s_axi_araddr       (s_axi_araddr),
        .s_axi_arvalid      (s_axi_arvalid),
        .s_axi_arready      (s_axi_arready),
        .s_axi_rdata        (s_axi_rdata),
        .s_axi_rresp        (s_axi_rresp),
        .s_axi_rvalid       (s_axi_rvalid),
        .s_axi_rready       (s_axi_rready)
    );

    // =========================================================================
    // 6. AXI 写任务 (模拟 CPU 写寄存器)
    // =========================================================================
    task axi_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge s_axi_aclk);
            s_axi_awaddr  <= addr;
            s_axi_awvalid <= 1'b1;
            s_axi_wdata   <= data;
            s_axi_wstrb   <= 4'hF;
            s_axi_wvalid  <= 1'b1;
            s_axi_bready  <= 1'b1;
            
            // 等待 Slave 准备好 (简化模型：假设 Slave 很快)
            // 实际仿真中最好检查 awready 和 wready
            wait(s_axi_awready && s_axi_wready);
            
            @(posedge s_axi_aclk);
            s_axi_awvalid <= 1'b0;
            s_axi_wvalid  <= 1'b0;
            
            wait(s_axi_bvalid);
            @(posedge s_axi_aclk);
            s_axi_bready  <= 1'b0;
            
            $display("[%0t] AXI WRITE Addr: 0x%h, Data: 0x%h", $time, addr, data);
        end
    endtask

    // =========================================================================
    // 7. 主测试流程
    // =========================================================================
    initial begin
        // 初始化信号
        sys_rst_n     = 0;
        s_axi_aresetn = 0;
        s_axi_awvalid = 0; s_axi_wvalid = 0; s_axi_arvalid = 0;
        s_axi_bready  = 0; s_axi_rready = 0; s_axi_awaddr = 0; s_axi_wdata = 0; s_axi_wstrb = 0;
        
        $display("Simulation Started...");
        
        // 1. 复位释放
        #200;
        sys_rst_n     = 1;
        s_axi_aresetn = 1;
        
        // 2. 等待 GTH 初始化完成 (o_rx_active 拉高)
        // 注意：GTH 仿真模型初始化非常慢，可能需要几 us 到几百 us
        $display("[%0t] Waiting for GTH RX Active...", $time);
        wait(o_rx_active == 1'b1);
        $display("[%0t] GTH RX Active! Link is Up.", $time);
        
        // 等待数据流稳定
        #1000;

        // 3. 配置模式
        // Reg0 Addr = 0x00
        // 我们已经在外部做了 gth_rx = gth_tx，所以使用 "Normal Mode" (Loopback = 000) 即可
        // 如果想测试内部 PMA 环回，可以写 0x0000_0008 (Bit[4:2]=010)
        // 这里写 0 (Normal Mode)
        axi_write(32'h0000_0000, 32'h0000_0000);
        
        #1000;

        // 4. 复位 PRBS 计数器 (产生一个 Clear 脉冲)
        // Reg0 Bit 0 = 1 (Clear)
        axi_write(32'h0000_0000, 32'h0000_0001);
        #1000;
        // Reg0 Bit 0 = 0 (Run)
        axi_write(32'h0000_0000, 32'h0000_0000);
        
        $display("[%0t] PRBS Counters Reset. Monitoring...", $time);

        // 5. 检查锁定状态
        // 增加超时机制防止死锁
        // fork
        //     begin
        //         wait(o_bit_locked == 1'b1);
        //         $display("[%0t] FEC Bit Aligner Locked!", $time);
        //         wait(o_prbs_locked == 1'b1);
        //         $display("[%0t] PRBS Checker Locked!", $time);
        //     end
        //     begin
        //         #500000; // 超时时间
        //         if (!o_bit_locked) begin
        //             $display("[%0t] ERROR: Timeout waiting for Lock!", $time);
        //             $stop;
        //         end
        //     end
        // join
        
        // 6. 运行一段时间看是否有误码
        // #50000;
        
        // if (o_error_detect == 1'b0) begin
        //     $display("========================================");
        //     $display("   TEST PASSED: No Errors Detected      ");
        //     $display("========================================");
        // end else begin
        //     $display("========================================");
        //     $display("   TEST FAILED: Errors Detected!        ");
        //     $display("   (o_error_detect went High)           ");
        //     $display("========================================");
        // end
        
        // $stop;
    end

endmodule