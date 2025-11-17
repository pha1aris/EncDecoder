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

    // 解码后的数据（注意：这里我改成 32bit，对齐 rs_decode_backend）
    output wire [31:0]      o_data,
    output wire             o_valid,

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
    // 写侧：bit_aligner 输出
    assign rx32_fifo_wr_en = aligned_valid;  // 每来一个对齐好的 word 就写

    async_fifo_32w_32r u_rx_fifo (
        .srst        (rst),
        .wr_clk      (line_clk),
        .rd_clk      (core_clk),
        .din         (aligned_data), //是否需要将控制信号一同输入fifo进行同步？
        .wr_en       (rx32_fifo_wr_en),
        .rd_en       (rx32_fifo_rd_en),
        .dout        (rx32_fifo_dout),
        .full        (rx32_fifo_full),
        .empty       (rx32_fifo_empty),
        .wr_rst_busy (rx32_fifo_wr_rst_busy),
        .rd_rst_busy (rx32_fifo_rd_rst_busy)
    );

    // 读侧：core_clk 域持续读（或者根据 deframer 需要读）
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

    gearbox_32to8 u_gb_32to8 (
        .clk      (core_clk),
        .rst      (rst),
        .in_data  (rx_payload_data),
        .in_valid (rx_payload_valid),
        .out_data (gb8_data),
        .out_valid(gb8_valid)
    );

    // 将 blk_soft_rst 同步一拍后送给去交织器
    reg blk_soft_rst_d;
    always @(posedge core_clk or posedge rst) begin
        if (rst)
            blk_soft_rst_d <= 1'b0;
        else
            blk_soft_rst_d <= blk_soft_rst;
    end

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
        .blk_soft_rst(blk_soft_rst_d),
        .in_valid    (gb8_valid),
        .in_data     (gb8_data),
        .in_ready    (),              // 目前不做反压，保持内部 ready=1 的风格
        .block_start (deintlv_block_start),
        .out_valid   (deintlv_valid),
        .out_data    (deintlv_data)
    );

    // =================== RS 解码后端 ========================
    //
    // 这里用你贴出来、已经验证过的 rs_decode_backend。
    // 它的输入是 8bit AXIS，需要我们提供：
    //   - s_axis_input_tdata  : deintlv_data
    //   - s_axis_input_tvalid : deintlv_valid
    //   - s_axis_input_tlast  : 本地按 255 计数生成
    // 输出是 32bit AXIS：output_tdata/output_tvalid
    // 这里先简单把 output_tready 固定为 1'b1（始终可接受），
    // 方便联调；以后如果要再接后级 AXIS，可以把 ready 做成端口往外引。

    // =================== RS 解码前的 tlast 生成 ========================
    // RS_N = 255（每个码字 255 字节）
    // deintlv_block_start：交织块的第一个 symbol，与 out_valid 同拍

    reg [8:0] rs_byte_cnt;   
    reg       rs_tlast;
    reg       rs_in_sync;    // 是否已经block_start完成一次同步

    wire s_axis_input_fire  = deintlv_valid & s_axis_input_tready;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            rs_byte_cnt <= 9'd0;
            rs_tlast    <= 1'b0;
            rs_in_sync  <= 1'b0;
        end else begin
            rs_tlast <= 1'b0;  

            if (s_axis_input_fire) begin
                if (deintlv_block_start) begin
                    rs_byte_cnt <= 9'd0;  
                    rs_in_sync  <= 1'b1;  // 从这拍开始认为已经对齐好了

                end else if (rs_in_sync) begin
                    if (rs_byte_cnt == RS_N-1) begin// 当前这个字节是一个 RS 码字的最后一个字节
                        rs_tlast    <= 1'b1;
                        rs_byte_cnt <= 9'd0;   // 下一拍的字节将是“下一码字的 index=0”
                    end else begin
                        rs_byte_cnt <= rs_byte_cnt + 1'b1;
                    end
                end
            end
        end
    end


    wire        s_axis_input_tready;
    wire [31:0] dec32_data;
    wire        dec32_valid;

    rs_decode_backend u_rs_decode_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (core_clk),   // 仿真/当前方案：先用同一个时钟，后面需要再拆时钟域可以改

        .s_axis_input_tdata  (deintlv_data),
        .s_axis_input_tvalid (deintlv_valid),
        .s_axis_input_tlast  (rs_tlast),
        .s_axis_input_tready (s_axis_input_tready), // 当前不回传给上游

        .output_tdata        (dec32_data),
        .output_tvalid       (dec32_valid),
        .output_tready       (1'b1)        // 下游永远 ready，方便你现在做联调
    );

    // 直接把 32bit 输出映射到 fec_rx 的输出口
    assign o_data  = dec32_data;
    assign o_valid = dec32_valid;

endmodule
