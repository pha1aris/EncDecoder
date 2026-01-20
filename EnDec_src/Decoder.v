module Decoder(
    input  wire         rst,
    input  wire         core_clk,
    input  wire         output_clk,

    input  wire  [7:0]  s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    input  wire         s_axis_input_tlast,
    output wire         s_axis_input_tready,

    output wire [31:0]  output_tdata,
    output wire         output_tvalid,
    input  wire         output_tready
);

    // =========================
    // 1) RS Decoder IP
    // =========================
    wire [7:0] dec_m_tdata;
    wire       dec_m_tvalid;
    wire       dec_m_tready;
    wire       dec_m_tlast;

    // 统计口/事件口（可留着调试）
    wire [7:0] m_axis_stat_tdata;
    wire       m_axis_stat_tvalid;
    wire       event_s_input_tlast_missing, event_s_input_tlast_unexpected, event_s_ctrl_tdata_invalid;

    rs_decoder_0 u_rs_dec (
        .aclk                           (core_clk),

        .s_axis_input_tdata             (s_axis_input_tdata),
        .s_axis_input_tvalid            (s_axis_input_tvalid),
        .s_axis_input_tlast             (s_axis_input_tlast),
        .s_axis_input_tready            (s_axis_input_tready),

        .m_axis_output_tdata            (dec_m_tdata),
        .m_axis_output_tvalid           (dec_m_tvalid),
        .m_axis_output_tready           (dec_m_tready),
        .m_axis_output_tlast            (dec_m_tlast),

        .m_axis_stat_tdata              (m_axis_stat_tdata),
        .m_axis_stat_tvalid             (m_axis_stat_tvalid),
        .m_axis_stat_tready             (1'b1),

        .event_s_input_tlast_missing    (event_s_input_tlast_missing),
        .event_s_input_tlast_unexpected (event_s_input_tlast_unexpected),
        .event_s_ctrl_tdata_invalid     (event_s_ctrl_tdata_invalid)
    );

    // =========================
    // 2) 输出 FIFO：8-bit 写入(core_clk) -> 32-bit 读出(output_clk)
    //    dec_m_tready 必须由 FIFO “是否可写”决定，否则会丢数据
    // =========================
    wire       fifo_full, fifo_empty, fifo_wr_rst_busy, fifo_rd_rst_busy;
    wire [31:0] fifo_dout_word;

    // 写端准备好 -> 给 decoder 的 ready
    assign dec_m_tready = (!fifo_full) && (!fifo_wr_rst_busy);

    // 写使能：必须是握手成功那拍
    wire wr_xfer = dec_m_tvalid && dec_m_tready;

    // 给 FIFO 的复位同步到 core_clk（和你原来一致思路）
    reg rst_sync_r1, rst_sync_r2;
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            rst_sync_r1 <= 1'b1;
            rst_sync_r2 <= 1'b1;
        end else begin
            rst_sync_r1 <= 1'b0;
            rst_sync_r2 <= rst_sync_r1;
        end
    end
    wire rst_sync = rst_sync_r2;

    // 这里用你现有的 fifo_sim_8_32（8->32）
    fifo_sim_8_32 output_fifo_inst (
        .srst        (rst_sync),
        .wr_clk      (core_clk),
        .rd_clk      (output_clk),
        .din         (dec_m_tdata),
        .wr_en       (wr_xfer),
        .rd_en       (output_tvalid && output_tready),
        .dout        (fifo_dout_word),
        .full        (fifo_full),
        .empty       (fifo_empty),
        .wr_rst_busy (fifo_wr_rst_busy),
        .rd_rst_busy (fifo_rd_rst_busy)
    );

    // 读端 AXIS-like 输出（32-bit）
    assign output_tvalid = (!fifo_empty) && (!fifo_rd_rst_busy);
    assign output_tdata  = fifo_dout_word;

endmodule
