// module fso_channel_ge_word_prob #(
//     parameter integer P = 16,

//     parameter integer P_GB = 13,
//     parameter integer P_BG = 524,

//     parameter integer FLIP_GOOD = 0,
//     parameter integer FLIP_BAD  = 7864,

//     parameter integer DROP_BAD  = 655,
//     parameter integer DROP_MODE = 2,

//     parameter [31:0]  SEED = 32'h1ACE_B00C
// )(
//     input  wire clk,
//     input  wire rst_n,

//     input  wire txp_in,
//     input  wire txn_in,
//     output wire rxp_out,
//     output wire rxn_out,

//     output reg  bad_state,
//     output reg  dropped
// );

//     // --- LFSR ---
//     reg [31:0] lfsr;

//     function automatic [31:0] lfsr_next(input [31:0] s);
//         reg f;
//         begin
//             f = s[31]^s[21]^s[1]^s[0];
//             lfsr_next = {s[30:0], f};
//         end
//     endfunction

//     function automatic bit hit(input [P-1:0] r, input integer thr);
//         begin
//             hit = (r < thr[P-1:0]);
//         end
//     endfunction

//     // 本周期动作（保持到下个 clk）
//     reg flip_active;
//     reg drop_active;
//     reg drop_val;          // dropout 输出值（0/1/随机）

//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             lfsr        <= SEED;
//             bad_state   <= 1'b0;
//             flip_active <= 1'b0;
//             drop_active <= 1'b0;
//             drop_val    <= 1'b0;
//             dropped     <= 1'b0;
//         end else begin
//             dropped <= 1'b0;

//             // 1) 更新 Markov 状态（用当前 lfsr 低位）
//             if (!bad_state) begin
//                 if (hit(lfsr[P-1:0], P_GB)) bad_state <= 1'b1;
//             end else begin
//                 if (hit(lfsr[P-1:0], P_BG)) bad_state <= 1'b0;
//             end

//             // 2) 产生 dropout / flip 决策（消耗随机数）
//             // dropout
//             lfsr <= lfsr_next(lfsr);
//             drop_active <= bad_state && (DROP_BAD != 0) && hit(lfsr_next(lfsr)[P-1:0], DROP_BAD);

//             // 决定 dropout 值
//             case (DROP_MODE)
//                 0: drop_val <= 1'b0;
//                 1: drop_val <= 1'b1;
//                 default: begin
//                     // random-like
//                     drop_val <= lfsr_next(lfsr_next(lfsr))[0];
//                 end
//             endcase

//             // flip
//             // 用下一拍的随机位做概率比较
//             if (!bad_state) begin
//                 flip_active <= (FLIP_GOOD != 0) && hit(lfsr_next(lfsr_next(lfsr))[P-1:0], FLIP_GOOD);
//             end else begin
//                 flip_active <= (FLIP_BAD  != 0) && hit(lfsr_next(lfsr_next(lfsr))[P-1:0], FLIP_BAD);
//             end

//             if (drop_active) begin
//                 dropped <= 1'b1;
//                 flip_active <= 1'b0; // drop 优先级最高
//             end
//         end
//     end

//     // 3) 组合输出：保证差分对一致（rxn_out 永远是 ~rxp_out）
//     wire data_in = txp_in; // 以 txp 作为“数据极性”，忽略 txn_in（仅用于参考）
//     wire data_corrupt =
//         drop_active ? drop_val :
//         flip_active ? ~data_in :
//         data_in;

//     assign rxp_out = data_corrupt;
//     assign rxn_out = ~data_corrupt;

// endmodule
