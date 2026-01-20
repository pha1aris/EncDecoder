`timescale 1ns/1ps
`define SIM

// ============================================================
// 衰落信道下的同步系统测试bench
// 测试目标：
// 1. bit_aligner 在衰落条件下的恢复能力
// 2. deframer 在衰落条件下的恢复能力
// 3. 块边界信息（block_id, frame_in_block）的正确传输和恢复
// 4. 多次衰落事件的稳定性
// ============================================================
module tb_sync_fade_test;

    // 系统差分时钟 & 复位
    reg sys_clk_p;
    reg sys_clk_n;
    reg sys_rst_n;

    initial begin
        sys_clk_p = 1'b0;
        sys_clk_n = 1'b1;
        forever begin
            #2.5 sys_clk_p = ~sys_clk_p;   // 200 MHz
            sys_clk_n = ~sys_clk_p;
        end
    end

    initial begin
        sys_rst_n = 1'b0;
        #200;
        sys_rst_n = 1'b1;
    end

    // MGT 参考时钟  125MHz
    reg mgtrefclk0_x1y1_p;
    wire mgtrefclk0_x1y1_n = ~mgtrefclk0_x1y1_p;
    initial begin
        mgtrefclk0_x1y1_p = 0;
        forever begin
            #4 mgtrefclk0_x1y1_p = ~mgtrefclk0_x1y1_p;
        end
    end

    // GTH 差分 IO
    wire gthrxp;
    wire gthrxn;
    wire gthtxp;
    wire gthtxn;

    wire [1:0] tx_disable;

    // ============================================================
    // DUT：Stage1 顶层（使用改进版本）
    // ============================================================
    fec_gth_loopback_top_s1 #(
        .W                (32),
        .PAYLOAD_WORDS    (16),
        .FRAMES_PER_BLOCK (255),
        .IGNORE_SFP_LOSS  (1)
    ) dut (
        .sys_clk_p         (sys_clk_p),
        .sys_clk_n         (sys_clk_n),
        .sys_rst_n         (sys_rst_n),
        .mgtrefclk0_x1y1_p (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n (mgtrefclk0_x1y1_n),
        .gthrxp_in         (gthrxp),
        .gthrxn_in         (gthrxn),
        .gthtxp_out        (gthtxp),
        .gthtxn_out        (gthtxn),
        .sfp_loss          (2'd0),
        .tx_disable        (tx_disable)
    );

    // ============================================================
    // 衰落信道模型（使用不同的衰落深度和持续时间）
    // ============================================================
    // 测试场景1：轻度衰落（快速恢复）
    // P_GB=13, P_BG=524  -> 平均坏状态持续时间短
    // FLIP_BAD=7864     -> 误码率适中
    // DROP_BAD=655      -> 丢包率较低
    fso_channel_ge_serial #(
        .P(16),
        .P_GB     (13),      // Good -> Bad 概率
        .P_BG     (524),     // Bad -> Good 概率（快速恢复）
        .FLIP_GOOD(0),       // 好状态误码率（无）
        .FLIP_BAD (7864),    // 坏状态误码率（适中）
        .DROP_BAD (655),     // 坏状态丢包率（较低）
        .DROP_MODE(2),       // 随机丢包值
        .SEED     (32'hFADE_TEST_01)
    ) u_channel_light (
        .clk     (mgtrefclk0_x1y1_p),
        .rst_n   (sys_rst_n),
        .txp_in  (gthtxp),
        .txn_in  (gthtxn),
        .rxp_out (gthrxp),
        .rxn_out (gthrxn),
        .bad_state(),
        .dropped ()
    );

    // ============================================================
    // 测试场景2：中度衰落（中等恢复时间）
    // ============================================================
    // 可以通过修改参数来测试不同场景
    // P_GB=20, P_BG=800  -> 中等恢复时间

    // ============================================================
    // 测试场景3：重度衰落（慢速恢复）
    // ============================================================
    // P_GB=30, P_BG=1200 -> 慢速恢复
    // FLIP_BAD=10000    -> 高误码率
    // DROP_BAD=1000     -> 高丢包率

    // ============================================================
    // 监控和统计
    // ============================================================
    reg bit_locked_reg, frame_locked_reg;
    reg [31:0] bit_lock_time, frame_lock_time;
    reg [31:0] bit_unlock_count, frame_unlock_count;
    reg [31:0] bit_recovery_time_total, frame_recovery_time_total;
    reg bit_unlock_active, frame_unlock_active;
    reg [31:0] bit_unlock_start, frame_unlock_start;

    // 监控信号（通过层次化路径访问）
    // 注意：这些信号在 fec_gth_loopback_top_s1 中被声明为内部信号
    // 我们需要通过模块实例访问
    wire bit_locked_core     = dut.bit_locked_core;
    wire frame_locked_core   = dut.frame_locked_core;
    wire [15:0] rx_block_id       = dut.rx_block_id;
    wire [15:0] rx_frame_in_block = dut.rx_frame_in_block;

    // 同步监控信号（使用内部信号）
    wire bit_locked     = bit_locked_core;
    wire frame_locked   = frame_locked_core;
    
    always @(posedge sys_clk_p) begin
        if (!sys_rst_n) begin
            bit_locked_reg <= 1'b0;
            frame_locked_reg <= 1'b0;
            bit_lock_time <= 0;
            frame_lock_time <= 0;
            bit_unlock_count <= 0;
            frame_unlock_count <= 0;
            bit_recovery_time_total <= 0;
            frame_recovery_time_total <= 0;
            bit_unlock_active <= 1'b0;
            frame_unlock_active <= 1'b0;
        end else begin
            bit_locked_reg <= bit_locked;
            frame_locked_reg <= frame_locked;

            // Bit lock 监控
            if (!bit_locked_reg && bit_locked) begin
                // 首次锁定
                if (bit_lock_time == 0) begin
                    bit_lock_time <= $time;
                    $display("[%0t] *** BIT_LOCKED achieved (first time) ***", $time);
                end
                // 重新锁定（恢复）
                else if (bit_unlock_active) begin
                    bit_unlock_active <= 1'b0;
                    bit_recovery_time_total <= bit_recovery_time_total + ($time - bit_unlock_start);
                    $display("[%0t] *** BIT_LOCKED recovered after %0t ns ***", 
                             $time, $time - bit_unlock_start);
                end
            end
            if (bit_locked_reg && !bit_locked) begin
                // 失锁
                if (!bit_unlock_active) begin
                    bit_unlock_active <= 1'b1;
                    bit_unlock_start <= $time;
                    bit_unlock_count <= bit_unlock_count + 1;
                    $display("[%0t] *** BIT_LOCKED lost (unlock #%0d) ***", 
                             $time, bit_unlock_count + 1);
                end
            end

            // Frame lock 监控
            if (!frame_locked_reg && frame_locked) begin
                // 首次锁定
                if (frame_lock_time == 0) begin
                    frame_lock_time <= $time;
                    $display("[%0t] *** FRAME_LOCKED achieved (first time) ***", $time);
                end
                // 重新锁定（恢复）
                else if (frame_unlock_active) begin
                    frame_unlock_active <= 1'b0;
                    frame_recovery_time_total <= frame_recovery_time_total + ($time - frame_unlock_start);
                    $display("[%0t] *** FRAME_LOCKED recovered after %0t ns ***", 
                             $time, $time - frame_unlock_start);
                end
            end
            if (frame_locked_reg && !frame_locked) begin
                // 失锁
                if (!frame_unlock_active) begin
                    frame_unlock_active <= 1'b1;
                    frame_unlock_start <= $time;
                    frame_unlock_count <= frame_unlock_count + 1;
                    $display("[%0t] *** FRAME_LOCKED lost (unlock #%0d) ***", 
                             $time, frame_unlock_count + 1);
                end
            end
        end
    end

    // ============================================================
    // 块边界信息监控
    // ============================================================
    reg [15:0] last_rx_block_id, last_rx_frame_in_block;
    reg [31:0] block_boundary_error_count;
    reg block_sync_valid;

    always @(posedge sys_clk_p) begin
        if (!sys_rst_n) begin
            last_rx_block_id <= 16'hFFFF;
            last_rx_frame_in_block <= 16'hFFFF;
            block_boundary_error_count <= 0;
            block_sync_valid <= 1'b0;
        end else begin
            // 监控块边界信息的连续性
            if (frame_locked) begin
                if (!block_sync_valid) begin
                    // 首次同步
                    last_rx_block_id <= rx_block_id;
                    last_rx_frame_in_block <= rx_frame_in_block;
                    block_sync_valid <= 1'b1;
                    $display("[%0t] Block sync initialized: block_id=%0d frame_in_block=%0d",
                             $time, rx_block_id, rx_frame_in_block);
                end else begin
                    // 检查块边界连续性
                    if (rx_block_id == last_rx_block_id) begin
                        // 同一块内，frame_in_block 应该递增
                        if (rx_frame_in_block != last_rx_frame_in_block + 1 &&
                            !(last_rx_frame_in_block == 254 && rx_frame_in_block == 0)) begin
                            block_boundary_error_count <= block_boundary_error_count + 1;
                            $display("[%0t] WARNING: Frame sequence error in block %0d: "
                                     "last=%0d current=%0d",
                                     $time, rx_block_id, 
                                     last_rx_frame_in_block, rx_frame_in_block);
                        end
                    end else if (rx_block_id == last_rx_block_id + 1) begin
                        // 新块开始，frame_in_block 应该为 0
                        if (rx_frame_in_block != 0) begin
                            block_boundary_error_count <= block_boundary_error_count + 1;
                            $display("[%0t] WARNING: Block boundary error: "
                                     "new block %0d but frame_in_block=%0d (expected 0)",
                                     $time, rx_block_id, rx_frame_in_block);
                        end
                    end
                    // 更新记录
                    last_rx_block_id <= rx_block_id;
                    last_rx_frame_in_block <= rx_frame_in_block;
                end
            end else begin
                // 失锁时清除同步状态
                block_sync_valid <= 1'b0;
            end
        end
    end

    // ============================================================
    // 测试控制和报告
    // ============================================================
    initial begin
        // 等待复位释放
        wait(sys_rst_n === 1'b1);
        $display("[%0t] =========================================", $time);
        $display("[%0t] Fading Channel Sync Test Started", $time);
        $display("[%0t] Channel: Light fading (fast recovery)", $time);
        $display("[%0t] =========================================", $time);

        // 等待首次锁定
        wait(bit_locked === 1'b1);
        wait(frame_locked === 1'b1);
        $display("[%0t] Initial lock achieved. Starting fade test...", $time);

        // 运行测试 5ms（包含多个衰落周期）
        #5_000_000;

        // 生成报告
        $display("\n========================================");
        $display("Fade Test Statistics:");
        $display("========================================");
        $display("Bit lock:");
        $display("  First lock time: %0t ns", bit_lock_time);
        $display("  Unlock events:   %0d", bit_unlock_count);
        if (bit_unlock_count > 0) begin
            $display("  Avg recovery time: %0t ns", 
                     bit_recovery_time_total / bit_unlock_count);
        end
        $display("Frame lock:");
        $display("  First lock time: %0t ns", frame_lock_time);
        $display("  Unlock events:   %0d", frame_unlock_count);
        if (frame_unlock_count > 0) begin
            $display("  Avg recovery time: %0t ns", 
                     frame_recovery_time_total / frame_unlock_count);
        end
        $display("Block boundaries:");
        $display("  Sync errors:     %0d", block_boundary_error_count);
        if (block_boundary_error_count == 0) begin
            $display("  Status:          PASS (no boundary errors)");
        end else begin
            $display("  Status:          FAIL (%0d boundary errors detected)", 
                     block_boundary_error_count);
        end
        $display("========================================\n");

        // 检查测试结果
        if (block_boundary_error_count == 0 && bit_unlock_count <= 10) begin
            $display("[%0t] *** TEST PASSED ***", $time);
        end else begin
            $display("[%0t] *** TEST FAILED ***", $time);
            if (block_boundary_error_count > 0) begin
                $display("  Reason: Block boundary errors detected");
            end
            if (bit_unlock_count > 10) begin
                $display("  Reason: Too many bit unlock events (%0d)", bit_unlock_count);
            end
        end

        #1000;
        $finish;
    end

endmodule
