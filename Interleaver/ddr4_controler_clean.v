`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// 模块名称: ddr4_controler_clean
//
// 设计目标:
//   本模块是 ddr4_controler 的纯净、可综合版本。
//   - 移除了所有 ILA 实例。
//   - 移除了所有文件I/O操作 ($fopen, $fwrite)。
//   - 保留了核心的 DDR4 控制逻辑。
//   - 通过 dbg_* 端口将关键内部信号引出，供上层测试平台监控。
//
//////////////////////////////////////////////////////////////////////////////////

module ddr4_controler_clean # (
    parameter integer ADDR_WIDTH = 29,
    parameter integer DATA_WIDTH = 32,
    parameter integer MATRIX_COL = 8,
    parameter integer MATRIX_ROW = 8
)(
    input                       sys_clk_p,
    input                       sys_clk_n,
    input                       rst_n,
    // --- DDR4 物理接口 ---
    output                      c0_ddr4_act_n,
    output [16:0]               c0_ddr4_adr,
    output [1:0]                c0_ddr4_ba,
    output [0:0]                c0_ddr4_bg,
    output [0:0]                c0_ddr4_cke,
    output [0:0]                c0_ddr4_odt,
    output [0:0]                c0_ddr4_cs_n,
    output [0:0]                c0_ddr4_ck_t,
    output [0:0]                c0_ddr4_ck_c,
    output                      c0_ddr4_reset_n,
    inout  [3:0]                c0_ddr4_dm_dbi_n,
    inout  [31:0]               c0_ddr4_dq,
    inout  [3:0]                c0_ddr4_dqs_c,
    inout  [3:0]                c0_ddr4_dqs_t,
    // --- 用户接口 ---
    output                      ui_clkout,
    output                      c0_init_calib_complete,
    input  [7:0]                rd_bust_len,
    input  [7:0]                wr_bust_len,
    input                       wr_fifo_wclk,
    input                       rd_fifo_rclk,
    input                       wr_fifo_wen,
    input  [DATA_WIDTH-1:0]     wr_fifo_wdata,
    // input                       rd_fifo_ren,
    output [DATA_WIDTH-1:0]     rd_fifo_rdata, 
    output                      rd_fifo_rvalid, //最终数据有效输出
    // --- 调试端口 (用于上层监控) ---
    output wire                 dbg_ui_clk,
    output wire                 dbg_ui_rst,
    output wire [28:0]          dbg_app_addr,
    output wire [2:0]           dbg_app_cmd,
    output wire                 dbg_app_en,
    output wire                 dbg_wdf_wren,
    output wire [255:0]         dbg_wr_data,
    output wire [255:0]         dbg_rd_data,
    output wire                 dbg_rd_data_valid
);

// 内部信号定义
wire [255:0]    wr_fifo_rdata;
wire [255:0]    rd_fifo_wdata;
wire [8:0]      wr_fifo_rcount;
wire [8:0]      rd_fifo_wcount;
wire            c0_ddr4_ui_clk_sync_rst;
wire            c0_ddr4_app_en;
wire            c0_ddr4_app_wdf_end;
wire            c0_ddr4_app_wdf_wren;
wire            c0_ddr4_app_rd_data_end;
wire            c0_ddr4_app_rd_data_valid;
wire            c0_ddr4_app_rdy;
wire            c0_ddr4_app_wdf_rdy;
wire [28:0]     c0_ddr4_app_addr;
wire [2:0]      c0_ddr4_app_cmd;
wire            c0_ddr4_ui_clk;
wire            rfifo_wren;

// 连接到调试端口
assign dbg_ui_clk        = c0_ddr4_ui_clk;
assign dbg_ui_rst        = c0_ddr4_ui_clk_sync_rst;
assign dbg_app_addr      = c0_ddr4_app_addr;
assign dbg_app_cmd       = c0_ddr4_app_cmd;
assign dbg_app_en        = c0_ddr4_app_en;
assign dbg_wdf_wren      = c0_ddr4_app_wdf_wren;
assign dbg_wr_data       = wr_fifo_rdata;
assign dbg_rd_data       = rd_fifo_wdata;
assign dbg_rd_data_valid = c0_ddr4_app_rd_data_valid;

//re req 生成逻辑
parameter BLOCK_LEN = MATRIX_COL * MATRIX_ROW * 8;
wire rd_req;
reg [31:0] rd_data_cnt;
reg rd_req_reg;
assign rd_req = rd_req_reg;
always @(posedge wr_fifo_wclk or negedge rst_n) begin 
    if(~rst_n) begin
        rd_req_reg <= 0;
        rd_data_cnt <= 'd0;
    end else if(wr_fifo_wen) begin
        rd_data_cnt <= rd_data_cnt + 1'b1;
        if(rd_data_cnt == BLOCK_LEN - 1)begin
            rd_req_reg <= 1'b1;
        end
    end
end

// 读写模块例化
ddr4_rw #(
    .ADDR_WIDTH(29),
    .CMD_WIDTH(3),
    .MATRIX_COL(MATRIX_COL),
    .MATRIX_ROW(MATRIX_ROW)
)u_ddr4_rw(
    .ui_clk(c0_ddr4_ui_clk),
    .ui_clk_sync_rst(c0_ddr4_ui_clk_sync_rst | ~rst_n),
    .init_calib_complete(c0_init_calib_complete),
    .app_rdy(c0_ddr4_app_rdy),
    .app_wdf_rdy(c0_ddr4_app_wdf_rdy),
    .app_rd_data_valid(c0_ddr4_app_rd_data_valid),
    .app_addr(c0_ddr4_app_addr),
    .app_en(c0_ddr4_app_en),
    .app_wdf_wren(c0_ddr4_app_wdf_wren),
    .app_wdf_end(c0_ddr4_app_wdf_end),
    .app_cmd(c0_ddr4_app_cmd),
    
    .rd_bust_len(rd_bust_len),
    .wr_bust_len(wr_bust_len),
    .rfifo_wren(rfifo_wren),
    .ddr4_read_valid(1'b1),
    .wfifo_rcount(wr_fifo_rcount),
    .rfifo_wcount(rd_fifo_wcount)
);

// DDR4 mig IP核例化
ddr4_0 u_ddr4_0 (
  .c0_init_calib_complete(c0_init_calib_complete),
  .c0_sys_clk_p(sys_clk_p),
  .c0_sys_clk_n(sys_clk_n),
  .c0_ddr4_adr(c0_ddr4_adr),
  .c0_ddr4_ba(c0_ddr4_ba),
  .c0_ddr4_cke(c0_ddr4_cke),
  .c0_ddr4_cs_n(c0_ddr4_cs_n),
  .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n),
  .c0_ddr4_dq(c0_ddr4_dq),
  .c0_ddr4_dqs_c(c0_ddr4_dqs_c),
  .c0_ddr4_dqs_t(c0_ddr4_dqs_t),
  .c0_ddr4_odt(c0_ddr4_odt),
  .c0_ddr4_bg(c0_ddr4_bg),
  .c0_ddr4_reset_n(c0_ddr4_reset_n),
  .c0_ddr4_act_n(c0_ddr4_act_n),
  .c0_ddr4_ck_c(c0_ddr4_ck_c),
  .c0_ddr4_ck_t(c0_ddr4_ck_t),
  .c0_ddr4_ui_clk(c0_ddr4_ui_clk),
  .c0_ddr4_ui_clk_sync_rst(c0_ddr4_ui_clk_sync_rst),
  .c0_ddr4_app_en(c0_ddr4_app_en),
  .c0_ddr4_app_hi_pri(1'b0),
  .c0_ddr4_app_wdf_end(c0_ddr4_app_wdf_end),
  .c0_ddr4_app_wdf_wren(c0_ddr4_app_wdf_wren),
  .c0_ddr4_app_rd_data_end(c0_ddr4_app_rd_data_end),
  .c0_ddr4_app_rd_data_valid(c0_ddr4_app_rd_data_valid),
  .c0_ddr4_app_rdy(c0_ddr4_app_rdy),
  .c0_ddr4_app_wdf_rdy(c0_ddr4_app_wdf_rdy),
  .c0_ddr4_app_addr(c0_ddr4_app_addr),
  .c0_ddr4_app_cmd(c0_ddr4_app_cmd),
  .c0_ddr4_app_wdf_data(wr_fifo_rdata),
  .c0_ddr4_app_wdf_mask(32'h0),
  .c0_ddr4_app_rd_data(rd_fifo_wdata),
  .addn_ui_clkout1(ui_clkout),
  .sys_rst(~rst_n)
);

// FIFO控制器例化
ddr4_fifo_ctrl u_ddr4_fifo_ctrl (
    .rst_n(rst_n),
    .wr_fifo_wclk(wr_fifo_wclk),
    .wr_fifo_rclk(c0_ddr4_ui_clk),
    .rd_fifo_wclk(c0_ddr4_ui_clk),
    .rd_fifo_rclk(rd_fifo_rclk),
    .wr_fifo_wdata(wr_fifo_wdata),
    .wr_fifo_rdata(wr_fifo_rdata),
    .rd_fifo_wdata(rd_fifo_wdata),
    .rd_fifo_rdata(rd_fifo_rdata),
    .wr_fifo_rcount(wr_fifo_rcount),
    .rd_fifo_wcount(rd_fifo_wcount),
    .wr_fifo_wen(wr_fifo_wen),
    .wr_fifo_ren(c0_ddr4_app_wdf_wren),
    .rd_fifo_wen(rfifo_wren),
    .rd_fifo_ren(rd_req),
    .data_valid_o(rd_fifo_rvalid)  //交织数据输出
    // .rd_fifo_data_o(rd_fifo_rdata)  //
);


endmodule
