`timescale 1ns/1ps

module fec_tx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_K          = 229,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,

    // 上游原始 8bit 数据（也可以内部接 PRBS）
    input  wire [7:0]       i_data,
    input  wire             i_valid,
    output wire             i_ready,

    // 输出给 GTH TX 的 32bit 数据
    output wire [W-1:0]     o_tx_data,
    output wire             o_tx_valid,
    output wire [31:0]      o_tx_data_line,
    output wire             o_tx_valid_line,
    output wire [15:0]      o_tx_frame_index
);

    wire rst = ~rst_n;

    // ================= RS 编码 =================
    wire [7:0] enc_data;
    wire       enc_valid;
    wire xpm_input_tready;


    rs_encode_frontend rs_encode_frontend (
        .clk                    (line_clk),                   // 上游 8bit 数据时钟
        .enc_clk                (core_clk),                // RS 编码 IP 的工作时钟
        .rst                    (rst),

        // 上游 8 bit 输入
        .fifo_input_rdy         (i_ready),
        .data_i                 (i_data),
        .data_valid_i           (i_valid),

        // 下游 RS 编码 IP 的 AXIS 输出
        .m_axis_output_tready   (xpm_input_tready),
        .m_axis_output_tdata    (enc_data),
        .m_axis_output_tvalid   (enc_valid)
    );

    // ================= 交织器 ==================
    wire        intlv_valid;
    wire [7:0]  intlv_data;
    wire        intlv_block_start;

    rs_interleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_interleaver (
        .clk            (core_clk),
        .rst            (rst),
        .in_valid       (enc_valid),
        .in_data        (enc_data),
        .in_ready       (xpm_input_tready),          // 模块内部 assign 1'b1
        // .in_tlast       (1'b0),
        .out_valid      (intlv_valid),
        .out_data       (intlv_data),
        .out_block_start(intlv_block_start)
    );

    // =============== 8bit → 32bit 打包 + 块起始 ===============
    wire [31:0] payload_word;
    wire        payload_word_valid;
    wire        block_start_word;

    gearbox_8to32_bs u_gb_8to32 (
        .clk             (core_clk),
        .rst             (rst),
        .in_data         (intlv_data),
        .in_valid        (intlv_valid),
        .in_block_start  (intlv_block_start),
        .out_data        (payload_word),
        .out_valid       (payload_word_valid),
        .out_block_start (block_start_word)
    );

    // ================= 帧封装器 =================
    fso_framer #(
        .W             (W),
        .PAYLOAD_WORDS (PAYLOAD_WORDS)
    ) u_fso_framer (
        .clk              (core_clk),
        .rst_n            (rst_n),
        .i_payload_data   (payload_word),
        .i_payload_valid  (payload_word_valid),
        .i_block_start_word(block_start_word),
        .o_payload_ready  (),            // 目前没有往回反压
        .o_tx_data        (o_tx_data),
        .o_tx_valid       (o_tx_valid),
        .o_frame_index    (o_tx_frame_index)
    );

    // =========== async FIFO: core_clk → line_clk ===============
    wire [31:0] tx32_fifo_dout;
    wire        tx32_fifo_empty;
    wire        tx32_fifo_full;
    wire        tx32_fifo_rd_en;               // line_clk 域读取
    wire        tx32_fifo_wrstbsy;
    wire        tx32_fifo_rrstbsy;

    async_fifo_32w_32r u_tx_fifo (
        .srst        (rst),
        .wr_clk     (core_clk),
        .rd_clk     (line_clk),
        .din        (o_tx_data),
        .wr_en      (o_tx_valid),
        .rd_en      (tx32_fifo_rd_en),
        .dout       (tx32_fifo_dout),
        .full       (tx32_fifo_full),
        .empty      (tx32_fifo_empty),  
        .wr_rst_busy(tx32_fifo_wrstbsy),  // output wire wr_rst_busy
        .rd_rst_busy(tx32_fifo_rrstbsy)  // output wire rd_rst_busy
    );

    // 真实 GTH 侧 TX 输出（line_clk 域）
    assign tx32_fifo_rd_en = ~tx32_fifo_empty;
    assign o_tx_data_line  = tx32_fifo_dout;
    assign o_tx_valid_line = ~tx32_fifo_empty;


endmodule
