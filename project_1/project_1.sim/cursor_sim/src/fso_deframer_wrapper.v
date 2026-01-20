`timescale 1ns/1ps
`include "global_defines.vh"

// ============================================================
// 包装模块：使用改进版本的 fso_deframer_improved，但保持原始模块名
// 这样可以无缝替换原始模块，无需修改调用代码
// ============================================================
module fso_deframer #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer FRAME_TIMEOUT_MAX = 256
)(
    input                         clk,
    input                         rst_n,

    input                         i_link_up,

    // ===== 输入：来自 rx32 FIFO 的"类AXIS" =====
    input        [W-1:0]          s_axis_tdata,
    input                         s_axis_tvalid,
    output wire                   s_axis_tready,

    input                         scrambler_en,

    // ===== 输出：payload AXIS =====
    output reg   [W-1:0]          m_axis_tdata,
    output reg   [1:0]            m_axis_tuser,   // [0]=blk_soft_rst_on_word0, [1]=frame_start_on_word0(可选)
    output reg                    m_axis_tvalid,
    input                         m_axis_tready,

    // 反馈/调试
    output reg                    o_realign_req,
    output reg                    o_frame_start,
    output reg   [15:0]           o_frame_index,
    output reg   [15:0]           o_block_id,
    output reg   [15:0]           o_frame_in_block,
    output reg                    o_blk_soft_rst,
    output reg                    o_frame_locked,
    output wire                   o_block_aligned,

    input      [15:0]             cfg_frame_timeout_max,
    input       [7:0]             cfg_crc_bad_th,
    input       [7:0]             cfg_pre_bad_th,
    input                         cfg_realign_or,

    // FER (Frame Error Rate) 统计输出
    output reg  [31:0]            o_total_frames,     // 总接收帧数
    output reg  [31:0]            o_crc_error_frames, // CRC 错误帧数
    output reg  [31:0]            o_fer_q32           // FER (Q0.32 格式)
);

    // 实例化改进版本的模块
    fso_deframer_improved #(
        .W                 (W),
        .PAYLOAD_WORDS     (PAYLOAD_WORDS),
        .FRAME_TIMEOUT_MAX (FRAME_TIMEOUT_MAX)
    ) u_deframer_improved (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .i_link_up             (i_link_up),
        .s_axis_tdata          (s_axis_tdata),
        .s_axis_tvalid         (s_axis_tvalid),
        .s_axis_tready         (s_axis_tready),
        .scrambler_en          (scrambler_en),
        .m_axis_tdata          (m_axis_tdata),
        .m_axis_tuser          (m_axis_tuser),
        .m_axis_tvalid         (m_axis_tvalid),
        .m_axis_tready         (m_axis_tready),
        .o_realign_req         (o_realign_req),
        .o_frame_start         (o_frame_start),
        .o_frame_index         (o_frame_index),
        .o_block_id            (o_block_id),
        .o_frame_in_block      (o_frame_in_block),
        .o_blk_soft_rst        (o_blk_soft_rst),
        .o_frame_locked        (o_frame_locked),
        .o_block_aligned       (o_block_aligned),
        .cfg_frame_timeout_max (cfg_frame_timeout_max),
        .cfg_crc_bad_th        (cfg_crc_bad_th),
        .cfg_pre_bad_th        (cfg_pre_bad_th),
        .cfg_realign_or        (cfg_realign_or),
        .o_total_frames        (o_total_frames),
        .o_crc_error_frames    (o_crc_error_frames),
        .o_fer_q32             (o_fer_q32)
    );

endmodule
