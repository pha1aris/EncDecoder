`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: frame_generator_final_fixed
//
// Description:
//   最终版帧生成器的修复版本。
//   - 修正了计数器在状态切换时被错误清零的bug。
//   - 优化了计数器逻辑，使其仅在对应状态下更新。
//
//////////////////////////////////////////////////////////////////////////////////
module frame_generator #(
    parameter [63:0]  SYNC_MARKER         = 64'hB1699558_A53333A8,
    parameter integer SYNC_REPETITION     = 1,
    parameter integer PAYLOAD_SIZE_WORDS  = 16
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [31:0]           payload_data_in,
    input  wire                  payload_valid_in,
    output wire                  payload_ready_out,
    output wire [31:0]           framed_data_out,
    output wire                  framed_valid_out,
    input  wire                  framed_ready_in
);

    localparam S_IDLE            = 4'h0;
    localparam S_CRC_CALC        = 4'h1;
    localparam S_SEND_SYNC       = 4'h2;
    localparam S_SEND_HEADER     = 4'h3;
    localparam S_STREAM_PAYLOAD  = 4'h4;

    reg [3:0] current_state, next_state;
    
    reg [31:0] seq_num_reg;
    reg [$clog2(PAYLOAD_SIZE_WORDS)-1:0] payload_cnt_reg;
    reg [2:0]  sync_cnt_reg; // Width needs to count up to 6
    reg [0:0]  header_cnt_reg;
    reg [31:0] latched_seq_num;
    reg [15:0] final_crc_reg;

    wire [15:0] crc_data_in;
    wire        crc_clr;
    wire        crc_en;
    wire [15:0] crc_result_out;
    reg [1:0] crc_calc_step;

    // CRC计算模块 1clock延迟
    crc u_crc ( 
        .clk(clk), 
        .rst_n(rst_n), 
        .clr(crc_clr), 
        .crc_en(crc_en), 
        .data_in(crc_data_in), 
        .crc_out(crc_result_out)
    );

    wire transfer_fire = framed_valid_out && framed_ready_in;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_IDLE;
            final_crc_reg <= 16'h0;
        end else begin
            current_state <= next_state;
            if (crc_calc_step == 3) begin
                final_crc_reg <= crc_result_out;
            end
        end
    end
    
    // --- 计数器时序逻辑 (已修复) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seq_num_reg     <= 32'd0;
            payload_cnt_reg <= 'd0;
            sync_cnt_reg    <= 'd0;
            header_cnt_reg  <= 'd0;
            latched_seq_num <= 32'd0;
        end else begin
            if (current_state == S_IDLE && next_state == S_CRC_CALC) begin
                latched_seq_num <= seq_num_reg;
            end

            // sync_cnt_reg: 只在S_SEND_SYNC状态下更新
            if (current_state == S_SEND_SYNC && transfer_fire) begin
                sync_cnt_reg <= sync_cnt_reg + 1;
            end else if (current_state != S_SEND_SYNC) begin
                sync_cnt_reg <= 'd0;
            end
            
            // header_cnt_reg: 只在S_SEND_HEADER状态下更新
            if (current_state == S_SEND_HEADER && transfer_fire) begin
                header_cnt_reg <= header_cnt_reg + 1;
            end else if (current_state != S_SEND_HEADER) begin
                header_cnt_reg <= 'd0;
            end

            // payload_cnt_reg: 只在S_STREAM_PAYLOAD状态下更新
            if (current_state == S_STREAM_PAYLOAD && payload_valid_in && payload_ready_out) begin
                payload_cnt_reg <= payload_cnt_reg + 1;
            end else if (current_state != S_STREAM_PAYLOAD) begin
                payload_cnt_reg <= 'd0;
            end
            
            // seq_num_reg: 在一帧结束后更新
            if (current_state == S_STREAM_PAYLOAD && payload_valid_in && payload_ready_out && (payload_cnt_reg == PAYLOAD_SIZE_WORDS - 1)) begin
                seq_num_reg <= seq_num_reg + 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) crc_calc_step <= 'd0;
        else if (current_state != S_CRC_CALC) crc_calc_step <= 'd0;
        else crc_calc_step <= crc_calc_step + 1;
    end
    assign crc_clr = (current_state == S_CRC_CALC && crc_calc_step == 0);
    assign crc_en  = (current_state == S_CRC_CALC && (crc_calc_step == 1 || crc_calc_step == 2));
    assign crc_data_in = (crc_calc_step == 1) ? latched_seq_num[15:0] : 
                         (crc_calc_step == 2) ? latched_seq_num[31:16] : 16'h0;
                         
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE:           
            if (payload_valid_in && payload_ready_out) 
            next_state = S_CRC_CALC;
            S_CRC_CALC:       
            if (crc_calc_step == 2) 
            next_state = S_SEND_SYNC;
            S_SEND_SYNC:      
            if (transfer_fire && (sync_cnt_reg == (SYNC_REPETITION * 2 - 1))) 
            next_state = S_SEND_HEADER;
            S_SEND_HEADER:    
            if (transfer_fire && (header_cnt_reg == 1)) 
                next_state = S_STREAM_PAYLOAD;
            S_STREAM_PAYLOAD: 
            if (payload_valid_in && payload_ready_out && (payload_cnt_reg == PAYLOAD_SIZE_WORDS - 1)) 
                next_state = S_IDLE;
            default:          
                next_state = S_IDLE;
        endcase
    end
    
    assign framed_data_out = (current_state == S_SEND_SYNC)      ? (sync_cnt_reg[0] ? SYNC_MARKER[31:0] : SYNC_MARKER[63:32]) :
                             (current_state == S_SEND_HEADER)    ? (header_cnt_reg ? {16'h0000, final_crc_reg} : latched_seq_num) :
                             (current_state == S_STREAM_PAYLOAD) ? payload_data_in :
                             32'b0;

    assign framed_valid_out = (current_state == S_SEND_SYNC)   ||
                              (current_state == S_SEND_HEADER) ||
                              (current_state == S_STREAM_PAYLOAD && payload_valid_in);

    assign payload_ready_out = (current_state == S_IDLE) ||
                           (current_state == S_STREAM_PAYLOAD);


endmodule
