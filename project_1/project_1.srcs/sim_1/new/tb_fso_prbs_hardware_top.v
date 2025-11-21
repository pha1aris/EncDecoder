`timescale 1ps/1ps

module tb_fso_prbs_hardware_top;

  // ===========================================================================
  // 1. 信号声明
  // ===========================================================================
  
  // 输入信号 (Reg 类型)
  reg sys_clk_p;
  reg sys_clk_n;
  reg sys_rst_n;
  reg mgtrefclk0_x1y1_p;
  reg mgtrefclk0_x1y1_n;
  
  // 模拟串行回环连接
  wire gthrxp_in;
  wire gthrxn_in;

  // 输出信号 (Wire 类型)
  wire [1:0] tx_disable;
  wire       pl_led1;
  wire       gthtxp_out;
  wire       gthtxn_out;

  // ===========================================================================
  // 2. 参数定义
  // ===========================================================================
  
  // 200MHz 系统时钟周期 = 5ns (5000ps) -> 半周期 = 2500ps
  localparam SYS_CLK_HALF_PERIOD = 2500; 
  
  // 125MHz Ref时钟周期 = 8ns (8000ps) -> 半周期 = 4000ps
  localparam REF_CLK_HALF_PERIOD = 4000;

  // ===========================================================================
  // 3. 时钟生成逻辑
  // ===========================================================================

  // 生成 200MHz 系统差分时钟
  initial begin
    sys_clk_p = 0;
    sys_clk_n = 1;
    forever begin
      #(SYS_CLK_HALF_PERIOD);
      sys_clk_p = ~sys_clk_p;
      sys_clk_n = ~sys_clk_n;
    end
  end

  // 生成 125MHz GTH 参考差分时钟
  initial begin
    mgtrefclk0_x1y1_p = 0;
    mgtrefclk0_x1y1_n = 1;
    forever begin
      #(REF_CLK_HALF_PERIOD);
      mgtrefclk0_x1y1_p = ~mgtrefclk0_x1y1_p;
      mgtrefclk0_x1y1_n = ~mgtrefclk0_x1y1_n;
    end
  end

  // ===========================================================================
  // 4. 模拟外部物理连接 (Serial Loopback)
  // ===========================================================================
  
  // 将发送端 TX 直接连回接收端 RX
  // 加入 100ps 的传输延迟模拟 PCB 走线或光纤延迟
  assign #100 gthrxp_in = gthtxp_out;
  assign #100 gthrxn_in = gthtxn_out;

  // ===========================================================================
  // 5. DUT (Device Under Test) 实例化
  // ===========================================================================
  
  fso_prbs_hardware_top u_dut (
    // 系统时钟与复位
    .sys_clk_p         (sys_clk_p),
    .sys_clk_n         (sys_clk_n),
    .sys_rst_n         (sys_rst_n),

    // 光模块控制
    .tx_disable        (tx_disable),

    // GTH 参考时钟
    .mgtrefclk0_x1y1_p (mgtrefclk0_x1y1_p),
    .mgtrefclk0_x1y1_n (mgtrefclk0_x1y1_n),

    // 状态指示
    .pl_led1           (pl_led1),

    // 串行差分接口 (已连接回环)
    .gthrxp_in         (gthrxp_in),
    .gthrxn_in         (gthrxn_in),
    .gthtxp_out        (gthtxp_out),
    .gthtxn_out        (gthtxn_out)
  );

  // ===========================================================================
  // 6. 测试流程控制
  // ===========================================================================
  
  initial begin
    // 1. 初始化
    sys_rst_n = 0; // 按下复位
    $display("[%t] Simulation Start. Applying Reset...", $time);

    // 2. 保持复位一段时间 (例如 200ns)
    repeat (40) @(posedge sys_clk_p); 
    
    // 3. 释放复位
    sys_rst_n = 1;
    $display("[%t] Reset Released. Waiting for GTH Initialization...", $time);

    // 4. 等待 GTH 初始化和锁定 (这通常需要较长时间)
    // 设置超时时间，防止仿真死循环
    fork
      begin
        // 任务 A: 等待 pl_led1 拉高 (表示对齐锁定成功)
        wait (pl_led1 == 1'b1);
        $display("\n========================================================");
        $display("[%t] SUCCESS: Aligner Locked! (pl_led1 is HIGH)", $time);
        $display("========================================================\n");
        
        // 锁定后再运行一段时间，观察数据传输稳定性
        #1000000; 
        $display("[%t] Testbench Finished Successfully.", $time);
        $finish;
      end
      
      begin
        // 任务 B: 超时计数器 (例如等待 500us)
        // GTH 仿真通常很慢，如果没有设置 SIM_GTRESET_SPEEDUP，可能需要毫秒级
        #500_000_000; // 500us
        $display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        $display("[%t] TIMEOUT: Aligner did not lock within expected time.", $time);
        $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
        $stop;
      end
    join
  end

reg [4:0] slide_cnt;
  always@(posedge u_dut.rxusrclk2 or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
      slide_cnt <= 'd0;
    end else begin
      if(u_dut.rxslide_in)begin
        if(slide_cnt == 'd32)
          slide_cnt <= 'd0;
        else 
          slide_cnt <= slide_cnt + 1'b1;
      end
    end
  end

endmodule