`timescale 1ns / 1ps

// ============================================================
// 包装模块：使用改进版本的 bit_aligner_ind_improved，但保持原始模块名
// 这样可以无缝替换原始模块，无需修改调用代码
// ============================================================
module bit_aligner_ind #(
    parameter integer W                 = 32,
    parameter integer SLIDE_COOLDOWN    = 5,
    parameter integer CHECK_TIMEOUT_MAX = 50,
    parameter         IDLE_WORD         = 32'h0707_0707, // tx在空闲状态下发送的数据
    // 只作为 loss_cnt 的计数位宽上限使用，实际阈值由 cfg_lock_loss_to 决定
    parameter integer LOCK_LOSS_TIMEOUT = 4096
)(
    input                       clk,
    input                       rst_n,
    input                       rx_reset_done,
    input                       rx_cdr_stable,
    
    input       [W-1:0]         i_rx_data,
    input                       i_rx_valid,
    
    input                       i_realign_req,  // 来自快时钟域

    // ★ 新增：VIO/上层可配置端口
    input       [5:0]           cfg_err_th,          // 允许误差 bit 数
    input       [7:0]           cfg_verify_cnt_max,  // 连续命中次数
    input       [15:0]          cfg_lock_loss_to,    // 失锁超时时间（单位：拍）

    output  reg                 o_rxslide,
    output  wire                o_aligned_valid,
    output                      o_bit_locked,
    output      [W-1:0]         o_data_aligned
);

    // 实例化改进版本的模块
    bit_aligner_ind_improved #(
        .W                 (W),
        .SLIDE_COOLDOWN    (SLIDE_COOLDOWN),
        .CHECK_TIMEOUT_MAX (CHECK_TIMEOUT_MAX),
        .IDLE_WORD         (IDLE_WORD),
        .LOCK_LOSS_TIMEOUT (LOCK_LOSS_TIMEOUT)
    ) u_bit_aligner_improved (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .rx_reset_done         (rx_reset_done),
        .rx_cdr_stable         (rx_cdr_stable),
        .i_rx_data             (i_rx_data),
        .i_rx_valid            (i_rx_valid),
        .i_realign_req         (i_realign_req),
        .cfg_err_th            (cfg_err_th),
        .cfg_verify_cnt_max    (cfg_verify_cnt_max),
        .cfg_lock_loss_to      (cfg_lock_loss_to),
        .o_rxslide             (o_rxslide),
        .o_aligned_valid       (o_aligned_valid),
        .o_bit_locked          (o_bit_locked),
        .o_data_aligned        (o_data_aligned)
    );

endmodule
