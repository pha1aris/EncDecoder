`timescale 1ns/1ps

module xpm_interleaver_sim;

    //================================================================
    // 0. 仿真参数
    //================================================================
    localparam real CORE_CLK_PERIOD_NS   = 10.0;   // 100 MHz
    localparam integer TB_D              = 4;      // 先用小一点 D，方便仿真
    localparam integer TB_N              = 255;    // 和你的 RS(255,229) 保持一致

    localparam integer WARMUP_SYMBOLS    = 2000;   // 跳过前面 N 个 symbol 再开始严格检查
    localparam integer NUM_TEST_SYMBOLS  = 20000;  // 总共检查这么多个 symbol

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
    end

    //================================================================
    // 2. PRBS 信号 & 中间连线
    //================================================================
    wire [7:0] prbs_tx_data;
    wire [7:0] prbs_err_to_chk;
    wire       prbs_match;

    assign prbs_match = ~|prbs_err_to_chk;   // 全 0 表示匹配

    // 交织器 <-> 解交织器 AXIS 信号
    wire        intlv_in_valid;
    wire        intlv_in_ready;
    wire [7:0]  intlv_in_data;

    wire        intlv_out_valid;
    wire [7:0]  intlv_out_data;
    wire        intlv_out_ready;

    wire        deintlv_in_valid;
    wire        deintlv_in_ready;
    wire [7:0]  deintlv_in_data;

    wire        deintlv_out_valid;
    wire [7:0]  deintlv_out_data;
    wire        deintlv_out_ready;

    assign intlv_in_valid   = 1'b1;          // 测试中：源端一直有数据
    assign intlv_in_data    = prbs_tx_data;  // 送入交织器的数据 = PRBS
    assign intlv_out_ready  = deintlv_in_ready;

    assign deintlv_in_valid = intlv_out_valid;
    assign deintlv_in_data  = intlv_out_data;
    assign deintlv_out_ready= 1'b1;          // 下游一直 ready（可以以后改成随机 backpressure）

    reg [7:0] cnt;
    wire cnt_fire = intlv_in_valid && intlv_in_ready;
    always@(posedge clk or posedge rst)begin
        if(rst)
            cnt <= 'd0;
        else if(cnt_fire)begin
            if(cnt == 'd509)
                cnt <= 'd0;
            else 
                cnt <= cnt + 1'b1;
        end
    end
    wire out_block_start;
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
        // .out_ready      (intlv_out_ready),
        .out_block_start(out_block_start)             // 暂时不用
    );

    //================================================================
    // 4. Deinterleaver 实例（你刚贴的这版）
    //================================================================
    rs_deinterleaver_xpm #(
        .D (TB_D),
        .N (TB_N)
    ) u_deinterleaver (
        .clk        (clk),
        .rst        (rst),

        .in_valid   (deintlv_in_valid),
        .in_data    (deintlv_in_data),
        .in_ready   (deintlv_in_ready),

        .out_valid  (deintlv_out_valid),
        .out_data   (deintlv_out_data)
    );

    //================================================================
    // 5. PRBS 发生器 & 检查器
    //================================================================

    // 交织器真正接收数据的那个事件
    wire intlv_accept;
    assign intlv_accept = intlv_in_valid & intlv_in_ready;

    // PRBS 发生器：每当交织器真正“吃掉”一个输入 symbol，就前进一步
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

    // PRBS 检查器：每当 deinterleaver 吐出一个 symbol，就前进一步
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
        .EN       (deintlv_out_valid&&deintlv_out_ready),  // ★关键：与解交织输出对齐
        .DATA_OUT (prbs_err_to_chk)
    );

    //================================================================
    // 6. 仿真监控：统计 symbol，检查是否有错误
    //================================================================
    integer out_sym_cnt;
    initial out_sym_cnt = 0;

    always @(posedge clk) begin
        if (rst) begin
            out_sym_cnt <= 0;
        end else if (deintlv_out_valid) begin
            out_sym_cnt <= out_sym_cnt + 1;

            // 跳过前 WARMUP_SYMBOLS 个 symbol（系统 pipeline 可能没完全同步）
            if (out_sym_cnt > WARMUP_SYMBOLS) begin
                if (prbs_err_to_chk !== 8'h00) begin
                    $display("[%0t] PRBS ERROR! out_sym_cnt=%0d, err=0x%0h",
                             $time, out_sym_cnt, prbs_err_to_chk);
                    $display("    deintlv_out_data = 0x%0h", deintlv_out_data);
//                    $stop;
                end
            end

            // 跑够 NUM_TEST_SYMBOLS 就认为 PASS
            if (out_sym_cnt == NUM_TEST_SYMBOLS) begin
                $display("=========================================");
                $display(" PRBS TEST PASS!  symbols checked = %0d", NUM_TEST_SYMBOLS);
                $display("=========================================");
                $finish;
            end
        end
    end



endmodule
