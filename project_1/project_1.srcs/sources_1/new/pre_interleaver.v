module pre_interleaver #(
    parameter CODEWORD_SIZE = 256,   // 每个码字256 words (1024B)
    parameter NUM_CODEWORDS = 4      // 4个码字
)(
    input  wire         clk,
    input  wire         rst,

    // 输入接口
    input  wire [31:0]  s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    // 输出接口
    output reg  [31:0]  m_axis_tdata,
    output reg          m_axis_tvalid,
    input  wire         m_axis_tready
);

    // ============ 写端 Round-Robin 控制 ============
    reg [1:0] cw_index;   // 当前写哪个CW (0~3)
    reg [7:0] cw_addr;    // CW内部地址 (0~255)
    reg       active_buf; // 当前写入的PingPong选择 (0:A写,1:B写)

    wire write_en = s_axis_tvalid & s_axis_tready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cw_index   <= 0;
            cw_addr    <= 0;
            active_buf <= 0;
        end else if (write_en) begin
            if (cw_index == NUM_CODEWORDS-1) begin
                cw_index <= 0;
                cw_addr  <= cw_addr + 1'b1; // 每四次写，内部地址+1
            end else begin
                cw_index <= cw_index + 1'b1;
            end

            // 一个交织块填满 (1024 words)
            if (cw_addr == CODEWORD_SIZE-1 && cw_index == NUM_CODEWORDS-1) begin
                active_buf <= ~active_buf; // 切换PingPong
            end
        end
    end

    // 写地址映射: 0~1023
    wire [9:0] wr_addr = cw_index * CODEWORD_SIZE + cw_addr;

    // ============ BRAM 实例化 (双缓冲) ============
    wire [31:0] doutA, doutB;

    blk_mem_gen_0 BRAM_A (
        .clka(clk), .wea(write_en & (active_buf==0)), .addra(wr_addr), .dina(s_axis_tdata),
        .clkb(clk), .web(1'b0), .addrb(rd_addr), .dinb(32'b0), .doutb(doutA)
    );

    blk_mem_gen_0 BRAM_B (
        .clka(clk), .wea(write_en & (active_buf==1)), .addra(wr_addr), .dina(s_axis_tdata),
        .clkb(clk), .web(1'b0), .addrb(rd_addr), .dinb(32'b0), .doutb(doutB)
    );

    // ============ 读端 控制 ============
    reg [9:0] rd_addr;
    reg       rd_buf; // 当前读的PingPong选择

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_addr <= 0;
            rd_buf  <= 1;  // 与写端错开
        end else if (m_axis_tready && m_axis_tvalid) begin
            rd_addr <= rd_addr + 1'b1;
            if (rd_addr == NUM_CODEWORDS*CODEWORD_SIZE-1) begin
                rd_addr <= 0;
                rd_buf  <= ~rd_buf; // 读端切换
            end
        end
    end

    // 输出数据选择
    always @(*) begin
        if (rd_buf == 0) m_axis_tdata = doutA;
        else             m_axis_tdata = doutB;
    end

    // 有效信号
    always @(posedge clk or posedge rst) begin
        if (rst) m_axis_tvalid <= 0;
        else     m_axis_tvalid <= 1; // 数据连续流出
    end

    // 上游ready
    assign s_axis_tready = 1'b1; // 可加fifo流控

endmodule
