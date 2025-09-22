module de_interleaver #(
    parameter CODEWORD_SIZE_IN_32 = 65,   // 每个码字长度 (与pre_interleaver保持一致)
    parameter NUM_CODEWORDS       = 4     // 码字个数 (与pre_interleaver保持一致)
)(
    input  wire          clk,
    input  wire          rst,

    // 输入接口 (来自信道/解码器)
    input  wire [31:0]   s_axis_tdata,
    input  wire          s_axis_tvalid,
    output wire          s_axis_tready,

    // 输出接口 (恢复后的顺序流)
    output reg  [31:0]   m_axis_tdata,
    output reg           m_axis_tvalid,
    input  wire          m_axis_tready
);

    localparam BLOCK_SIZE_IN_32 = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS; // 260 words

    // ================= 状态与控制 =================
    reg       wr_buf;    // 当前写的Buffer选择 (0:A, 1:B)
    reg       rd_buf;    // 当前读的Buffer选择 (0:A, 1:B)
    reg       bufA_full, bufB_full;

    wire write_en = s_axis_tvalid & s_axis_tready;
    wire read_en  = m_axis_tvalid & m_axis_tready;

    // ================= 写入控制 (按行/顺序写入) =================
    reg [8:0] wr_local_addr; // 线性地址计数器 0..259

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_local_addr <= 0;
            wr_buf <= 0;
            bufA_full <= 0;
            bufB_full <= 0;
        end else if (write_en) begin
            if (wr_local_addr == BLOCK_SIZE_IN_32 - 1) begin
                wr_local_addr <= 0;
                // 写满一个block, 置位full标志并切换buffer
                if (wr_buf == 0) bufA_full <= 1'b1;
                else             bufB_full <= 1'b1;
                wr_buf <= ~wr_buf;
            end else begin
                wr_local_addr <= wr_local_addr + 1'b1;
            end
        end
    end
    
    // 写地址生成
    wire [9:0] wr_base = (wr_buf == 0) ? 10'd0 : 10'd260;
    wire [9:0] wr_addr = wr_base + wr_local_addr;


    // ================= 读出控制 (按列/交织读出) =================
    reg [1:0] rd_index;  // 读哪个CW (0~3)，快速变化
    reg [5:0] rd_addr_in_cw; // CW内部地址 (0~64)，慢速变化

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_index      <= 0;
            rd_addr_in_cw <= 0;
            rd_buf        <= 1; // 与写端错开
        end else if (read_en) begin
            if (rd_index == NUM_CODEWORDS - 1) begin
                rd_index <= 0;
                rd_addr_in_cw <= rd_addr_in_cw + 1'b1;
            end else begin
                rd_index <= rd_index + 1'b1;
            end

            // 读完一个block
            if (rd_addr_in_cw == CODEWORD_SIZE_IN_32 - 1 && rd_index == NUM_CODEWORDS - 1) begin
                // 释放buffer并切换
                if (rd_buf == 0) bufA_full <= 1'b0;
                else             bufB_full <= 1'b0;
                rd_buf <= ~rd_buf;
                rd_addr_in_cw <= 0; // 读完一个块后，地址清零
            end
        end
    end

    // 读地址生成
    wire [8:0] local_rd_addr = rd_index * CODEWORD_SIZE_IN_32 + rd_addr_in_cw;
    wire [9:0] rd_base       = (rd_buf == 0) ? 10'd0 : 10'd260;
    wire [9:0] rd_addr       = rd_base + local_rd_addr;
    

    // ================= BRAM实例 (单体BRAM) =================
    wire [31:0] doutb;

    blk_mem_gen_0 deinterleaver_bram (
        .clka (clk),
        .wea  (write_en),
        .addra(wr_addr),
        .dina (s_axis_tdata),
        .douta(),

        .clkb (clk),
        .web  (1'b0),
        .addrb(rd_addr),
        .dinb (32'b0),
        .doutb(doutb)
    );

    // ================= 输出与流控 =================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tdata  <= 32'd0;
            m_axis_tvalid <= 1'b0;
        end else begin
            m_axis_tdata <= doutb;
            // 当且仅当要读的buffer是满的时候，输出才有效
            if ((rd_buf == 0 && bufA_full) || (rd_buf == 1 && bufB_full))
                m_axis_tvalid <= 1'b1;
            // 读完最后一个数据且下游接受了，tvalid马上拉低
            else if (read_en && rd_addr_in_cw == CODEWORD_SIZE_IN_32 - 1 && rd_index == NUM_CODEWORDS - 1)
                m_axis_tvalid <= 1'b0;
        end
    end

    // 当且仅当要写的buffer是空的时候，才接收上游数据
    assign s_axis_tready = (wr_buf == 0 && !bufA_full) || (wr_buf == 1 && !bufB_full);

endmodule