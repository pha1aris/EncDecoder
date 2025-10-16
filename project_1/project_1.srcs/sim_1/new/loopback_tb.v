// File: loopback_tb.v
`timescale 1ns / 1ps

module loopback_tb;

    // 参数
    localparam CLK_PERIOD = 10; // 时钟周期 10ns -> 100MHz

    // 信号声明
    reg clk;
    reg rst;

    // 连接 TX 和 RX 的 AXI-Stream 总线
    wire [31:0] loop_tdata;
    wire        loop_tvalid;
    wire        loop_tready;

    // RX 模块的统计输出
    wire [63:0] total_bits;
    wire [63:0] error_count;

    // 1. 实例化 TX 核心逻辑
    tx_chain u_tx_chain (
        .clk            (clk),
        .rst            (rst),
        .m_axis_tdata   (loop_tdata),
        .m_axis_tvalid  (loop_tvalid),
        .m_axis_tready  (loop_tready)
    );

    // 2. 实例化 RX 核心逻辑
    rx_chain u_rx_chain (
        .clk            (clk),
        .rst            (rst),
        .s_axis_tdata   (loop_tdata),
        .s_axis_tvalid  (loop_tvalid),
        .s_axis_tready  (loop_tready),
        .total_bits_o   (total_bits),
        .error_count_o  (error_count)
    );

    // 3. 时钟生成
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // 4. 复位和仿真流程控制
    initial begin
        // 初始化和复位
        rst = 1;
        $display("[%t] Simulation started. System is in reset.", $time);
        repeat(5) @(posedge clk);
        rst = 0;
        $display("[%t] Reset released. Starting data transmission.", $time);

        // 运行一段时间
        repeat(50000) @(posedge clk);

        // 检查结果并结束仿真
        $display("-------------------------------------------------");
        $display("[%t] Simulation finished.", $time);
        $display("Total bits processed: %d", total_bits);
        $display("Total errors detected: %d", error_count);
        if (error_count == 0 && total_bits > 0) begin
            $display("SUCCESS: Loopback test PASSED with 0 errors.");
        end else begin
            $display("FAILURE: Loopback test FAILED.");
        end
        $display("-------------------------------------------------");
        $finish;
    end

endmodule