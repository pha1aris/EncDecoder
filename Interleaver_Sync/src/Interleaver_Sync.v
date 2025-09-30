// 
// 交织后对交织器交织输出数据加入同步头
// 
// 
module Interleaver_Sync#(
	parameter DATA_WIDTH = 32,
	parameter SYNC_HEADER = 32'h1ACFFC1D,
	parameter BLOCK_SIZE_IN_WORDS = 256
)(

	input wire clk,
	input wire rst,

    // --- 输入接口 (来自交织器) ---
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire                  valid_in,
    output wire                  ready_out,

    // --- 输出接口 (送往信道/物理层) ---
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  valid_out,
    input  wire                  ready_in

);









endmodule