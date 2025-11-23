`timescale 1ns/1ps

module AdditiveScrambler #(
    parameter integer POLY_LENGHT = 16,       // LFSR 长度
    parameter integer POLY_TAP_1  = 5,        // 多项式 tap1 位置（1-based）
    parameter integer POLY_TAP_2  = 4,        // tap2
    parameter integer POLY_TAP_3  = 3,        // tap3
    parameter integer NBITS       = 8         // 并行位宽
)(
    input  wire                     CLK,
    input  wire                     RST,          // 异步/同步复位，按你系统风格来
    input  wire                     EN,           // 有效时钟使能（1clk 处理 NBITS 位）
    input  wire                     SEED_LOAD,    // =1 时加载种子
    input  wire [POLY_LENGHT-1:0]   SEED_VALUE,   // LFSR 种子（通常固定）

    input  wire [NBITS-1:0]         DATA_IN,      // 输入并行数据
    output wire [NBITS-1:0]         DATA_OUT      // 输出并行扰码/解扰后的数据
);

    // 当前 LFSR 状态
    reg  [POLY_LENGHT-1:0] lfsr_reg;
    wire [POLY_LENGHT-1:0] lfsr_chain [0:NBITS];

    wire [NBITS-1:0] pn_bit;

    assign lfsr_chain[0] = lfsr_reg;

    genvar i;
    generate
        for (i = 0; i < NBITS; i = i + 1) begin : G_LFSR_STEP
            assign pn_bit[i] = lfsr_chain[i][POLY_LENGHT-1];

            assign DATA_OUT[i] = DATA_IN[i] ^ pn_bit[i];
            wire feedback = lfsr_chain[i][POLY_LENGHT-1] ^
                            lfsr_chain[i][POLY_TAP_1-1]  ^
                            lfsr_chain[i][POLY_TAP_2-1]  ^
                            lfsr_chain[i][POLY_TAP_3-1];

            assign lfsr_chain[i+1] = {lfsr_chain[i][POLY_LENGHT-2:0], feedback};
        end
    endgenerate

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            lfsr_reg <= SEED_VALUE;  
        end else if (SEED_LOAD) begin
            lfsr_reg <= SEED_VALUE;   
        end else if (EN) begin
            lfsr_reg <= lfsr_chain[NBITS];
        end
    end

endmodule
