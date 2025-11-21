`timescale 1ns / 1ps

module fso_framer #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    // 每个交织块所包含的帧数量（要和 INTLV_D/INTLV_N 对上）
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input                         clk,
    input                         rst_n,

    input        [W-1:0]          i_payload_data,
    input                         i_payload_valid,
    input                         i_block_start_word,  // 不再用于计 block，只保留接口

    output reg                    o_payload_ready,

    input                         i_tx_ready,
    output reg   [W-1:0]          o_tx_data,
    output reg                    o_tx_valid,
    output reg   [15:0]           o_frame_index
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    localparam [2:0] S_IDLE        = 3'd0;
    localparam [2:0] S_PREAMBLE_HI = 3'd1;
    localparam [2:0] S_PREAMBLE_LO = 3'd2;
    localparam [2:0] S_HEADER      = 3'd3;
    localparam [2:0] S_PAYLOAD     = 3'd4;

    reg [2:0]  state;
    reg [15:0] frame_index;
    reg [15:0] payload_cnt;
    reg [15:0] block_id;
    reg [15:0] frame_in_block;

    //============================================================
    // o_payload_ready：S_PAYLOAD 且下游 ready 时透传背压
    //============================================================
    always @(*) begin
        if (state == S_PAYLOAD && i_tx_ready)
            o_payload_ready = 1'b1;
        else
            o_payload_ready = 1'b0;
    end

    //============================================================
    // 主状态机
    //============================================================
    always @(posedge clk) begin
        if (!rst_n) begin
            state          <= S_IDLE;
            frame_index    <= 16'd0;
            payload_cnt    <= 16'd0;
            o_tx_data      <= {W{1'b0}};
            o_tx_valid     <= 1'b0;
            o_frame_index  <= 16'd0;
            block_id       <= 16'd0;
            frame_in_block <= 16'd0;
        end else begin
            // 默认不发送
            o_tx_valid <= 1'b0;

            case (state)
                //------------------------------------------------
                // 起始：等待下游 ready 后发第一帧前导
                //------------------------------------------------
                S_IDLE: begin
                    if (i_tx_ready)
                        state <= S_PREAMBLE_HI;
                end

                //------------------------------------------------
                // PREAMBLE_HI
                //------------------------------------------------
                S_PREAMBLE_HI: begin
                    if (i_tx_ready) begin
                        o_tx_data  <= PREAMBLE_HI;
                        o_tx_valid <= 1'b1;
                        state      <= S_PREAMBLE_LO;
                    end
                end

                //------------------------------------------------
                // PREAMBLE_LO
                //------------------------------------------------
                S_PREAMBLE_LO: begin
                    if (i_tx_ready) begin
                        o_tx_data  <= PREAMBLE_LO;
                        o_tx_valid <= 1'b1;
                        state      <= S_HEADER;
                    end
                end

                //------------------------------------------------
                // HEADER：发送 {block_id, frame_in_block}
                //------------------------------------------------
                S_HEADER: begin
                    if (i_tx_ready) begin
                        o_tx_data     <= {block_id, frame_in_block};
                        o_tx_valid    <= 1'b1;
                        o_frame_index <= frame_index;

                        payload_cnt   <= 16'd0;
                        state         <= S_PAYLOAD;
                    end
                end

                //------------------------------------------------
                // PAYLOAD：发送 PAYLOAD_WORDS 个 32bit 数据
                //------------------------------------------------
                S_PAYLOAD: begin
                    // 只有在下游 ready 且 payload_valid 时才消耗一个 word
                    if (o_payload_ready && i_payload_valid) begin
                        o_tx_data  <= i_payload_data;
                        o_tx_valid <= 1'b1;

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            // ===== 一帧结束 =====
                            frame_index <= frame_index + 1'b1;

                            // 帧计数达到块尾：block_id+1，frame_in_block 归 0
                            if (frame_in_block == FRAMES_PER_BLOCK - 1) begin
                                block_id       <= block_id + 1'b1;
                                frame_in_block <= 16'd0;
                            end else begin
                                // 否则只是块内帧号+1
                                frame_in_block <= frame_in_block + 1'b1;
                            end

                            payload_cnt <= 16'd0;
                            state       <= S_PREAMBLE_HI;  // 开始下一帧
                        end else begin
                            payload_cnt <= payload_cnt + 1'b1;
                        end
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
