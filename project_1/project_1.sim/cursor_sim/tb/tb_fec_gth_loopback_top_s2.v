`timescale 1ns/1ps
`define SIM

module tb_fec_gth_loopback_top_s2;

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

    // GTH 差分 IO
    wire gthrxp;
    wire gthrxn;
    wire gthtxp;
    wire gthtxn;

    wire [1:0] tx_disable;

    // ============================================================
    // DUT：Stage2 顶层（bit同步 + 帧同步 + RS(255,229) + PRBS）
    // ============================================================
    fec_gth_loopback_top_s2 #(
        .W                 (32),
        .PAYLOAD_WORDS     (16),
        .RS_K              (229),
        .RS_N              (255),
        .INTLV_D           (64),
        .INTLV_N           (255),
        .FRAMES_PER_BLOCK  (255),
        .IGNORE_SFP_LOSS   (1)    // 仿真/板上内部环回时建议=1
    ) dut_s2 (
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

    // 信道模型
    fso_channel_ge_serial  #(
        .P(16),
        .P_GB     (13),
        .P_BG     (524),
        .FLIP_BAD (7864),
        .DROP_BAD (655),
        .DROP_MODE(2),
        .SEED     (32'h1ACE_B00C)
    ) u_ch (
        .clk   (mgtrefclk0_x1y1_p), // choose a fast clock as "line timebase"
        .rst_n (sys_rst_n),

        .txp_in (gthtxp),
        .txn_in (gthtxn),
        .rxp_out(gthrxp),
        .rxn_out(gthrxn)
    );

endmodule
