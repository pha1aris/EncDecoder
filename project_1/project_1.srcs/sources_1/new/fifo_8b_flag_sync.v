`timescale 1ns/1ps

module fifo_8b_flag_sync #(
    parameter integer DEPTH  = 64,   // FIFO 深度
    parameter integer GUARD  = 1     // 预留的“保护槽位”：至少 1，保证上游多打一拍不溢出
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

    // 地址宽度
    localparam integer AW = $clog2(DEPTH);

    // 存储数据 + flag
    reg [8:0] mem [0:DEPTH-1];

    // 读写指针，多 1bit 方便做差
    reg [AW:0] wr_ptr;
    reg [AW:0] rd_ptr;

    // 当前使用量（模 2^(AW+1)）
    wire [AW:0] used = wr_ptr - rd_ptr;

    // 保护水位：最多写到 DEPTH-GUARD
    localparam [AW:0] FULL_LEVEL = DEPTH - GUARD;

    wire almost_full = (used >= FULL_LEVEL);                    // 接近满
    wire empty       = (used == { (AW+1){1'b0} });              // 为空

    assign in_ready  = ~almost_full;    // 提前反压
    assign out_valid = ~empty;

    wire push = in_valid && in_ready;
    wire pop  = out_valid && out_ready;

    // 同步读：数据在组合逻辑里直接从 mem 读出
    assign {out_flag, out_data} = mem[rd_ptr[AW-1:0]];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= { (AW+1){1'b0} };
            rd_ptr <= { (AW+1){1'b0} };
            // 仿真友好：清零存储器（综合会推成复位值，不影响功能）
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= 9'd0;
            end
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
