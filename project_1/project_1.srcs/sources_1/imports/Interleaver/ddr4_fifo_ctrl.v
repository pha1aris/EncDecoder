//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ddr4_fifo_ctrl(
    input          rst_n,
    input          wr_fifo_wclk,
    input          wr_fifo_rclk,
    input          rd_fifo_wclk,
    input          rd_fifo_rclk,
    input  [31:0]  wr_fifo_wdata,
    output [255:0] wr_fifo_rdata,
    input  [255:0] rd_fifo_wdata, 
    output [31:0]  rd_fifo_rdata,
    output [8:0]   wr_fifo_rcount,
    output [8:0]   rd_fifo_wcount,
    input          wr_fifo_wen,
    input          wr_fifo_ren,
    input          rd_fifo_wen,
    input          rd_fifo_ren,

    output         data_valid_o,
    output [31:0]  rd_fifo_data_o
);

reg  [2:0] wr_fifo_rst_sync_reg; // Shift register for synchronizing rst_n
reg        wr_fifo_rst_s;        // Final synchronous active-high reset for wr_fifo

always @(posedge wr_fifo_wclk or negedge rst_n) begin
    if (!rst_n) begin // Asynchronous assertion of reset
        wr_fifo_rst_sync_reg <= 3'b111; // Force all bits high to ensure immediate reset
        wr_fifo_rst_s        <= 1'b1;   // Assert wr_fifo_rst_s (active-high)
    end else begin // Synchronous de-assertion of reset
        // Shift a '0' through the synchronizer chain
        wr_fifo_rst_sync_reg <= {wr_fifo_rst_sync_reg[1:0], 1'b0};
        // De-assert reset only after '0' has propagated through the chain
        if (wr_fifo_rst_sync_reg == 3'b000) begin
            wr_fifo_rst_s <= 1'b0; // De-assert wr_fifo_rst_s (active-high reset becomes low)
        end else begin
            wr_fifo_rst_s <= 1'b1; // Keep reset asserted until delay is met
        end
    end
end

reg  [2:0] rd_fifo_rst_sync_reg; // Shift register for synchronizing rst_n
reg        rd_fifo_rst_s;        // Final synchronous active-high reset for rd_fifo

always @(posedge rd_fifo_wclk or negedge rst_n) begin
    if (!rst_n) begin // Asynchronous assertion of reset
        rd_fifo_rst_sync_reg <= 3'b111; // Force all bits high to ensure immediate reset
        rd_fifo_rst_s        <= 1'b1;   // Assert rd_fifo_rst_s (active-high)
    end else begin // Synchronous de-assertion of reset
        // Shift a '0' through the synchronizer chain
        rd_fifo_rst_sync_reg <= {rd_fifo_rst_sync_reg[1:0], 1'b0};
        // De-assert reset only after '0' has propagated through the chain
        if (rd_fifo_rst_sync_reg == 3'b000) begin
            rd_fifo_rst_s <= 1'b0; // De-assert rd_fifo_rst_s (active-high reset becomes low)
        end else begin
            rd_fifo_rst_s <= 1'b1; // Keep reset asserted until delay is met
        end
    end
end

wire wr_fifo_empty,wr_fifo_full;
wire rd_fifo_empty,rd_fifo_full;

assign data_valid_o = rd_fifo_ren && !rd_fifo_empty;
assign rd_fifo_data_o = rd_fifo_rdata;

wr_fifo u_wr_fifo (
    .rst          (wr_fifo_rst_s),      // input wire rst
    .wr_clk       (wr_fifo_wclk),       // input wire wr_clk
    .rd_clk       (wr_fifo_rclk),       // input wire rd_clk
    .din          (wr_fifo_wdata),      // input wire [31 : 0] din
    .wr_en        (wr_fifo_wen),        // input wire wr_en
    .rd_en        (wr_fifo_ren),        // input wire rd_en
    .dout         (wr_fifo_rdata),      // output wire [255 : 0] dout
    .full         (wr_fifo_full),                  // output wire full
    .empty        (wr_fifo_empty),                  // output wire empty
    .rd_data_count(wr_fifo_rcount),     // output wire [8 : 0] rd_data_count
    .wr_data_count( )                   // output wire [11 : 0] wr_data_count
);

rd_fifo u_rd_fifo (
    .rst          (rd_fifo_rst_s),             // input wire rst
    .wr_clk       (rd_fifo_wclk),       // input wire wr_clk
    .rd_clk       (rd_fifo_rclk),       // input wire rd_clk
    .din          (rd_fifo_wdata),      // input wire [255 : 0] din
    .wr_en        (rd_fifo_wen),        // input wire wr_en
    .rd_en        (rd_fifo_ren && !rd_fifo_empty),        // input wire rd_en
    .dout         (rd_fifo_rdata),      // output wire [31 : 0] dout
    .full         (rd_fifo_full),                  // output wire full
    .empty        (rd_fifo_empty),                  // output wire empty
    .rd_data_count( ),                  // output wire [11 : 0] rd_data_count
    .wr_data_count(rd_fifo_wcount)      // output wire [8 : 0] wr_data_count
);




endmodule
