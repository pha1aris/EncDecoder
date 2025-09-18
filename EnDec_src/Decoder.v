module Decoder(
    input wire         rst,
    input wire         core_clk,

    // 8-bit AXI Stream Input
    input wire  [7:0]  s_axis_input_tdata,
    input wire         s_axis_input_tvalid,
    input wire         s_axis_input_tlast,
    output wire        s_axis_input_tready,

    // 32-bit AXI Stream Output
    output wire [31:0] output_tdata,
    output wire        output_tvalid,
    input wire         output_tready // [改进] 增加了标准的下游 tready 信号
);

//================================================================
// 1. Ping-Pong Control and Input Demultiplexing
//================================================================
reg pingpang; // 0: Decoder_U0 is active (writing), 1: Decoder_U1 is active (writing)

reg [7:0] s_axis_input_tdata0, s_axis_input_tdata1;
reg       s_axis_input_tvalid0, s_axis_input_tvalid1;
reg       s_axis_input_tlast0, s_axis_input_tlast1;
wire      s_axis_input_tready0, s_axis_input_tready1;

assign s_axis_input_tready = !pingpang ? s_axis_input_tready0 : s_axis_input_tready1;

always @(posedge core_clk or posedge rst) begin
    if(rst) begin
        pingpang <= 1'b0;
    end else if(s_axis_input_tlast && s_axis_input_tvalid && s_axis_input_tready) begin
        pingpang <= ~pingpang;
    end
end

always @(*) begin
    if (!pingpang) begin // Route to Decoder_U0
        s_axis_input_tdata0  = s_axis_input_tdata;
        s_axis_input_tvalid0 = s_axis_input_tvalid;
        s_axis_input_tlast0  = s_axis_input_tlast;
        s_axis_input_tdata1  = 8'b0;
        s_axis_input_tvalid1 = 1'b0;
        s_axis_input_tlast1  = 1'b0;
    end else begin // Route to Decoder_U1
        s_axis_input_tdata0  = 8'b0;
        s_axis_input_tvalid0 = 1'b0;
        s_axis_input_tlast0  = 1'b0;
        s_axis_input_tdata1  = s_axis_input_tdata;
        s_axis_input_tvalid1 = s_axis_input_tvalid;
        s_axis_input_tlast1  = s_axis_input_tlast;
    end
end

//================================================================
// 2. Decoder Instantiations
//================================================================
wire [7:0] m_axis_output_tdata0, m_axis_output_tdata1;
wire       m_axis_output_tvalid0, m_axis_output_tvalid1;
wire       m_axis_output_tlast0, m_axis_output_tlast1;
wire       decoder_tready; // Common tready for both decoders

// Unused ports...
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

//================================================================
// 3. Output Buffering and Combination
//================================================================
wire [7:0] fifo_input_tdata;
wire       fifo_input_tvalid;
wire       fifo_wr_en;
wire       fifo_full, fifo_empty, fifo_wr_rst_busy, fifo_rd_rst_busy;
wire       fifo_rd_en;
reg  rst_sync_r1, rst_sync_r2;
wire rst_sync;

reg select; // 0:取decoder0, 1:取decoder1

always @(*) begin
    if (m_axis_output_tvalid0) begin
        select = 1'b0;
    end else if (m_axis_output_tvalid1) begin
        select = 1'b1;
    end else begin
        select = 1'b0; // default
    end
end

wire [7:0] Dec_output_tdata;
wire Dec_output_valid;
assign Dec_output_valid = m_axis_output_tvalid0 | m_axis_output_tvalid1;
assign Dec_output_tdata = (select == 1'b0) ? m_axis_output_tdata0
                                           : m_axis_output_tdata1;

// 定义FIFO写使能和解码器tready信号
assign fifo_wr_en = Dec_output_valid;
assign decoder_tready = !fifo_full && !fifo_wr_rst_busy;

// 创建并使用同步复位
always @(posedge core_clk or posedge rst) begin
    if(rst) {rst_sync_r1, rst_sync_r2} <= 2'b11;
    else    {rst_sync_r1, rst_sync_r2} <= {1'b0, rst_sync_r1};
end
assign rst_sync = rst_sync_r2;

fifo_sim_8_32 output_fifo_inst (
  .srst         (rst_sync), 
  .wr_clk       (core_clk),
  .rd_clk       (core_clk),
  .din          (Dec_output_tdata),
  .wr_en        (Dec_output_valid), 
  .rd_en        (fifo_rd_en), 
  .dout         (output_tdata),
  .full         (fifo_full),
  .empty        (fifo_empty),
  .wr_rst_busy  (fifo_wr_rst_busy),
  .rd_rst_busy  (fifo_rd_rst_busy)
);

// 实现标准的AXIS输出握手逻辑
assign output_tvalid = !fifo_empty;
assign fifo_rd_en = !fifo_empty && !fifo_rd_rst_busy;

endmodule