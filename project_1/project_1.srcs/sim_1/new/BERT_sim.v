`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2025/09/19 20:03:03
// Design Name:
// Module Name: BERT_sim
// Project Name:
// Target Devices:
// Tool Versions:
// Description: PRBS-31 生成器和检查器的误码率测试平台
//
// Revision:
// Revision 1.00 - File refined by Gemini
// Additional Comments:
// 1. 修正了EN信号激励，确保测试能够运行。
// 2. 修正了总发送比特数计算逻辑（每次+32）。
// 3. 使用function优化了每周期误码数计算，代码更简洁。
// 4. 添加了仿真结束时的BER（误码率）自动计算和报告。
// 5. 移除了未使用的clr信号。
//////////////////////////////////////////////////////////////////////////////////


module BERT_sim();

    //================================================================
    // Signal Declarations
    //================================================================
    reg EN;
    reg rst;
    reg clk;
    reg [31:0] err_inject;

    wire [31:0] prbs_data; // **FIXED**: Added missing wire declaration
    wire [31:0] prbs_error_to_gth;
    wire prbs_match_out1;

    // BER calculation signals
    reg [63:0] total_send_bits;
    reg [63:0] total_err_bit;
    wire [5:0]  err_bits_count; // Count of error bits per clock cycle

    //================================================================
    // Clock and Reset Generation
    //================================================================
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        #40
        rst = 1'b0;
    end

    always #10 clk = ~clk; // 50MHz clock

    //================================================================
    // Stimulus Generation
    //================================================================
    initial begin
        // **FIXED**: EN is now asserted after reset to start the test
        EN = 1'b0;
        #50; // Wait for reset to de-assert
        EN = 1'b1;
        #2000; // Run simulation for 2000ns
        EN = 1'b0; // Stop the test
    end

    initial begin
        err_inject = 32'd0;
        #80; // After 80ns, start injecting errors
        err_inject = 32'h0000_00FF; // Inject 8 bit errors every cycle
    end

    //================================================================
    // PRBS Generator Instantiation (PRBS-31)
    //================================================================
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),  // 0 for Generator
        .INV_PATTERN (1),  // Invert pattern
        .POLY_LENGHT (31), // PRBS-31
        .POLY_TAP    (28), // Tap for PRBS-31 is at bit 28
        .NBITS       (32)  // Data width
    ) prbs_any_gen (
        .RST       (rst),
        .CLK       (clk),
        .DATA_IN   (32'd0),
        .EN        (EN),
        .DATA_OUT  (prbs_data)
    );

    //================================================================
    // PRBS Checker Instantiation (PRBS-31)
    //================================================================
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),  // 1 for Checker
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker (
        .RST       (rst),
        .CLK       (clk),
        .DATA_IN   (prbs_data ^ err_inject), // Inject error before checker
        .EN        (EN),
        .DATA_OUT  (prbs_error_to_gth) // Output indicates error bits (1 = error)
    );

    // prbs_match_out1 is high when there are no errors
    assign prbs_match_out1 = ~|prbs_error_to_gth;

    //================================================================
    // Bit Error Rate (BER) Calculation Logic
    //================================================================

    // Total bits sent counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            total_send_bits <= 64'd0;
        end else if (EN) begin
            // **FIXED**: Increment by data width (32) each cycle, not 1
            total_send_bits <= total_send_bits + 32;
        end
    end

    // **IMPROVED**: Function to count set bits (popcount) in a vector
    // This replaces the long, manual summation.
    function [5:0] count_set_bits;
        input [31:0] data;
        integer i;
        begin
            count_set_bits = 6'd0;
            for (i = 0; i < 32; i = i + 1) begin
                if (data[i] == 1'b1) begin
                    count_set_bits = count_set_bits + 1;
                end
            end
        end
    endfunction

    // Use the function to count error bits per cycle
    assign err_bits_count = count_set_bits(prbs_error_to_gth);

    // Total error bits accumulator
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            total_err_bit <= 64'd0;
        end else if (EN) begin
            total_err_bit <= total_err_bit + err_bits_count;
        end
    end

    //================================================================
    // Simulation Control and Reporting
    //================================================================
    initial begin
        // **NEW**: Stop the simulation and print the results
        #3000;
        $display("-------------------------------------------------");
        $display("Simulation Finished at time %0t ns", $time);
        $display("Total bits sent: %d", total_send_bits);
        $display("Total error bits: %d", total_err_bit);
        if (total_send_bits > 0) begin
            // Use 'real' type for division to get a floating-point result
            $display("Bit Error Rate (BER): %e", $itor(total_err_bit) / $itor(total_send_bits));
        end else begin
            $display("No bits sent, cannot calculate BER.");
        end
        $display("-------------------------------------------------");
        $finish;
    end

endmodule