`timescale 1 ns / 1 ps

module axi4_lite_slave #
(
    // 适配 fso_sys_top 的参数命名
    parameter integer ADDRESS_WIDTH = 32,
    parameter integer DATA_WIDTH    = 32,
    parameter integer NUM_RO_REGS   = 2     // 监控寄存器数量
)
(
    // --- 全局信号 ---
    input wire                      ACLK,
    input wire                      ARESETN,

    // --- AXI4-Lite 接口 (对应 fso_sys_top 的连接) ---
    input wire [ADDRESS_WIDTH-1 : 0] S_AWADDR,
    input wire [2 : 0]               S_AWPROT,
    input wire                       S_AWVALID,
    output wire                      S_AWREADY,
    
    input wire [DATA_WIDTH-1 : 0]    S_WDATA,
    input wire [(DATA_WIDTH/8)-1 : 0] S_WSTRB,
    input wire                       S_WVALID,
    output wire                      S_WREADY,
    
    output wire [1 : 0] S_BRESP,
    output wire  S_BVALID,
    input wire  S_BREADY,
    
    input wire [ADDRESS_WIDTH-1 : 0] S_ARADDR,
    input wire [2 : 0] S_ARPROT,
    input wire  S_ARVALID,
    output wire  S_ARREADY,
    
    output wire [DATA_WIDTH-1 : 0] S_RDATA,
    output wire [1 : 0] S_RRESP,
    output wire  S_RVALID,
    input wire  S_RREADY,

    // --- 【新增】自定义接口 ---
    input wire [(NUM_RO_REGS*32)-1:0] monitor_data_flat, // 监控数据输入
    output wire [31:0]                o_slv_reg0         // 导出控制寄存器
);

    // AXI4LITE 内部信号
    reg [ADDRESS_WIDTH-1 : 0] axi_awaddr;
    reg  axi_awready;
    reg  axi_wready;
    reg [1 : 0] axi_bresp;
    reg  axi_bvalid;
    reg [ADDRESS_WIDTH-1 : 0] axi_araddr;
    reg  axi_arready;
    reg [DATA_WIDTH-1 : 0] axi_rdata;
    reg [1 : 0] axi_rresp;
    reg  axi_rvalid;

    // 地址解码参数
    localparam integer ADDR_LSB = (DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 6; // 覆盖 0x00 ~ 0xFF 范围 (足够容纳几十个寄存器)
    
    // --- 【修改点 1】: 定义通用读写寄存器堆 ---
    localparam integer NUM_RW_REGS = 16;
    reg [DATA_WIDTH-1:0] slv_regs [0:NUM_RW_REGS-1];
    
    // --- 【修改点 2】: 导出控制信号 ---
    assign o_slv_reg0 = slv_regs[0];

    wire slv_reg_rden;
    wire slv_reg_wren;
    reg [DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;
    integer i;
    reg  aw_en;

    // I/O 连接
    assign S_AWREADY = axi_awready;
    assign S_WREADY  = axi_wready;
    assign S_BRESP   = axi_bresp;
    assign S_BVALID  = axi_bvalid;
    assign S_ARREADY = axi_arready;
    assign S_RDATA   = axi_rdata;
    assign S_RRESP   = axi_rresp;
    assign S_RVALID  = axi_rvalid;

    // -------------------------------------------------------------------------
    //  AXI 握手逻辑 (保持 Xilinx 模板原样)
    // -------------------------------------------------------------------------

    // 写地址准备好 (AWREADY)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end 
        else begin    
            if (~axi_awready && S_AWVALID && S_WVALID && aw_en) begin
                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end
            else if (S_BREADY && axi_bvalid) begin
                aw_en <= 1'b1;
                axi_awready <= 1'b0;
            end
            else begin
                axi_awready <= 1'b0;
            end
        end 
    end  

    // 写地址锁存 (AWADDR)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_awaddr <= 0;
        end 
        else begin    
            if (~axi_awready && S_AWVALID && S_WVALID && aw_en) begin
                axi_awaddr <= S_AWADDR;
            end
        end 
    end       

    // 写数据准备好 (WREADY)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_wready <= 1'b0;
        end 
        else begin    
            if (~axi_wready && S_WVALID && S_AWVALID && aw_en ) begin
                axi_wready <= 1'b1;
            end
            else begin
                axi_wready <= 1'b0;
            end
        end 
    end       

    // 写响应 (BVALID/BRESP)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_bvalid  <= 0;
            axi_bresp   <= 2'b0;
        end 
        else begin    
            if (axi_awready && S_AWVALID && ~axi_bvalid && axi_wready && S_WVALID) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0; 
            end
            else if (S_BREADY && axi_bvalid) begin
                axi_bvalid <= 1'b0; 
            end
        end
    end   

    // 读地址准备好 (ARREADY)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 32'b0;
        end 
        else begin    
            if (~axi_arready && S_ARVALID) begin
                axi_arready <= 1'b1;
                axi_araddr  <= S_ARADDR;
            end
            else begin
                axi_arready <= 1'b0;
            end
        end 
    end       

    // 读数据有效 (RVALID)
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end 
        else begin    
            if (axi_arready && S_ARVALID && ~axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0; 
            end   
            else if (axi_rvalid && S_RREADY) begin
                axi_rvalid <= 1'b0;
            end                
        end
    end    

    // -------------------------------------------------------------------------
    //  【修改点 3】: 写寄存器逻辑 (Write Logic)
    // -------------------------------------------------------------------------
    assign slv_reg_wren = axi_wready && S_WVALID && axi_awready && S_AWVALID;

    // 计算当前写操作的寄存器索引
    wire [OPT_MEM_ADDR_BITS:0] wr_index;
    assign wr_index = axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            for (i = 0; i < NUM_RW_REGS; i = i + 1) begin
                slv_regs[i] <= 0;
            end
        end
        else begin
            if (slv_reg_wren) begin
                // 只允许写入 0 ~ NUM_RW_REGS-1 范围内的寄存器
                if (wr_index < NUM_RW_REGS) begin
                    for ( byte_index = 0; byte_index <= (DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                        if ( S_WSTRB[byte_index] == 1 ) begin
                            slv_regs[wr_index][(byte_index*8) +: 8] <= S_WDATA[(byte_index*8) +: 8];
                        end  
                end
            end
        end
    end    

    // -------------------------------------------------------------------------
    //  【修改点 4】: 读数据逻辑 (Read Logic - 包含监控数据)
    // -------------------------------------------------------------------------
    assign slv_reg_rden = axi_arready & S_ARVALID & ~axi_rvalid;

    // 计算当前读操作的寄存器索引
    wire [OPT_MEM_ADDR_BITS:0] rd_index;
    assign rd_index = axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
    
    // 监控数据起始地址 (Index 16 = 0x40)
    localparam RO_START_INDEX = 16;

    always @(*)
    begin
        reg_data_out = 32'h0; // 默认 0

        // 1. 读取可读写寄存器 (0 ~ 15)
        if (rd_index < NUM_RW_REGS) begin
            reg_data_out = slv_regs[rd_index];
        end
        // 2. 读取只读监控数据 (16 ~ 16+NUM_RO_REGS)
        else if (rd_index >= RO_START_INDEX && 
                 rd_index < RO_START_INDEX + NUM_RO_REGS) begin
            // 动态位切片：从扁平向量中切出对应的 32 位
            reg_data_out = monitor_data_flat[(rd_index - RO_START_INDEX) * 32 +: 32];
        end
    end

    // 输出到总线
    always @( posedge ACLK )
    begin
        if ( ARESETN == 1'b0 ) begin
            axi_rdata  <= 0;
        end 
        else begin    
            if (slv_reg_rden) begin
                axi_rdata <= reg_data_out;     
            end   
        end
    end    

endmodule