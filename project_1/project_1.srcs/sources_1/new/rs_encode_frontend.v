// 每收到 K=229 个字节，就给 rs_encoder_0 一个 tlast。
// 上游只要给连续的 8bit 流即可。
module rs_encode_frontend (
    input        clk,                    // 上游 8bit 数据时钟
    input        enc_clk,                // RS 编码 IP 的工作时钟
    input        rst,

    // 上游 8 bit 输入
    output       fifo_input_rdy,
    input  [7:0] data_i,
    input        data_valid_i,

    // 下游 RS 编码 IP 的 AXIS 输出
    input        m_axis_output_tready,
    output [7:0] m_axis_output_tdata,
    output       m_axis_output_tvalid,
    output       m_axis_output_tlast
);

    // ================= FIFO: clk -> enc_clk, 8b 异步 FIFO =================
    wire [7:0] dout;
    wire       full, empty;
    wire       wr_rst_busy, rd_rst_busy;
    reg        rd_en;

    // 上游就看 ready：FIFO 不满且写侧没 rst_busy
    assign fifo_input_rdy = !full && !wr_rst_busy;

    // 写侧复位同步到 clk
    reg reset_sync_r1, reset_sync_r2;
    wire reset_sync;
    always @(posedge clk or posedge rst) begin
        if (rst) {reset_sync_r1, reset_sync_r2} <= 2'b11;
        else      {reset_sync_r1, reset_sync_r2} <= {1'b0, reset_sync_r1};
    end
    assign reset_sync = reset_sync_r2;

    // 异步 FIFO：wr_clk=clk, rd_clk=enc_clk
    fifo_0 fifo0_inst2 (
      .srst        (reset_sync),
      .wr_clk      (clk),
      .rd_clk      (enc_clk),
      .din         (data_i),
      .wr_en       (fifo_input_rdy && data_valid_i),
      .rd_en       (rd_en),
      .dout        (dout),
      .full        (full),
      .empty       (empty),
      .wr_rst_busy (wr_rst_busy),
      .rd_rst_busy (rd_rst_busy)
    );

    // ================= enc_clk 域：按 229 字节打包，喂 rs_encoder_0 =================

    // 延迟一段时间再开始读 FIFO，避免刚启动就读空
    localparam DLY_VALUE = 8'd46;
    reg [7:0] dly_cnt;
    reg       rd_begin;

    // 给 rs_encoder 的 AXIS 接口信号
    wire [7:0] s_axis_input_tdata;
    wire       s_axis_input_tvalid;
    wire       s_axis_input_tready;
    wire       s_axis_input_tlast;

    // debug 事件
    wire event_s_input_tlast_missing;
    wire event_s_input_tlast_unexpected;

    // 延时计数 + 启动标志
    always @(posedge enc_clk or posedge rst) begin
        if (rst) begin
            dly_cnt  <= 8'd0;
            rd_begin <= 1'b0;
        end else begin
            if (!rd_rst_busy && !rd_begin) begin
                // 只在还没开始读、且读侧不在复位忙状态时计数
                if (dly_cnt != DLY_VALUE)
                    dly_cnt <= dly_cnt + 1'b1;

                // 满足“延时 + FIFO 有数据 + 编码 IP ready”再正式起跑
                if (dly_cnt == DLY_VALUE && !empty && s_axis_input_tready)
                    rd_begin <= 1'b1;
            end
        end
    end

    // 当前码字内已经“成功送给 IP 的字节数”（0~228，共 229 个字节）
    reg [7:0] byte_cnt;

    // FIFO 到 encoder 的握手：
    //  - valid：rd_begin 后，只要 FIFO 不空且读侧不忙就一直拉高
    //  - ready：来自 rs_encoder_0 的 s_axis_input_tready
    //  - 真正的一次“传输成功” = valid && ready
    wire s_valid_raw  = rd_begin && !empty && !rd_rst_busy;
    wire xfer         = s_valid_raw && s_axis_input_tready;

    // 给 RS 编码 IP 的输入
    assign s_axis_input_tdata  = dout;                     // FWFT FIFO：dout 在 empty=0 时是当前头元素
    assign s_axis_input_tvalid = s_valid_raw;
    assign s_axis_input_tlast  = (byte_cnt == 8'd228) && xfer;

    // FIFO 读使能：只在真正有一次 xfer 时才 pop 一字节
    always @(posedge enc_clk or posedge rst) begin
        if (rst) begin
            rd_en <= 1'b0;
        end else begin
            rd_en <= xfer;
        end
    end

    // 229 字节计数：只在 xfer 时才累加
    always @(posedge enc_clk or posedge rst) begin
        if (rst) begin
            byte_cnt <= 8'd0;
        end else if (!rd_begin) begin
            // 等待起跑阶段，计数保持 0
            byte_cnt <= 8'd0;
        end else if (xfer) begin
            if (byte_cnt == 8'd228)
                // 最后一个字节这次传输完，下一拍回到 0，开始下一帧
                byte_cnt <= 8'd0;
            else
                byte_cnt <= byte_cnt + 1'b1;
        end
    end

    // ================= RS 编码 IP =================
    rs_encoder_0 Encoder (
      .aclk                             (enc_clk),
      .s_axis_input_tdata               (s_axis_input_tdata),
      .s_axis_input_tvalid              (s_axis_input_tvalid),
      .s_axis_input_tready              (s_axis_input_tready),
      .s_axis_input_tlast               (s_axis_input_tlast),

      .m_axis_output_tdata              (m_axis_output_tdata),
      .m_axis_output_tvalid             (m_axis_output_tvalid),
      .m_axis_output_tready             (m_axis_output_tready),
      .m_axis_output_tlast              (m_axis_output_tlast),

      .event_s_input_tlast_missing      (event_s_input_tlast_missing),
      .event_s_input_tlast_unexpected   (event_s_input_tlast_unexpected)
    );

endmodule