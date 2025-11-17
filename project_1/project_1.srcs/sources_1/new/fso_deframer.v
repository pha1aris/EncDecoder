`timescale 1ns / 1ps

// 实现了“二级锁定” + 块级对齐检查
// 1. 帧级：前导 + 超时 + realign_req（bit_aligner）
// 2. 块级：检查 {block_id, frame_in_block} 连续性，给去交织器 blk_soft_rst
// 
module fso_deframer #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    // 必须大于一帧的总长度：
    //   2(Preamble) + 1(Header) + PAYLOAD_WORDS
    parameter integer FRAME_TIMEOUT_MAX = 256 
)(
    input                       clk,
    input                       rst_n,

    input                       i_link_up,     // bit_aligner 的 o_aligned_valid
    input       [W-1:0]         i_rx_data,
    input                       i_rx_valid,

    output reg                  o_realign_req, // 请求 bit_aligner 重新搜索

    output reg                  o_frame_start,   
    output reg [15:0]           o_frame_index,   // 这里改为“本地递增帧号”

    output reg [15:0]           o_block_id,       // 当前帧头的 block_id
    output reg [15:0]           o_frame_in_block, // 当前帧头的 frame_in_block
    output reg                  o_blk_soft_rst,   // 给去交织器的块级软复位

    output reg [W-1:0]          o_payload_data,
    output reg                  o_payload_valid
);

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;

    // 状态机
    localparam [2:0] S_WAIT_LINK        = 3'd0;
    localparam [2:0] S_SEARCH_PREAMBLE1 = 3'd1;
    localparam [2:0] S_SEARCH_PREAMBLE2 = 3'd2;
    localparam [2:0] S_RECV_HEADER      = 3'd3;
    localparam [2:0] S_RECV_PAYLOAD     = 3'd4;

    reg [2:0]  state;
    reg [15:0] payload_cnt; 
    
    // *** 帧超时计数器 ***
    localparam integer FRAME_TIMEOUT_WIDTH = $clog2(FRAME_TIMEOUT_MAX + 1);
    reg [FRAME_TIMEOUT_WIDTH-1:0] frame_timeout_cnt;

    // ==== 新增：块连续性检查相关寄存器 ====
    reg [15:0] last_block_id;
    reg [15:0] last_frame_in_block;
    reg        block_sync_valid;     // 是否已经“锁定”块序列
    reg [15:0] frame_index;          // 本地帧计数，用来驱动 o_frame_index

    // 从当前 header 中“拆”出字段（仅在 S_RECV_HEADER & i_rx_valid 有意义）
    wire [15:0] rx_block_id       = i_rx_data[31:16];
    wire [15:0] rx_frame_in_block = i_rx_data[15:0];

    // （你原来这两个拍延时现在没再用到，可以保留或删掉）
    reg [W-1:0] rx_data_d0, rx_data_d1;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            rx_data_d0 <= 'd0;
            rx_data_d1 <= 'd0;
        end else begin
            rx_data_d0 <= i_rx_data;
            rx_data_d1 <= rx_data_d0;
        end
    end

    // ================== 主状态机 ==================
    always @(posedge clk) begin
        if (!rst_n) begin
            state             <= S_WAIT_LINK;
            payload_cnt       <= 16'd0;
            o_payload_data    <= {W{1'b0}};
            o_payload_valid   <= 1'b0;
            o_frame_start     <= 1'b0;
            o_frame_index     <= 16'd0;
            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
            o_realign_req     <= 1'b0;

            // 块相关
            last_block_id       <= 16'd0;
            last_frame_in_block <= 16'd0;
            block_sync_valid    <= 1'b0;
            o_block_id          <= 16'd0;
            o_frame_in_block    <= 16'd0;
            o_blk_soft_rst      <= 1'b0;
            frame_index         <= 16'd0;
        end else begin
            // 默认清零
            o_payload_valid   <= 1'b0;
            o_frame_start     <= 1'b0;
            o_realign_req     <= 1'b0;
            o_blk_soft_rst    <= 1'b0;

            case (state)
                //----------------------------------------------------------
                S_WAIT_LINK: begin
                    payload_cnt       <= 16'd0;
                    frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                    block_sync_valid  <= 1'b0;    // 重新等块同步
                    // 也可以在这里选择是否清 frame_index
                    // frame_index       <= 16'd0;

                    if (i_link_up) begin
                        state <= S_SEARCH_PREAMBLE1;
                    end
                end

                //----------------------------------------------------------
                // 寻找 PREAMBLE_HI (带超时)
                //----------------------------------------------------------
                S_SEARCH_PREAMBLE1: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_HI) begin
                            state             <= S_SEARCH_PREAMBLE2;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}}; // 找到，清零超时
                        
                        end else if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin
                            // *** 核心：假锁定 or 数据完全乱掉 ***
                            o_realign_req     <= 1'b1;   // 发送重同步请求
                            state             <= S_WAIT_LINK; // 返回等待链路 (bit_aligner 会复位)
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        
                        end else begin
                            // 继续等待，超时计数
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                //----------------------------------------------------------
                // 验证下一 word 是否 PREAMBLE_LO（也可加入超时）
                //----------------------------------------------------------
                S_SEARCH_PREAMBLE2: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        if (i_rx_data == PREAMBLE_LO) begin
                            state             <= S_RECV_HEADER;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            // 不匹配(说明 PREAMBLE_HI 是假警报), 回去重新找 HI
                            state             <= S_SEARCH_PREAMBLE1; 
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end
                    end else begin // (超时逻辑)
                        if (frame_timeout_cnt == FRAME_TIMEOUT_MAX) begin //若超时发送反馈重对齐
                            o_realign_req     <= 1'b1;
                            state             <= S_WAIT_LINK;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        end else begin
                            frame_timeout_cnt <= frame_timeout_cnt + 1'b1;
                        end
                    end
                end

                //----------------------------------------------------------
                // 读取 HEADER：解析 {block_id, frame_in_block}
                //----------------------------------------------------------
                S_RECV_HEADER: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_block_id       <= rx_block_id;
                        o_frame_in_block <= rx_frame_in_block;

                        // 帧计数
                        o_frame_index    <= frame_index;
                        frame_index      <= frame_index + 1'b1;

                        // ====== 块连续性检查逻辑 ======
                        if (!block_sync_valid) begin
                            // 第一次看到 header 还未锁定
                            last_block_id       <= rx_block_id;
                            last_frame_in_block <= rx_frame_in_block;
                            block_sync_valid    <= 1'b1;

                            // 通知去交织器：从当前块重新开始写
                            o_blk_soft_rst      <= 1'b1;

                        end else begin
                            // 已经有上一次的块/帧信息，开始检查
                            if (rx_block_id == last_block_id) begin
                                // 同一个 block 内
                                if (rx_frame_in_block == last_frame_in_block + 1) begin // 正常：块内帧号 +1
                                    last_frame_in_block <= rx_frame_in_block;
                                end else begin      // 块内帧号跳变/回退 - 认为前面的交织块不再可靠 重新确认块边界
                                    last_block_id       <= rx_block_id;
                                    last_frame_in_block <= rx_frame_in_block;
                                    o_blk_soft_rst      <= 1'b1;
                                end

                            end else if (rx_block_id == last_block_id + 1) begin
                                // 块号 +1：正常的“下一块”
                                // 理想情况：rx_frame_in_block == 0
                                last_block_id       <= rx_block_id;
                                last_frame_in_block <= rx_frame_in_block;
                                // 不管 frame_in_block 是不是 0，都通知去交织器：
                                // 当前块之前写的内容作废，从这个新块重新开始
                                o_blk_soft_rst      <= 1'b1;

                            end else begin  // 块号大跳：说明中间丢了若干块/帧 → 软复位
                                last_block_id       <= rx_block_id;
                                last_frame_in_block <= rx_frame_in_block;
                                o_blk_soft_rst      <= 1'b1;
                            end
                        end

                        // 准备收 payload
                        payload_cnt       <= 16'd0;
                        frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                        state             <= S_RECV_PAYLOAD;
                    end
                end

                //----------------------------------------------------------
                // 接收 PAYLOAD
                //----------------------------------------------------------
                S_RECV_PAYLOAD: begin
                    if (!i_link_up) begin
                        state <= S_WAIT_LINK;
                    end else if (i_rx_valid) begin
                        o_payload_data  <= i_rx_data;
                        o_payload_valid <= 1'b1;

                        if (payload_cnt == 0) begin
                            o_frame_start <= 1'b1; 
                        end

                        if (payload_cnt == PAYLOAD_WORDS - 1) begin
                            // 一帧结束，回去找下一帧前导
                            payload_cnt       <= 16'd0;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}};
                            state             <= S_SEARCH_PREAMBLE1;
                        end else begin
                            payload_cnt       <= payload_cnt + 1'b1;
                            frame_timeout_cnt <= {FRAME_TIMEOUT_WIDTH{1'b0}}; // 正常收 payload 时不计超时
                        end
                    end
                end
                
                default: begin
                    state <= S_WAIT_LINK;
                end
            endcase
        end
    end

endmodule
