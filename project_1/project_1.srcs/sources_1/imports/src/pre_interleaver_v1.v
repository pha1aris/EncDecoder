// 将每个输入数据分散到个数为NUM_CODEWORDS
// 长度为CODEWORD_SIZE_IN_32（32bits）的
// 码字中
//
module pre_interleaver_v1 #(
   parameter CODEWORD_SIZE_IN_32 = 65,    // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS       = 4      // 码字个数
)(
    input  wire                              clk,
    input  wire                              rst,
    input  wire [31:0]                       s_axis_tdata,
    input  wire                              s_axis_tvalid,
    output wire                              s_axis_tready,
    output reg  [31:0]                       m_axis_tdata,
    output reg                               m_axis_tvalid,
    input  wire                              m_axis_tready
);
    
    reg [31:0] RAM0 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM1 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM2 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM3 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM4 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM5 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM6 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM7 [CODEWORD_SIZE_IN_32-1:0];

    // ... initial block unchanged ...
    integer i;
    initial begin
        for (i = 0; i < CODEWORD_SIZE_IN_32; i = i+1) begin
            RAM0[i] = 32'd0; RAM1[i] = 32'd0; RAM2[i] = 32'd0; RAM3[i] = 32'd0;
            RAM4[i] = 32'd0; RAM5[i] = 32'd0; RAM6[i] = 32'd0; RAM7[i] = 32'd0;
        end
    end

    // 写指针：每个 block 独立 (逻辑保持不变)
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] ptr_b0;
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] ptr_b1;
    reg [2:0] wr_ram_sel;
    reg block0_full, block1_full;

    assign s_axis_tready = !(block0_full && block1_full);

    //  ------------------写入逻辑 (保持不变)-------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ram_sel   <= 3'd0;
            ptr_b0       <= 0;
            ptr_b1       <= 0;
            block0_full  <= 1'b0;
            block1_full  <= 1'b0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            if (!block0_full) begin
                if (wr_ram_sel == 3'd3) begin
                    wr_ram_sel <= 3'd0;
                    if (ptr_b0 == CODEWORD_SIZE_IN_32-1) begin
                        block0_full <= 1'b1;
                        wr_ram_sel  <= 3'd4;
                        ptr_b0      <= 0;
                    end else begin
                        ptr_b0 <= ptr_b0 + 1;
                    end
                end else begin
                    wr_ram_sel <= wr_ram_sel + 1;
                end
            end
            else if (!block1_full) begin
                if (wr_ram_sel == 3'd7) begin
                    wr_ram_sel <= 3'd4;
                    if (ptr_b1 == CODEWORD_SIZE_IN_32-1) begin
                        block1_full <= 1'b1;
                        wr_ram_sel  <= 3'd0;
                        ptr_b1      <= 0;
                    end else begin
                        ptr_b1 <= ptr_b1 + 1;
                    end
                end else begin
                    wr_ram_sel <= wr_ram_sel + 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if(s_axis_tvalid && s_axis_tready)begin        
            case(wr_ram_sel)
                'd0: RAM0[ptr_b0] <= s_axis_tdata; 'd1: RAM1[ptr_b0] <= s_axis_tdata; 
                'd2: RAM2[ptr_b0] <= s_axis_tdata; 'd3: RAM3[ptr_b0] <= s_axis_tdata; 
                'd4: RAM4[ptr_b1] <= s_axis_tdata; 'd5: RAM5[ptr_b1] <= s_axis_tdata; 
                'd6: RAM6[ptr_b1] <= s_axis_tdata; 'd7: RAM7[ptr_b1] <= s_axis_tdata; 
            endcase
        end
    end

    // ------------------读出逻辑 (最小修改)-------------------------
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_ptr_b0;
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_ptr_b1;
    reg [2:0] rd_ram_sel;
    reg rd_active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr_b0   <= 0;
            rd_ptr_b1   <= 0;
            rd_ram_sel  <= 0;
            rd_active   <= 0;
        end else if (rd_active && m_axis_tready) begin
            if (rd_ram_sel <= 3'd3) begin
                // 读 block0
                if (rd_ptr_b0 == CODEWORD_SIZE_IN_32-1) begin
                    rd_ptr_b0 <= 0;
                    if (rd_ram_sel == 3'd3) begin // 整个 block0 的最后一个 RAM 读完
                        block0_full <= 0;
                        // [最小修改 1/3] 安全地切换到 block1 或停止
                        if (block1_full) begin
                            rd_ram_sel <= 3'd4; // 只有当 block1 满了才切换
                        end else begin
                            rd_active <= 1'b0;  // 否则停止读
                        end
                    end else begin
                        rd_ram_sel <= rd_ram_sel + 1;
                    end
                end else begin
                    rd_ptr_b0 <= rd_ptr_b0 + 1;
                end
            end else begin
                // 读 block1
                if (rd_ptr_b1 == CODEWORD_SIZE_IN_32-1) begin
                    rd_ptr_b1 <= 0;
                    if (rd_ram_sel == 3'd7) begin // 整个 block1 的最后一个 RAM 读完
                        block1_full <= 0;
                        rd_active   <= 0;     // 读完 block1 后总是先停止
                        // [最小修改 2/3] (可选但更清晰) 让启动逻辑决定下一步，而不是无条件切换
                        // rd_ram_sel <= 3'd0; // 删除此行，让启动逻辑处理
                    end else begin
                        rd_ram_sel <= rd_ram_sel + 1;
                    end
                end else begin
                    rd_ptr_b1 <= rd_ptr_b1 + 1;
                end
            end
        end else if (!rd_active && (block0_full || block1_full)) begin
            rd_active  <= 1'b1;
            // [最小修改 3/3] 读之前，正确初始化读指针
            if (block0_full) begin
                rd_ram_sel <= 3'd0;
            end else begin // 暗示 block1_full 为真
                rd_ram_sel <= 3'd4;
            end
        end
    end

    // 输出数据
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tdata  <= 0;
        end else if (rd_active && m_axis_tready) begin // 保持原样，此为有效的寄存器输出方式
            case (rd_ram_sel)
                3'd0: m_axis_tdata <= RAM0[rd_ptr_b0];
                3'd1: m_axis_tdata <= RAM1[rd_ptr_b0];
                3'd2: m_axis_tdata <= RAM2[rd_ptr_b0];
                3'd3: m_axis_tdata <= RAM3[rd_ptr_b0];
                3'd4: m_axis_tdata <= RAM4[rd_ptr_b1];
                3'd5: m_axis_tdata <= RAM5[rd_ptr_b1];
                3'd6: m_axis_tdata <= RAM6[rd_ptr_b1];
                3'd7: m_axis_tdata <= RAM7[rd_ptr_b1];
            endcase
        end
    end

    // [最小修改] 独立的 tvalid 逻辑，修复协议问题
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tvalid <= 1'b0;
        end else begin
            m_axis_tvalid <= rd_active;
        end
    end
endmodule