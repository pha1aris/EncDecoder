`timescale 1ns / 1ps
//
// 模块: frame_synchronizer_pipelined  (带末级有效位 wflag_valid)
// 功能: 并行滑动窗口匹配引擎；A级用 din_valid 推进；B/C/D 级每拍推进；末级导出有效位.
//
module frame_synchronizer_pipelined #(
    parameter PARALLEL        = 32,
    parameter MASK_LEN        = 192,
    parameter ASM_LEN         = 32,
    parameter TOLERANCE       = 4
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [PARALLEL-1:0]    din,
    input  wire                   din_valid,
    input  wire [MASK_LEN-1:0]    asm_pattern,
    input  wire [MASK_LEN-1:0]    asm_mask,
    output wire [PARALLEL-1:0]    wflag_reg_out_wire, // 调试输出
    output reg  [PARALLEL-1:0]    wflag_reg_out,      // 匹配结果位向量
    output reg                    wflag_valid         // ★ 末级有效位：本拍 wflag_reg_out 是否有效
);

    localparam integer NSEG          = MASK_LEN / 8;         // 192/8 = 24
    localparam integer SHIFT_BUF_W   = MASK_LEN + (PARALLEL - 1);
    localparam integer GROUP_SZ      = 3;
    localparam integer NG1           = NSEG / GROUP_SZ;      // 24/3 = 8
    localparam integer HI            = MASK_LEN-1;
    localparam integer WNUM          = MASK_LEN/32;          // 192/32 = 6

    // -------- 有效位流水 --------
    reg vA, vB, vC, vD;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vA <= 1'b0; vB <= 1'b0; vC <= 1'b0; vD <= 1'b0;
        end else begin
            vA <= din_valid; // A级对应 din_valid
            vB <= vA;        // B级
            vC <= vB;        // C级
            vD <= vC;        // D级（输出）
        end
    end

    // -------- 1. 滑动缓冲区（仅 din_valid 时推进） --------
    reg [SHIFT_BUF_W-1:0] shift_buf;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_buf <= {SHIFT_BUF_W{1'b0}};
        else if (din_valid)
            shift_buf <= { shift_buf[SHIFT_BUF_W-PARALLEL-1:0], din };
    end

    // -------- 2. 窗口展开 --------
    wire [MASK_LEN-1:0] windows [0:PARALLEL-1];
    genvar gi;
    generate
        for (gi = 0; gi < PARALLEL; gi = gi + 1) begin : gen_windows
            assign windows[gi] = shift_buf[gi +: MASK_LEN];
        end
    endgenerate

    // -------- 3. 阶段A (异或 + 掩码) —— 仅在 din_valid 时写入 --------
    reg [7:0] pipeA_seg_bytes [0:PARALLEL-1][0:NSEG-1];
    integer win_idx, seg_idx, grp_idx;

    function [7:0] patt_byte;
      input integer seg_idx; // 0..23
      integer w, b, w_rev;
      begin
        w     = seg_idx/4;         // 第几个 32bit word
        b     = seg_idx%4;         // 该 word 内第几个字节（LSB→MSB）
        w_rev = (WNUM-1 - w);      // ★ 反转 32bit 字顺序
        patt_byte = asm_pattern[HI - (w_rev*32 + (3-b)*8) -: 8];
      end
    endfunction

    function [7:0] mask_byte;
      input integer seg_idx;
      integer w, b, w_rev;
      begin
        w     = seg_idx/4;
        b     = seg_idx%4;
        w_rev = (WNUM-1 - w);
        mask_byte = asm_mask[HI - (w_rev*32 + (3-b)*8) -: 8];
      end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeA_seg_bytes[win_idx][seg_idx] <= 8'hFF;
        end else if (din_valid) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeA_seg_bytes[win_idx][seg_idx] <=
                        ( windows[win_idx][ seg_idx*8 +: 8 ] ^ patt_byte(seg_idx) )
                        & mask_byte(seg_idx);
        end
    end

    // -------- 4. popcount8 --------
    function [3:0] popcount8;
        input [7:0] v;
        integer bit_idx;
        begin
            popcount8 = 4'd0;
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1)
                popcount8 = popcount8 + v[bit_idx];
        end
    endfunction

    // -------- 5. 阶段B (8位 popcount) —— 每拍推进 --------
    reg [3:0] pipeB_seg_pops  [0:PARALLEL-1][0:NSEG-1];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeB_seg_pops[win_idx][seg_idx] <= 4'hF;
        end else begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1)
                for (seg_idx = 0; seg_idx < NSEG; seg_idx = seg_idx + 1)
                    pipeB_seg_pops[win_idx][seg_idx] <= popcount8(pipeA_seg_bytes[win_idx][seg_idx]);
        end
    end

    // -------- 6. 阶段C (分组求和) —— 每拍推进 --------
    reg [7:0] pipeC_group_sums[0:PARALLEL-1][0:NG1-1];
    genvar gj;
    generate
        for (gi = 0; gi < PARALLEL; gi = gi + 1) begin : gen_pipeC
            for (gj = 0; gj < NG1; gj = gj + 1) begin : gen_grp
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n)
                        pipeC_group_sums[gi][gj] <= 8'hFF;
                    else
                        pipeC_group_sums[gi][gj] <=
                              pipeB_seg_pops[gi][gj*GROUP_SZ  ]
                            + pipeB_seg_pops[gi][gj*GROUP_SZ+1]
                            + pipeB_seg_pops[gi][gj*GROUP_SZ+2];
                end
            end
        end
    endgenerate

    // -------- 7. 阶段D (总和 + 容差比较) —— 每拍推进；有效性由 vD 指示 --------
    integer acc;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wflag_reg_out <= {PARALLEL{1'b0}};
            wflag_valid   <= 1'b0;
        end else begin
            for (win_idx = 0; win_idx < PARALLEL; win_idx = win_idx + 1) begin
                acc = 0;
                for (grp_idx = 0; grp_idx < NG1; grp_idx = grp_idx + 1)
                    acc = acc + pipeC_group_sums[win_idx][grp_idx];
                wflag_reg_out[win_idx] <= (acc <= TOLERANCE);
            end
            wflag_valid <= vD; // 末级有效位
        end
    end

    assign wflag_reg_out_wire = wflag_reg_out;
endmodule
