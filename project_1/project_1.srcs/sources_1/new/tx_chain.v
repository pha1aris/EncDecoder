// File: tx_chain.v
`timescale 1ns / 1ps

module tx_chain (
    input  wire         clk,
    input  wire         rst,

    input wire          prbs_clk,

    // 交织后的数据输出接口 (AXI-Stream)
    output wire [31:0]  m_axis_tdata,
    output wire         m_axis_tvalid,
    input  wire         m_axis_tready,
    output wire         sync_tlast,
    output wire         encoder_tlast
);

    // 内部连线
    wire [31:0] prbs_data;
    wire        encoder_fifo_wrrdy;
    wire [7:0]  encoder_tdata;
    wire        encoder_tvalid;
    wire        encoder_tready;
    // wire        encoder_tlast;
    wire [31:0] sync_tdata;
    wire        sync_tvalid;
    wire        sync_tready;
    // wire        sync_tlast; // Sync模块应有tlast输出以正确传递帧边界

    // 1. PRBS-31 伪随机码生成器 (数据源)
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE               (0),
        .INV_PATTERN            (1),
        .POLY_LENGHT            (31),
        .POLY_TAP               (28),
        .NBITS                  (32)
    ) prbs_any_gen_inst (
        .RST                    (rst),
        .CLK                    (prbs_clk),
        .DATA_IN                ('d0),
        .EN                     (encoder_fifo_wrrdy), // 当编码器的输入FIFO准备好时，产生新数据
        .DATA_OUT               (prbs_data)
    );

    // 2. 编码器
    Encoder Encoder(
        .rst                   (rst),
        .input_fifo_clk        (prbs_clk),
        .core_clk              (clk),
        .data_i                (prbs_data),
        .data_valid_i          (encoder_fifo_wrrdy),
        .input_fifo_wrrdy      (encoder_fifo_wrrdy),

        .m_axis_output_tdata   (encoder_tdata),
        .m_axis_output_tvalid  (encoder_tvalid),
        .m_axis_output_tready  (encoder_tready),
        .m_axis_output_tlast   (encoder_tlast)
    );

    Sync Sync (
        .rst                            (rst),
        .core_clk                       (clk),
        .s_axis_input_tdata             (encoder_tdata),
        .s_axis_input_tvalid            (encoder_tvalid),
        .s_axis_input_tlast             (encoder_tlast),
        .s_axis_input_tready            (encoder_tready),
        // 32-bit AXI-Stream Master Interface (Output)
        .m_axis_output_tdata            (m_axis_tdata),
        .m_axis_output_tvalid           (m_axis_tvalid),
        .m_axis_output_tlast            (sync_tlast),
        .m_axis_output_tready           (m_axis_tready)
    );

    // 4. 交织器
    pre_interleaver #(
        .CODEWORD_SIZE              (256),
        .NUM_CODEWORDS              (4)
    ) pre_interleaver (
        .rst                        (rst),
        .clk                        (clk),
        .s_axis_tdata               (sync_tdata),
        .s_axis_tvalid              (sync_tvalid),
        .s_axis_tready              (sync_tready),
        // 交织器输出即为本模块的最终输出
        .m_axis_tdata               (m_axis_tdata),
        .m_axis_tvalid              (m_axis_tvalid),
        .m_axis_tready              (m_axis_tready)
    );

endmodule