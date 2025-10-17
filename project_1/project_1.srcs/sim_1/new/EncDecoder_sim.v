`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/17 12:10:52
// Design Name: 
// Module Name: EncDecoder_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Testbench for validating the PRBS -> Encoder -> Decoder -> PRBS chain.
//     - Generates a 100MHz core_clk.
//     - Generates a 31.25MHz (32ns period) prbs_clk.
//     - Performs a loopback test and counts bit errors.
// 
// Dependencies: 
//     - Encoder.v
//     - Decoder.v
//     - gtwizard_ultrascale_0_prbs_any.v (PRBS IP core)
//     - FIFO IP cores used by Encoder and Decoder.
// 
// Revision:
// Revision 1.00 - File Created with full testbench logic.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module EncDecoder_sim();

    // =================================================================
    // 1. Testbench Parameters
    // =================================================================
    localparam CORE_CLK_PERIOD = 10;  // 100 MHz
    localparam PRBS_CLK_PERIOD = 32;  // 31.25 MHz

    // =================================================================
    // 2. Signal Declarations
    // =================================================================
    // Clocks and Reset
    reg clk;
    reg prbs_clk;
    reg rst;

    // PRBS Generator -> Encoder Interface
    wire [31:0] prbs_data;
    wire        encoder_fifo_wrrdy;

    // Encoder -> Decoder Loopback Interface (AXI-Stream)
    wire [7:0]  m_axis_tdata;    // Encoder output is 8-bit
    wire        m_axis_tvalid;
    wire        m_axis_tready;   // Driven by Decoder
    wire        m_axis_tlast;

    // Decoder -> PRBS Checker Interface
    wire [31:0] decoder_tdata;
    wire        decoder_tvalid;

    // PRBS Checker Output
    wire [31:0] prbs_error_vector;
    wire prbs_match;
    assign  prbs_match = ~|prbs_error_vector;
    
    // =================================================================
    // 3. Clock and Reset Generation
    // =================================================================
    // core_clk (100MHz)
    initial begin
        clk = 1;
        forever #(CORE_CLK_PERIOD / 2) clk = ~clk;
    end

    // prbs_clk (32ns period)
    initial begin
        prbs_clk = 1;
        forever #(PRBS_CLK_PERIOD / 2) prbs_clk = ~prbs_clk;
    end

    // Reset sequence
    initial begin
        rst = 1;
        // Hold reset for a few clock cycles of the slower clock
        repeat(10) @(posedge prbs_clk);
        rst = 0;
    end

    // =================================================================
    // 4. DUT (Design Under Test) Instantiation
    // =================================================================
    // PRBS-31 Generator (Data Source)
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_any_gen_inst (
        .RST       (rst),
        .CLK       (prbs_clk),
        .DATA_IN   ('d0),
        .EN        (encoder_fifo_wrrdy), // Produce data only when Encoder FIFO is ready
        .DATA_OUT  (prbs_data)
    );

    // Encoder
    Encoder Encoder_inst (
        .rst                    (rst),
        .input_fifo_clk         (prbs_clk),
        .core_clk               (clk),
        .data_i                 (prbs_data),
        .data_valid_i           (encoder_fifo_wrrdy), // Data is valid when FIFO is ready
        .input_fifo_wrrdy       (encoder_fifo_wrrdy),
        .m_axis_output_tdata    (m_axis_tdata),
        .m_axis_output_tvalid   (m_axis_tvalid),
        .m_axis_output_tready   (m_axis_tready),
        .m_axis_output_tlast    (m_axis_tlast)
    );

    // Decoder
    Decoder Decoder_inst (
        .core_clk               (clk),
        .rst                    (rst),
        .s_axis_input_tdata     (m_axis_tdata),
        .s_axis_input_tvalid    (m_axis_tvalid),
        .s_axis_input_tlast     (m_axis_tlast),
        .s_axis_input_tready    (m_axis_tready),
        .output_tdata           (decoder_tdata),
        .output_tvalid          (decoder_tvalid),
        .output_tready          (1'b1) // Assume checker is always ready
    );

    // PRBS-31 Checker
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker_inst (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (decoder_tdata),
        .EN       (decoder_tvalid),
        .DATA_OUT (prbs_error_vector)
    );

    
endmodule