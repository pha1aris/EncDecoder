`timescale 1ns/1ps

// 每收到 RS_K 个字节，就给 rs_encoder_0 一个 tlast。
// 上游只要给连续的 8bit 流即可。
module rs_encode_frontend #(
    parameter integer RS_K = 229    // RS(255,229) 的信息字节数
)(
    input        clk,      // 写时钟（上游 8bit）
    input        enc_clk,  // 读时钟（RS Encoder 时钟）
    input        rst,      // 异步复位，高有效

    // 上游 8bit 输入
    output       fifo_input_rdy,
    input  [7:0] data_i,
    input        data_valid_i,

    // 下游 RS Encoder AXI-Stream
    input        m_axis_output_tready,
    output [7:0] m_axis_output_tdata,
    output       m_axis_output_tvalid,
    output       m_axis_output_tlast
);

    //================================================================
    // 1. 复位同步
    //================================================================
    // enc_clk 域的同步复位
    reg rst_enc_sync_r1, rst_enc_sync_r2;
    wire rst_enc;

    always @(posedge enc_clk or posedge rst) begin
        if (rst) begin
            rst_enc_sync_r1 <= 1'b1;
            rst_enc_sync_r2 <= 1'b1;
        end else begin
            rst_enc_sync_r1 <= 1'b0;
            rst_enc_sync_r2 <= rst_enc_sync_r1;
        end
    end
    assign rst_enc = rst_enc_sync_r2;

    // clk 域的同步复位，给 FIFO 的 srst 用
    reg reset_sync_r1, reset_sync_r2;
    wire reset_sync;
    always @(posedge clk or posedge rst) begin
        if (rst) {reset_sync_r1, reset_sync_r2} <= 2'b11;
        else     {reset_sync_r1, reset_sync_r2} <= {1'b0, reset_sync_r1};
    end
    assign reset_sync = reset_sync_r2;

    //================================================================
    // 2. 异步 FIFO : clk -> enc_clk  (配置为 FWFT: First-Word Fall-Through)
    //================================================================
    wire       full, empty;
    wire       wr_rst_busy, rd_rst_busy;
    wire [7:0] fifo_dout;
    wire       fifo_rd_en;

    // 写侧反压
    assign fifo_input_rdy = !full && !wr_rst_busy;

    fifo_0 fifo0_inst2 (
        .srst        (reset_sync),
        .wr_clk      (clk),
        .rd_clk      (enc_clk),
        .din         (data_i),
        .wr_en       (fifo_input_rdy && data_valid_i),
        .rd_en       (fifo_rd_en),
        .dout        (fifo_dout),
        .full        (full),
        .empty       (empty),
        .wr_rst_busy (wr_rst_busy),
        .rd_rst_busy (rd_rst_busy)
    );

    //================================================================
    // 3. enc_clk 域：FWFT FIFO -> RS Encoder AXIS
    //
    // 关键点（FWFT）：
    // - FIFO 非空时，dout 已经是“当前字”，无需先 rd_en 预取
    // - 只有当下游真正握手接收时（fire）才 rd_en pop，下一个字会在随后更新到 dout
    //================================================================
    wire fifo_vld = (!empty) && (!rd_rst_busy) && (!rst_enc);

    wire s_ready;     // 来自 RS Encoder 的 tready
    wire fire = fifo_vld && s_ready;

    // 仅在握手时 pop
    assign fifo_rd_en = fire;

    // 直接驱动 AXIS 输入
    wire [7:0] s_axis_input_tdata  = fifo_dout;
    wire       s_axis_input_tvalid = fifo_vld;

    //================================================================
    // 4. 计数产生 tlast：只在 fire 时计数
    //================================================================
    reg [7:0] byte_cnt;  // RS_K=229 足够覆盖

    always @(posedge enc_clk or posedge rst_enc) begin
        if (rst_enc) begin
            byte_cnt <= 8'd0;
        end else if (fire) begin
            if (byte_cnt == RS_K-1)
                byte_cnt <= 8'd0;
            else
                byte_cnt <= byte_cnt + 1'b1;
        end
    end

    wire s_axis_input_tlast = (byte_cnt == RS_K-1);

    //================================================================
    // 5. 接到 RS Encoder IP
    //================================================================
    wire event_s_input_tlast_missing;
    wire event_s_input_tlast_unexpected;

    rs_encoder_0 Encoder (
        .aclk                           (enc_clk),
        .s_axis_input_tdata             (s_axis_input_tdata),
        .s_axis_input_tvalid            (s_axis_input_tvalid),
        .s_axis_input_tready            (s_ready),
        .s_axis_input_tlast             (s_axis_input_tlast),
        .m_axis_output_tdata            (m_axis_output_tdata),
        .m_axis_output_tvalid           (m_axis_output_tvalid),
        .m_axis_output_tready           (m_axis_output_tready),
        .m_axis_output_tlast            (m_axis_output_tlast),
        .event_s_input_tlast_missing    (event_s_input_tlast_missing),
        .event_s_input_tlast_unexpected (event_s_input_tlast_unexpected)
    );

endmodule
