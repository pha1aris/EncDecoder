module de_interleaver #(
    parameter CODEWORD_SIZE = 256,   // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS = 4      // 码字个数
)(
    input  wire         clk,
    input  wire         rst,

    // 输入接口（来自信道/解码器）
    input  wire [31:0]  s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    // 输出接口（恢复后的顺序流）
    output reg  [31:0]  m_axis_tdata,
    output reg          m_axis_tvalid,
    input  wire         m_axis_tready
);

    // ================= 写入控制 =================
    reg [1:0] cw_wr_index;   // 当前写哪个码字 (0~3)
    reg [7:0] cw_wr_addr;    // 当前码字地址 (0~255)
    reg       wr_buf;        // PingPong写选择

    wire write_en = s_axis_tvalid & s_axis_tready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cw_wr_index <= 0;
            cw_wr_addr  <= 0;
            wr_buf      <= 0;
        end else if (write_en) begin
            cw_wr_addr <= cw_wr_addr + 1'b1;
            if (cw_wr_addr == CODEWORD_SIZE-1) begin
                cw_wr_addr  <= 0;
                cw_wr_index <= cw_wr_index + 1'b1;
                if (cw_wr_index == NUM_CODEWORDS-1) begin
                    cw_wr_index <= 0;
                    wr_buf <= ~wr_buf; // 一帧写完切换buffer
                end
            end
        end
    end

    // 写地址映射
    wire [9:0] wr_addr = cw_wr_index*CODEWORD_SIZE + cw_wr_addr;

    // ================= 读出控制 =================
    reg [7:0] cw_rd_addr;   // 每个CW内地址
    reg [1:0] cw_rd_index;  // 轮询读取CW0..CW3
    reg       rd_buf;       // 当前读哪块BRAM (与写错开)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cw_rd_addr  <= 0;
            cw_rd_index <= 0;
            rd_buf      <= 1; // 默认与写端反相
        end else if (m_axis_tready && m_axis_tvalid) begin
            if (cw_rd_index == NUM_CODEWORDS-1) begin
                cw_rd_index <= 0;
                cw_rd_addr  <= cw_rd_addr + 1'b1;
                if (cw_rd_addr == CODEWORD_SIZE-1) begin
                    cw_rd_addr <= 0;
                    rd_buf <= ~rd_buf; // 一帧读完切换
                end
            end else begin
                cw_rd_index <= cw_rd_index + 1'b1;
            end
        end
    end

    // 读地址映射
    wire [9:0] rd_addr = cw_rd_index*CODEWORD_SIZE + cw_rd_addr;

    // ================= BRAM实例 =================
    wire [31:0] doutA, doutB;

    blk_mem_gen_0 BRAM_A (
        .clka(clk), .wea(write_en & (wr_buf==0)), .addra(wr_addr), .dina(s_axis_tdata),
        .clkb(clk), .web(1'b0), .addrb(rd_addr), .dinb(32'b0), .doutb(doutA)
    );

    blk_mem_gen_0 BRAM_B (
        .clka(clk), .wea(write_en & (wr_buf==1)), .addra(wr_addr), .dina(s_axis_tdata),
        .clkb(clk), .web(1'b0), .addrb(rd_addr), .dinb(32'b0), .doutb(doutB)
    );

    // ================= 输出逻辑 =================
    always @(*) begin
        if (rd_buf==0) m_axis_tdata = doutA;
        else           m_axis_tdata = doutB;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) m_axis_tvalid <= 0;
        else     m_axis_tvalid <= 1; // 连续流
    end

    assign s_axis_tready = 1'b1;

endmodule
