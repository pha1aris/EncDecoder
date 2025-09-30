`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: ScramblerDescrambler
//
// Description:
//   最终修正版本：高性能的并行自同步加扰/解扰器。
//   - 结构: 采用高效的并行 generate 结构，性能好。
//   - 逻辑: 采用经典的自同步反馈逻辑，理论清晰，可自动恢复同步。
//
//////////////////////////////////////////////////////////////////////////////////
module ScramblerDescrambler #(
    parameter CHK_MODE    = 0,    // 0=加扰 (Scrambler), 1=解扰 (Descrambler)
    parameter POLY_LENGHT = 16,
    parameter POLY_TAP_1  = 5,
    parameter POLY_TAP_2  = 4,
    parameter POLY_TAP_3  = 3,
    parameter NBITS       = 8
)(
    input  wire                  RST,
    input  wire                  CLK,
    input  wire [NBITS-1:0]      DATA_IN,
    input  wire                  EN,
    output wire [NBITS-1:0]      DATA_OUT
);
    reg  [POLY_LENGHT-1:0] lfsr_reg;
    wire [POLY_LENGHT-1:0] lfsr_chain [NBITS:0];
    wire [NBITS-1:0]       feedback;
    
    localparam [POLY_LENGHT-1:0] LFSR_INIT = {POLY_LENGHT{1'b1}}; //初始化为全1

    assign lfsr_chain[0] = lfsr_reg;
    
    genvar i;
    // 并行自同步加扰/解扰器
    generate
        for (i = 0; i < NBITS; i = i + 1) begin : G_SCRAMBLE_LOOP
            // 1. 计算反馈比特
            assign feedback[i] = lfsr_chain[i][POLY_LENGHT-1] ^ 
                                 lfsr_chain[i][POLY_TAP_1-1]  ^ 
                                 lfsr_chain[i][POLY_TAP_2-1]  ^ 
                                 lfsr_chain[i][POLY_TAP_3-1];

            // 2. 输出数据
            assign DATA_OUT[i] = DATA_IN[i] ^ feedback[i];

            // 3. 根据模式选择输入
            wire lfsr_input_bit = (CHK_MODE == 0) ? DATA_OUT[i] : DATA_IN[i];

            // 4. 更新链
            assign lfsr_chain[i+1] = {lfsr_chain[i][POLY_LENGHT-2:0], lfsr_input_bit};
        end
    endgenerate


    // 4. 时序逻辑: 在时钟边沿更新LFSR状态
    always @(posedge CLK) begin
        if (RST) begin
            lfsr_reg <= LFSR_INIT;
        end else if (EN) begin
            lfsr_reg <= lfsr_chain[NBITS];
        end
    end
endmodule
