`timescale 1ns/1ps
`define SIM

// S4 测试平台：fec_gth_loopback_top_s2 整体测试
// 目标：仿真 10ms，得到稳定的 PRBS match 信号
// 包含信道模型、PRBS 监控和状态报告
module tb_fec_loopback_s4;

    //================================================================
    // 0. 仿真参数
    //================================================================
    // 仿真时间控制（10ms = 10_000_000 ns）
    localparam real SIM_TIME_MS = 10.0;
    localparam real SIM_TIME_NS = SIM_TIME_MS * 1_000_000;
    
    // 状态报告间隔（每 1ms 报告一次）
    localparam real REPORT_INTERVAL_NS = 1_000_000;
    
    // PRBS 稳定判断：连续稳定时间阈值（500us）
    localparam real PRBS_STABLE_THRESHOLD_NS = 500_000;

    //================================================================
    // 1. 时钟生成
    //================================================================
    // 系统差分时钟 200 MHz
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
        $display("[%0t] Reset released", $time);
    end

    // MGT 参考时钟 125 MHz
    reg mgtrefclk0_x1y1_p;
    wire mgtrefclk0_x1y1_n = ~mgtrefclk0_x1y1_p;
    initial begin
        mgtrefclk0_x1y1_p = 0;
        forever begin
            #4 mgtrefclk0_x1y1_p = ~mgtrefclk0_x1y1_p;
        end
    end

    //================================================================
    // 2. GTH 差分 IO
    //================================================================
    wire gthrxp;
    wire gthrxn;
    wire gthtxp;
    wire gthtxn;
    wire [1:0] tx_disable;

    //================================================================
    // 3. DUT：fec_gth_loopback_top_s2
    //================================================================
    fec_gth_loopback_top_s2 #(
        .W                 (32),
        .PAYLOAD_WORDS     (16),
        .RS_K              (229),
        .RS_N              (255),
        .INTLV_D           (64),
        .INTLV_N           (255),
        .FRAMES_PER_BLOCK  (255),
        .IGNORE_SFP_LOSS   (1)    // 仿真/板上内部环回时建议=1
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

    //================================================================
    // 4. 信道模型（使用 GTH 内部环回模式时不需要）
    //================================================================
    // 当使用 GTH 内部环回模式 (loop_backmode=3'b001) 时，
    // 数据在 GTH 内部回环，不经过串行接口，因此不需要外部信道模型。
    // 直接连接 TX 到 RX 作为占位符（实际上内部环回模式下这些信号不使用）
    assign gthrxp = gthtxp;
    assign gthrxn = gthtxn;
    
    // 如果需要测试带信道模型的完整链路，需要：
    // 1. 使用外部环回模式 (loop_backmode=3'b000)
    // 2. GTH 仿真模型需要支持串行传输
    // 3. 或创建数据路径级别的测试平台（绕过 GTH）
    
    // 保留信道模型代码以备将来使用：
    // fso_channel_ge_serial #(
    //     .P        (16),
    //     .P_GB     (13),
    //     .P_BG     (524),
    //     .FLIP_BAD (7864),
    //     .DROP_BAD (655),
    //     .DROP_MODE(2),
    //     .SEED     (32'h1ACE_B00C)
    // ) u_channel (
    //     .clk     (mgtrefclk0_x1y1_p),
    //     .rst_n   (sys_rst_n),
    //     .txp_in  (gthtxp),
    //     .txn_in  (gthtxn),
    //     .rxp_out (gthrxp),
    //     .rxn_out (gthrxn)
    // );

    //================================================================
    // 5. 状态监控
    //================================================================
    // 访问 DUT 内部信号
    wire bit_locked    = dut.bit_locked_core;
    wire frame_locked  = dut.frame_locked_core;
    wire prbs_meas_ok  = dut.prbs_meas_ok;
    wire [7:0] prbs_err_vec = dut.prbs_err_vec;
    wire prbs_match    = (prbs_err_vec == 8'h00);
    wire [63:0] total_bits = dut.total_bits_cnt;
    wire [63:0] total_errs = dut.total_err_cnt;
    wire [31:0] ber_out    = dut.ber_out;

    // 统计变量
    reg bit_locked_ever;
    reg frame_locked_ever;
    reg prbs_match_ever;
    real first_bit_locked_time;
    real first_frame_locked_time;
    real first_prbs_match_time;
    real prbs_stable_start_time;
    reg prbs_stable_achieved;
    
    integer report_cnt;
    real last_report_time;

    initial begin
        bit_locked_ever = 0;
        frame_locked_ever = 0;
        prbs_match_ever = 0;
        first_bit_locked_time = 0;
        first_frame_locked_time = 0;
        first_prbs_match_time = 0;
        prbs_stable_start_time = 0;
        prbs_stable_achieved = 0;
        report_cnt = 0;
        last_report_time = 0;
    end

    //================================================================
    // 6. 状态检测和报告
    //================================================================
    always @(posedge sys_clk_p) begin
        if (sys_rst_n) begin
            // 检测 bit_locked 首次锁定
            if (bit_locked && !bit_locked_ever) begin
                bit_locked_ever <= 1;
                first_bit_locked_time <= $realtime;
                $display("[%0t] *** BIT_LOCKED achieved ***", $time);
            end
            
            // 检测 frame_locked 首次锁定
            if (frame_locked && !frame_locked_ever) begin
                frame_locked_ever <= 1;
                first_frame_locked_time <= $realtime;
                $display("[%0t] *** FRAME_LOCKED achieved ***", $time);
            end
            
            // 检测 PRBS match 首次达成
            if (prbs_meas_ok && prbs_match && !prbs_match_ever) begin
                prbs_match_ever <= 1;
                first_prbs_match_time <= $realtime;
                prbs_stable_start_time <= $realtime;
                $display("[%0t] *** PRBS_MATCH first achieved ***", $time);
            end
            
            // 检测 PRBS 稳定（连续匹配超过阈值时间）
            if (prbs_meas_ok && prbs_match) begin
                if (prbs_match_ever && !prbs_stable_achieved) begin
                    if (($realtime - prbs_stable_start_time) >= PRBS_STABLE_THRESHOLD_NS) begin
                        prbs_stable_achieved <= 1;
                        $display("[%0t] *** PRBS STABLE achieved (>%.0f us) ***", 
                                 $time, PRBS_STABLE_THRESHOLD_NS/1000);
                    end
                end
            end else begin
                // PRBS 不匹配，重置稳定计时
                if (prbs_match_ever) begin
                    prbs_stable_start_time <= $realtime;
                end
            end
        end
    end

    // 定期状态报告
    always @(posedge sys_clk_p) begin
        if (sys_rst_n && ($realtime - last_report_time) >= REPORT_INTERVAL_NS) begin
            last_report_time <= $realtime;
            report_cnt <= report_cnt + 1;
            
            $display("========== Status Report #%0d at %0t (%.1f ms) ==========", 
                     report_cnt, $time, $realtime/1_000_000);
            $display("  bit_locked:   %b (first at %.3f ms)", 
                     bit_locked, first_bit_locked_time/1_000_000);
            $display("  frame_locked: %b (first at %.3f ms)", 
                     frame_locked, first_frame_locked_time/1_000_000);
            $display("  prbs_meas_ok: %b", prbs_meas_ok);
            $display("  prbs_match:   %b (first at %.3f ms)", 
                     prbs_match, first_prbs_match_time/1_000_000);
            $display("  prbs_err_vec: 0x%02h", prbs_err_vec);
            $display("  total_bits:   %0d", total_bits);
            $display("  total_errs:   %0d", total_errs);
            $display("  BER output:   0x%08h", ber_out);
            $display("  PRBS stable:  %b", prbs_stable_achieved);
            $display("");
        end
    end

    //================================================================
    // 7. 仿真结束判断
    //================================================================
    initial begin
        // 等待仿真时间结束
        #(SIM_TIME_NS);
        
        $display("");
        $display("================================================================================");
        $display("                          SIMULATION COMPLETE");
        $display("================================================================================");
        $display("  Simulation time: %.1f ms", $realtime/1_000_000);
        $display("");
        $display("  Final Status:");
        $display("    bit_locked:     %b", bit_locked);
        $display("    frame_locked:   %b", frame_locked);
        $display("    prbs_meas_ok:   %b", prbs_meas_ok);
        $display("    prbs_match:     %b", prbs_match);
        $display("    prbs_err_vec:   0x%02h", prbs_err_vec);
        $display("");
        $display("  Statistics:");
        $display("    Total bits:     %0d", total_bits);
        $display("    Total errors:   %0d", total_errs);
        $display("    BER output:     0x%08h", ber_out);
        $display("");
        $display("  Milestones:");
        $display("    bit_locked first:   %.3f ms", first_bit_locked_time/1_000_000);
        $display("    frame_locked first: %.3f ms", first_frame_locked_time/1_000_000);
        $display("    prbs_match first:   %.3f ms", first_prbs_match_time/1_000_000);
        $display("    prbs_stable:        %s", prbs_stable_achieved ? "YES" : "NO");
        $display("");
        
        // 判断测试结果
        if (prbs_stable_achieved) begin
            $display("  Result: *** PASS - PRBS MATCH STABLE ***");
        end else if (prbs_match_ever) begin
            $display("  Result: PARTIAL - PRBS matched but not stable");
        end else if (frame_locked_ever) begin
            $display("  Result: PARTIAL - Frame locked but no PRBS match");
        end else if (bit_locked_ever) begin
            $display("  Result: PARTIAL - Bit locked but no frame lock");
        end else begin
            $display("  Result: FAIL - No bit lock achieved");
        end
        
        $display("================================================================================");
        $finish;
    end

    // 超时保护
    initial begin
        #(SIM_TIME_NS + 1_000_000);  // 额外 1ms 超时
        $display("[%0t] TIMEOUT: Simulation exceeded expected time", $time);
        $finish;
    end

endmodule
