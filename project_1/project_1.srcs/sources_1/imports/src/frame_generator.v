`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: frame_generator (最终匹配版 - 移除 Header)
//
// Description:
//   发送端同步帧生成模块。
//   - 移除了 CRC 校验逻辑。
//   - ★ 移除了 S_SEND_HEADER 状态，现在帧结构为 [ASM] + [PAYLOAD]
//
//////////////////////////////////////////////////////////////////////////////////
module frame_generator #(
    parameter [63:0]  SYNC_MARKER         = 64'hB1699558_A53333A8,
    // ★ 匹配 192-bit ASM
    parameter integer SYNC_REPETITION     = 3, 
    // ★ 匹配 4 个字的 Payload (16 字节)
    parameter integer PAYLOAD_SIZE_WORDS  = 4
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [31:0]            payload_data_in,
    input  wire                   payload_valid_in,
    output wire                   payload_ready_out,
    output wire [31:0]            framed_data_out,
    output wire                   framed_valid_out,
    input  wire                   framed_ready_in
);

    // ★ 移除了 S_SEND_HEADER 和 S_CRC_CALC
    localparam S_IDLE            = 4'h0;
    localparam S_SEND_SYNC       = 4'h2;
    localparam S_STREAM_PAYLOAD  = 4'h4;

    reg [3:0] current_state, next_state;
    
    // ★ 移除了 seq_num_reg 和 latched_seq_num
    reg [$clog2(PAYLOAD_SIZE_WORDS)-1:0] payload_cnt_reg;
    reg [2:0]  sync_cnt_reg; // Width needs to count up to 6
    // ★ 移除了 header_cnt_reg

    // ★ 移除了 CRC 相关所有信号和模块
    
    wire transfer_fire = framed_valid_out && framed_ready_in;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // --- 计数器时序逻辑 (已修复) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            payload_cnt_reg <= 'd0;
            sync_cnt_reg    <= 'd0;
        end else begin
            // ★ 移除了 S_IDLE 时的锁存

            // sync_cnt_reg: 只在S_SEND_SYNC状态下更新
            if (current_state == S_SEND_SYNC && transfer_fire) begin
                sync_cnt_reg <= sync_cnt_reg + 1;
            end else if (current_state != S_SEND_SYNC) begin
                sync_cnt_reg <= 'd0;
            end
            
            // ★ 移除了 header_cnt_reg 逻辑

            // payload_cnt_reg: 只在S_STREAM_PAYLOAD状态下更新
            if (current_state == S_STREAM_PAYLOAD && payload_valid_in && payload_ready_out) begin
                payload_cnt_reg <= payload_cnt_reg + 1;
            end else if (current_state != S_STREAM_PAYLOAD) begin
                payload_cnt_reg <= 'd0;
            end
            
            // ★ 移除了 seq_num_reg 逻辑
        end
    end

                         
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE:         
            // ★ 修复: 移除 payload_ready_out 检查，防止 S_IDLE 产生反压竞争
            if (payload_valid_in) 
            // ★ 修改: 直接跳转到 SEND_SYNC
            next_state = S_SEND_SYNC;
            S_SEND_SYNC:    
            // ★ 匹配 SYNC_REPETITION
            if (transfer_fire && (sync_cnt_reg == (SYNC_REPETITION * 2 - 1))) 
            // ★ 修改: 跳转到 S_STREAM_PAYLOAD
            next_state = S_STREAM_PAYLOAD;
            // ★ 移除了 S_SEND_HEADER 状态
            S_STREAM_PAYLOAD: 
            // ★ 匹配 PAYLOAD_SIZE_WORDS
            if (payload_valid_in && payload_ready_out && (payload_cnt_reg == PAYLOAD_SIZE_WORDS - 1)) 
                next_state = S_IDLE;
            default:        
                next_state = S_IDLE;
        endcase
    end
    
    assign framed_data_out = (current_state == S_SEND_SYNC)     ? (sync_cnt_reg[0] ? SYNC_MARKER[31:0] : SYNC_MARKER[63:32]) :
                             // ★ 移除了 S_SEND_HEADER 分支
                             (current_state == S_STREAM_PAYLOAD) ? payload_data_in :
                             32'b0;

    assign framed_valid_out = (current_state == S_SEND_SYNC)   ||
                              // ★ 移除了 S_SEND_HEADER 分支
                              (current_state == S_STREAM_PAYLOAD && payload_valid_in);

    // ★ 修复: payload_ready_out 只在 S_STREAM_PAYLOAD 期间有效
    assign payload_ready_out = (current_state == S_STREAM_PAYLOAD);


endmodule

