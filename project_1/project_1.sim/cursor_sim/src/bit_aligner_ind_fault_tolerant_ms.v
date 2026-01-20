`timescale 1ns / 1ps

// ============================================================
// 容错位对齐模块 - 适用于激光通信几毫秒级衰落场景（修复版）
// 
// 修复内容：
// 1. 主FSM在HARD_LOSS时运行搜索，而不是被清零（修复死锁）
// 2. o_data_valid对所有word有效，不只是header/idle（修复payload丢失）
// 3. 所有计数器在reset时初始化（修复X传播）
// 4. 窗口语义改为统一miss_cnt，用两个阈值分段（修复语义歧义）
// 5. 位宽直接使用24-bit，不依赖parameter推断（修复截断问题）
// ============================================================
module bit_aligner_ind_fault_tolerant_ms #(
    parameter integer W                 = 32,
    parameter integer SLIDE_COOLDOWN    = 5,
    parameter integer CHECK_TIMEOUT_MAX = 50,
    parameter         IDLE_WORD         = 32'h0707_0707,
    parameter integer LOCK_LOSS_TIMEOUT = 4096,
    // 容错参数 - 针对几毫秒级衰落优化
    // 默认值基于 15.625MHz（500Mbps / 32位）
    //   1ms = 15,625 拍
    //   5ms = 78,125 拍
    //   10ms = 156,250 拍
    //   20ms = 312,500 拍
    parameter integer SOFT_LOSS_TIMEOUT  = 78125,   // 软失锁超时：5ms @ 15.625MHz（默认）
    parameter integer HARD_LOSS_TIMEOUT  = 312500   // 硬失锁超时：20ms @ 15.625MHz（总窗口，不是soft+hard）
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
    // 容错配置 - 支持大范围配置（最大 40ms）
    input       [23:0]          cfg_soft_loss_to,   // 软失锁超时（可配置，最大 20ms）
    input       [23:0]          cfg_hard_loss_to,   // 硬失锁超时（可配置，最大 40ms，总窗口）

    output  reg                 o_rxslide,
    output  wire                o_aligned_valid,
    output                      o_bit_locked,        // 硬锁定状态
    output                      o_bit_locked_soft,   // 软锁定状态（包括软失锁期间）
    output                      o_data_valid,        // 数据有效性标记（HARD_LOCKED时对所有word有效）
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

    // ============================================================
    // 状态和计数器（固定24-bit位宽，避免截断）
    // ============================================================
    reg [1:0]  state;
    reg [7:0]  verify_cnt;
    reg [7:0]  match_cnt;
    reg [7:0]  slide_cooldown_cnt;
    reg        locked_reg;              // 硬锁定寄存器
    reg [1:0]  lock_state;              // 锁定状态机
    
    // 固定24-bit位宽，支持最大40ms（625,000拍 @ 15.625MHz）
    reg [CHECK_TIMEOUT_MAX-1:0] timeout_counter;
    reg [15:0]                  loss_cnt;
    reg [23:0]                  miss_cnt;              // 统一失锁计数器（24-bit，总窗口）

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
    
    // 数据可用性判断（用于锁状态维持/恢复）
    wire data_available = i_rx_valid && (header_match || is_idle_word);

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
    // 锁定/失锁判定（容错版本 - 统一miss_cnt，两个阈值分段）
    // ============================================================
    wire lock_now = (state == S_CHECK_ALIGNMENT) &&
                    (!locked_reg) &&
                    i_rx_valid &&
                    header_match &&
                    (verify_cnt == cfg_verify_cnt_max - 1);

    // 失锁阈值判断（使用统一miss_cnt）
    wire soft_loss_timeout_hit = (miss_cnt >= cfg_soft_loss_to);
    wire hard_loss_timeout_hit = (miss_cnt >= cfg_hard_loss_to);

    // 锁定状态机
    wire recovery_from_soft_loss = (lock_state == LOCK_STATE_SOFT_LOSS) && data_available;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lock_state    <= LOCK_STATE_HARD_LOSS;
            locked_reg    <= 1'b0;
            miss_cnt      <= 24'd0;  // 初始化计数器
            loss_cnt      <= 16'd0;
        end else begin
            // 硬复位条件：CDR 不稳定或 reset_done 无效
            if (!rx_cdr_stable || !rx_reset_done || realign_req_line) begin
                lock_state <= LOCK_STATE_HARD_LOSS;
                locked_reg <= 1'b0;
                miss_cnt   <= 24'd0;
                loss_cnt   <= 16'd0;
            end else begin
                case (lock_state)
                    LOCK_STATE_HARD_LOCKED: begin
                        if (data_available) begin
                            // 有健康数据（header/idle），保持硬锁定，清零计数器
                            miss_cnt <= 24'd0;
                            loss_cnt <= 16'd0;
                        end else begin
                            // 无健康数据，增加miss计数
                            if (i_rx_valid) begin
                                // 有数据但不对齐
                                if (miss_cnt < 24'hFFFFFF)
                                    miss_cnt <= miss_cnt + 1'b1;
                            end else begin
                                // 无数据（衰落开始）
                                if (miss_cnt < 24'hFFFFFF)
                                    miss_cnt <= miss_cnt + 1'b1;
                            end
                            
                            // 检查是否进入软失锁
                            if (soft_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_SOFT_LOSS;
                            end
                        end
                    end

                    LOCK_STATE_SOFT_LOSS: begin
                        if (recovery_from_soft_loss) begin
                            // 从软失锁恢复（衰落结束，数据恢复）
                            lock_state <= LOCK_STATE_HARD_LOCKED;
                            miss_cnt   <= 24'd0;
                            loss_cnt   <= 16'd0;
                        end else begin
                            // 继续失锁，增加miss计数
                            if (i_rx_valid) begin
                                if (miss_cnt < 24'hFFFFFF)
                                    miss_cnt <= miss_cnt + 1'b1;
                            end else begin
                                if (miss_cnt < 24'hFFFFFF)
                                    miss_cnt <= miss_cnt + 1'b1;
                            end
                            
                            // 检查是否进入硬失锁
                            if (hard_loss_timeout_hit) begin
                                lock_state <= LOCK_STATE_HARD_LOSS;
                                locked_reg <= 1'b0;
                                miss_cnt   <= 24'd0;  // 进入硬失锁时清零，准备重新搜索
                            end
                        end
                    end

                    LOCK_STATE_HARD_LOSS: begin
                        // 硬失锁，需要重新锁定
                        // 主FSM会在这里运行搜索，lock_now会触发恢复
                        if (lock_now) begin
                            lock_state <= LOCK_STATE_HARD_LOCKED;
                            locked_reg <= 1'b1;
                            miss_cnt   <= 24'd0;
                            loss_cnt   <= 16'd0;
                        end else begin
                            // 保持硬失锁，等待主FSM搜索
                            miss_cnt <= 24'd0;
                            loss_cnt <= 16'd0;
                        end
                    end

                    default: begin
                        lock_state <= LOCK_STATE_HARD_LOSS;
                        miss_cnt   <= 24'd0;
                        loss_cnt   <= 16'd0;
                    end
                endcase
            end
        end
    end

    // ============================================================
    // 输出信号
    // ============================================================
    assign o_bit_locked = (lock_state == LOCK_STATE_HARD_LOCKED);
    assign o_bit_locked_soft = (lock_state == LOCK_STATE_HARD_LOCKED) || 
                               (lock_state == LOCK_STATE_SOFT_LOSS);
    
    // 修复：o_data_valid应该对所有word有效（HARD_LOCKED时），不只是header/idle
    // header_match/idle只用于锁状态维持，不用于数据有效性门控
    assign o_data_valid = (lock_state == LOCK_STATE_HARD_LOCKED) && i_rx_valid;

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

            // 修复：o_aligned_valid应该对所有word有效（HARD_LOCKED时）
            aligned_valid_reg <= o_data_valid;
        end
    end

    assign o_data_aligned  = data_aligned_reg;
    assign o_aligned_valid = aligned_valid_reg;

    // ============================================================
    // 主状态机：搜索 + 滑位（仅在硬失锁时工作）
    // 修复：HARD_LOSS时不应该清零FSM，应该允许运行搜索
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
            // 硬复位条件：CDR不稳定、reset_done无效、realign请求
            // 修复：HARD_LOSS时不应该清零FSM，应该允许运行搜索
            if (!rx_cdr_stable || !rx_reset_done || realign_req_line) begin
                state              <= S_IDLE;
                verify_cnt         <= 8'd0;
                slide_cooldown_cnt <= 8'd0;
                o_rxslide          <= 1'b0;
                timeout_counter    <= 'd0;
                match_cnt          <= 'd0;
            end else begin
                // 修复：只有在HARD_LOSS时才运行搜索FSM
                // HARD_LOCKED或SOFT_LOSS时，禁止slip，state保持在IDLE
                if (lock_state == LOCK_STATE_HARD_LOSS) begin
                    // HARD_LOSS：运行搜索FSM
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
                end else begin
                    // HARD_LOCKED或SOFT_LOSS：禁止slip，state保持在IDLE
                    state              <= S_IDLE;
                    verify_cnt         <= 8'd0;
                    slide_cooldown_cnt <= 8'd0;
                    o_rxslide          <= 1'b0;
                    timeout_counter    <= 'd0;
                    match_cnt          <= 'd0;
                end
            end
        end
    end

endmodule
