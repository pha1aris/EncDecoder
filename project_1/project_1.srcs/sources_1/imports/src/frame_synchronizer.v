`timescale 1ns/1ps

module frame_synchronizer #(
    parameter [63:0]  SYNC_MARKER        = 64'hB1699558_A53333A8,
    parameter integer PAYLOAD_SIZE_WORDS = 16
    // 冗余参数已移除
)(
    input  wire        clk,
    input  wire        rst_n,

    // 输入 AXI-Stream
    input  wire [31:0] framed_data_in,
    input  wire        framed_valid_in,
    output wire        framed_ready_out,

    // 输出 AXI-Stream
    output wire [31:0] payload_data_out,
    output wire        payload_valid_out,
    input  wire        payload_ready_in,

    // 帧开始标志
    output reg         start_of_frame_o
);

    // =================================================================
    // 1. FIFO 接口与实例化
    // =================================================================
    wire [31:0] fifo_dout;
    wire        fifo_full;
    wire        fifo_empty;
    reg         fifo_rd_en;

    assign framed_ready_out = ~fifo_full;

    sync_gen_fifo fifo_inst (
        .clk(clk),
        .srst(~rst_n),
        .din(framed_data_in),
        .wr_en(framed_valid_in && framed_ready_out), // 仅在握手成功时写入
        .rd_en(fifo_rd_en),
        .dout(fifo_dout),
        .full(fifo_full),
        .empty(fifo_empty),
        .wr_rst_busy(), // 悬空不用的输出
        .rd_rst_busy()  // 悬空不用的输出
    );

    // =================================================================
    // 2. 状态机定义
    // =================================================================
    localparam S_HUNT_SYNC      = 3'd0;
    localparam S_GET_HEADER_SEQ = 3'd1; // 细化状态，更清晰
    localparam S_GET_HEADER_CRC = 3'd2;
    localparam S_VALIDATE_CRC   = 3'd3;
    localparam S_STREAM_PAYLOAD = 3'd4;

    reg [2:0] current_state, next_state;

    // =================================================================
    // 3. 核心逻辑信号定义
    // =================================================================
    // --- 同步头检测 ---
    reg [63:0] sync_shift_reg;
    wire       sync_match = (sync_shift_reg == SYNC_MARKER);

    // --- Header 捕获 ---
    reg [31:0] received_seq_num_reg;
    reg [15:0] received_crc_reg;

    // --- CRC 校验 ---
    reg [1:0]   crc_calc_step;
    wire [15:0] calculated_crc;
    wire        crc_ok;
    wire        crc_clr;
    wire        crc_en;
    wire [15:0] crc_data_in;

    // --- Payload 计数 ---
    reg [$clog2(PAYLOAD_SIZE_WORDS):0] payload_cnt; // 位宽自动计算

    // --- 握手信号 ---
    wire fifo_fire      = fifo_rd_en && !fifo_empty;
    wire payload_fire   = payload_valid_out && payload_ready_in;

    // =================================================================
    // 4. 状态机时序逻辑 (单一职责：只更新状态)
    // =================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S_HUNT_SYNC;
        else
            current_state <= next_state;
    end

    // =================================================================
    // 5. 数据通路时序逻辑 (根据当前状态更新寄存器)
    // =================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_shift_reg       <= 64'd0;
            received_seq_num_reg <= 32'd0;
            received_crc_reg     <= 16'd0;
            payload_cnt          <= 'd0;
            start_of_frame_o     <= 1'b0;
            crc_calc_step        <= 'd0;
        end else begin
            // 默认关闭 start_of_frame_o，只在特定周期拉高
            start_of_frame_o <= 1'b0;

            // 根据当前状态(current_state)进行操作
            case (current_state)
                S_HUNT_SYNC: begin
                    if (fifo_fire)
                        sync_shift_reg <= {sync_shift_reg[31:0], fifo_dout};
                end
                
                S_GET_HEADER_SEQ: begin
                    if (fifo_fire)
                        received_seq_num_reg <= fifo_dout;
                end
                
                S_GET_HEADER_CRC: begin
                    if (fifo_fire)
                        received_crc_reg <= fifo_dout[15:0];
                end

                S_VALIDATE_CRC: begin
                    crc_calc_step <= crc_calc_step + 1;
                    if (next_state == S_STREAM_PAYLOAD) // CRC校验通过的标志
                        start_of_frame_o <= 1'b1;
                end

                S_STREAM_PAYLOAD: begin
                    if (payload_fire)
                        payload_cnt <= payload_cnt + 1;
                    
                    // 当一帧传输完成时，计数器清零
                    if (payload_cnt == PAYLOAD_SIZE_WORDS && payload_fire)
                        payload_cnt <= 'd0;
                end
            endcase
            
            // 如果状态要离开 CRC 校验，则清零计数器
            if (current_state != S_VALIDATE_CRC)
                crc_calc_step <= 'd0;
        end
    end

    // =================================================================
    // 6. 状态机组合逻辑 (计算 next_state 和其他控制信号)
    // =================================================================
    always @(*) begin
        // --- 默认值 ---
        next_state = current_state;
        fifo_rd_en = 1'b0;

        case (current_state)
            S_HUNT_SYNC: begin
                fifo_rd_en = ~fifo_empty; // 持续从FIFO读数据以寻找同步头
                if (sync_match)
                    next_state = S_GET_HEADER_SEQ;
            end
            
            S_GET_HEADER_SEQ: begin
                fifo_rd_en = ~fifo_empty;
                if (fifo_fire)
                    next_state = S_GET_HEADER_CRC;
            end
            
            S_GET_HEADER_CRC: begin
                fifo_rd_en = ~fifo_empty;
                if (fifo_fire)
                    next_state = S_VALIDATE_CRC;
            end
            
            S_VALIDATE_CRC: begin
                // CRC计算需要3个时钟周期：clr(1), en(2), en(3)。第4拍出结果
                if (crc_calc_step == 3) begin
                    if (crc_ok)
                        next_state = S_STREAM_PAYLOAD;
                    else
                        next_state = S_HUNT_SYNC;
                end
            end

            S_STREAM_PAYLOAD: begin
                // 仅当输出端口准备好时才从FIFO读取
                fifo_rd_en = payload_ready_in;
                if (payload_cnt == PAYLOAD_SIZE_WORDS && payload_fire)
                    next_state = S_HUNT_SYNC;
            end
        endcase
    end

    // =================================================================
    // 7. CRC 模块及输出逻辑
    // =================================================================
    assign crc_clr = (current_state == S_VALIDATE_CRC) && (crc_calc_step == 0);
    assign crc_en  = (current_state == S_VALIDATE_CRC) && (crc_calc_step == 1 || crc_calc_step == 2);
    assign crc_data_in = (crc_calc_step == 1) ? received_seq_num_reg[15:0] : 
                                                received_seq_num_reg[31:16];

    crc u_crc (
        .clk(clk),
        .rst_n(rst_n),
        .clr(crc_clr),
        .crc_en(crc_en),
        .data_in(crc_data_in),
        .crc_out(calculated_crc)
    );
    
    // CRC结果在计算开始后的第4个周期稳定，正好在crc_calc_step为3时进行比较
    assign crc_ok = (calculated_crc == received_crc_reg);

    // --- 输出流控逻辑 ---
    // payload_data_out 直接来自FIFO，以减少延迟
    assign payload_data_out  = fifo_dout; 
    // valid信号在STREAM状态且FIFO非空时有效
    assign payload_valid_out = (current_state == S_STREAM_PAYLOAD) && ~fifo_empty;

endmodule