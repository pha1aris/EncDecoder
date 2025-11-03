`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/31 16:38:13
// Design Name: 
// Module Name: prbs_gth_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// prbs gen - frame_generator - gth tx
// gth rx - frame_synchronizer_top - prbs chk
//  验证实际同步情况
// 
// [GEMINI EDITS]:
// 1. 插入了 frame_generator 和 frame_synchronizer_top 到数据路径中。
// 2. 将 PRBS Gen -> GTH TX 路径修改为 PRBS Gen -> frame_generator -> GTH TX。
// 3. 将 GTH RX -> PRBS Chk 路径修改为 GTH RX -> frame_synchronizer_top -> PRBS Chk。
// 4. TX/RX 时钟/复位/有效信号已连接到帧模块。
// 5. ILA probe1 修改为 GTH TX 的输入 (framed_tx_data)。
// 6. ILA probe2 修改为帧同步锁存信号 (frame_is_locked)。
// 7. 根据 frame_generator 的参数 (SYNC_MARKER) 自动配置了 frame_synchronizer 的 (asm_pattern)。
// 8. 修正了 frame_synchronizer 的 FRAME_LEN_BYTE (24B ASM + 16B Payload = 40B)。
//////////////////////////////////////////////////////////////////////////////////


module prbs_gth_test(

    input wire          sys_clk_p,
    input wire          sys_clk_n,
    input wire          sys_rst_n,

    output wire [1:0]   tx_disable,

    input  wire         mgtrefclk0_x1y1_p,
    input  wire         mgtrefclk0_x1y1_n,

    // 串行物理
    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out
);
    wire        freerun_clk, gtwiz_userclk_tx_active_out;
    wire        gtwiz_userclk_rx_active_out;
    wire        gtwiz_userclk_tx_usrclk2_out;
    wire        gtwiz_userclk_rx_usrclk2_out;
    // wire [31:0]userdata_tx_in ; // [GEMINI] 移除, 改用 framed_tx_data
    wire [31:0] userdata_rx_out;
    wire        pll_locked;
    wire [31:0] prbs_chk;
    wire        prbs_match;

    // --- GEMINI: 为帧结构添加的新信号 ---
    wire [31:0] prbs_data;                      // PRBS Gen -> Frame Gen
    wire        payload_ready_from_frame_gen;   // Frame Gen -> PRBS Gen
    wire [31:0] framed_tx_data;                 // Frame Gen -> GTH TX
    wire [31:0] sync_dout;                      // Frame Sync -> PRBS Chk
    wire        sync_dout_valid;                // Frame Sync -> PRBS Chk
    wire        frame_is_locked;                // Frame Sync 状态
    wire [191:0] asm_pattern_wire;              // 同步头 (ASM) 码型
    wire [191:0] asm_mask_wire;                 // 同步头 (ASM) 掩码
    // ------------------------------------

    assign tx_disable = 2'b00;
    assign prbs_match = ~|prbs_chk;
    // assign userdata_tx_in = prbs_data; // [GEMINI] 移除, ILA probe1 将直接连接到 framed_tx_data

    // [GEMINI NOTE]: ILA探针修改
    // probe1 -> framed_tx_data (GTH的实际TX输入)
    // probe2 -> frame_is_locked (帧同步锁存状态)
    ila_0 ila_0 (
        .clk      (freerun_clk), // input wire clk
        .probe0   (userdata_rx_out), // input wire [31:0]  probe0 (GTH RX 输出)
        .probe1   (framed_tx_data), // input wire [31:0]  probe1 (GTH TX 输入)
        .probe2   (frame_is_locked) // input wire [0:0]   probe2 (帧同步锁存)
    );

    clk_wiz_0 clk_wiz_0  (
        .clk_out1   (freerun_clk),      
        .reset      (!sys_rst_n), 
        .locked     (pll_locked),       
        .clk_in1_p  (sys_clk_p),    
        .clk_in1_n  (sys_clk_n)    
    );

    gth_top     gth_top (
      .freerun_clk                (freerun_clk),
      // TX/RX 用户数据
      .gtwiz_userdata_tx_in       (framed_tx_data), // [GEMINI] 修改: 连接到 Frame Gen 的输出
      .gtwiz_userdata_rx_out      (userdata_rx_out),
      // 导出 helper 生成的用户时钟与激活信号
      .gtwiz_userclk_tx_active_out(gtwiz_userclk_tx_active_out),
      .gtwiz_userclk_rx_active_out(gtwiz_userclk_rx_active_out),
      .gtwiz_userclk_tx_usrclk2_out(gtwiz_userclk_tx_usrclk2_out),
      .gtwiz_userclk_rx_usrclk2_out(gtwiz_userclk_rx_usrclk2_out),
      // 参考时钟（差分）
      .mgtrefclk0_x1y1_p          (mgtrefclk0_x1y1_p),
      .mgtrefclk0_x1y1_n          (mgtrefclk0_x1y1_n),
      // 串行物理
      .gthrxp_in                  (gthrxp_in),
      .gthrxn_in                  (gthrxn_in),
      .gthtxp_out                 (gthtxp_out),
      .gthtxn_out                 (gthtxn_out)
    );

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_gen_inst (
        .RST      (~gtwiz_userclk_tx_active_out),
        .CLK      (gtwiz_userclk_tx_usrclk2_out),
        .DATA_IN  ('d0),
        .EN       (payload_ready_from_frame_gen), // [GEMINI] 修改: 由 Frame Gen 反压
        .DATA_OUT (prbs_data)
    );

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP (28),
        .NBITS (32)
    ) prbs_chk_inst (
        .RST      (!gtwiz_userclk_rx_active_out),
        .CLK      (gtwiz_userclk_rx_usrclk2_out),
        .DATA_IN  (sync_dout),       // [GEMINI] 修改: 连接到 Frame Sync 的输出
        .EN       (sync_dout_valid), // [GEMINI] 修改: 由 Frame Sync 的 valid 信号控制
        .DATA_OUT (prbs_chk)
    );


// [GEMINI] 实例化帧生成器 (TX 路径)
frame_generator #(
    .SYNC_MARKER        (64'hB1699558_A53333A8),
    // ★ 匹配 192-bit ASM
    .SYNC_REPETITION    (3),  
    // ★ 匹配 4 个字的 Payload (16 字节)
    .PAYLOAD_SIZE_WORDS (4)
) u_frame_generator (
    .clk                (gtwiz_userclk_tx_usrclk2_out),
    .rst_n              (gtwiz_userclk_tx_active_out),
    .payload_data_in    (prbs_data),
    .payload_valid_in   (1'b1), // PRBS Gen 在 EN=1 时总是有效的
    .payload_ready_out  (payload_ready_from_frame_gen),
    .framed_data_out    (framed_tx_data),
    .framed_valid_out   (),     // 假设 GTH TX FIFO 总是准备好，不处理反压
    .framed_ready_in    (1'b1)  // 假设 GTH TX FIFO 总是准备好
);

// [GEMINI] 实例化帧同步器 (RX 路径)

// 根据 frame_generator 的 SYNC_MARKER (B1699558_A53333A8) 和 REPETITION (3) 来定义 ASM 码型
// ASM = 192 bits
assign asm_pattern_wire = {64'hB1699558_A53333A8, 64'hB1699558_A53333A8, 64'hB1699558_A53333A8};
// 使用全1掩码进行精确匹配
assign asm_mask_wire    = {192{1'b1}}; 

frame_synchronizer_top #(
    .PARALLEL           (32),     // 数据总线位宽
    .MASK_LEN           (192),    // 帧同步码 (ASM) 的掩码长度 (bits)。
    .ASM_LEN            (192),    // 帧同步码 (ASM) 的总长度 (bits)。
    .TOLERANCE          (0),      // 帧同步码 (ASM) 匹配时允许的最大误码位数 (容错)。
    .FRAME_LEN_BYTE     (40),     // [GEMINI] 修正: 帧总长 = ASM(24B) + Payload(16B) = 40B
    .M_VERIFY           (2),      // FSM: 需要连续 M 帧(帧头)命中才能进入 LOCK 状态。
    .N_PROTECT          (2),      // FSM: 需要连续 N 帧(帧头)丢失才能从 LOCK 跌落到 PROTECT 状态。
    .PIPELINE_LATENCY   (9)       // [GEMINI] 采用TB中的值 9
) u_frame_synchronizer (
    .clk                (gtwiz_userclk_rx_usrclk2_out),
    .rst_n              (gtwiz_userclk_rx_active_out),    
    .din                (userdata_rx_out),
    .din_valid          (gtwiz_userclk_rx_active_out), // GTH RX 数据在时钟 active 时有效
    .asm_pattern        (asm_pattern_wire),
    .asm_mask           (asm_mask_wire),

    .frame_lock         (frame_is_locked), // 连接到 ILA
    .frame_sync_found   (),
    .wnumber_dec        (),
    .flocation          (),
    .sof                (), // ★ [NEW] 帧首 (Start of Frame) 信号
    .dout               (sync_dout),
    .dout_valid         (sync_dout_valid)
);

endmodule
