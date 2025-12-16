`timescale 1ns/1ps
`include "global_defines.vh"

module rs_deinterleaver_xpm #(
    parameter integer D = 4808,
    parameter integer N = 255
)(
    input  wire         clk,
    input  wire         rst,          // 全局硬复位
    input  wire         blk_soft_rst, // 块对齐软复位（来自 deframer/gearbox）

    input  wire         in_valid,
    input  wire [7:0]   in_data,
    output wire         in_ready,

    output wire         out_valid,
    output wire [7:0]   out_data,
    output wire         block_start,
    input  wire         out_ready
);

`ifdef SIM
    reg [31:0] drop_cnt;
    always @(posedge clk or posedge rst) begin
      if (rst) drop_cnt <= 0;
      else if (in_valid && !in_ready) drop_cnt <= drop_cnt + 1;
    end
`endif

    // ===================== 常量 =====================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W);
    localparam integer MAX_D      = MAX_DEPTH / N;
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;

    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

    localparam integer MEM_SIZE_BITS = (1 << SYM_IDX_W) * 8;

`ifdef SIM
    initial begin
        if (D > MAX_D) begin
            $display("[%0t] WARNING(rs_deinterleaver_xpm): D=%0d > MAX_D=%0d, D_EFF=%0d",
                     $time, D, MAX_D, D_EFF);
        end
        if (TOTAL_SYM > MAX_DEPTH) begin
            $display("[%0t] ERROR(rs_deinterleaver_xpm): TOTAL_SYM=%0d > MAX_DEPTH=%0d",
                     $time, TOTAL_SYM, MAX_DEPTH);
        end
    end
`endif

    wire hard_rst = rst;
    wire soft_rst = blk_soft_rst;

    // ===================== 写侧：列优先写入 + 双 bank =====================
    reg  [ROW_W-1:0]     wr_row;
    reg  [COL_W-1:0]     wr_col;
    reg  [SYM_IDX_W-1:0] wr_cnt;
    reg                  wr_bank;

    reg  [1:0]           block_ready;

    wire [ROW_W-1:0]     wr_row_base  = soft_rst ? {ROW_W{1'b0}}     : wr_row;
    wire [COL_W-1:0]     wr_col_base  = soft_rst ? {COL_W{1'b0}}     : wr_col;
    wire [SYM_IDX_W-1:0] wr_cnt_base  = soft_rst ? {SYM_IDX_W{1'b0}} : wr_cnt;
    wire                 wr_bank_base = soft_rst ? 1'b0              : wr_bank;

    wire cur_bank_full = (~soft_rst) && block_ready[wr_bank_base];

    wire in_can_fire = ~hard_rst & ~cur_bank_full;
    assign in_ready  = in_can_fire;

    wire wr_fire     = in_valid && in_can_fire;
    wire wr_last_sym = wr_fire && (wr_cnt_base == TOTAL_SYM-1);

    wire [SYM_IDX_W-1:0] wr_row_ext   = wr_row_base;
    wire [SYM_IDX_W-1:0] wr_col_ext   = wr_col_base;
    wire [SYM_IDX_W-1:0] wr_row_mul_N = wr_row_ext * N;
    wire [SYM_IDX_W-1:0] wr_sym_idx   = wr_row_mul_N + wr_col_ext;

    reg  [ROW_W-1:0]     wr_row_nxt;
    reg  [COL_W-1:0]     wr_col_nxt;
    reg  [SYM_IDX_W-1:0] wr_cnt_nxt;
    reg                  wr_bank_nxt;

    always @* begin
        wr_row_nxt  = wr_row;
        wr_col_nxt  = wr_col;
        wr_cnt_nxt  = wr_cnt;
        wr_bank_nxt = wr_bank;

        if (wr_fire) begin
            if (wr_row_base == D_EFF-1) begin
                wr_row_nxt = {ROW_W{1'b0}};
                if (wr_col_base == N-1)
                    wr_col_nxt = {COL_W{1'b0}};
                else
                    wr_col_nxt = wr_col_base + 1'b1;
            end else begin
                wr_row_nxt = wr_row_base + 1'b1;
                wr_col_nxt = wr_col_base;
            end

            if (wr_cnt_base == TOTAL_SYM-1) begin
                wr_cnt_nxt  = {SYM_IDX_W{1'b0}};
                wr_bank_nxt = ~wr_bank_base;
            end else begin
                wr_cnt_nxt  = wr_cnt_base + 1'b1;
                wr_bank_nxt = wr_bank_base;
            end

        end else if (soft_rst) begin
            wr_row_nxt  = {ROW_W{1'b0}};
            wr_col_nxt  = {COL_W{1'b0}};
            wr_cnt_nxt  = {SYM_IDX_W{1'b0}};
            wr_bank_nxt = 1'b0;
        end
    end

    always @(posedge clk or posedge hard_rst) begin
        if (hard_rst) begin
            wr_row  <= {ROW_W{1'b0}};
            wr_col  <= {COL_W{1'b0}};
            wr_cnt  <= {SYM_IDX_W{1'b0}};
            wr_bank <= 1'b0;
        end else begin
            wr_row  <= wr_row_nxt;
            wr_col  <= wr_col_nxt;
            wr_cnt  <= wr_cnt_nxt;
            wr_bank <= wr_bank_nxt;
        end
    end

    wire wea0 = wr_fire && (wr_bank_base == 1'b0);
    wire wea1 = wr_fire && (wr_bank_base == 1'b1);

    // ===================== 读侧：线性读出 + 双 bank =====================
    reg  [SYM_IDX_W-1:0] rd_sym_idx;
    reg                  rd_busy;
    reg                  rd_bank;

    wire have_block0     = block_ready[0];
    wire have_block1     = block_ready[1];
    wire any_block_ready = have_block0 | have_block1;
    wire next_rd_bank    = have_block0 ? 1'b0 : 1'b1;

    wire ofifo_in_ready;

    // 同 interleaver：地址拍仍然保守地看 FIFO ready
    wire rd_fire = rd_busy && ofifo_in_ready;

    wire rd_last_sym = rd_fire && (rd_sym_idx == TOTAL_SYM-1);

    wire [SYM_IDX_W-1:0] rd_addr = rd_sym_idx;

    always @(posedge clk or posedge hard_rst) begin
        if (hard_rst) begin
            rd_sym_idx <= {SYM_IDX_W{1'b0}};
            rd_busy    <= 1'b0;
            rd_bank    <= 1'b0;
        end else if (soft_rst) begin
            rd_sym_idx <= {SYM_IDX_W{1'b0}};
            rd_busy    <= 1'b0;
            rd_bank    <= 1'b0;
        end else begin
            if (!rd_busy) begin
                if (any_block_ready && ofifo_in_ready) begin
                    rd_busy    <= 1'b1;
                    rd_bank    <= next_rd_bank;
                    rd_sym_idx <= {SYM_IDX_W{1'b0}};
                end
            end else if (rd_fire) begin
                if (rd_sym_idx == TOTAL_SYM-1) begin
                    rd_sym_idx <= {SYM_IDX_W{1'b0}};
                    rd_busy    <= 1'b0;
                end else begin
                    rd_sym_idx <= rd_sym_idx + 1'b1;
                end
            end
        end
    end

    // ===================== block_ready 更新 =====================
    always @(posedge clk or posedge hard_rst) begin
        if (hard_rst) begin
            block_ready <= 2'b00;
        end else if (soft_rst) begin
            block_ready <= 2'b00;
        end else begin
            if (wr_last_sym)
                block_ready[wr_bank] <= 1'b1;
            if (rd_last_sym)
                block_ready[rd_bank] <= 1'b0;
        end
    end

    // ===================== 双口 RAM（两个 bank） =====================
    wire [7:0] doutb0, doutb1;

`ifdef SIM
    reg [7:0] mem0 [0:TOTAL_SYM-1];
    reg [7:0] mem1 [0:TOTAL_SYM-1];
    reg [7:0] doutb0_r, doutb1_r;
    integer i;
    initial begin
        $display("rs_deinterleaver_xpm: dpram simulation model.");
        for (i = 0; i < TOTAL_SYM; i = i + 1) begin
            mem0[i] = 8'd0;
            mem1[i] = 8'd0;
        end
    end

    always @(posedge clk) begin
        if (wea0)
            mem0[wr_sym_idx] <= in_data;
        doutb0_r <= mem0[rd_addr];
    end

    always @(posedge clk) begin
        if (wea1)
            mem1[wr_sym_idx] <= in_data;
        doutb1_r <= mem1[rd_addr];
    end

    assign doutb0 = doutb0_r;
    assign doutb1 = doutb1_r;

`else
    xpm_memory_sdpram #(
        .ADDR_WIDTH_A        (SYM_IDX_W),
        .ADDR_WIDTH_B        (SYM_IDX_W),
        .BYTE_WRITE_WIDTH_A  (8),
        .CLOCKING_MODE       ("common_clock"),
        .ECC_MODE            ("no_ecc"),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .MEMORY_OPTIMIZATION ("true"),
        .MEMORY_PRIMITIVE    ("auto"),
        .MEMORY_SIZE         (MEM_SIZE_BITS),
        .MESSAGE_CONTROL     (0),
        .READ_DATA_WIDTH_B   (8),
        .READ_LATENCY_B      (1),
        .READ_RESET_VALUE_B  ("0"),
        .RST_MODE_A          ("SYNC"),
        .RST_MODE_B          ("SYNC"),
        .SIM_ASSERT_CHK      (0),
        .USE_MEM_INIT        (1),
        .WAKEUP_TIME         ("disable_sleep"),
        .WRITE_DATA_WIDTH_A  (8),
        .WRITE_MODE_B        ("read_first")
    ) u_mem0 (
        .clka        (clk),
        .ena         (1'b1),
        .wea         (wea0),
        .addra       (wr_sym_idx),
        .dina        (in_data),
        .injectsbiterra(1'b0),
        .injectdbiterra(1'b0),
        .clkb        (clk),
        .enb         (1'b1),
        .addrb       (rd_addr),
        .doutb       (doutb0),
        .regceb      (1'b1),
        .rstb        (hard_rst | soft_rst),
        .sleep       (1'b0),
        .sbiterrb    (),
        .dbiterrb    ()
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A        (SYM_IDX_W),
        .ADDR_WIDTH_B        (SYM_IDX_W),
        .BYTE_WRITE_WIDTH_A  (8),
        .CLOCKING_MODE       ("common_clock"),
        .ECC_MODE            ("no_ecc"),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .MEMORY_OPTIMIZATION ("true"),
        .MEMORY_PRIMITIVE    ("auto"),
        .MEMORY_SIZE         (MEM_SIZE_BITS),
        .MESSAGE_CONTROL     (0),
        .READ_DATA_WIDTH_B   (8),
        .READ_LATENCY_B      (1),
        .READ_RESET_VALUE_B  ("0"),
        .RST_MODE_A          ("SYNC"),
        .RST_MODE_B          ("SYNC"),
        .SIM_ASSERT_CHK      (0),
        .USE_MEM_INIT        (1),
        .WAKEUP_TIME         ("disable_sleep"),
        .WRITE_DATA_WIDTH_A  (8),
        .WRITE_MODE_B        ("read_first")
    ) u_mem1 (
        .clka        (clk),
        .ena         (1'b1),
        .wea         (wea1),
        .addra       (wr_sym_idx),
        .dina        (in_data),
        .injectsbiterra(1'b0),
        .injectdbiterra(1'b0),
        .clkb        (clk),
        .enb         (1'b1),
        .addrb       (rd_addr),
        .doutb       (doutb1),
        .regceb      (1'b1),
        .rstb        (hard_rst | soft_rst),
        .sleep       (1'b0),
        .sbiterrb    (),
        .dbiterrb    ()
    );
`endif

    wire [7:0] dout_mux = (rd_bank == 1'b0) ? doutb0 : doutb1;

    wire block_start_this = rd_fire && (rd_sym_idx == {SYM_IDX_W{1'b0}});

    // ===================== RAM 一拍延迟标志 =====================
    reg rd_fire_d1;
    reg block_start_d1;

    always @(posedge clk or posedge hard_rst) begin
        if (hard_rst) begin
            rd_fire_d1     <= 1'b0;
            block_start_d1 <= 1'b0;
        end else if (soft_rst) begin
            rd_fire_d1     <= 1'b0;
            block_start_d1 <= 1'b0;
        end else begin
            rd_fire_d1     <= rd_fire;
            block_start_d1 <= block_start_this;
        end
    end

    // ===================== ★关键修复：RAM->FIFO skid buffer =====================
    wire fifo_rst = hard_rst | soft_rst;

    wire       src_valid = rd_fire_d1;
    wire [7:0] src_data  = dout_mux;
    wire       src_flag  = block_start_d1;

    reg        skid_v;
    reg [7:0]  skid_d;
    reg        skid_f;

    wire       fifo_in_valid = skid_v ? 1'b1   : src_valid;
    wire [7:0] fifo_in_data  = skid_v ? skid_d : src_data;
    wire       fifo_in_flag  = skid_v ? skid_f : src_flag;

    always @(posedge clk or posedge hard_rst) begin
        if (hard_rst) begin
            skid_v <= 1'b0;
            skid_d <= 8'd0;
            skid_f <= 1'b0;
        end else if (soft_rst) begin
            skid_v <= 1'b0;
            skid_d <= 8'd0;
            skid_f <= 1'b0;
        end else begin
            if (ofifo_in_ready) begin
                if (skid_v) begin
                    if (src_valid) begin
                        skid_d <= src_data;
                        skid_f <= src_flag;
                        skid_v <= 1'b1;
                    end else begin
                        skid_v <= 1'b0;
                    end
                end
            end else begin
                if (!skid_v && src_valid) begin
                    skid_d <= src_data;
                    skid_f <= src_flag;
                    skid_v <= 1'b1;
                end
            end
        end
    end

`ifdef SIM
    always @(posedge clk) begin
        if (!fifo_rst) begin
            if (src_valid && skid_v && !ofifo_in_ready) begin
                $display("[%0t] DEINTERLEAVER SKID OVERFLOW (should never happen)", $time);
                // $stop;
            end
        end
    end
`endif

    // ===================== 输出 FIFO =====================
    wire [7:0]  ofifo_out_data;
    wire        ofifo_out_flag;
    wire        ofifo_out_valid;

    fifo_8b_flag_sync #(
        .DEPTH (128),
        .GUARD (1)
    ) u_out_fifo (
        .clk       (clk),
        .rst       (fifo_rst),

        .in_data   (fifo_in_data),
        .in_flag   (fifo_in_flag),
        .in_valid  (fifo_in_valid),
        .in_ready  (ofifo_in_ready),

        .out_data  (ofifo_out_data),
        .out_flag  (ofifo_out_flag),
        .out_valid (ofifo_out_valid),
        .out_ready (out_ready)
    );

    assign out_valid   = ofifo_out_valid;
    assign out_data    = ofifo_out_data;
    assign block_start = ofifo_out_flag;

`ifdef SIM
    always @(posedge clk) begin
        if (!fifo_rst && out_valid && (^out_data === 1'bx)) begin
            $display("[%0t] DEINTERLEAVER OUT X", $time);
            $stop;
        end
    end
`endif

endmodule
