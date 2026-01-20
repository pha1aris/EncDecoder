`timescale 1ns / 1ps

module EncDecoder_sim();

    localparam CORE_CLK_PERIOD = 10;  // 100 MHz
    localparam PRBS_CLK_PERIOD = 32;  // 31.25 MHz

    // ===== clocks / reset
    reg clk;
    reg prbs_clk;
    reg rst;

    // ===== PRBS gen -> Encoder
    wire [31:0] prbs_data;
    wire        encoder_fifo_wrrdy;

    // ===== Encoder -> Decoder (AXIS 8-bit)
    wire [7:0]  m_axis_tdata;
    wire        m_axis_tvalid;
    wire        m_axis_tready;
    wire        m_axis_tlast;

    // ===== Decoder -> PRBS checker (32-bit)
    wire [31:0] decoder_tdata;
    wire        decoder_tvalid;

    // ===== PRBS checker output
    wire [31:0] prbs_error_vector;
    wire        prbs_match = ~|prbs_error_vector;

    // core_clk
    initial begin
        clk = 1'b1;
        forever #(CORE_CLK_PERIOD/2) clk = ~clk;
    end

    // prbs_clk
    initial begin
        prbs_clk = 1'b1;
        forever #(PRBS_CLK_PERIOD/2) prbs_clk = ~prbs_clk;
    end

    // reset
    initial begin
        rst = 1'b1;
        repeat(10) @(posedge prbs_clk);
        rst = 1'b0;
    end

    // ================= PRBS-31 Generator
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_any_gen_inst (
        .RST       (rst),
        .CLK       (prbs_clk),
        .DATA_IN   (32'd0),
        .EN        (encoder_fifo_wrrdy),
        .DATA_OUT  (prbs_data)
    );

    // ================= Encoder
    Encoder #(
        .K_BYTES(229) // <<< 这里必须与你 RS Encoder 的“输入数据字节数(k)”一致
    ) Encoder_inst (
        .rst                    (rst),
        .input_fifo_clk         (prbs_clk),
        .core_clk               (clk),

        .data_i                 (prbs_data),
        .data_valid_i           (encoder_fifo_wrrdy),
        .input_fifo_wrrdy       (encoder_fifo_wrrdy),

        .m_axis_output_tdata    (m_axis_tdata),
        .m_axis_output_tvalid   (m_axis_tvalid),
        .m_axis_output_tready   (m_axis_tready),
        .m_axis_output_tlast    (m_axis_tlast)
    );

    // ================= Decoder (修正版：单核 decoder + 输出 FIFO)
    Decoder Decoder_inst (
        .rst                    (rst),
        .core_clk               (clk),
        .output_clk             (clk),         // <<< 你原来没连，这里必须连

        .s_axis_input_tdata     (m_axis_tdata),
        .s_axis_input_tvalid    (m_axis_tvalid),
        .s_axis_input_tlast     (m_axis_tlast),
        .s_axis_input_tready    (m_axis_tready),

        .output_tdata           (decoder_tdata),
        .output_tvalid          (decoder_tvalid),
        .output_tready          (1'b1)
    );

    // （可选）如果你怀疑 32->8 与 8->32 的字节序不一致，可以打开 swap 试一下
    // localparam SWAP32 = 1'b0;
    // wire [31:0] checker_data = SWAP32 ? {decoder_tdata[7:0],decoder_tdata[15:8],decoder_tdata[23:16],decoder_tdata[31:24]}
    //                                   : decoder_tdata;

    // ================= PRBS-31 Checker
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker_inst (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (decoder_tdata),   // 或者用 checker_data
        .EN       (decoder_tvalid),
        .DATA_OUT (prbs_error_vector)
    );

endmodule
