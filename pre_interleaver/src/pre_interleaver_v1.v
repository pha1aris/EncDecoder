// ============================================================================
// pre_interleaver_v1 (重构优化版)
// 功能: 按列写入, 按行读出. 支持断续的AXIS valid信号.
// ============================================================================
module pre_interleaver_v1 #(
    parameter DATA_WIDTH = 32,
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
    // 使用两组RAM实现乒乓操作
    localparam BLOCK_SIZE = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS;
    reg [31:0] RAM_b0 [NUM_CODEWORDS-1:0] [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM_b1 [NUM_CODEWORDS-1:0] [CODEWORD_SIZE_IN_32-1:0];

    // ------------------ 状态变量 ------------------
    reg wr_pingpong; // 0: 写Block0, 1: 写Block1
    reg rd_pingpong; // 0: 读Block0, 1: 读Block1
    reg block0_full;
    reg block1_full;
    
    // 主计数器
    reg [$clog2(BLOCK_SIZE)-1:0] wr_count;
    reg [$clog2(BLOCK_SIZE)-1:0] rd_count;

    // ------------------ 握手信号 ------------------
    wire do_write = s_axis_tvalid && s_axis_tready;
    wire do_read  = m_axis_tvalid && m_axis_tready;

    // ------------------ 写入逻辑 ------------------
    // 只有当前要写的block不为满时, 才接收数据
    assign s_axis_tready = (wr_pingpong == 0) ? !block0_full : !block1_full;

    // 写控制: 更新计数器和乒乓指针
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_pingpong <= 1'b0;
            block0_full <= 1'b0;
            block1_full <= 1'b0;
            wr_count    <= 0;
        end else if (do_write) begin
            if (wr_count == BLOCK_SIZE - 1) begin
                wr_count <= 0;
                wr_pingpong <= ~wr_pingpong; // 切换到另一个Block
                if (wr_pingpong == 0) begin
                    block0_full <= 1'b1;
                end else begin
                    block1_full <= 1'b1;
                end
            end else begin
                wr_count <= wr_count + 1;
            end
        end
    end

    // 地址生成与RAM写入 (按列写入)
    wire [$clog2(NUM_CODEWORDS)-1:0]       wr_ram_sel;
    wire [$clog2(CODEWORD_SIZE_IN_32)-1:0] wr_addr;

    assign wr_ram_sel = wr_count / CODEWORD_SIZE_IN_32; // 先写满RAM0, 再写RAM1...
    assign wr_addr    = wr_count % CODEWORD_SIZE_IN_32;

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
    // 只有当前要读的block为满时, 才输出valid
    assign m_axis_tvalid = (rd_pingpong == 0) ? block0_full : block1_full;

    // 读控制: 更新计数器和乒乓指针
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_pingpong <= 1'b0;
            rd_count    <= 0;
        end else if (do_read) begin
            if (rd_count == BLOCK_SIZE - 1) begin
                rd_count <= 0;
                rd_pingpong <= ~rd_pingpong; // 切换到另一个Block
                // 读完后, 将full标志清零, 以便写入逻辑可以复用
                if (rd_pingpong == 0) begin
                    block0_full <= 1'b0;
                end else begin
                    block1_full <= 1'b0;
                end
            end else begin
                rd_count <= rd_count + 1;
            end
        end
    end
    
    // 地址生成与数据读出 (按行读出)
    wire [$clog2(NUM_CODEWORDS)-1:0]       rd_ram_sel;
    wire [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_addr;

    assign rd_ram_sel = rd_count % NUM_CODEWORDS; // 从RAM0读一个, RAM1读一个...
    assign rd_addr    = rd_count / NUM_CODEWORDS;
    
    assign m_axis_tdata = (rd_pingpong == 0) ? RAM_b0[rd_ram_sel][rd_addr] : RAM_b1[rd_ram_sel][rd_addr];

endmodule