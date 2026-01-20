`timescale 1ns/1ps

// ============================================================
// 数据完全中断恢复测试
// 测试场景：
// 1. 正常传输一段时间，建立 bit_locked 和 frame_locked
// 2. 数据完全中断（模拟激光通信中的遮挡、大气湍流等）
// 3. 中断持续一段时间
// 4. 数据恢复
// 5. 验证系统能否重新锁定
// ============================================================

module tb_data_interrupt_recovery;

    // ============================================================
    // 参数配置
    // ============================================================
    localparam integer W              = 32;
    localparam integer PAYLOAD_WORDS  = 16;
    localparam integer LINE_CLK_FREQ  = 312500000;  // 312.5 MHz
    localparam integer CORE_CLK_FREQ  = 156250000;  // 156.25 MHz
    localparam real    LINE_CLK_PERIOD = 1000.0 / LINE_CLK_FREQ;
    localparam real    CORE_CLK_PERIOD = 1000.0 / CORE_CLK_FREQ;

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
    // 中断控制信号
    // ============================================================
    reg data_interrupt;      // 数据中断标志
    reg link_down;           // 链路断开标志
    reg cdr_unstable;        // CDR 不稳定标志

    // 中断时序控制
    localparam integer NORMAL_TIME_NS    = 10000;  // 正常传输 10us
    localparam integer INTERRUPT_TIME_NS = 5000;   // 中断持续 5us
    localparam integer RECOVERY_TIME_NS  = 20000;  // 恢复后观察 20us

    initial begin
        data_interrupt = 0;
        link_down      = 0;
        cdr_unstable   = 0;

        // 阶段1: 正常传输
        #(NORMAL_TIME_NS);

        // 阶段2: 数据完全中断
        $display("[%0t] ========================================", $time);
        $display("[%0t] 数据中断开始", $time);
        $display("[%0t] ========================================", $time);
        data_interrupt = 1;
        link_down      = 1;
        cdr_unstable   = 1;
        #(INTERRUPT_TIME_NS);

        // 阶段3: 数据恢复
        $display("[%0t] ========================================", $time);
        $display("[%0t] 数据恢复开始", $time);
        $display("[%0t] ========================================", $time);
        data_interrupt = 0;
        link_down      = 0;
        cdr_unstable   = 0;
        #(RECOVERY_TIME_NS);

        $display("[%0t] ========================================", $time);
        $display("[%0t] 测试完成", $time);
        $display("[%0t] ========================================", $time);
        $finish;
    end

    // ============================================================
    // 数据生成器（正常传输时生成有效数据）
    // ============================================================
    reg [W-1:0] tx_data;
    reg         tx_valid;
    reg [15:0]  block_id;
    reg [15:0]  frame_in_block;
    reg [15:0]  payload_word_cnt;
    reg [2:0]   frame_state;  // 0: PREAMBLE_HI, 1: PREAMBLE_LO, 2: HEADER, 3: PAYLOAD, 4: CRC

    localparam [31:0] PREAMBLE_HI = 32'hEB94_BDA3;
    localparam [31:0] PREAMBLE_LO = 32'hF6AA_EE24;
    localparam [31:0] IDLE_WORD   = 32'h0707_0707;

    // 简单的 CRC32 计算（用于生成测试数据）
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
                // 中断期间：不发送数据或发送无效数据
                tx_data  <= 32'h0;
                tx_valid <= 1'b0;
            end else begin
                // 正常传输
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
                        // 更新 block_id 和 frame_in_block
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
    // 同步系统实例化（使用改进的模块）
    // ============================================================
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    wire         bit_locked;
    wire         rx_slide_req;

    // bit_aligner 控制信号
    wire rx_reset_done = rst_n && !link_down && !cdr_unstable;
    wire rx_cdr_stable = rst_n && !cdr_unstable;
    wire [5:0]  cfg_err_th         = 6'd2;
    wire [7:0]  cfg_verify_cnt_max  = 8'd8;
    wire [15:0] cfg_lock_loss_to    = 16'd1000;

    bit_aligner_ind #(
        .W                 (W),
        .IDLE_WORD         (IDLE_WORD),
        .LOCK_LOSS_TIMEOUT (4096)
    ) u_bit_aligner (
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
        .o_rxslide          (),
        .o_aligned_valid    (aligned_valid),
        .o_bit_locked       (bit_locked),
        .o_data_aligned     (aligned_data)
    );

    // ============================================================
    // Async FIFO: line_clk -> core_clk
    // ============================================================
    wire [W-1:0] fifo_dout;
    wire         fifo_empty;
    wire         fifo_rd_en;

    // 简化的 FIFO 模型（实际应使用 async_fifo_32w_32r）
    reg [W-1:0] fifo_mem [0:15];
    reg [3:0]   fifo_wr_ptr;
    reg [3:0]   fifo_rd_ptr;
    reg [4:0]   fifo_count;

    assign fifo_empty = (fifo_count == 0);
    assign fifo_rd_en = !fifo_empty && 1'b1;  // 总是读取（简化）

    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_wr_ptr <= 4'd0;
            fifo_count  <= 5'd0;
        end else begin
            if (aligned_valid && aligned_data != 32'h0) begin
                if (fifo_count < 16) begin
                    fifo_mem[fifo_wr_ptr] <= aligned_data;
                    fifo_wr_ptr <= fifo_wr_ptr + 1'b1;
                    fifo_count  <= fifo_count + 1'b1;
                end
            end
        end
    end

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_rd_ptr <= 4'd0;
        end else begin
            if (fifo_rd_en && !fifo_empty) begin
                fifo_rd_ptr <= fifo_rd_ptr + 1'b1;
                fifo_count  <= fifo_count - 1'b1;
            end
        end
    end

    assign fifo_dout = fifo_mem[fifo_rd_ptr];

    // ============================================================
    // Deframer
    // ============================================================
    wire [W-1:0] payload_data;
    wire         payload_valid;
    wire         frame_locked;
    wire         frame_start;
    wire [15:0]  rx_block_id;
    wire [15:0]  rx_frame_in_block;
    wire         realign_req;
    wire [31:0]  total_frames;
    wire [31:0]  crc_error_frames;
    wire [31:0]  fer_q32;

    wire i_link_up = rst_n && !link_down;
    wire s_axis_tvalid = !fifo_empty;
    wire s_axis_tready = 1'b1;

    // 使用改进的 deframer wrapper
    wire [1:0] m_axis_tuser;
    fso_deframer #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (256)
    ) u_deframer (
        .clk                (core_clk),
        .rst_n              (rst_n),
        .i_link_up          (i_link_up),
        .s_axis_tdata       (fifo_dout),
        .s_axis_tvalid      (s_axis_tvalid),
        .s_axis_tready      (s_axis_tready),
        .scrambler_en       (1'b0),
        .m_axis_tdata       (payload_data),
        .m_axis_tuser       (m_axis_tuser),
        .m_axis_tvalid      (payload_valid),
        .m_axis_tready      (1'b1),
        .o_realign_req      (realign_req),
        .o_frame_start      (frame_start),
        .o_frame_index      (),
        .o_block_id         (rx_block_id),
        .o_frame_in_block   (rx_frame_in_block),
        .o_blk_soft_rst     (),
        .o_frame_locked     (frame_locked),
        .o_block_aligned     (),
        .cfg_frame_timeout_max (16'd256),
        .cfg_crc_bad_th     (8'd8),
        .cfg_pre_bad_th     (8'd8),
        .cfg_realign_or     (1'b0),
        .o_total_frames     (total_frames),
        .o_crc_error_frames (crc_error_frames),
        .o_fer_q32          (fer_q32)
    );

    // realign_req 同步回 bit_aligner（简化处理）
    reg [2:0] realign_sync;
    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) realign_sync <= 3'd0;
        else       realign_sync <= {realign_sync[1:0], realign_req};
    end
    assign rx_slide_req = realign_sync[2];

    // ============================================================
    // 监控和统计
    // ============================================================
    reg bit_locked_d;
    reg frame_locked_d;
    reg bit_lock_acquired;
    reg frame_lock_acquired;
    reg bit_lock_lost;
    reg frame_lock_lost;
    reg bit_lock_recovered;
    reg frame_lock_recovered;

    always @(posedge line_clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_locked_d <= 1'b0;
            bit_lock_acquired <= 1'b0;
            bit_lock_lost <= 1'b0;
            bit_lock_recovered <= 1'b0;
        end else begin
            bit_locked_d <= bit_locked;
            if (bit_locked && !bit_locked_d) begin
                bit_lock_acquired <= 1'b1;
                if (bit_lock_lost) begin
                    bit_lock_recovered <= 1'b1;
                    $display("[%0t] ✓ Bit lock RECOVERED after interruption", $time);
                end else begin
                    $display("[%0t] ✓ Bit lock ACQUIRED (initial)", $time);
                end
            end
            if (!bit_locked && bit_locked_d) begin
                bit_lock_lost <= 1'b1;
                $display("[%0t] ✗ Bit lock LOST", $time);
            end
        end
    end

    always @(posedge core_clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_locked_d <= 1'b0;
            frame_lock_acquired <= 1'b0;
            frame_lock_lost <= 1'b0;
            frame_lock_recovered <= 1'b0;
        end else begin
            frame_locked_d <= frame_locked;
            if (frame_locked && !frame_locked_d) begin
                frame_lock_acquired <= 1'b1;
                if (frame_lock_lost) begin
                    frame_lock_recovered <= 1'b1;
                    $display("[%0t] ✓ Frame lock RECOVERED after interruption", $time);
                end else begin
                    $display("[%0t] ✓ Frame lock ACQUIRED (initial)", $time);
                end
            end
            if (!frame_locked && frame_locked_d) begin
                frame_lock_lost <= 1'b1;
                $display("[%0t] ✗ Frame lock LOST", $time);
            end
        end
    end

    // ============================================================
    // 测试结果检查
    // ============================================================
    initial begin
        #(NORMAL_TIME_NS + INTERRUPT_TIME_NS + RECOVERY_TIME_NS + 1000);
        
        $display("\n========================================");
        $display("测试结果总结");
        $display("========================================");
        $display("初始锁定:");
        $display("  Bit lock acquired:  %0s", bit_lock_acquired ? "✓ YES" : "✗ NO");
        $display("  Frame lock acquired: %0s", frame_lock_acquired ? "✓ YES" : "✗ NO");
        $display("\n中断后恢复:");
        $display("  Bit lock recovered:  %0s", bit_lock_recovered ? "✓ YES" : "✗ NO");
        $display("  Frame lock recovered: %0s", frame_lock_recovered ? "✓ YES" : "✗ NO");
        $display("\n帧统计:");
        $display("  Total frames:      %0d", total_frames);
        $display("  CRC error frames:  %0d", crc_error_frames);
        if (total_frames > 0) begin
            $display("  FER:               %0.6f%%", (crc_error_frames * 100.0) / total_frames);
        end
        
        if (bit_lock_recovered && frame_lock_recovered) begin
            $display("\n✓✓✓ 测试通过：系统能够在数据中断后重新锁定！");
        end else begin
            $display("\n✗✗✗ 测试失败：系统未能完全恢复锁定");
            if (!bit_lock_recovered) $display("  - Bit lock 未能恢复");
            if (!frame_lock_recovered) $display("  - Frame lock 未能恢复");
        end
        $display("========================================\n");
    end

endmodule
