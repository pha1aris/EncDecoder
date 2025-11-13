`timescale 1ps / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: gth_sim
// Description:
//   用于 `prbs_gth_test` 模块的仿真测试平台 (Testbench)。
//   - ★ 修复: 添加了 MGT 参考时钟 (mgtrefclk0) 生成逻辑。
//   - ★ 修复: 简化了串行环回连线。
//   - 生成 200MHz 的系统时钟 (sys_clk)。
//   - 施加初始复位。
//
//////////////////////////////////////////////////////////////////////////////////
module gth_sim;

    //----------------------------------------------------------------
    // 时钟和复位
    //----------------------------------------------------------------
    localparam SYS_CLK_PERIOD    = 5000;     // 200MHz
    localparam REFCLK_PERIOD     = 8000;     //125Mhz

    reg  sys_clk;
    reg  rst_n;
    reg  mgtrefclk0_x1y1_p;
    wire mgtrefclk0_x1y1_n;

    //----------------------------------------------------------------
    // DUT (Device Under Test) 端口
    //----------------------------------------------------------------
    wire [1:0] tx_disable;
    wire       gthtxp_out;
    wire       gthtxn_out;

    //----------------------------------------------------------------
    // 1. 时钟生成
    //----------------------------------------------------------------
    initial begin
        sys_clk = 1'b0;
        forever #(SYS_CLK_PERIOD / 2.0) sys_clk = ~sys_clk;
    end

    initial begin
        mgtrefclk0_x1y1_p = 1'b0;
        forever #(REFCLK_PERIOD / 2.0) mgtrefclk0_x1y1_p = ~mgtrefclk0_x1y1_p;
    end
    
    assign mgtrefclk0_x1y1_n = ~mgtrefclk0_x1y1_p;

    //----------------------------------------------------------------
    // 2. 复位和仿真控制
    //----------------------------------------------------------------
// 修正后的仿真控制
     initial begin
         $display("Testbench Started...");
         rst_n = 1'b0; // 施加复位
       
         #(SYS_CLK_PERIOD * 100);
       
         rst_n = 1'b1; // 释放复位
         $display("Reset Released. Running simulation for 200us...");

         // 运行 200us (200,000 ns = 200,000,000 ps)
         #200_000_000; // <--- 已修正
        
         $display("Simulation Finished.");
         $finish;
     end

    //----------------------------------------------------------------
    // 3. DUT: prbs_gth_test 模块例化
    //----------------------------------------------------------------
    gth_prbs8b10b_test gth_prbs8b10b_test ( // ★ 建议为您例化的模块添加一个实例名称
        .sys_clk_p           (sys_clk),
        .sys_clk_n           (~sys_clk), // 正确的差分时钟
        .sys_rst_n           (rst_n),
        .tx_disable          (tx_disable),
        .mgtrefclk0_x1y1_p   (mgtrefclk0_x1y1_p),
        .mgtrefclk0_x1y1_n   (mgtrefclk0_x1y1_n),
    
        .gthrxp_in           (gthtxp_out),
        .gthrxn_in           (gthtxn_out),
        .gthtxp_out          (gthtxp_out),
        .gthtxn_out          (gthtxn_out)
    );
    

// prbs_gth_test prbs_gth_test(

//         .sys_clk_p           (sys_clk),
//         .sys_clk_n           (~sys_clk), // 正确的差分时钟
//         .sys_rst_n           (rst_n),


//         .mgtrefclk0_x1y1_p   (mgtrefclk0_x1y1_p),
//         .mgtrefclk0_x1y1_n   (mgtrefclk0_x1y1_n),

//         .gthrxp_in           (gthtxp_out),
//         .gthrxn_in           (gthtxn_out),
//         .gthtxp_out          (gthtxp_out),
//         .gthtxn_out          (gthtxn_out)
// );



endmodule