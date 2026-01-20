`timescale 1ns/1ps
`include "global_defines.vh"

//============================================================
// PRBS loop test: PRBS -> interleaver -> deinterleaver -> PRBS chk
//============================================================
module tb_rs_intlv_deintlv_prbs;

    //============================================================
    // 可调参数（建议仿真先用小 D；真实配置 D=4808 会被裁到 D_EFF=4112，单块约 1,048,560B）
    //============================================================
    parameter integer D = 64;
    parameter integer N = 255;

    localparam integer NUM_BLOCKS    = 2;     // 跑几个 block（>=2 覆盖 ping-pong）
    localparam integer READY_PCT     = 80;    // out_ready 为 1 的概率(%)
    localparam integer STALL_PCT     = 2;     // 触发“长反压”的概率(%)
    localparam integer STALL_LEN_CYC = 300;   // 长反压周期数

    //============================================================
    // 对齐 DUT 内部 D_EFF/TOTAL_SYM
    //============================================================
    localparam integer MEM_ADDR_W = 20;
    localparam integer MAX_DEPTH  = (1 << MEM_ADDR_W);
    localparam integer MAX_D      = (MAX_DEPTH / N);
    localparam integer D_EFF      = (D > MAX_D) ? MAX_D : D;
    localparam integer TOTAL_SYM  = D_EFF * N;

    localparam longint TARGET_BYTES = (longint'(NUM_BLOCKS)) * (longint'(TOTAL_SYM));

    //============================================================
    // clk / rst
    //============================================================
    reg clk;
    reg rst; // async high

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
    end

    //============================================================
    // PRBS generator -> interleaver input
    //============================================================
    wire [7:0] prbs_byte;
    wire       in_valid;
    wire       in_ready;
    assign in_valid = 1'b1;
    wire in_fire  = in_valid && in_ready && !rst;

    // 发生器：只在 in_fire 时推进，否则保持（这样反压时不会“偷跑”）
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_gen (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (8'd0),
        .EN       (in_fire),
        .DATA_OUT (prbs_byte)
    );

    //============================================================
    // DUT: interleaver
    //============================================================
    wire        intlv_out_valid;
    wire [7:0]  intlv_out_data;
    wire        intlv_out_block_start;
    wire        intlv_out_ready;

    rs_interleaver_xpm #(
        .D(D),
        .N(N)
    ) u_intlv (
        .clk            (clk),
        .rst            (rst),

        .in_valid       (in_valid),
        .in_data        (prbs_byte),
        .in_ready       (in_ready),

        .out_valid      (intlv_out_valid),
        .out_data       (intlv_out_data),
        .out_block_start(intlv_out_block_start),
        .out_ready      (intlv_out_ready)
    );

    //============================================================
    // DUT: deinterleaver
    //============================================================
    wire         blk_soft_rst;   
    wire        de_in_valid  = intlv_out_valid;
    wire [7:0]  de_in_data   = intlv_out_data;
    wire        de_in_ready;

    wire        de_out_valid;
    wire [7:0]  de_out_data;
    wire        de_block_start;
    reg         de_out_ready;

assign blk_soft_rst = intlv_out_valid && intlv_out_block_start && !rst;

    rs_deinterleaver_xpm #(
        .D(D),
        .N(N)
    ) u_deintlv (
        .clk          (clk),
        .rst          (rst),
        .blk_soft_rst (blk_soft_rst),

        .in_valid     (de_in_valid),
        .in_data      (de_in_data),
        .in_ready     (de_in_ready),

        .out_valid    (de_out_valid),
        .out_data     (de_out_data),
        .block_start  (de_block_start),
        .out_ready    (de_out_ready)
    );

    assign intlv_out_ready = de_in_ready;

    //============================================================
    // 输出端随机反压
    //============================================================
    integer r;
    reg [15:0] stall_cnt;

    initial begin
        de_out_ready = 1'b1;
        stall_cnt    = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            de_out_ready <= 1'b1;
            stall_cnt    <= 0;
        end else begin
            if (stall_cnt != 0) begin
                de_out_ready <= 1'b0;
                stall_cnt    <= stall_cnt - 1'b1;
            end else begin
                r = $random;

                if (r[7:0] < (STALL_PCT * 256 / 100))
                    stall_cnt <= STALL_LEN_CYC[15:0];

                de_out_ready <= (r[15:8] < (READY_PCT * 256 / 100));
            end
        end
    end

    //============================================================
    // PRBS checker（只在 out_fire 时推进）
    //============================================================
    wire out_fire = de_out_valid && de_out_ready && !rst;

    wire [7:0] prbs_err_vec;
    wire       prbs_match = ~|prbs_err_vec;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_chk (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (de_out_data),
        .EN       (out_fire),
        .DATA_OUT (prbs_err_vec)
    );

    // longint rx_cnt;
    // integer  ;

    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         rx_cnt  <= 0;
    //         err_cnt <= 0;
    //     end else if (out_fire) begin
    //         rx_cnt <= rx_cnt + 1;

    //         if (!prbs_match) begin
    //             $display("[%0t ns] PRBS ERROR: data=%02x err_vec=%02x total_err=%0d",
    //                      $time, de_out_data, prbs_err_vec, err_cnt + 1);
    //             err_cnt <= err_cnt + 1;
    //         end
    //     end
    // end



endmodule