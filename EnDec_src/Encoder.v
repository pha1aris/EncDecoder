module Encoder (
    rst,
    input_fifo_clk,
    core_clk,
    data_i,
    data_valid_i,
    input_fifo_wrrdy,
    m_axis_output_tdata,
    m_axis_output_tvalid,
    m_axis_output_tready,
    m_axis_output_tlast
);

    // ===== 参数放模块内部（避免 module #(...) 语法）
    parameter K_BYTES = 229;   // 必须与你 rs_encoder_0 的输入块长度(k字节)一致

    // ===== 端口声明（非 ANSI 写法，更兼容）
    input  rst;
    input  input_fifo_clk;
    input  core_clk;

    input  [31:0] data_i;
    input         data_valid_i;
    output        input_fifo_wrrdy;

    output [7:0]  m_axis_output_tdata;
    output        m_axis_output_tvalid;
    input         m_axis_output_tready;
    output        m_axis_output_tlast;

    // =========================================================
    // clog2 function (Verilog-1995/2001 compatible)
    // =========================================================
    function integer clog2;
        input integer value;
        integer i;
        begin
            if (value <= 1) begin
                clog2 = 1;
            end else begin
                value = value - 1;
                for (i = 0; value > 0; i = i + 1)
                    value = value >> 1;
                clog2 = i;
            end
        end
    endfunction

    localparam integer CNT_W = clog2(K_BYTES);

    // =========================================================
    // 1) Async FIFO 32w->8r
    // =========================================================
    wire        fifo_full, fifo_empty, fifo_wr_rst_busy, fifo_rd_rst_busy;
    wire [7:0]  fifo_dout;

    assign input_fifo_wrrdy = (!fifo_full) && (!fifo_wr_rst_busy);

    // rd_en 必须等 RS encoder 真的吃掉一个字节才读
    wire rd_xfer;

    fifo_32w_8r input_buf (
        .srst        (rst),
        .wr_clk      (input_fifo_clk),
        .rd_clk      (core_clk),
        .din         (data_i),
        .wr_en       (data_valid_i && input_fifo_wrrdy),
        .rd_en       (rd_xfer),
        .dout        (fifo_dout),
        .full        (fifo_full),
        .empty       (fifo_empty),
        .wr_rst_busy (fifo_wr_rst_busy),
        .rd_rst_busy (fifo_rd_rst_busy)
    );

    // =========================================================
    // 2) AXIS into RS Encoder
    // =========================================================
    wire [7:0]  s_axis_tdata;
    wire        s_axis_tvalid;
    wire        s_axis_tready;

    assign s_axis_tdata  = fifo_dout;
    assign s_axis_tvalid = (!fifo_empty) && (!fifo_rd_rst_busy);

    // =========================================================
    // 3) TLAST counter (only advance on handshake)
    // =========================================================
    reg [CNT_W-1:0] byte_cnt;

    wire xfer_in;
    assign xfer_in = s_axis_tvalid && s_axis_tready;

    wire s_axis_tlast;
    assign s_axis_tlast = (byte_cnt == (K_BYTES-1));

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            byte_cnt <= {CNT_W{1'b0}};
        end else if (xfer_in) begin
            if (s_axis_tlast)
                byte_cnt <= {CNT_W{1'b0}};
            else
                byte_cnt <= byte_cnt + 1'b1;
        end
    end

    // FIFO read enable：仅当 RS encoder 消费一个字节才读出下一个
    assign rd_xfer = xfer_in;

    // =========================================================
    // 4) RS Encoder IP
    // =========================================================
    wire event_s_input_tlast_missing, event_s_input_tlast_unexpected;

    rs_encoder_0 u_rs_enc (
        .aclk                           (core_clk),
        .s_axis_input_tdata             (s_axis_tdata),
        .s_axis_input_tvalid            (s_axis_tvalid),
        .s_axis_input_tready            (s_axis_tready),
        .s_axis_input_tlast             (s_axis_tlast),

        .m_axis_output_tdata            (m_axis_output_tdata),
        .m_axis_output_tvalid           (m_axis_output_tvalid),
        .m_axis_output_tready           (m_axis_output_tready),
        .m_axis_output_tlast            (m_axis_output_tlast),

        .event_s_input_tlast_missing    (event_s_input_tlast_missing),
        .event_s_input_tlast_unexpected (event_s_input_tlast_unexpected)
    );


endmodule
