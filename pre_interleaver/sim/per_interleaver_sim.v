`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2025/09/19 15:11:31
// Design Name:
// Module Name: interleaver_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: 仿真 pre_interleaver + de_interleaver
//              输入伪随机数据 -> 交织 -> 解交织 -> 输出
//              检查输入输出是否一致
//////////////////////////////////////////////////////////////////////////////////

module per_interleaver_sim();

    // ================= 参数定义 =================
    parameter CORE_CLK_PERIOD = 10.0;
    parameter CODEWORD_SIZE_IN_32 = 65;
    parameter NUM_CODEWORDS = 4;
    localparam BLOCK_SIZE = CODEWORD_SIZE_IN_32 * NUM_CODEWORDS; // 260
    localparam NUM_BLOCKS_TO_TEST = 2; // 测试3个数据块，以验证乒乓操作
    localparam TOTAL_WORDS = BLOCK_SIZE * NUM_BLOCKS_TO_TEST; // 780

    // ================= 时钟与复位 =================
    reg core_clk;
    reg rst;

    initial begin
        core_clk = 0;
    end

    // 复位序列
    initial begin
        rst = 1;
        #(CORE_CLK_PERIOD * 4);
        rst = 0;
    end

    // 时钟生成
    always #(CORE_CLK_PERIOD/2) core_clk = ~core_clk;

    // ================= DUT 端口信号 =================
    // pre_interleaver 输入
    wire  [31:0] src_tdata;
    reg         src_tvalid;
    wire        src_tready;

    // pre_interleaver <-> de_interleaver 连接
    wire [31:0] intv_tdata;
    wire        intv_tvalid;
    wire        intv_tready;

    // de_interleaver 输出
    wire [31:0] final_tdata;
    wire        final_tvalid;
    reg         final_tready; // 由TB的Checker控制

    // ================= 输入数据流生成 =================
    // integer sent_count = 0;
    // assign src_tdata = sent_count;
    // initial begin
    //     src_tvalid = 0;
    //     // src_tdata  = 0;
    //     wait (rst == 0); // 等待复位结束
    //     #50;

    //     while (sent_count < TOTAL_WORDS) begin
    //         @(posedge core_clk);
    //         src_tvalid <= 1;
    //         // src_tdata  <= sent_count; // 用递增数据方便检查
    //         if (src_tvalid && src_tready) begin
    //             sent_count <= sent_count + 1;
    //         end
    //     end

    //     @(posedge core_clk);
    //     src_tvalid <= 0;
    // end

    reg [31:0] send_cnt;
    reg cnt_valid;
    // wire [31:0] prbs_data;

    always @(posedge core_clk or posedge rst) begin
        if(rst) begin
            send_cnt <= 0;
            cnt_valid <= 0;
        end else if(src_tready)begin
            cnt_valid <= 1;
            if(send_cnt == CODEWORD_SIZE_IN_32 - 1)begin
                send_cnt <= 'd1;
            end else begin
                send_cnt <= send_cnt + 1;
            end
        end else begin
            cnt_valid <= 0;
        end
    end

    // ================= 随机反压模拟 =================
    initial begin
        final_tready = 1;
        wait (rst == 0); // 等待复位结束
        forever begin
            // 可以在这里模拟随机 backpressure
            #(CORE_CLK_PERIOD * ($random % 20 + 5)); // 随机间隔
            final_tready <= 0;
            #(CORE_CLK_PERIOD * ($random % 10 + 1)); // 随机拉低时长
            final_tready <= 1;
        end
    end

    // gtwizard_ultrascale_0_prbs_any #(
    //     .CHK_MODE               (0),
    //     .INV_PATTERN            (1),
    //     .POLY_LENGHT            (31),
    //     .POLY_TAP               (28),
    //     .NBITS                  (32)
    // ) prbs_any_gen_inst (
    //     .RST                    (rst),
    //     .CLK                    (core_clk),
    //     .DATA_IN                ('d0),
    //     .EN                     (src_tready && src_tvalid),
    //     .DATA_OUT               (prbs_data)
    // );

    // ================= DUT 实例化 =================
    // pre_interleaver #(
    //     .CODEWORD_SIZE_IN_32(CODEWORD_SIZE_IN_32),
    //     .NUM_CODEWORDS      (NUM_CODEWORDS)
    // ) u_pre_interleaver (
    //     .clk                (core_clk),
    //     .rst                (rst),
    //     .s_axis_tdata       (send_cnt),
    //     .s_axis_tvalid      (cnt_valid),
    //     .s_axis_tready      (src_tready),
    //     .m_axis_tdata       (intv_tdata),
    //     .m_axis_tvalid      (intv_tvalid),
    //     .m_axis_tready      (intv_tready) // 连接到下游的ready信号
    // );

wire [31:0] intv_v1_tdata;
wire intv_v1_tvalid;
wire intv_v1_tready;
wire deintv_tready;

    pre_interleaver_v1 #(
        .CODEWORD_SIZE_IN_32         (65),
        .NUM_CODEWORDS         (4)  // 每个RAM深度 = 2^6 = 64   
    )pre_interleaver_v1(
        .clk                (core_clk),
        .rst                (rst),
        .s_axis_tdata       (send_cnt),
        .s_axis_tvalid      (cnt_valid),
        .s_axis_tready      (src_tready),
        .m_axis_tdata       (intv_v1_tdata),
        .m_axis_tvalid      (intv_v1_tvalid),
        .m_axis_tready      (deintv_tready) // 连接到下游的ready信号
    );

wire [31:0]deintv_tdata;
wire       deintv_tvalid;
 de_interleaver_v1#(
        .CODEWORD_SIZE_IN_32         (65),
        .NUM_CODEWORDS         (4)  // 每个RAM深度 = 2^6 = 64  
)de_interleaver_v1(
        .clk                (core_clk),
        .rst                (rst),
        .s_axis_tdata       (intv_v1_tdata),
        .s_axis_tvalid      (intv_v1_tvalid),
        .s_axis_tready      (deintv_tready),
        .m_axis_tdata       (deintv_tdata),
        .m_axis_tvalid      (deintv_tvalid),
        .m_axis_tready      (1) // 连接到下游的ready信号
);
    // pre_interleaver_v1 #(
    //     .CODEWORD_SIZE_IN_32         (65),
    //     .NUM_CODEWORDS         (4)  // 每个RAM深度 = 2^6 = 64   
    // )de_interleaver_v1(
    //     .clk                (core_clk),
    //     .rst                (rst),
    //     .s_axis_tdata       (intv_v1_tdata),
    //     .s_axis_tvalid      (intv_v1_tvalid),
    //     .s_axis_tready      (deintv_tready),
    //     .m_axis_tdata       (deintv_tdata),
    //     .m_axis_tvalid      (deintv_tvalid),
    //     .m_axis_tready      (1) // 连接到下游的ready信号
    // );

    // de_interleaver #(
    //     .CODEWORD_SIZE_IN_32 (CODEWORD_SIZE_IN_32),
    //     .NUM_CODEWORDS       (NUM_CODEWORDS)
    // ) u_de_interleaver (
    //     .clk                (core_clk),
    //     .rst                (rst),
    //     .s_axis_tdata       (intv_tdata),
    //     .s_axis_tvalid      (intv_tvalid),
    //     .s_axis_tready      (intv_tready),
    //     .m_axis_tdata       (final_tdata),
    //     .m_axis_tvalid      (final_tvalid),
    //     .m_axis_tready      (1)
    // );

    // wire [31:0] prbs_error_to_gth;
    // gtwizard_ultrascale_0_prbs_any #(
    //     .CHK_MODE       (1),
    //     .INV_PATTERN    (1),
    //     .POLY_LENGHT    (31),
    //     .POLY_TAP       (28),
    //     .NBITS          (32)
    // ) prbs_checker_inst1 (
    //     .RST            (rst),
    //     .CLK            (core_clk), // 假设 tx_clk 与 rd_clk 同步用于此测试
    //     .DATA_IN        (final_tdata),
    //     .EN             (final_tvalid),
    //     .DATA_OUT       (prbs_error_to_gth)
    // );

    // wire prbs_match;
    // assign prbs_match = ~|prbs_error_to_gth;
    // ================= Checker: 比对输入/输出 =================
    integer received_count = 0;
    reg [31:0] sent_data_mem[0:TOTAL_WORDS-1];
    integer push_ptr = 0;
    integer pop_ptr = 0;

    // 记录发送的数据
    always @(posedge core_clk) begin
        if (src_tvalid && src_tready) begin
            if (push_ptr < TOTAL_WORDS) begin
                sent_data_mem[push_ptr] = src_tdata;
                push_ptr = push_ptr + 1;
            end
        end
    end

            reg [31:0] expected_data;
    // 检查接收的数据
    always @(posedge core_clk) begin
        if (!rst && final_tvalid && final_tready) begin
            if (pop_ptr >= push_ptr) begin // 检查FIFO是否为空
                $display("[%0t] ERROR: Checker received data, but FIFO model is empty!", $time);
                // $stop;
            end

            expected_data = sent_data_mem[pop_ptr];
            
            if (final_tdata !== expected_data) begin
                $display("[%0t] ERROR: Data mismatch!", $time);
                $display("    Expected: %0d", expected_data);
                $display("    Received: %0d", final_tdata);
                // $stop;
            end else begin
                // $display("[%0t] INFO: Correctly received data %0d", $time, final_tdata);
            end
            pop_ptr = pop_ptr + 1;
            received_count <= received_count + 1;
        end
    end

    // ================= 仿真结束条件 =================
    // initial begin
    //     wait (received_count == TOTAL_WORDS);
    //     #(CORE_CLK_PERIOD * 10);
    //     $display("==========================================================");
    //     $display("SUCCESS: Simulation finished without errors.");
    //     $display("Total words sent and verified: %0d", received_count);
    //     $display("==========================================================");
    //     // $finish;
    // end

    // initial begin
    //     #(CORE_CLK_PERIOD * 50000); // 最大仿真时间
    //     $display("==========================================================");
    //     $display("ERROR: Simulation timed out!");
    //     $display("Words sent: %0d, Words received: %0d", sent_count, received_count);
    //     $display("==========================================================");
    //     // $stop;
    // end

endmodule

