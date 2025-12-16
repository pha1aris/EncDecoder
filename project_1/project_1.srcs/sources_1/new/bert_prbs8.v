module bert_prbs8 #(
  parameter integer NBITS            = 8,
  parameter integer POLY_LENGHT      = 7,
  parameter integer POLY_TAP         = 6,
  parameter integer LOCK_GOOD_TH     = 1024,  // 连续 good 才锁
  parameter integer MASK_WAIT_CYCLES = 1024,  // 锁后 mask
  parameter integer GAP_TIMEOUT      = 256,   // valid 断流阈值（单位：clk）
  parameter integer CONSEC_BAD_TH    = 32     // 连续 bad 掉锁
)(
  input  wire               clk,
  input  wire               rst,       // 同步高复位
  input  wire               clr,       // 清零/重测
  input  wire               link_up,   // 物理链路 OK（建议 bit_locked && frame_locked）
  input  wire [NBITS-1:0]   data_in,
  input  wire               data_valid,

  output wire [NBITS-1:0]   err_vec,
  output reg                locked,
  output reg                ber_enable,
  output reg  [63:0]        total_bits,
  output reg  [63:0]        total_err
);

  // popcount
  function [3:0] popcount8(input [7:0] v);
    integer k;
    begin
      popcount8 = 0;
      for (k=0;k<8;k=k+1) popcount8 = popcount8 + v[k];
    end
  endfunction

  wire err_any;
  wire [3:0] err_bits = popcount8(err_vec);
  assign err_any = |err_vec;

  // 断流与掉锁控制
  reg [$clog2(GAP_TIMEOUT+1)-1:0] gap_cnt;
  reg [$clog2(CONSEC_BAD_TH+1)-1:0] bad_run;
  reg [31:0] good_run;
  reg [$clog2(MASK_WAIT_CYCLES+1)-1:0] mask_cnt;

  // 给 prbs_any 的同步复位：掉锁/断流/链路down 时强制复位，避免“暂停后相位乱”
  reg prbs_rst_req;
  always @(posedge clk) begin
    prbs_rst_req <= 1'b0;
    if (rst || clr || !link_up) prbs_rst_req <= 1'b1;
    else if (locked && (gap_cnt == GAP_TIMEOUT-1)) prbs_rst_req <= 1'b1;
    else if (locked && (bad_run  == CONSEC_BAD_TH-1)) prbs_rst_req <= 1'b1;
  end

  gtwizard_ultrascale_0_prbs_any #(
    .CHK_MODE    (1),
    .INV_PATTERN (0),
    .POLY_LENGHT (POLY_LENGHT),
    .POLY_TAP    (POLY_TAP),
    .NBITS       (NBITS)
  ) u_prbs_chk (
    .RST      (rst || clr || !link_up || prbs_rst_req),
    .CLK      (clk),
    .DATA_IN  (data_in),
    .EN       (data_valid),     // 仍然只在 valid beat 时“取样”；但断流会触发掉锁+复位
    .DATA_OUT (err_vec)
  );

  always @(posedge clk) begin
    if (rst || clr || !link_up) begin
      locked     <= 1'b0;
      ber_enable <= 1'b0;
      total_bits <= 64'd0;
      total_err  <= 64'd0;

      gap_cnt  <= 'd0;
      bad_run  <= 'd0;
      good_run <= 32'd0;
      mask_cnt <= 'd0;
    end else begin
      // 断流统计：valid 低就累加；valid 一来就清零
      if (!data_valid) begin
        if (gap_cnt != GAP_TIMEOUT) gap_cnt <= gap_cnt + 1'b1;
      end else begin
        gap_cnt <= 'd0;
      end

      if (data_valid) begin
        if (!locked) begin
          ber_enable <= 1'b0;
          mask_cnt   <= 'd0;
          bad_run    <= 'd0;

          if (!err_any) begin
            if (good_run == LOCK_GOOD_TH-1) begin
              locked   <= 1'b1;
              good_run <= 32'd0;
            end else begin
              good_run <= good_run + 1'b1;
            end
          end else begin
            good_run <= 32'd0;
          end
        end else begin
          // locked 状态：连续 bad 掉锁
          if (err_any) begin
            if (bad_run == CONSEC_BAD_TH-1) begin
              locked <= 1'b0;
              bad_run <= 'd0;
              ber_enable <= 1'b0;
              mask_cnt <= 'd0;
            end else bad_run <= bad_run + 1'b1;
          end else begin
            bad_run <= 'd0;
          end

          // mask → 统计
          if (mask_cnt < MASK_WAIT_CYCLES) begin
            mask_cnt <= mask_cnt + 1'b1;
            ber_enable <= 1'b0;
          end else begin
            ber_enable <= 1'b1;
            total_bits <= total_bits + NBITS;
            if (err_any) total_err <= total_err + err_bits;
          end
        end
      end
    end
  end

endmodule
