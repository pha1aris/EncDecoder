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
    // 2. 异步 FIFO : clk -> enc_clk
    //================================================================
    wire       full, empty;
    wire       wr_rst_busy, rd_rst_busy;
    wire [7:0] fifo_dout;
    wire       fifo_rd_en;

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

    // always@(posedge clk or posedge reset_sync)begin
    //     if(fifo_input_rdy && data_valid_i)
    //         $display("fifo rd data:%d",data_i);
    // end
    // always@(posedge enc_clk or posedge reset_sync)begin
    //     if(fifo_rd_en)
    //         $display("fifo wr data:%d",fifo_dout);
    // end
    //================================================================
    // 3. enc_clk 域：RS Encoder 输入 AXIS 打拍 + 计数产生 tlast
    //================================================================
    reg [7:0] s_data_reg;
    reg       s_valid_reg;

    reg [7:0] byte_cnt;          // 足够覆盖 RS_K=229
    wire      s_ready;           // 来自 Encoder 的 tready
    wire      fire;              // 一次有效握手

    assign fire = s_valid_reg && s_ready;

    // FIFO 读使能：
    //  - 不在 rd_rst_busy 期间
    //  - FIFO 非空
    //  - Encoder 这边“有位置”：当前没有有效数据，或者本拍刚好 handshake 消费掉
    assign fifo_rd_en =
        !rd_rst_busy && !empty &&
        ((!s_valid_reg) || fire);

    // 数据 / valid / last 寄存器
    always @(posedge enc_clk or posedge rst_enc) begin
        if (rst_enc) begin
            s_data_reg  <= 8'd0;
            s_valid_reg <= 1'b0;
        end else begin
            if (fifo_rd_en) begin
                s_data_reg  <= fifo_dout;
                s_valid_reg <= 1'b1;
            end else if (fire) begin
                s_valid_reg <= 1'b0;
            end
        end
    end

    // 字节计数：只在真正握手 fire 时计数
    always @(posedge enc_clk or posedge rst_enc) begin
        if (rst_enc) begin
            byte_cnt <= 8'd0;
        end else begin
            if (fire) begin
                if (byte_cnt == RS_K-1) //0-228
                    byte_cnt <= 8'd0;          // 这一拍是第 RS_K 个字节→下一拍从 0 重新开始
                else
                    byte_cnt <= byte_cnt + 1'b1;
            end
        end
    end

    wire tlast;
    assign tlast = (byte_cnt == RS_K-1);

    //================================================================
    // 4. 接到 RS Encoder IP
    //================================================================
    wire event_s_input_tlast_missing;
    wire event_s_input_tlast_unexpected;

    wire [7:0] s_axis_input_tdata  = s_data_reg;
    wire       s_axis_input_tvalid = s_valid_reg;
    wire       s_axis_input_tlast  = tlast;

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
