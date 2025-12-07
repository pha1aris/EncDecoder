// File: tx_chain.v
`timescale 1ns / 1ps

module tx_chain (
    input  wire        clk,          // 主时钟 (Encoder, TLAST Gen, Interleaver, Packer)
    input  wire        rst,          // 复位 (高电平有效)
    input  wire        prbs_clk     // PRBS 时钟
);

    // --- 内部连线 ---
    // PRBS -> Encoder
    wire [31:0] prbs_data;
    wire        encoder_s_ready;    // Encoder 输入 FIFO 的 Ready 信号

    // Encoder -> TLAST Gen
    wire [7:0]  encoder_tdata;
    wire        encoder_tvalid;
    wire        tlast_gen_s_tready; // TLAST Gen 输入 Ready (连接到 Encoder 输出 tready)

    // TLAST Gen -> Interleaver (sid_0)
    wire [7:0]  sid_tdata;
    wire        sid_tvalid;
    wire        sid_tlast;          // TLAST for interleaver block
    wire        sid_tready;         // Interleaver 输入 Ready

    // Interleaver (sid_0) -> Packer
    wire [7:0]  interleaver_tdata;
    wire        interleaver_tvalid;
    wire        interleaver_tlast;  // TLAST from interleaver block end
    wire        interleaver_tready;
    wire [1:0]  interleaver_tuser;  // BLOCK_START/END from interleaver
    wire        packer_s_tready;    // Packer 输入 Ready

    // Event signals (can be monitored or left unconnected if unused)
    wire event_tlast_unexpected;
    wire event_tlast_missing;
    wire event_halted;
    wire encoder_tlast;

    // --- 1. PRBS-31 伪随机码生成器 (数据源) ---
    wire prbs_en = encoder_s_ready;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE       (0),
        .INV_PATTERN    (1),
        .POLY_LENGHT    (31),
        .POLY_TAP       (28),
        .NBITS          (32)
    ) prbs_any_gen_inst (
        .RST           (rst),
        .CLK           (prbs_clk),
        .DATA_IN       ('d0),
        .EN            (prbs_en), // 仅当编码器输入 FIFO 准备好时才产生新数据
        .DATA_OUT      (prbs_data)
    );
    
    // --- 2. 编码器 ---
    Encoder Encoder(
        .rst                   (rst),
        .input_fifo_clk        (prbs_clk),
        .core_clk              (clk),
        .data_i                (prbs_data),
        .data_valid_i          (prbs_en),   // 假设 PRBS 数据在 EN 使能时即有效
        .input_fifo_wrrdy      (encoder_s_ready), // Encoder FIFO Ready 输出信号

        .m_axis_output_tdata   (encoder_tdata),
        .m_axis_output_tvalid  (encoder_tvalid),
        .m_axis_output_tready  (tlast_gen_s_tready),// TLAST Gen 是否准备好接收
        .m_axis_output_tlast   (encoder_tlast)   // 编码器输出 TLAST (例如, 码字结束)
    );

    // --- 3. TLAST 生成器 (适配交织器块边界) ---
    tlast_generator #(
        .BLOCK_SIZE(65025) // <-- 确认此值与 sid_0 配置完全一致!
    ) tlast_gen_inst (
        .aclk               (clk),
        .reset              (rst),

        // 连接到 Encoder 输出
        .s_axis_tdata       (encoder_tdata),
        .s_axis_tvalid      (encoder_tvalid),
        .s_axis_tlast       (encoder_tlast),     // 编码器的 TLAST (内部忽略)
        .s_axis_tready      (tlast_gen_s_tready),// 输出 Ready 给 Encoder

        // 连接到 Interleaver 输入
        .m_axis_tdata       (sid_tdata),
        .m_axis_tvalid      (sid_tvalid),
        .m_axis_tlast       (sid_tlast),         // 生成的 TLAST for sid_0
        .m_axis_tready      (sid_tready)         // 从 sid_0 接收 Ready
    );

    // // --- 4. 交织器 ---
    sid_0_top sid_0_top (
        .clk                  (clk),                                      // input wire aclk
        .aresetn               (~rst),                                // input wire aresetn

        .s_axis_data_tdata     (sid_tdata),             // input wire [7 : 0] s_axis_data_tdata
        .s_axis_data_tvalid    (sid_tvalid),            // input wire s_axis_data_tvalid
        .s_axis_data_tlast     (sid_tlast),             // input wire s_axis_data_tlast
        .s_axis_data_tready    (sid_tready),            // output wire s_axis_data_tready

        .m_axis_data_tdata     (interleaver_tdata),     // output wire [7 : 0] m_axis_data_tdata (to packer)
        .m_axis_data_tuser     (interleaver_tuser),     // output wire [1 : 0] m_axis_data_tuser
        .m_axis_data_tvalid    (interleaver_tvalid),    // output wire m_axis_data_tvalid (to packer)
        .m_axis_data_tlast     (interleaver_tlast),     // output wire m_axis_data_tlast (to packer)
        .m_axis_data_tready    (1)    // input wire m_axis_data_tready (from packer)
    );

    wire [7:0]  deinterleaver_tdata;
    wire        deinterleaver_tvalid;
    wire        deinterleaver_tlast;  // TLAST from interleaver block end
    wire        deinterleaver_tready;
    wire[1:0]   deinterleaver_tuser;
    wire        deintv_block_start      = interleaver_tuser[0];
    wire        deintv_block_end        = interleaver_tuser[1];
    wire        deintv_tlast_unexpected;
    wire        deintv_tlast_missing;
    wire        deintv_event_halted;

    reg  frame;

    always@(posedge clk)begin
        if(rst)begin
            frame <= 0;
        end else begin
            if(deintv_block_start)begin
                frame <= 1;
            end else if(deintv_block_end)begin
                frame <= 0;
            end
        end
    end

    reg [8:0] cnt;
    reg [8:0] block_cnt;
    reg [7:0] tdata_d;
    reg tvalid;
    wire tlast = (cnt == 255-1);

    always@(posedge clk)begin
        if(rst)begin
            cnt <= 'd0;
            tvalid <= 1'b0;
            tdata_d <= 'd0;
            block_cnt <= 'd0;
        end else begin
            tvalid <= interleaver_tvalid;
            tdata_d <= interleaver_tdata;
            block_cnt <= 'd0;
            cnt <= 'd0;
            if(frame)begin
                if(cnt == 'd255-1)begin
                    cnt <= 'd0;
                    block_cnt <= (block_cnt == 'd254) ? 'd0 : block_cnt + 1;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end


    sid_1_top sid_1_0(
      .aclk                     (clk),                                  // input wire aclk
      .aresetn                  (~rst),                                 // input wire aresetn
// Slave Interface (来自上游)
      .s_axis_data_tdata        (tdata_d),                                  // input wire [7 : 0] s_axis_data_tdata
      .s_axis_data_tvalid       (tvalid),                               // input wire s_axis_data_tvalid
      .s_axis_data_tlast        (tlast),                                // input wire s_axis_data_tlast
      .s_axis_data_tready       (interleaver_tready),                   // output wire s_axis_data_tready

      .m_axis_data_tdata        (deinterleaver_tdata),                  // output wire [7 : 0] m_axis_data_tdata
      .m_axis_data_tuser        (deinterleaver_tuser),                  // output wire [1 : 0] m_axis_data_tuser
      .m_axis_data_tvalid       (deinterleaver_tvalid),                 // output wire m_axis_data_tvalid
      .m_axis_data_tlast        (deinterleaver_tlast),                  // output wire m_axis_data_tlast
      .m_axis_data_tready       (1)                                     // input wire m_axis_data_tready
    );


    // sid_1 sid_1 (
    //       .aclk                     (clk),                                      // input wire aclk
    //       .aresetn                  (~rst),                                 // input wire aresetn
    //       .s_axis_data_tdata        (cnt),                    // input wire [7 : 0] s_axis_data_tdata
    //       .s_axis_data_tvalid       (tvalid),                   // input wire s_axis_data_tvalid
    //       .s_axis_data_tlast        (tlast),                    // input wire s_axis_data_tlast
    //       .s_axis_data_tready       (interleaver_tready),                   // output wire s_axis_data_tready

    //       .m_axis_data_tdata        (deinterleaver_tdata),                  // output wire [7 : 0] m_axis_data_tdata
    //       .m_axis_data_tuser        (deinterleaver_tuser),                  // output wire [1 : 0] m_axis_data_tuser
    //       .m_axis_data_tvalid       (deinterleaver_tvalid),                 // output wire m_axis_data_tvalid
    //       .m_axis_data_tlast        (deinterleaver_tlast),                  // output wire m_axis_data_tlast
    //       .m_axis_data_tready       (1),                 // input wire m_axis_data_tready

    //       .event_tlast_unexpected   (deintv_tlast_unexpected),              // output wire event_tlast_unexpected
    //       .event_tlast_missing      (deintv_tlast_missing),                 // output wire event_tlast_missing
    //       .event_halted             (deintv_event_halted)                      // output wire event_halted
    // );

    // wire decoder_tdata;
    // // 3. 解码器
    // Decoder Decoder (
    //     .core_clk               (clk),
    //     .rst                    (rst),
    //     .s_axis_input_tdata     (desync_tdata ),
    //     .s_axis_input_tvalid    (desync_tvalid),
    //     .s_axis_input_tlast     (desync_tlast ),
    //     .s_axis_input_tready    (deinterleaver_tready),
    //     .output_tdata           (decoder_tdata),
    //     .output_tvalid          (decoder_tvalid),
    //     .output_tready          (1'b1) // 假设解码器后级总能接收数据
    // );




endmodule

