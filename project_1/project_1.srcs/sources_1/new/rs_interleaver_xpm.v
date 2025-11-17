`timescale 1ns/1ps

// 行写入 + 列读出 + 双 bank 乒乓交织器
// 注意：由于 XPM_MEMORY_TDPRAM 的地址位宽限制为 20，
// 实际有效交织深度会被限制为 D_eff = min(D, floor(2^20 / N)).
// 对于 N=255 时：D_eff_max = 4112，对应 TOTAL_SYM = 4112*255 = 1,048,560 <= 2^20.

module rs_interleaver_xpm #(
    parameter integer D = 4808, // 目标交织深度（行数），实际有效为 D_eff 最大
    parameter integer N = 255   // 每行符号数（RS(255,229) → 255）
)(
    input  wire       clk,
    input  wire       rst,       // 高有效复位

    input  wire       in_valid,
    input  wire [7:0] in_data,  
    output wire       in_ready,
    // input  wire       in_tlast,  

    output reg        out_valid,
    output reg  [7:0] out_data,  //数据读出延迟一个clk周期

    output reg        out_block_start

);

    // XPM 要求：MEMORY_SIZE = 2^ADDR_WIDTH * DATA_WIDTH ADDR_WIDTH = 20  深度 = 2^20 地址
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W);   // 2^20 = 1048576 地址
    localparam integer MEM_SIZE   = MAX_DEPTH * 8;      

    // 在地址深度 2^20 的前提下，最多能存的 8bit 符号数就是 2^20 个。
    // 交织器一块中总符号数 = D_eff * N 必须 <= 2^20。
    localparam integer MAX_D      = MAX_DEPTH / N;       // floor(2^20 / 255) = 4112
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D; // 实际有效行数 ≤ 4112

    // 实际一块交织中总符号数
    localparam integer TOTAL_SYM  = D_EFF * N;           // ≤ 2^20

    // 行/列计数的位宽
    localparam integer ROW_W      = $clog2(D_EFF);
    localparam integer COL_W      = $clog2(N);

    // 线性符号索引位宽 —— 实际上 <= 20，可以直接用 MEM_ADDR_W
    localparam integer SYM_IDX_W  = MEM_ADDR_W; // 20

    reg  [SYM_IDX_W-1:0] wr_sym_idx;    // 线性写地址：0 .. TOTAL_SYM-1
    reg                  wr_bank;       // 当前写的 bank：0 或 1
    reg                  rd_bank;       // 当前读的 bank：0 或 1
    reg                  read_is_ready; // 第一块写满后置 1，允许读

    wire wr_fire = in_valid && in_ready;

    // 当前版本不做反压：一直 ready
    assign in_ready = 1'b1;

    // 写指针 & 乒乓切换
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_sym_idx    <= {SYM_IDX_W{1'b0}};
            wr_bank       <= 1'b0;  // 先写 bank0
            rd_bank       <= 1'b1;  // 起步指向 bank1（空），但 read_is_ready=0，不会读
            read_is_ready <= 1'b0;  // 第一块写完前禁止读
        end else if (wr_fire) begin
            if (wr_sym_idx == TOTAL_SYM-1) begin
                // 当前写块写满
                wr_sym_idx    <= {SYM_IDX_W{1'b0}};
                wr_bank       <= ~wr_bank; // 下一块写到另一个 bank
                rd_bank       <= ~rd_bank; // 读 bank 与写 bank 始终相反
                read_is_ready <= 1'b1;     // 第一块写满后，开始允许读
            end else begin
                wr_sym_idx <= wr_sym_idx + 1'b1;
            end
        end
    end

    wire wea0 = wr_fire && (wr_bank == 1'b0);
    wire wea1 = wr_fire && (wr_bank == 1'b1);

    reg  [ROW_W-1:0] rd_row;
    reg  [COL_W-1:0] rd_col;
    wire             rd_active = read_is_ready; // 第一块写满前不读
    wire             rd_fire   = rd_active;     // 此版不做 out_ready 反压：一直读

    // 列优先遍历：(col 固定，row 从 0..D_EFF-1)，然后 col++
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_row <= {ROW_W{1'b0}};
            rd_col <= {COL_W{1'b0}};
        end else if (rd_fire && rd_active) begin
            if (rd_row == D_EFF-1) begin
                rd_row <= {ROW_W{1'b0}};
                if (rd_col == N-1)
                    rd_col <= {COL_W{1'b0}};
                else
                    rd_col <= rd_col + 1'b1;
            end else begin
                rd_row <= rd_row + 1'b1;
            end
        end
    end

// -------------------产生sof信号----------------------------
    reg [SYM_IDX_W-1:0]  rd_sym_cnt;
    reg                  block_start_raw;  // 对齐到 out_data/out_valid 的版本

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_sym_cnt       <= {SYM_IDX_W{1'b0}};
            block_start_raw<= 1'b0;
        end else begin
            block_start_raw <= 1'b0;

            if (rd_fire && rd_active) begin
                if (rd_sym_cnt == {SYM_IDX_W{1'b0}}) begin
                    block_start_raw <= 1'b1;
                end

                if (rd_sym_cnt == TOTAL_SYM-1)
                    rd_sym_cnt <= {SYM_IDX_W{1'b0}};
                else
                    rd_sym_cnt <= rd_sym_cnt + 1'b1;
            end
        end
    end


    // 计算 row*255 + col 的线性地址
    // row*255 = row*(256-1) = (row<<8) - row
    wire [SYM_IDX_W-1:0] row_mul_255 = (rd_row << 8) - rd_row;
    wire [SYM_IDX_W-1:0] rd_sym_idx  = row_mul_255 + rd_col; 

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
        .MEMORY_PRIMITIVE    ("block"),    // 可改为 "ultra"
        .MEMORY_SIZE         (MEM_SIZE),   // = 2^20 * 8 bit
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
        .addra           (wr_sym_idx),                   // 行写：线性地址
        .addrb           (rd_sym_idx),                   // 列读：row*255+col
        .dina            (in_data),
        .dinb            (8'd0),
        .wea             (wea0),                         // 写 bank0 时使能
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
        .clka                (clk),
        .clkb                (clk),
        .addra               (wr_sym_idx),
        .addrb               (rd_sym_idx),
        .dina                (in_data),
        .dinb                (8'd0),
        .wea                 (wea1),                         // 写 bank1 时使能
        .web                 (1'b0),
        .ena                 (1'b1),
        .enb                 (rd_active && (rd_bank == 1'b1)),
        .douta               (),
        .doutb               (doutb1),
        .rsta                (rst),
        .rstb                (rst),
        .regcea              (1'b1),
        .regceb              (1'b1),
        .sleep               (1'b0),
        .dbiterra            (),
        .dbiterrb            (),
        .sbiterra            (),
        .sbiterrb            (),
        .injectdbiterra      (1'b0),
        .injectdbiterrb      (1'b0),
        .injectsbiterra      (1'b0),
        .injectsbiterrb      (1'b0)
    );

    reg        rd_fire_d1;
    reg        rd_fire_d2;
    reg        rd_bank_d;
    reg [7:0]  dout_muxed_d;
    reg block_start_d1;
    reg block_start_d2; 
    wire [7:0] dout_muxed_now = (rd_bank_d == 1'b0) ? doutb0 : doutb1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_fire_d1 <= 1'b0;
            rd_fire_d2 <= 1'b0;
            rd_bank_d    <= 1'b0;
            dout_muxed_d <= 8'd0;
            out_valid    <= 1'b0;
            out_data     <= 8'd0;
            out_block_start <= 'd0;
            block_start_d1  <= 'd0;
            block_start_d2  <= 'd0;
        end else begin
            rd_fire_d1 <= rd_fire && rd_active;
            rd_fire_d2 <= rd_fire_d1;
            rd_bank_d <= rd_bank;

            dout_muxed_d <= dout_muxed_now;

            out_valid <= rd_fire_d2; //数据延迟2个周期加上xpm共三周期 ，此处也延迟三周期输出
            out_data  <= dout_muxed_d;

            block_start_d1  <= block_start_raw;
            block_start_d2  <= block_start_d1;
            out_block_start <= block_start_d2;
        end
    end

endmodule