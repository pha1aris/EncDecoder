`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: tb_frame_end2end (已修复 - 匹配无Header版本)
//
// Description:
//   端到端测试平台 (修复版)。
//   - ★ 修正1: 帧参数匹配 "无Header" 的 generator (ASM + Payload)
//   - ★ 修正2: TB_FRAME_LEN_BYTE = 24 (ASM) + 16 (Payload) = 40 字节
//   - ★ 修正3: asm_pattern 匹配 generator 的 SYNC_MARKER
//   - ★ 修正4: 启用了 Scoreboard 自校验和仿真控制
//   - ★ 修正5 (Gemini): 修复了 asm_pattern 字节序颠倒的问题
//
//////////////////////////////////////////////////////////////////////////////////
module tb_frame_end2end;

    // =================================================================
    // ★ 修复 1: 从 generator 计算帧参数 (匹配无Header版)
    // =================================================================
    localparam GEN_PAYLOAD_WORDS    = 4;  // 必须匹配 frame_generator.v
    localparam GEN_ASM_REPS         = 3;  // 必须匹配 frame_generator.v
    localparam GEN_ASM_BYTES        = 8 * GEN_ASM_REPS; // (64'h / 8 bits) * 3 = 24 字节
    localparam GEN_HEADER_BYTES     = 0;  // ★★★ 移除了 Header ★★★
    localparam GEN_PAYLOAD_BYTES    = GEN_PAYLOAD_WORDS * 4; // 4 * 4 = 16 字节
    // ★ 修复 2: 计算传递给 synchronizer 的总帧长
    localparam TB_FRAME_LEN_BYTE    = GEN_ASM_BYTES + GEN_HEADER_BYTES + GEN_PAYLOAD_BYTES; // 24 + 0 + 16 = 40 字节

    // =================================================================
    // ★ 修复 3: 同步器参数 (必须与我们的最终版本匹配)
    // =================================================================
    localparam TB_ASM_LEN           = 192; // 3 * 64-bit = 192 bits
    localparam TB_M_VERIFY          = 2;
    localparam TB_N_PROTECT         = 2;
    localparam TB_PIPELINE_LATENCY  = 9; // (使用 TB 中设置的 9)
    // ★ 修复 3: 定义 Generator 的 SYNC_MARKER
    // localparam [63:0] TB_SYNC_MARKER = 64'hB1699558_A53333A8;
    localparam [63:0] TB_SYNC_MARKER = 64'hA53333A8_B1699558;
    // ★ 修复 5: 定义 HI/LO 字用于重组
    localparam [31:0] TB_MARKER_HI   = TB_SYNC_MARKER[31:0]; // 32'hB1699558
    localparam [31:0] TB_MARKER_LO   = TB_SYNC_MARKER[63:32];  // 32'hA53333A8


    // --- 时钟与复位 ---
    reg clk;
    reg rst_n; // ★ 模块使用 rst_n

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst_n = 0; // ★
        #20;
        rst_n = 1; // ★
    end

    // --- 模块间连线 ---
    wire [31:0] payload_data_gen_w;
    wire        payload_valid_gen_w;
    wire        payload_ready_gen_w;

    wire [31:0] framed_data_w;
    wire        framed_valid_w;
    reg         framed_ready_w; // ★ 更改为 reg 以便进行反压
    
    wire [31:0] payload_data_sync_w;
    wire        payload_valid_sync_w;
    wire        payload_ready_sync_w;
    assign      payload_ready_sync_w = 1; // 接收器总是准备好
    wire        start_of_frame_w; // ★ 匹配 sof 端口

    wire [7:0]  txctrl2_out;
    wire [3:0]  charisk;
    assign charisk = txctrl2_out[3:0];

    // --- DUT 1: 帧生成器 ---
    // (注意: 这里的 frame_generator 必须是 *无Header* 的版本)
    frame_generator #(
        .SYNC_MARKER            (TB_SYNC_MARKER), // ★ 传递 SYNC_MARKER A53333A8_B1699558
        .SYNC_REPETITION        (GEN_ASM_REPS),
        .PAYLOAD_SIZE_WORDS     (GEN_PAYLOAD_WORDS) 
    ) u_frame_gen (
        .clk                    (clk),
        .rst_n                  (rst_n), // 
        .payload_data_in        (payload_data_gen_w),
        .payload_valid_in       (payload_valid_gen_w),
        .payload_ready_out      (payload_ready_gen_w),
        .txctrl2_out            (txctrl2_out),
        .framed_data_out        (framed_data_w),
        .framed_valid_out       (framed_valid_w),
        .framed_ready_in        (framed_ready_w) // ★ 连接到反压 reg
    );

    // --- DUT 2: 帧同步器 ---
    // ★ 例化我们已修复的 'frame_synchronizer_top' (即 frame_synchronizer_top_fixed.v)
    frame_synchronizer_top #(
        .PARALLEL           (32),
        .MASK_LEN           (TB_ASM_LEN),
        .ASM_LEN            (TB_ASM_LEN),
        .FRAME_LEN_BYTE     (TB_FRAME_LEN_BYTE), // ★ 修复 2: 传递 40
        .M_VERIFY           (TB_M_VERIFY),
        .N_PROTECT          (TB_N_PROTECT),
        .PIPELINE_LATENCY   (TB_PIPELINE_LATENCY),
        .FRAME_CNT_W        (16)
    ) u_frame_sync (
        .clk                (clk),
        .rst_n              (rst_n), // ★
        .din                (framed_data_w),
        .din_valid          (framed_valid_w),
        .din_charisk        (charisk),
        .asm_pattern        ({TB_MARKER_LO, TB_MARKER_HI, 
                              TB_MARKER_LO, TB_MARKER_HI,  
                              TB_MARKER_LO, TB_MARKER_HI}),   //   B1699558_A53333A8
        .asm_mask           ({TB_ASM_LEN{1'h1}}),   // 精确匹配
        .frame_lock         (frame_lock_w),      // (连接到内部线网)
        .frame_sync_found   (frame_sync_found_w),
        .wnumber_dec        (wnumber_dec_w),
        .flocation          (flocation_w),
        .sof                (start_of_frame_w),         // ★
        .dout               (payload_data_sync_w),
        .dout_valid         (payload_valid_sync_w)
        // .dout_ready(payload_ready_sync_w) // 我们的同步器没有 dout_ready
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

    // --- 2. 随机反压逻辑 (连接到 framed_ready_w) ---
    // (默认关闭, framed_ready_w 初始值为 1'b1)
     initial framed_ready_w = 1'b1;
    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n)
    //         framed_ready_w <= 1'b1;
    //     else
    //         // 模拟下游随机繁忙
    //         framed_ready_w <= ($random % 10) > 2; // 70%的概率准备好
    // end



    // =================================================================
    // ★ 修复 4: 启用自校验和仿真控制
    // =================================================================

    // --- 3. 自校验逻辑 (Scoreboard & Checker) ---
    reg [31:0] scoreboard_q[$:2*GEN_PAYLOAD_WORDS]; // 一个简单的队列
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
        
        // 发送几帧数据 (例如 10 帧)
        wait (transaction_count > (10 * GEN_PAYLOAD_WORDS));

        // **可以加入错误注入测试 (可选)**
        // #100;
        // inject_bit_error(framed_data_w);
        
        #200;

        // 结束检查
        if (error_count == 0 && transaction_count > 0) begin
            $display("*******************************************");
            $display("**** TEST PASSED!      ****");
            $display("*******************************************");
        end else begin
            $display("*******************************************");
            $display("**** TEST FAILED!      ****");
            $display("*******************************************");
        end
        $finish;
    end
    
    // --- (可选) 错误注入任务 ---
    // task inject_bit_error(inout [31:0] data);
    //     integer bit_pos;
    //     begin
    //         bit_pos = $random % 32;
    //         $display("Injecting error at bit %d", bit_pos);
    //         data[bit_pos] = ~data[bit_pos];
    //     end
    // endtask
    
    // 仿真波形 dump
    // initial begin
    //     $dumpfile("tb_frame_end2end.vcd");
    //     $dumpvars(0, tb_frame_end2end);
    // end

    reg [31:0] payload_data;

    always@(posedge clk)begin
        if(payload_valid_sync_w)begin
            $display("payload data %d",payload_data_sync_w);
        end
    end

endmodule

