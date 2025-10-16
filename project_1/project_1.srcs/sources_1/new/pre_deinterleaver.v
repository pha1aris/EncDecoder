// de intealeaver verion v1
// 解交织器将外部数据按行将数据存入
// 按列将数据读出 还原数据
// 
module pre_deinterleaver#(
    parameter CODEWORD_SIZE_IN_32 = 65,    // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS       = 4      // 码字个数
)(
    input  wire                              clk,
    input  wire                              rst,

    // 输入接口 (AXIS-like)
    input  wire [31:0]                       s_axis_tdata,
    input  wire                              s_axis_tvalid,
    output wire                              s_axis_tready,

    input wire                               start_of_frame,
    // 输出接口 (AXIS-like)
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

    reg start_of_frame_d0,start_of_frame_d1;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            {start_of_frame_d0,start_of_frame_d1} <= {2'b00};
        end else begin
            start_of_frame_d0 <= start_of_frame;
            start_of_frame_d1 <= start_of_frame_d0;
        end
    end


    // 仿真时初始化RAM (仅用于仿真)
    integer i;
    initial begin
        for (i = 0; i < CODEWORD_SIZE_IN_32; i = i+1) begin
            RAM0[i] = 32'd0; RAM1[i] = 32'd0; RAM2[i] = 32'd0; RAM3[i] = 32'd0;
            RAM4[i] = 32'd0; RAM5[i] = 32'd0; RAM6[i] = 32'd0; RAM7[i] = 32'd0;
        end
    end

    // 写指针：每个 block 独立
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] ptr_b0;
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] ptr_b1;
    reg [2:0] wr_ram_sel;
    reg block0_full, block1_full;
    // tready 仅当至少有一个 block 未满才接受数据
    assign s_axis_tready = !(block0_full && block1_full);

 //  ------------------写入逻辑(按行写入)-------------------------
    // always @(posedge clk or posedge rst) begin
    //     if(rst) begin
    //         ptr_b0 <= 'd0;
    //         ptr_b1 <= 'd0;
    //         block0_full <= 0;
    //         block1_full <= 0;
    //         wr_ram_sel <= 'd0;
    //     end else if(s_axis_tvalid && s_axis_tready) begin
    //         // if(!block0_full)begin
    //         //     if(wr_ram_sel <= 3'd3)begin
    //         //         if(ptr_b0 == CODEWORD_SIZE_IN_32-1)begin
    //         //             ptr_b0 <= 'd0;
    //         //             if(wr_ram_sel == 'd3)begin
    //         //                 block0_full <= 1;
    //         //                 wr_ram_sel <= 'd4;
    //         //             end else begin
    //         //                 wr_ram_sel <= wr_ram_sel + 1;
    //         //             end
    //         //         end else begin
    //         //             ptr_b0 <= ptr_b0 + 1;
    //         //         end
    //         //     end 
    //         //     else if(!block1_full) begin
    //         //         if(ptr_b1 == CODEWORD_SIZE_IN_32 - 1)begin
    //         //             ptr_b1 <= 0;
    //         //             if(wr_ram_sel == 'd7)begin
    //         //                 block1_full <= 1;
    //         //                 wr_ram_sel <= 'd0;
    //         //             end else begin
    //         //                 wr_ram_sel <= 'd4;
    //         //             end 
    //         //         end else begin
    //         //             ptr_b1 <= ptr_b1 + 1;
    //         //         end
    //         //     end
    //         // end 

    //         if(!block0_full)begin   //===== 写 block0 =====
    //             if(ptr_b0 == CODEWORD_SIZE_IN_32 - 1)begin
    //                 ptr_b0 <= 'd0;
    //                 if(wr_ram_sel == 3'd3)begin
    //                     wr_ram_sel <= 3'd4; //写满block0--跳转到block1
    //                     block0_full <= 1;
    //                 end else begin
    //                     wr_ram_sel <= wr_ram_sel + 1;
    //                 end
    //             end else begin
    //                 ptr_b0 <= ptr_b0 + 1;
    //             end
    //         end 



    //         else if(!block1_full)begin// ===== 写 block1 =====
    //             if(ptr_b1 == CODEWORD_SIZE_IN_32 - 1)begin
    //                 ptr_b1 <= 'd0;
    //                 if(wr_ram_sel == 3'd7)begin
    //                     wr_ram_sel <= 'd0; //写满block1--跳转到block0
    //                     block1_full <= 1;
    //                 end else begin
    //                     wr_ram_sel <= wr_ram_sel + 1;
    //                 end
    //             end else begin
    //                 ptr_b1 <= ptr_b1 + 1;
    //             end
    //         end
    //         // else begin
                
    //         // end
    //     end
    // end
//  ------------------写入逻辑(按行写入)-------------------------
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ptr_b0 <= 'd0;
            ptr_b1 <= 'd0;
            block0_full <= 0;
            block1_full <= 0;
            wr_ram_sel <= 'd0;
        end 
        // 关键修改1：将 start_of_frame 作为高优先级事件，不受 tvalid/tready 影响
        else if(start_of_frame_d1) begin 
            // 关键修改2：复位所有的写指针，确保从头开始
            wr_ram_sel <= 'd0;
            ptr_b0 <= 'd0;
            ptr_b1 <= 'd0;
        end 
        // 关键修改3：仅在数据传输时，才执行指针递增逻辑
        else if(s_axis_tvalid && s_axis_tready) begin
            if(!block0_full)begin    //===== 写 block0 =====
                if(ptr_b0 == CODEWORD_SIZE_IN_32 - 1)begin
                    ptr_b0 <= 'd0;
                    if(wr_ram_sel == 3'd3)begin
                        wr_ram_sel <= 3'd4; //写满block0--跳转到block1
                        block0_full <= 1;
                    end else begin
                        wr_ram_sel <= wr_ram_sel + 1;
                    end
                end else begin
                    ptr_b0 <= ptr_b0 + 1;
                end
            end 
            else if(!block1_full)begin// ===== 写 block1 =====
                if(ptr_b1 == CODEWORD_SIZE_IN_32 - 1)begin
                    ptr_b1 <= 'd0;
                    if(wr_ram_sel == 3'd7)begin
                        wr_ram_sel <= 'd0; //写满block1--跳转到block0
                        block1_full <= 1;
                    end else begin
                        wr_ram_sel <= wr_ram_sel + 1;
                    end
                end else begin
                    ptr_b1 <= ptr_b1 + 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if(s_axis_tvalid && s_axis_tready)begin        
            case(wr_ram_sel)
                'd0: RAM0[ptr_b0] <= s_axis_tdata;
                'd1: RAM1[ptr_b0] <= s_axis_tdata; 
                'd2: RAM2[ptr_b0] <= s_axis_tdata; 
                'd3: RAM3[ptr_b0] <= s_axis_tdata; 
                'd4: RAM4[ptr_b1] <= s_axis_tdata; 
                'd5: RAM5[ptr_b1] <= s_axis_tdata; 
                'd6: RAM6[ptr_b1] <= s_axis_tdata;
                'd7: RAM7[ptr_b1] <= s_axis_tdata; 
            endcase
        end
    end

 //  ------------------读出逻辑(按列读出)-------------------------
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_ptr_b0;
    reg [$clog2(CODEWORD_SIZE_IN_32)-1:0] rd_ptr_b1;
    reg [2:0] rd_ram_sel;
    reg rd_active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr_b0 <= 0;
            rd_ptr_b1 <= 0;
            rd_ram_sel <= 0;
            rd_active <= 0;
            end else if (rd_active && m_axis_tready) begin
            if(rd_ram_sel == 3'd3)begin
                rd_ram_sel <= 'd0;
                if(rd_ptr_b0 == CODEWORD_SIZE_IN_32 - 1)begin
                    rd_ram_sel <= 'd4;
                    rd_ptr_b0 <= 0;
                    block0_full <= 0;
                end else begin
                    rd_ptr_b0 <= rd_ptr_b0 + 1;
                end
            end
            else if(rd_ram_sel == 3'd7)begin
                rd_ram_sel <= 3'd4;
                if(rd_ptr_b1 == CODEWORD_SIZE_IN_32 - 1)begin
                    rd_ram_sel <= 3'd0;
                    rd_ptr_b1 <= 'd0;
                    block1_full <= 0;
                    rd_active <= 0;
                end else begin
                    rd_ptr_b1 <= rd_ptr_b1 + 1;
                end 
            end else begin
                rd_ram_sel <= rd_ram_sel + 1;
            end

        end else if (!rd_active && (block0_full || block1_full)) begin
            rd_active <= 1'b1; // 有数据就开始读
        end
    end

    // 输出数据
    always @(posedge clk or posedge rst) begin
        if(rst)begin
            m_axis_tdata <= 0;
        end else if(rd_active && m_axis_tready)begin
            case(rd_ram_sel)
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

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            m_axis_tvalid <= 0;
        end else begin
            m_axis_tvalid <= rd_active;
        end
    end

endmodule