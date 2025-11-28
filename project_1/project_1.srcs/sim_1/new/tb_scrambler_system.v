//======================================================================
// 测试平台：发送端 + 接收端（同一个 scrambler 模块，在 RX 当 descrambler）
//======================================================================
module tb_scrambler_system();

    // 1. 全局信号定义
    reg clk;
    reg sys_rst;      // 硬件复位（同时作用于 TX/RX scrambler 的 rst）

    // 2. TX (发送端) 信号
    reg  [7:0] tx_data_in;     // 原始数据
    reg        tx_scram_en;
    reg        tx_scram_rst;   // TX 的逻辑复位（同步种子）
    wire [7:0] tx_data_out;    // 加扰后的数据（“上线路”的数据）

    // 3. RX (接收端) 信号
    wire [7:0] rx_data_in;
    reg        rx_scram_en;
    reg        rx_scram_rst;   // RX 的逻辑复位
    wire [7:0] rx_data_out;    // 解扰后的数据（应等于 tx_data_in，但晚 1 拍）

    // 4. 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 周期 → 100 MHz
    end

    // 5. 模拟信道连接 (直连)
    assign rx_data_in = tx_data_out;

    wire data_valid_out;

    //============================================================
    // 6. 实例化发送端 (Scrambler)
    //============================================================
    scrambler u_tx (
        .clk            (clk),
        .rst            (sys_rst),
        .data_in        (tx_data_in),
        .data_valid_out (data_valid_out),
        .scram_en       (tx_scram_en),
        .scram_rst      (tx_scram_rst),
        .data_out       (tx_data_out)
    );

    //============================================================
    // 7. 实例化接收端 (Descrambler)
    //============================================================
    scrambler u_rx (
        .clk       (clk),
        .rst       (sys_rst),
        .data_in   (tx_data_out),   // 输入是 TX 的输出
        .scram_en  (data_valid_out),
        .scram_rst (tx_scram_rst), // 必须和 TX 对齐时刻才会正确解扰
        .data_out  (rx_data_out)
    );

    //============================================================
    // 8. Checker：考虑 1 拍延迟后的数据比较
    //============================================================
    reg [7:0] tx_data_in_d1;     // tx_data_in 打一拍
    reg       check_en_d1;       // 使能也打拍，和 tx_data_in_d1 对齐

    wire check_en = tx_scram_en & rx_scram_en;  // 只有 TX/RX 都在工作时才检查

    integer total_cnt;      // 总比较符号数
    integer err_cnt;        // 总错误符号数
    integer case1_err_cnt;  // 记录 Case1 结束时的错误数

    always @(posedge clk or posedge sys_rst) begin
        if (sys_rst) begin
            tx_data_in_d1 <= 8'h00;
            check_en_d1   <= 1'b0;
            total_cnt     <= 0;
            err_cnt       <= 0;
        end else begin
            // 打拍（注意：打拍顺序无所谓，组合在一起即可）
            tx_data_in_d1 <= tx_data_in;
            check_en_d1   <= check_en;

            // 只在使能有效、且已经有对齐后一拍时比较
            if (check_en_d1) begin
                total_cnt <= total_cnt + 1;
                if (rx_data_out !== tx_data_in_d1) begin
                    err_cnt <= err_cnt + 1;
                    if (err_cnt < 10) begin
                        $display("[%0t] MISMATCH: tx_in_d1=%0h, rx_out=%0h",
                                 $time, tx_data_in_d1, rx_data_out);
                    end
                end
            end
        end
    end

    //============================================================
    // 9. 仿真流程
    //============================================================
    initial begin
        // VCD 波形输出（可选）
        $dumpfile("tb_scrambler_system.vcd");
        $dumpvars(0, tb_scrambler_system);

        // --- 上电复位 ---
        sys_rst      = 1;
        tx_scram_en  = 0;
        tx_scram_rst = 0;
        rx_scram_en  = 0;
        rx_scram_rst = 0;
        tx_data_in   = 8'h00;

        #50;
        sys_rst = 0;     // 释放硬件复位

        // 等几个时钟稳定一下
        repeat(5) @(posedge clk);

        //========================================================
        // Case1：TX/RX 同步 scram_rst，一起 scram_en → 应该完全对
        //========================================================
        $display("===== CASE1: TX/RX scrambler 同步复位 & 使能 =====");

        // 1) scram_rst 同时拉高一个周期，对齐 LFSR 种子
        @(posedge clk);
        tx_scram_rst <= 1'b1;
        rx_scram_rst <= 1'b1;

        @(posedge clk);
        tx_scram_rst <= 1'b0;
        rx_scram_rst <= 1'b0;

        // 2) 打开加扰
        tx_scram_en <= 1'b1;
        rx_scram_en <= 1'b1;

        // 发送一段连续计数的数据
        repeat(32) begin
            @(posedge clk);
            tx_data_in <= tx_data_in + 8'd1;   // 1,2,3,...
        end

        // 3) 停止传输
        @(posedge clk);
        tx_scram_en <= 1'b0;
        rx_scram_en <= 1'b0;

        // 等待几拍，防止最后几个符号还在路上
        repeat(5) @(posedge clk);

        case1_err_cnt = err_cnt;
        $display("CASE1: total_cnt = %0d, err_cnt = %0d", total_cnt, case1_err_cnt);

        //========================================================
        // Case2：TX 再次 scram_rst，但 RX 不复位 → 必然大量误码
        //========================================================
        $display("===== CASE2: 只 TX scram_rst, RX 不复位，模拟失步 =====");

        // 清一下数据
        tx_data_in <= 8'h00;
        @(posedge clk);

        // TX 再次同步种子，RX 不动
        tx_scram_rst <= 1'b1;
        @(posedge clk);
        tx_scram_rst <= 1'b0;

        // 打开发送/接收
        tx_scram_en <= 1'b1;
        rx_scram_en <= 1'b1;

        repeat(16) begin
            @(posedge clk);
            tx_data_in <= tx_data_in + 8'd1;
        end

        @(posedge clk);
        tx_scram_en <= 1'b0;
        rx_scram_en <= 1'b0;

        // 再等一会儿
        repeat(10) @(posedge clk);

        //========================================================
        // 10. 打印最终统计结果
        //========================================================
        $display("============================================");
        $display("Total symbols checked = %0d", total_cnt);
        $display("Error symbols (ALL)   = %0d", err_cnt);
        $display("Error symbols (Case1) = %0d", case1_err_cnt);
        $display("Error symbols (Case2) = %0d", err_cnt - case1_err_cnt);
        $display("============================================");

        $stop;
    end

endmodule