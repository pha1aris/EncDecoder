`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: fifo_buffer
//
// Description:
//   一个通用的、可综合的同步FIFO缓冲模块。
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_buffer #(
    parameter integer DATA_WIDTH = 32,
    parameter integer DEPTH      = 32  // FIFO深度
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Write Interface
    input  wire [DATA_WIDTH-1:0] wr_data_in,
    input  wire                  wr_en,
    output wire                  wr_full,

    // Read Interface
    output wire [DATA_WIDTH-1:0] rd_data_out,
    input  wire                  rd_en,
    output wire                  rd_empty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
    reg [ADDR_WIDTH:0]   count; // counter needs one more bit for full state

    assign wr_full  = (count == DEPTH);
    assign rd_empty = (count == 0);

    // Write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 'd0;
        end else if (wr_en && !wr_full) begin
            mem[wr_ptr] <= wr_data_in;
            wr_ptr <= (wr_ptr == DEPTH - 1) ? 'd0 : wr_ptr + 1;
        end
    end

    // Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 'd0;
        end else if (rd_en && !rd_empty) begin
            rd_ptr <= (rd_ptr == DEPTH - 1) ? 'd0 : rd_ptr + 1;
        end
    end
    
    assign rd_data_out = mem[rd_ptr];

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 'd0;
        end else begin
            case ({wr_en && !wr_full, rd_en && !rd_empty})
                2'b01: count <= count - 1; // Read only
                2'b10: count <= count + 1; // Write only
                2'b11: count <= count;     // Read and Write
                default: count <= count;
            endcase
        end
    end

endmodule
