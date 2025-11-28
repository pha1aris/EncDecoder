`timescale 1ns / 1ps

module fso_framer #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input                         clk,
    input                         rst_n,

    input        [W-1:0]          i_payload_data,
    input                         i_payload_valid,
    input                         scrambler_en,
    output reg                    o_payload_ready,

    input                         i_tx_ready,
    output reg   [W-1:0]          o_tx_data,
    output reg                    o_tx_valid,
    output reg   [15:0]           o_frame_index
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;
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

    //============================================================
    // 扰码：只在 PAYLOAD 期间生效
    //============================================================
    wire         scram_rst;
    wire         scram_en;
    wire [W-1:0] scram_din;
    wire [W-1:0] scram_dout;

    assign scram_din = i_payload_data;
    assign scram_rst = (state == S_HEADER) && i_tx_ready;     // 每帧头初始化
    assign scram_en  = (state == S_PAYLOAD) && scrambler_en;  // 只扰 payload

    scrambler u_scrambler (
      .clk       (clk),
      .rst       (!rst_n),
      .scram_rst (scram_rst),
      .scram_en  (scram_en),
      .data_in   (scram_din),
      .data_out  (scram_dout)
    );

    //============================================================
    // CRC32：对 payload 计算一帧的 CRC
    //============================================================
    wire        crc_en;
    wire        crc_rst_frame;
    wire        crc_rst;
    wire [31:0] crc_din;
    wire [31:0] crc_dout;

    reg [8:0] tb_cnt;

    // 1) 只在 PAYLOAD 期间把每个 32bit word 喂给 CRC
    assign crc_en  = (state == S_PAYLOAD) && o_payload_ready && i_payload_valid;
    assign crc_din = i_payload_data;   // 对“原始 payload”做 CRC

    // 2) 每帧头那一拍初始化 CRC（以及全局复位）
    assign crc_rst_frame = (state == S_HEADER) && i_tx_ready;
    assign crc_rst       = (~rst_n) | crc_rst_frame;

    crc32 u_crc32 (
      .clk     (clk),
      .rst     (crc_rst),
      .data_in (crc_din),
      .crc_en  (crc_en),
      .crc_out (crc_dout)
    );

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
            tb_cnt <= 'd0;
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
                        // ★ 同一拍 crc_rst_frame=1，CRC 被初始化为全1
                    end
                end

                //------------------------------------------------
                // PAYLOAD：发送 PAYLOAD_WORDS 个 32bit 数据
                //------------------------------------------------
                S_PAYLOAD: begin
                    if (o_payload_ready && i_payload_valid) begin
                        o_tx_valid <= 1'b1;
                        tb_cnt <= tb_cnt + 1'b1;
                        if (scrambler_en)
                            o_tx_data <= scram_dout;
                        else 
                            o_tx_data <= i_payload_data;

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            // 只负责结束 payload，转去发 CRC
                            payload_cnt <= 16'd0;
                            state       <= S_CRC;
                        end else begin
                            payload_cnt <= payload_cnt + 1'b1;
                        end
                    end
                end


                //------------------------------------------------
                // CRC：发送 1 个 32bit CRC 字
                //------------------------------------------------
                S_CRC: begin
                    if (i_tx_ready) begin
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
                end


                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
