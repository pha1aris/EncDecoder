`timescale 1ns / 1ps

module axi4_lite_top #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS    = 32
)(
    input                       ACLK,
    input                       ARESETN,
    input                       read_s,
    input                       write_s,
    input  [ADDRESS-1:0]        address,
    input  [DATA_WIDTH-1:0]     W_data,
    
    // 【新增】从外部引入的具体监控信号
    input  [31:0]               pl_pkg_seq_num,
    input  [31:0]               pl_bit_err_count
);

    // AXI 总线连接信号
    wire M_ARREADY, S_RVALID, M_ARVALID, M_RREADY, S_AWREADY, S_BVALID, M_AWVALID, M_BREADY, M_WVALID, S_WREADY;
    wire [ADDRESS-1:0] M_ARADDR;
    wire [ADDRESS-1:0] M_AWADDR;
    wire [DATA_WIDTH-1:0] M_WDATA;
    wire [DATA_WIDTH-1:0] S_RDATA;
    wire [3:0] M_WSTRB;
    wire [1:0] S_RRESP, S_BRESP;

    // 实例化 Master
    axi4_lite_master u_axi4_lite_master0 (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .START_READ(read_s),
        .START_WRITE(write_s),
        .address(address),
        .W_data(W_data),
        // AXI 连接
        .M_ARREADY(M_ARREADY),
        .M_RDATA(S_RDATA),
        .M_RRESP(S_RRESP),
        .M_RVALID(S_RVALID),
        .M_ARADDR(M_ARADDR),
        .M_ARVALID(M_ARVALID),
        .M_RREADY(M_RREADY),
        .M_AWREADY(S_AWREADY),
        .M_WVALID(M_WVALID),
        .M_WREADY(S_WREADY),
        .M_BRESP(S_BRESP),
        .M_BVALID(S_BVALID),
        .M_AWADDR(M_AWADDR),
        .M_AWVALID(M_AWVALID),
        .M_WDATA(M_WDATA),
        .M_WSTRB(M_WSTRB),
        .M_BREADY(M_BREADY)
    );

    // 实例化 Slave
    axi4_lite_slave #(
        .ADDRESS_WIDTH(ADDRESS),
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_RO_REGS(2) // 我们有两个监控数据
    ) u_axi4_lite_slave0 (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        // AXI 连接
        .S_ARREADY(M_ARREADY),
        .S_RDATA(S_RDATA),
        .S_RRESP(S_RRESP),
        .S_RVALID(S_RVALID),
        .S_ARADDR(M_ARADDR),
        .S_ARVALID(M_ARVALID),
        .S_RREADY(M_RREADY),
        .S_AWREADY(S_AWREADY),
        .S_WVALID(M_WVALID),
        .S_WREADY(S_WREADY),
        .S_BRESP(S_BRESP),
        .S_BVALID(S_BVALID),
        .S_AWADDR(M_AWADDR),
        .S_AWVALID(M_AWVALID),
        .S_WDATA(M_WDATA),
        .S_WSTRB(M_WSTRB),
        .S_BREADY(M_BREADY),
        
        // 【核心修改】将具体的 PL 信号拼接成 Slave 需要的 monitor_data_flat
        // 注意顺序：高位放高索引数据 (reg 17)，低位放低索引数据 (reg 16)
        // 这里 pl_bit_err_count 对应 reg 17 (0x44), pl_pkg_seq_num 对应 reg 16 (0x40)
        .monitor_data_flat( {pl_bit_err_count, pl_pkg_seq_num} )
    );

endmodule