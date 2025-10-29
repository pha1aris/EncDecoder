`timescale 1ns / 1ps
//
// 模块: frame_synchronizer_pipelined 4-clk pipline 
// 功能: 并行滑动窗口匹配引擎
//
module frame_synchronizer_pipelined #(
    parameter PARALLEL        = 32,
    parameter MASK_LEN        = 192,
    parameter ASM_LEN         = 32,
    parameter TOLERANCE       = 4,
    parameter FRAME_LEN_BYTE  = 15,
    parameter M_VERIFY        = 3,
    parameter N_PROTECT       = 2
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [PARALLEL-1:0]    din,
    input  wire                   din_valid,
    input  wire [MASK_LEN-1:0]    asm_pattern,
    input  wire [MASK_LEN-1:0]    asm_mask,
    output wire [PARALLEL-1:0]    wflag_reg_out_wire,
    output reg  [PARALLEL-1:0]    wflag_reg_out
);

    // === 常量定义 ===
    localparam NSEG = MASK_LEN / 8;         // 192/8 = 24
    localparam BYTES_PER_CYCLE = PARALLEL / 8;
    localparam SHIFT_BUF_W = MASK_LEN + (PARALLEL - 1);
    localparam GROUP_SZ = 3;
    localparam NG1 = NSEG / GROUP_SZ;       // 24/3 = 8

    // === 内部寄存器 ===
    reg [SHIFT_BUF_W-1:0] shift_buf;
    wire [MASK_LEN-1:0] windows [0:PARALLEL-1];

    reg [7:0] pipeA_seg_bytes [0:PARALLEL-1][0:NSEG-1];
    reg [3:0] pipeB_seg_pops  [0:PARALLEL-1][0:NSEG-1];
    reg [7:0] pipeC_group_sums[0:PARALLEL-1][0:NG1-1];

    integer win_idx, seg_idx, grp_idx;
    genvar gi, gj, gk;

    // === 1. 滑动缓冲区 ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_buf <= {SHIFT_BUF_W{1'b0}};
        else if (din_valid)
        shift_buf <= { shift_buf[SHIFT_BUF_W-PARALLEL-1:0], din };
    end
    // === 2. 窗口展开 ===
    generate
        for (gi = 0; gi < PARALLEL; gi = gi + 1) begin : gen_windows
            // assign windows[gi] = shift_buf[gi +: MASK_LEN];
            // 从低位开始取 MASK_LEN 位
            assign windows[gi] = shift_buf[gi +: MASK_LEN];
        end
    endgenerate

    // === 3. 流水线阶段A (异或 + 掩码) ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeA_seg_bytes[win_idx][seg_idx] <= 8'hFF;
        end else if (din_valid) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    // pipeA_seg_bytes[win_idx][seg_idx] <= 
                    //     ( windows[win_idx][ seg_idx*8 +: 8 ] ^ asm_pattern[ seg_idx*8 +: 8 ] )
                    //     & asm_mask[ seg_idx*8 +: 8 ];
                    // 阶段 A：用窗口的 LSB→MSB 字节去跟“反字节后的 pattern”比
                    pipeA_seg_bytes[win_idx][seg_idx] <=
                        ( windows[win_idx][ seg_idx*8 +: 8 ] ^ patt_byte(seg_idx) ) & mask_byte(seg_idx);

        end
    end

    localparam integer HI = MASK_LEN-1;
    localparam integer WNUM = MASK_LEN/32; // 192/32 = 6
    // === 4. Popcount函数 ===
    function [3:0] popcount8;
        input [7:0] v;
        integer bit_idx;
        begin
            popcount8 = 4'd0;
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1)
                popcount8 = popcount8 + v[bit_idx];
        end
    endfunction

    function [7:0] patt_byte;
      input integer seg_idx; // 0..23
      integer w, b, w_rev;
      begin
        w = seg_idx/4;     // seg_idx 0..3 属于同一个 32bit 字
        b = seg_idx%4;     // 该字内的第几个字节（窗口是 LSB→MSB）
        w_rev = (WNUM-1 - w);  // ★ 关键：把 32bit 字顺序反过来（Word6,5,...,1）
        // 先反“字序” w_rev，再在该 32bit 内做“反字节” (3-b)
        patt_byte = asm_pattern[HI - (w_rev*32 + (3-b)*8) -: 8];
      end
    endfunction

    function [7:0] mask_byte;
      input integer seg_idx;
      integer w, b, w_rev;
      begin
        w = seg_idx/4;
        b = seg_idx%4;
        w_rev = (WNUM-1 - w);  // 同上
        mask_byte = asm_mask[HI - (w_rev*32 + (3-b)*8) -: 8];
      end
    endfunction

    // === 5. 流水线阶段B (8位popcount) 分组求和===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeB_seg_pops[win_idx][seg_idx] <= 4'hF;
        end else if (din_valid) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeB_seg_pops[win_idx][seg_idx] <= popcount8(pipeA_seg_bytes[win_idx][seg_idx]);
        end
    end

    // === 6. 流水线阶段C (按组求和) ===
    generate
        for (gi = 0; gi < PARALLEL; gi = gi + 1) begin : gen_pipeC
            for (gj = 0; gj < NG1; gj = gj + 1) begin : gen_grp
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n)
                        pipeC_group_sums[gi][gj] <= 8'hF;
                    else if (din_valid)
                        pipeC_group_sums[gi][gj] <= 
                              pipeB_seg_pops[gi][gj*GROUP_SZ  ]
                            + pipeB_seg_pops[gi][gj*GROUP_SZ+1]
                            + pipeB_seg_pops[gi][gj*GROUP_SZ+2];
                end
            end
        end
    endgenerate

    integer acc;
    // === 7. 流水线阶段D (总和 + 容差比较) ===
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wflag_reg_out <= {PARALLEL{1'b0}};
        else if (din_valid) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1) begin
                acc = 0;
                for (grp_idx = 0; grp_idx < NG1; grp_idx = grp_idx + 1)
                    acc = acc + pipeC_group_sums[win_idx][grp_idx];
                wflag_reg_out[win_idx] <= (acc <= TOLERANCE);
            end
        end
    end

    assign wflag_reg_out_wire = wflag_reg_out;

///////////////////////////////////////////////////////////
        // always @(posedge clk) if (din_valid) begin
        //   $display("%0t din=%h  shift_lo=%h  shift_hi=%h",
        //            $time, din,
        //            shift_buf[63:0],                     // 低 64 位
        //            shift_buf[SHIFT_BUF_W-1 -: 64]);     // 高 64 位
        // end
        // integer b;
        // always @(posedge clk) if (din_valid) begin
        //   $write("%0t win0 bytes:", $time);
        //   for (b=0; b<4; b=b+1)  // 打印前 4 个字节，便于目视核对端序
        //     $write(" %02x", windows[0][ b*8 +: 8 ]);
        //   $write("  patt[MSB..]: %02x %02x %02x %02x",
        //           asm_pattern[MASK_LEN-1 -: 8],
        //           asm_pattern[MASK_LEN-9 -: 8],
        //           asm_pattern[MASK_LEN-17 -: 8],
        //           asm_pattern[MASK_LEN-25 -: 8]);
        //   $display("");
        // end





endmodule
