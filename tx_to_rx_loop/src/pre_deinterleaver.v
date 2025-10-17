// de intealeaver verion v1
// 解交织器将外部数据按行将数据存入
// 按列将数据读出 还原数据
// 
module pre_deinterleaver#(
    parameter CODEWORD_SIZE_IN_32 = 65,
    parameter NUM_CODEWORDS       = 4
)(
    input  wire                   clk,
    input  wire                   rst,
    // AXI-Stream Slave Interface
    input  wire [31:0]            s_axis_tdata,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    // AXI-Stream Master Interface
    output wire [31:0]            m_axis_tdata,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready
);

    // ------------------ 存储器定义 ------------------
    localparam BLOCK_SIZE = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS;
    reg [31:0] RAM_b0 [NUM_CODEWORDS-1:0] [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM_b1 [NUM_CODEWORDS-1:0] [CODEWORD_SIZE_IN_32-1:0];

    // ------------------ 状态变量 ------------------
    reg wr_pingpong;
    reg rd_pingpong;
    reg block0_full;
    reg block1_full;
    reg [$clog2(BLOCK_SIZE)-1:0] wr_count;
    reg [$clog2(BLOCK_SIZE)-1:0] rd_count;

    // ------------------ 握手信号 ------------------
    wire do_write = s_axis_tvalid && s_axis_tready;
    wire do_read  = m_axis_tvalid && m_axis_tready;

    // ------------------ 写入逻辑 ------------------
    assign s_axis_tready = (wr_pingpong == 0) ? !block0_full : !block1_full;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_pingpong <= 1'b0;
            block0_full <= 1'b0;
            block1_full <= 1'b0;
            wr_count    <= 0;
        end else if (do_write) begin
            if (wr_count == BLOCK_SIZE - 1) begin
                wr_count <= 0;
                wr_pingpong <= ~wr_pingpong;
                if (wr_pingpong == 0) block0_full <= 1'b1;
                else                  block1_full <= 1'b1;
            end else begin
                wr_count <= wr_count + 1;
            end
        end
    end

    // 地址生成与RAM写入 (按行写入)
    wire [$clog2(NUM_CODEWORDS)-1:0]       wr_ram_sel;
    wire [$clog2(CODEWORD_SIZE_IN_32)-1:0] wr_addr;
    
    assign wr_ram_sel = wr_count % NUM_CODEWORDS; // 轮流写入RAM0, RAM1...
    assign wr_addr    = wr_count / NUM_CODEWORDS;

    always @(posedge clk) begin
        if (do_write) begin
            if (wr_pingpong == 0) begin
                RAM_b0[wr_ram_sel][wr_addr] <= s_axis_tdata;
            end else begin
                RAM_b1[wr_ram_sel][wr_addr] <= s_axis_tdata;
            end
        end
    end

    // ------------------ 读出逻辑 ------------------
    assign m_axis_tvalid = (rd_pingpong == 0) ? block0_full : block1_full;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_pingpong <= 1'b0;
            rd_count    <= 0;
        end else if (do_read) begin
            if (rd_count == BLOCK_SIZE - 1) begin
                rd_count <= 0;
                rd_pingpong <= ~rd_pingpong;
                if (rd_pingpong == 0) block0_full <= 1'b0;
                else                  block1_full <= 1'b0;
            end else begin
                rd_count <= rd_count + 1;
            end
        end
    end

    // 地址生成与数据读出 (按列读出)
    wire [$clog2(NUM_CODEWORDS)-1:0]       rd_ram_sel;
    wire [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_addr;

    assign rd_ram_sel = rd_count / CODEWORD_SIZE_IN_32; // 先读完RAM0, 再读RAM1...
    assign rd_addr    = rd_count % CODEWORD_SIZE_IN_32;
    
    assign m_axis_tdata = (rd_pingpong == 0) ? RAM_b0[rd_ram_sel][rd_addr] : RAM_b1[rd_ram_sel][rd_addr];

endmodule