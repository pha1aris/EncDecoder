`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// 模块名称: enc_dec_sync_sim (已完善)
// 模块功能: 完整的发送/接收链路仿真测试平台。
//           1. 包含您定义的多时钟生成器和复位逻辑。
//           2. 实例化您的设计模块 (DUTs) 并修正连接。
//           3. 包含健壮的激励生成器，用于发送随机数据包。
//           4. 包含自动化的数据验证器，用于比对收发数据并报告仿真结果。
//
//////////////////////////////////////////////////////////////////////////////////

module enc_dec_core_clk_sim();

//================================================================
// 1. 仿真参数和时钟/复位定义
//================================================================
    // --- 仿真控制 ---
    // parameter SIM_TIMEOUT = 100000; // 仿真超时时间 (ns)

    // --- 时钟周期参数 ---
    parameter CORE_CLK_PERIOD      =   10.0;
    parameter WR_CLK_PERIOD        = 64.0;                   // 15.625MHz 32bits
    parameter CRC_CLK_PERIOD       = WR_CLK_PERIOD / 4.0;   // 16.0 ns -> 62.5MHz 8bits
    parameter ENC_CLK_PERIOD       = CRC_CLK_PERIOD / 1.1179; // ~14.36 ns -> ~69.6MHz 8bits 
    parameter SYNC_CLK_PERIOD      = ENC_CLK_PERIOD / 1.0156; //sync clk = enc clk * 1.015 8bits
    parameter CONV_CLK_PERIOD      = SYNC_CLK_PERIOD * 4.0;  // ~57.47 ns -> ~17.4MHz 32bits
    parameter SYNC_DETECTOR_PERIOD = SYNC_CLK_PERIOD;        //
    parameter DEC_CLK_PERIOD       = SYNC_DETECTOR_PERIOD / 1.0156;        // 16.0 ns -> 62.5MHz
    parameter FIFO_RD_CLK_PERIOD   = DEC_CLK_PERIOD / 1.1179;
    parameter RD_CLK_PERIOD        = WR_CLK_PERIOD;                // 15.625MHz

    // --- 时钟和复位信号 ---
    reg core_clk;

    reg wr_clk;
    reg rd_clk;
    reg crc_clk;
    reg sync_clk;
    reg enc_clk;
    reg conv_clk;
    reg sync_detector_clk;
    reg dec_clk;
    reg fifo_rd_clk;
    reg rst;

//================================================================
// 2. 模块间连线和激励信号
//================================================================
    // --- 激励生成 ---
    reg [7:0] send_data_in;
    wire      enc_fifo_rdy;

    // --- rs_enc -> rs_enc_sync ---
    wire [7:0] M_AXIS_OUTPUT_TDATA;
    wire       M_AXIS_OUTPUT_TVALID;
    wire       M_AXIS_OUTPUT_TLAST;
    wire       M_AXIS_OUTPUT_TREADY;

    // --- rs_enc_sync -> sync_detector ---
    wire [31:0] sync_data_o;
    wire        sync_valid_o;

    // --- sync_detector -> rs_decoder_8 ---
    wire [7:0] decoder_sync_tdata;
    wire       decoder_sync_tvalid;
    wire       decoder_sync_tlast;
    wire       decoder_sync_tready;

    // --- 最终输出 ---
    wire [31:0] decoder_output_tdata;
    wire       decoder_output_tvalid;
//================================================================
// 3. 时钟和复位生成
//================================================================
    initial begin
        core_clk = 0;
        wr_clk = 1'b0;
        rd_clk = 1'b0;
        sync_clk = 0;
        enc_clk = 1'b0;
        crc_clk = 1'b0;
        conv_clk = 1'b0;
        sync_detector_clk = 0;
        fifo_rd_clk = 0;
        dec_clk = 1'b0;
    end
    
    always #(CORE_CLK_PERIOD / 2)       core_clk   = ~core_clk;
    always #(WR_CLK_PERIOD / 2)         wr_clk   = ~wr_clk;
    always #(CRC_CLK_PERIOD / 2)        crc_clk  = ~crc_clk;
    always #(ENC_CLK_PERIOD / 2)        enc_clk  = ~enc_clk;
    always #(SYNC_CLK_PERIOD / 2)       sync_clk  = ~sync_clk;
    always #(CONV_CLK_PERIOD / 2)       conv_clk = ~conv_clk;
    always #(SYNC_DETECTOR_PERIOD / 2)  sync_detector_clk = ~sync_detector_clk;
    always #(FIFO_RD_CLK_PERIOD / 2)    fifo_rd_clk = ~fifo_rd_clk;
    always #(DEC_CLK_PERIOD / 2)        dec_clk  = ~dec_clk;
    always #(WR_CLK_PERIOD / 2)         rd_clk   = ~rd_clk;
        
    // 复位和主仿真流程
    initial begin
        rst = 1;
        #(ENC_CLK_PERIOD * 5);
        @(posedge  core_clk);
        rst = 0;
    end
        
    parameter ENCODE_CNT_LEN = 229;
    parameter SYNC_CNT_LEN   = 255;

// 复位同步器
    reg reset_crc_r1, reset_crc_r2;
    always @(posedge crc_clk or posedge rst) begin
        if(rst) {reset_crc_r1, reset_crc_r2} <= 2'b11;
        else      {reset_crc_r1, reset_crc_r2} <= {1'b0,reset_crc_r1};
    end
    assign reset_sync_crc = reset_crc_r2;

    reg reset_enc_r1, reset_enc_r2;
    always @(posedge enc_clk or posedge rst) begin
        if (rst) {reset_enc_r1, reset_enc_r2} <= 2'b11;
        else       {reset_enc_r1, reset_enc_r2} <= {1'b0, reset_enc_r1};
    end
    assign reset_sync_enc = reset_enc_r2;

    reg reset_conv_r1, reset_conv_r2;
    always @(posedge conv_clk or posedge rst) begin
        if(rst) {reset_conv_r1 , reset_conv_r2} <= 2'b11;
        else      {reset_conv_r1 , reset_conv_r2} <= {1'b0,reset_conv_r1};
    end
    assign reset_sync_conv = reset_conv_r2;

    wire        cnt_buf_rden;
    wire        cnt_buf_empty;
    wire        cnt_buf_full;
    wire        cnt_buf_wr_rst_bsy;
    wire        cnt_buf_rd_rst_bsy;
    wire [31:0] tdata;
    wire [31:0] prbs_data;
    wire [7:0] s_axis_tdata;
    wire       s_axis_tready;
    wire       s_axis_tvalid;
    wire       s_axis_tlast;
    wire encoder_fifo_wrrdy;
    wire [31:0]  cnt32;
    wire         cnt32_valid;
    reg [8:0]  byte_cnt;   
    assign      cnt_buf_rden = !cnt_buf_empty;

cnt32_gen cnt32_gen (
    .wr_clk             (wr_clk),
    .rst                (rst),
    .encoder_fifo_wrrdy (encoder_fifo_wrrdy), // 下游FIFO就绪
    .data_o             (cnt32),
    .data_valid         (cnt32_valid)
);

//////////////------------------------------------------------
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_any_gen_inst (
        .RST         (rst),
        .CLK         (wr_clk),
        .DATA_IN     ('d0),
        .EN          (encoder_fifo_wrrdy),
        .DATA_OUT    (prbs_data)
    );

//================================================================
// 4. 设计单元 (DUT) 实例化
//================================================================

    wire        decoder_m_axis_tdata;
    wire [7:0]  m_axis_tdata ;
    wire        m_axis_tvalid;
    wire        m_axis_tlast ;
    wire        m_axis_tready;
    wire        Decoder_output_ready;
    reg         reset_sync_r1, reset_sync_r2;
    wire        reset_sync;
    always @(posedge fifo_rd_clk or posedge rst) begin
        if (rst) {reset_sync_r1, reset_sync_r2} <= 2'b11;
        else      {reset_sync_r1, reset_sync_r2} <= {1'b0,reset_sync_r1};
    end
    assign reset_sync = reset_sync_r2;
    wire output_buf_full,output_buf_empty,obuf_wrst_busy,obuf_rrst_busy;
    wire output_fifo_rden;
    // 参数化延迟周期，您可以根据需要调整这个值
    // 例如，设置为 8 表示在数据有效后，再等待 8 个读时钟周期才开始读取
    parameter READ_DELAY_CYCLES = 30; 

    // 创建一个移位寄存器来延迟 empty 信号
    // 寄存器的时钟必须是 FIFO 的读时钟 (wr_clk)
    reg [$clog2(READ_DELAY_CYCLES)-1:0] empty_dly_sr;
    reg output_buf_empty_neg0,output_buf_empty_neg1;
    wire output_buf_empty_neg;
    reg output_buf_rd_r;
    assign output_buf_empty_neg = !output_buf_empty_neg0 && output_buf_empty_neg1;

    Encoder Encoder(
        .rst                    (rst), 
        .input_fifo_clk         (wr_clk),
        .core_clk               (core_clk),    
        // .data_i                 (cnt32),
        // .data_valid_i           (cnt32_valid),
        
        .data_i                 (prbs_data),
        .data_valid_i           (encoder_fifo_wrrdy),

        .input_fifo_wrrdy       (encoder_fifo_wrrdy), 
        .m_axis_output_tdata    (M_AXIS_OUTPUT_TDATA ),
        .m_axis_output_tvalid   (M_AXIS_OUTPUT_TVALID),
        .m_axis_output_tready   (M_AXIS_OUTPUT_TREADY ),
        .m_axis_output_tlast    (M_AXIS_OUTPUT_TLAST)
    );

    Sync Sync(
        .rst                    (rst),
        .core_clk               (core_clk),
        .s_axis_input_tdata     (M_AXIS_OUTPUT_TDATA),
        .s_axis_input_tvalid    (M_AXIS_OUTPUT_TVALID),
        .s_axis_input_tlast     (M_AXIS_OUTPUT_TLAST),
        .s_axis_input_tready    (M_AXIS_OUTPUT_TREADY),
        .sync_data_o            (sync_data_o),
        .sync_valid_o           (sync_valid_o)
    );


    DeSync DeSync(
        // --- 时钟和复位 ---
        .rst                    (rst),
        .core_clk               (core_clk),
        // --- 输入 (32-bit, 来自解交织器) ---
        .data_i                 (sync_data_o),
        .data_valid_i           (sync_valid_o),
        // --- AXI-Stream 主接口输出 (8-bit, 送往 decoder 模块) ---
        .m_axis_output_tdata    (decoder_sync_tdata ),
        .m_axis_output_tvalid   (decoder_sync_tvalid),
        .m_axis_output_tlast    (decoder_sync_tlast ),
        .m_axis_output_tready   (decoder_sync_tready)
    );

    Decoder Decoder(
        .rst            (rst),
        .core_clk       (core_clk),
        // AXIS Slave 接口 (输入)
        .s_axis_input_tdata (decoder_sync_tdata ),
        .s_axis_input_tvalid(decoder_sync_tvalid),
        .s_axis_input_tlast (decoder_sync_tlast ),
        .s_axis_input_tready(decoder_sync_tready),
        // AXIS Master 接口 (输出)
        .output_tdata(decoder_output_tdata),
        .output_tvalid(decoder_output_tvalid),
        .output_tready(Decoder_output_ready) 
    );

    assign Decoder_output_ready = 1;

    always @(posedge fifo_rd_clk or posedge rst) begin
        if(rst) begin
            output_buf_empty_neg0 <= 0;
            output_buf_empty_neg1 <= 0;
        end else begin
            output_buf_empty_neg0 <= output_buf_empty;
            output_buf_empty_neg1 <= output_buf_empty_neg0;
        end
    end

    always @(posedge fifo_rd_clk or posedge rst) begin
        if(rst) begin
            empty_dly_sr <= 0;
        end else if(output_buf_rd_r && empty_dly_sr < READ_DELAY_CYCLES) begin
            empty_dly_sr <= empty_dly_sr + 1;
        end else if(empty_dly_sr == READ_DELAY_CYCLES)begin
            empty_dly_sr <= empty_dly_sr;
        end
    end

    always @(posedge fifo_rd_clk or posedge rst) begin
        if(rst) begin
            output_buf_rd_r <= 0;
        end else if(output_buf_empty_neg) begin
            output_buf_rd_r <= 1;
        end
    end
    reg obuf_rden;
    always @(posedge fifo_rd_clk or posedge rst) begin
        if(rst) begin
           obuf_rden <= 0;
        end else if(empty_dly_sr == READ_DELAY_CYCLES && output_buf_rd_r <= 1) begin
            obuf_rden <= 1;
        end
    end
    wire [31:0] data_to_gth;
    wr_gth_fifo output_buf (
      .srst         (reset_sync),                           // input wire srst
      .wr_clk       (core_clk),                             // input wire wr_clk
      .rd_clk       (rd_clk),                               // input wire rd_clk
      .din          (decoder_output_tdata),                 // input wire [31 : 0] din
      .wr_en        (decoder_output_tvalid),                // input wire wr_en
      .rd_en        (obuf_rden && !output_buf_empty),                // input wire rd_en
      .dout         (data_to_gth),                          // output wire [31 : 0] dout
      .full         (output_buf_full),                      // output wire full
      .empty        (output_buf_empty),                     // output wire empty
      .wr_rst_busy  (obuf_wrst_busy),                       // output wire wr_rst_busy
      .rd_rst_busy  (obuf_rrst_busy)                        // output wire rd_rst_busy
    );

    // 直接例化PRBS检查器，检查解码出的数据 (用于环回测试)
    wire [31:0] prbs_error_to_gth;
    wire prbs_match_out1;

    reg reset_sync_chk1, reset_sync_chk2;
    wire reset_sync_chk;
    always @(posedge rd_clk or posedge rst) begin
        if (rst) {reset_sync_chk1, reset_sync_chk2} <= 2'b11;
        else      {reset_sync_chk1, reset_sync_chk2} <= {1'b0,reset_sync_chk1};
    end
    assign reset_sync_chk = reset_sync_chk2;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (32)
    ) prbs_checker_inst1 (
        .RST      (reset_sync_chk),
        .CLK      (rd_clk), // 假设 tx_clk 与 rd_clk 同步用于此测试
        .DATA_IN  (data_to_gth),
        .EN       (obuf_rden && !output_buf_empty),
        .DATA_OUT (prbs_error_to_gth)
    );
    assign prbs_match_out1 = ~|prbs_error_to_gth;

endmodule