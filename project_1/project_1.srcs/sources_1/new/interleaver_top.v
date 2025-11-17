`timescale 1ns / 1ps

// 顶层：RS → 预交织器 → 8→32 packer → DDR4 控制器
module interleaver_top #(
    // 预交织器参数（RS255,229）
    parameter integer D           = 4808,        // 行数（交织深度）
    parameter integer N           = 255,         // 每行符号数

    // DDR 交织器参数
    parameter integer ADDR_WIDTH  = 29,
    parameter integer DATA_WIDTH  = 32,
    parameter integer MATRIX_COL  = 8,
    parameter integer MATRIX_ROW  = 8
)(
    // -------- RS  --------
    input  wire                   tx_clk,
    input  wire                   tx_rst,        // 高有效复位
    input  wire                   rs_in_valid,
    input  wire [7:0]             rs_in_data,
    input  wire                   rs_in_tlast,   // 暂未使用，可忽略

    // -------- DDR4 物理接口 --------
    input  wire                   sys_clk_p,
    input  wire                   sys_clk_n,
    input  wire                   rst_n,

    output wire                   c0_ddr4_act_n,
    output wire [16:0]            c0_ddr4_adr,
    output wire [1:0]             c0_ddr4_ba,
    output wire [0:0]             c0_ddr4_bg,
    output wire [0:0]             c0_ddr4_cke,
    output wire [0:0]             c0_ddr4_odt,
    output wire [0:0]             c0_ddr4_cs_n,
    output wire [0:0]             c0_ddr4_ck_t,
    output wire [0:0]             c0_ddr4_ck_c,
    output wire                   c0_ddr4_reset_n,
    inout  wire [3:0]             c0_ddr4_dm_dbi_n,
    inout  wire [31:0]            c0_ddr4_dq,
    inout  wire [3:0]             c0_ddr4_dqs_c,
    inout  wire [3:0]             c0_ddr4_dqs_t,

    // -------- DDR 用户侧接口 --------
    output wire                   ui_clkout,
    output wire                   c0_init_calib_complete,

    input  wire [7:0]             rd_bust_len,
    input  wire [7:0]             wr_bust_len,

    // 从 DDR 读出的 32bit 数据，给 FSO framer 用
    input  wire                   rd_fifo_rclk,     // 读出侧时钟（FSO framer 时钟）
    output wire [DATA_WIDTH-1:0]  rd_fifo_rdata,
    output wire                   rd_fifo_rvalid
);

    // =========================================================
    // 1) RS → 预交织器（8bit）
    // =========================================================
    wire       rs_intv_in_ready;
    wire       rs_intv_out_valid;
    wire [7:0] rs_intv_out_data;
    wire       rs_intv_block_start;

    rs_interleaver_xpm #(
        .D(D),
        .N(N)
    ) u_rs_interleaver_xpm (
        .clk            (tx_clk),
        .rst            (tx_rst),

        .in_valid       (rs_in_valid),
        .in_data        (rs_in_data),
        .in_ready       (rs_intv_in_ready), // 当前版本恒为 1，可忽略
        .in_tlast       (rs_in_tlast),

        .out_valid      (rs_intv_out_valid),
        .out_data       (rs_intv_out_data),
        .out_block_start(rs_intv_block_start)
    );

    // =========================================================
    // 2) 预交织器输出 8bit → 打包成 32bit word
    //    同时把交织块起始同步成 word 粒度 start_of_frame
    // =========================================================
    wire        pack_out_valid;
    wire [31:0] pack_out_data;
    wire        pack_out_block_start_word;

    sym8_to_word32_packer u_sym8_to_word32_packer (
        .clk                 (tx_clk),
        .rst                 (tx_rst),

        .in_valid            (rs_intv_out_valid),
        .in_data             (rs_intv_out_data),
        .in_block_start      (rs_intv_block_start),
        .in_ready            (),                    // 不使用

        .out_valid           (pack_out_valid),
        .out_data            (pack_out_data),
        .out_block_start_word(pack_out_block_start_word)
    );

    // =========================================================
    // 3) 连接到 DDR4 控制器
    //    pack_out_* → 写 FIFO 输入 + 块边界 start_of_frame_i
    // =========================================================
    // 写 FIFO 写时钟 = tx_clk （RS / FSO 发端时钟）
    wire wr_fifo_wclk = tx_clk;

    ddr4_controler_clean #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .MATRIX_COL (MATRIX_COL),
        .MATRIX_ROW (MATRIX_ROW)
    ) u_ddr4_controler_clean (
        .sys_clk_p          (sys_clk_p),
        .sys_clk_n          (sys_clk_n),
        .rst_n              (rst_n),

        // MIG PHY 透传
        .c0_ddr4_act_n      (c0_ddr4_act_n),
        .c0_ddr4_adr        (c0_ddr4_adr),
        .c0_ddr4_ba         (c0_ddr4_ba),
        .c0_ddr4_bg         (c0_ddr4_bg),
        .c0_ddr4_cke        (c0_ddr4_cke),
        .c0_ddr4_odt        (c0_ddr4_odt),
        .c0_ddr4_cs_n       (c0_ddr4_cs_n),
        .c0_ddr4_ck_t       (c0_ddr4_ck_t),
        .c0_ddr4_ck_c       (c0_ddr4_ck_c),
        .c0_ddr4_reset_n    (c0_ddr4_reset_n),
        .c0_ddr4_dm_dbi_n   (c0_ddr4_dm_dbi_n),
        .c0_ddr4_dq         (c0_ddr4_dq),
        .c0_ddr4_dqs_c      (c0_ddr4_dqs_c),
        .c0_ddr4_dqs_t      (c0_ddr4_dqs_t),

        // 块起始 → 作为 DDR4 交织块的 SOF
        .start_of_frame_i   (pack_out_block_start_word),

        .ui_clkout          (ui_clkout),
        .c0_init_calib_complete(c0_init_calib_complete),

        .rd_bust_len        (rd_bust_len),
        .wr_bust_len        (wr_bust_len),

        // 写 FIFO：来自 packer
        .wr_fifo_wclk       (wr_fifo_wclk),
        .wr_fifo_wen        (pack_out_valid),
        .wr_fifo_wdata      (pack_out_data),

        // 读 FIFO：读出到 FSO framer
        .rd_fifo_rclk       (rd_fifo_rclk),
        .rd_fifo_rdata      (rd_fifo_rdata),
        .rd_fifo_rvalid     (rd_fifo_rvalid)
    );

endmodule
