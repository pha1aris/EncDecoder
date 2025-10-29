`timescale 1ns / 1ps

//
// 1. 仿真顶层模块 (Testbench) - 针对 192-bit 同步头检测
//
module tb_frame_sync_top;

    // --- DUT 参数 ---
    parameter P_PARALLEL         = 32;
    parameter P_MASK_LEN         = 192; // <--- 匹配 192-bit 模式
    parameter P_ASM_LEN          = 192; // <--- 整个模式有效
    parameter P_TOLERANCE        = 0;   // <--- 精确匹配
    parameter P_FRAME_LEN_BYTE   = 48;  // 帧长度 字节
    parameter P_M_VERIFY         = 3;
    parameter P_N_PROTECT        = 2;
    parameter P_PIPELINE_LATENCY = 5;   // 匹配 pipelined 模块的 3 级计算延迟
    parameter P_FIFO_DEPTH_BITS  = 4;

    // --- 时钟周期 ---
    localparam CLK_PERIOD = 10; // 100 MHz

    // --- Testbench 寄存器 ---
    reg                   clk;
    reg                   rst_n;
    reg [P_PARALLEL-1:0]    din;
    reg                   din_valid;
    reg [P_MASK_LEN-1:0]    asm_pattern;
    reg [P_MASK_LEN-1:0]    asm_mask;

    // --- Testbench 线网 ---
    wire                  frame_lock;
    wire                  frame_sync_found;
    wire [4:0]              wnumber_dec;
    wire [3:0]              flocation;
    wire                  slip_detected;
    wire signed [2:0]     slip_amount;
    wire [P_PARALLEL-1:0]   dout;
    wire                  dout_valid;
    
    // --- 直接观察 pipelined 模块的输出 ---

    wire [P_PARALLEL-1:0] wflag_internal = uut.u_pipelined.wflag_reg_out;

    // -------------------------------------------------
    // DUT (Design Under Test) 实例化
    // -------------------------------------------------
    frame_synchronizer_top #(
        .PARALLEL(P_PARALLEL),
        .MASK_LEN(P_MASK_LEN),
        .ASM_LEN(P_ASM_LEN), // <-- 传递 ASM_LEN
        .TOLERANCE(P_TOLERANCE),
        .FRAME_LEN_BYTE(P_FRAME_LEN_BYTE),
        .M_VERIFY(P_M_VERIFY),
        .N_PROTECT(P_N_PROTECT),
        .PIPELINE_LATENCY(P_PIPELINE_LATENCY),
        .FIFO_DEPTH_BITS(P_FIFO_DEPTH_BITS)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .din(din),
        .din_valid(din_valid),
        .asm_pattern(asm_pattern),
        .asm_mask(asm_mask),
        .frame_lock(frame_lock),
        .frame_sync_found(frame_sync_found),
        .wnumber_dec(wnumber_dec),
        .flocation(flocation),
        .slip_detected(slip_detected),
        .slip_amount(slip_amount),
        .dout(dout),
        .dout_valid(dout_valid)
    );

    // --- 时钟生成 ---
    always # (CLK_PERIOD / 2) clk = ~clk;

    // --- 监视器 ---
    initial begin
        $monitor("Time=%0t | din=%h | wflag=%b | frame_lock=%b | dout_valid=%b dout=%h",
                 $time, din, wflag_internal, frame_lock, dout_valid, dout);
    end

    reg head_send_finish;

    // --- 激励 (Stimulus) ---
    initial begin
        clk = 1'b0; // 初始化时钟

        $display("--- [TB] Simulation Start: Testing 192-bit Sync Pattern ---");
        // 1. 初始化
        rst_n       = 1'b0; // 保持复位
        din         = 32'h0;
        din_valid   = 1'b0;
        head_send_finish = 1'b0;
        // 设置 192-bit 目标同步模式 (B169... 重复 3 次)
        asm_pattern = 192'hB1699558A53333A8B1699558A53333A8B1699558A53333A8;
        // 掩码: 所有 192 位都有效
        asm_mask    = {P_MASK_LEN{1'b1}}; // Equivalent to 192'hFFFF...

        // 2. 释放复位
        #(CLK_PERIOD * 2);
        @(posedge clk)begin
          rst_n     <= 1'b1;
          // din_valid <= 1'b1; // 开始发送数据
        end
        $display("--- [TB] Reset Released. Sending garbage data... ---");

        // 3. 发送一些 "垃圾" 数据 (例如 10 个周期)
        // repeat (10) @(posedge clk) begin
        //     din <= $random; // 使用随机数作为垃圾数据
        // end

        // 4. 精确注入 192-bit 同步头 (分为 6 个 32-bit 字)
        // 注意: 由于 shift_buf 是右移 {din, shift_buf[...]}
        // 所以我们按高位到低位的顺序注入
$display("--- [TB] Injecting 192-bit Sync Pattern (6 words)... ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din_valid <= 1'b1;
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h11111111; //1
        @(posedge clk) din <= 32'h11111111; //2
        @(posedge clk) din <= 32'h11111111; //3
        @(posedge clk) din <= 32'h11111111; //4
        @(posedge clk) din <= 32'h11111111; //5
        @(posedge clk) din <= 32'h11111111; //6
$display("frame 1 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h22222222; //1
        @(posedge clk) din <= 32'h22222222; //2
        @(posedge clk) din <= 32'h22222222; //3
        @(posedge clk) din <= 32'h22222222; //4
        @(posedge clk) din <= 32'h22222222; //5
        @(posedge clk) din <= 32'h22222222; //6
$display("frame 2 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h33333333; //1
        @(posedge clk) din <= 32'h33333333; //2
        @(posedge clk) din <= 32'h33333333; //3
        @(posedge clk) din <= 32'h33333333; //4
        @(posedge clk) din <= 32'h33333333; //5
        @(posedge clk) din <= 32'h33333333; //6
$display("frame 3 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h44444444; //1
        @(posedge clk) din <= 32'h44444444; //2
        @(posedge clk) din <= 32'h44444444; //3
        @(posedge clk) din <= 32'h44444444; //4
        @(posedge clk) din <= 32'h44444444; //5
        @(posedge clk) din <= 32'h44444444; //6
$display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h55555555; //1
        @(posedge clk) din <= 32'h55555555; //2
        @(posedge clk) din <= 32'h55555555; //3
        @(posedge clk) din <= 32'h55555555; //4
        @(posedge clk) din <= 32'h55555555; //5
        @(posedge clk) din <= 32'h55555555; //6
$display("frame 5 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h66666666; //1
        @(posedge clk) din <= 32'h66666666; //2
        @(posedge clk) din <= 32'h66666666; //3
        @(posedge clk) din <= 32'h66666666; //4
        @(posedge clk) din <= 32'h66666666; //5
        @(posedge clk) din <= 32'h66666666; //6
$display("frame 6 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h77777777; //1
        @(posedge clk) din <= 32'h77777777; //2
        @(posedge clk) din <= 32'h77777777; //3
        @(posedge clk) din <= 32'h77777777; //4
        @(posedge clk) din <= 32'h77777777; //5
        @(posedge clk) din <= 32'h77777777; //6
$display("frame 7 send finish ---");
        // @(posedge clk)begin
        //     head_send_finish <= 1'b1;
        //     din <= 'd0;
        //     din_valid <= 1'b0;
        // end

        // @(posedge clk)begin
        //     head_send_finish <= 1'b0;
        //     din <= 'd0;
        //     din_valid <= 1'b1;
        // end

        $display("--- [TB] Pattern injected. Waiting for detection... ---");

        // 5. 等待检测结果
        // 延迟计算:
        // - 数据完全进入 shift_buf 的相关 192 位需要 6 个周期
        // - 流水线计算需要 4 个周期 (A -> B -> C -> D/Output)
        // - 总延迟 = 6 + 4 = 10 个周期
        // 我们多等待几个周期以观察
        repeat (15) @(posedge clk) begin
            din <= $random; // 继续发送垃圾数据
        end
        
        $display("--- [TB] Check wflag[0] around T=%0t", $time);
        ///////////////////////////////////////////////////失所重新锁定测试
        // 6. 继续运行一段时间观察 FSM (可选)
        repeat (50) @(posedge clk) begin
             din <= $random;
        end
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h11111111; //1
        @(posedge clk) din <= 32'h11111111; //2
        @(posedge clk) din <= 32'h11111111; //3
        @(posedge clk) din <= 32'h11111111; //4
        @(posedge clk) din <= 32'h11111111; //5
        @(posedge clk) din <= 32'h11111111; //6
$display("frame 1 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h22222222; //1
        @(posedge clk) din <= 32'h22222222; //2
        @(posedge clk) din <= 32'h22222222; //3
        @(posedge clk) din <= 32'h22222222; //4
        @(posedge clk) din <= 32'h22222222; //5
        @(posedge clk) din <= 32'h22222222; //6
$display("frame 2 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h33333333; //1
        @(posedge clk) din <= 32'h33333333; //2
        @(posedge clk) din <= 32'h33333333; //3
        @(posedge clk) din <= 32'h33333333; //4
        @(posedge clk) din <= 32'h33333333; //5
        @(posedge clk) din <= 32'h33333333; //6
$display("frame 3 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h44444444; //1
        @(posedge clk) din <= 32'h44444444; //2
        @(posedge clk) din <= 32'h44444444; //3
        @(posedge clk) din <= 32'h44444444; //4
        @(posedge clk) din <= 32'h44444444; //5
        @(posedge clk) din <= 32'h44444444; //6
$display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h55555555; //1
        @(posedge clk) din <= 32'h55555555; //2
        @(posedge clk) din <= 32'h55555555; //3
        @(posedge clk) din <= 32'h55555555; //4
        @(posedge clk) din <= 32'h55555555; //5
        @(posedge clk) din <= 32'h55555555; //6
$display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h66666666; //1
        @(posedge clk) din <= 32'h66666666; //2
        @(posedge clk) din <= 32'h66666666; //3
        @(posedge clk) din <= 32'h66666666; //4
        @(posedge clk) din <= 32'h66666666; //5
        @(posedge clk) din <= 32'h66666666; //6
$display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h77777777; //1
        @(posedge clk) din <= 32'h77777777; //2
        @(posedge clk) din <= 32'h77777777; //3
        @(posedge clk) din <= 32'h77777777; //4
        @(posedge clk) din <= 32'h77777777; //5
        @(posedge clk) din <= 32'h77777777; //6
$display("frame 4 send finish ---");
        // 7. 结束
        $display("--- [TB] Test Complete. ---");
        // $finish;
         $stop;
    end

endmodule 