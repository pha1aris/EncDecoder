`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/27 15:44:35
// Design Name: 
// Module Name: BER_axis_packager
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 将ber计算需要的两个数据通过axis传输到 PS DMA
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BER_axis_packager#(
    parameter CYCLES_PER_PAK = 10_000_000
)(
    input wire          clk,//100Mhz - 10ns
    input wire          rst_n,
    input wire [63:0]   data_i0,
    input wire [63:0]   data_i1,

    output reg [127:0]  M_AXIS_TDATA,
    output reg          M_AXIS_TVALID,
    input wire          M_AXIS_TREADY,
    output reg          M_AXIS_TLAST
);

reg [$clog2(CYCLES_PER_PAK)-1:0] cycle_cnt;
reg                              send_req;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cycle_cnt <= 0;
        send_req <= 0;
        M_AXIS_TLAST <= 0;
        M_AXIS_TVALID <= 0;
        M_AXIS_TDATA <= 'd0;
    end else begin
        if(cycle_cnt == CYCLES_PER_PAK-1)begin
            cycle_cnt <= 'd0;
            send_req <= 1;
        end else begin
            cycle_cnt <= cycle_cnt + 1;
        end

        if(send_req)begin
            if(!M_AXIS_TVALID)begin
                M_AXIS_TDATA <= {data_i0,data_i1};
                M_AXIS_TVALID <= 1;
                M_AXIS_TLAST <= 1;
            end else if(M_AXIS_TVALID && M_AXIS_TREADY) begin
                M_AXIS_TVALID <= 0;
                M_AXIS_TLAST <= 0;
                send_req <= 0;
            end
        end
    end
end



endmodule
