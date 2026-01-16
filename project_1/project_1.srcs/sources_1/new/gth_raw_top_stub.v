`timescale 1ns/1ps

module gth_raw_top_stub #(
    parameter integer W = 32,
    parameter integer INIT_BIT_OFFSET = 0
)(
    input  wire         freerun_clk,
    input  wire         gth_reset_all,

    input  wire [2:0]   i_loopback,

    output wire         o_tx_clk,
    output reg          o_tx_rst_n,
    output reg          o_tx_done,
    output reg          o_tx_active,
    input  wire [W-1:0] i_tx_data,

    output wire         o_rx_clk,
    output reg          o_rx_rst_n,
    output reg          o_rx_done,
    output reg          o_rx_active,
    output reg          o_cdr_stable,
    output wire [W-1:0] o_rx_data,
    input  wire         i_rx_slide,

    input  wire         gthrxp_in,
    input  wire         gthrxn_in,
    output wire         gthtxp_out,
    output wire         gthtxn_out
);
    assign gthtxp_out = 1'b0;
    assign gthtxn_out = 1'b1;

    assign o_tx_clk = freerun_clk;
    assign o_rx_clk = freerun_clk;

    reg [5:0] up_cnt;
    reg [4:0] bit_off;

    function [W-1:0] ror;
        input [W-1:0] din;
        input [4:0]   sh;
        begin
            if (sh == 0) ror = din;
            else         ror = (din >> sh) | (din << (W - sh));
        end
    endfunction

    always @(posedge freerun_clk or posedge gth_reset_all) begin
        if (gth_reset_all) begin
            up_cnt     <= 0;
            o_tx_rst_n <= 1'b0; o_rx_rst_n <= 1'b0;
            o_tx_done  <= 1'b0; o_rx_done  <= 1'b0;
            o_tx_active<= 1'b0; o_rx_active<= 1'b0;
            o_cdr_stable<=1'b0;
            bit_off    <= INIT_BIT_OFFSET[4:0];
        end else begin
            if (up_cnt < 20) up_cnt <= up_cnt + 1'b1;

            if (up_cnt == 10) begin
                o_tx_rst_n  <= 1'b1;
                o_rx_rst_n  <= 1'b1;
                o_tx_done   <= 1'b1;
                o_rx_done   <= 1'b1;
                o_tx_active <= 1'b1;
                o_rx_active <= 1'b1;
                o_cdr_stable<= 1'b1;
            end

            // 收到 bitslip 请求就旋转回来 1bit
            if (i_rx_slide && (bit_off != 0))
                bit_off <= bit_off - 1'b1;
        end
    end

    assign o_rx_data = ror(i_tx_data, bit_off);

endmodule
