`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: de_interleaver
// Description: 解交织器模块.
//              它是 pre_interleaver 的逆操作.
//              - 写逻辑: 对应 pre_interleaver 的读逻辑, 按顺序接收交织数据, 依次填满 RAM0, RAM1, ...
//              - 读逻辑: 对应 pre_interleaver 的写逻辑, 按地址交错读出, 恢复原始数据顺序.
//////////////////////////////////////////////////////////////////////////////////

module de_interleaver #(
    parameter CODEWORD_SIZE_IN_32 = 65,    // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS       = 4      // 码字个数
)(
    input  wire                              clk,
    input  wire                              rst,

    // 输入接口 (AXIS)
    input  wire [31:0]                       s_axis_tdata,
    input  wire                              s_axis_tvalid,
    output wire                              s_axis_tready,

    // 输出接口 (AXIS)
    output reg  [31:0]                       m_axis_tdata,
    output reg                               m_axis_tvalid,
    input  wire                              m_axis_tready
);

    // RAM 深度参数化
    reg [31:0] RAM0[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM1[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM2[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM3[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM4[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM5[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM6[CODEWORD_SIZE_IN_32-1:0];
    reg [31:0] RAM7[CODEWORD_SIZE_IN_32-1:0];
    // 仿真时初始化RAM (仅用于仿真)
    integer i;
    initial begin
        for (i = 0; i < CODEWORD_SIZE_IN_32; i = i+1) begin
            RAM0[i] = 32'd0; RAM1[i] = 32'd0; RAM2[i] = 32'd0; RAM3[i] = 32'd0;
            RAM4[i] = 32'd0; RAM5[i] = 32'd0; RAM6[i] = 32'd0; RAM7[i] = 32'd0;
        end
    end
    // ================== 控制信号 ==================
    reg write_to_block1;

    // 写指针 (对应 pre_interleaver 的读指针)
    reg [1:0] ram_wr_sel0;
    reg [6:0] ptr0;
    reg       block0_full;
    reg       block0_reading;

    // 写指针 (对应 pre_interleaver 的读指针)
    reg [1:0] ram_wr_sel1;
    reg [6:0] ptr1;
    reg       block1_full;
    reg       block1_reading;
    reg [31:0] read_data0;
    reg [6:0]  rd_ptr0;
    reg [1:0]  rd_ram_sel0;

    reg block0_reading_d, block1_reading_d; // 上一周期的 reading 快照
    
    reg [31:0] read_data1;
    reg [6:0]  rd_ptr1;
    reg [1:0]  rd_ram_sel1;

    // ================== 写 Block 0 逻辑 (接收交织数据) ==================
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ram_wr_sel0 <= 2'd0;
            ptr0 <= 7'd0;
            block0_full <= 0;
            write_to_block1 <= 0;
        end else if(s_axis_tvalid && s_axis_tready && !write_to_block1) begin
            // 这里的指针更新逻辑和 pre_interleaver 的读逻辑一致
            if(ptr0 == CODEWORD_SIZE_IN_32 - 1) begin
                ptr0 <= 7'd0;
                if(ram_wr_sel0 == NUM_CODEWORDS - 1) begin
                    ram_wr_sel0 <= 2'd0;
                    block0_full <= 1'b1;
                    write_to_block1 <= 1'b1; // 切换
                end else begin
                    ram_wr_sel0 <= ram_wr_sel0 + 1;
                end
            end else begin
                ptr0 <= ptr0 + 1;
            end
        end
    end

    // Block 0 RAM 写
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

    // ================== 写 Block 1 逻辑 (接收交织数据) ==================
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ram_wr_sel1 <= 2'd0;
            ptr1 <= 7'd0;
            block1_full <= 0;
        end else if(s_axis_tvalid && s_axis_tready && write_to_block1) begin
            if(ptr1 == CODEWORD_SIZE_IN_32 - 1) begin
                ptr1 <= 7'd0;
                if(ram_wr_sel1 == NUM_CODEWORDS - 1) begin
                    ram_wr_sel1 <= 2'd0;
                    block1_full <= 1'b1;
                    write_to_block1 <= 1'b0; // 切换
                end else begin
                    ram_wr_sel1 <= ram_wr_sel1 + 1;
                end
            end else begin
                ptr1 <= ptr1 + 1;
            end
        end
    end

    // Block 1 RAM 写
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
    assign s_axis_tready = (!write_to_block1 && !block0_full) || (write_to_block1 && !block1_full);
    // assign m_axis_tvalid = block0_reading || block1_reading;

    // always @(posedge clk or posedge rst) begin : proc_
    //     if(rst) begin
    //         m_axis_tvalid <= 0;
    //     end else if(block0_reading || block1_reading) begin
    //         m_axis_tvalid <= 1;
    //     end else begin
    //         m_axis_tvalid <= 0;
    //     end
    // end

    // always @(posedge clk) begin
    //     if(rst) begin
    //         m_axis_tdata <= 32'd0;
    //     end else if (block0_reading) begin
    //         m_axis_tdata <= read_data0;
    //     end else if (block1_reading) begin
    //         m_axis_tdata <= read_data1;
    //     end
    // end

    // --- 在 module 顶部或适当位置新增延迟寄存器 ---

    // --- 在 posedge 时更新快照（放在当前已有的 posedge 区域之外也可以） ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            block0_reading_d <= 1'b0;
            block1_reading_d <= 1'b0;
        end else begin
            block0_reading_d <= block0_reading;
            block1_reading_d <= block1_reading;
        end
    end

    // --- 用延迟快照驱动 valid（这样 valid 在 read_data 可用的周期为高） ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tvalid <= 1'b0;
        end else begin
            m_axis_tvalid <= block0_reading_d || block1_reading_d;
        end
    end

    // --- 用延迟快照选择并寄存 data，保证 data/valid 同步 ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_tdata <= 32'd0;
        end else begin
            if (block0_reading_d) begin
                m_axis_tdata <= read_data0;
            end else if (block1_reading_d) begin
                m_axis_tdata <= read_data1;
            end else begin
                m_axis_tdata <= 32'd0;
            end
        end
    end


    // ================== Block 0 读逻辑 (恢复原始顺序) ==================


    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_ptr0 <= 'd0;
            rd_ram_sel0 <= 2'b00;
            block0_reading <= 0;
        end else if(block0_full && m_axis_tready) begin
            block0_reading <= 1;
            // 这里的指针更新逻辑和 pre_interleaver 的写逻辑一致
            if(rd_ram_sel0 == NUM_CODEWORDS - 1) begin
                rd_ram_sel0 <= 2'd0;
                if(rd_ptr0 == CODEWORD_SIZE_IN_32 - 1) begin
                    rd_ptr0 <= 'd0;
                    block0_full <= 1'b0; // 读完后清空
                    block0_reading <= 0;
                end else begin
                    rd_ptr0 <= rd_ptr0 + 1;
                end
            end else begin
                rd_ram_sel0 <= rd_ram_sel0 + 1;
            end
        end else if (!block0_full) begin
             block0_reading <= 0;
        end
    end

    // Block 0 读数据 MUX
    always @(posedge clk) begin
        case(rd_ram_sel0)
            2'b00: read_data0 <= RAM0[rd_ptr0];
            2'b01: read_data0 <= RAM1[rd_ptr0];
            2'b10: read_data0 <= RAM2[rd_ptr0];
            2'b11: read_data0 <= RAM3[rd_ptr0];
            default: read_data0 <= 'd0;
        endcase
    end

    // ================== Block 1 读逻辑 (恢复原始顺序) ==================
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_ptr1 <= 'd0;
            rd_ram_sel1 <= 2'b00;
            block1_reading <= 0;
        end else if(block1_full && m_axis_tready) begin
            block1_reading <= 1;
            if(rd_ram_sel1 == NUM_CODEWORDS - 1) begin
                rd_ram_sel1 <= 2'd0;
                if(rd_ptr1 == CODEWORD_SIZE_IN_32 - 1) begin
                    rd_ptr1 <= 'd0;
                    block1_full <= 1'b0; // 读完后清空
                    block1_reading <= 0;
                end else begin
                    rd_ptr1 <= rd_ptr1 + 1;
                end
            end else begin
                rd_ram_sel1 <= rd_ram_sel1 + 1;
            end
        end else if (!block1_full) begin
            block1_reading <= 0;
        end
    end

    // Block 1 读数据 MUX
    always @(posedge clk) begin
        case(rd_ram_sel1)
            2'b00: read_data1 <= RAM4[rd_ptr1];
            2'b01: read_data1 <= RAM5[rd_ptr1];
            2'b10: read_data1 <= RAM6[rd_ptr1];
            2'b11: read_data1 <= RAM7[rd_ptr1];
            default: read_data1 <= 'd0;
        endcase
    end
endmodule

