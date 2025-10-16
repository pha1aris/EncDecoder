// 这是一个同步头检测模块
// 在通过FIFO缓冲后的数据中检测同步头
// 并在找到后连续输出一个码字
module DeSync(
    input wire          rst,
    input wire          core_clk,
    
    // --- MODIFICATION 1: 将输入接口修改为AXI-Stream slave接口 ---
    // input wire [31:0]   data_i,
    // input wire          data_valid_i,
    // output wire         fifo_input_rdy,
    input  wire [31:0]  s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    output wire         s_axis_input_tready,
    // --- END of MODIFICATION 1 ---

    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    output wire         m_axis_output_tlast,
    input wire          m_axis_output_tready
);

    parameter [31:0] SYNC_MARKER  = 32'h1ACFFC1D;
    parameter        CODEWORD_LEN = 255;

    // --- FSM State Definition ---
    localparam S_SEARCH = 2'd0;
    localparam S_WAIT   = 2'd1;
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
    
    // --- Output Registers for Backpressure Handling ---
    reg [7:0]  tdata_reg;
    reg        tvalid_reg;
    reg        tlast_reg;

    assign m_axis_output_tdata  = tdata_reg;
    assign m_axis_output_tvalid = tvalid_reg;
    assign m_axis_output_tlast  = tlast_reg;

    // 为全局rst生成同步复位信号
    always @(posedge core_clk or posedge rst) begin
        if (rst) {rst_sync_detector_r1, rst_sync_detector_r2} <= 2'b11;
        else     {rst_sync_detector_r1, rst_sync_detector_r2} <= {1'b0, rst_sync_detector_r1};
    end
    assign rst_sync_dector = rst_sync_detector_r2;

    // 实例化FIFO
    fifo_32w_8r fifo_inst (
        .srst         (rst_sync_dector),
        .wr_clk       (core_clk),
        .rd_clk       (core_clk),
        
        // --- MODIFICATION 2: 更新FIFO的写入逻辑以匹配AXI-Stream握手 ---
        // .din          (data_i),
        // .wr_en        (data_valid_i),
        .din          (s_axis_input_tdata),
        .wr_en        (s_axis_input_tvalid && s_axis_input_tready), // 仅在握手成功时写入FIFO
        // --- END of MODIFICATION 2 ---
        
        .full         (fifo_full),
        .wr_rst_busy  (fifo_wr_rst_busy),
        .dout         (fifo_dout_8b),
        .rd_en        (fifo_rd_en),
        .empty        (fifo_empty),
        .rd_rst_busy  (fifo_rd_rst_busy)
    );
    
    // --- MODIFICATION 1 (continued): 重命名输出ready信号 ---
    // assign fifo_input_rdy = !fifo_full && !fifo_wr_rst_busy;
    assign s_axis_input_tready = !fifo_full && !fifo_wr_rst_busy;
    // --- END of MODIFICATION 1 ---

    // 1. 在搜索状态，只要FIFO有数据就读
    // 2. 在输出状态，只有当输出寄存器为空(tvalid_reg=0)或已被下游接收(tready=1)时，才从FIFO加载新数据
    assign fifo_rd_en = (state == S_SEARCH && fifo_can_read) ||
                        (state == S_PASS && fifo_can_read && (!tvalid_reg || m_axis_output_tready));

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
            state      <= S_SEARCH;
            shift_reg  <= 32'b0;
            byte_cnt   <= 8'd0;
            tvalid_reg <= 1'b0;
            tdata_reg  <= 8'd0;
            tlast_reg  <= 1'b0;
        end else begin
            // 更新移位寄存器
            if (fifo_rd_en) begin
                shift_reg <= {shift_reg[23:0], fifo_dout_8b};
            end

            // 当输出端口空闲 (tvalid=0) 或者下游已接收数据 (tready=1) 时，更新输出寄存器
            if (!tvalid_reg || m_axis_output_tready) begin
                if (state == S_PASS) begin
                    // 从已经寄存了一拍的FIFO信号中加载新数据
                    tvalid_reg <= fifo_rd_en_r;
                    tdata_reg  <= fifo_dout_8b_r;
                    // 同时更新tlast寄存器
                    tlast_reg  <= (byte_cnt == CODEWORD_LEN) && fifo_rd_en_r;
                end else begin
                    // 如果不处于PASS状态，则输出无效
                    tvalid_reg <= 1'b0;
                    tlast_reg  <= 1'b0;
                end
            end
            
            // 更新状态和计数器
            case(state)
                S_SEARCH: begin
                    if (sync_match && fifo_rd_en) begin
                        state <= S_PASS;
                        byte_cnt <= 1;
                    end
                end
                S_PASS: begin
                    // 仅当成功传输一个字节时 (tvalid & tready)，才更新计数器
                    if (tvalid_reg && m_axis_output_tready) begin
                        if (byte_cnt == CODEWORD_LEN) begin
                            state <= S_SEARCH;
                            byte_cnt <= 0;
                        end else begin
                            byte_cnt <= byte_cnt + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule