`timescale 1ns / 1ps

module bit_aligner_ind #(
    parameter integer W                 = 32,
    parameter integer VERIFY_CNT_MAX    = 8,
    parameter integer SLIDE_COOLDOWN    = 5,
    parameter integer ERR_TH            = 0,
    parameter integer CHECK_TIMEOUT_MAX = 2048,
    // ★ 新增：锁定后如果长期看不到前导，则认为“失锁”的超时时间
    parameter integer LOCK_LOSS_TIMEOUT = 4096
)(
    input                       clk,
    input                       rst_n,
    input                       rx_reset_done,
    input                       rx_cdr_stable,
    
    input       [W-1:0]         i_rx_data,
    input                       i_rx_valid,
    
    input                       i_realign_req,  // 来自快时钟域

    output  reg                 o_rxslide,
    output  wire                o_aligned_valid,
    output                      o_bit_locked,
    output      [W-1:0]         o_data_aligned
);

    localparam [W-1:0] ALIGN_WORD = 32'hEB94_BDA3;

    localparam [1:0] S_IDLE            = 2'd0;
    localparam [1:0] S_CHECK_ALIGNMENT = 2'd1;
    localparam [1:0] S_SLIP_BIT        = 2'd2;

    reg [1:0]  state;
    reg [7:0]  verify_cnt;
    reg [7:0]  match_cnt;
    reg [7:0]  slide_cooldown_cnt;
    reg        locked_reg;

    // 原来的“未锁定时长时间匹配不到头”的超时计数
    localparam integer CHECK_TIMEOUT_WIDTH = $clog2(CHECK_TIMEOUT_MAX + 1);
    reg [CHECK_TIMEOUT_WIDTH-1:0] timeout_counter;

    // ★ 新增：已锁定状态下的“长期看不到前导”的超时计数
    localparam integer LOCK_LOSS_WIDTH = $clog2(LOCK_LOSS_TIMEOUT + 1);
    reg [LOCK_LOSS_WIDTH-1:0] loss_cnt;

    assign o_bit_locked = locked_reg;

    // ---------------- popcount & 匹配 ----------------
    function [5:0] popcount;
        input [W-1:0] v;
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < W; i = i + 1)
                popcount = popcount + v[i];
        end
    endfunction

    wire [W-1:0] diff         = i_rx_data ^ ALIGN_WORD;
    wire [5:0]   err_bits     = popcount(diff);
    wire         header_match = i_rx_valid && (err_bits <= ERR_TH);

    // ---------------- realign_req 同步 & 拉宽 ----------------
    reg [2:0]   realign_cnt;
    reg         realign_sync_d0,
                realign_sync_d1;
    wire        realign_req_line;   // 本域拉宽后的重对齐请求

    // core_clk 域来的 i_realign_req 先做 2 拍同步
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            realign_sync_d0 <= 1'b0;
            realign_sync_d1 <= 1'b0;
        end else begin
            realign_sync_d0 <= i_realign_req;
            realign_sync_d1 <= realign_sync_d0;
        end
    end

    // 展宽（拉成 N 拍 level 信号）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            realign_cnt <= 3'd0;
        end else begin
            if (realign_sync_d1) begin
                realign_cnt <= 3'd4;             // 重对齐时拉高 4 拍
            end else if (realign_cnt != 3'd0) begin
                realign_cnt <= realign_cnt - 1'b1;
            end
        end
    end

    assign realign_req_line = (realign_cnt != 3'd0);

    // ---------------- 锁定 / 失锁 判定 ----------------

    // 条件：在 S_CHECK_ALIGNMENT 下，未锁定 + 连续 VERIFY_CNT_MAX 次 header_match
    wire lock_now = (state == S_CHECK_ALIGNMENT) &&
                    (!locked_reg) &&
                    i_rx_valid &&
                    header_match &&
                    (verify_cnt == VERIFY_CNT_MAX-1);

    // ★ 已锁定状态下，如果 loss_cnt 数到阈值就认为“锁丢了”
    wire loss_timeout_hit = (loss_cnt == LOCK_LOSS_TIMEOUT-1);
    wire unlock_now       = locked_reg && loss_timeout_hit;

    // 这一拍结束后，locked 将要变成的值
    wire locked_next = (locked_reg | lock_now) & ~unlock_now;

    // ---------------- 数据 & valid 打一拍 ----------------
    reg [W-1:0] data_aligned_reg;
    reg         aligned_valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_aligned_reg  <= {W{1'b0}};
            aligned_valid_reg <= 1'b0;
        end else begin
            if (i_rx_valid)
                data_aligned_reg <= i_rx_data;

            // 如果这一拍结束后还是未锁定，就不认为输出是对齐过的
            if (!locked_next)
                aligned_valid_reg <= 1'b0;
            else
                aligned_valid_reg <= i_rx_valid;
        end
    end

    assign o_data_aligned  = data_aligned_reg;
    assign o_aligned_valid = aligned_valid_reg;

    // ---------------- 主状态机：搜索 + 滑位 ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state              <= S_IDLE;
            verify_cnt         <= 8'd0;
            slide_cooldown_cnt <= 8'd0;
            o_rxslide          <= 1'b0;
            locked_reg         <= 1'b0;
            timeout_counter    <= 'd0;
            match_cnt          <= 'd0;
            loss_cnt           <= 'd0;   // ★ 新增
        end else begin
            if(!rx_cdr_stable || !rx_reset_done || realign_req_line)begin
                state              <= S_IDLE;
                verify_cnt         <= 8'd0;
                slide_cooldown_cnt <= 8'd0;
                o_rxslide          <= 1'b0;
                locked_reg         <= 1'b0;
                timeout_counter    <= 'd0;
                match_cnt          <= 'd0;
                loss_cnt           <= 'd0;  // ★ 新增
            end else begin
                o_rxslide <= 1'b0;
    
                // 统一在这里更新 locked_reg
                locked_reg <= locked_next;

                // 冷却计数
                if (slide_cooldown_cnt != 0)
                    slide_cooldown_cnt <= slide_cooldown_cnt - 1'b1;

                // ★ 新增：已锁定时的“前导丢失”计数
                // 只在对齐检查状态 + 有效数据时工作
                if (state == S_CHECK_ALIGNMENT && i_rx_valid) begin
                    if (!locked_reg) begin
                        // 未锁定阶段不用 loss_cnt（用 timeout_counter）
                        loss_cnt <= 'd0;
                    end else begin
                        // 已锁定：看到前导 -> 清零；看不到 -> 递增，到阈值后本拍 unlock_now
                        if (header_match)
                            loss_cnt <= 'd0;
                        else if (!loss_timeout_hit)
                            loss_cnt <= loss_cnt + 1'b1;
                        else
                            loss_cnt <= 'd0;   // 已经触发 unlock_now 了，下一拍重新计
                    end
                end

                case (state)
                    S_IDLE: begin
                        verify_cnt      <= 8'd0;
                        match_cnt       <= 8'd0;
                        timeout_counter <= 'd0;
                        if (rx_cdr_stable && rx_reset_done)
                            state <= S_CHECK_ALIGNMENT;
                    end
    
                    S_CHECK_ALIGNMENT: begin
                        if (!locked_reg) begin
                            if (i_rx_valid) begin
                                if (header_match) begin
                                    timeout_counter <= 'd0;
                                    match_cnt       <= match_cnt + 1'b1;
                                    
                                    if (verify_cnt != VERIFY_CNT_MAX-1)
                                        verify_cnt <= verify_cnt + 1'b1;
                                end else begin
                                    // 未锁定阶段，长时间匹配不到头 -> bitslip
                                    if (timeout_counter == CHECK_TIMEOUT_MAX) begin
                                        verify_cnt      <= 8'd0;
                                        state           <= S_SLIP_BIT;
                                        timeout_counter <= 'd0;
                                    end else begin
                                        timeout_counter <= timeout_counter + 1'b1;
                                    end
                                end
                            end
                        end
                        // 已锁定时，这里不动 state，loss_cnt 的逻辑在上面统一处理
                    end
    
                    S_SLIP_BIT: begin
                        if (!locked_reg) begin
                            if (slide_cooldown_cnt == 0) begin
                                o_rxslide          <= 1'b1;
                                slide_cooldown_cnt <= SLIDE_COOLDOWN;
                            end
                        end
                        state <= S_CHECK_ALIGNMENT;
                    end
    
                    default: state <= S_IDLE;
                endcase
            end
        end
    end

endmodule
