// 
// 同步头检测模块
// 通过fifo缓冲后的数据检测到同步头
// 连续读出一个码字
module DeSync(
    input wire          rst,
    input wire          core_clk,
    input wire [31:0]   data_i,
    input wire          data_valid_i,

    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    output wire         m_axis_output_tlast,
    input wire          m_axis_output_tready
);

    parameter [31:0] SYNC_MARKER  = 32'h1ACFFC1D;
    parameter        CODEWORD_LEN = 255;

    // --- FSM State Definition ---
    localparam S_SEARCH = 2'd0;
    localparam S_WAIT     = 2'd1;
    localparam S_PASS   = 2'd2;

    // --- Internal Signals ---
    reg [1:0]  state;
    reg [31:0] shift_reg;
    reg [7:0]  byte_cnt;
    wire       sync_match = (shift_reg == SYNC_MARKER);
    reg rst_sync_detector_r1, rst_sync_detector_r2;
    wire rst_sync_dector;
    // --- FIFO Interface Signals ---
    wire [7:0] fifo_dout_8b;
    wire       fifo_empty;
    wire       fifo_full;
    wire       fifo_wr_rst_busy;
    wire       fifo_rd_rst_busy;
    wire       fifo_rd_en;
    wire       fifo_can_read = !fifo_empty && !fifo_rd_rst_busy;
    reg [7:0] tdata_reg;
    reg       tvalid_reg;

    assign m_axis_output_tdata =  (state == S_PASS) ? fifo_dout_8b_r : 'd0;
    assign m_axis_output_tvalid = (state == S_PASS) ? fifo_rd_en_r : 0;
    assign m_axis_output_tlast = (byte_cnt == CODEWORD_LEN) && fifo_rd_en_r; // tlast也应与tvalid同步

    // 为全局rst生成同步复位信号
    always @(posedge core_clk or posedge rst) begin
        if (rst) {rst_sync_detector_r1, rst_sync_detector_r2} <= 2'b11;
        else     {rst_sync_detector_r1, rst_sync_detector_r2} <= {1'b0, rst_sync_detector_r1};
    end
    assign rst_sync_dector = rst_sync_detector_r2;

    // 实例化FIFO
    fifo_32w_8r fifo_inst (
        .srst           (rst_sync_dector),
        .wr_clk         (core_clk),
        .rd_clk         (core_clk),
        .din            (data_i),
        .wr_en          (data_valid_i),
        .full           (fifo_full),
        .wr_rst_busy    (fifo_wr_rst_busy),
        .dout           (fifo_dout_8b),
        .rd_en          (fifo_rd_en),
        .empty          (fifo_empty),
        .rd_rst_busy    (fifo_rd_rst_busy)
    );
    
    // 1. 在搜索状态，只要FIFO有数据就读
    // 2. 在输出状态，只有当输出寄存器为空(tvalid_reg=0)或已被下游接收(tready=1)时，才从FIFO加载新数据
    assign fifo_rd_en = (state == S_SEARCH && fifo_can_read) ||
                        (state == S_PASS && fifo_can_read && (!tvalid_reg || m_axis_output_tready));

    reg byte_cnt_en;
    reg [7:0] fifo_dout_8b_r;
    reg fifo_rd_en_r;
    always @(posedge core_clk or posedge rst) begin
        if(rst) begin
            fifo_dout_8b_r <= 0;
        end else if(fifo_rd_en) begin
            fifo_dout_8b_r <= fifo_dout_8b;
        end
    end

    always @(posedge core_clk or posedge rst) begin
        if(rst) begin
            fifo_rd_en_r <= 0;
        end else begin
            fifo_rd_en_r <= fifo_rd_en;
        end
    end

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            state       <= S_SEARCH;
            shift_reg   <= 32'b0;
            byte_cnt    <= 8'd0;
            tvalid_reg  <= 1'b0;
            tdata_reg   <= 8'd0;
            byte_cnt_en <= 0;
        end else begin
            // 更新移位寄存器
            if (fifo_rd_en) begin
                shift_reg <= {shift_reg[23:0], fifo_dout_8b};
            end

            if (state == S_PASS) begin
                // 当下游接收了数据，或者我们准备从FIFO加载新数据时
                if (m_axis_output_tready) begin
                    tvalid_reg <= fifo_rd_en_r; // 如果FIFO有数据，则下一拍tvalid有效
                    tdata_reg  <= fifo_dout_8b_r;  // 加载FIFO的数据
                end
            end else begin
                tvalid_reg <= 1'b0; // 在搜索状态，输出无效
            end

            // 更新状态和计数器
            case(state)
                S_SEARCH: begin
                    // 当移位寄存器匹配成功，且当前FIFO读操作正在将最后一个匹配字节移入时
                    if (sync_match && fifo_rd_en) begin
                        state <= S_PASS;
                        byte_cnt <= 1; // 准备发送第一个字节
                    end
                end
                S_PASS: begin
                    // 仅当成功传输一个字节时，才更新计数器 对读出数据计数
                    if (fifo_rd_en_r && m_axis_output_tready) begin
                        if (byte_cnt == CODEWORD_LEN) begin
                            state <= S_SEARCH;
                            byte_cnt <= 0; // 完成一包，复位计数器
                            byte_cnt_en <= 0;
                        end else begin
                            byte_cnt <= byte_cnt + 1;
                            byte_cnt_en <= 1;
                        end
                    end else begin
                        byte_cnt_en <= 0;
                    end
                end
            endcase
        end
    end



endmodule