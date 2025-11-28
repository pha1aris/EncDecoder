`timescale 1ns / 1ps

module bit_aligner_gth #(
    parameter integer W                 = 32,
    // 工业级参数调整
    parameter integer VERIFY_CNT_MAX    = 4,    // 连续匹配 4 次才锁 (防假锁)
    parameter integer MISS_CNT_MAX      = 10,   // 连续错 10 次才失锁 (迟滞容错)
    parameter integer SLIDE_COOLDOWN    = 32,   // GTH 物理层滑动需要的等待周期 (通常 > 32)
    parameter integer ERR_TH            = 2,    // 汉明距离容错 (2 bit)
    parameter integer SCAN_WINDOW       = 256   // 盲搜窗口 (大于最大帧长)
)(
    input  wire          clk,
    input  wire          rst_n,
    input  wire          rx_reset_done,
    input  wire          rx_cdr_stable,
    
    input  wire [W-1:0]  i_rx_data,
    input  wire          i_rx_valid,
    
    // input wire i_realign_req, // 工业级设计通常由本模块自行判断失锁，不需要外部请求
    
    output reg           o_rxslide,
    output wire          o_aligned_valid,
    output wire          o_bit_locked,
    output reg  [W-1:0]  o_data_aligned
);

    localparam [W-1:0] ALIGN_WORD = 32'hEB94_BDA3;

    // ---------------------------------------------------------
    // 工业级状态机定义 (LpGBT Style)
    // ---------------------------------------------------------
    localparam [2:0] S_IDLE     = 3'd0; // 等待复位
    localparam [2:0] S_HUNT     = 3'd1; // 盲搜模式 (Scan)
    localparam [2:0] S_SLIDE    = 3'd2; // 执行滑动动作
    localparam [2:0] S_COOLDOWN = 3'd3; // 等待 GTH 稳定
    localparam [2:0] S_VERIFY   = 3'd4; // 验证模式 (Pre-Lock)
    localparam [2:0] S_LOCKED   = 3'd5; // 锁定模式 (正常工作)

    reg [2:0]  state;
    reg [15:0] scan_cnt;    // 搜索窗口计数
    reg [7:0]  wait_cnt;    // 冷却计数
    reg [3:0]  match_cnt;   // 连续匹配计数
    reg [3:0]  miss_cnt;    // 连续丢失计数 (迟滞)
    reg        locked_reg;

    assign o_bit_locked = locked_reg;

    // ---------------------------------------------------------
    // 汉明距离匹配逻辑
    // ---------------------------------------------------------
    function [5:0] popcount;
        input [W-1:0] v;
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < W; i = i + 1)
                popcount = popcount + v[i];
        end
    endfunction

    wire [W-1:0] diff       = i_rx_data ^ ALIGN_WORD;
    wire [5:0]   err_bits   = popcount(diff);
    wire         header_match = i_rx_valid && (err_bits <= ERR_TH);

    // ---------------------------------------------------------
    // 输出数据打拍 (简单的直通，锁定时有效)
    // ---------------------------------------------------------
    assign o_aligned_valid = i_rx_valid && locked_reg;
    
    always @(posedge clk) begin
        if (i_rx_valid) o_data_aligned <= i_rx_data;
    end

    // ---------------------------------------------------------
    // 主状态机 (工业级优化版)
    // ---------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= S_IDLE;
            o_rxslide   <= 1'b0;
            locked_reg  <= 1'b0;
            scan_cnt    <= 0;
            wait_cnt    <= 0;
            match_cnt   <= 0;
            miss_cnt    <= 0;
        end else begin
            // 全局复位条件检查
            if (!rx_cdr_stable || !rx_reset_done) begin
                state       <= S_IDLE;
                o_rxslide   <= 1'b0;
                locked_reg  <= 1'b0;
            end else begin
                
                // 默认拉低脉冲信号
                o_rxslide <= 1'b0;

                case (state)
                    // 1. IDLE: 等待 GTH 物理层就绪
                    S_IDLE: begin
                        locked_reg <= 1'b0;
                        if (rx_cdr_stable && rx_reset_done) 
                            state <= S_HUNT;
                    end

                    // 2. HUNT: 盲搜模式 (Scan Window)
                    // 在这个窗口内，只要见到一次前导码，就认为相位可能对了
                    S_HUNT: begin
                        locked_reg <= 1'b0;
                        
                        if (header_match) begin
                            // 发现疑似帧头！去验证
                            state     <= S_VERIFY;
                            match_cnt <= 0;
                            scan_cnt  <= 0;
                        end else begin
                            // 还没找到，继续观察
                            if (scan_cnt >= SCAN_WINDOW) begin
                                // 超时了都没见到前导码，说明相位肯定错了
                                state    <= S_SLIDE; // 去滑一位
                                scan_cnt <= 0;
                            end else begin
                                scan_cnt <= scan_cnt + 1;
                            end
                        end
                    end

                    // 3. SLIDE: 执行滑动
                    S_SLIDE: begin
                        o_rxslide <= 1'b1; // 触发 GTH
                        state     <= S_COOLDOWN;
                        wait_cnt  <= 0;
                    end

                    // 4. COOLDOWN: 强制冷却
                    // GTH RXSLIDE 动作后，数据会乱一段时间，必须等待
                    S_COOLDOWN: begin
                        o_rxslide <= 1'b0;
                        if (wait_cnt >= SLIDE_COOLDOWN) begin
                            state <= S_HUNT; // 冷却结束，回 HUNT 重新看
                        end else begin
                            wait_cnt <= wait_cnt + 1;
                        end
                        if(header_match)begin
                            state <= S_VERIFY;
                        end
                    end

                    // 5. VERIFY: 验证模式 (Pre-Lock)
                    // 连续抓到 N 次前导码才算锁，防止数据中偶尔出现的伪帧头
                    S_VERIFY: begin
                        if (header_match) begin
                            if (match_cnt >= VERIFY_CNT_MAX - 1) begin
                                state      <= S_LOCKED;
                                locked_reg <= 1'b1;
                                miss_cnt   <= 0;
                            end else begin
                                match_cnt <= match_cnt + 1;
                            end
                        end else begin
                            if (scan_cnt >= SCAN_WINDOW) begin
                                state <= S_HUNT; 
                            end else begin
                                scan_cnt <= scan_cnt + 1;
                            end
                        end
                    end

                    // 6. LOCKED: 锁定模式 (带迟滞容错)
                    // 这是 LpGBT 的精髓：进锁严，出锁宽
                    S_LOCKED: begin
                        locked_reg <= 1'b1;
                        
                        if (header_match) begin
                            // 只要见到一次头，就清零“丢失计数器”
                            miss_cnt <= 0;
                            scan_cnt <= 0;
                        end else begin
                            // 只有长时间（比如 2 倍窗口）都没见到头，才认为失锁
                            if (scan_cnt >= SCAN_WINDOW * 2) begin
                                if (miss_cnt >= MISS_CNT_MAX - 1) begin
                                    state      <= S_HUNT; // 彻底失锁，重搜
                                    locked_reg <= 1'b0;
                                end else begin
                                    miss_cnt <= miss_cnt + 1; 
                                    scan_cnt <= 0; 
                                end
                            end else begin
                                scan_cnt <= scan_cnt + 1;
                            end
                        end
                    end
                    
                    default: state <= S_IDLE;
                endcase
            end
        end
    end

endmodule