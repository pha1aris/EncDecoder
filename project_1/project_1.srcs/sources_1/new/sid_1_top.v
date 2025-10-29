`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/28 16:13:06
// Design Name: 
// Module Name: sid_1_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sid_1_top(
    input                 clk,
    input                 aresetn,

    // Slave Interface (来自上游)
    input wire [7 : 0]    s_axis_data_tdata,
    input wire            s_axis_data_tvalid,
    input wire            s_axis_data_tlast,
    output wire           s_axis_data_tready, // 反压到上游

    // Master Interface (去往下游)
    output wire [7 : 0]   m_axis_data_tdata,
    output wire [1 : 0]   m_axis_data_tuser,
    output wire           m_axis_data_tvalid,
    output wire           m_axis_data_tlast,
    input  wire           m_axis_data_tready  
);


    // 内部使用高电平有效复位
    wire rst = ~aresetn;

    // --- 乒乓控制逻辑 ---
    
    // write_select: 0 = 写入 sid_0_0, 1 = 写入 sid_0_1
    reg  write_select;
    // read_select:  0 = 读取 sid_0_0, 1 = 读取 sid_0_1
    reg  read_select;

    // 输入侧握手和块结束检测
    wire s_axis_handshake = s_axis_data_tvalid && s_axis_data_tready;
    wire s_axis_block_end = s_axis_handshake && s_axis_data_tlast;

    // 控制逻辑:
    // 1. write_select 在 *输入* 块结束时切换
    // 2. read_select 切换到 *刚刚写完* 的那个缓冲
    always @(posedge clk) begin
        if (rst) begin
            write_select <= 1'b0; // 复位后，首先写入 buffer 0
            read_select  <= 1'b1; // 复位后，尝试读取 buffer 1 (它将是空的, tvalid=0)
        end else if (s_axis_block_end) begin
            write_select <= ~write_select; // 切换写入目标
            read_select  <= write_select;  // 切换读取源 (读取刚写完的那个)
        end
    end
    
    // sid_0_0 接口
    wire [7:0] s_axis_data_tdata_0;
    wire       s_axis_data_tvalid_0;
    wire       s_axis_data_tlast_0;
    wire       s_axis_data_tready_0;
    wire [7:0] m_axis_data_tdata_0;
    wire [1:0] m_axis_data_tuser_0;
    wire       m_axis_data_tvalid_0;
    wire       m_axis_data_tlast_0;
    wire       m_axis_data_tready_0;
    wire       event_tlast_unexpected_0;
    wire       event_tlast_missing_0;
    wire       event_halted_0;
    
    // sid_0_1 接口
    wire [7:0] s_axis_data_tdata_1;
    wire       s_axis_data_tvalid_1;
    wire       s_axis_data_tlast_1;
    wire       s_axis_data_tready_1;
    wire [7:0] m_axis_data_tdata_1;
    wire [1:0] m_axis_data_tuser_1;
    wire       m_axis_data_tvalid_1;
    wire       m_axis_data_tlast_1;
    wire       m_axis_data_tready_1;
    wire       event_tlast_unexpected_1;
    wire       event_tlast_missing_1;
    wire       event_halted_1;

    // --- 1. 输入解复用器 (Demux) ---
    // 将 s_axis_* 分配给 s_axis_*_0 或 s_axis_*_1

    // 数据和 tlast 信号广播给两者
    assign s_axis_data_tdata_0  = s_axis_data_tdata;
    assign s_axis_data_tlast_0  = s_axis_data_tlast;
    assign s_axis_data_tdata_1  = s_axis_data_tdata;
    assign s_axis_data_tlast_1  = s_axis_data_tlast;

    // tvalid 信号根据 write_select 路由
    assign s_axis_data_tvalid_0 = s_axis_data_tvalid && (write_select == 1'b0);
    assign s_axis_data_tvalid_1 = s_axis_data_tvalid && (write_select == 1'b1);

    // TREADY 信号从被选中的 IP 传回
    assign s_axis_data_tready   = (write_select == 1'b0) ? s_axis_data_tready_0 : s_axis_data_tready_1;


    // --- 2. 输出复用器 (Mux) ---
    // 从 m_axis_*_0 或 m_axis_*_1 中选择，驱动 m_axis_*

    // 数据和 valid 信号根据 read_select 路由
    assign m_axis_data_tdata  = (read_select == 1'b0) ? m_axis_data_tdata_0 : m_axis_data_tdata_1;
    assign m_axis_data_tuser  = (read_select == 1'b0) ? m_axis_data_tuser_0 : m_axis_data_tuser_1;
    assign m_axis_data_tvalid = (read_select == 1'b0) ? m_axis_data_tvalid_0 : m_axis_data_tvalid_1;
    assign m_axis_data_tlast  = (read_select == 1'b0) ? m_axis_data_tlast_0 : m_axis_data_tlast_1;
    
    // TREADY 信号被路由到当前正在读取的那个 IP
    assign m_axis_data_tready_0 = m_axis_data_tready && (read_select == 1'b0);
    assign m_axis_data_tready_1 = m_axis_data_tready && (read_select == 1'b1);
    

    // --- 3. IP 实例化 ---

    sid_1 sid_1_0 (
        .aclk                   (clk),
        .aresetn                (aresetn),
        // --- 输入端口 (来自 Demux) ---
        .s_axis_data_tdata      (s_axis_data_tdata_0),
        .s_axis_data_tvalid     (s_axis_data_tvalid_0),
        .s_axis_data_tlast      (s_axis_data_tlast_0),
        .s_axis_data_tready     (s_axis_data_tready_0),

        // --- 输出端口 (去往 Mux) ---
        .m_axis_data_tdata      (m_axis_data_tdata_0),
        .m_axis_data_tuser      (m_axis_data_tuser_0),
        .m_axis_data_tvalid     (m_axis_data_tvalid_0),
        .m_axis_data_tlast      (m_axis_data_tlast_0),
        .m_axis_data_tready     (m_axis_data_tready_0), // <-- 关键: 连接到 Mux, 不再是 1'b1
        // --- 事件端口 ---
        .event_tlast_unexpected (event_tlast_unexpected_0),
        .event_tlast_missing    (event_tlast_missing_0),
        .event_halted           (event_halted_0)
    );

    sid_1 sid_1_1 (
        .aclk                   (clk),
        .aresetn                (aresetn),
        // --- 输入端口 (来自 Demux) ---
        .s_axis_data_tdata      (s_axis_data_tdata_1),
        .s_axis_data_tvalid     (s_axis_data_tvalid_1),
        .s_axis_data_tlast      (s_axis_data_tlast_1),
        .s_axis_data_tready     (s_axis_data_tready_1),

        // --- 输出端口 (去往 Mux) ---
        .m_axis_data_tdata      (m_axis_data_tdata_1),
        .m_axis_data_tuser      (m_axis_data_tuser_1),
        .m_axis_data_tvalid     (m_axis_data_tvalid_1),
        .m_axis_data_tlast      (m_axis_data_tlast_1),
        .m_axis_data_tready     (m_axis_data_tready_1), // <-- 关键: 连接到 Mux, 不再是 1'b1
        // --- 事件端口 ---
        .event_tlast_unexpected (event_tlast_unexpected_1),
        .event_tlast_missing    (event_tlast_missing_1),
        .event_halted           (event_halted_1)
    );


endmodule
