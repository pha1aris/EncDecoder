`timescale 1ns / 1ps

// ============================================================
// 容错位对齐模块 - 适用于激光通信深度衰落场景
// 主要特性：
// 1. 软失锁（Soft Lock Loss）：短时间中断时保持锁定状态，但标记数据无效
// 2. 硬失锁（Hard Lock Loss）：长时间中断时才真正失锁
// 3. 数据有效性标记：在软失锁期间，输出 valid 信号被抑制
// 4. 容忍窗口：可配置的中断容忍时间（基于解交织器恢复能力）
// ============================================================
module bit_aligner_ind_fault_tolerant #(
    parameter integer W                 = 32,
    parameter integer SLIDE_COOLDOWN    = 5,
    parameter integer CHECK_TIMEOUT_MAX = 50,
    parameter         IDLE_WORD         = 32'h0707_0707,
    parameter integer LOCK_LOSS_TIMEOUT = 4096,
    // 容错参数
    parameter integer SOFT_LOSS_TIMEOUT  = 10000,  // 软失锁超时（拍数）：约 32us @ 312.5MHz
    parameter integer HARD_LOSS_TIMEOUT  = 50000   // 硬失锁超时（拍数）：约 160us @ 312.5MHz
)(
    input                       clk,
    input                       rst_n,
    input                       rx_reset_done,
    input                       rx_cdr_stable,
    
    input       [W-1:0]         i_rx_data,
    input                       i_rx_valid,
    
    input                       i_realign_req,

    // 配置端口
    input       [5:0]           cfg_err_th,
    input       [7:0]           cfg_verify_cnt_max,
    input       [15:0]          cfg_lock_loss_to,
    // 容错配置
    input       [19:0]          cfg_soft_loss_to,   // 软失锁超时（可配置）
    input       [19:0]          cfg_hard_loss_to,   // 硬失锁超时（可配置）

    output  reg                 o_rxslide,
    output  wire                o_aligned_valid,
    output                      o_bit_locked,        // 硬锁定状态
    output                      o_bit_locked_soft,  // 软锁定状态（包括软失锁期间）
    output                      o_data_valid,        // 数据有效性标记
    output      [W-1:0]         o_data_aligned
);

    localparam [W-1:0] ALIGN_WORD = 32'hEB94_BDA3;
    localparam [1:0] S_IDLE            = 2'd0;
    localparam [1:0] S_CHECK_ALIGNMENT = 2'd1;
    localparam [1:0] S_SLIP_BIT        = 2'd2;

    // 锁定状态定义
    localparam [1:0] LOCK_STATE_HARD_LOCKED = 2'd0;  // 硬锁定（正常）
    localparam [1:0] LOCK_STATE_SOFT_LOSS   = 2'd1;  // 软失锁（容忍窗口内）
    localparam [1:0] LOCK_STATE_HARD_LOSS   = 2'd2;  // 硬失锁（需要重新搜索）

    reg [1:0]  state;
    reg [7:0]  verify_cnt;
    reg [7:0]  match_cnt;
    reg [7:0]  slide_cooldown_cnt;
    reg        locked_reg;              // 硬锁定寄存器
    reg [1:0]  lock_state;              // 锁定状态机

    localparam integer CHECK_TIMEOUT_WIDTH = $clog2(CHECK_TIMEOUT_MAX + 1);
    localparam integer LOCK_LOSS_WIDTH    = $clog2(LOCK_LOSS_TIMEOUT + 1);
    localparam integer SOFT_LOSS_WIDTH    = $clog2(SOFT_LOSS_TIMEOUT + 1);
    localparam integer HARD_LOSS_WIDTH    = $clog2(HARD_LOSS_TIMEOUT + 1);

    reg [CHECK_TIMEOUT_WIDTH-1:0] timeout_counter;
    reg [LOCK_LOSS_WIDTH-1:0]     loss_cnt;
    reg [SOFT_LOSS_WIDTH-1:0]     soft_loss_cnt;    // 软失锁计数器
    reg [HARD_LOSS_WIDTH-1:0]     hard_loss_cnt;    // 硬失锁计数器

    // 配置参数截断
    wire [LOCK_LOSS_WIDTH-1:0] cfg_lock_loss_to_trunc =
            cfg_lock_loss_to[LOCK_LOSS_WIDTH-1:0];
    wire [SOFT_LOSS_WIDTH-1:0] cfg_soft_loss_to_trunc =
            cfg_soft_loss_to[SOFT_LOSS_WIDTH-1:0];
    wire [HARD_LOSS_WIDTH-1:0] cfg_hard_loss_to_trunc =
            cfg_hard_loss_to[HARD_LOSS_WIDTH-1:0];

    // 匹配检测
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
    wire         header_match = i_rx_valid && (err_bits <= cfg_err_th);
    wire         is_idle_word = (i_rx_data == IDLE_WORD);

    // CDC realign_req 同步
    reg [2:0]   realign_cnt;
    reg         realign_sync_d0, realign_sync_d1;
    wire        realign_req_line = (realign_cnt != 3'd0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            realign_sync_d0 <= 1'b0;
            realign_sync_d1 <= 1'b0;
        end else begin
            realign_sync_d0 <= i_realign_req;
            realign_sync_d1 <= realign_sync_d0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            realign_cnt <= 3'd0;
        end else begin
            if (realign_sync_d1) begin
                realign_cnt <= 3'd4;
            end else if (realign_cnt != 3'd0) begin
                realign_cnt <= realign_cnt - 1'b1;
            end
        end
    end

    // ============================================================
    // 锁定/失锁判定（容错版本）
    // ============================================================
    wire lock_now = (state == S_CHECK_ALIGNMENT) &&
                    (!locked_reg) &&
                    i_rx_valid &&
                    header_match &&
                    (verify_cnt == cfg_verify_cnt_max - 1);

    // 软失锁检测：在容忍窗口内，看到 header 或 idle 就恢复
    wire soft_loss_timeout_hit = (soft_loss_cnt >= cfg_soft_loss_to_trunc);
    wire hard_loss_timeout_hit = (hard_loss_cnt >= cfg_hard_loss_to_trunc);

    // 锁定状态机
    wire data_available = i_rx_valid && (header_match || is_idle_word);
    wire recovery_from_soft_loss = (lock_state == LOCK_STATE_SOFT_LOSS) && data_available;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lock_state <= LOCK_STATE_HARD_LOSS;
            locked_reg <= 1'b0;
        end else begin
            // 硬复位条件：CDR 不稳定或 reset_done 无效
            if (!rx_cdr_stable || !rx_reset_done || realign_req_line) begin
                lock_state <= LOCK_STATE_HARD_LOSS;
                locked_reg <= 1'b0;
            end else begin
                case (lock_state)
                    LOCK_STATE_HARD_LOCKED: begin
                        if (data_available) begin
                            // 有数据，保持硬锁定
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                        end else if (i_rx_valid) begin
                            // 有数据但不对齐，进入软失锁
                            if (soft_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_SOFT_LOSS;
                                soft_loss_cnt <= 'd0;
                            end else begin
                                soft_loss_cnt <= soft_loss_cnt + 1'b1;
                            end
                        end else begin
                            // 无数据，进入软失锁
                            if (soft_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_SOFT_LOSS;
                                soft_loss_cnt <= 'd0;
                            end else begin
                                soft_loss_cnt <= soft_loss_cnt + 1'b1;
                            end
                        end
                    end

                    LOCK_STATE_SOFT_LOSS: begin
                        if (recovery_from_soft_loss) begin
                            // 从软失锁恢复
                            lock_state <= LOCK_STATE_HARD_LOCKED;
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                        end else if (i_rx_valid) begin
                            // 继续软失锁，检查是否超过硬失锁阈值
                            if (hard_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_HARD_LOSS;
                                locked_reg <= 1'b0;
                                hard_loss_cnt <= 'd0;
                            end else begin
                                hard_loss_cnt <= hard_loss_cnt + 1'b1;
                            end
                        end else begin
                            // 无数据，继续软失锁
                            if (hard_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_HARD_LOSS;
                                locked_reg <= 1'b0;
                                hard_loss_cnt <= 'd0;
                            end else begin
                                hard_loss_cnt <= hard_loss_cnt + 1'b1;
                            end
                        end
                    end

                    LOCK_STATE_HARD_LOSS: begin
                        // 硬失锁，需要重新锁定
                        if (lock_now) begin
                            lock_state <= LOCK_STATE_HARD_LOCKED;
                            locked_reg <= 1'b1;
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                        end else begin
                            soft_loss_cnt <= 'd0;
                            hard_loss_cnt <= 'd0;
                        end
                    end

                    default: lock_state <= LOCK_STATE_HARD_LOSS;
                endcase
            end
        end
    end

    // 输出信号
    assign o_bit_locked = (lock_state == LOCK_STATE_HARD_LOCKED);
    assign o_bit_locked_soft = (lock_state == LOCK_STATE_HARD_LOCKED) || 
                               (lock_state == LOCK_STATE_SOFT_LOSS);
    assign o_data_valid = (lock_state == LOCK_STATE_HARD_LOCKED) && 
                          (header_match || is_idle_word);

    // 数据输出
    reg [W-1:0] data_aligned_reg;
    reg         aligned_valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_aligned_reg  <= {W{1'b0}};
            aligned_valid_reg <= 1'b0;
        end else begin
            if (i_rx_valid)
                data_aligned_reg <= i_rx_data;

            // 只有在硬锁定且数据有效时才输出 valid
            if (o_data_valid)
                aligned_valid_reg <= i_rx_valid;
            else
                aligned_valid_reg <= 1'b0;
        end
    end

    assign o_data_aligned  = data_aligned_reg;
    assign o_aligned_valid = aligned_valid_reg;

    // ============================================================
    // 主状态机：搜索 + 滑位（仅在硬失锁时工作）
    // ============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state              <= S_IDLE;
            verify_cnt         <= 8'd0;
            slide_cooldown_cnt <= 8'd0;
            o_rxslide          <= 1'b0;
            timeout_counter    <= 'd0;
            match_cnt          <= 'd0;
        end else begin
            // 硬复位或硬失锁时重置状态机
            if (!rx_cdr_stable || !rx_reset_done || realign_req_line || 
                (lock_state == LOCK_STATE_HARD_LOSS)) begin
                state              <= S_IDLE;
                verify_cnt         <= 8'd0;
                slide_cooldown_cnt <= 8'd0;
                o_rxslide          <= 1'b0;
                timeout_counter    <= 'd0;
                match_cnt          <= 'd0;
            end else begin
                o_rxslide <= 1'b0;

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
                                    
                                    if (verify_cnt != cfg_verify_cnt_max - 1)
                                        verify_cnt <= verify_cnt + 1'b1;
                                end else begin
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

                // 冷却计数
                if (slide_cooldown_cnt != 0)
                    slide_cooldown_cnt <= slide_cooldown_cnt - 1'b1;
            end
        end
    end

endmodule
