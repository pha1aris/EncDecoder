`timescale 1ns/1ps

module frame_synchronizer #(
    parameter [63:0]  SYNC_MARKER        = 64'hB1699558_A53333A8,
    parameter integer SYNC_REPETITION    = 3,
    parameter integer PAYLOAD_SIZE_WORDS = 16,
    parameter integer ERROR_THRESHOLD    = 10,  // 先保留不用
    parameter integer VOTE_THRESHOLD     = 2    // 先保留不用
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

    // FIFO信号定义
    wire [31:0] fifo_dout;
    wire        fifo_full;
    wire        fifo_empty;
    wire        fifo_wr_rst_busy;
    wire        fifo_rd_rst_busy;
    reg         fifo_rd_en;
    wire        fifo_wr_en;
    wire        fifo_srst;

    assign fifo_srst = ~rst_n;
    assign fifo_wr_en = framed_valid_in;
    assign framed_ready_out = ~fifo_full;

    // FIFO实例
    sync_gen_fifo fifo_inst (
        .clk(clk),
        .srst(fifo_srst),
        .din(framed_data_in),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .dout(fifo_dout),
        .full(fifo_full),
        .empty(fifo_empty),
        .wr_rst_busy(fifo_wr_rst_busy),
        .rd_rst_busy(fifo_rd_rst_busy)
    );

    // 状态机定义
    localparam S_HUNT_SYNC      = 3'd0;
    localparam S_GET_HEADER     = 3'd1;
    localparam S_VALIDATE_CRC   = 3'd2;
    localparam S_STREAM_PAYLOAD = 3'd3;

    reg [2:0] current_state, next_state;

    // ------------------ 同步头检测 (简化：只做完全匹配) ------------------
    reg [63:0] sync_shift_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sync_shift_reg <= 64'd0;
        else if (fifo_rd_en && !fifo_empty)
            sync_shift_reg <= {sync_shift_reg[31:0], fifo_dout};
    end
    wire sync_match = (sync_shift_reg == SYNC_MARKER);

    // ------------------ Header 捕获 ------------------
    reg [63:0] header_reg;
    reg [1:0]  header_cnt;  // 改为2bit
    wire [31:0] received_seq_num;
    wire [15:0] received_crc;

    assign received_seq_num = header_cnt == 2'd1 ? header_reg[63:32] : received_seq_num;
    assign received_crc     = header_cnt == 2'd1 ? header_reg[15:0] : received_crc;

    // ------------------ CRC 校验 ------------------
    reg [1:0] crc_calc_step;
    wire [15:0] calculated_crc;
    wire crc_ok;
    assign crc_ok = (calculated_crc == received_crc);

    wire crc_clr;
    wire crc_en;
    assign crc_clr = (current_state == S_VALIDATE_CRC && crc_calc_step == 2'd0);
    assign crc_en  = (current_state == S_VALIDATE_CRC && (crc_calc_step == 2'd1 || crc_calc_step == 2'd2));

    // CRC计算模块 1clock延迟
    crc u_crc ( 
        .clk(clk), 
        .rst_n(rst_n), 
        .clr(crc_clr), 
        .crc_en(crc_en), 
        .data_in(received_seq_num), 
        .crc_out(calculated_crc)
    );

    // ------------------ Payload 缓冲 ------------------
    reg [4:0] payload_cnt;
    reg [31:0] payload_data_reg;
    reg payload_valid_reg;

    assign payload_data_out  = payload_data_reg;
    assign payload_valid_out = payload_valid_reg;

    // ------------------ 状态机时序 ------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state    <= S_HUNT_SYNC;
            header_reg       <= 64'd0;
            header_cnt       <= 2'd0;
            crc_calc_step    <= 2'd0;
            payload_cnt      <= 5'd0;
            payload_data_reg <= 32'd0;
            payload_valid_reg<= 1'b0;
            start_of_frame_o <= 1'b0;
            fifo_rd_en       <= 1'b0;
        end else begin
            current_state <= next_state;
            start_of_frame_o <= 1'b0;
            fifo_rd_en <= 1'b0;

            // Header 捕获
            if (current_state == S_GET_HEADER && !fifo_empty) begin
                fifo_rd_en <= 1'b1;
                if (fifo_rd_en) begin
                    header_reg <= {header_reg[31:0], fifo_dout};
                    header_cnt <= header_cnt + 1;
                end
            end else if (current_state != S_GET_HEADER) begin
                header_cnt <= 2'd0;
            end

            // CRC 步骤
            if (current_state == S_VALIDATE_CRC)
                crc_calc_step <= crc_calc_step + 1;
            else
                crc_calc_step <= 0;

            // Payload 流
            if (current_state == S_STREAM_PAYLOAD) begin
                if (!fifo_empty) begin
                    fifo_rd_en <= 1'b1;
                    if (fifo_rd_en) begin
                        payload_data_reg  <= fifo_dout;
                        payload_valid_reg <= 1'b1;
                        payload_cnt       <= payload_cnt + 1;
                    end
                end else if (payload_valid_reg && payload_ready_in) begin
                    payload_valid_reg <= 1'b0;
                end
            end else begin
                payload_valid_reg <= 1'b0;
                payload_cnt       <= 0;
            end

            // 帧开始信号
            if (current_state == S_VALIDATE_CRC && crc_calc_step == 2'd3 && crc_ok)
                start_of_frame_o <= 1'b1;

            // 同步头检测
            if (current_state == S_HUNT_SYNC && !fifo_empty) begin
                fifo_rd_en <= 1'b1;
            end
        end
    end

    // ------------------ 状态机组合逻辑 ------------------
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_HUNT_SYNC: begin
                if (sync_match) next_state = S_GET_HEADER;
            end
            S_GET_HEADER: begin
                if (header_cnt == 2'd1 && !fifo_empty)
                    next_state = S_VALIDATE_CRC;
            end
            S_VALIDATE_CRC: begin
                if (crc_calc_step == 2'd3) begin
                    if (crc_ok)
                        next_state = S_STREAM_PAYLOAD;
                    else
                        next_state = S_HUNT_SYNC;
                end
            end
            S_STREAM_PAYLOAD: begin
                if (payload_cnt == PAYLOAD_SIZE_WORDS && 
                    payload_valid_reg && payload_ready_in)
                    next_state = S_HUNT_SYNC;
            end
        endcase
    end

endmodule
