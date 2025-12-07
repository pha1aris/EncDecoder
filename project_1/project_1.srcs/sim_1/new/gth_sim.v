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
    localparam FREERUNCLK_PERIOD = 64000;    //15.625Mhz
    reg  sys_clk;  
    reg  rst_n;
    reg  mgtrefclk0_x1y1_p;
    wire mgtrefclk0_x1y1_n;
    reg freerun_clk;
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

    initial begin
        freerun_clk = 1'b0;
        forever #(FREERUNCLK_PERIOD/2.0) freerun_clk = ~freerun_clk;
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
    
    // gth_raw_top #(
    //     .W (W)
    // ) u_gth_raw (
    //     .freerun_clk        (freerun_clk),
    //     .gth_reset_all      (!rst_n),

    //     .tx_disable         (tx_disable),
    //     .mgtrefclk0_x1y1_p  (mgtrefclk0_x1y1_p),
    //     .mgtrefclk0_x1y1_n  (mgtrefclk0_x1y1_n),
    //     .gthrxp_in          (gthrxp_in),
    //     .gthrxn_in          (gthrxn_in),
    //     .gthtxp_out         (gthtxp_out),
    //     .gthtxn_out         (gthtxn_out),

    //     .i_loopback         (3'b000),

    //     .o_tx_clk           (tx_usr_clk),   // TX line_clk
    //     .o_tx_rst_n         (tx_rst_n),
    //     .o_tx_done          (tx_done),
    //     .o_tx_active        (tx_active),
    //     .i_tx_data          (tx_data_to_gth),

    //     .o_rx_clk           (rx_usr_clk),   // RX line_clk
    //     .o_rx_rst_n         (rx_rst_n),
    //     .o_rx_done          (rx_done),
    //     .o_rx_active        (rx_active),
    //     .o_cdr_stable       (cdr_stable),
    //     .o_rx_data          (rx_data_from_gth),
    //     .i_rx_slide         (rx_slide_req)
    // );


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