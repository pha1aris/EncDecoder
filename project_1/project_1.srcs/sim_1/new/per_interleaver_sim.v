`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for rs_interleaver_xpm & rs_deinterleaver_xpm
//////////////////////////////////////////////////////////////////////////////////

module xpm_interleaver_sim;

    //================ 参数定义 =================
    parameter real CORE_CLK_PERIOD = 10.0;   // 100 MHz
    parameter integer D  = 4;
    parameter integer N  = 255;

    // 这里这几个参数先留着，你之后可以用来做停止条件
    parameter integer CODEWORD_SIZE_IN_32 = 65;
    parameter integer NUM_CODEWORDS       = 4;
    localparam integer BLOCK_SIZE         = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS; // 260
    localparam integer NUM_BLOCKS_TO_TEST = 20;
    localparam integer TOTAL_WORDS        = BLOCK_SIZE * NUM_BLOCKS_TO_TEST;

    //================ 时钟与复位 =================
    reg core_clk;
    reg rst;

    initial core_clk = 1'b0;
    always #(CORE_CLK_PERIOD/2.0) core_clk = ~core_clk;

    initial begin
        rst = 1'b1;
        #(CORE_CLK_PERIOD*4);
        rst = 1'b0;
    end

    //=================== 源数据：8bit PRBS ===================

    wire        src_ready;
    wire [7:0]  prbs_data;
    wire        prbs_valid;

    // 这里简单地：当交织器 ready 时就喂一个新符号
    assign prbs_valid = src_ready & ~rst;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),   // 发生器
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (8)    // 注意：8bit PRBS
    ) u_prbs_gen (
        .RST      (rst),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (prbs_valid),
        .DATA_OUT (prbs_data)
    );

    //=================== 交织器 / 去交织器 ===================

    wire        xpm_intv_ready;
    wire [7:0]  xpm_intv_data_o;
    wire        xpm_intv_dvalid;
    wire        out_block_start;   // 交织块起始标志（来自 interleaver）

    // in_tlast 当前不用，直接绑 0
    wire xpm_last = 1'b0;

    // 交织器
    rs_interleaver_xpm #(
        .D (D),
        .N (N)
    ) u_xpm_interleaver (
        .clk             (core_clk),
        .rst             (rst),

        .in_valid        (prbs_valid),
        .in_data         (prbs_data),
        .in_ready        (src_ready),
        .in_tlast        (xpm_last),        // 暂时不用

        .out_block_start (out_block_start), // 每个交织块首符号脉冲
        .out_valid       (xpm_intv_dvalid),
        .out_data        (xpm_intv_data_o)
    );

    // 去交织器信号
    wire        xpm_deintv_ready;
    wire [7:0]  xpm_deintv_data;
    wire        xpm_deintv_dvalid;
    wire        block_start;       // 去交织器输出块起始（可用于后端 framer）
    wire        blk_soft_rst;      // 去交织器输入软复位

    // 简单闭环：交织器的 out_block_start -> 去交织器 blk_soft_rst
    // 真实系统中这里会由 deframer 的 o_blk_soft_rst 驱动
    assign blk_soft_rst    = out_block_start;
    assign xpm_deintv_ready = 1'b1;  // 去交织器后面不 backpressure，永远 ready

    rs_deinterleaver_xpm #(
        .D (D),
        .N (N)
    ) u_xpm_deinterleaver (
        .clk         (core_clk),
        .rst         (rst),

        .blk_soft_rst(blk_soft_rst),
        .in_valid    (xpm_intv_dvalid),
        .in_data     (xpm_intv_data_o),
        .in_ready    (xpm_deintv_ready),

        .block_start (block_start),
        .out_valid   (xpm_deintv_dvalid),
        .out_data    (xpm_deintv_data)
    );

    //=================== PRBS Checker ===================

    wire [7:0] prbs_err_vec;
    wire       prbs_match;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),   // 检查模式
        .INV_PATTERN (1),
        .POLY_LENGHT (31),
        .POLY_TAP    (28),
        .NBITS       (8)
    ) u_prbs_chk (
        .RST      (rst),
        .CLK      (core_clk),
        .DATA_IN  (xpm_deintv_data),
        .EN       (xpm_deintv_dvalid),   // 只在真正输出有效时比较
        .DATA_OUT (prbs_err_vec)
    );

    assign prbs_match = ~|prbs_err_vec;

    //=================== 监视 & 停止条件 ===================

    integer send_cnt;
    integer recv_cnt;
    integer err_cnt;

    // 统计发送符号数
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            send_cnt <= 0;
        end else if (prbs_valid) begin
            send_cnt <= send_cnt + 1;
        end
    end

    // 统计接收符号数 / 错误数
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            recv_cnt <= 0;
            err_cnt  <= 0;
        end else if (xpm_deintv_dvalid) begin
            recv_cnt <= recv_cnt + 1;
            if (!prbs_match) begin
                err_cnt <= err_cnt + 1;
                $display("[%0t ns] PRBS ERROR: data=%02x, err_vec=%02x, recv_cnt=%0d",
                         $time, xpm_deintv_data, prbs_err_vec, recv_cnt);
            end
        end
    end

    // 仿真结束条件：接收够一定数量的符号
    initial begin
        // 等复位结束
        @(negedge rst);
        // 等待一段时间让流水线填满
        repeat (10) @(posedge core_clk);

        // 可以用 TOTAL_WORDS，也可以用固定值，这里给个适中值
        wait (recv_cnt >= TOTAL_WORDS);
        #100;
        $display("====================================================");
        $display("  XPM Interleaver/Deinterleaver Simulation Done");
        $display("  Sent symbols : %0d", send_cnt);
        $display("  Recv symbols : %0d", recv_cnt);
        $display("  PRBS errors  : %0d", err_cnt);
        $display("====================================================");
        $finish;
    end

    // 波形 dump（适合仿真器不自带 GUI 时）
    initial begin
        $dumpfile("xpm_interleaver_sim.vcd");
        $dumpvars(0, xpm_interleaver_sim);
    end

endmodule
