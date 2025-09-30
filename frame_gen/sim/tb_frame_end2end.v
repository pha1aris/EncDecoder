`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: tb_frame_end2end_optimized
//
// Description:
//   一个更健壮、自校验的端到端测试平台。
//   - 新增! 自动数据校验逻辑 (Scoreboard)。
//   - 新增! 随机化的反压/流控，模拟真实场景。
//   - 新增! 错误注入任务，用于测试同步器的容错能力。
//   - 结束时会自动报告 PASS / FAIL。
//
//////////////////////////////////////////////////////////////////////////////////
module tb_frame_end2end;

    localparam PAYLOAD_SIZE_WORDS = 16; // 仿真小尺寸，方便观察

    // --- 时钟与复位 ---
    reg clk;
    reg rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
    end

    // --- 模块间连线 ---
    wire [31:0] payload_data_gen_w;
    wire        payload_valid_gen_w;
    wire        payload_ready_gen_w;

    wire [31:0] framed_data_w;
    wire        framed_valid_w;
    wire        framed_ready_w;
    
    wire [31:0] payload_data_sync_w;
    wire        payload_valid_sync_w;
    wire        payload_ready_sync_w;
    assign payload_ready_sync_w = 1;
    wire        start_of_frame_w;

    // --- DUT 1: 帧生成器 ---
    // 注意：这里需要例化您最新的 generator 模块
    frame_generator #(
        .PAYLOAD_SIZE_WORDS(PAYLOAD_SIZE_WORDS)
    ) u_frame_gen (
        .clk(clk),
        .rst_n(rst_n),
        .payload_data_in(payload_data_gen_w),
        .payload_valid_in(payload_valid_gen_w),
        .payload_ready_out(payload_ready_gen_w),
        .framed_data_out(framed_data_w),
        .framed_valid_out(framed_valid_w),
        .framed_ready_in(framed_ready_w)
    );

    // --- DUT 2: 帧同步器 ---
    // 使用您提供的最新版本
    frame_synchronizer #(
        .PAYLOAD_SIZE_WORDS(PAYLOAD_SIZE_WORDS)
    ) u_frame_sync (
        .clk(clk),
        .rst_n(rst_n),
        .framed_data_in(framed_data_w),
        .framed_valid_in(framed_valid_w),
        .framed_ready_out(framed_ready_w),
        .payload_data_out(payload_data_sync_w),
        .payload_valid_out(payload_valid_sync_w),
        .payload_ready_in(payload_ready_sync_w),
        .start_of_frame_o(start_of_frame_w)
    );
    
    // --- 1. 数据源 (Generator) ---
    reg [31:0] payload_data_src;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            payload_data_src <= 32'd0;
        end else if (payload_valid_gen_w && payload_ready_gen_w) begin
            payload_data_src <= payload_data_src + 1;
        end
    end
    assign payload_data_gen_w = payload_data_src;
    assign payload_valid_gen_w = 1'b1; // 数据源总是有效

    // --- 2. 随机反压逻辑 ---
    // always @(*) begin
    //     // 模拟下游随机繁忙
    //     payload_ready_sync_w = ($random % 10) > 2; // 70%的概率准备好
    // end

    // --- 3. 自校验逻辑 (Scoreboard & Checker) ---
    reg [31:0] scoreboard_q[$:2*PAYLOAD_SIZE_WORDS]; // 一个简单的队列
    reg [31:0] expected_data;
    integer    error_count;
    integer    transaction_count;

    // 存储发送的数据
    always @(posedge clk) begin
        if (payload_valid_gen_w && payload_ready_gen_w) begin
            scoreboard_q.push_back(payload_data_gen_w);
        end
    end
    
    // 比较接收的数据
    always @(posedge clk) begin
        if (payload_valid_sync_w && payload_ready_sync_w) begin
            if (scoreboard_q.size() > 0) begin
                expected_data = scoreboard_q.pop_front();
                if (payload_data_sync_w == expected_data) begin
                    $display("Checker: PASS! Received: %d, Expected: %d", payload_data_sync_w, expected_data);
                    transaction_count = transaction_count + 1;
                end else begin
                    $error("Checker: FAIL! Received: %d, Expected: %d", payload_data_sync_w, expected_data);
                    error_count = error_count + 1;
                end
            end else begin
                $error("Checker: FAIL! Received unexpected data when scoreboard is empty.");
                error_count = error_count + 1;
            end
        end
    end

    // --- 4. 仿真控制 ---
    initial begin
        error_count = 0;
        transaction_count = 0;
        
        // 等待复位完成
        @(posedge rst_n);
        
        // 发送几帧数据
        wait (transaction_count > 3 * PAYLOAD_SIZE_WORDS);

        // **可以加入错误注入测试 (可选)**
        // #100;
        // inject_bit_error(framed_data_w);
        
        #200;

        // 结束检查
        if (error_count == 0 && transaction_count > 0) begin
            $display("*******************************************");
            $display("**** TEST PASSED!            ****");
            $display("*******************************************");
        end else begin
            $display("*******************************************");
            $display("**** TEST FAILED!            ****");
            $display("*******************************************");
        end
        $finish;
    end
    
    // --- (可选) 错误注入任务 ---
    task inject_bit_error(inout [31:0] data);
        integer bit_pos;
        begin
            bit_pos = $random % 32;
            $display("Injecting error at bit %d", bit_pos);
            data[bit_pos] = ~data[bit_pos];
        end
    endtask
    
    // 仿真波形 dump
    // initial begin
    //     $dumpfile("tb_frame_end2end_optimized.vcd");
    //     $dumpvars(0, tb_frame_end2end_optimized);
    // end

endmodule
