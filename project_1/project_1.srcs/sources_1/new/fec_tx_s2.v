//==============================================================
// fec_tx_s2
//==============================================================
module fec_tx_s2 #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,

    parameter integer RS_K             = 229,
    parameter integer RS_N             = 255,

    parameter integer INTLV_D          = 64,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,

    input  wire [7:0]       i_data,
    input  wire             i_valid,
    output wire             i_ready,

    input  wire             scrambler_en,
    output wire [31:0]      o_tx_data_line,
    output wire             o_tx_valid_line,
    output wire [15:0]      o_tx_frame_index
);
    wire rst = ~rst_n;

    // RS encode frontend
    wire [7:0] enc_data;
    wire       enc_valid;
    wire       enc_last;
    wire       enc_out_ready;
    wire       enc_fifo_rdy;

    assign i_ready = enc_fifo_rdy;

    rs_encode_frontend #(
        .RS_K(RS_K)
    ) u_rs_encode_frontend (
        .clk                  (core_clk),
        .enc_clk              (core_clk),
        .rst                  (rst),

        .fifo_input_rdy       (enc_fifo_rdy),
        .data_i               (i_data),
        .data_valid_i         (i_valid),

        .m_axis_output_tready (enc_out_ready),
        .m_axis_output_tlast  (enc_last),
        .m_axis_output_tdata  (enc_data),
        .m_axis_output_tvalid (enc_valid)
    );

    // block_start every INTLV_D*RS_N bytes
    localparam integer BLK_OUT_BYTES = INTLV_D * RS_N;
    localparam integer BLK_W = (BLK_OUT_BYTES <= 2) ? 1 : $clog2(BLK_OUT_BYTES);

    reg [BLK_W-1:0] blk_out_idx;
    wire rs_out_fire = enc_valid && enc_out_ready;

    wire enc_block_start = enc_valid && (blk_out_idx == {BLK_W{1'b0}});

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            blk_out_idx <= {BLK_W{1'b0}};
        end else if (rs_out_fire) begin
            if (blk_out_idx == BLK_OUT_BYTES-1)
                blk_out_idx <= {BLK_W{1'b0}};
            else
                blk_out_idx <= blk_out_idx + 1'b1;
        end
    end

    // 8->32 gearbox
    wire [31:0] gb_data;
    wire        gb_valid;
    wire        gb_block_start;
    wire        gb_ready;

    gearbox_8to32_bs u_gb_8to32 (
        .clk            (core_clk),
        .rst            (rst),

        .in_data        (enc_data),
        .in_valid       (enc_valid),
        .in_block_start (enc_block_start),
        .in_ready       (enc_out_ready),

        .out_ready      (gb_ready),
        .out_data       (gb_data),
        .out_valid      (gb_valid),
        .out_block_start(gb_block_start)
    );

    // framer
    wire [W-1:0] o_tx_data;
    wire         o_tx_valid;

    wire tx32_fifo_full;
    wire tx32_fifo_wrstbsy;
    wire tx32_wr_ready_raw = ~tx32_fifo_full & ~tx32_fifo_wrstbsy;

    fso_framer #(
      .W                (W),
      .PAYLOAD_WORDS    (PAYLOAD_WORDS),
      .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_fso_framer (
      .clk                   (core_clk),
      .rst_n                 (rst_n),

      .i_payload_data        (gb_data),
      .i_payload_valid       (gb_valid),
      .i_payload_block_start (gb_block_start),
      .scrambler_en          (scrambler_en),
      .o_payload_ready       (gb_ready),

      .i_tx_ready            (tx32_wr_ready_raw),
      .o_tx_data             (o_tx_data),
      .o_tx_valid            (o_tx_valid),
      .o_frame_in_block      (),
      .o_block_id            (),
      .o_frame_index         (o_tx_frame_index)
    );

    // async fifo core->line
    wire        tx32_fifo_empty;
    wire        tx32_fifo_rrstbsy;
    wire [31:0] tx32_fifo_dout;
    wire        tx32_fifo_rd_en;
    wire [11:0] tx_fifo_rdcnt;
    wire [11:0] tx_fifo_wrcnt;

    reg rst_sync_d0, rst_sync_d1;
    always @(posedge line_clk or posedge rst) begin
        if (rst) begin
            rst_sync_d0 <= 1'b1;
            rst_sync_d1 <= 1'b1;
        end else begin
            rst_sync_d0 <= 1'b0;
            rst_sync_d1 <= rst_sync_d0;
        end
    end

    async_fifo_32w_32r u_tx_fifo (
        .rst           (rst_sync_d1),
        .wr_clk        (core_clk),
        .rd_clk        (line_clk),
        .din           (o_tx_data),
        .wr_en         (o_tx_valid && tx32_wr_ready_raw),
        .rd_en         (tx32_fifo_rd_en),
        .dout          (tx32_fifo_dout),
        .full          (tx32_fifo_full),
        .empty         (tx32_fifo_empty),
        .rd_data_count (tx_fifo_rdcnt),
        .wr_data_count (tx_fifo_wrcnt),
        .wr_rst_busy   (tx32_fifo_wrstbsy),
        .rd_rst_busy   (tx32_fifo_rrstbsy)
    );

    // line burst
    localparam [31:0] IDLE_WORD    = 32'h0707_0707;
    localparam integer FRAME_WORDS = PAYLOAD_WORDS + 4;

    localparam [1:0] L_IDLE  = 2'd0;
    localparam [1:0] L_BURST = 2'd1;

    reg [1:0]  lstate;
    reg [15:0] burst_rem;
    reg        rd_en_r;
    reg [31:0] dout_r;
    reg        vld_r;

    wire fifo_has_one_frame =
        (!tx32_fifo_rrstbsy) &&
        (!tx32_fifo_empty)  &&
        (tx_fifo_rdcnt >= FRAME_WORDS[11:0]);

    always @(posedge line_clk or posedge rst) begin
        if (rst) begin
            lstate   <= L_IDLE;
            burst_rem<= 16'd0;
            rd_en_r  <= 1'b0;
            dout_r   <= IDLE_WORD;
            vld_r    <= 1'b0;
        end else begin
            rd_en_r <= 1'b0;

            if (tx32_fifo_rrstbsy) begin
                lstate <= L_IDLE;
                burst_rem <= 16'd0;
                dout_r <= IDLE_WORD;
                vld_r  <= 1'b0;
            end else begin
                case (lstate)
                    L_IDLE: begin
                        dout_r <= IDLE_WORD;
                        vld_r  <= 1'b0;
                        if (fifo_has_one_frame) begin
                            lstate <= L_BURST;
                            burst_rem <= FRAME_WORDS[15:0];

                            rd_en_r <= 1'b1;
                            dout_r  <= tx32_fifo_dout;
                            vld_r   <= 1'b1;
                            burst_rem <= FRAME_WORDS[15:0] - 16'd1;
                        end
                    end

                    L_BURST: begin
                        if (tx32_fifo_empty) begin
                            lstate <= L_IDLE;
                            burst_rem <= 16'd0;
                            dout_r <= IDLE_WORD;
                            vld_r  <= 1'b0;
                        end else begin
                            rd_en_r <= 1'b1;
                            dout_r  <= tx32_fifo_dout;
                            vld_r   <= 1'b1;

                            if (burst_rem == 16'd1) begin
                                lstate <= L_IDLE;
                                burst_rem <= 16'd0;
                            end else begin
                                burst_rem <= burst_rem - 16'd1;
                            end
                        end
                    end
                endcase
            end
        end
    end

    assign tx32_fifo_rd_en = rd_en_r;
    assign o_tx_data_line  = dout_r;
    assign o_tx_valid_line = vld_r;

endmodule
