`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/04 10:43:17
// Design Name: 
// Module Name: gth_k_filter
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


module gth_k_filter#(
    parameter PARALLEL  = 32
)(
    input wire                  clk,
    input wire                  rst_n,

    input wire [PARALLEL -1:0]  data_i,
    input wire [PARALLEL/8-1:0] gth_charisk,
    input wire                  gth_valid_in,

    output reg [PARALLEL -1:0] sync_data_o,
    output reg                 sync_valid_out,
    input wire                 sync_ready_in
);

    wire data_only_valid;
    assign data_only_valid = gth_valid_in && (gth_charisk=='d0);

    always@(posedge clk or negedge rst_n)begin
        if(rst_n)begin
            sync_data_o <= 'd0;
            sync_valid_out <= 'd0;
        end else begin
            if(data_only_valid)begin
                sync_data_o <= data_i;
                sync_valid_out <= 1'b1;
            end else begin
                sync_valid_out <= 1'b0;
            end
        end
    end



endmodule
