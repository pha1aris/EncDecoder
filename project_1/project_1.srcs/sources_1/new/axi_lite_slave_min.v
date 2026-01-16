`timescale 1 ns / 1 ps

module axi4_lite_slave_min #
(
    parameter integer ADDRESS_WIDTH = 32,
    parameter integer DATA_WIDTH    = 32
)
(
    // --- Global ---
    input  wire                      ACLK,
    input  wire                      ARESETN,

    // --- AXI4-Lite Slave ---
    input  wire [ADDRESS_WIDTH-1:0]   S_AWADDR,
    input  wire [2:0]                S_AWPROT,
    input  wire                      S_AWVALID,
    output wire                      S_AWREADY,

    input  wire [DATA_WIDTH-1:0]     S_WDATA,
    input  wire [(DATA_WIDTH/8)-1:0] S_WSTRB,
    input  wire                      S_WVALID,
    output wire                      S_WREADY,

    output wire [1:0]                S_BRESP,
    output wire                      S_BVALID,
    input  wire                      S_BREADY,

    input  wire [ADDRESS_WIDTH-1:0]  S_ARADDR,
    input  wire [2:0]                S_ARPROT,
    input  wire                      S_ARVALID,
    output wire                      S_ARREADY,

    output wire [DATA_WIDTH-1:0]     S_RDATA,
    output wire [1:0]                S_RRESP,
    output wire                      S_RVALID,
    input  wire                      S_RREADY,

    // --- 第一阶段：监控输入（实时） ---
    input  wire [31:0]               i_status0,        // RO16
    input  wire [31:0]               i_ber_q32,         // RO17
    input  wire [31:0]               i_err_bits_lo,     // RO18
    input  wire [31:0]               i_err_bits_hi,     // RO19
    input  wire [31:0]               i_tot_bits_lo,     // RO20
    input  wire [31:0]               i_tot_bits_hi,     // RO21
    input  wire [31:0]               i_align_err_cnt,   // RO22
    input  wire [31:0]               i_last_align_off,  // RO23

    // --- 第一阶段：控制输出（从 RW regs 拆出来） ---
    output wire                      o_clear_stats_pulse, // 写1自清
    output wire                      o_snapshot_pulse,    // 写1自清
    output wire                      o_hold_ro,           // 直接保持
    output wire                      o_soft_reset_pulse,  // 写1自清
    output wire [7:0]                o_dbg_sel,           // CTRL[15:8]

    output wire [31:0]               o_ctrl_raw,          // slv_regs[0]（可选导出）
    output wire [31:0]               o_cfg0_raw,          // slv_regs[1]
    output wire [31:0]               o_cfg1_raw,          // slv_regs[2]
    output wire [31:0]               o_cfg2_raw,          // slv_regs[3]
    output wire [31:0]               o_rs_cfg_raw,        // slv_regs[4]
    output wire [31:0]               o_ilv_cfg_raw        // slv_regs[5]
);

    // ----------------------------
    // Parameters / localparams
    // ----------------------------
    localparam integer NUM_RW_REGS = 16;
    localparam integer RO_START_INDEX = 16; // 0x40
    localparam integer NUM_RO_STAGE1 = 8;  // RO16..RO23

    // For 32-bit data width: ADDR_LSB = 2 (byte addr -> word index)
    localparam integer ADDR_LSB = (DATA_WIDTH/32) + 1; // =2 when DATA_WIDTH=32
    localparam integer OPT_MEM_ADDR_BITS = 6; // decode enough

    // ----------------------------
    // AXI internal regs
    // ----------------------------
    reg  axi_awready;
    reg  axi_wready;
    reg  [1:0] axi_bresp;
    reg  axi_bvalid;

    reg  axi_arready;
    reg  [DATA_WIDTH-1:0] axi_rdata;
    reg  [1:0] axi_rresp;
    reg  axi_rvalid;

    reg  [ADDRESS_WIDTH-1:0] awaddr_reg;
    reg  [ADDRESS_WIDTH-1:0] araddr_reg;
    reg  awaddr_valid;
    reg  wdata_valid;

    // ----------------------------
    // RW register file
    // ----------------------------
    reg [DATA_WIDTH-1:0] slv_regs [0:NUM_RW_REGS-1];
    integer i;
    integer byte_index;

    // Export raw regs (useful for your top integration)
    assign o_ctrl_raw    = slv_regs[0];
    assign o_cfg0_raw    = slv_regs[1];
    assign o_cfg1_raw    = slv_regs[2];
    assign o_cfg2_raw    = slv_regs[3];
    assign o_rs_cfg_raw  = slv_regs[4];
    assign o_ilv_cfg_raw = slv_regs[5];

    // ----------------------------
    // CTRL bitfield (with pulse self-clear)
    // CTRL @ 0x00
    // bit0 clear_stats_pulse  (write1 self-clear)
    // bit1 snapshot_pulse     (write1 self-clear)
    // bit2 hold_ro            (level)
    // bit3 soft_reset_pulse   (write1 self-clear)
    // [15:8] dbg_sel          (level)
    // ----------------------------
    assign o_clear_stats_pulse = slv_regs[0][0];
    assign o_snapshot_pulse    = slv_regs[0][1];
    assign o_hold_ro           = slv_regs[0][2];
    assign o_soft_reset_pulse  = slv_regs[0][3];
    assign o_dbg_sel           = slv_regs[0][15:8];

    // ----------------------------
    // Snapshot bank (RO)
    // ----------------------------
    reg [31:0] snap_status0;
    reg [31:0] snap_ber_q32;
    reg [31:0] snap_err_bits_lo;
    reg [31:0] snap_err_bits_hi;
    reg [31:0] snap_tot_bits_lo;
    reg [31:0] snap_tot_bits_hi;
    reg [31:0] snap_align_err_cnt;
    reg [31:0] snap_last_align_off;

    // On snapshot_pulse, capture all RO stage1 signals
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            snap_status0        <= 32'h0;
            snap_ber_q32         <= 32'h0;
            snap_err_bits_lo     <= 32'h0;
            snap_err_bits_hi     <= 32'h0;
            snap_tot_bits_lo     <= 32'h0;
            snap_tot_bits_hi     <= 32'h0;
            snap_align_err_cnt   <= 32'h0;
            snap_last_align_off  <= 32'h0;
        end else begin
            if (o_snapshot_pulse) begin
                snap_status0        <= i_status0;
                snap_ber_q32         <= i_ber_q32;
                snap_err_bits_lo     <= i_err_bits_lo;
                snap_err_bits_hi     <= i_err_bits_hi;
                snap_tot_bits_lo     <= i_tot_bits_lo;
                snap_tot_bits_hi     <= i_tot_bits_hi;
                snap_align_err_cnt   <= i_align_err_cnt;
                snap_last_align_off  <= i_last_align_off;
            end
        end
    end

    // ----------------------------
    // AXI outputs
    // ----------------------------
    assign S_AWREADY = axi_awready;
    assign S_WREADY  = axi_wready;
    assign S_BRESP   = axi_bresp;
    assign S_BVALID  = axi_bvalid;

    assign S_ARREADY = axi_arready;
    assign S_RDATA   = axi_rdata;
    assign S_RRESP   = axi_rresp;
    assign S_RVALID  = axi_rvalid;

    // ----------------------------
    // Write Address Channel (AW)
    // ----------------------------
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            axi_awready  <= 1'b0;
            awaddr_reg   <= {ADDRESS_WIDTH{1'b0}};
            awaddr_valid <= 1'b0;
        end else begin
            // ready when we can accept a new address
            axi_awready <= (!awaddr_valid) && (!axi_bvalid);

            if (axi_awready && S_AWVALID) begin
                awaddr_reg   <= S_AWADDR;
                awaddr_valid <= 1'b1;
            end

            // clear after write commit
            if (write_commit) begin
                awaddr_valid <= 1'b0;
            end
        end
    end

    // ----------------------------
    // Write Data Channel (W)
    // ----------------------------
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            axi_wready  <= 1'b0;
            wdata_valid <= 1'b0;
        end else begin
            axi_wready <= (!wdata_valid) && (!axi_bvalid);

            if (axi_wready && S_WVALID) begin
                wdata_valid <= 1'b1;
            end

            // clear after write commit
            if (write_commit) begin
                wdata_valid <= 1'b0;
            end
        end
    end

    // Write commit when both captured
    wire write_commit;
    assign write_commit = awaddr_valid && wdata_valid && (!axi_bvalid);

    // ----------------------------
    // Write Response (B)
    // ----------------------------
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else begin
            if (write_commit) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00; // OKAY
            end else if (axi_bvalid && S_BREADY) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    // ----------------------------
    // Write to slv_regs (WSTRB supported)
    // ----------------------------
    wire [OPT_MEM_ADDR_BITS:0] wr_index;
    assign wr_index = awaddr_reg[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            for (i = 0; i < NUM_RW_REGS; i = i + 1)
                slv_regs[i] <= {DATA_WIDTH{1'b0}};
        end else begin
            if (write_commit) begin
                if (wr_index < NUM_RW_REGS) begin
                    for (byte_index = 0; byte_index < (DATA_WIDTH/8); byte_index = byte_index + 1) begin
                        if (S_WSTRB[byte_index]) begin
                            slv_regs[wr_index][(byte_index*8) +: 8] <= S_WDATA[(byte_index*8) +: 8];
                        end
                    end
                end
            end

            // ---- Pulse self-clear (write-1-to-pulse) ----
            // Ensure pulse bits go back to 0 automatically after 1 cycle.
            // This makes SW simple and avoids "stuck high".
            slv_regs[0][0] <= 1'b0; // clear_stats_pulse
            slv_regs[0][1] <= 1'b0; // snapshot_pulse
            slv_regs[0][3] <= 1'b0; // soft_reset_pulse
        end
    end

    // ----------------------------
    // Read Address Channel (AR)
    // ----------------------------
    always @(posedge ACLK) begin
        if (!ARESETN) begin
            axi_arready <= 1'b0;
            araddr_reg  <= {ADDRESS_WIDTH{1'b0}};
        end else begin
            // accept AR when we are not holding a valid R
            axi_arready <= (!axi_rvalid);

            if (axi_arready && S_ARVALID) begin
                araddr_reg <= S_ARADDR;
            end
        end
    end

    // ----------------------------
    // Read Data Channel (R)
    // ----------------------------
    wire [OPT_MEM_ADDR_BITS:0] rd_index;
    assign rd_index = araddr_reg[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

    reg [31:0] reg_data_out;

    always @(*) begin
        reg_data_out = 32'h0;

        // 1) RW regs 0..15
        if (rd_index < NUM_RW_REGS) begin
            reg_data_out = slv_regs[rd_index];
        end
        // 2) RO stage1 16..23
        else if ((rd_index >= RO_START_INDEX) && (rd_index < (RO_START_INDEX + NUM_RO_STAGE1))) begin
            // choose live or snapshot by hold_ro
            case (rd_index - RO_START_INDEX)
                0: reg_data_out = (o_hold_ro) ? snap_status0       : i_status0;        // RO16
                1: reg_data_out = (o_hold_ro) ? snap_ber_q32        : i_ber_q32;         // RO17
                2: reg_data_out = (o_hold_ro) ? snap_err_bits_lo    : i_err_bits_lo;     // RO18
                3: reg_data_out = (o_hold_ro) ? snap_err_bits_hi    : i_err_bits_hi;     // RO19
                4: reg_data_out = (o_hold_ro) ? snap_tot_bits_lo    : i_tot_bits_lo;     // RO20
                5: reg_data_out = (o_hold_ro) ? snap_tot_bits_hi    : i_tot_bits_hi;     // RO21
                6: reg_data_out = (o_hold_ro) ? snap_align_err_cnt  : i_align_err_cnt;   // RO22
                7: reg_data_out = (o_hold_ro) ? snap_last_align_off : i_last_align_off;  // RO23
                default: reg_data_out = 32'h0;
            endcase
        end
        else begin
            reg_data_out = 32'h0;
        end
    end

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
            axi_rdata  <= {DATA_WIDTH{1'b0}};
        end else begin
            if (axi_arready && S_ARVALID && !axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00; // OKAY
                axi_rdata  <= reg_data_out;
            end else if (axi_rvalid && S_RREADY) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

endmodule
