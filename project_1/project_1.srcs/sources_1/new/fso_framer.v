`timescale 1ns / 1ps

module fso_framer #(
    parameter integer W             = 32,  // 数据宽度
    parameter integer PAYLOAD_WORDS = 16   // 每帧 payload 的 word 数
)(
    input                       clk,
    input                       rst_n,

    // 上游 payload 输入
    input       [W-1:0]         i_payload_data,
    input                       i_payload_valid,
    input                       i_block_start_word, //交织块中第一个字
    output reg                  o_payload_ready,   // framer 需要数据时拉高

    // 输出到 GTH TX
    output reg [W-1:0]          o_tx_data,
    output reg                  o_tx_valid,

    // 帧序号
    output reg [15:0]           o_frame_index
);

    // 固定前导码（64bit，分成两个 32bit word）
    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    // 状态机定义
    localparam [2:0] S_IDLE         = 3'd0;
    localparam [2:0] S_PREAMBLE_HI  = 3'd1;
    localparam [2:0] S_PREAMBLE_LO  = 3'd2;
    localparam [2:0] S_HEADER       = 3'd3;
    localparam [2:0] S_PAYLOAD      = 3'd4;

    reg [2:0]  state;
    reg [15:0] frame_index;
    reg [15:0] payload_cnt;

    reg [15:0] block_id;        
    reg [15:0] frame_in_block;  // 块内帧号

    reg        frame_has_block_start;

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            frame_index   <= 16'd0;
            payload_cnt   <= 16'd0;
            o_tx_data     <= {W{1'b0}};
            o_tx_valid    <= 1'b0;
            o_payload_ready <= 1'b0;
            o_frame_index <= 16'd0;
            block_id       <= 16'd0;
            frame_in_block <= 16'd0;
            frame_has_block_start <= 1'b0;
        end else begin
            o_tx_valid    <= 1'b0;
            o_payload_ready <= 1'b0;

            case (state)
                //----------------------------------------------------------
                S_IDLE: begin
                    state <= S_PREAMBLE_HI;
                end

                //----------------------------------------------------------
                S_PREAMBLE_HI: begin
                    o_tx_data  <= PREAMBLE_HI;
                    o_tx_valid <= 1'b1;
                    state      <= S_PREAMBLE_LO;
                end

                //----------------------------------------------------------
                S_PREAMBLE_LO: begin
                    o_tx_data  <= PREAMBLE_LO;
                    o_tx_valid <= 1'b1;
                    state      <= S_HEADER;
                end

                //----------------------------------------------------------
                S_HEADER: begin
                    o_tx_data    <= {block_id , frame_in_block}; //添加块编号， 块内帧编号
                    o_tx_valid   <= 1'b1;
                    o_frame_index <= frame_index;                 //全局帧号
                    // 准备进入 PAYLOAD
                    payload_cnt  <= 16'd0;
                    frame_has_block_start <= 1'b0;   // 本帧的标志清零
                    state        <= S_PAYLOAD;
                end

                //----------------------------------------------------------
                S_PAYLOAD: begin
                    o_payload_ready <= 1'b1;

                    if (i_payload_valid) begin
                        o_tx_data  <= i_payload_data;
                        o_tx_valid <= 1'b1;

                        // 只要这一帧 payload 里见过一次块起始，就记下来
                        if (i_block_start_word)
                            frame_has_block_start <= 1'b1;

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            // ====== 帧结束  更新 block_id / frame_in_block ======
                            frame_index <= frame_index + 1'b1;  // 全局帧号照旧

                            if (frame_has_block_start) begin// 这一帧 payload 内含交织块起始符
                                block_id       <= block_id + 1'b1;   // 新块号
                                frame_in_block <= 16'd0;             // 新块内的第0帧
                            end else begin
                                // 同一个交织块内的后续帧
                                frame_in_block <= frame_in_block + 1'b1;
                            end
                             o_payload_ready <= 1'b0;
                            payload_cnt <= 16'd0;
                            state       <= S_PREAMBLE_HI;
                        end else begin
                            payload_cnt <= payload_cnt + 1'b1;
                        end
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule