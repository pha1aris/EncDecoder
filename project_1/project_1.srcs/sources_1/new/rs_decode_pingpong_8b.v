// 连续 8bit 码流 → 两个 rs_decoder_0 乒乓解码 → 连续 8bit 码流
// 每 255 个输入符号为一个 RS(255, 229) 码块。
`timescale 1ns/1ps

module rs_decode_pingpong_8b #(
    parameter integer RS_N = 255
)(
    input  wire        clk,
    input  wire        rst,     // 高有效复位

    // 来自去交织器的 8bit 码流（post-deinterleaver）
    input  wire [7:0]  i_data,
    input  wire        i_valid,
    output wire        i_ready,  // 目前假定 decoder 始终 ready，可直接忽略

    // 解码后的 8bit 码流
    output wire [7:0]  o_data,
    output wire        o_valid
    // 如果需要 tlast（每个码块结束）可再加一个 o_last
);

    // 当前码块送到哪个解码器：0 → dec0, 1 → dec1
    reg        pingpang;
    reg [8:0]  sym_cnt;       // 0 .. RS_N-1
    reg        tlast0;
    reg        tlast1;

    // 顶层暂时不做反压，假设乒乓设计满足 IP 连续码块约束
    assign i_ready = 1'b1;

    // 计数当前码块内符号，并在末符号时给当前 decoder 打 tlast + 切换 pingpang
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pingpang <= 1'b0;
            sym_cnt  <= 9'd0;
            tlast0   <= 1'b0;
            tlast1   <= 1'b0;
        end else begin
            tlast0   <= 1'b0;
            tlast1   <= 1'b0;

            if (i_valid) begin
                if (sym_cnt == RS_N-1) begin
                    sym_cnt <= 9'd0;

                    // 当前码块最后一个符号 → 当前 decoder 打 tlast
                    if (!pingpang)
                        tlast0 <= 1'b1;
                    else
                        tlast1 <= 1'b1;

                    // 下一个码块切换到另一个 decoder
                    pingpang <= ~pingpang;
                end else begin
                    sym_cnt <= sym_cnt + 1'b1;
                end
            end
        end
    end

    // -------- 输入 AXIS 拆到两个 decoder --------
    reg [7:0] s_tdata0, s_tdata1;
    reg       s_tvalid0, s_tvalid1;

    always @(*) begin
        // 默认不喂
        s_tdata0  = 8'd0;
        s_tvalid0 = 1'b0;
        s_tdata1  = 8'd0;
        s_tvalid1 = 1'b0;

        if (i_valid) begin
            if (!pingpang) begin
                s_tdata0  = i_data;
                s_tvalid0 = 1'b1;
            end else begin
                s_tdata1  = i_data;
                s_tvalid1 = 1'b1;
            end
        end
    end

    wire s_tready0;
    wire s_tready1;

    // -------- 两个 RS 解码 IP --------
    wire [7:0] m_tdata0, m_tdata1;
    wire       m_tvalid0, m_tvalid1;
    wire       m_tlast0,  m_tlast1;

    wire [7:0] m_stat0, m_stat1;
    wire       m_stat_valid0, m_stat_valid1;

    wire       ev_tlast_missing0, ev_tlast_unexp0, ev_ctrl_inv0;
    wire       ev_tlast_missing1, ev_tlast_unexp1, ev_ctrl_inv1;

    rs_decoder_0 u_dec0 (
        .aclk                       (clk),
        .s_axis_input_tdata         (s_tdata0),
        .s_axis_input_tvalid        (s_tvalid0),
        .s_axis_input_tready        (s_tready0),   // 当前设计里不往上用
        .s_axis_input_tlast         (tlast0),

        .m_axis_output_tdata        (m_tdata0),
        .m_axis_output_tvalid       (m_tvalid0),
        .m_axis_output_tready       (1'b1),
        .m_axis_output_tlast        (m_tlast0),

        .m_axis_stat_tdata          (m_stat0),
        .m_axis_stat_tvalid         (m_stat_valid0),
        .m_axis_stat_tready         (1'b1),

        .event_s_input_tlast_missing(ev_tlast_missing0),
        .event_s_input_tlast_unexpected(ev_tlast_unexp0),
        .event_s_ctrl_tdata_invalid (ev_ctrl_inv0)
    );

    rs_decoder_0 u_dec1 (
        .aclk                       (clk),
        .s_axis_input_tdata         (s_tdata1),
        .s_axis_input_tvalid        (s_tvalid1),
        .s_axis_input_tready        (s_tready1),
        .s_axis_input_tlast         (tlast1),

        .m_axis_output_tdata        (m_tdata1),
        .m_axis_output_tvalid       (m_tvalid1),
        .m_axis_output_tready       (1'b1),
        .m_axis_output_tlast        (m_tlast1),

        .m_axis_stat_tdata          (m_stat1),
        .m_axis_stat_tvalid         (m_stat_valid1),
        .m_axis_stat_tready         (1'b1),

        .event_s_input_tlast_missing(ev_tlast_missing1),
        .event_s_input_tlast_unexpected(ev_tlast_unexp1),
        .event_s_ctrl_tdata_invalid (ev_ctrl_inv1)
    );

    // -------- 输出合并 --------
    // 正常情况下，Xilinx 这个 RS Decoder 的输出在时间上不会两个核同时 valid
    // （是“块”为单位连续吐数据），所以简单优先级选择就够用。
    assign o_valid = m_tvalid0 | m_tvalid1;
    assign o_data  = m_tvalid0 ? m_tdata0 : m_tdata1;

endmodule
