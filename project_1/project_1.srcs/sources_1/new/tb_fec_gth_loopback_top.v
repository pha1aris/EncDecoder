`timescale 1ns/1ps
`define SIM

module tb_fec_gth_loopback_top;

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

    // MGT 参考时钟  125Mhz
    reg mgtrefclk0_x1y1_p;
    wire mgtrefclk0_x1y1_n = ~mgtrefclk0_x1y1_p;
    initial begin
        mgtrefclk0_x1y1_p = 0;
        forever begin
            #4 mgtrefclk0_x1y1_p = ~mgtrefclk0_x1y1_p;
        end
    end

    // GTH 差分 IO：仿真中不用，拉成常量即可
    wire gthrxp;
    wire gthrxn;

    wire [1:0] tx_disable;
    // ============================================================
    // 完整版回环测试仿真通过，上板测试未通过
    // 无门控版本环回测试 === 仿真测试通过、上板测试通过
    // ============================================================
    // fec_gth_loopback_top #(          //完整版本
    // fec_gth_loopback_top_nogate#(    //无门控版本
    //     .W                (32),
    //     .PAYLOAD_WORDS    (16),
    //     .RS_K             (229),
    //     .RS_N             (255),
    //     .INTLV_D          (64),
    //     .INTLV_N          (255),
    //     .FRAMES_PER_BLOCK (255)
    // ) dut (
    //     .sys_clk_p        (sys_clk_p),
    //     .sys_clk_n        (sys_clk_n),
    //     .sys_rst_n        (sys_rst_n),

    //     .mgtrefclk0_x1y1_p(mgtrefclk0_x1y1_p),
    //     .mgtrefclk0_x1y1_n(mgtrefclk0_x1y1_n),

    //     .gthrxp_in        (gthrxp),
    //     .gthrxn_in        (gthrxn),
    //     .gthtxp_out       (gthrxp),
    //     .gthtxn_out       (gthrxn),
    //     .sfp_loss         (2'd0),
    //     .tx_disable       (tx_disable)
    // );

    // ============================================================
    // 无fec版本，仅测试prbs 用于用于分析比对fec效果
    // ============================================================
    
    // gth_loopback_top_nofec #(
    //     .W                ( 32   ),
    //     .PAYLOAD_WORDS    ( 16   ),
    //     .RS_K             ( 229  ),
    //     .RS_N             ( 255  ),
    //     .INTLV_D          ( 64   ),
    //     .INTLV_N          ( 255  ),
    //     .FRAMES_PER_BLOCK ( 255  ),
    //     .LOCK_THRESH      ( 1024 ),
    //     .TEST_PRBS        ( 1    ))
    // u_gth_loopback_top_nofec (
    //     .sys_clk_p               ( sys_clk_p           ),
    //     .sys_clk_n               ( sys_clk_n           ),
    //     .sys_rst_n               ( sys_rst_n           ),
    //     .mgtrefclk0_x1y1_p       ( mgtrefclk0_x1y1_p   ),
    //     .mgtrefclk0_x1y1_n       ( mgtrefclk0_x1y1_n   ),
    //     .gthrxp_in               ( gthrxp              ),
    //     .gthrxn_in               ( gthrxn              ),
    //     .gthtxp_out              ( gthrxp              ),
    //     .gthtxn_out              ( gthrxn              ),
    //     .sfp_loss                ( 2'd0                ),
    //     .tx_disable              ( tx_disable          )
    // );

// ======================================-------------------分步测试部分---------------------==================================================
    // ============================================================
    // Stage 1 版本环回测试 ： framer - bit align - deframer ====测试通过
    // ============================================================
    fec_gth_loopback_top_s1 #(
        .W                (32),
        .PAYLOAD_WORDS     (16),
        .FRAMES_PER_BLOCK  (255)
        // .IGNORE_SFP_LOSS   (1)   
    ) dut_s1     (
        .sys_clk_p         (sys_clk_p),
        .sys_clk_n         (sys_clk_n),
        .sys_rst_n         (sys_rst_n),

        .mgtrefclk0_x1y1_p (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n (mgtrefclk0_x1y1_n),

        .gthrxp_in        (gthrxp),
        .gthrxn_in        (gthrxn),
        .gthtxp_out       (gthrxp),
        .gthtxn_out       (gthrxn),
        // .gthrxp_in         (gthrxp),
        // .gthrxn_in         (gthrxn),
        // .gthtxp_out        (gthtxp),
        // .gthtxn_out        (gthtxn),
        .sfp_loss          (2'd0),
        .tx_disable        (tx_disable)
    );
    // ============================================================
    // Stage 2 版本环回测试 ： Stage 1 基础上加入 encode decode ===测试未通过 
    // ============================================================
    // fec_gth_loopback_top_s2 #(
    //     .W                 (32),
    //     .PAYLOAD_WORDS     (16)
    // )dut_s2(
    //     .sys_clk_p         (sys_clk_p),
    //     .sys_clk_n         (sys_clk_n),
    //     .sys_rst_n         (sys_rst_n),

    //     .mgtrefclk0_x1y1_p (mgtrefclk0_x1y1_p),
    //     .mgtrefclk0_x1y1_n (mgtrefclk0_x1y1_n),

    //     .gthrxp_in        (gthrxp),
    //     .gthrxn_in        (gthrxn),
    //     .gthtxp_out       (gthrxp),
    //     .gthtxn_out       (gthrxn),

    //     .sfp_loss          (2'd0),
    //     .tx_disable        (tx_disable)
    // );

    // ------------------------------------------------------------
    // 仿真监控：bit_aligner 锁定、PRBS 锁定 & BER 统计
    // // ------------------------------------------------------------
    // initial begin
    //     // @(posedge sys_rst_n);
    //     // $display("[%0t] Reset deasserted, start top-level simulation.", $time);

    //     // 等 GTH stub 激活（rx_active 是 gth_raw_top 的 o_rx_active）
    //     // wait (dut.rx_active === 1'b1);
    //     // $display("[%0t] RX active.", $time);

    //     // 等物理层 bit_aligner 锁定（来自 fec_rx）
    //     // wait (dut.bit_locked === 1'b1);
    //     // $display("[%0t] Bit align locked.", $time);

    //     // 等 PRBS 检查器锁定
    //     // wait (dut.prbs_lock_reg === 1'b1);
    //     // $display("[%0t] PRBS checker locked.", $time);

    //     // 再跑一段时间，收集 BER 统计
    //     // #1_000_000;  // 1 ms 仿真时间

    //     // $display("--------------------------------------------------");
    //     // $display("PRBS rx bits  = %0d", dut.prbs_rx_bits);
    //     // $display("PRBS err bits = %0d", dut.prbs_err_bits);
    //     // $display("BER Q0.32     = 0x%08x", dut.ber_q32);
    //     // $display("--------------------------------------------------");

    //     // if (dut.prbs_err_bits !== 0) begin
    //     //     $display("!!! ERROR: PRBS errors detected in top-level loopback !!!");
    //     // end else begin
    //     //     $display("Simulation PASS: no PRBS error in loopback.");
    //     // end

    //     // $finish;
    // end

// 信道模型:
    // fso_channel_ge_serial  #(
    //     .P(16),
    //     .P_GB     (13),
    //     .P_BG     (524),
    //     .FLIP_BAD (7864),
    //     .DROP_BAD (655),
    //     .DROP_MODE(2),
    //     .SEED     (32'h1ACE_B00C)
    // ) u_ch (
    //     .clk   (mgtrefclk0_x1y1_p), // choose a fast clock as "line timebase"
    //     .rst_n (sys_rst_n),

    //     .txp_in (gthtxp),
    //     .txn_in (gthtxn),
    //     .rxp_out(gthrxp),
    //     .rxn_out(gthrxn)
    // );


endmodule
