module rs_decode_backend(
    input wire         rst,
    input wire         core_clk,
    input wire         output_clk,

    // 8-bit AXI Stream Input（来自去交织器）
    input wire  [7:0]  s_axis_input_tdata,
    input wire         s_axis_input_tvalid,
    input wire         s_axis_input_tlast,   // 如果此处是“码字 tlast”，保持；否则也可以忽略，内部自己数255
    output wire        s_axis_input_tready,

    // 32-bit AXI Stream Output（给后级）
    output wire [31:0] output_tdata,
    output wire        output_tvalid,
    input  wire        output_tready 
);

//================================================================
// 1. Ping-Pong 控制 & 输入分发（core_clk 域）
//================================================================
    reg pingpang; // 0: Decoder_U0 在接收；1: Decoder_U1 在接收

    reg [7:0] s_axis_input_tdata0, s_axis_input_tdata1;
    reg       s_axis_input_tvalid0, s_axis_input_tvalid1;
    reg       s_axis_input_tlast0,  s_axis_input_tlast1;
    wire      s_axis_input_tready0, s_axis_input_tready1;

    // 当前选中的 decoder 的 ready 反馈到上游
    assign s_axis_input_tready = (!pingpang) ? s_axis_input_tready0
                                             : s_axis_input_tready1;

    // 这里沿用你原来的“按上游 tlast 乒乓切换”的方式
    //  若 RX 侧已经无法保持“每个 RS 码块一个 tlast”，建议后面改成内部按 255 计数生成 tlast
    always @(posedge core_clk or posedge rst) begin
        if(rst) begin
            pingpang <= 1'b0;
        end else if(s_axis_input_tlast && s_axis_input_tvalid && s_axis_input_tready) begin
            pingpang <= ~pingpang;
        end
    end

    // 输入数据分发到两个 decoder
    always @(*) begin
        if (!pingpang) begin // 送 Decoder_U0
            s_axis_input_tdata0  = s_axis_input_tdata;
            s_axis_input_tvalid0 = s_axis_input_tvalid;
            s_axis_input_tlast0  = s_axis_input_tlast;

            s_axis_input_tdata1  = 8'b0;
            s_axis_input_tvalid1 = 1'b0;
            s_axis_input_tlast1  = 1'b0;
        end else begin        // 送 Decoder_U1
            s_axis_input_tdata0  = 8'b0;
            s_axis_input_tvalid0 = 1'b0;
            s_axis_input_tlast0  = 1'b0;

            s_axis_input_tdata1  = s_axis_input_tdata;
            s_axis_input_tvalid1 = s_axis_input_tvalid;
            s_axis_input_tlast1  = s_axis_input_tlast;
        end
    end

//================================================================
// 2. 两个 RS 解码 IP（core_clk 域）
//================================================================
    wire [7:0] m_axis_output_tdata0, m_axis_output_tdata1;
    wire       m_axis_output_tvalid0, m_axis_output_tvalid1;
    wire       m_axis_output_tlast0,  m_axis_output_tlast1;
    wire       decoder_tready; // 两个 decoder 共用 m_axis_output_tready

    // 未使用端口
    wire [7:0] m_axis_stat_tdata0, m_axis_stat_tdata1;
    wire       m_axis_stat_tvalid0, m_axis_stat_tvalid1;
    wire       event_s_input_tlast_missing, event_s_input_tlast_unexpected, event_s_ctrl_tdata_invalid;
    wire       event_s_input_tlast_missing0, event_s_input_tlast_unexpected0, event_s_ctrl_tdata_invalid0;

    rs_decoder_0 Decoder_U0 (
      .aclk                             (core_clk),
      .s_axis_input_tdata               (s_axis_input_tdata0),
      .s_axis_input_tvalid              (s_axis_input_tvalid0),
      .s_axis_input_tlast               (s_axis_input_tlast0),
      .s_axis_input_tready              (s_axis_input_tready0),

      .m_axis_output_tdata              (m_axis_output_tdata0),
      .m_axis_output_tvalid             (m_axis_output_tvalid0),
      .m_axis_output_tready             (decoder_tready),
      .m_axis_output_tlast              (m_axis_output_tlast0),

      .m_axis_stat_tdata                (m_axis_stat_tdata0),
      .m_axis_stat_tvalid               (m_axis_stat_tvalid0),
      .m_axis_stat_tready               (1'b1),
      .event_s_input_tlast_missing      (event_s_input_tlast_missing),
      .event_s_input_tlast_unexpected   (event_s_input_tlast_unexpected),
      .event_s_ctrl_tdata_invalid       (event_s_ctrl_tdata_invalid)
    );

    rs_decoder_0 Decoder_U1 (
      .aclk                             (core_clk),
      .s_axis_input_tdata               (s_axis_input_tdata1),
      .s_axis_input_tvalid              (s_axis_input_tvalid1),
      .s_axis_input_tlast               (s_axis_input_tlast1),
      .s_axis_input_tready              (s_axis_input_tready1),

      .m_axis_output_tdata              (m_axis_output_tdata1),
      .m_axis_output_tvalid             (m_axis_output_tvalid1),
      .m_axis_output_tready             (decoder_tready),
      .m_axis_output_tlast              (m_axis_output_tlast1),

      .m_axis_stat_tdata                (m_axis_stat_tdata1),
      .m_axis_stat_tvalid               (m_axis_stat_tvalid1),
      .m_axis_stat_tready               (1'b1),
      .event_s_input_tlast_missing      (event_s_input_tlast_missing0),
      .event_s_input_tlast_unexpected   (event_s_input_tlast_unexpected0),
      .event_s_ctrl_tdata_invalid       (event_s_ctrl_tdata_invalid0)
    );

    // 输出合并（理论上不会两个同时 valid，因为 Processing Delay 和乒乓间隔关系）
    reg select; // 0: 取 decoder0，1: 取 decoder1
    always @(*) begin
        if (m_axis_output_tvalid0) begin
            select = 1'b0;
        end else if (m_axis_output_tvalid1) begin
            select = 1'b1;
        end else begin
            select = 1'b0;
        end
    end

    wire [7:0] Dec_output_tdata;
    wire       Dec_output_valid;
    assign Dec_output_valid = m_axis_output_tvalid0 | m_axis_output_tvalid1;
    assign Dec_output_tdata = (select == 1'b0) ? m_axis_output_tdata0
                                               : m_axis_output_tdata1;

//================================================================
// 3. dec_fifo_8w_8r：core_clk → output_clk 的 8bit 异步 FIFO
//================================================================
    wire [7:0] dec_fifo_dout;
    wire       dec_fifo_full, dec_fifo_empty;
    wire       dec_fifo_wr_rst_busy, dec_fifo_rd_rst_busy;
    wire       dec_fifo_wr_en;
    wire       dec_fifo_rd_en;

    // 当 FIFO 未满且复位完成时，解码器才允许往里写（即 tready=1）
    assign decoder_tready  = !dec_fifo_full && !dec_fifo_wr_rst_busy;

    // 有有效数据且 FIFO 有空间就写
    assign dec_fifo_wr_en  = Dec_output_valid && decoder_tready;

    dec_fifo_8w_8r u_dec_fifo (
      .rst        (rst),
      .wr_clk     (core_clk),
      .rd_clk     (output_clk),
      .din        (Dec_output_tdata),
      .wr_en      (dec_fifo_wr_en),
      .rd_en      (dec_fifo_rd_en),
      .dout       (dec_fifo_dout),
      .full       (dec_fifo_full),
      .empty      (dec_fifo_empty),
      .wr_rst_busy(dec_fifo_wr_rst_busy),
      .rd_rst_busy(dec_fifo_rd_rst_busy)
    );

//================================================================
// 4. fifo_sim_8_32：在 output_clk 域做 8→32 位宽转换
//    （你原来的 IP，wr_clk/rd_clk 都接 output_clk）
//================================================================
    wire       fifo8_32_full;
    wire       fifo8_32_empty;
    wire       fifo8_32_wr_rst_busy;
    wire       fifo8_32_rd_rst_busy;

    // 把 dec_fifo 读出来，写进 8→32 宽度转换 FIFO
    // 注意：这里为了简单，直接把 dec_fifo 的 dout 写进 fifo_sim_8_32
    //       读 dec_fifo 的时机：fifo_sim_8_32 有空间 且 dec_fifo 非空 且复位完成
    assign dec_fifo_rd_en = !dec_fifo_empty && !dec_fifo_rd_rst_busy && !fifo8_32_full && !fifo8_32_wr_rst_busy;

    // 同步复位到 output_clk（给 fifo_sim_8_32 用）
    reg rst_sync_r1, rst_sync_r2;
    wire rst_sync_rfifo;
    always @(posedge output_clk or posedge rst) begin
        if (rst) {rst_sync_r1, rst_sync_r2} <= 2'b11;
        else     {rst_sync_r1, rst_sync_r2} <= {1'b0, rst_sync_r1};
    end
    assign rst_sync_rfifo = rst_sync_r2;

    fifo_sim_8_32 output_fifo_inst (
      .srst         (rst_sync_rfifo),
      .wr_clk       (output_clk),         // 写时钟：output_clk
      .rd_clk       (output_clk),         // 读时钟：同一域，只做宽度转换
      .din          (dec_fifo_dout),      // 来自 dec_fifo_8w_8r 的 8bit
      .wr_en        (dec_fifo_rd_en),     // 每次从 dec_fifo 读出就写入一个字节
      .rd_en        (output_tvalid && output_tready), // AXIS 下游准备好时读一个 32bit
      .dout         (output_tdata),       // 32bit 输出
      .full         (fifo8_32_full),
      .empty        (fifo8_32_empty),
      .wr_rst_busy  (fifo8_32_wr_rst_busy),
      .rd_rst_busy  (fifo8_32_rd_rst_busy)
    );

    // 最终 32bit AXI-Stream 输出握手
    assign output_tvalid = !fifo8_32_empty && !fifo8_32_rd_rst_busy;

endmodule
