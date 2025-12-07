`timescale 1ns/1ps
`define SIM

module rs_deinterleaver_xpm #(
    parameter integer D = 4808,
    parameter integer N = 255
)(
    input  wire         clk,
    input  wire         rst,          // 全局复位
    input  wire         blk_soft_rst, // 块对齐软复位（来自 deframer）

    // 输入：交织后的 8bit 流（列优先）
    input  wire         in_valid,
    input  wire [7:0]   in_data,
    output wire         in_ready,     // 可反压上游（比如 gearbox_32to8）

    // 输出：解交织后的 8bit 流（行优先 = 逐码字）
    output wire         out_valid,
    output wire [7:0]   out_data,
    output wire         block_start,  // 每块第一个符号拉高
    input  wire         out_ready     // 下游 ready（FIFO / RS decoder）
);

    // ===================== 常量 =====================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W);   // 1M symbol 深度
    localparam integer MAX_D      = MAX_DEPTH / N;
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;

    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

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

    // 统一复位（块软复位也当作一次“重同步”）
    wire rst_int = rst | blk_soft_rst;

    // ===================== 写侧：列优先写入 + 双 bank =====================
    reg  [ROW_W-1:0]     wr_row;
    reg  [COL_W-1:0]     wr_col;
    reg  [SYM_IDX_W-1:0] wr_cnt;      // 已写符号数 0..TOTAL_SYM-1
    reg                  wr_bank;     // 当前写 bank：0 / 1

    reg  [1:0]           block_ready; // block_ready[b]=1 表示该 bank 有完整块等待读

    // 写地址：addr = row * N + col  （列优先写）
    wire [SYM_IDX_W-1:0] wr_row_ext   = wr_row;
    wire [SYM_IDX_W-1:0] wr_col_ext   = wr_col;
    wire [SYM_IDX_W-1:0] wr_row_mul_N = wr_row_ext * N;
    wire [SYM_IDX_W-1:0] wr_sym_idx   = wr_row_mul_N + wr_col_ext;

    // 当前写 bank 已经存着一整块尚未读出 => 写满
    wire cur_bank_full = block_ready[wr_bank];

    // 只有当前写 bank 空闲时才允许写入，否则 in_ready = 0 反压上游
    wire in_can_fire = ~rst_int & ~cur_bank_full;
    assign in_ready  = in_can_fire;

    wire wr_fire     = in_valid && in_can_fire;
    wire wr_last_sym = wr_fire && (wr_cnt == TOTAL_SYM-1);

    // 列优先写：Row 快，Col 慢
    always @(posedge clk or posedge rst_int) begin
        if (rst_int) begin
            wr_row  <= {ROW_W{1'b0}};
            wr_col  <= {COL_W{1'b0}};
            wr_cnt  <= {SYM_IDX_W{1'b0}};
            wr_bank <= 1'b0;
        end else if (wr_fire) begin
            // row 0..D_EFF-1，然后 col+1
            if (wr_row == D_EFF-1) begin
                wr_row <= {ROW_W{1'b0}};
                if (wr_col == N-1)
                    wr_col <= {COL_W{1'b0}};
                else
                    wr_col <= wr_col + 1'b1;
            end else begin
                wr_row <= wr_row + 1'b1;
            end

            // 线性计数 + bank ping-pong
            if (wr_cnt == TOTAL_SYM-1) begin
                wr_cnt  <= {SYM_IDX_W{1'b0}};
                wr_bank <= ~wr_bank;   // 写完一整块，切到另一 bank
            end else begin
                wr_cnt <= wr_cnt + 1'b1;
            end
        end
    end

    // 写使能
    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    // ===================== 读侧：线性读出 + 双 bank =====================
    reg  [SYM_IDX_W-1:0] rd_sym_idx;
    reg                  rd_busy;     // 正在读某 bank 的一个 block
    reg                  rd_bank;     // 当前读的是哪个 bank

    wire have_block0     = block_ready[0];
    wire have_block1     = block_ready[1];
    wire any_block_ready = have_block0 | have_block1;
    wire next_rd_bank    = have_block0 ? 1'b0 : 1'b1;

    // ---------- 与 FIFO 对接的输入端 ----------
    wire        ofifo_in_ready;
    wire        rd_fire;          // 真正的读使能（受 FIFO 空间限制）

    // 有 block 可读 + 已经开始读 + FIFO 有空间 时才发起 read
    assign rd_fire = rd_busy && ofifo_in_ready;

    // 一个 block 的最后一个符号（注意用 rd_fire）
    wire rd_last_sym = rd_fire && (rd_sym_idx == TOTAL_SYM-1);

    // 行优先：rd_sym_idx 直接做读地址 0..TOTAL_SYM-1
    wire [SYM_IDX_W-1:0] rd_addr = rd_sym_idx;

    // 读指针状态机
    always @(posedge clk or posedge rst_int) begin
        if (rst_int) begin
            rd_sym_idx <= {SYM_IDX_W{1'b0}};
            rd_busy    <= 1'b0;
            rd_bank    <= 1'b0;
        end else begin
            if (!rd_busy) begin
                // 空闲 && 有完整块 && FIFO 有空间 => 启动一次 block 读
                if (any_block_ready && ofifo_in_ready) begin
                    rd_busy    <= 1'b1;
                    rd_bank    <= next_rd_bank;
                    rd_sym_idx <= {SYM_IDX_W{1'b0}};
                end
            end else if (rd_fire) begin
                // 正在读当前 block
                if (rd_sym_idx == TOTAL_SYM-1) begin
                    rd_sym_idx <= {SYM_IDX_W{1'b0}};
                    rd_busy    <= 1'b0; // 整个 block 读完
                end else begin
                    rd_sym_idx <= rd_sym_idx + 1'b1;
                end
            end
        end
    end

    // ===================== block_ready 更新 =====================
    always @(posedge clk or posedge rst_int) begin
        if (rst_int) begin
            block_ready <= 2'b00;
        end else begin
            // 写完一整块 => 该写 bank 置 1
            if (wr_last_sym)
                block_ready[wr_bank] <= 1'b1;

            // 读完一整块 => 该读 bank 清 0
            if (rd_last_sym)
                block_ready[rd_bank] <= 1'b0;
        end
    end

    // ===================== 双口 RAM（两个 bank） =====================
    wire [7:0] doutb0, doutb1;

`ifdef SIM
    // 仿真用行为 RAM，读延迟约等于 1 拍
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
    // 综合用 XPM RAM
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A        (MEM_ADDR_W),
        .ADDR_WIDTH_B        (MEM_ADDR_W),
        .MEMORY_SIZE         (MAX_DEPTH * 8),
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
        .addrb  (rd_addr),
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
        .MEMORY_SIZE         (MAX_DEPTH * 8),
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
        .addrb  (rd_addr),
        .doutb  (doutb1),
        .enb    (1'b1),

        .rsta   (1'b0),
        .rstb   (1'b0),
        .regcea (1'b1),
        .regceb (1'b1),
        .web    (1'b0)
    );
`endif

    wire [7:0] dout_mux = (rd_bank == 1'b0) ? doutb0 : doutb1;

    // ===================== 对齐 RAM 一拍延迟 -> FIFO 入口 =====================
    reg        rd_fire_d1;
    reg [7:0]  ofifo_in_data_r;
    reg        ofifo_in_flag_r;

    // block 首符号标志：在发起读的那一拍（rd_fire 且 rd_sym_idx==0）
    wire block_start_this = rd_fire && (rd_sym_idx == {SYM_IDX_W{1'b0}});

    always @(posedge clk or posedge rst_int) begin
        if (rst_int) begin
            rd_fire_d1       <= 1'b0;
            ofifo_in_data_r  <= 8'd0;
            ofifo_in_flag_r  <= 1'b0;
        end else begin
            // 一拍 pipeline：把“上一拍的 read”对应的数据/flag 送给 FIFO
            rd_fire_d1 <= rd_fire;

            if (rd_fire_d1) begin
                ofifo_in_data_r <= dout_mux;
                ofifo_in_flag_r <= block_start_this;
            end
        end
    end

    wire        ofifo_in_valid = rd_fire_d1;
    wire [7:0]  ofifo_in_data  = ofifo_in_data_r;
    wire        ofifo_in_flag  = ofifo_in_flag_r;

    // ===================== 简单同步 FIFO：隐藏 RAM 延迟 + 真正反压 =====================
    wire [7:0]  ofifo_out_data;
    wire        ofifo_out_flag;
    wire        ofifo_out_valid;

    fifo_8b_flag_sync #(
        .DEPTH (128),   // 足够吸收短时 backpressure
        .GUARD (1)      // 至少 1，抵消“多打一拍的读”
    ) u_out_fifo (
        .clk       (clk),
        .rst       (rst_int),

        .in_data   (ofifo_in_data),
        .in_flag   (ofifo_in_flag),
        .in_valid  (ofifo_in_valid),
        .in_ready  (ofifo_in_ready),   // ★ 这个 ready 控制 rd_fire

        .out_data  (ofifo_out_data),
        .out_flag  (ofifo_out_flag),
        .out_valid (ofifo_out_valid),
        .out_ready (out_ready)
    );

    assign out_valid   = ofifo_out_valid;
    assign out_data    = ofifo_out_data;
    assign block_start = ofifo_out_flag;

`ifdef SIM
    // 简单 X 检查
    always @(posedge clk) begin
        if (!rst_int && out_valid && (^out_data === 1'bx)) begin
            $display("[%0t] DEINTERLEAVER OUT X", $time);
            $stop;
        end
    end
`endif

endmodule
