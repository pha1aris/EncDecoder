`timescale 1ns/1ps

module fec_rx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,

    // 来自 GTH RX 的并行数据（已经是 parallel data）
    input  wire [W-1:0]     i_rx_data,
    input  wire             i_rx_valid,
    input  wire             rx_reset_done,
    input  wire             rx_cdr_stable,

    // 解码后的数据（8bit）
    output wire [7:0]       o_data,
    output wire             o_valid,
    input  wire             i_data_ready,

    // 调试信号
    output wire             o_rxslide,
    output wire             o_bit_locked,
    output wire [15:0]      o_frame_index,
    output wire [15:0]      o_block_id,
    output wire [15:0]      o_frame_in_block
);

    wire rst = ~rst_n;

    // ==================== bit_aligner ====================
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         realign_req;

    bit_aligner #(
        .W                 (W),
        .VERIFY_CNT_MAX    (8),
        .SLIDE_COOLDOWN    (5),
        .ERR_TH            (0),
        .CHECK_TIMEOUT_MAX (2048)
    ) u_bit_aligner (
        .clk                (line_clk),  //慢时钟域
        .rst_n              (rst_n),
        .rx_reset_done      (rx_reset_done),
        .rx_cdr_stable      (rx_cdr_stable),
        .i_rx_data          (i_rx_data),
        .i_rx_valid         (i_rx_valid),
        .i_realign_req      (realign_req),
        .o_rxslide          (o_rxslide),
        .o_aligned_valid    (aligned_valid),
        .o_bit_locked       (o_bit_locked),
        .o_data_aligned     (aligned_data)
    );

    // ========== async FIFO: line_clk → core_clk ==========

    wire [W-1:0] rx32_fifo_dout;
    wire         rx32_fifo_empty;
    wire         rx32_fifo_full;
    wire         rx32_fifo_wr_rst_busy;
    wire         rx32_fifo_rd_rst_busy;
    wire         rx32_fifo_rd_en;
    wire         rx32_fifo_wr_en;

    assign rx32_fifo_wr_en = aligned_valid;  // 每来一个对齐好的 word 就写

    async_fifo_32w_32r u_rx_fifo (
        .rst        (rst),
        .wr_clk     (line_clk),
        .rd_clk     (core_clk),
        .din        (aligned_data), 
        .wr_en      (rx32_fifo_wr_en),
        .rd_en      (rx32_fifo_rd_en),
        .dout       (rx32_fifo_dout),
        .full       (rx32_fifo_full),
        .empty      (rx32_fifo_empty),
        .wr_rst_busy(rx32_fifo_wr_rst_busy),
        .rd_rst_busy(rx32_fifo_rd_rst_busy)
    );

    assign rx32_fifo_rd_en   = ~rx32_fifo_empty & ~rx32_fifo_rd_rst_busy;

    wire [W-1:0] aligned_data_c  = rx32_fifo_dout;
    wire         aligned_valid_c = ~rx32_fifo_empty & ~rx32_fifo_rd_rst_busy;

    // ==================== deframer =======================
    wire [W-1:0] rx_payload_data;
    wire         rx_payload_valid;

    wire [15:0]  frame_index_rx;
    wire [15:0]  block_id_rx;
    wire [15:0]  frame_in_block_rx;
    wire         blk_soft_rst;

    // line_clk → core_clk 的双触发同步
    reg [1:0] bit_locked_sync;
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            bit_locked_sync <= 2'b00;
        end else begin
            bit_locked_sync <= {bit_locked_sync[0], o_bit_locked};
        end
    end
    wire bit_locked_core = bit_locked_sync[1];

    fso_deframer #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (64)
    ) u_fso_deframer (
        .clk              (core_clk),   //快时钟域
        .rst_n            (rst_n),
        .i_link_up        (bit_locked_core),
        .i_rx_data        (aligned_data_c),
        .i_rx_valid       (aligned_valid_c),
        .o_realign_req    (realign_req),
        .o_frame_start    (),                 
        .o_frame_index    (frame_index_rx),
        .o_block_id       (block_id_rx),
        .o_frame_in_block (frame_in_block_rx),
        .o_blk_soft_rst   (blk_soft_rst),
        .o_payload_data   (rx_payload_data),
        .o_payload_valid  (rx_payload_valid)
    );

    assign o_frame_index    = frame_index_rx;
    assign o_block_id       = block_id_rx;
    assign o_frame_in_block = frame_in_block_rx;

    // =============== 32bit → 8bit gearbox ===============
    wire [7:0]  gb8_data;
    wire        gb8_valid;
    wire        out_sync_rst;

    gearbox_32to8 u_gb_32to8 (
        .clk            (core_clk),
        .rst            (rst),
        .in_sync_rst    (blk_soft_rst),
        .in_data        (rx_payload_data),
        .in_valid       (rx_payload_valid),
        .out_sync_rst   (out_sync_rst),
        .out_data       (gb8_data),
        .out_valid      (gb8_valid)
    );

    // =================== 去交织器 ========================
    wire [7:0] deintlv_data;
    wire       deintlv_valid;
    wire       deintlv_block_start;
    
    rs_deinterleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_deinterleaver (
        .clk         (core_clk),
        .rst         (rst),
        .blk_soft_rst(out_sync_rst),
        .in_valid    (gb8_valid),
        .in_data     (gb8_data),
        .in_ready    (),              // 目前不反压
        .block_start (deintlv_block_start),
        .out_valid   (deintlv_valid),
        .out_data    (deintlv_data)
    );

    // ====================================================
    // ★ 新增：9bit FIFO dec_rx_fifo
    //      把 {block_start, data} 一起排队
    // ====================================================

    wire [8:0] dec_rx_fifo_din  = {deintlv_block_start, deintlv_data};
    wire       dec_rx_fifo_wr_en;
    wire       dec_rx_fifo_rd_en;
    wire [8:0] dec_rx_fifo_dout;
    wire       dec_rx_fifo_full, dec_rx_fifo_empty;
    wire       dec_rx_fifo_wr_rst_busy, dec_rx_fifo_rd_rst_busy;

    assign dec_rx_fifo_wr_en = deintlv_valid;

    dec_rx_fifo u_dec_rx_fifo (
      .rst        (rst),                  // input wire rst
      .wr_clk     (core_clk),            // 写时钟：core_clk
      .rd_clk     (core_clk),            // 读时钟：core_clk（同域）
      .din        (dec_rx_fifo_din),     // input wire [8 : 0] din
      .wr_en      (dec_rx_fifo_wr_en),   // input wire wr_en
      .rd_en      (dec_rx_fifo_rd_en),   // input wire rd_en
      .dout       (dec_rx_fifo_dout),    // output wire [8 : 0] dout
      .full       (dec_rx_fifo_full),    // output wire full
      .empty      (dec_rx_fifo_empty),   // output wire empty
      .wr_rst_busy(dec_rx_fifo_wr_rst_busy),  // output wire wr_rst_busy
      .rd_rst_busy(dec_rx_fifo_rd_rst_busy)   // output wire rd_rst_busy
    );

    // FIFO 读口视角下的有效信号
    wire fifo_out_valid = ~dec_rx_fifo_empty & ~dec_rx_fifo_rd_rst_busy;
    wire fifo_block_start = dec_rx_fifo_dout[8];
    wire [7:0] fifo_data  = dec_rx_fifo_dout[7:0];

    // =================== RS 解码前端：计数 + tlast ========================

    reg  [7:0] rs_byte_cnt;
    reg        rs_in_sync;

    wire       s_axis_input_tready;   // 来自 rs_decode_backend
    wire       s_axis_input_fire;     // 真正被解码器“吃掉”的 symbol

    // AXIS 到解码器：valid 由 FIFO 是否为空决定，data 来自 FIFO
    wire       s_axis_input_tvalid = fifo_out_valid;
    wire [7:0] s_axis_input_tdata  = fifo_data;

    // 当 FIFO 有数据且解码器 ready 时，拉 rd_en，表示这一拍的 symbol 被“消费”
    assign dec_rx_fifo_rd_en = fifo_out_valid & s_axis_input_tready;

    assign s_axis_input_fire = dec_rx_fifo_rd_en;

    // tlast：在码字的第 254 个 symbol 上拉高（0..254 共 255 个）
    wire rs_tlast = (rs_byte_cnt == 8'd254) && s_axis_input_fire;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            rs_byte_cnt <= 8'd0;
            rs_in_sync  <= 1'b0;
        end else begin
            if (s_axis_input_fire) begin
                if (fifo_block_start) begin
                    // 当前这个 symbol 定义为新码字 index=0
                    rs_byte_cnt <= 8'd1;
                    rs_in_sync  <= 1'b1;
                end else if (rs_in_sync) begin
                    if (rs_byte_cnt == RS_N-1) begin
                        // 当前这一拍是 index=254，下一拍从 0 开始
                        rs_byte_cnt <= 8'd0;
                    end else begin
                        rs_byte_cnt <= rs_byte_cnt + 1'b1;
                    end
                end
            end
        end
    end

    // =================== RS 解码后端（双 decoder + 内部 8bit FIFO） ========================

    wire [7:0]  dec_data;
    wire        dec_valid;

    rs_decode_backend u_rs_decode_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (core_clk),   

        .s_axis_input_tdata  (s_axis_input_tdata),
        .s_axis_input_tvalid (s_axis_input_tvalid),
        .s_axis_input_tlast  (rs_tlast),
        .s_axis_input_tready (s_axis_input_tready),

        .output_tdata        (dec_data),
        .output_tvalid       (dec_valid),
        .output_tready       (i_data_ready)
    );

    assign o_data  = dec_data;
    assign o_valid = dec_valid;

endmodule
