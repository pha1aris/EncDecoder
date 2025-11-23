`timescale 1ns/1ps

module rs_decode_backend(
    input  wire        rst,
    input  wire        core_clk,
    input  wire        output_clk,

    // 8-bit AXI Stream Input（来自去交织器）
    input  wire [7:0]  s_axis_input_tdata,
    input  wire        s_axis_input_tvalid,
    input  wire        s_axis_input_tlast,   // 码字末尾 tlast
    output wire        s_axis_input_tready,

    // 8-bit AXI Stream Output（给后级）
    output wire [7:0]  output_tdata,
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

    // 按上游 tlast 乒乓切换
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            pingpang <= 1'b0;
        end else if (s_axis_input_tlast && s_axis_input_tvalid && s_axis_input_tready) begin
            pingpang <= ~pingpang;
        end
    end

    // 输入数据分发到两个 decoder
    always @(*) begin
        if (!pingpang) begin // 送 Decoder_U0
            s_axis_input_tdata0  = s_axis_input_tdata;
            s_axis_input_tvalid0 = s_axis_input_tvalid;
            s_axis_input_tlast0  = s_axis_input_tlast;

            s_axis_input_tdata1  = 8'd0;
            s_axis_input_tvalid1 = 1'b0;
            s_axis_input_tlast1  = 1'b0;
        end else begin        // 送 Decoder_U1
            s_axis_input_tdata0  = 8'd0;
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

    // 给每个 decoder 各自的 tready
    wire       decoder_tready0;
    wire       decoder_tready1;

    // 未使用端口
    wire [7:0] m_axis_stat_tdata0, m_axis_stat_tdata1;
    wire       m_axis_stat_tvalid0, m_axis_stat_tvalid1;
    wire       event_s_input_tlast_missing,  event_s_input_tlast_unexpected,  event_s_ctrl_tdata_invalid;
    wire       event_s_input_tlast_missing0, event_s_input_tlast_unexpected0, event_s_ctrl_tdata_invalid0;

    rs_decoder_0 Decoder_U0 (
      .aclk                             (core_clk),
      .s_axis_input_tdata               (s_axis_input_tdata0),
      .s_axis_input_tvalid              (s_axis_input_tvalid0),
      .s_axis_input_tlast               (s_axis_input_tlast0),
      .s_axis_input_tready              (s_axis_input_tready0),

      .m_axis_output_tdata              (m_axis_output_tdata0),
      .m_axis_output_tvalid             (m_axis_output_tvalid0),
      .m_axis_output_tready             (decoder_tready0),
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
      .m_axis_output_tready             (decoder_tready1),
      .m_axis_output_tlast              (m_axis_output_tlast1),

      .m_axis_stat_tdata                (m_axis_stat_tdata1),
      .m_axis_stat_tvalid               (m_axis_stat_tvalid1),
      .m_axis_stat_tready               (1'b1),
      .event_s_input_tlast_missing      (event_s_input_tlast_missing0),
      .event_s_input_tlast_unexpected   (event_s_input_tlast_unexpected0),
      .event_s_ctrl_tdata_invalid       (event_s_ctrl_tdata_invalid0)
    );

//================================================================
// 2.1 输出仲裁：一段时间只服务一个 decoder
//================================================================
    reg cur_sel;   // 当前服务的 decoder：0→U0，1→U1
    reg in_word;   // 当前是否处于一个 codeword 输出中

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            cur_sel <= 1'b0;
            in_word <= 1'b0;
        end else begin
            if (!in_word) begin
                // 还没开始输出任何 codeword，看谁先 valid
                if (m_axis_output_tvalid0) begin
                    cur_sel <= 1'b0;
                    in_word <= 1'b1;
                end else if (m_axis_output_tvalid1) begin
                    cur_sel <= 1'b1;
                    in_word <= 1'b1;
                end
            end else begin
                // 正在输出某个 decoder 的 codeword，检测该路的 tlast
                if (cur_sel == 1'b0) begin
                    if (m_axis_output_tvalid0 && decoder_tready0 && m_axis_output_tlast0)
                        in_word <= 1'b0;
                end else begin
                    if (m_axis_output_tvalid1 && decoder_tready1 && m_axis_output_tlast1)
                        in_word <= 1'b0;
                end
            end
        end
    end

    wire [7:0] sel_data  = (cur_sel == 1'b0) ? m_axis_output_tdata0  : m_axis_output_tdata1;
    wire       sel_valid = (cur_sel == 1'b0) ? m_axis_output_tvalid0 : m_axis_output_tvalid1;
    wire       sel_last  = (cur_sel == 1'b0) ? m_axis_output_tlast0  : m_axis_output_tlast1;

//================================================================
// 3. dec_fifo_8w_8r：core_clk → output_clk 的 8bit 异步 FIFO
//================================================================
    wire [7:0] dec_fifo_dout;
    wire       dec_fifo_full, dec_fifo_empty;
    wire       dec_fifo_wr_rst_busy, dec_fifo_rd_rst_busy;
    wire       dec_fifo_wr_en;
    wire       dec_fifo_rd_en;

    // FIFO 作为“输出 sink”的 tready
    wire fifo_can_write = !dec_fifo_full && !dec_fifo_wr_rst_busy;

    // 只有当前选中的 decoder 看到 tready=1
    assign decoder_tready0 = fifo_can_write && (cur_sel == 1'b0);
    assign decoder_tready1 = fifo_can_write && (cur_sel == 1'b1);

    // 有有效数据且 FIFO 有空间就写
    assign dec_fifo_wr_en  = sel_valid && fifo_can_write;

    dec_fifo_8w_8r u_dec_fifo (
      .rst        (rst),
      .wr_clk     (core_clk),
      .rd_clk     (output_clk),
      .din        (sel_data),
      .wr_en      (dec_fifo_wr_en),
      .rd_en      (dec_fifo_rd_en),
      .dout       (dec_fifo_dout),
      .full       (dec_fifo_full),
      .empty      (dec_fifo_empty),
      .wr_rst_busy(dec_fifo_wr_rst_busy),
      .rd_rst_busy(dec_fifo_rd_rst_busy)
    );

    // 最终 8bit AXI-Stream 输出握手（output_clk 域）
    assign output_tvalid = !dec_fifo_empty && !dec_fifo_rd_rst_busy;
    assign dec_fifo_rd_en = output_tvalid && output_tready;
    assign output_tdata  = dec_fifo_dout;

endmodule
