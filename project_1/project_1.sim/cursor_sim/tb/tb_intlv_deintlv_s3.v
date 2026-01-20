`timescale 1ns/1ps
`include "global_defines.vh"

// S3 测试平台：测试交织器和解交织器的数据还原能力
// 使用 PRBS 测试，支持多个交织块
module tb_intlv_deintlv_s3;

    //================================================================
    // 0. 仿真参数（使用较小的参数以便快速仿真）
    //================================================================
    localparam real CORE_CLK_PERIOD_NS = 10.0;   // 100 MHz
    localparam integer TB_D = 8;                 // 交织深度（行数）- 小参数
    localparam integer TB_N = 7;                  // 每行符号数 - 小参数
    localparam integer TOTAL_SYM_PER_BLOCK = TB_D * TB_N;  // 每个块的总符号数 = 56
    
    localparam integer NUM_BLOCKS = 4;            // 测试 4 个交织块
    localparam integer WARMUP_SYMBOLS = 100;     // 跳过前 N 个 symbol（系统 pipeline）
    localparam integer TOTAL_TEST_SYMBOLS = NUM_BLOCKS * TOTAL_SYM_PER_BLOCK;  // 总共 224 个符号

    //================================================================
    // 1. 时钟 & 复位
    //================================================================
    reg clk;
    reg rst;

    initial begin
        clk = 1'b0;
        forever #(CORE_CLK_PERIOD_NS/2.0) clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        repeat(10) @(posedge clk);   // 复位保持 10 个周期
        rst = 1'b0;
        $display("[%0t] Reset released", $time);
    end

    //================================================================
    // 2. PRBS 信号 & 中间连线
    //================================================================
    wire [7:0] prbs_tx_data;
    wire [7:0] prbs_err_to_chk;
    wire       prbs_match;

    assign prbs_match = ~|prbs_err_to_chk;   // 全 0 表示匹配

    // 交织器输入接口
    wire        intlv_in_valid;
    wire        intlv_in_ready;
    wire [7:0]  intlv_in_data;

    // 交织器输出接口
    wire        intlv_out_valid;
    wire [7:0]  intlv_out_data;
    wire        intlv_out_ready;
    wire        intlv_out_block_start;

    // 解交织器输入接口
    wire        deintlv_in_valid;
    wire        deintlv_in_ready;
    wire [7:0]  deintlv_in_data;

    // 解交织器输出接口
    wire        deintlv_out_valid;
    wire [7:0]  deintlv_out_data;
    wire        deintlv_out_ready;
    wire        deintlv_out_block_start;

    // 块计数器（用于控制发送的块数）
    reg [31:0] block_sent_cnt;
    reg [31:0] symbol_sent_cnt;
    wire block_sent_done = (block_sent_cnt >= NUM_BLOCKS);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            block_sent_cnt <= 0;
            symbol_sent_cnt <= 0;
        end else if (intlv_in_valid && intlv_in_ready && !block_sent_done) begin
            symbol_sent_cnt <= symbol_sent_cnt + 1;
            if (symbol_sent_cnt == TOTAL_SYM_PER_BLOCK - 1) begin
                symbol_sent_cnt <= 0;
                block_sent_cnt <= block_sent_cnt + 1;
                $display("[%0t] Block %0d sent (total symbols: %0d)", 
                         $time, block_sent_cnt + 1, (block_sent_cnt + 1) * TOTAL_SYM_PER_BLOCK);
            end
        end
    end

    // 连接：PRBS -> 交织器 -> 解交织器 -> PRBS 检查器
    assign intlv_in_valid   = !block_sent_done;  // 源端有数据直到发送完所有块
    assign intlv_in_data    = prbs_tx_data;      // 送入交织器的数据 = PRBS
    assign intlv_out_ready  = deintlv_in_ready;

    assign deintlv_in_valid = intlv_out_valid;
    assign deintlv_in_data  = intlv_out_data;
    assign deintlv_out_ready= 1'b1;              // 下游一直 ready

    //================================================================
    // 3. Interleaver 实例
    //================================================================
    rs_interleaver_xpm #(
        .D (TB_D),
        .N (TB_N)
    ) u_interleaver (
        .clk            (clk),
        .rst            (rst),

        .in_valid       (intlv_in_valid),
        .in_data        (intlv_in_data),
        .in_ready       (intlv_in_ready),

        .out_valid      (intlv_out_valid),
        .out_data       (intlv_out_data),
        .out_ready       (intlv_out_ready),
        .out_block_start(intlv_out_block_start)
    );

    //================================================================
    // 4. Deinterleaver 实例
    //================================================================
    rs_deinterleaver_xpm #(
        .D (TB_D),
        .N (TB_N)
    ) u_deinterleaver (
        .clk            (clk),
        .rst             (rst),
        .blk_soft_rst    (1'b0),  // 不使用软复位

        .in_valid        (deintlv_in_valid),
        .in_data         (deintlv_in_data),
        .in_ready        (deintlv_in_ready),

        .out_valid       (deintlv_out_valid),
        .out_data        (deintlv_out_data),
        .out_ready       (deintlv_out_ready),
        .block_start     (deintlv_out_block_start)
    );

    //================================================================
    // 5. PRBS 发生器 & 检查器
    //================================================================

    // 交织器真正接收数据的那个事件
    wire intlv_accept;
    assign intlv_accept = intlv_in_valid && intlv_in_ready;

    // PRBS 发生器：每当交织器真正"吃掉"一个输入 symbol，就前进一步
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),    // 0 = generator
        .INV_PATTERN (1),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_gen (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (8'd0),
        .EN       (intlv_accept),   // ★关键：与交织器写端完全对齐
        .DATA_OUT (prbs_tx_data)
    );

    // PRBS 检查器：每当解交织器吐出一个 symbol，就前进一步
    wire deintlv_out_fire = deintlv_out_valid && deintlv_out_ready;
    
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),    // 1 = checker
        .INV_PATTERN (1),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST      (rst),
        .CLK      (clk),
        .DATA_IN  (deintlv_out_data),
        .EN       (deintlv_out_fire),  // ★关键：与解交织输出对齐
        .DATA_OUT (prbs_err_to_chk)
    );

    //================================================================
    // 6. 仿真监控：统计 symbol，检查是否有错误
    //================================================================
    integer out_sym_cnt;
    integer prbs_err_cnt;
    integer block_rcv_cnt;
    reg [31:0] last_block_start_time;
    
    initial begin
        out_sym_cnt = 0;
        prbs_err_cnt = 0;
        block_rcv_cnt = 0;
        last_block_start_time = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            out_sym_cnt <= 0;
            prbs_err_cnt <= 0;
            block_rcv_cnt <= 0;
        end else begin
            // 检测块开始
            if (deintlv_out_valid && deintlv_out_ready && deintlv_out_block_start) begin
                block_rcv_cnt <= block_rcv_cnt + 1;
                last_block_start_time <= $time;
                $display("[%0t] ===== Block %0d received (block_start detected) =====", 
                         $time, block_rcv_cnt + 1);
            end
            
            // 统计输出的 symbol
            if (deintlv_out_valid && deintlv_out_ready) begin
                out_sym_cnt <= out_sym_cnt + 1;

                // 跳过前 WARMUP_SYMBOLS 个 symbol（系统 pipeline 可能没完全同步）
                if (out_sym_cnt >= WARMUP_SYMBOLS) begin
                    if (prbs_err_to_chk !== 8'h00) begin
                        prbs_err_cnt <= prbs_err_cnt + 1;
                        $display("[%0t] PRBS ERROR! out_sym_cnt=%0d, err=0x%02h, data=0x%02h",
                                 $time, out_sym_cnt, prbs_err_to_chk, deintlv_out_data);
                    end
                end

                // 每收到一个完整块，打印统计信息
                if (out_sym_cnt > 0 && (out_sym_cnt % TOTAL_SYM_PER_BLOCK == 0)) begin
                    $display("[%0t] Block %0d completed: %0d symbols, errors=%0d", 
                             $time, out_sym_cnt / TOTAL_SYM_PER_BLOCK, 
                             TOTAL_SYM_PER_BLOCK, prbs_err_cnt);
                end
            end
        end
    end

    // 仿真结束条件：收到所有块且没有错误
    reg test_pass;
    initial test_pass = 0;
    
    always @(posedge clk) begin
        if (!rst && block_rcv_cnt >= NUM_BLOCKS && out_sym_cnt >= TOTAL_TEST_SYMBOLS) begin
            if (prbs_err_cnt == 0) begin
                $display("=========================================");
                $display(" PRBS TEST PASS!");
                $display(" Total blocks received: %0d", block_rcv_cnt);
                $display(" Total symbols checked: %0d", out_sym_cnt);
                $display(" PRBS errors: %0d", prbs_err_cnt);
                $display("=========================================");
                test_pass <= 1;
                #1000;  // 等待一段时间
                $finish;
            end else begin
                $display("=========================================");
                $display(" PRBS TEST FAIL!");
                $display(" Total blocks received: %0d", block_rcv_cnt);
                $display(" Total symbols checked: %0d", out_sym_cnt);
                $display(" PRBS errors: %0d", prbs_err_cnt);
                $display("=========================================");
                #1000;
                $finish;
            end
        end
    end

    // 超时保护：如果仿真运行时间过长，自动结束
    initial begin
        #1000000;  // 1ms 超时
        $display("[%0t] Simulation timeout!", $time);
        $display("  Blocks sent: %0d", block_sent_cnt);
        $display("  Blocks received: %0d", block_rcv_cnt);
        $display("  Symbols received: %0d", out_sym_cnt);
        $display("  PRBS errors: %0d", prbs_err_cnt);
        $finish;
    end

endmodule
