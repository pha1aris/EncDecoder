`timescale 1ns/1ps

// ============================================================
// 包装模块：使用改进版本的 fso_framer_improved，但保持原始模块名
// 这样可以无缝替换原始模块，无需修改调用代码
// ============================================================
module fso_framer #(
    parameter integer W                = 32,
    parameter integer PAYLOAD_WORDS    = 16,
    parameter integer FRAMES_PER_BLOCK = 255
)(
    input                         clk,
    input                         rst_n,

    // 上游 payload 流（32bit）
    input      [W-1:0]            i_payload_data,
    input                         i_payload_valid,
    input                         i_payload_block_start,   // word级块开始标志
    input                         scrambler_en,
    output reg                    o_payload_ready,

    // 下游 TX 流（32bit）与监控端口
    input                         i_tx_ready,
    output reg [W-1:0]            o_tx_data,
    output reg                    o_tx_valid,
    output wire [15:0]            o_frame_in_block,
    output wire [15:0]            o_block_id,
    output reg [15:0]             o_frame_index
);

    // 实例化改进版本的模块
    fso_framer_improved #(
        .W                (W),
        .PAYLOAD_WORDS    (PAYLOAD_WORDS),
        .FRAMES_PER_BLOCK (FRAMES_PER_BLOCK)
    ) u_framer_improved (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .i_payload_data        (i_payload_data),
        .i_payload_valid       (i_payload_valid),
        .i_payload_block_start (i_payload_block_start),
        .scrambler_en          (scrambler_en),
        .o_payload_ready       (o_payload_ready),
        .i_tx_ready            (i_tx_ready),
        .o_tx_data             (o_tx_data),
        .o_tx_valid            (o_tx_valid),
        .o_frame_in_block      (o_frame_in_block),
        .o_block_id            (o_block_id),
        .o_frame_index         (o_frame_index)
    );

endmodule
