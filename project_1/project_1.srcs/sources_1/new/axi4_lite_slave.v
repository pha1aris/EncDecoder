`timescale 1ns / 1ps

module axi4_lite_slave #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH    = 32,
    // 【扩展性设计 1】: 定义有多少个只读监控数据
    parameter NUM_RO_REGS   = 2   // 目前有: 包序号, 误码数
)(
    // 全局信号
    input wire                      ACLK,
    input wire                      ARESETN,

    // --- AXI4-Lite 接口 (标准 Verilog 写法) ---
    // 写地址通道
    input wire [ADDRESS_WIDTH-1:0]  S_AWADDR,
    input wire                      S_AWVALID,
    output reg                      S_AWREADY,
    
    // 写数据通道
    input wire [DATA_WIDTH-1:0]     S_WDATA,
    input wire [3:0]                S_WSTRB,
    input wire                      S_WVALID,
    output reg                      S_WREADY,
    
    // 写响应通道
    output reg [1:0]                S_BRESP,
    output reg                      S_BVALID,
    input wire                      S_BREADY,
    
    // 读地址通道
    input wire [ADDRESS_WIDTH-1:0]  S_ARADDR,
    input wire                      S_ARVALID,
    output reg                      S_ARREADY,
    
    // 读数据通道
    output reg [DATA_WIDTH-1:0]     S_RDATA,
    output reg [1:0]                S_RRESP,
    output reg                      S_RVALID,
    input wire                      S_RREADY,

    // --- 【扩展性设计 2】: 扁平化的监控数据输入 ---
    // 在实例化时，将多个 32 位信号拼接成 {信号2, 信号1} 输入
    input wire [(NUM_RO_REGS*32)-1:0] monitor_data_flat
);

    // --- 参数定义 (替代 enum) ---
    localparam [2:0] IDLE           = 3'b000;
    localparam [2:0] WRITE_CHANNEL  = 3'b001;
    localparam [2:0] WRESP_CHANNEL  = 3'b010;
    localparam [2:0] RADDR_CHANNEL  = 3'b011;
    localparam [2:0] RDATA_CHANNEL  = 3'b100;

    // --- 内部信号 ---
    reg [2:0] state, next_state;
    reg [ADDRESS_WIDTH-1:0] r_addr_latch; // 锁存读地址
    
    // 通用寄存器 (用于 PS 控制 PL，可读写)
    // 假设保留 16 个通用控制寄存器
    localparam NUM_RW_REGS = 16;
    reg [DATA_WIDTH-1:0] slv_regs [0:NUM_RW_REGS-1];
    
    // 写辅助信号
    wire slv_reg_wren;
    integer i;

    // --- 1. 状态机逻辑 ---
    always @(posedge ACLK) begin
        if (!ARESETN) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        next_state = state; // 默认保持
        case (state)
            IDLE: begin
                if (S_AWVALID)
                    next_state = WRITE_CHANNEL;
                else if (S_ARVALID)
                    next_state = RADDR_CHANNEL;
                else
                    next_state = IDLE;
            end
            WRITE_CHANNEL: begin
                if (S_AWVALID && S_AWREADY && S_WVALID && S_WREADY)
                    next_state = WRESP_CHANNEL;
            end
            WRESP_CHANNEL: begin
                if (S_BVALID && S_BREADY)
                    next_state = IDLE;
            end
            RADDR_CHANNEL: begin
                if (S_ARVALID && S_ARREADY)
                    next_state = RDATA_CHANNEL;
            end
            RDATA_CHANNEL: begin
                if (S_RVALID && S_RREADY)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // --- 2. AXI 握手输出逻辑 ---
    // 为了简化时序，这里使用组合逻辑生成 READY，但在高速设计中建议用寄存器输出
    always @(*) begin
        S_AWREADY = (state == WRITE_CHANNEL);
        S_WREADY  = (state == WRITE_CHANNEL);
        S_ARREADY = (state == RADDR_CHANNEL);
        S_BVALID  = (state == WRESP_CHANNEL);
        S_RVALID  = (state == RDATA_CHANNEL);
        S_BRESP   = 2'b00; // OKAY
        S_RRESP   = 2'b00; // OKAY
    end

    // --- 3. 写操作逻辑 (PS -> PL) ---
    assign slv_reg_wren = S_AWVALID && S_WREADY && S_WVALID && S_AWREADY;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            for (i = 0; i < NUM_RW_REGS; i = i + 1) begin
                slv_regs[i] <= 32'h0;
            end
        end
        else if (slv_reg_wren) begin
            // 简单的地址解码：忽略低2位，取 [6:2]
            // 只允许写入前 NUM_RW_REGS 个寄存器
            if (S_AWADDR[6:2] < NUM_RW_REGS) begin
                slv_regs[S_AWADDR[6:2]] <= S_WDATA;
            end
        end
    end

    // --- 4. 读地址锁存 ---
    always @(posedge ACLK) begin
        if (!ARESETN)
            r_addr_latch <= 0;
        else if (S_ARVALID && S_ARREADY)
            r_addr_latch <= S_ARADDR;
    end

    // --- 5. 【核心】读数据逻辑 (PL -> PS) ---
    // 扩展性设计的关键：将地址空间划分为“通用区”和“监控区”
    
    // 计算寄存器索引 (word index)
    wire [4:0] reg_index = r_addr_latch[6:2]; 
    
    // 定义只读监控数据的起始索引 (例如从寄存器 16 开始)
    localparam RO_START_INDEX = 16; 

    always @(*) begin
        S_RDATA = 32'h0; // 默认值
        
        if (state == RDATA_CHANNEL) begin
            if (reg_index < NUM_RW_REGS) begin
                // 0 ~ 15: 读取通用可读写寄存器
                S_RDATA = slv_regs[reg_index];
            end
            else if (reg_index >= RO_START_INDEX && 
                     reg_index < RO_START_INDEX + NUM_RO_REGS) begin
                // 16 ~ 16+N: 读取只读监控数据
                // 【技巧】使用位切片从扁平向量中提取对应的 32 位数据
                // 比如 reg_index=16 (第一个监控数据), 提取 monitor_data_flat[31:0]
                // 比如 reg_index=17 (第二个监控数据), 提取 monitor_data_flat[63:32]
                S_RDATA = monitor_data_flat[(reg_index - RO_START_INDEX) * 32 +: 32];
            end
        end
    end

endmodule