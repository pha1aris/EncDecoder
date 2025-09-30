//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//-----------------------------------------------------------------------------
// CRC module for data[15:0] ,   crc[15:0]=1+x^5+x^12+x^16;
//
// -- MODIFIED --
// - Added synchronous active-high clear signal 'clr'.
// - Changed reset to active-low 'rst_n' for convention.
//-----------------------------------------------------------------------------
module crc(
  input  wire [15:0] data_in,
  input  wire        crc_en,
  input  wire        clr,          // <-- 新增：同步清零信号，高有效
  output wire [15:0] crc_out,
  input  wire        rst_n,        // <-- 修改：改为低有效复位
  input  wire        clk
);

  reg [15:0] lfsr_q,lfsr_c;

  assign crc_out = lfsr_q;

  // 组合逻辑部分保持不变
  always @(*) begin
    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[12] ^ data_in[0] ^ data_in[4] ^ data_in[8] ^ data_in[11] ^ data_in[12];
    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[13] ^ data_in[1] ^ data_in[5] ^ data_in[9] ^ data_in[12] ^ data_in[13];
    lfsr_c[2] = lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[2] ^ data_in[6] ^ data_in[10] ^ data_in[13] ^ data_in[14];
    lfsr_c[3] = lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[3] ^ data_in[7] ^ data_in[11] ^ data_in[14] ^ data_in[15];
    lfsr_c[4] = lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[15] ^ data_in[4] ^ data_in[8] ^ data_in[12] ^ data_in[15];
    lfsr_c[5] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ data_in[0] ^ data_in[4] ^ data_in[5] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13];
    lfsr_c[6] = lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[1] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14];
    lfsr_c[7] = lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[2] ^ data_in[6] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    lfsr_c[8] = lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15];
    lfsr_c[9] = lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ data_in[4] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[15];
    lfsr_c[10] = lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[5] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14];
    lfsr_c[11] = lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[6] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15];
    lfsr_c[12] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[15] ^ data_in[0] ^ data_in[4] ^ data_in[7] ^ data_in[8] ^ data_in[15];
    lfsr_c[13] = lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[9] ^ data_in[1] ^ data_in[5] ^ data_in[8] ^ data_in[9];
    lfsr_c[14] = lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[10] ^ data_in[2] ^ data_in[6] ^ data_in[9] ^ data_in[10];
    lfsr_c[15] = lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[11] ^ data_in[3] ^ data_in[7] ^ data_in[10] ^ data_in[11];

  end // always

  // --- 时序逻辑部分已修改 ---
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin // 异步复位，优先级最高
      lfsr_q <= 16'hFFFF;
    end
    else begin
      if (clr) begin // 同步清零，优先级高于使能
        lfsr_q <= 16'hFFFF; // 将CRC寄存器恢复到初始值
      end
      else if (crc_en) begin // 当使能有效时，更新CRC值
        lfsr_q <= lfsr_c;
      end
      // 当 clr 和 crc_en 都无效时，lfsr_q 保持不变
    end
  end // always
endmodule // crc