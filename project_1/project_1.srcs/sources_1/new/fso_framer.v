`timescale 1ns / 1ps

module fso_framer #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input                         clk,
    input                         rst_n,

    // 上游 payload 流（32bit）
    input      [W-1:0]            i_payload_data,
    input                         i_payload_valid,
    input                         scrambler_en,
    output reg                    o_payload_ready,

    // 下游 TX 流（32bit）
    input                         i_tx_ready,
    output reg [W-1:0]            o_tx_data,
    output reg                    o_tx_valid,
    output reg [15:0]             o_frame_index
);

    // ------------------------------------------------------------
    // 常量 / 状态定义
    // ------------------------------------------------------------
    localparam [31:0] PREAMBLE_HI   = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO   = 32'hF6AA_EE24;

    localparam [2:0]  S_IDLE        = 3'd0;
    localparam [2:0]  S_PREAMBLE_HI = 3'd1;
    localparam [2:0]  S_PREAMBLE_LO = 3'd2;
    localparam [2:0]  S_HEADER      = 3'd3;
    localparam [2:0]  S_PAYLOAD     = 3'd4;
    localparam [2:0]  S_CRC         = 3'd5;

    reg [2:0]  state;
    reg [15:0] frame_index;
    reg [15:0] payload_cnt;
    reg [15:0] block_id;
    reg [15:0] frame_in_block;

    // ------------------------------------------------------------
    // ready/valid 组合信号
    // ------------------------------------------------------------
    // 下游被 backpressure 时：保持一切寄存器不变
    wire stall = o_tx_valid && !i_tx_ready;

    // 在 PAYLOAD 状态下真正“吃”一个 payload word 的条件
    wire payload_fire = (state == S_PAYLOAD) && i_payload_valid && !stall;

    // ------------------------------------------------------------
    // Scrambler：按 payload_fire 推进，每帧 HEADER 那拍复位
    // ------------------------------------------------------------
    wire         scram_rst;
    wire         scram_step;
    wire [W-1:0] scram_din;
    wire [W-1:0] scram_dout;

    assign scram_din  = i_payload_data;
    assign scram_rst  = (state == S_HEADER) && !stall;         // 发送 HEADER 那拍复位
    assign scram_step = payload_fire && scrambler_en;          // 只在真正吃到 payload 时推进

    scrambler u_scrambler (
        .clk       (clk),
        .rst       (!rst_n),
        .scram_rst (scram_rst),
        .scram_en  (scram_step),
        .data_in   (scram_din),
        .data_out  (scram_dout)
    );

    // ------------------------------------------------------------
    // CRC32：按 payload_fire 计算，每帧 HEADER 那拍复位
    // ------------------------------------------------------------
    wire        crc_en;
    wire        crc_rst_frame;
    wire        crc_rst;
    wire [31:0] crc_din;
    wire [31:0] crc_dout;

    assign crc_en        = payload_fire;                       // 真正接收 payload 的那拍
    assign crc_din       = i_payload_data;                     // 对“原始 payload”做 CRC
    assign crc_rst_frame = (state == S_HEADER) && !stall;      // HEADER 拍复位 CRC
    assign crc_rst       = (~rst_n) | crc_rst_frame;

    crc32 u_crc32 (
        .clk     (clk),
        .rst     (crc_rst),
        .data_in (crc_din),
        .crc_en  (crc_en),
        .crc_out (crc_dout)
    );

    always @(*) begin
        if ((state == S_PAYLOAD) && !stall)
            o_payload_ready = 1'b1;
        else
            o_payload_ready = 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= S_IDLE;
            o_tx_valid     <= 1'b0;
            o_tx_data      <= {W{1'b0}};
            frame_index    <= 16'd0;
            payload_cnt    <= 16'd0;
            o_frame_index  <= 16'd0;
            block_id       <= 16'd0;
            frame_in_block <= 16'd0;
        end else begin
            if (stall) begin
                // 下游不 ready：保持所有寄存器（data/valid/state/counters）
            end else begin
                case (state)
                    //------------------------------------------------
                    // IDLE
                    //------------------------------------------------
                    S_IDLE: begin
                        o_tx_valid <= 1'b0;
                        state      <= S_PREAMBLE_HI;
                    end

                    //------------------------------------------------
                    // PREAMBLE_HI
                    //------------------------------------------------
                    S_PREAMBLE_HI: begin
                        o_tx_data  <= PREAMBLE_HI;
                        o_tx_valid <= 1'b1;
                        state      <= S_PREAMBLE_LO;
                    end

                    //------------------------------------------------
                    // PREAMBLE_LO
                    //------------------------------------------------
                    S_PREAMBLE_LO: begin
                        o_tx_data  <= PREAMBLE_LO;
                        o_tx_valid <= 1'b1;
                        state      <= S_HEADER;
                    end

                    //------------------------------------------------
                    // HEADER：发送 {block_id, frame_in_block}
                    //------------------------------------------------
                    S_HEADER: begin
                        o_tx_data     <= {block_id, frame_in_block};
                        o_tx_valid    <= 1'b1;
                        o_frame_index <= frame_index;
                        payload_cnt   <= 16'd0;   // 为接下来的 payload 做准备
                        state         <= S_PAYLOAD;
                        // 同一拍 scram_rst_frame / crc_rst_frame = 1
                    end

                    //------------------------------------------------
                    // PAYLOAD
                    //------------------------------------------------
                    S_PAYLOAD: begin
                        if (payload_fire) begin
                            o_tx_valid <= 1'b1;
                            o_tx_data  <= scrambler_en ? scram_dout : i_payload_data;

                            if (payload_cnt == PAYLOAD_WORDS - 1) begin
                                payload_cnt <= 16'd0;
                                state       <= S_CRC;   // 最后一个 payload word
                            end else begin
                                payload_cnt <= payload_cnt + 1'b1;
                                state       <= S_PAYLOAD;
                            end
                        end else begin
                            o_tx_valid <= 1'b0;
                        end
                    end

                    //------------------------------------------------
                    // CRC：发送 1 个 32bit CRC 字
                    //------------------------------------------------
                    S_CRC: begin
                        o_tx_data  <= crc_dout;
                        o_tx_valid <= 1'b1;

                        frame_index <= frame_index + 1'b1;

                        if (frame_in_block == FRAMES_PER_BLOCK - 1) begin
                            block_id       <= block_id + 1'b1;
                            frame_in_block <= 16'd0;
                        end else begin
                            frame_in_block <= frame_in_block + 1'b1;
                        end

                        state <= S_PREAMBLE_HI;
                    end

                    default: begin
                        state      <= S_IDLE;
                        o_tx_valid <= 1'b0;
                    end
                endcase
            end
        end
    end

endmodule
