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
// 8. 修正了 frame_synchronizer 的 FRAME_LEN_BYTE (1MB + 24B ASM)。
// 9. 删除了 L172 之后粘贴错的重复代码。
// 10. ★ 修复了 gth_top 的例化语法错误 (缺少实例名称)。
// 11. ★ 修复了 u_frame_sync 的悬空输出端口 (连接到 dummy wire)。
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
    (* MARK_DEBUG="true" *) wire [31:0] userdata_rx_out;
    wire        pll_locked;
    wire [31:0] prbs_chk;
    wire        prbs_match;

    // --- GEMINI: 为帧结构添加的新信号 ---
    wire [31:0] prbs_data;                      // PRBS Gen -> Frame Gen
    wire        payload_ready_from_frame_gen;   // Frame Gen -> PRBS Gen
    (* MARK_DEBUG="true" *)wire [31:0] framed_tx_data;                 // Frame Gen -> GTH TX
    wire        framed_tx_valid;                // Frame Gen -> GTH TX (用于门控)
    (* MARK_DEBUG="true" *)wire [31:0] sync_dout;                      // Frame Sync -> PRBS Chk
    wire        sync_dout_valid;                // Frame Sync -> PRBS Chk
   (* MARK_DEBUG="true" *)  wire        frame_is_locked;                // Frame Sync 状态 (连接到 ILA)
    wire [191:0] asm_pattern_wire;              // 同步头 (ASM) 码型
    wire [191:0] asm_mask_wire;                 // 同步头 (ASM) 掩码
    
    // 为悬空的输出端口声明 wire (防止 lint/synthesis 警告)
    wire        unused_sync_found;
    wire [4:0]  unused_wnumber;
    wire [3:0]  unused_flocation;
    wire        unused_sof;
    // ------------------------------------

    // --- GEMINI: 帧结构参数 (基于 1MB 负载) ---
    // 1. 定义帧生成器 (TX) 参数
    // localparam GEN_PAYLOAD_BYTES    = 1048576;          // 1MB 负载
    localparam GEN_PAYLOAD_BYTES    = 220;
    localparam GEN_PAYLOAD_WORDS    = GEN_PAYLOAD_BYTES / 4; // 262,144 个 32-bit 字
    localparam GEN_ASM_REPS         = 3;                // 3 * 64-bit = 192 bits
    localparam [63:0] GEN_SYNC_MARKER = 64'hA53333A8_B1699558; // 保持与TB一致

    // 2. 推导帧同步器 (RX) 参数
    localparam TB_ASM_LEN           = 192;              // GEN_ASM_REPS * 64
    localparam TB_ASM_BYTES         = GEN_ASM_REPS * 8;       // 24 字节
    localparam TB_FRAME_LEN_BYTE    = TB_ASM_BYTES + GEN_PAYLOAD_BYTES; // 24 + 1,048,576 = 1,048,600 字节
    localparam TB_FRAME_CNT_W       = $clog2(TB_FRAME_LEN_BYTE); // $clog2(1048600) = 21

    // 3. 推导 RX ASM 码型 (用于匹配)
    //    Generator 发送: [HI, LO] [HI, LO] [HI, LO]
    //    接收端 (shift_buf) 看到: {LO, HI, LO, HI, LO, HI}
    localparam [31:0] TB_MARKER_HI = GEN_SYNC_MARKER[31:0]; // 32'hB1699558
    localparam [31:0] TB_MARKER_LO = GEN_SYNC_MARKER[63:32];  // 32'hA53333A8
    assign asm_pattern_wire = {TB_MARKER_LO, TB_MARKER_HI, 
                               TB_MARKER_LO, TB_MARKER_HI, 
                               TB_MARKER_LO, TB_MARKER_HI}; //A53333A8_B1699558 , ***
    assign asm_mask_wire    = {TB_ASM_LEN{1'b1}};
    // ------------------------------------------

    assign tx_disable = 2'b00;
    assign prbs_match = ~|prbs_chk;
    // ================= 8b10b ctrl ===========

    wire [7:0]   txctrl2_out;
   (* MARK_DEBUG="true" *) wire [3:0]   charisk;

    clk_wiz_0 clk_wiz_0  (
        .clk_out1                   (freerun_clk),     
        .reset                      (!sys_rst_n), 
        .locked                     (pll_locked),       
        .clk_in1_p                  (sys_clk_p),    
        .clk_in1_n                  (sys_clk_n)     
    );

        wire  [15:0] rxctrl0_out; 
        wire  [15:0] rxctrl1_out; 
        wire  [7:0] rxctrl2_out; 
        wire  [7:0] rxctrl3_out;
        wire  [3:0] rxdisperr = rxctrl0_out[3:0];
        wire  [3:0] rxnotintable = rxctrl1_out[3:0]; 

    assign charisk = rxctrl2_out[3:0];

    gth_top gth_top (
        .freerun_clk                  (freerun_clk),
        .gtwiz_rst_in                 (!sys_rst_n || !pll_locked),

    // TX/RX 用户数据
        .gtwiz_userdata_tx_in         (framed_tx_data), // [GEMINI] 修改: 连接到 Frame Gen 的输出 (Frame Gen 在 IDLE 时输出 0)
        .gtwiz_userdata_rx_out        (userdata_rx_out),
        .gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_out),
        .gtwiz_userclk_rx_active_out  (gtwiz_userclk_rx_active_out),
        .gtwiz_userclk_tx_usrclk2_out (gtwiz_userclk_tx_usrclk2_out),
        .gtwiz_userclk_rx_usrclk2_out (gtwiz_userclk_rx_usrclk2_out),
   // 8b10b控制端口

        .txctrl0_in                   (16'd0),
        .txctrl1_in                   (16'd0),
        .txctrl2_in                   (txctrl2_out), //发送是K码

        .rxctrl0_out                  (rxctrl0_out), 
        .rxctrl1_out                  (rxctrl1_out), 
        .rxctrl2_out                  (rxctrl2_out),  //charisk
        .rxctrl3_out                  (rxctrl3_out),

        .tx8b10ben_in                 (1'b1),
        .rx8b10ben_in                 (1'b1),
        .rxcommadeten_in              (1'b1),
        .rxmcommaalignen_in           (1'b1),
        .rxpcommaalignen_in           (1'b1),
        .rxbufreset_in                (1'b0),

        .mgtrefclk0_x1y1_p            (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n            (mgtrefclk0_x1y1_n),
        .gthrxp_in                    (gthrxp_in),
        .gthrxn_in                    (gthrxn_in),
        .gthtxp_out                   (gthtxp_out),
        .gthtxn_out                   (gthtxn_out)
    );

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (0),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (32)
    ) prbs_gen_inst (
        .RST                (~gtwiz_userclk_tx_active_out), // 使用 GTH TX 激活信号
        .CLK                (gtwiz_userclk_tx_usrclk2_out), // 使用 GTH TX 时钟
        .DATA_IN            ('d0),
        .EN                 (payload_ready_from_frame_gen), //  修改: 由 Frame Gen 反压
        .DATA_OUT           (prbs_data)                     //  连接到 Frame Gen
    );

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE           (1),
        .INV_PATTERN        (1),
        .POLY_LENGHT        (31),
        .POLY_TAP           (28),
        .NBITS              (32)
    ) prbs_chk_inst (
        .RST                (!gtwiz_userclk_rx_active_out), //  使用 GTH RX 激活信号
        .CLK                (gtwiz_userclk_rx_usrclk2_out), //  使用 GTH RX 时钟
        .DATA_IN            (sync_dout),                    //  修改: 连接到 Frame Sync 的输出
        .EN                 (sync_dout_valid),              //  修改: 由 Frame Sync 的 valid 信号控制
        .DATA_OUT           (prbs_chk)
    );

    frame_generator #(
        .SYNC_MARKER        (GEN_SYNC_MARKER),  // 64'hA53333A8_B1699558 
        .SYNC_REPETITION    (GEN_ASM_REPS),
        .PAYLOAD_SIZE_WORDS (GEN_PAYLOAD_WORDS) // 负载
    ) u_frame_gen (
        .clk                (gtwiz_userclk_tx_usrclk2_out), // GTH TX 时钟
        .rst_n              (gtwiz_userclk_tx_active_out),  // GTH TX 激活
        .txctrl2_out        (txctrl2_out),
        .payload_data_in    (prbs_data),                   
        .payload_valid_in   (1'b1),                        
        .payload_ready_out  (payload_ready_from_frame_gen),
        .framed_data_out    (framed_tx_data),              
        .framed_valid_out   (framed_tx_valid),             
        .framed_ready_in    (1'b1)                         
    );

    (* MARK_DEBUG="true" *)wire [31:0] data_o;
    (* MARK_DEBUG="true" *)wire data_valid_o;

    frame_synchronizer_top #(
        .PARALLEL           (32),
        .MASK_LEN           (TB_ASM_LEN),           // 192
        .ASM_LEN            (TB_ASM_LEN),           // 192
        .FRAME_LEN_BYTE     (TB_FRAME_LEN_BYTE),    // 1,048,600
        .M_VERIFY           (2),                    // 
        .N_PROTECT          (2),                    // 
        .PIPELINE_LATENCY   (9),                    // 
        .FRAME_CNT_W        (TB_FRAME_CNT_W),       // 21
        .TOLERANCE          (0),
        .OUTPUT_DELAY       (3)                     // (使用默认值)
    ) u_frame_sync (
        .clk                (gtwiz_userclk_rx_usrclk2_out), // GTH RX 时钟
        .rst_n              (gtwiz_userclk_rx_active_out),  // GTH RX 激活
        .din                (userdata_rx_out),            // GTH RX 数据
        .din_valid          (gtwiz_userclk_rx_active_out),  // GTH RX 激活 = 数据有效
        .din_charisk        (charisk),
        .asm_pattern        (asm_pattern_wire),         // A53333A8_B1699558 * 3
        .asm_mask           (asm_mask_wire),
        .frame_lock         (frame_is_locked),            // 连接到 ILA probe2
        
        .frame_sync_found   (unused_sync_found),
        .wnumber_dec        (unused_wnumber),
        .flocation          (unused_flocation),
        .sof                (unused_sof),
        
        .data_o             (data_o),
        .data_valid_o       (data_valid_o),

        .dout               (sync_dout),                  // 连接到 PRBS Chk
        .dout_valid         (sync_dout_valid)             // 连接到 PRBS Chk
    );

endmodule

