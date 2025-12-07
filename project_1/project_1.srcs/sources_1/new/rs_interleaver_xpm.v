`timescale 1ns/1ps
`define SIM

module rs_interleaver_xpm #(
    parameter integer D = 4808,
    parameter integer N = 255
)(
    input  wire         clk,
    input  wire         rst,

    // 上游 RS 编码输出（未交织）
    input  wire         in_valid,
    input  wire [7:0]   in_data,
    output wire         in_ready,

    // 下游带 ready/valid 的输出（已交织）
    output wire         out_valid,
    output wire [7:0]   out_data,
    output wire         out_block_start,
    input  wire         out_ready
);

    // ===================== 常量 =====================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W);   // 1M symbol
    localparam integer MEM_SIZE   = MAX_DEPTH * 8;

    localparam integer MAX_D      = MAX_DEPTH / N;
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;

    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

`ifdef SIM
    initial begin
        if (D > MAX_D) begin
            $display("[%0t] WARNING(rs_interleaver_xpm): D=%0d > MAX_D=%0d, D_EFF=%0d",
                     $time, D, MAX_D, D_EFF);
        end
        if (TOTAL_SYM > MAX_DEPTH) begin
            $display("[%0t] ERROR(rs_interleaver_xpm): TOTAL_SYM=%0d > MAX_DEPTH=%0d",
                     $time, TOTAL_SYM, MAX_DEPTH);
        end
    end
`endif

    // ===================== 写侧：线性写入 + 双缓冲 =====================
    reg [SYM_IDX_W-1:0] wr_sym_idx;
    reg                 wr_bank;          // 当前写 bank：0/1
    reg [1:0]           block_ready;      // block_ready[b]=1 该 bank 有完整 block 等待读

    // 当前写 bank 是否已经有完整 block 等待读
    wire cur_bank_full = block_ready[wr_bank];

    // 只有当前写 bank 是“空”的才允许继续写入
    wire in_can_fire = ~rst & ~cur_bank_full;
    assign in_ready  = in_can_fire;

    wire wr_fire     = in_valid && in_can_fire;
    wire wr_last_sym = wr_fire && (wr_sym_idx == TOTAL_SYM-1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_sym_idx <= {SYM_IDX_W{1'b0}};
            wr_bank    <= 1'b0;
        end else if (wr_fire) begin
            if (wr_sym_idx == TOTAL_SYM-1) begin
                wr_sym_idx <= {SYM_IDX_W{1'b0}};
                wr_bank    <= ~wr_bank;     // 写完一个 block 必切到另一 bank
            end else begin
                wr_sym_idx <= wr_sym_idx + 1'b1;
            end
        end
    end

    // 写使能
    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    // ===================== 读侧：列优先读出 =====================
    reg [ROW_W-1:0] rd_row;
    reg [COL_W-1:0] rd_col;
    reg             rd_busy;
    reg             rd_bank;

    // 已有完整 block 的 bank
    wire have_block0     = block_ready[0];
    wire have_block1     = block_ready[1];
    wire any_block_ready = have_block0 | have_block1;
    wire next_rd_bank    = have_block0 ? 1'b0 : 1'b1;

    // ---------- 新增：输出 FIFO 写口握手 ----------
    wire        ofifo_in_ready;
    wire        rd_fire;    // 真正的读使能（受 FIFO 空间限制）

    assign rd_fire = rd_busy && ofifo_in_ready;

    // block 内最后一个符号（注意用 rd_fire）
    wire rd_last_sym = rd_fire &&
                       (rd_row == D_EFF-1) &&
                       (rd_col == N-1);

    // 启动 / 推进读指针
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_busy <= 1'b0;
            rd_bank <= 1'b0;
            rd_row  <= {ROW_W{1'b0}};
            rd_col  <= {COL_W{1'b0}};
        end else begin
            if (!rd_busy && any_block_ready && ofifo_in_ready) begin
                // 启动新 block 的读
                rd_busy <= 1'b1;
                rd_bank <= next_rd_bank;
                rd_row  <= {ROW_W{1'b0}};
                rd_col  <= {COL_W{1'b0}};
            end else if (rd_fire) begin
                if (rd_row == D_EFF-1) begin
                    rd_row <= {ROW_W{1'b0}};
                    if (rd_col == N-1) begin
                        rd_col  <= {COL_W{1'b0}};
                        rd_busy <= 1'b0;
                    end else begin
                        rd_col <= rd_col + 1'b1;
                    end
                end else begin
                    rd_row <= rd_row + 1'b1;
                end
            end
        end
    end

    // ===================== block_ready 更新 =====================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            block_ready <= 2'b00;
        end else begin
            // 写完：当前 wr_bank 置 1
            if (wr_last_sym)
                block_ready[wr_bank] <= 1'b1;
            // 读完：当前 rd_bank 清 0
            if (rd_last_sym)
                block_ready[rd_bank] <= 1'b0;
        end
    end

    // ===================== 地址 & block_start（读地址侧） =====================
    // addr = row * N + col
    wire [SYM_IDX_W-1:0] rd_row_ext = rd_row;
    wire [SYM_IDX_W-1:0] rd_col_ext = rd_col;
    wire [SYM_IDX_W-1:0] row_mul_N  = rd_row_ext * N;
    wire [SYM_IDX_W-1:0] rd_sym_idx = row_mul_N + rd_col_ext;

    wire block_start_this = rd_fire &&
                            (rd_row == {ROW_W{1'b0}}) &&
                            (rd_col == {COL_W{1'b0}});

    // ===================== RAM 实现 =====================
    wire [7:0] doutb0, doutb1;

`ifdef SIM
    // 仿真行为 RAM
    reg [7:0] mem0 [0:TOTAL_SYM-1];
    reg [7:0] mem1 [0:TOTAL_SYM-1];
    reg [7:0] doutb0_r, doutb1_r;
    integer i;
    initial begin
        $display("rs_interleaver_xpm: dpram simulation model.");
        for (i = 0; i < TOTAL_SYM; i = i + 1) begin
            mem0[i] = 8'd0;
            mem1[i] = 8'd0;
        end
    end

    always @(posedge clk) begin
        if (wea0)
            mem0[wr_sym_idx] <= in_data;
        doutb0_r <= mem0[rd_sym_idx];
    end

    always @(posedge clk) begin
        if (wea1)
            mem1[wr_sym_idx] <= in_data;
        doutb1_r <= mem1[rd_sym_idx];
    end

    assign doutb0 = doutb0_r;
    assign doutb1 = doutb1_r;
`else
    // 综合用 XPM RAM
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A        (MEM_ADDR_W),
        .ADDR_WIDTH_B        (MEM_ADDR_W),
        .MEMORY_SIZE         (MEM_SIZE),
        .READ_LATENCY_B      (1),
        .WRITE_DATA_WIDTH_A  (8),
        .READ_DATA_WIDTH_B   (8),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .WRITE_MODE_B        ("read_first")
    ) u_ram0 (
        .clka   (clk),
        .addra  (wr_sym_idx),
        .dina   (in_data),
        .wea    (wea0),
        .ena    (1'b1),

        .clkb   (clk),
        .addrb  (rd_sym_idx),
        .doutb  (doutb0),
        .enb    (1'b1),

        .rsta   (1'b0),
        .rstb   (1'b0),
        .regcea (1'b1),
        .regceb (1'b1),
        .web    (1'b0)
    );

    xpm_memory_tdpram #(
        .ADDR_WIDTH_A        (MEM_ADDR_W),
        .ADDR_WIDTH_B        (MEM_ADDR_W),
        .MEMORY_SIZE         (MEM_SIZE),
        .READ_LATENCY_B      (1),
        .WRITE_DATA_WIDTH_A  (8),
        .READ_DATA_WIDTH_B   (8),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .WRITE_MODE_B        ("read_first")
    ) u_ram1 (
        .clka   (clk),
        .addra  (wr_sym_idx),
        .dina   (in_data),
        .wea    (wea1),
        .ena    (1'b1),

        .clkb   (clk),
        .addrb  (rd_sym_idx),
        .doutb  (doutb1),
        .enb    (1'b1),

        .rsta   (1'b0),
        .rstb   (1'b0),
        .regcea (1'b1),
        .regceb (1'b1),
        .web    (1'b0)
    );
`endif

    // ===================== READ_LATENCY_B = 1 管线对齐 =====================
    wire [7:0] dout_mux = (rd_bank == 1'b0) ? doutb0 : doutb1;

    reg       rd_fire_d1;
    reg [7:0] ofifo_in_data_r;
    reg       ofifo_in_flag_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d1       <= 1'b0;
            ofifo_in_data_r  <= 8'd0;
            ofifo_in_flag_r  <= 1'b0;
        end else begin
            // 1 拍对齐
            rd_fire_d1     <= rd_fire;

            if (rd_fire_d1) begin
                ofifo_in_data_r <= dout_mux;
                ofifo_in_flag_r <= block_start_this;
            end
        end
    end

    // ===================== 输出 FIFO：把 dpram 延迟隐藏起来，提供 AXIS 语义 =====================
    wire        ofifo_in_valid  = rd_fire_d1;
    wire [7:0]  ofifo_in_data   = ofifo_in_data_r;
    wire        ofifo_in_flag   = ofifo_in_flag_r;

    wire [7:0]  ofifo_out_data;
    wire        ofifo_out_flag;
    wire        ofifo_out_valid;

    fifo_8b_flag_sync #(
        .DEPTH (128),   // 小一点即可，只要能吸收短时 backpressure
        .GUARD (1)     // 至少 1，抵消 dpram 的 1 拍读延迟
    ) u_out_fifo (
        .clk       (clk),
        .rst       (rst),

        .in_data   (ofifo_in_data),
        .in_flag   (ofifo_in_flag),
        .in_valid  (ofifo_in_valid),
        .in_ready  (ofifo_in_ready),   // 反压回传给读地址生成

        .out_data  (ofifo_out_data),
        .out_flag  (ofifo_out_flag),
        .out_valid (ofifo_out_valid),
        .out_ready (out_ready)
    );

    assign out_valid       = ofifo_out_valid;
    assign out_data        = ofifo_out_data;
    assign out_block_start = ofifo_out_flag;

`ifdef SIM
    // 简单 X 检查
    always @(posedge clk) begin
        if (!rst && out_valid && (^out_data === 1'bx)) begin
            $display("[%0t] INTERLEAVER OUT X", $time);
            $stop;
        end
    end
`endif

endmodule
