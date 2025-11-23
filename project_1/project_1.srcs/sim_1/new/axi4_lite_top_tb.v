`timescale 1ns / 1ps

module axi4_lite_top_tb();

    // 1. 信号定义 (使用 reg)
    reg           ACLK_tb;
    reg           ARESETN_tb;
    reg           read_s_tb;
    reg           write_s_tb;
    reg [31:0]    address_tb;
    reg [31:0]    W_data_tb;

    // 【新增】用于模拟 PL 端的业务数据
    reg [31:0]    tb_seq_num;
    reg [31:0]    tb_err_cnt;

    // 2. 实例化顶层模块 (连接新增端口)
    // 注意：请确保您的 axi4_lite_top 模块端口名与这里一致
    axi4_lite_top u_axi4_lite_top0(
        .ACLK(ACLK_tb),
        .ARESETN(ARESETN_tb),
        .read_s(read_s_tb),
        .write_s(write_s_tb),
        .address(address_tb),
        .W_data(W_data_tb),
        // 连接新增的监控端口
        .pl_pkg_seq_num(tb_seq_num),
        .pl_bit_err_count(tb_err_cnt)
    );

    // 3. 时钟生成 (周期 10ns)
    initial begin
        ACLK_tb = 0;
        forever #5 ACLK_tb = ~ACLK_tb;
    end

    // 4. 测试流程
    initial begin
        // --- 初始化 ---
        ARESETN_tb = 0;
        read_s_tb  = 0;  
        write_s_tb = 0;
        address_tb = 0;
        W_data_tb  = 0;
        
        // 设置模拟的 PL 状态数据 (用于验证读取结果)
        tb_seq_num = 32'hAAAA_5555;  // 期望读出值 1
        tb_err_cnt = 32'h1234_5678;  // 期望读出值 2
                           
        // --- 复位释放 ---
        #20;
        ARESETN_tb = 1;
        #20;

        // ============================================================
        // 测试阶段 1: 原作者的测试 (普通寄存器读写)
        // 向地址 0x14 (5<<2) 写入数据 4
        // 注意：原代码 address=5, 在 slave 中会被解析为 reg_index=1 (因为取[6:2])
        // 为了避免混淆，我们这里严格按照字节地址来测试
        // ============================================================
        
        // -> 写操作: 地址 0x00 (通用寄存器0), 数据 0xDEADBEEF
        write_s_tb = 1;
        address_tb = 32'h0000_0000; 
        W_data_tb  = 32'hDEAD_BEEF;
        #10; // 给一个脉冲
        write_s_tb = 0;

        // 等待写操作完成 (根据波形大概需要 20-30ns)
        #50;

        // -> 读操作: 地址 0x00 (应该读回 0xDEADBEEF)
        read_s_tb  = 1;
        address_tb = 32'h0000_0000;
        #10;
        read_s_tb  = 0;
        
        #50; // 等待读完成

        // ============================================================
        // 测试阶段 2: 【新增】读取 PL 监控数据
        // ============================================================

        // -> 读操作: 地址 0x04 (对应 reg_index=1 -> 包序号)
        read_s_tb  = 1;
        address_tb = 32'h0000_0004; 
        #10;
        read_s_tb  = 0;

        #50; // 此时观察 S_RDATA 应该等于 tb_seq_num (0xAAAA5555)

        // -> 读操作: 地址 0x08 (对应 reg_index=2 -> 误码数)
        read_s_tb  = 1;
        address_tb = 32'h0000_0008;
        #10;
        read_s_tb  = 0;

        #50; // 此时观察 S_RDATA 应该等于 tb_err_cnt (0x12345678)

        // --- 结束仿真 ---
        $display("Simulation Finished. Check Waveform for results.");
        $finish;            
    end

endmodule