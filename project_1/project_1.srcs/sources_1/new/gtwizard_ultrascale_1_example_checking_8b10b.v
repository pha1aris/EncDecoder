`timescale 1ps/1ps
module gtwizard_ultrascale_1_example_checking_8b10b (
  input  wire         gtwiz_reset_all_in,
  input  wire         gtwiz_userclk_rx_usrclk2_in,
  input  wire         gtwiz_userclk_rx_active_in,
  input  wire  [15:0] rxctrl0_in,
  input  wire  [15:0] rxctrl1_in,
  input  wire   [7:0] rxctrl2_in,
  input  wire   [7:0] rxctrl3_in,
  input  wire  [31:0] rxdata_in,
  input  wire         rxbyteisaligned_in,   // ★ 新增：来自 gth_top 的对齐
  output reg          prbs_match_out = 1'b0
);

  // 同步复位

  wire example_checking_reset_int = gtwiz_reset_all_in || ~gtwiz_userclk_rx_active_in;
  wire example_checking_reset_sync;

  (* ASYNC_REG="TRUE" *) reg r0=1'b0,r1=1'b0,r2=1'b0,r3=1'b0; reg rs=1'b0;

  always @(posedge gtwiz_userclk_rx_usrclk2_in, posedge example_checking_reset_int) begin
    if (example_checking_reset_int) begin 
      r0<=1; r1<=1; r2<=1; r3<=1; rs<=1; 
    end
    else begin 
      r0<=1'b0; r1<=r0; r2<=r1; r3<=r2; rs<=r3; 
    end
  end
  assign example_checking_reset_sync = rs;


  wire [3:0] rxcharisk;
  assign rxcharisk = rxctrl2_in[3:0];
  // 合法数据拍：无 K、无 8b/10b 错、对齐稳定
  wire no_k      = (rxcharisk == 4'b0000);
  // 若你的版本把 DISPERR 在 rxctrl1[3:0]，可改为： (rxctrl3_in[3:0]==0) && (rxctrl1_in[3:0]==0)
  wire err_clean = (rxctrl3_in[3:0] == 4'b0000);

  // 对齐去抖（8 拍）
  reg [3:0] align_cnt = 4'd0;
  wire aligned_stable = (align_cnt == 4'd8);
  always @(posedge gtwiz_userclk_rx_usrclk2_in) begin
    if (example_checking_reset_sync || ~rxbyteisaligned_in) align_cnt <= 0;
    else if (!aligned_stable) align_cnt <= align_cnt + 1'b1;
  end

  wire prbs_any_chk_en_int = no_k & err_clean & aligned_stable;

  // 丢对齐 → 软复位 checker（避免相位漂移）
  wire checker_soft_reset = example_checking_reset_sync | (~rxbyteisaligned_in);

  // PRBS31 校验
  wire [31:0] prbs_err_bus;
  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE(1), .INV_PATTERN(1), .POLY_LENGHT(31), .POLY_TAP(28), .NBITS(32)
  ) u_prbs_chk (
    .RST      (checker_soft_reset),
    .CLK      (gtwiz_userclk_rx_usrclk2_in),
    .DATA_IN  (rxdata_in),
    .EN       (prbs_any_chk_en_int),
    .DATA_OUT (prbs_err_bus)
  );

  always @(posedge gtwiz_userclk_rx_usrclk2_in) begin
    if (checker_soft_reset) prbs_match_out <= 1'b0;
    else                    prbs_match_out <= ~(|prbs_err_bus);
  end
endmodule
