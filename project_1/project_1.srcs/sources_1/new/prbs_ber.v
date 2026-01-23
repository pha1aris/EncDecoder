`timescale 1ns/1ps

module prbs_ber #(
    parameter integer NBITS = 8
)(
    input  wire             core_clk,
    input  wire             logic_rst_n,   // active-high "not reset"
    input  wire             ber_clr,       // async from VIO, module内部会同步成 pulse

    input  wire             use_prbs,      // 1: PRBS mode
    input  wire             rx_valid,      // 每个 byte 有效
    input  wire [NBITS-1:0] rx_data,

    input  wire             meas_ok,       
    input  wire             prbs_seed_rst, 

    output reg  [63:0]      bit_cnt,
    output reg  [63:0]      err_cnt,

    output reg  [31:0]      ber_q32,       
    output reg              ber_valid
);

    wire logic_rst = ~logic_rst_n;

    // ------------------------------------------------------------
    // 1) ber_clr 同步成 pulse
    // ------------------------------------------------------------
    reg ber_clr_ff1, ber_clr_ff2, ber_clr_ff2_d;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_clr_ff1   <= 1'b0;
            ber_clr_ff2   <= 1'b0;
            ber_clr_ff2_d <= 1'b0;
        end else begin
            ber_clr_ff1   <= ber_clr;
            ber_clr_ff2   <= ber_clr_ff1;
            ber_clr_ff2_d <= ber_clr_ff2;
        end
    end
    wire ber_clear_pulse = ber_clr_ff2 & ~ber_clr_ff2_d;

    // ------------------------------------------------------------
    // 2) PRBS checker
    // ------------------------------------------------------------
    wire prbs_chk_en;
    wire [NBITS-1:0] prbs_err_vec_int;
    (* MARK_DEBUG="true" *) wire prbs_chk_rst = logic_rst | ber_clear_pulse | prbs_seed_rst;
    assign prbs_chk_en = use_prbs & rx_valid;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (NBITS)
    ) u_prbs_chk_rx (
        .RST      (prbs_chk_rst),
        .CLK      (core_clk),
        .DATA_IN  (rx_data),
        .EN       (prbs_chk_en),
        .DATA_OUT (prbs_err_vec_int)
    );

    // popcount
    function integer popcount;
        input [NBITS-1:0] v;
        integer k;
        begin
            popcount = 0;
            for (k = 0; k < NBITS; k = k + 1)
                popcount = popcount + v[k];
        end
    endfunction

    (* MARK_DEBUG="true" *) wire [7:0] err_bits = popcount(prbs_err_vec_int);
    (* MARK_DEBUG="true" *) wire prbs_match;
    assign prbs_match = ~|prbs_err_vec_int;

    // ------------------------------------------------------------
    // 3) 计数
    // ------------------------------------------------------------
    always @(posedge core_clk) begin
        if (logic_rst || ber_clear_pulse) begin
            bit_cnt <= 64'd0;
            err_cnt <= 64'd0;
        end else if (prbs_chk_en && meas_ok) begin
            bit_cnt <= bit_cnt + NBITS;                         
            err_cnt <= err_cnt + {{56{1'b0}}, err_bits};         
        end
    end

    // ------------------------------------------------------------
    // 4) 用 div_gen_0 算 Q32
    // ------------------------------------------------------------
`ifdef USE_DIV_GEN_0
    reg [2:0] div_clr_cnt;
    always @(posedge core_clk) begin
        if (logic_rst) begin
            div_clr_cnt <= 3'd0;
        end else if (ber_clear_pulse) begin
            div_clr_cnt <= 3'd4;
        end else if (div_clr_cnt != 0) begin
            div_clr_cnt <= div_clr_cnt - 1'b1;
        end
    end

    wire div_clear_stretch = (div_clr_cnt != 0);
    wire div_aresetn = logic_rst_n & ~div_clear_stretch;

    reg        div_valid;
    reg [63:0] div_dividend_reg; // err
    reg [63:0] div_divisor_reg;  // bits

    wire        m_axis_dout_tvalid;
    wire [95:0] m_axis_dout_tdata;
    wire        s_axis_divisor_tready;
    wire        s_axis_dividend_tready;
    wire div_fire = div_valid && s_axis_dividend_tready && s_axis_divisor_tready;

    always @(posedge core_clk) begin
        if (!div_aresetn) begin
            div_valid        <= 1'b0;
            div_dividend_reg <= 64'd0;
            div_divisor_reg  <= 64'd1;
        end else begin
            if (!div_valid) begin
                if (bit_cnt != 0) begin
                    div_valid        <= 1'b1;
                    div_dividend_reg <= err_cnt;
                    div_divisor_reg  <= bit_cnt;
                end
            end else if (div_fire) begin
                div_dividend_reg <= err_cnt;
                div_divisor_reg  <= (bit_cnt == 0) ? 64'd1 : bit_cnt;
                div_valid        <= (bit_cnt != 0);
            end
        end
    end

    div_gen_0 u_ber_div (
        .aclk                   (core_clk),
        .aresetn                (div_aresetn),

        .s_axis_divisor_tvalid  (div_valid),
        .s_axis_divisor_tready  (s_axis_divisor_tready),
        .s_axis_divisor_tdata   (div_divisor_reg),

        .s_axis_dividend_tvalid (div_valid),
        .s_axis_dividend_tready (s_axis_dividend_tready),
        .s_axis_dividend_tdata  (div_dividend_reg),

        .m_axis_dout_tvalid     (m_axis_dout_tvalid),
        .m_axis_dout_tuser      (),
        .m_axis_dout_tdata      (m_axis_dout_tdata)
    );

    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_q32   <= 32'd0;
            ber_valid <= 1'b0;
        end else begin
            ber_valid <= m_axis_dout_tvalid;
            if (m_axis_dout_tvalid)
                ber_q32 <= m_axis_dout_tdata[31:0];
        end
    end
`else
    always @(posedge core_clk) begin
        if (logic_rst) begin
            ber_q32   <= 32'd0;
            ber_valid <= 1'b0;
        end else begin
            ber_q32   <= 32'd0;
            ber_valid <= 1'b0;
        end
    end
`endif

endmodule
