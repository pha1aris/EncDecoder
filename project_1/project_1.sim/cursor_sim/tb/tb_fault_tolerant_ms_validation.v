`timescale 1ns/1ps

// ============================================================
// 容错同步系统验证测试平台
// 测试场景：验证不同中断时间下的锁定保持能力
// 线速率：500Mbps
// ============================================================

module tb_fault_tolerant_ms_validation;

    // ============================================================
    // 参数配置
    // ============================================================
    localparam integer W              = 32;
    localparam integer PAYLOAD_WORDS  = 16;
    
    // 线速率：500Mbps
    // 32位并行数据，线时钟频率 = 500Mbps / 32 = 15.625 MHz
    // 根据 GT_rx500M_tx1G IP 配置：RX_USRCLK_FREQUENCY = 15.625 MHz
    localparam integer LINE_CLK_FREQ  = 15625000;   // 15.625 MHz（500Mbps / 32）
    localparam integer CORE_CLK_FREQ  = 15625000;   // 15.625 MHz
    localparam real    LINE_CLK_PERIOD = 1000.0 / LINE_CLK_FREQ;
    localparam real    CORE_CLK_PERIOD = 1000.0 / CORE_CLK_FREQ;

    // 测试中断时间（微秒）
    localparam real INTERRUPT_SHORT = 0.5;   // 0.5ms（短衰落）
    localparam real INTERRUPT_MEDIUM = 3.0;  // 3ms（中等衰落）
    localparam real INTERRUPT_LONG = 8.0;    // 8ms（深度衰落）
    localparam real INTERRUPT_VERY_LONG = 15.0; // 15ms（超过硬失锁窗口）

    // 容错参数（针对几毫秒级衰落）
    // 在 15.625MHz 下：
    //   1ms = 15,625 拍
    //   5ms = 78,125 拍
    //   10ms = 156,250 拍
    //   20ms = 312,500 拍
    localparam integer SOFT_LOSS_TO = 78125;    // 5ms @ 15.625MHz
    localparam integer HARD_LOSS_TO = 312500;   // 20ms @ 15.625MHz

    // ============================================================
    // 时钟和复位
    // ============================================================
    reg line_clk;
    reg core_clk;
    reg rst_n;

    initial begin
        line_clk = 0;
        forever #(LINE_CLK_PERIOD/2) line_clk = ~line_clk;
    end

    initial begin
        core_clk = 0;
        forever #(CORE_CLK_PERIOD/2) core_clk = ~core_clk;
    end

    initial begin
        rst_n = 0;
        #(100 * LINE_CLK_PERIOD);
        rst_n = 1;
    end

    // ============================================================
    // 测试控制
    // ============================================================
    reg [2:0] test_case;
    reg data_interrupt;
    reg link_down;
    reg cdr_unstable;

    // 测试用例选择
    initial begin
        test_case = 3'd0;
        data_interrupt = 0;
        link_down = 0;
        cdr_unstable = 0;

        // 等待复位完成和初始锁定建立
        #(200 * LINE_CLK_PERIOD);
        $display("[%0t] 等待初始锁定建立...", $time);
        #(10000 * LINE_CLK_PERIOD); // 等待 640us 建立锁定

        // 测试用例 1: 短衰落（0.5ms，应该保持在软失锁内）
        $display("\n========================================");
        $display("测试用例 1: 短衰落 (0.5ms)");
        $display("========================================");
        test_case = 3'd1;
        #(10000 * LINE_CLK_PERIOD); // 正常传输 640us，确保锁定稳定

        $display("[%0t] 衰落开始 (0.5ms)", $time);
        data_interrupt = 1;
        link_down = 0;  // 链路保持，只是数据中断
        cdr_unstable = 0;
        #(INTERRUPT_SHORT * 1000); // 0.5ms

        $display("[%0t] 衰落结束", $time);
        data_interrupt = 0;
        #(20000 * LINE_CLK_PERIOD); // 观察恢复 1.28ms

        // 测试用例 2: 中等衰落（3ms，应该在软失锁窗口内）
        $display("\n========================================");
        $display("测试用例 2: 中等衰落 (3ms)");
        $display("========================================");
        test_case = 3'd2;
        #(10000 * LINE_CLK_PERIOD); // 正常传输 640us

        $display("[%0t] 衰落开始 (3ms)", $time);
        data_interrupt = 1;
        #(INTERRUPT_MEDIUM * 1000); // 3ms

        $display("[%0t] 衰落结束", $time);
        data_interrupt = 0;
        #(20000 * LINE_CLK_PERIOD); // 观察恢复 1.28ms

        // 测试用例 3: 深度衰落（8ms，可能超过软失锁但小于硬失锁）
        $display("\n========================================");
        $display("测试用例 3: 深度衰落 (8ms)");
        $display("========================================");
        test_case = 3'd3;
        #(10000 * LINE_CLK_PERIOD); // 正常传输 640us

        $display("[%0t] 衰落开始 (8ms)", $time);
        data_interrupt = 1;
        #(INTERRUPT_LONG * 1000); // 8ms

        $display("[%0t] 衰落结束", $time);
        data_interrupt = 0;
        #(50000 * LINE_CLK_PERIOD); // 观察重新锁定 3.2ms（需要重新搜索）

        // 测试用例 4: 超长衰落（15ms，应该超过硬失锁窗口）
        $display("\n========================================");
        $display("测试用例 4: 超长衰落 (15ms)");
        $display("========================================");
        test_case = 3'd4;
        #(10000 * LINE_CLK_PERIOD); // 正常传输 640us

        $display("[%0t] 衰落开始 (15ms)", $time);
        data_interrupt = 1;
        #(INTERRUPT_VERY_LONG * 1000); // 15ms

        $display("[%0t] 衰落结束", $time);
        data_interrupt = 0;
        #(100000 * LINE_CLK_PERIOD); // 观察重新锁定 6.4ms（需要重新搜索和锁定）

        $display("\n========================================");
        $display("所有测试完成");
        $display("========================================");
        #(10000 * LINE_CLK_PERIOD);
        $finish;
    end

    // ============================================================
    // 数据生成器
    // ============================================================
    reg [W-1:0] tx_data;
    reg         tx_valid;
    reg [15:0]  block_id;
    reg [15:0]  frame_in_block;
    reg [15:0]  payload_word_cnt;
    reg [2:0]   frame_state;

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;
    localparam [31:0] IDLE_WORD   = 32'h0707_0707;

    // 简化的 CRC32 计算
    reg [31:0] crc32_reg;
    function [31:0] next_crc32;
        input [31:0] crc;
        input [31:0] data;
        integer i;
        begin
            next_crc32 = crc;
            for (i = 0; i < 32; i = i + 1) begin
                if (next_crc32[31] ^ data[i])
                    next_crc32 = (next_crc32 << 1) ^ 32'h04C11DB7;
                else
                    next_crc32 = next_crc32 << 1;
            end
        end
    endfunction

    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data         <= IDLE_WORD;
            tx_valid        <= 1'b0;
            block_id        <= 16'd0;
            frame_in_block  <= 16'd0;
            payload_word_cnt <= 16'd0;
            frame_state     <= 3'd0;
            crc32_reg       <= 32'hFFFFFFFF;
        end else begin
            if (data_interrupt || link_down || cdr_unstable) begin
                tx_data  <= 32'h0;
                tx_valid <= 1'b0;
            end else begin
                tx_valid <= 1'b1;
                
                case (frame_state)
                    3'd0: begin  // PREAMBLE_HI
                        tx_data <= PREAMBLE_HI;
                        frame_state <= 3'd1;
                        crc32_reg <= 32'hFFFFFFFF;
                    end
                    3'd1: begin  // PREAMBLE_LO
                        tx_data <= PREAMBLE_LO;
                        frame_state <= 3'd2;
                    end
                    3'd2: begin  // HEADER
                        tx_data <= {block_id, frame_in_block};
                        frame_state <= 3'd3;
                        payload_word_cnt <= 16'd0;
                        crc32_reg <= next_crc32(crc32_reg, {block_id, frame_in_block});
                    end
                    3'd3: begin  // PAYLOAD
                        tx_data <= {16'd0, payload_word_cnt};
                        crc32_reg <= next_crc32(crc32_reg, {16'd0, payload_word_cnt});
                        if (payload_word_cnt == PAYLOAD_WORDS - 1) begin
                            frame_state <= 3'd4;
                            payload_word_cnt <= 16'd0;
                        end else begin
                            payload_word_cnt <= payload_word_cnt + 1'b1;
                        end
                    end
                    3'd4: begin  // CRC
                        tx_data <= crc32_reg;
                        frame_state <= 3'd0;
                        if (frame_in_block == 15) begin
                            frame_in_block <= 16'd0;
                            block_id <= block_id + 1'b1;
                        end else begin
                            frame_in_block <= frame_in_block + 1'b1;
                        end
                    end
                    default: frame_state <= 3'd0;
                endcase
            end
        end
    end

    // ============================================================
    // 容错位对齐模块实例化
    // ============================================================
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         bit_locked;
    wire         bit_locked_soft;
    wire         data_valid;
    wire         rx_slide_req;

    wire rx_reset_done = rst_n && !link_down && !cdr_unstable;
    wire rx_cdr_stable = rst_n && !cdr_unstable;
    wire [5:0]  cfg_err_th         = 6'd2;
    wire [7:0]  cfg_verify_cnt_max  = 8'd8;
    wire [15:0] cfg_lock_loss_to    = 16'd1000;
    wire [23:0] cfg_soft_loss_to    = SOFT_LOSS_TO[23:0];
    wire [23:0] cfg_hard_loss_to    = HARD_LOSS_TO[23:0];

    bit_aligner_ind_fault_tolerant_ms #(
        .W                 (W),
        .IDLE_WORD         (IDLE_WORD),
        .LOCK_LOSS_TIMEOUT (4096),
        .SOFT_LOSS_TIMEOUT (SOFT_LOSS_TO),
        .HARD_LOSS_TIMEOUT (HARD_LOSS_TO)
    ) u_bit_aligner_ft (
        .clk                (line_clk),
        .rst_n              (rst_n),
        .rx_reset_done      (rx_reset_done),
        .rx_cdr_stable      (rx_cdr_stable),
        .i_rx_data          (tx_data),
        .i_rx_valid         (tx_valid),
        .i_realign_req      (rx_slide_req),
        .cfg_err_th         (cfg_err_th),
        .cfg_verify_cnt_max (cfg_verify_cnt_max),
        .cfg_lock_loss_to   (cfg_lock_loss_to),
        .cfg_soft_loss_to   (cfg_soft_loss_to),
        .cfg_hard_loss_to   (cfg_hard_loss_to),
        .o_rxslide          (),
        .o_aligned_valid    (aligned_valid),
        .o_bit_locked       (bit_locked),
        .o_bit_locked_soft  (bit_locked_soft),
        .o_data_valid       (data_valid),
        .o_data_aligned     (aligned_data)
    );

    // ============================================================
    // 监控和统计
    // ============================================================
    reg bit_locked_d;
    reg bit_locked_soft_d;
    reg bit_lock_acquired;
    reg bit_lock_lost;
    reg bit_lock_recovered;
    reg bit_lock_hard_lost;
    reg [31:0] soft_loss_count;
    reg [31:0] hard_loss_count;
    reg [31:0] total_interrupt_time_ns;

    // 锁定状态监控
    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_locked_d <= 1'b0;
            bit_locked_soft_d <= 1'b0;
            bit_lock_acquired <= 1'b0;
            bit_lock_lost <= 1'b0;
            bit_lock_recovered <= 1'b0;
            bit_lock_hard_lost <= 1'b0;
            soft_loss_count <= 32'd0;
            hard_loss_count <= 32'd0;
        end else begin
            bit_locked_d <= bit_locked;
            bit_locked_soft_d <= bit_locked_soft;

            // 硬锁定获取
            if (bit_locked && !bit_locked_d) begin
                bit_lock_acquired <= 1'b1;
                if (bit_lock_lost) begin
                    bit_lock_recovered <= 1'b1;
                    $display("[%0t] ✓ Bit lock RECOVERED after interruption", $time);
                end else begin
                    $display("[%0t] ✓ Bit lock ACQUIRED (initial)", $time);
                end
            end

            // 硬锁定丢失
            if (!bit_locked && bit_locked_d) begin
                bit_lock_lost <= 1'b1;
                bit_lock_hard_lost <= 1'b1;
                hard_loss_count <= hard_loss_count + 1'b1;
                $display("[%0t] ✗ Bit lock HARD LOST", $time);
            end

            // 软失锁检测（硬锁定丢失但软锁定保持）
            if (!bit_locked && bit_locked_soft && bit_locked_d) begin
                soft_loss_count <= soft_loss_count + 1'b1;
                $display("[%0t] ⚠ Bit lock SOFT LOSS (保持软锁定)", $time);
            end

            // 从软失锁恢复
            if (bit_locked && !bit_locked_d && bit_locked_soft_d) begin
                $display("[%0t] ✓ Bit lock RECOVERED from soft loss", $time);
            end
        end
    end

    // 中断时间统计
    reg interrupt_start_time;
    reg [63:0] interrupt_start_ns;
    reg [63:0] interrupt_end_ns;

    always @(posedge line_clk) begin
        if (data_interrupt && !interrupt_start_time) begin
            interrupt_start_time <= 1'b1;
            interrupt_start_ns <= $time;
        end else if (!data_interrupt && interrupt_start_time) begin
            interrupt_start_time <= 1'b0;
            interrupt_end_ns <= $time;
            total_interrupt_time_ns <= interrupt_end_ns - interrupt_start_ns;
            $display("[%0t] 中断持续时间: %0d ns (%0.3f ms)", 
                     $time, total_interrupt_time_ns, total_interrupt_time_ns / 1000000.0);
        end
    end

    // ============================================================
    // 测试结果检查
    // ============================================================
    // 计算总仿真时间：
    // - 初始锁定：640us
    // - 测试1：640us正常 + 0.5ms衰落 + 1.28ms观察 = 2.42ms
    // - 测试2：640us正常 + 3ms衰落 + 1.28ms观察 = 4.92ms
    // - 测试3：640us正常 + 8ms衰落 + 3.2ms观察 = 11.84ms
    // - 测试4：640us正常 + 15ms衰落 + 6.4ms观察 = 22.04ms
    // 总计：约 42ms，加上间隔和结果检查，需要至少 50ms
    initial begin
        #(55000000); // 等待所有测试完成（55ms，确保覆盖所有测试）
        
        $display("\n========================================");
        $display("测试结果总结");
        $display("========================================");
        $display("线速率: 500Mbps");
        $display("线时钟频率: %0d MHz", LINE_CLK_FREQ / 1000000);
        $display("软失锁窗口: %0d 拍 (%0.3f ms)", 
                 SOFT_LOSS_TO, (SOFT_LOSS_TO * LINE_CLK_PERIOD) / 1000.0);
        $display("硬失锁窗口: %0d 拍 (%0.3f ms)", 
                 HARD_LOSS_TO, (HARD_LOSS_TO * LINE_CLK_PERIOD) / 1000.0);
        $display("\n统计信息:");
        $display("  软失锁次数: %0d", soft_loss_count);
        $display("  硬失锁次数: %0d", hard_loss_count);
        $display("  锁定恢复次数: %0d", bit_lock_recovered);
        
        $display("\n验证结果:");
        if (soft_loss_count > 0 && hard_loss_count == 0) begin
            $display("  ✓ 短/中等衰落测试通过：系统保持在软失锁状态");
        end
        if (hard_loss_count > 0) begin
            $display("  ⚠ 检测到硬失锁：可能衰落时间超过硬失锁窗口");
        end
        if (bit_lock_recovered > 0) begin
            $display("  ✓ 锁定恢复测试通过：系统能够从衰落中恢复");
        end
        
        $display("========================================\n");
    end

endmodule
