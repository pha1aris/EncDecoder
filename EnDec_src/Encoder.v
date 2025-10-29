// 引入数据反压的编码器逻辑
module Encoder(
    input  wire         rst,
    input  wire         input_fifo_clk, // Clock for FIFO write domain
    input  wire         core_clk,       // Clock for core logic & FIFO read domain

    // 32-bit Custom Input Interface
    input  wire [31:0]  data_i,
    input  wire         data_valid_i,
    output wire         input_fifo_wrrdy,

    // AXI-Stream Master Interface
    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    input  wire         m_axis_output_tready,
    output wire         m_axis_output_tlast
);

    //----------------------------------------------------------------
    // 1. 内部信号定义 (Internal Signals)
    //----------------------------------------------------------------
    wire        fifo_full, fifo_empty, fifo_wr_rst_busy, fifo_rd_rst_busy;
    wire [7:0]  fifo_dout;
    wire        fifo_rd_en;

    wire [7:0]  enc_s_axis_tdata;
    wire        enc_s_axis_tvalid;
    wire        enc_s_axis_tready;
    wire        enc_s_axis_tlast;

    reg  [7:0]  packet_byte_cnt;

    // 握手信号，表示一次有效的数据传输
    wire        transfer_happen = enc_s_axis_tvalid && enc_s_axis_tready;

    //----------------------------------------------------------------
    // 2. 异步FIFO (宽度与时钟域转换)
    //----------------------------------------------------------------
    // 只有当FIFO未满且未处于复位状态时，才准备好接收上游数据
    assign input_fifo_wrrdy = !fifo_full && !fifo_wr_rst_busy;

    // 只有在下游准备好且本级有有效数据时，才从FIFO读取数据
    assign fifo_rd_en = transfer_happen;

    fifo_32w_8r input_buf (
        .srst       (rst),
        .wr_clk     (input_fifo_clk),
        .rd_clk     (core_clk),
        .din        (data_i),
        .wr_en      (data_valid_i && input_fifo_wrrdy),
        .rd_en      (fifo_rd_en),
        .dout       (fifo_dout),
        .full       (fifo_full),
        .empty      (fifo_empty),
        .wr_rst_busy(fifo_wr_rst_busy),
        .rd_rst_busy(fifo_rd_rst_busy)
    );
    
    //----------------------------------------------------------------
    // 3. AXI-Stream 逻辑与包生成
    //----------------------------------------------------------------
    assign enc_s_axis_tdata  = fifo_dout;
    assign enc_s_axis_tvalid = !fifo_empty && !fifo_rd_rst_busy;
    
    // 当计数器达到229时，生成tlast信号
    assign enc_s_axis_tlast = (packet_byte_cnt == 8'd229);

    // 包字节计数器
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            packet_byte_cnt <= 8'd1;
        end else if (transfer_happen) begin
            // 如果当前是包的最后一个字节，则下一个计数从1开始
            // 否则，计数器加1
            if (enc_s_axis_tlast) begin
                packet_byte_cnt <= 8'd1;
            end else begin
                packet_byte_cnt <= packet_byte_cnt + 1'b1;
            end
        end
    end

    //----------------------------------------------------------------
    // 4. RS编码器实例化
    //----------------------------------------------------------------
    // (未使用的调试端口可以悬空，但连接到wire可以帮助调试)
    wire event_s_input_tlast_missing, event_s_input_tlast_unexpected;

    rs_encoder_0 Encoder_inst (
        .aclk                       (core_clk),
        .s_axis_input_tdata         (enc_s_axis_tdata),
        .s_axis_input_tvalid        (enc_s_axis_tvalid),
        .s_axis_input_tready        (enc_s_axis_tready),
        .s_axis_input_tlast         (enc_s_axis_tlast),
        .m_axis_output_tdata        (m_axis_output_tdata),
        .m_axis_output_tvalid       (m_axis_output_tvalid),
        .m_axis_output_tready       (m_axis_output_tready),
        .m_axis_output_tlast        (m_axis_output_tlast),
        .event_s_input_tlast_missing(event_s_input_tlast_missing),
        .event_s_input_tlast_unexpected(event_s_input_tlast_unexpected)
    );

endmodule