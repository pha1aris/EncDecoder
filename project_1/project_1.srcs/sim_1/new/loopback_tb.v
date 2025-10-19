`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module: loopback_tb
//
// Description:
//   一个完整的全链路仿真测试平台 (Testbench)。
//   数据流:
//   1. PRBS Gen (32-bit @ prbs_clk)
//   2. Encoder (32-bit in -> 8-bit out, CDC: prbs_clk -> clk)
//   3. Sync (8-bit in -> 32-bit out, 添加同步头/Padding)
//   4. DeSync (32-bit in -> 8-bit out, 移除同步头)
//   5. Decoder (8-bit in -> 32-bit out)
//   6. PRBS Check (32-bit @ clk)
//
//   本仿真验证了整个数据处理链路的正确性，包括跨时钟域和帧处理。
//
//////////////////////////////////////////////////////////////////////////////////

module loopback_tb;

    // =================================================================
    // 1. 参数定义
    // =================================================================
    localparam CORE_CLK_PERIOD = 10; // 主时钟周期 10ns -> 100MHz
    localparam PRBS_CLK_PERIOD = 32; // PRBS时钟周期 32ns -> 31.25MHz

    // =================================================================
    // 2. 信号声明
    // =================================================================
    reg clk;
    reg rst;
    reg prbs_clk;

    // --- 链路各阶段的连线 ---
    // PRBS Gen -> Encoder
    wire [31:0] prbs_data_out;
    wire        encoder_ready_for_data;

    // Encoder -> Sync
    wire [7:0]  encoder_tdata;
    wire        encoder_tvalid;
    wire        encoder_tlast;
    wire        sync_ready_for_encoder;

    // Sync -> DeSync
    wire [31:0] sync_tdata;
    wire        sync_tvalid;
    wire        sync_tlast;
    wire        desync_ready_for_sync;

    // DeSync -> Decoder
    wire [7:0]  desync_tdata;
    wire        desync_tvalid;
    wire        desync_tlast;
    wire        decoder_ready_for_desync;

    // Decoder -> PRBS Checker
    wire [31:0] decoder_tdata;
    wire        decoder_tvalid;

    // PRBS Checker 输出
    wire [31:0] prbs_error_vector;
    wire prbs_match;
    assign prbs_match = ~|prbs_error_vector;

    // 统计信号
    reg [63:0] total_bits;
    reg [63:0] error_count;

    // =================================================================
    // 3. 时钟和复位生成
    // =================================================================
    initial begin
        clk = 0;
        forever #(CORE_CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        prbs_clk = 0;
        forever #(PRBS_CLK_PERIOD / 2) prbs_clk = ~prbs_clk;
    end

    // =================================================================
    // 4. DUT 实例化和全链路连接
    // =================================================================


    wire enc_tvalid;
    wire enc_tready;
    assign enc_tvalid = 1;

    wire [7:0] Desync_tdata;
    wire Desync_tvalid;
    wire Desync_tlast;
    wire Desync_tready;

    // --- 模块 1: PRBS-31 生成器 (数据源, 32位) ---
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32) // **注意: Encoder 输入是32位**
    ) prbs_gen_inst (
        .RST      (rst),
        .CLK      (prbs_clk), 
        .DATA_IN  ('d0),
        .EN       (enc_tready && enc_tvalid), 
        .DATA_OUT (prbs_data_out)
    );
    // --- 模块 2: PRBS-7 生成器 (数据源, 32位) ---
    wire [7:0] prbs_7;
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (8) // **注意: sync 输入是8位**
    ) prbs_gen7_inst (
        .RST      (rst),
        .CLK      (prbs_clk), 
        .DATA_IN  ('d0),
        .EN       (enc_tready && enc_tvalid), 
        .DATA_OUT (prbs_7)
    );


    // --- 模块 2: Encoder (编码 + 跨时钟域) ---
    Encoder Encoder_inst (
        .rst                    (rst),
        .input_fifo_clk         (prbs_clk), 
        .core_clk               (clk),      
        .data_i                 (prbs_data_out),
        .data_valid_i           (enc_tvalid), // 当FIFO ready时，认为数据有效
        .input_fifo_wrrdy       (enc_tready),

        .m_axis_output_tdata    (encoder_tdata),
        .m_axis_output_tvalid   (encoder_tvalid),
        .m_axis_output_tlast    (encoder_tlast),
        .m_axis_output_tready   (sync_ready_for_encoder)
    );

    // --- 模块 3: Sync (添加同步头) ---
    // Sync Sync_inst (
    //     .rst                    (rst),
    //     .wr_clk                 (prbs_clk),
    //     .core_clk               (clk),
    //     .s_axis_input_tdata     (prbs_7),
    //     .s_axis_input_tvalid    (enc_tvalid),
    //     .s_axis_input_tlast     (encoder_tlast),    ///未连接
    //     .s_axis_input_tready    (enc_tready),

    //     .m_axis_output_tdata    (sync_tdata),
    //     .m_axis_output_tvalid   (sync_tvalid),
    //     .m_axis_output_tlast    (sync_tlast),
    //     .m_axis_output_tready   (desync_ready_for_sync)
    // );

    wire [31:0] sync_data_o;
    wire        sync_valid_o;

    Sync_axis Sync_axis (
        .rst                    (rst),                  // 高有效复位
        .core_clk               (clk),             // 时钟
        // AXI Stream Input
        .s_axis_input_tdata     (encoder_tdata),
        .s_axis_input_tvalid    (encoder_tvalid),
        .s_axis_input_tlast     (encoder_tlast),   // tlast 信号当前未被使用，逻辑依赖于固定的 PAYLOAD_LEN
        .s_axis_input_tready    (sync_ready_for_encoder),

        // 32-bit Aligned Output
        .sync_data_o            (sync_data_o),
        .sync_valid_o           (sync_valid_o)
    );

    Desync_axis Desync_axis(
        .rst                    (rst),
        .core_clk               (clk),

        .data_i                 (sync_data_o),
        .data_valid_i           (sync_valid_o),

        .m_axis_output_tdata    (Desync_tdata),
        .m_axis_output_tvalid   (Desync_tvalid),
        .m_axis_output_tlast    (Desync_tlast),
        .m_axis_output_tready   (Desync_tready)
    );
    // --- 模块 4: DeSync (移除同步头) ---
    // DeSync DeSync_inst (
    //     .rst                    (rst),
    //     .wr_clk                 (clk),
    //     .core_clk               (prbs_clk),
    //     .s_axis_input_tdata     (sync_tdata),
    //     .s_axis_input_tvalid    (sync_tvalid),
    //     // .s_axis_input_tlast     (sync_tlast), // DeSync 需要 tlast
    //     .s_axis_input_tready    (desync_ready_for_sync),

    //     .m_axis_output_tdata    (desync_tdata),
    //     .m_axis_output_tvalid   (desync_tvalid),
    //     .m_axis_output_tlast    (desync_tlast),
    //     .m_axis_output_tready   (1)
    // );

    // --- 模块 5: Decoder (解码) ---
    Decoder Decoder_inst (
        .rst                    (rst),
        .core_clk               (clk),
        .output_clk             (prbs_clk),

        .s_axis_input_tdata     (Desync_tdata),
        .s_axis_input_tvalid    (Desync_tvalid),
        .s_axis_input_tlast     (Desync_tlast),
        .s_axis_input_tready    (Desync_tready),

        .output_tdata           (decoder_tdata),
        .output_tvalid          (decoder_tvalid),
        .output_tready          (1'b1) // 假设PRBS校验器总能接收数据
    );

    // --- 模块 6: PRBS-31 校验器 (32位) ---
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (1),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (32) // **注意: Decoder 输出是32位**
    ) prbs_checker_inst (
        .RST                (rst),
        .CLK                (prbs_clk),
        .DATA_IN            (desync_tdata),
        .EN                 (desync_tvalid),
        .DATA_OUT           (prbs_error_vector)
    );

    // --- 模块 7: PRBS-7 校验器 (32位) ---
    wire [7:0] prbs_err_7;
    wire prbs_match7;
    assign prbs_match7 = ~|prbs_err_7;
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (1),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (8) // **注意: sync 输出是8位**
    ) prbs_checker7_inst (
        .RST                (rst),
        .CLK                (prbs_clk),
        .DATA_IN            (decoder_tdata),
        .EN                 (decoder_tvalid),
        .DATA_OUT           (prbs_err_7)
    );
    // =================================================================
    // 5. 误码统计逻辑
    // =================================================================
    // function automatic [5:0] popcount32;
    //     input [31:0] v;
    //     integer k;
    //     begin
    //         popcount32 = 0;
    //         for (k = 0; k < 32; k = k + 1) begin
    //             popcount32 = popcount32 + v[k];
    //         end
    //     end
    // endfunction

    // wire [5:0] perr_cnt = popcount32(prbs_error_vector);

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         error_count <= 64'd0;
    //         total_bits  <= 64'd0;
    //     end else if (decoder_tvalid) begin // **在最终输出端进行统计**
    //         error_count <= error_count + perr_cnt;
    //         total_bits  <= total_bits + 32; // 数据是32位的
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

        // // 检查结果并结束仿真
        // $display("-------------------------------------------------");
        // $display("[%0t ns] Simulation finished.", $time);
        // $display("Total bits processed: %d", total_bits);
        // $display("Total errors detected: %d", error_count);
        // if (error_count == 0 && total_bits > 0) begin
        //     $display("SUCCESS: Full loopback test PASSED with 0 errors.");
        // end else if (total_bits == 0) {
        //     $display("FAILURE: Full loopback test FAILED. No data was processed.");
        // } else begin
        //     $display("FAILURE: Full loopback test FAILED. Errors were detected.");
        // end
        // $display("-------------------------------------------------");
        // $finish;
    end

endmodule