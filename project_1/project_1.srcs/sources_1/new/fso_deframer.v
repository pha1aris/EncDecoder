`timescale 1ns / 1ps

module fso_deframer #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256 
)(
    input                         clk,
    input                         rst_n,

    input                         i_link_up,
    input        [W-1:0]          i_rx_data,
    input                         i_rx_valid,

    output reg                    o_realign_req,
    output reg                    o_frame_start,    
    output reg   [15:0]           o_frame_index,
    output reg   [15:0]           o_block_id,
    output reg   [15:0]           o_frame_in_block,
    
    // ★ 这个信号现在会与 o_payload_valid 的第一拍严格对齐
    output reg                    o_blk_soft_rst,   

    output reg   [W-1:0]          o_payload_data,
    output reg                    o_payload_valid
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;

    reg [2:0]  state;
    reg [15:0] payload_cnt; 
    
    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;

    reg [15:0] last_block_id;
    reg [15:0] last_frame_in_block;
    reg        block_sync_valid;     
    reg [15:0] frame_index;          

    wire [15:0] rx_block_id       = i_rx_data[31:16];
    wire [15:0] rx_frame_in_block = i_rx_data[15:0];

    reg         pending_rst;            // 暂存复位请求
    reg         block_aligned; // 已经对齐过块标志

    always @(posedge clk) begin
        if (!rst_n) begin
            state                 <= S_WAIT_LINK;
            frame_index           <= 16'd0;
            payload_cnt           <= 16'd0;
            o_payload_data        <= {W{1'b0}};
            o_payload_valid       <= 1'b0;
            o_frame_start         <= 1'b0;
            o_frame_index         <= 16'd0;
            frame_timeout_cnt     <= {FRAME_TIMEOUT_WIDTH{1'b0}};
            o_realign_req         <= 1'b0;
            last_block_id         <= 16'd0;
            last_frame_in_block   <= 16'd0;
            block_sync_valid      <= 1'b0;
            o_block_id            <= 16'd0;
            o_frame_in_block      <= 16'd0;
            o_blk_soft_rst        <= 1'b0;

            pending_rst           <= 1'b0;
            block_aligned         <= 1'b0;
            block_aligned         <= 1'b0;
        end else begin
            // 默认清零
            o_payload_valid <= 1'b0;
            o_frame_start   <= 1'b0;
            o_realign_req   <= 1'b0;
            o_blk_soft_rst  <= 1'b0; // 默认拉低，只有在 payload 第一拍且有请求时拉高

            case (state)
                S_WAIT_LINK: begin
                    payload_cnt       <= 16'd0;
                    frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                    block_sync_valid  <= 1'b0;    
                    pending_rst       <= 1'b0;    // 清除 pending
                    if (i_link_up) state <= S_SEARCH_PREAMBLE1;
                end

                S_SEARCH_PREAMBLE1: begin
                    if (!i_link_up) state <= S_WAIT_LINK;
                    else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_HI) begin
                            state             <= S_SEARCH_PREAMBLE2;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            o_realign_req     <= 1'b1;
                            state             <= S_WAIT_LINK;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                S_SEARCH_PREAMBLE2: begin
                    if (!i_link_up) state <= S_WAIT_LINK;
                    else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_LO) begin
                            state             <= S_RECV_HEADER;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            state             <= S_SEARCH_PREAMBLE1; 
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end
                    end else begin 
                        if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            o_realign_req     <= 1'b1;
                            state             <= S_WAIT_LINK;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                // --------------------------------------------------------
                // S_RECV_HEADER: 只在“确定到块边界”时请求软复位
                // --------------------------------------------------------
                S_RECV_HEADER: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_block_id        <= rx_block_id;
                        o_frame_in_block  <= rx_frame_in_block;
                        o_frame_index     <= frame_index;
                        frame_index       <= frame_index + 1'b1;

// Debug: 输出 block_id 和 frame_in_block
                        $display("Received Header - block_id: %0d, frame_in_block: %0d, state: S_RECV_HEADER", rx_block_id, rx_frame_in_block);
                        if (!block_sync_valid) begin
                            // 第一次看到合法 header：只建立参考坐标，不复位
                            last_block_id       <= rx_block_id;
                            last_frame_in_block <= rx_frame_in_block;
                            block_sync_valid    <= 1'b1;
                            pending_rst         <= 1'b0;
                            // block_aligned 先保持 0，等真正看到“块号跳变”再对齐
                        end else begin
                            // 1) 同一个 block 内
                            if (rx_block_id == last_block_id) begin
                                if (rx_frame_in_block == last_frame_in_block + 1) begin
                                    // 帧连续，一切正常
                                    last_frame_in_block <= rx_frame_in_block;
                                    // pending_rst 不变
                                end else begin
                                    // 同块但 frame_in_block 断裂：说明中间有丢帧/错帧
                                    last_block_id       <= rx_block_id;
                                    last_frame_in_block <= rx_frame_in_block;
                                    pending_rst         <= 1'b1;   // 要求重新对齐交织器
                                    block_aligned       <= 1'b0;   // 之前对齐作废
                                end

                            // 2) 块号连续 +1：进入下一块
                            end else if (rx_block_id == last_block_id + 1) begin
                                last_block_id       <= rx_block_id;
                                last_frame_in_block <= rx_frame_in_block;

                                // ★ 这里是关键：第一次从“未知块相位”进入“下一块”
                                // 可以在这帧 payload 上给反交织器一次软复位，之后视为已经对齐
                                if (!block_aligned) begin
                                    pending_rst   <= 1'b1;   // 这一帧的 payload 第 0 个 word 会打 o_blk_soft_rst
                                    block_aligned <= 1'b1;   // 记住已经对齐过
                                end else begin
                                    pending_rst   <= 1'b0;   // 已经对齐后就不要每块都复位
                                end

                            // 3) 其他情况：block_id 跳变 > 1，认为丢了很多块
                            end else begin
                                last_block_id       <= rx_block_id;
                                last_frame_in_block <= rx_frame_in_block;
                                pending_rst         <= 1'b1;   // 再次要求对齐
                                block_aligned       <= 1'b0;   // 重新进入“未对齐”状态
                            end
                        end

                        payload_cnt       <= 16'd0;
                        frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        state             <= S_RECV_PAYLOAD;
                    end
                end

                // --------------------------------------------------------
                // S_RECV_PAYLOAD: 输出对齐的复位信号
                // --------------------------------------------------------
                S_RECV_PAYLOAD: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_payload_data  <= i_rx_data;
                        o_payload_valid <= 1'b1;

$display("Received Payload Data - o_payload_data: %h, payload_cnt: %0d", i_rx_data, payload_cnt);
                        // ★ 关键修改：在输出第 0 个 Payload Word 时，
                        // 如果有 pending_rst，则拉高 o_blk_soft_rst
                        if (payload_cnt == 0) begin
                            o_frame_start <= 1'b1; 
                            if (pending_rst) begin
                                o_blk_soft_rst <= 1'b1; // 与 valid 和 data 严格对齐
                                pending_rst    <= 1'b0; // 用完清除
                            end
                        end

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            payload_cnt       <= 16'd0;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                            state             <= S_SEARCH_PREAMBLE1;
                        end else begin
                            payload_cnt       <= payload_cnt + 1'b1;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}}; 
                        end
                    end
                end
                
                default: state <= S_WAIT_LINK;
            endcase
        end
    end

    // Simulation Debug: 输出调试信息
    always @(posedge clk) begin
        if (i_rx_valid) begin
            $display("RX Data - i_rx_data: %h, i_rx_valid: %b", i_rx_data, i_rx_valid);
        end
        if (o_payload_valid) begin
            $display("TX Data - o_payload_data: %h, o_payload_valid: %b", o_payload_data, o_payload_valid);
        end
    end

endmodule