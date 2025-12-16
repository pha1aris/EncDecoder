`timescale 1ns/1ps
`include "global_defines.vh"

module fec_rx #(
    parameter integer W             = 32,
    parameter integer PAYLOAD_WORDS = 16,
    parameter integer RS_N          = 255,
    parameter integer INTLV_D       = 4808,
    parameter integer INTLV_N       = 255
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,

    // 来自 GTH RX 的并行数据（已经是 parallel data）
    input  wire [W-1:0]     i_rx_data,
    input  wire             i_rx_valid,
    input  wire             rx_reset_done,
    input  wire             rx_cdr_stable,
    input  wire             scrambler_en,

    // 解码后的数据（8bit）
    output wire [7:0]       o_data,
    output wire             o_valid,
    input  wire             i_data_ready,

    // 调试信号
    output wire             o_rxslide,
    output wire             o_bit_locked,
    output wire [15:0]      o_frame_index,
    output wire [15:0]      o_block_id,
    output wire [15:0]      o_frame_in_block
);

    wire rst = ~rst_n;

    // 这些是“默认参数”，作为 VIO 配置寄存器的上电默认值
    parameter integer VERIFY_CNT_MAX     = 4;
    parameter integer SLIDE_COOLDOWN    = 5;
    parameter integer ERR_TH            = 2;
    parameter integer CHECK_TIMEOUT_MAX = 50;
    parameter integer LOCK_LOSS_TIMEOUT = 4096;
    parameter integer FRAME_TIMEOUT_MAX = 64;

   // ====================================================
    // 0) VIO 配置寄存器（帧同步 / 比特对齐）
    // ====================================================

    // bit_aligner 相关
    wire [5:0]  cfg_err_th;          // 允许的比特误差数（对齐头与期望之间）
    wire [7:0]  cfg_verify_cnt_max;  // 连续命中次数
    wire [15:0] cfg_lock_loss_to;    // 失锁超时时间（单位：拍）

    // deframer / CRC / 前导统计相关
    wire [15:0] cfg_frame_to;        // 帧超时阈值
    wire [7:0]  cfg_crc_win;         // CRC 统计窗口长度（目前 RTL 没用到，也无妨）
    wire [7:0]  cfg_crc_bad_th;      // CRC 坏帧阈值
    wire [7:0]  cfg_pre_win;         // 前导统计窗口长度（目前没用到）
    wire [7:0]  cfg_pre_bad_th;      // 前导失败阈值
    wire        cfg_realign_mode;    // 0: need&pre; 1: need|pre

`ifdef SIM
    // 仿真用固定默认值（和你原来的 initial 一致）
    assign cfg_err_th          = ERR_TH[5:0];               // 2 bit 误差
    assign cfg_verify_cnt_max  = VERIFY_CNT_MAX[7:0];       // 4 次连续命中
    assign cfg_lock_loss_to    = LOCK_LOSS_TIMEOUT[15:0];   // 4096 拍失锁

    assign cfg_frame_to        = FRAME_TIMEOUT_MAX[15:0];   // 64 拍帧超时
    assign cfg_crc_win         = 8'd64;
    assign cfg_crc_bad_th      = 8'd16;
    assign cfg_pre_win         = 8'd64;
    assign cfg_pre_bad_th      = 8'd16;
    assign cfg_realign_mode    = 1'b0;                      // AND：need & pre
`else
    // 上板用 VIO，默认值在 VIO IP 里配置
    vio_frame_cfg u_vio_frame_cfg (
        .clk        (core_clk),

        .probe_out0 (cfg_err_th),          // [5:0]
        .probe_out1 (cfg_verify_cnt_max),  // [7:0]
        .probe_out2 (cfg_lock_loss_to),    // [15:0]
        .probe_out3 (cfg_frame_to),        // [15:0]
        .probe_out4 (cfg_crc_win),         // [7:0]
        .probe_out5 (cfg_crc_bad_th),      // [7:0]
        .probe_out6 (cfg_pre_win),         // [7:0]
        .probe_out7 (cfg_pre_bad_th),      // [7:0]
        .probe_out8 (cfg_realign_mode)     // [0:0]
    );
`endif
    // ====================================================
    // 1) bit_aligner：line_clk 域
    // ====================================================
    wire [W-1:0] aligned_data;
    wire         aligned_valid;
    (* MARK_DEBUG="true" *)wire         realign_req;

    bit_aligner_ind #(
        .W                 (W),
        .IDLE_WORD         (32'h0707_0707),
        .LOCK_LOSS_TIMEOUT (LOCK_LOSS_TIMEOUT) // 仅用于计数器位宽
    ) u_bit_aligner_ind (
        .clk                (line_clk),
        .rst_n              (rst_n),
        .rx_reset_done      (rx_reset_done),
        .rx_cdr_stable      (rx_cdr_stable),

        .i_rx_data          (i_rx_data),
        .i_rx_valid         (i_rx_valid),

        // 来自 deframer 的重对齐请求（core_clk→line_clk，内部有同步 & 拉宽）
        .i_realign_req      (realign_req),

        // ===== VIO 配置（注意：这里直接用 cfg_*，默认认为动态改的频率很低）=====
        .cfg_err_th         (cfg_err_th),
        .cfg_verify_cnt_max (cfg_verify_cnt_max),
        .cfg_lock_loss_to   (cfg_lock_loss_to),

        .o_rxslide          (o_rxslide),
        .o_aligned_valid    (aligned_valid),
        .o_bit_locked       (o_bit_locked),
        .o_data_aligned     (aligned_data)
    );

    // ====================================================
    // 2) async FIFO：line_clk → core_clk
    // ====================================================
    wire [W-1:0] rx32_fifo_dout;
    wire         rx32_fifo_empty;
    wire         rx32_fifo_full;
    wire         rx32_fifo_wr_rst_busy;
    wire         rx32_fifo_rd_rst_busy;
    wire         rx32_fifo_rd_en;
    wire         rx32_fifo_wr_en;

    assign rx32_fifo_wr_en = aligned_valid;

    async_fifo_32w_32r u_rx_fifo (
        .rst        (rst),
        .wr_clk     (line_clk),
        .rd_clk     (core_clk),
        .din        (aligned_data),
        .wr_en      (rx32_fifo_wr_en),
        .rd_en      (rx32_fifo_rd_en),
        .dout       (rx32_fifo_dout),
        .full       (rx32_fifo_full),
        .empty      (rx32_fifo_empty),
        .wr_rst_busy(rx32_fifo_wr_rst_busy),
        .rd_rst_busy(rx32_fifo_rd_rst_busy)
    );

    wire [W-1:0] aligned_data_c;
    wire         aligned_valid_c;

    assign aligned_data_c  = rx32_fifo_dout;
    assign aligned_valid_c = ~rx32_fifo_empty & ~rx32_fifo_rd_rst_busy;
    assign rx32_fifo_rd_en = aligned_valid_c;  // 简单 streaming

    // ====================================================
    // 3) bit_locked 同步到 core_clk
    // ====================================================
    reg [1:0] bit_locked_sync;
    always @(posedge core_clk or posedge rst) begin
        if (rst)
            bit_locked_sync <= 2'b00;
        else
            bit_locked_sync <= {bit_locked_sync[0], o_bit_locked};
    end
    wire bit_locked_core = bit_locked_sync[1];

    // ====================================================
    // 4) deframer（帧同步 / CRC / 重对齐）
    // ====================================================
    (* MARK_DEBUG="true" *)wire [W-1:0] rx_payload_data;
    (* MARK_DEBUG="true" *)wire         rx_payload_valid;
    (* MARK_DEBUG="true" *)wire [15:0]  frame_index_rx;
    (* MARK_DEBUG="true" *)wire [15:0]  block_id_rx;
    (* MARK_DEBUG="true" *)wire [15:0]  frame_in_block_rx;
    (* MARK_DEBUG="true" *)wire         blk_soft_rst;
    (* MARK_DEBUG="true" *)wire         frame_locked;
    (* MARK_DEBUG="true" *)wire         frame_start;

    fso_deframer #(
        .W                      (W),
        .PAYLOAD_WORDS          (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX      (FRAME_TIMEOUT_MAX)
    ) u_fso_deframer (
        .clk                    (core_clk),
        .rst_n                  (rst_n),

        .i_link_up              (bit_locked_core),
        .i_rx_data              (aligned_data_c),
        .i_rx_valid             (aligned_valid_c),

        .scrambler_en           (scrambler_en),

        // ===== VIO 配置寄存器（core_clk 域） =====
        .cfg_frame_timeout_max  (cfg_frame_to),        // 原 cfg_frame_to
        .cfg_crc_bad_th         (cfg_crc_bad_th),
        .cfg_pre_bad_th         (cfg_pre_bad_th),
        .cfg_realign_or         (cfg_realign_mode),    // 原 cfg_realign_mode

        .o_realign_req          (realign_req),
        .o_frame_start          (frame_start),
        .o_frame_index          (frame_index_rx),
        .o_block_id             (block_id_rx),
        .o_frame_in_block       (frame_in_block_rx),
        .o_blk_soft_rst         (blk_soft_rst),
        
        .o_frame_locked         (frame_locked),
        .o_payload_data         (rx_payload_data),
        .o_payload_valid        (rx_payload_valid)
    );

    assign o_frame_index    = frame_index_rx;
    assign o_block_id       = block_id_rx;
    assign o_frame_in_block = frame_in_block_rx;

    // ====================================================
    // 5) 32→8 gearbox
    // ====================================================
    (* MARK_DEBUG="true" *)wire [7:0] gb8_data;
    (* MARK_DEBUG="true" *)wire       gb8_valid;
    (* MARK_DEBUG="true" *)wire       gb8_sync_rst;

    gearbox_32to8 u_gb_32to8 (
        .clk         (core_clk),
        .rst         (rst),

        .in_sync_rst (blk_soft_rst),
        .in_data     (rx_payload_data),
        .in_valid    (rx_payload_valid),

        .out_data    (gb8_data),
        .out_sync_rst(gb8_sync_rst),
        .out_valid   (gb8_valid)
    );

    // ====================================================
    // 6) 去交织器
    // ====================================================
    (* MARK_DEBUG="true" *)wire        deintlv_valid;
    (* MARK_DEBUG="true" *)wire [7:0]  deintlv_data;
    (* MARK_DEBUG="true" *)wire        deintlv_block_start;
    (* MARK_DEBUG="true" *)wire [7:0]  rs_in_data;
    (* MARK_DEBUG="true" *)wire        rs_in_valid;
    (* MARK_DEBUG="true" *)wire        rs_in_ready;
    (* MARK_DEBUG="true" *)reg  [7:0]  rs_byte_cnt;
    (* MARK_DEBUG="true" *)wire        rs_tlast;

    rs_deinterleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_deinterleaver (
        .clk         (core_clk),
        .rst         (rst),

        .blk_soft_rst(gb8_sync_rst),

        .in_valid    (gb8_valid),
        .in_data     (gb8_data),
        .in_ready    (),                 // gearbox32→8 没有 ready，空着

        .out_valid   (deintlv_valid),
        .out_data    (deintlv_data),
        .block_start (deintlv_block_start),
        .out_ready   (rs_in_ready)       
    );

    assign rs_in_data  = deintlv_data;
    assign rs_in_valid = deintlv_valid;

    wire rs_fire = deintlv_valid && rs_in_ready;

    assign rs_tlast = deintlv_valid && (rs_byte_cnt == RS_N-1);

    always @(posedge core_clk or posedge rst) begin
      if (rst) begin
        rs_byte_cnt <= 8'd0;
      end else if (gb8_sync_rst) begin
        rs_byte_cnt <= 8'd0;
      end else if (rs_fire) begin
        //  block_start 对应的这个字节索引=0，消费后下一字节应为1
        if (deintlv_block_start) begin
          rs_byte_cnt <= 8'd1;
        end else if (rs_byte_cnt == RS_N-1) begin
          rs_byte_cnt <= 8'd0;
        end else begin
          rs_byte_cnt <= rs_byte_cnt + 1'b1;
        end
      end
    end


    // ====================================================
    // 7) RS 解码后端
    // ====================================================
    (* MARK_DEBUG="true" *)wire [7:0] dec_data;
    (* MARK_DEBUG="true" *)wire       dec_valid;

    rs_decode_backend u_rs_decode_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (core_clk),

        .s_axis_input_tdata  (rs_in_data),
        .s_axis_input_tvalid (rs_in_valid),
        .s_axis_input_tlast  (rs_tlast),
        .s_axis_input_tready (rs_in_ready),

        .output_tdata        (dec_data),
        .output_tvalid       (dec_valid),
        .output_tready       (i_data_ready)
    );

    assign o_data  = dec_data;
    assign o_valid = dec_valid;

// `ifdef SIM
//     integer wr_cnt;
//     always @(posedge line_clk or posedge rst) begin
//         if (rst) begin
//             wr_cnt <= 0;
//         end else begin
//             if (aligned_valid && rx32_fifo_full) begin
//                 $display("[%0t] ERROR: rx32 FIFO FULL, incoming data DROPPED!", $time);
//             end
//             if (rx32_fifo_wr_en) begin
//                 wr_cnt <= wr_cnt + 1;
//                 $display("[%0t] FIFO WR #%0d: data = %h",
//                          $time, wr_cnt, aligned_data);
//             end
//         end
//     end

//     integer rd_cnt;
//     reg [W-1:0] last_read_data;

//     always @(posedge core_clk or posedge rst) begin
//         if (rst) begin
//             rd_cnt         <= 0;
//             last_read_data <= {W{1'b0}};
//         end else if (aligned_valid_c) begin
//             rd_cnt <= rd_cnt + 1;
//             $display("[%0t] FIFO RD #%0d: data = %h",
//                      $time, rd_cnt, aligned_data_c);

//             if (aligned_data_c == last_read_data) begin
//                 $display("[%0t] WARNING: consecutive reads have same data: %h",
//                          $time, aligned_data_c);
//             end
//             last_read_data <= aligned_data_c;
//         end
//     end

//     always @(posedge line_clk or posedge rst) begin
//         if (rst) begin
//         end else if (aligned_valid && rx32_fifo_full) begin
//             $display("[%0t] ERROR: rx32 FIFO FULL, data dropped!", $time);
//         end
//     end

// `endif

endmodule
