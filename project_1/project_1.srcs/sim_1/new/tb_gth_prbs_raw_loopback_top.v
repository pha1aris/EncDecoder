`timescale 1ns/1ps

module tb_gth_prbs_raw_loopback_top;

  // =========================
  // Clocks / Reset
  // =========================
  reg sys_clk_p = 1'b0;   // 200MHz
  reg sys_clk_n = 1'b1;
  reg sys_rst_n = 1'b0;   // active-low

  reg mgtrefclk0_x1y1_p = 1'b0; // 125MHz
  reg mgtrefclk0_x1y1_n = 1'b1;

  wire gthtxp;
  wire gthtxn;

  wire [1:0] tx_disable;

  // sys_clk: 200MHz -> period 5ns
  always #2.5 begin
    sys_clk_p <= ~sys_clk_p;
    sys_clk_n <= ~sys_clk_n;
  end

  // mgtrefclk: 125MHz -> period 8ns
  always #4.0 begin
    mgtrefclk0_x1y1_p <= ~mgtrefclk0_x1y1_p;
    mgtrefclk0_x1y1_n <= ~mgtrefclk0_x1y1_n;
  end

  // =========================
  // DUT
  // =========================
  gth_prbs_raw_loopback_top dut (
    .sys_clk_p(sys_clk_p),
    .sys_clk_n(sys_clk_n),
    .sys_rst_n(sys_rst_n),

    .tx_disable(tx_disable),

    .mgtrefclk0_x1y1_p(mgtrefclk0_x1y1_p),
    .mgtrefclk0_x1y1_n(mgtrefclk0_x1y1_n),

    .gthrxp_in(gthtxp),
    .gthrxn_in(gthtxn),
    .gthtxp_out(gthtxp),
    .gthtxn_out(gthtxn)
  );

  // =========================
  // Reset sequence
  // =========================
  initial begin
    // 保持复位一段时间
    sys_rst_n = 1'b0;
    #200;                 // 200ns
    sys_rst_n = 1'b1;

    // 运行一段时间观察（例如 2ms）
    #2_000_000;

    $finish;
  end

  // =========================
  // Optional waveform dump
  // =========================
  initial begin
    $dumpfile("tb_gth_prbs_raw_loopback_top.vcd");
    $dumpvars(0, tb_gth_prbs_raw_loopback_top);
  end

endmodule
