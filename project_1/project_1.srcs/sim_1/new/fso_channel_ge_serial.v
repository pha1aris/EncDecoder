`timescale 1ns/1ps

module fso_channel_ge_serial #(
    parameter integer P = 16,

    parameter integer P_GB = 13,
    parameter integer P_BG = 524,

    parameter integer FLIP_GOOD = 0,
    parameter integer FLIP_BAD  = 7864,

    parameter integer DROP_BAD  = 655,
    parameter integer DROP_MODE = 2,

    parameter [31:0]  SEED = 32'h1ACE_B00C
)(
    input  wire clk,
    input  wire rst_n,

    input  wire txp_in,
    input  wire txn_in,
    output reg  rxp_out,
    output reg  rxn_out,

    output reg  bad_state,
    output reg  dropped
);

    // LFSR state
    reg [31:0] lfsr;

    // internal controls (held until next clk)
    reg flip_active;
    reg drop_active;
    reg drop_val;

    // next-state temp
    reg [31:0] s0, s1, s2;

    // -----------------------------
    // Functions (Verilog-2001)
    // -----------------------------
    function [31:0] lfsr_next;
        input [31:0] s;
        reg f;
        begin
            f = s[31]^s[21]^s[1]^s[0];
            lfsr_next = {s[30:0], f};
        end
    endfunction

    function hit;
        input [P-1:0] r;
        input integer thr;
        reg [P-1:0] thr_p;
        begin
            thr_p = thr[P-1:0];
            hit = (r < thr_p);
        end
    endfunction

    // -----------------------------
    // Sequential: update GE state + decisions
    // -----------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr        <= SEED;
            bad_state   <= 1'b0;
            flip_active <= 1'b0;
            drop_active <= 1'b0;
            drop_val    <= 1'b0;
            dropped     <= 1'b0;

            rxp_out     <= 1'b0;
            rxn_out     <= 1'b1;
        end else begin
            dropped <= 1'b0;

            // prepare some advanced LFSR states for this cycle
            s0 = lfsr_next(lfsr);
            s1 = lfsr_next(s0);
            s2 = lfsr_next(s1);

            // 1) Markov state update uses current lfsr low bits
            if (!bad_state) begin
                if (hit(lfsr[P-1:0], P_GB))
                    bad_state <= 1'b1;
            end else begin
                if (hit(lfsr[P-1:0], P_BG))
                    bad_state <= 1'b0;
            end

            // 2) dropout decision (only in bad)
            drop_active <= bad_state && (DROP_BAD != 0) && hit(s0[P-1:0], DROP_BAD);

            // dropout value
            if (DROP_MODE == 0)
                drop_val <= 1'b0;
            else if (DROP_MODE == 1)
                drop_val <= 1'b1;
            else
                drop_val <= s2[0];

            // 3) flip decision
            if (!bad_state)
                flip_active <= (FLIP_GOOD != 0) && hit(s1[P-1:0], FLIP_GOOD);
            else
                flip_active <= (FLIP_BAD  != 0) && hit(s1[P-1:0], FLIP_BAD);

            // drop has highest priority
            if (drop_active) begin
                dropped     <= 1'b1;
                flip_active <= 1'b0;
            end

            // 4) commit LFSR (consume randomness)
            lfsr <= s2;

            // 5) Drive outputs (differential)
            if (drop_active) begin
                rxp_out <= drop_val;
                rxn_out <= ~drop_val;
            end else if (flip_active) begin
                rxp_out <= ~txp_in;
                rxn_out <= ~(~txp_in); // == txp_in
            end else begin
                rxp_out <= txp_in;
                rxn_out <= ~txp_in;
            end
        end
    end

    // txn_in is ignored here intentionally; we enforce rxn_out = ~rxp_out

endmodule
