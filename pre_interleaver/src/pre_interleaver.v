// 将每个输入数据分散到个数为NUM_CODEWORDS
// 长度为CODEWORD_SIZE_IN_32（32bits）的
// 码字中
//
module pre_interleaver #(
    parameter CODEWORD_SIZE_IN_32 = 65,    // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS       = 4      // 码字个数
)(
    input  wire                              clk,
    input  wire                              rst,

    // 输入接口 (AXIS-like)
    input  wire [31:0]                       s_axis_tdata,
    input  wire                              s_axis_tvalid,
    output wire                              s_axis_tready,

    // 输出接口 (AXIS-like)
    output reg  [31:0]                       m_axis_tdata,
    output wire                              m_axis_tvalid,
    input  wire                              m_axis_tready
);

    // [FIX 1]：RAM深度参数化。原始代码的RAM深度是硬编码的64，与参数65不匹配，会导致地址越界。
    reg [31:0] RAM0 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM1 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM2 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM3 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM4 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM5 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM6 [CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM7 [CODEWORD_SIZE_IN_32-1:0];

    // 仿真时初始化RAM (仅用于仿真)
    integer i;
    initial begin
        for (i = 0; i < CODEWORD_SIZE_IN_32; i = i+1) begin
            RAM0[i] = 32'd0; RAM1[i] = 32'd0; RAM2[i] = 32'd0; RAM3[i] = 32'd0;
            RAM4[i] = 32'd0; RAM5[i] = 32'd0; RAM6[i] = 32'd0; RAM7[i] = 32'd0;
        end
    end

    // ================== 控制信号 ==================
    // [FIX 2]: 引入一个明确的乒乓写选择信号，这是解决控制混乱的关键。
    reg write_to_block1;

    reg [1:0] ram_wr_sel0;
    reg [6:0] ptr0;
    reg       block0_full;
    reg       block0_reading;

    reg [1:0] ram_wr_sel1;
    reg [6:0] ptr1;
    reg       block1_full;
    reg       block1_reading;
    reg m_axis_tvalid_r;
    reg [31:0] read_data0;
    reg [6:0]  rd_ptr0;
    reg [1:0]  rd_ram_sel0;
    reg [31:0] read_data1;
    reg [6:0]  rd_ptr1;
    reg [1:0]  rd_ram_sel1;
    
    // ================== 写 Block 0 逻辑 ==================
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ram_wr_sel0 <= 2'd0;
            ptr0 <= 7'd0;
            block0_full <= 0;
            write_to_block1 <= 0; // 初始化写选择信号
        // [FIX 3]: 写Block0的条件现在由乒乓选择信号 !write_to_block1 控制。
        end else if(s_axis_tvalid && s_axis_tready && !write_to_block1) begin
            if(ram_wr_sel0 == NUM_CODEWORDS - 1) begin
                ram_wr_sel0 <= 2'd0;
                if(ptr0 == CODEWORD_SIZE_IN_32 - 1) begin
                    ptr0 <= 'd0;
                    block0_full <= 1'b1;
                    write_to_block1 <= 1'b1; // **核心切换**：写完Block0后，切换去写Block1
                end else begin    
                    ptr0 <= ptr0 + 1;
                end
            end else begin
                ram_wr_sel0 <= ram_wr_sel0 + 1;
            end
        end
    end

    // Block 0 RAM 写操作 (保持不变)
    always @(posedge clk) begin
        if(s_axis_tvalid && s_axis_tready && !write_to_block1) begin
            case(ram_wr_sel0)
                2'b00: RAM0[ptr0] <= s_axis_tdata;
                2'b01: RAM1[ptr0] <= s_axis_tdata;
                2'b10: RAM2[ptr0] <= s_axis_tdata;
                2'b11: RAM3[ptr0] <= s_axis_tdata;
            endcase
        end
    end

    // ================== 写 Block 1 逻辑 ==================
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ram_wr_sel1 <= 2'd0;
            ptr1 <= 7'd0;
            block1_full <= 0;
        end else if(s_axis_tvalid && s_axis_tready && write_to_block1) begin
            if(ram_wr_sel1 == NUM_CODEWORDS - 1) begin
                ram_wr_sel1 <= 2'd0;
                if(ptr1 == CODEWORD_SIZE_IN_32 - 1) begin
                    ptr1 <= 'd0;
                    block1_full <= 1'b1;
                    write_to_block1 <= 1'b0; // **核心切换**：写完Block1后，切换回去写Block0
                end else begin
                    ptr1 <= ptr1 + 1;
                end
            end else begin
                ram_wr_sel1 <= ram_wr_sel1 + 1;
            end
        end
    end

    // Block 1 RAM 写操作 (条件修改)
    always @(posedge clk) begin
        if(s_axis_tvalid && s_axis_tready && write_to_block1) begin
            case(ram_wr_sel1)
                2'b00: RAM4[ptr1] <= s_axis_tdata;
                2'b01: RAM5[ptr1] <= s_axis_tdata;
                2'b10: RAM6[ptr1] <= s_axis_tdata;
                2'b11: RAM7[ptr1] <= s_axis_tdata;
            endcase
        end
    end

    // ================== 读/输出 逻辑 ==================
    // [FIX 4]: 实现正确的反压逻辑。只有当目标写缓存区没满时，才接收数据。
    assign s_axis_tready = (!write_to_block1 && !block0_full) || (write_to_block1 && !block1_full);

    // assign m_axis_tvalid = block0_reading || block1_reading;

    // // always @(*) begin
    // //     if(rst) begin
    // //         m_axis_tvalid <= 0;
    // //     end else if(block0_reading || block1_reading) begin
    // //         m_axis_tvalid <= 1;
    // //     end else begin
    // //         m_axis_tvalid <= 0;
    // //     end
    // // end

    // always @(*) begin
    //     if(rst) begin
    //         m_axis_tdata <= 32'd0;
    //     end else if (block0_reading) begin
    //         m_axis_tdata <= read_data0;
    //     end else if (block1_reading) begin
    //         m_axis_tdata <= read_data1;
    //     end
    // end
// --- register valid one cycle later so it lines up with read_data (which comes from sync RAM) ---

always @(posedge clk or posedge rst) begin
    if (rst) begin
        m_axis_tvalid_r <= 1'b0;
    end else begin
        // note: RHS reads the pre-clock block*_reading (i.e. previous-cycle value) — that's what we want
        m_axis_tvalid_r <= block0_reading || block1_reading;
    end
end

assign m_axis_tvalid = m_axis_tvalid_r;

// --- register data so it is sampled the cycle after read_data was updated ---
always @(posedge clk or posedge rst) begin
    if (rst) begin
        m_axis_tdata <= 32'd0;
    end else begin
        // use the *previous-cycle* block*_reading value (current pre-clock value) to decide which read_data to present
        if (block0_reading) begin
            // read_data0 was produced in the previous clock edge (synchronous RAM read),
            // so now we can safely present it to output
            m_axis_tdata <= read_data0;
        end else if (block1_reading) begin
            m_axis_tdata <= read_data1;
        end else begin
            m_axis_tdata <= 32'd0; // or hold last value if you prefer
        end
    end
end



// ==========================================================================================
// ============================ ---------- 读逻辑--------- ===================================
// ==========================================================================================

    // ================== Block 0 读逻辑 ==================

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_ptr0 <= 'd0;
            rd_ram_sel0 <= 2'b00;
            block0_reading <= 0;
        //  只有当可以握手时才推进读指针，防止数据丢失。
        end else if(block0_full && m_axis_tready) begin
            block0_reading <= 1;
            if(rd_ptr0 == CODEWORD_SIZE_IN_32 - 1) begin
                rd_ptr0 <= 'd0;
                if(rd_ram_sel0 == NUM_CODEWORDS - 1) begin
                    rd_ram_sel0 <= 2'd0;
                    block0_full <= 1'b0; // 读完后，清空full标志，使其可被再次写入
                    block0_reading <= 0;
                end else begin
                    rd_ram_sel0 <= rd_ram_sel0 + 1;
                end
            end else begin
                rd_ptr0 <= rd_ptr0 + 1'b1;
            end
        end else if (!block0_full) begin
             block0_reading <= 0;
        end
    end

    // 读数据 MUX
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            read_data0 <= 'd0;
        end
        // 读出有一周期延迟
        else begin
            case(rd_ram_sel0)
                2'b00: read_data0 <= RAM0[rd_ptr0];
                2'b01: read_data0 <= RAM1[rd_ptr0];
                2'b10: read_data0 <= RAM2[rd_ptr0];
                2'b11: read_data0 <= RAM3[rd_ptr0];
                default: read_data0 <= 'd0;
            endcase
        end
    end

    // ================== Block 1 读逻辑 ==================

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_ptr1 <= 'd0;
            rd_ram_sel1 <= 2'b00;
            block1_reading <= 0;
        end else if(block1_full && m_axis_tready) begin
            block1_reading <= 1;
            if(rd_ptr1 == CODEWORD_SIZE_IN_32 - 1) begin
                rd_ptr1 <= 'd0;
                if(rd_ram_sel1 == NUM_CODEWORDS - 1) begin
                    rd_ram_sel1 <= 2'd0;
                    block1_full <= 1'b0; // 读完后，清空full标志
                    block1_reading <= 0;
                end else begin
                    rd_ram_sel1 <= rd_ram_sel1 + 1;
                end
            end else begin
                rd_ptr1 <= rd_ptr1 + 1'b1;
            end
        end else if (!block1_full) begin
            block1_reading <= 0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            read_data1 <= 'd0;
        end
        // 读出有一周期延迟
        else begin
            case(rd_ram_sel1)
                2'b00: read_data1 <= RAM4[rd_ptr1];
                2'b01: read_data1 <= RAM5[rd_ptr1];
                2'b10: read_data1 <= RAM6[rd_ptr1];
                2'b11: read_data1 <= RAM7[rd_ptr1];
                default: read_data1 <= 'd0;
            endcase
        end
    end
endmodule
