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
    parameter P_PIPELINE_LATENCY = 5;   // 匹配 pipelined 计算延迟

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
    // wire                  slip_detected;
    // wire signed [2:0]     slip_amount;
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
        .PIPELINE_LATENCY(P_PIPELINE_LATENCY)
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
        // .slip_detected(slip_detected),
        // .slip_amount(slip_amount),
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

        // $display("--- [TB] Simulation Start: Testing 192-bit Sync Pattern ---");
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
        // $display("--- [TB] Reset Released. Sending garbage data... ---");

        // 3. 发送一些 "垃圾" 数据 (例如 10 个周期)
        // repeat (10) @(posedge clk) begin
        //     din <= $random; // 使用随机数作为垃圾数据
        // end

        // 4. 精确注入 192-bit 同步头 (分为 6 个 32-bit 字)
        // 注意: 由于 shift_buf 是右移 {din, shift_buf[...]}
        // 所以我们按高位到低位的顺序注入
// $display("--- [TB] Inj
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
// $display("frame 1 send finish ---");
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
// $display("frame 2 send finish ---");
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
// $display("frame 3 send finish ---");
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
// $display("frame 4 send finish ---");
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
// $display("frame 5 send finish ---");
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
// $display("frame 6 send finish ---");
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
// $display("frame 7 send finish ---");
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

        // $display("--- [TB] Pattern injected. Waiting for detection... ---");

        // 5. 等待检测结果
        // 延迟计算:
        // - 数据完全进入 shift_buf 的相关 192 位需要 6 个周期
        // - 流水线计算需要 4 个周期 (A -> B -> C -> D/Output)
        // - 总延迟 = 6 + 4 = 10 个周期
        // 我们多等待几个周期以观察
        repeat (15) @(posedge clk) begin
            din <= $random; // 继续发送垃圾数据
        end
        
        // $display("--- [TB] Check wflag[0] around T=%0t", $time);
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
        @(posedge clk) din <= 32'h01111111; //1
        @(posedge clk) din <= 32'h01111111; //2
        @(posedge clk) din <= 32'h01111111; //3
        @(posedge clk) din <= 32'h01111111; //4
        @(posedge clk) din <= 32'h01111111; //5
        @(posedge clk) din <= 32'h01111111; //6
// $display("frame 1 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h12222222; //1
        @(posedge clk) din <= 32'h12222222; //2
        @(posedge clk) din <= 32'h12222222; //3
        @(posedge clk) din <= 32'h12222222; //4
        @(posedge clk) din <= 32'h12222222; //5
        @(posedge clk) din <= 32'h12222222; //6
// $display("frame 2 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h23333333; //1
        @(posedge clk) din <= 32'h23333333; //2
        @(posedge clk) din <= 32'h23333333; //3
        @(posedge clk) din <= 32'h23333333; //4
        @(posedge clk) din <= 32'h23333333; //5
        @(posedge clk) din <= 32'h23333333; //6
// $display("frame 3 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h34444444; //1
        @(posedge clk) din <= 32'h34444444; //2
        @(posedge clk) din <= 32'h34444444; //3
        @(posedge clk) din <= 32'h34444444; //4
        @(posedge clk) din <= 32'h34444444; //5
        @(posedge clk) din <= 32'h34444444; //6
// $display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h45555555; //1
        @(posedge clk) din <= 32'h45555555; //2
        @(posedge clk) din <= 32'h45555555; //3
        @(posedge clk) din <= 32'h45555555; //4
        @(posedge clk) din <= 32'h45555555; //5
        @(posedge clk) din <= 32'h45555555; //6
// $display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h56666666; //1
        @(posedge clk) din <= 32'h56666666; //2
        @(posedge clk) din <= 32'h56666666; //3
        @(posedge clk) din <= 32'h56666666; //4
        @(posedge clk) din <= 32'h56666666; //5
        @(posedge clk) din <= 32'h56666666; //6
// $display("frame 4 send finish ---");
        @(posedge clk) din <= 32'hB1699558; // Word 1 (MSB of pattern)
        @(posedge clk) din <= 32'hA53333A8; // Word 2
        @(posedge clk) din <= 32'hB1699558; // Word 3
        @(posedge clk) din <= 32'hA53333A8; // Word 4
        @(posedge clk) din <= 32'hB1699558; // Word 5
        @(posedge clk) din <= 32'hA53333A8; // Word 6 (LSB of pattern)
        @(posedge clk) din <= 32'h67777777; //1
        @(posedge clk) din <= 32'h67777777; //2
        @(posedge clk) din <= 32'h67777777; //3
        @(posedge clk) din <= 32'h67777777; //4
        @(posedge clk) din <= 32'h67777777; //5
        @(posedge clk) din <= 32'h67777777; //6
// $display("frame 4 send finish ---");
        // 7. 结束
        $display("--- [TB] Test Complete. ---");
        #1000;
        // $finish;
         $stop;
    end


// always @(*) begin
//   if (uut.din == 32'hA53333A8 && uut.din_valid) 
//     $display("sync tail input at %0t", $time);
//   if (|uut.wflag_reg_out) 
//     $display("wflag_reg_out high at %0t", $time);
//   if (|uut.wflag_delayed) 
//     $display("wflag_delayed high at %0t", $time);

//   if (uut.header_end_delayed)
//     $display("hdr_end_dly=%0t hit_in_frame=%b frame_lock=%b", $time, uut.hit_in_frame, uut.frame_lock);
//   if (uut.found_pulse)
//     $display("found_pulse @ %0t", $time);
// end
// ================================================================
// Frame Synchronizer Runtime Monitor (Verilog-safe, with uut.)
// ================================================================

initial begin
  $display("\n===== [Frame Sync Runtime Monitor] =====");
  $display("Time(ns) | frame_lock | hit_in_frame | found_pulse | hdr_end_d1 | hdr_end_d2 | state");
  $display("---------------------------------------------------------------");
end

// ================================================================
// 1️⃣ 基本事件监控
// ================================================================

// always @(posedge clk) begin
//   if (rst_n) begin

//     // 打印帧头结束信号变化
//     if (uut.header_end_delayed)
//       $display("[%0t] hdr_end_dly | hit_in_frame=%0d | frame_lock=%0d | verify_cnt=%0d | miss_cnt=%0d",
//         $time, uut.hit_in_frame, uut.frame_lock, uut.verify_cnt, uut.miss_cnt);

//     if (uut.header_end_d1)
//       $display("[%0t] hdr_end_d1  | hit_in_frame=%0d | frame_lock=%0d | verify_cnt=%0d | miss_cnt=%0d",
//         $time, uut.hit_in_frame, uut.frame_lock, uut.verify_cnt, uut.miss_cnt);

//     if (uut.header_end_d2)
//       $display("[%0t] hdr_end_d2  | hit_in_frame=%0d | frame_lock=%0d | verify_cnt=%0d | miss_cnt=%0d",
//         $time, uut.hit_in_frame, uut.frame_lock, uut.verify_cnt, uut.miss_cnt);

//     // found_pulse 打印
//     if (uut.found_pulse)
//       $display("[%0t] found_pulse ↑ | in_header_delayed=%0d | hit_in_frame=%0d | state=%s",
//         $time, uut.in_header_delayed, uut.hit_in_frame, uut.ascii_state);

//     // 帧起止标志
//     if (uut.frame_start)
//       $display("[%0t] frame_start ↑ (new frame begins)", $time);
//     if (uut.frame_end)
//       $display("[%0t] frame_end   ↑ (frame end reached)", $time);

//     // 输出非法检查
//     if (uut.dout_valid && !uut.frame_lock) begin
//       $display("[%0t][ERROR]  dout_valid=1 while frame_lock=0 (BAD FRAME OUTPUT)", $time);
//       $stop;
//     end

//   end
// end

// ================================================================
// 2️⃣ frame_lock 边沿检测（Verilog 兼容写法）
// ================================================================

// reg prev_frame_lock;
// always @(posedge clk or negedge rst_n) begin
//   if (!rst_n)
//     prev_frame_lock <= 1'b0;
//   else
//     prev_frame_lock <= uut.frame_lock;
// end

// always @(posedge clk) begin
//   if (rst_n) begin
//     if (!prev_frame_lock && uut.frame_lock)
//       $display("[%0t] >>> Frame LOCK ACQUIRED <<<", $time);
//     if (prev_frame_lock && !uut.frame_lock)
//       $display("[%0t] !!! Frame LOCK LOST !!!", $time);
//   end
// end

// ================================================================
// 3️⃣ 状态一致性检查 / 命中异常检测
// ================================================================

// 若锁定状态下该帧未命中 → 预警
// always @(posedge clk) begin
//   if (rst_n && uut.frame_lock && uut.header_end_d2 && !uut.hit_in_frame) begin
//     $display("[%0t][WARN]  Locked but current frame missed header!", $time);
//   end
//   if (uut.found_pulse)
//   $display("[%0t] found_pulse vs in_header_delayed=%0d header_end_delayed=%0d",
//     $time, uut.in_header_delayed, uut.header_end_delayed);
// end

// // 检查 found_pulse 是否与 header_end_delayed 重叠
// reg found_overlap_hdr;
// always @(posedge clk or negedge rst_n) begin
//   if (!rst_n)
//     found_overlap_hdr <= 1'b0;
//   else
//     found_overlap_hdr <= uut.header_end_delayed && uut.found_pulse;
// end

// always @(posedge clk) begin
//   if (found_overlap_hdr)
//     $display("[%0t][WARN]  found_pulse overlaps header_end_delayed, possible timing race!", $time);
// end

// // ================================================================
// // 4️⃣ 仿真结束汇总
// // ================================================================

// initial begin
//   #3000000; // 仿真时间，可按需求修改（此处为3us）
//   $display("\n===== [Simulation Summary] =====");
//   $display("仿真结束：若无 或 日志，则帧同步链稳定");
//   $stop;
// end



endmodule 