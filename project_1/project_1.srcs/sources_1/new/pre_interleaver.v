module pre_interleaver #(
    parameter CODEWORD_SIZE_IN_32 = 65,   // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS       = 4     // 码字个数
)(
    input  wire          clk,
    input  wire          rst,

    // 输入接口 (AXIS-like)
    input  wire [31:0]   s_axis_tdata,
    input  wire          s_axis_tvalid,
    output wire          s_axis_tready,

    // 输出接口 (AXIS-like)
    output reg  [31:0]   m_axis_tdata,
    output reg           m_axis_tvalid,
    input  wire          m_axis_tready
);

    localparam BLOCK_SIZE_IN_32 = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS; // 260 words
    localparam BUF_SIZE           = BLOCK_SIZE_IN_32 * 2;             // 520 words

    // ================= 写端控制 =================
    reg [1:0] cw_index;  // 当前写哪个CW (0~3)
    reg [5:0] cw_addr;   // CW内部地址 (0~64)
    reg       wr_buf;    // 当前写的Buffer选择 (0:A, 1:B)
    reg       bufA_full, bufB_full;

    wire write_en = s_axis_tvalid & s_axis_tready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cw_index  <= 0;
            cw_addr   <= 0;
            wr_buf    <= 0;
            bufA_full <= 0;
            bufB_full <= 0;
        end else if (write_en) begin
            // 更新索引
            if (cw_index == NUM_CODEWORDS-1) begin
                cw_index <= 0;
                cw_addr  <= cw_addr + 1'b1;
            end else begin
                cw_index <= cw_index + 1'b1;
            end

            // 写满一个block
            if (cw_addr == CODEWORD_SIZE_IN_32-1 && cw_index == NUM_CODEWORDS-1) begin
                if (wr_buf==0) bufA_full <= 1'b1;
                else           bufB_full <= 1'b1;
                wr_buf <= ~wr_buf; // 切换buffer
                cw_addr <= 0; // 写完一个块后，cw_addr也需要清零
            end
        end
    end

    // 写地址生成
    // <<<--- 关键修改在此
    wire [8:0] local_wr_addr = cw_index * CODEWORD_SIZE_IN_32 + cw_addr; // 真正的交织地址
    wire [9:0] wr_base       = (wr_buf==0) ? 10'd0 : 10'd260;
    wire [9:0] wr_addr       = wr_base + local_wr_addr;

    // ================= 读端控制 =================
    // (读端逻辑无需修改)
    reg [8:0] rd_local; // 0..259
    reg       rd_buf;   // 当前读的Buffer选择

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_local <= 0;
            rd_buf   <= 1; // 与写端错开
        end else if (m_axis_tvalid && m_axis_tready) begin
            if (rd_local == BLOCK_SIZE_IN_32-1) begin
                rd_local <= 0;
                // 读完，释放buffer
                if (rd_buf==0) bufA_full <= 1'b0;
                else           bufB_full <= 1'b0;
                rd_buf <= ~rd_buf;
            end else begin
                rd_local <= rd_local + 1'b1;
            end
        end
    end

    // 读地址生成
    wire [9:0] rd_base = (rd_buf==0) ? 10'd0 : 10'd260;
    wire [9:0] rd_addr = rd_base + rd_local;

    // ================= BRAM实例 =================
    wire [31:0] doutb;

    blk_mem_gen_0 interleaver_bram (
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

    // ================= 输出逻辑 =================
    // (输出逻辑无需修改)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tdata  <= 32'd0;
            m_axis_tvalid <= 1'b0;
        end else begin
            m_axis_tdata <= doutb;
            if ((rd_buf==0 && bufA_full) || (rd_buf==1 && bufB_full))
                m_axis_tvalid <= 1'b1;
            else if (rd_local==BLOCK_SIZE_IN_32-1 && m_axis_tready)
                m_axis_tvalid <= 1'b0;
        end
    end

    // ================= 输入ready =================
    // (输入ready逻辑无需修改)
    assign s_axis_tready = (wr_buf==0 && !bufA_full) || (wr_buf==1 && !bufB_full);

endmodule