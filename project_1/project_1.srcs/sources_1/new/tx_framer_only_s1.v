`timescale 1ns/1ps

module tx_framer_only_s1 #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input  wire        line_clk,
    input  wire        core_clk,
    input  wire        rst_n,

    input  wire        scrambler_en,

    input  wire [7:0]  i_data,
    input  wire        i_valid,
    output wire        o_ready,

    output wire [W-1:0] o_tx_data_line,
    output wire         o_tx_valid_line,
    output wire [15:0]  o_tx_frame_index
);
    wire rst = ~rst_n;

    // ---- 生成 block_start(byte) ：每个 block = FRAMES_PER_BLOCK 帧，每帧 PAYLOAD_WORDS*4 字节
    localparam integer BYTES_PER_FRAME = PAYLOAD_WORDS * 4;
    localparam integer BYTES_PER_BLOCK = BYTES_PER_FRAME * FRAMES_PER_BLOCK;
    localparam integer BCW = (BYTES_PER_BLOCK <= 2) ? 2 : $clog2(BYTES_PER_BLOCK);

    reg [BCW-1:0] byte_cnt_in_block;
    wire byte_fire = i_valid & o_ready;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            byte_cnt_in_block <= 'd0;
        end else if (byte_fire) begin
            if (byte_cnt_in_block == BYTES_PER_BLOCK-1)
                byte_cnt_in_block <= 'd0;
            else
                byte_cnt_in_block <= byte_cnt_in_block + 1'b1;
        end
    end
    wire in_block_start_byte = (byte_cnt_in_block == 'd0);

    // ---- 8->32 gearbox（你原来用的 gearbox_8to32_bs）
    wire [31:0] gb_data;
    wire        gb_valid;
    wire        gb_block_start;
    wire        gb_ready;

    gearbox_8to32_bs u_gb_8to32 (
        .clk            (core_clk),
        .rst            (rst),

        .in_data        (i_data),
        .in_valid       (i_valid),
        .in_block_start (in_block_start_byte),
        .in_ready       (o_ready),

        .out_ready      (gb_ready),
        .out_data       (gb_data),
        .out_valid      (gb_valid),
        .out_block_start(gb_block_start)
    );

    // ---- framer（你的 fso_framer 原封不动）
    wire [W-1:0] o_tx_data;
    wire         o_tx_valid;
    wire         tx32_wr_ready;

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

        .i_tx_ready            (tx32_wr_ready),
        .o_tx_data             (o_tx_data),
        .o_tx_valid            (o_tx_valid),
        .o_frame_in_block      (),
        .o_block_id            (),
        .o_frame_index         (o_tx_frame_index)
    );

    // ---- async FIFO core_clk -> line_clk（你原有的 async_fifo_32w_32r）
    wire        tx32_fifo_empty, tx32_fifo_full;
    wire        tx32_fifo_wrstbsy, tx32_fifo_rrstbsy;
    wire [31:0] tx32_fifo_dout;
    wire        tx32_fifo_rd_en;
    wire [11:0] tx_fifo_rdcnt, tx_fifo_wrcnt;

    assign tx32_wr_ready = ~tx32_fifo_full & ~tx32_fifo_wrstbsy;

    // line_clk 域 reset sync（贴近原代码）
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
        .wr_en         (o_tx_valid && tx32_wr_ready),
        .rd_en         (tx32_fifo_rd_en),
        .dout          (tx32_fifo_dout),
        .full          (tx32_fifo_full),
        .empty         (tx32_fifo_empty),
        .rd_data_count (tx_fifo_rdcnt),
        .wr_data_count (tx_fifo_wrcnt),
        .wr_rst_busy   (tx32_fifo_wrstbsy),
        .rd_rst_busy   (tx32_fifo_rrstbsy)
    );

    // ---- line_clk burst：保证整帧连续输出（bit aligner/deframer 友好）
    localparam [31:0] IDLE_WORD    = 32'h0707_0707;
    localparam integer FRAME_WORDS = PAYLOAD_WORDS + 4; // 2 pre + 1 hdr + payload + 1 crc

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
