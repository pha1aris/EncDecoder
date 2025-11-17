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

      reg [7:0] byte_cnt;
    wire full, empty, wr_rst_busy, rd_rst_busy;
    wire [7:0] dout;
    reg rd_en;
    assign fifo_input_rdy = !full && !wr_rst_busy;
    wire [7 : 0] s_axis_input_tdata;
    wire s_axis_input_tvalid;
    wire s_axis_input_tready;
    wire s_axis_input_tlast;
    //debug
    wire event_s_input_tlast_missing;
    wire event_s_input_tlast_unexpected;

    assign s_axis_input_tdata = (byte_cnt >= 1 && byte_cnt <= 229) ? dout : 'd0;
    assign s_axis_input_tvalid = (byte_cnt >= 1 && byte_cnt <= 229);
    assign s_axis_input_tlast = (byte_cnt == 229);

    reg reset_sync_r1, reset_sync_r2;
    wire reset_sync;
    always @(posedge clk or posedge rst) begin
        if (rst) {reset_sync_r1, reset_sync_r2} <= 2'b11;
        else      {reset_sync_r1, reset_sync_r2} <= {1'b0,reset_sync_r1};
    end
    assign reset_sync = reset_sync_r2;

    fifo_0 fifo0_inst2 (
      .srst(reset_sync),                       // input wire srst
      .wr_clk(clk),                     // input wire wr_clk
      .rd_clk(enc_clk),                  // input wire rd_clk
      .din(data_i),                     // input wire [7 : 0] din
      .wr_en(fifo_input_rdy && data_valid_i),// input wire wr_en
      .rd_en(rd_en),                    // input wire rd_en
      .dout(dout),                      // output wire [7 : 0] dout
      .full(full),                      // output wire full
      .empty(empty),                    // output wire empty
      .wr_rst_busy(wr_rst_busy),        // output wire wr_rst_busy
      .rd_rst_busy(rd_rst_busy)         // output wire rd_rst_busy
    );

//delay 
    parameter DLY_VALUE = 8'd46;
    reg [7:0] dly_cnt;
    reg rd_begin;

    always @(posedge enc_clk or posedge rst) begin 
        if(rst) begin
            dly_cnt <= 'd0;
        end 
        else if(!rd_rst_busy) begin
            dly_cnt <= dly_cnt + 1'b1;
        end
    end

    always @(posedge enc_clk or posedge rst) begin 
        if(rst) begin
            rd_begin <= 0;
        end else if(s_axis_input_tready && (!empty && !rd_rst_busy)&& dly_cnt == DLY_VALUE) begin
            rd_begin <= 1'b1;
        end
    end

    always @(posedge enc_clk or posedge rst) begin //rs 255,229; byte_cnt 1~229
        if(rst) begin
            byte_cnt <= 'd0;
            rd_en <= 1'b0;
        end 
        else if(s_axis_input_tready && (!empty && !rd_rst_busy) && byte_cnt <228 && rd_begin)  begin //1~227
            byte_cnt <= byte_cnt + 1'b1;
            rd_en <= 1'b1;
        end
        else if (byte_cnt == 228)begin
            byte_cnt <= byte_cnt + 1'b1;
            rd_en <= 1'b1;
        end 
        else if(byte_cnt == 'd229)begin
            byte_cnt <= 'd0;
            rd_en <= 1'b0;
        end
    end

    rs_encoder_0 Encoder (
      .aclk                             (enc_clk),                                                      // input wire aclk
      .s_axis_input_tdata               (s_axis_input_tdata),                          // input wire [7 : 0] s_axis_input_tdata
      .s_axis_input_tvalid              (s_axis_input_tvalid),                        // input wire s_axis_input_tvalid
      .s_axis_input_tready              (s_axis_input_tready),                        // output wire s_axis_input_tready
      .s_axis_input_tlast               (s_axis_input_tlast),                          // input wire s_axis_input_tlast
      .m_axis_output_tdata              (m_axis_output_tdata),                        // output wire [7 : 0] m_axis_output_tdata
      .m_axis_output_tvalid             (m_axis_output_tvalid),                      // output wire m_axis_output_tvalid
      .m_axis_output_tready             (m_axis_output_tready),                      // input wire m_axis_output_tready
      .m_axis_output_tlast              (m_axis_output_tlast),                        // output wire m_axis_output_tlast
      .event_s_input_tlast_missing      (event_s_input_tlast_missing),        // output wire event_s_input_tlast_missing
      .event_s_input_tlast_unexpected   (event_s_input_tlast_unexpected)  // output wire event_s_input_tlast_unexpected
    );
    
endmodule