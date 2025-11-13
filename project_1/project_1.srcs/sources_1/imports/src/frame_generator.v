`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: frame_generator_matched (匹配 gth_top 接口版)
//
// Description:
//   发送端同步帧生成模块。
//   - ★ 修改: 匹配 gth_top_simplified.v 的标准接口。
//   - ★ 新增: 32位 framed_data_out 数据输出端口。
//   - ★ 移除: txctrl0_out 和 txctrl1_out 端口。
//   - 在 S_IDLE 状态发送 COMMA (K28.5) 字符。
//   - 输出 GTH 8b/10b 编码器所需的 txctrl2 接口。
//
//////////////////////////////////////////////////////////////////////////////////
module frame_generator #(
    parameter [63:0]  SYNC_MARKER         = 64'hB1699558_A53333A8,
    parameter integer SYNC_REPETITION     = 3, 
    parameter integer PAYLOAD_SIZE_WORDS  = 4,
    
    // 8b/10b GTH 控制参数
    parameter [7:0]   COMMA_CHAR          = 8'hBC,  // K28.5
    parameter         ASM_IS_K_CHAR       = 1'b0,   // 0 = ASM 是 D 码, 1 = K 码
    parameter         TX_EN_COMMA_ALIGN   = 1'b1
)(
    input  wire           clk,
    input  wire           rst_n,

    // Payload AXI-Stream 接口
    input  wire [31:0]    payload_data_in,
    input  wire           payload_valid_in,
    output wire           payload_ready_out,

    // GTH 接口 (下游)
    output wire [31:0]    framed_data_out,  
    output wire [ 7:0]    txctrl2_out,      // ★ 保留: K 字符控制总线
    output wire           framed_valid_out,
    input  wire           framed_ready_in

);

    localparam S_IDLE           = 4'h0;
    localparam S_SEND_SYNC      = 4'h2;
    localparam S_STREAM_PAYLOAD = 4'h4;

    reg [3:0] current_state, next_state;

    reg [$clog2(PAYLOAD_SIZE_WORDS)-1:0] payload_cnt_reg;
    localparam SYNC_CNT_WIDTH = $clog2(SYNC_REPETITION * 2); 
    reg [SYNC_CNT_WIDTH-1:0] sync_cnt_reg; 

    wire transfer_fire = framed_valid_out && framed_ready_in;
    wire payload_fire  = payload_valid_in && payload_ready_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            payload_cnt_reg <= 'd0;
            sync_cnt_reg    <= 'd0;
        end else begin
            if (current_state == S_SEND_SYNC && transfer_fire) begin
                sync_cnt_reg <= sync_cnt_reg + 1;
            end else if (current_state != S_SEND_SYNC) begin
                sync_cnt_reg <= 'd0;
            end
            
            if (current_state == S_STREAM_PAYLOAD && payload_fire) begin
                payload_cnt_reg <= payload_cnt_reg + 1;
            end else if (current_state != S_STREAM_PAYLOAD) begin
                payload_cnt_reg <= 'd0;
            end
        end
    end
    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE: 
                if (payload_valid_in) 
                    next_state = S_SEND_SYNC;
                
            S_SEND_SYNC: 
                if (transfer_fire && (sync_cnt_reg == (SYNC_REPETITION * 2 - 1))) 
                    next_state = S_STREAM_PAYLOAD;
                
            S_STREAM_PAYLOAD: 
                if (payload_fire && (payload_cnt_reg == PAYLOAD_SIZE_WORDS - 1)) 
                    next_state = S_IDLE;
                
            default: 
                next_state = S_IDLE;
        endcase
    end
    
    wire [31:0] data_out_mux;
    assign data_out_mux = 
        (current_state == S_IDLE)           ? {4{COMMA_CHAR}} : 
        (current_state == S_SEND_SYNC)      ? (sync_cnt_reg[0] ? SYNC_MARKER[31:0] : SYNC_MARKER[63:32]) :
        (current_state == S_STREAM_PAYLOAD) ? payload_data_in :
                                              32'b0; 

    assign framed_data_out = data_out_mux;


    // 控制信号 (txctrl2) 生成逻辑
    wire [3:0] txcharisk;
    assign txcharisk = 
        (current_state == S_IDLE)           ? 4'b1111 : 
        (current_state == S_SEND_SYNC)      ? (ASM_IS_K_CHAR ? 4'b1111 : 4'b0000) : 
        (current_state == S_STREAM_PAYLOAD) ? 4'b0000 : 
                                              4'b0000;  

    wire txencommaalign;
    assign txencommaalign = 
        (current_state == S_IDLE) ? TX_EN_COMMA_ALIGN : 1'b0; 

    assign txctrl2_out = {4'b000, txcharisk};

    assign framed_valid_out = (current_state == S_IDLE)            ||
                              (current_state == S_SEND_SYNC)       ||
                              (current_state == S_STREAM_PAYLOAD && payload_valid_in);

    assign payload_ready_out = (current_state == S_STREAM_PAYLOAD) && framed_ready_in;

endmodule
