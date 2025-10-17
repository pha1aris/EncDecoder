`timescale 1ns / 1ps

module loopback_tb;

    // =================================================================
    // 1. 参数定义
    // =================================================================
    localparam CLK_PERIOD = 10; // 主时钟周期 10ns -> 100MHz

    // =================================================================
    // 2. 信号声明
    // =================================================================
    reg clk;
    reg rst;
    reg prbs_clk; // 独立的PRBS时钟，在这个测试中未使用，但保留

    // PRBS Generator -> Sync 接口
    wire [7:0]  prbs_data;       // PRBS输出为8位
    wire        prbs_valid;
    wire        sync_input_ready;

    // Sync -> DeSync 接口 (AXI-Stream)
    wire [31:0] sync_to_desync_tdata;
    wire        sync_to_desync_tvalid;
    wire        sync_to_desync_tready;
    wire        sync_to_desync_tlast;

    // DeSync -> PRBS Checker 接口
    wire [7:0]  desync_output_tdata;
    wire        desync_output_tvalid;
    wire        desync_output_tlast;
    wire        checker_ready = 1'b1; // 假设Checker总能接收数据

    // PRBS Checker -> 统计 接口
    wire [31:0] prbs_error_vector_full; // Checker的DATA_OUT是32位
    wire [7:0]  prbs_error_vector = prbs_error_vector_full[7:0]; // 我们只关心低8位
    wire        prbs_match = ~|prbs_error_vector; // 错误向量全0表示匹配

    // 统计输出
    reg [63:0] total_bits;
    reg [63:0] error_count;

    // =================================================================
    // 3. 时钟和复位生成
    // =================================================================
    // 主时钟 clk (100MHz)
    initial begin
        clk = 0;
        forever 
            #(CLK_PERIOD / 2) clk = ~clk;
    end
    
    // prbs_clk (64ns周期 -> 15.625 MHz), 当前未使用
    initial begin
        prbs_clk = 0;
        // #32 表示半周期为32ns, 全周期为64ns
        forever 
            #32 prbs_clk = ~prbs_clk;
    end

    // =================================================================
    // 4. DUT 实例化和连接
    // =================================================================

    // --- 模块 1: PRBS-31 生成器 ---
    // 输出8位伪随机码
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (8) 
    ) prbs_gen_inst (
        .RST      (rst),
        .CLK      (prbs_clk),
        .DATA_IN  ('d0),
        .EN       (prbs_valid && sync_input_ready), // 仅当Sync准备好时才生成新数据
        .DATA_OUT (prbs_data)
    );
    // PRBS生成器没有tvalid, 我们用一个简单的逻辑创建它
    assign prbs_valid = 1'b1; // 假设数据一直有效

    // --- 模块 2: Sync (加同步头和Padding) ---
    Sync Sync_inst (
        .rst                    (rst),
        .wr_clk                 (prbs_clk),
        .core_clk               (clk),
        .s_axis_input_tdata     (prbs_data),
        .s_axis_input_tvalid    (prbs_valid),
        .s_axis_input_tlast     (1'b0), // 输入是连续流, 无tlast
        .s_axis_input_tready    (sync_input_ready),

        .m_axis_output_tdata    (sync_to_desync_tdata),
        .m_axis_output_tvalid   (sync_to_desync_tvalid),
        .m_axis_output_tlast    (sync_to_desync_tlast),
        .m_axis_output_tready   (sync_to_desync_tready) // **关键: 连接下游的反压**
    );

    // --- 模块 3: DeSync (去同步头) ---
    DeSync DeSync_inst (
        .rst                    (rst),
        .wr_clk                 (clk),
        .core_clk               (clk),
        .s_axis_input_tdata     (sync_to_desync_tdata),
        .s_axis_input_tvalid    (sync_to_desync_tvalid),
        .s_axis_input_tready    (sync_to_desync_tready),

        .m_axis_output_tdata    (desync_output_tdata),
        .m_axis_output_tvalid   (desync_output_tvalid),
        .m_axis_output_tlast    (desync_output_tlast),
        .m_axis_output_tready   (checker_ready) // Checker总是ready
    );

    // --- 模块 4: PRBS-31 校验器 ---
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (8) // **修正: 位宽为8, 匹配DeSync输出**
    ) prbs_checker_inst (
        .RST       (rst),
        .CLK       (clk),
        .DATA_IN   (desync_output_tdata),
        .EN        (desync_output_tvalid),
        .DATA_OUT  (prbs_error_vector_full) // IP核输出总是32位
    );

    // =================================================================
    // 5. 误码统计逻辑
    // =================================================================
    // function automatic [5:0] popcount8;
    //     input [7:0] v;
    //     integer k;
    //     begin
    //         popcount8 = 0;
    //         for (k = 0; k < 8; k = k + 1) begin
    //             popcount8 = popcount8 + v[k];
    //         end
    //     end
    // endfunction

    // wire [5:0] perr_cnt = popcount8(prbs_error_vector);

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         error_count <= 64'd0;
    //         total_bits  <= 64'd0;
    //     end else if (desync_output_tvalid) begin // 仅当有效数据到达校验器时才计数
    //         error_count <= error_count + perr_cnt;
    //         total_bits  <= total_bits + 8; // 数据是8位的
    //     end
    // end

    // =================================================================
    // 6. 仿真流程控制与结果检查
    // =================================================================
    initial begin
        // 初始化和复位
        rst = 1;
        $display("[%0t ns] Simulation started. System is in reset.", $time);
        repeat(10) @(posedge clk);
        rst = 0;
        $display("[%0t ns] Reset released. Starting data transmission.", $time);

        // 运行足够长的时间以处理多个帧
        repeat(50000) @(posedge clk);

        // 检查结果并结束仿真
        // $display("-------------------------------------------------");
        // $display("[%0t ns] Simulation finished.", $time);
        // $display("Total bits processed: %d", total_bits);
        // $display("Total errors detected: %d", error_count);
        // if (error_count == 0 && total_bits > 0) begin
        //     $display("SUCCESS: Loopback test PASSED with 0 errors.");
        // end else if (total_bits == 0) {
        //     $display("FAILURE: Loopback test FAILED. No data was processed.");
        // } else begin
        //     $display("FAILURE: Loopback test FAILED. Errors were detected.");
        // end
        // $display("-------------------------------------------------");
        // $finish;
    end

endmodule