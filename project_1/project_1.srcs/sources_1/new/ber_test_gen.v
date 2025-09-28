`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/27 19:56:21
// Design Name: 
// Module Name: ber_test_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ber_test_gen(
    input wire           clk, //100Mhz
    input wire           rst_n,

    output wire [63:0]   data_i0,
    output wire [63:0]   data_i1
);

    reg [63:0] data_r0;
    reg [63:0] data_r1;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_r0 <= 'd0;
            data_r1 <= 'd0;
        end else begin
            data_r0 <= data_r0 + 1'd1;
            data_r1 <= data_r1 + 1'd1;
        end
    end


endmodule
