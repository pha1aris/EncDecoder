`timescale 1ns/1ps

// 去交织器：列写入 + 行读出 + 双 bank 乒乓
// 发端交织器：行写 / 列读
// 收端去交织器：列写 / 行读  → 正好互逆
// 受 XPM/BRAM 地址宽度 20bit 限制：
// 实际有效交织深度 D_EFF = min(D, floor(2^20 / N)).

module rs_deinterleaver_xpm #(
    parameter integer D = 4808, // 目标交织深度（行数），实际有效为 D_EFF
    parameter integer N = 255   // 每行符号数（RS(255,229) → 255）
)(
    input  wire       clk,
    input  wire       rst,           // 高有效全局复位
    input  wire       blk_soft_rst,  // 新增：交织块级软复位（来自 deframer）

    input  wire       in_valid,
    input  wire [7:0] in_data,
    output wire       in_ready,

    output reg        out_valid,
    output reg  [7:0] out_data,   // 读出延迟一个周期
    output reg        block_start // 当前读出的符号是“块内第一个符号”时拉高一拍
);

    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W); // 2^20 = 1048576 地址
    localparam integer MEM_SIZE   = MAX_DEPTH * 8;     // bit 数（DATA_WIDTH=8）

    // 一块交织中总符号数 = D_EFF * N 必须 <= 2^20。
    localparam integer MAX_D      = MAX_DEPTH / N;     // floor(2^20 / 255) = 4112
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;         // ≤ 2^20

    // 行/列计数的位宽
    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);

    // 线性符号索引位宽 —— 直接用 20
    localparam integer SYM_IDX_W  = MEM_ADDR_W;

    reg  [ROW_W-1:0]     wr_row;
    reg  [COL_W-1:0]     wr_col;
    reg  [SYM_IDX_W-1:0] wr_sym_idx; // = wr_row*255 + wr_col（寄存）
    reg  [SYM_IDX_W-1:0] wr_cnt;     // 当前块已写符号数
    reg                  wr_bank;    // 当前写入 bank
    reg                  rd_bank;    // 当前读出 bank
    reg                  read_is_ready; // 第一块写满后允许读

    wire                 wr_fire = in_valid && in_ready;

    // 这里先不对上游反压
    assign in_ready = 1'b1;

    // 列优先写：和 TX 那边读时的 row/col 规则一样
    // (col 固定，row 从 0..D_EFF-1)，然后 col++
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_row <= {ROW_W{1'b0}};
            wr_col <= {COL_W{1'b0}};
        end else if (blk_soft_rst) begin
            // 软复位：从块头重新写
            wr_row <= {ROW_W{1'b0}};
            wr_col <= {COL_W{1'b0}};
        end else if (wr_fire) begin
            if (wr_row == D_EFF-1) begin
                wr_row <= {ROW_W{1'b0}};
                if (wr_col == N-1)
                    wr_col <= {COL_W{1'b0}};
                else
                    wr_col <= wr_col + 1'b1;
            end else begin
                wr_row <= wr_row + 1'b1;
            end
        end
    end

    // 线性写地址：row*255 + col
    wire [SYM_IDX_W-1:0] wr_row_mul_255   = (wr_row << 8) - wr_row;
    wire [SYM_IDX_W-1:0] wr_sym_idx_next  = wr_row_mul_255 + wr_col;

    // 写块计数 & 乒乓切换
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_cnt        <= {SYM_IDX_W{1'b0}};
            wr_sym_idx    <= {SYM_IDX_W{1'b0}};
            wr_bank       <= 1'b0;    // 先写 bank0
            rd_bank       <= 1'b1;    // 起步指向 bank1（空）
            read_is_ready <= 1'b0;    // 第一块写满前禁止读
        end else if (blk_soft_rst) begin
            // 软复位：丢弃当前正在写/读的块，重新从 bank0 开始写
            wr_cnt        <= {SYM_IDX_W{1'b0}};
            wr_sym_idx    <= {SYM_IDX_W{1'b0}};
            wr_bank       <= 1'b0;
            rd_bank       <= 1'b1;
            read_is_ready <= 1'b0;    // 必须重新填满一个完整块后再读
        end else if (wr_fire) begin
            wr_sym_idx <= wr_sym_idx_next; // 组合地址寄存一拍（可选）

            if (wr_cnt == TOTAL_SYM-1) begin
                wr_cnt        <= {SYM_IDX_W{1'b0}};
                wr_bank       <= ~wr_bank;
                rd_bank       <= ~rd_bank;
                read_is_ready <= 1'b1; // 第一块写满后，就一直允许读
            end else begin
                wr_cnt <= wr_cnt + 1'b1;
            end
        end
    end

    // 写使能：哪个 bank 在写，就对哪个打 wea
    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    reg  [SYM_IDX_W-1:0] rd_sym_idx;
    wire                 rd_active = read_is_ready;
    wire                 rd_fire   = rd_active;  // 不做下游反压

    // 用于产生块起始信号（读出块的第一个符号）
    reg                  block_start_raw;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_sym_idx      <= {SYM_IDX_W{1'b0}};
            block_start_raw <= 1'b0;
        end else if (blk_soft_rst) begin
            // 块级软复位：读指针也回到块头
            rd_sym_idx      <= {SYM_IDX_W{1'b0}};
            block_start_raw <= 1'b0;
        end else if (rd_fire && rd_active) begin
            // 在读出块的第一个符号时，标记 block_start_raw
            if (rd_sym_idx == {SYM_IDX_W{1'b0}})
                block_start_raw <= 1'b1;
            else
                block_start_raw <= 1'b0;

            if (rd_sym_idx == TOTAL_SYM-1)
                rd_sym_idx <= {SYM_IDX_W{1'b0}};
            else
                rd_sym_idx <= rd_sym_idx + 1'b1;
        end else begin
            block_start_raw <= 1'b0;
        end
    end

    wire [7:0] doutb0;
    wire [7:0] doutb1;

    // bank0
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A        (MEM_ADDR_W),
        .ADDR_WIDTH_B        (MEM_ADDR_W),
        .AUTO_SLEEP_TIME     (0),
        .BYTE_WRITE_WIDTH_A  (8),
        .BYTE_WRITE_WIDTH_B  (8),
        .CASCADE_HEIGHT      (0),
        .CLOCKING_MODE       ("common_clock"),
        .ECC_MODE            ("no_ecc"),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .MEMORY_OPTIMIZATION ("true"),
        .MEMORY_PRIMITIVE    ("block"),    // 或 "ultra"
        .MEMORY_SIZE         (MEM_SIZE),
        .MESSAGE_CONTROL     (0),
        .READ_DATA_WIDTH_A   (8),
        .READ_DATA_WIDTH_B   (8),
        .READ_LATENCY_A      (1),
        .READ_LATENCY_B      (1),
        .READ_RESET_VALUE_A  ("0"),
        .READ_RESET_VALUE_B  ("0"),
        .RST_MODE_A          ("SYNC"),
        .RST_MODE_B          ("SYNC"),
        .SIM_ASSERT_CHK      (0),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT        (0),
        .USE_MEM_INIT_MMI    (0),
        .WAKEUP_TIME         ("disable_sleep"),
        .WRITE_DATA_WIDTH_A  (8),
        .WRITE_DATA_WIDTH_B  (8),
        .WRITE_MODE_A        ("no_change"),
        .WRITE_MODE_B        ("no_change"),
        .WRITE_PROTECT       (1)
    ) u_ram0 (
        .clka            (clk),
        .clkb            (clk),
        .addra           (wr_sym_idx_next),           // 列写：row*255+col
        .addrb           (rd_sym_idx),                // 行读：线性 0..TOTAL_SYM-1
        .dina            (in_data),
        .dinb            (8'd0),
        .wea             (wea0),
        .web             (1'b0),
        .ena             (1'b1),
        .enb             (rd_active && (rd_bank == 1'b0)),
        .douta           (),
        .doutb           (doutb0),
        .rsta            (rst),
        .rstb            (rst),
        .regcea          (1'b1),
        .regceb          (1'b1),
        .sleep           (1'b0),
        .dbiterra        (),
        .dbiterrb        (),
        .sbiterra        (),
        .sbiterrb        (),
        .injectdbiterra  (1'b0),
        .injectdbiterrb  (1'b0),
        .injectsbiterra  (1'b0),
        .injectsbiterrb  (1'b0)
    );

    // bank1
    xpm_memory_tdpram #(
        .ADDR_WIDTH_A        (MEM_ADDR_W),
        .ADDR_WIDTH_B        (MEM_ADDR_W),
        .AUTO_SLEEP_TIME     (0),
        .BYTE_WRITE_WIDTH_A  (8),
        .BYTE_WRITE_WIDTH_B  (8),
        .CASCADE_HEIGHT      (0),
        .CLOCKING_MODE       ("common_clock"),
        .ECC_MODE            ("no_ecc"),
        .MEMORY_INIT_FILE    ("none"),
        .MEMORY_INIT_PARAM   ("0"),
        .MEMORY_OPTIMIZATION ("true"),
        .MEMORY_PRIMITIVE    ("block"),
        .MEMORY_SIZE         (MEM_SIZE),
        .MESSAGE_CONTROL     (0),
        .READ_DATA_WIDTH_A   (8),
        .READ_DATA_WIDTH_B   (8),
        .READ_LATENCY_A      (1),
        .READ_LATENCY_B      (1),
        .READ_RESET_VALUE_A  ("0"),
        .READ_RESET_VALUE_B  ("0"),
        .RST_MODE_A          ("SYNC"),
        .RST_MODE_B          ("SYNC"),
        .SIM_ASSERT_CHK      (0),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT        (0),
        .USE_MEM_INIT_MMI    (0),
        .WAKEUP_TIME         ("disable_sleep"),
        .WRITE_DATA_WIDTH_A  (8),
        .WRITE_DATA_WIDTH_B  (8),
        .WRITE_MODE_A        ("no_change"),
        .WRITE_MODE_B        ("no_change"),
        .WRITE_PROTECT       (1)
    ) u_ram1 (
        .clka            (clk),
        .clkb            (clk),
        .addra           (wr_sym_idx_next),
        .addrb           (rd_sym_idx),
        .dina            (in_data),
        .dinb            (8'd0),
        .wea             (wea1),
        .web             (1'b0),
        .ena             (1'b1),
        .enb             (rd_active && (rd_bank == 1'b1)),
        .douta           (),
        .doutb           (doutb1),
        .rsta            (rst),
        .rstb            (rst),
        .regcea          (1'b1),
        .regceb          (1'b1),
        .sleep           (1'b0),
        .dbiterra        (),
        .dbiterrb        (),
        .sbiterra        (),
        .sbiterrb        (),
        .injectdbiterra  (1'b0),
        .injectdbiterrb  (1'b0),
        .injectsbiterra  (1'b0),
        .injectsbiterrb  (1'b0)
    );

    reg        rd_fire_d;
    reg        rd_fire_d1;
    reg        rd_bank_d;
    reg  [7:0] dout_muxed_d;
    reg        block_start_d;   // 对齐到 out_valid/out_data

    wire [7:0] dout_muxed_now = (rd_bank_d == 1'b0) ? doutb0 : doutb1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d      <= 1'b0;
            rd_bank_d      <= 1'b0;
            dout_muxed_d   <= 8'd0;
            out_valid      <= 1'b0;
            out_data       <= 8'd0;
            block_start_d  <= 1'b0;
            block_start    <= 1'b0;
            rd_fire_d1 <= 1'b0;
        end else begin
            // 第 0 拍：发起读、锁存当前 rd_bank
            rd_fire_d <= rd_fire && rd_active;
            rd_bank_d <= rd_bank;

            // 第 1 拍：RAM 数据就绪，按上一拍的 rd_bank_d 选 bank
            dout_muxed_d <= dout_muxed_now;

            // 对齐有效标志
            rd_fire_d1 <= rd_fire_d;
            out_valid <= rd_fire_d1;
            out_data  <= dout_muxed_d;

            // 块起始同步到 out_valid
            block_start_d <= block_start_raw;
            block_start   <= block_start_d;
        end
    end

endmodule
