// 修正后的代码：去掉了 BRAM 强制属性，适用于 Depth=64
module fifo_8b_flag_sync #(
    parameter integer DEPTH = 64,
    localparam integer AW = $clog2(DEPTH)
)(
    input  wire            clk,
    input  wire            rst,
    input  wire [7:0]      in_data,
    input  wire            in_flag,
    input  wire            in_valid,
    output wire            in_ready,

    output wire [7:0]      out_data,
    output wire            out_flag,
    output wire            out_valid,
    input  wire            out_ready
);

    reg [8:0] mem [0:DEPTH-1];

    reg [AW:0] wr_ptr;
    reg [AW:0] rd_ptr;

    wire [AW:0] used  = wr_ptr - rd_ptr;
    wire        full  = (used == DEPTH[AW:0]);
    wire        empty = (used == {(AW+1){1'b0}});

    assign in_ready  = ~full;
    assign out_valid = ~empty;

    wire push = in_valid && in_ready;
    wire pop  = out_valid && out_ready;

    assign {out_flag, out_data} = mem[rd_ptr[AW-1:0]];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= {(AW+1){1'b0}};
            rd_ptr <= {(AW+1){1'b0}};
        end else begin
            if (push) begin
                mem[wr_ptr[AW-1:0]] <= {in_flag, in_data};
                wr_ptr <= wr_ptr + 1'b1;
            end
            if (pop) begin
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end

endmodule