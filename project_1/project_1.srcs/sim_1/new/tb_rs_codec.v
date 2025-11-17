`timescale 1ns / 1ps

module tb_rs_codec;

    //============================================================
    // 参数：选择测试模式
    // TEST_PRBS = 0 → 计数器模式
    // TEST_PRBS = 1 → PRBS7 模式
    //============================================================
    localparam TEST_PRBS = 1; 

    //============================================================
    // 时钟 & 复位
    //============================================================
    reg clk;
    reg rst;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;   // 100MHz
    end

    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
    end

    // 对于本仿真，所有模块统一用 clk
    wire core_clk   = clk;
    wire enc_clk    = clk;
    wire output_clk = clk;

    //============================================================
    // DUT 1: RS 编码前端 rs_encode_frontend
    //============================================================
    wire       fifo_input_rdy;
    wire [7:0] data_i;
    reg       data_valid_i;

    // RS Encoder AXIS 输出
    wire [7:0] enc_tdata;
    wire       enc_tvalid;
    wire       enc_tlast;
    wire       enc_tready;

    rs_encode_frontend u_rs_enc_frontend (
        .clk                 (core_clk),
        .enc_clk             (enc_clk),
        .rst                 (rst),

        .fifo_input_rdy      (fifo_input_rdy),
        .data_i              (data_i),
        .data_valid_i        (fifo_input_rdy),

        .m_axis_output_tready(enc_tready),
        .m_axis_output_tdata (enc_tdata),
        .m_axis_output_tvalid(enc_tvalid),
        .m_axis_output_tlast (enc_tlast)
    );

    //============================================================
    // DUT 2: RS 解码后端 rs_decode_backend
    //============================================================
    wire [31:0] dec32_tdata;
    wire        dec32_tvalid;
    wire        dec32_tready;

    assign dec32_tready = 1'b1;   // 下游一直 ready（我们主要看 8bit 字节）

    rs_decode_backend u_rs_dec_backend (
        .rst                 (rst),
        .core_clk            (core_clk),
        .output_clk          (output_clk),

        // 来自编码器的 8bit AXIS
        .s_axis_input_tdata  (enc_tdata),
        .s_axis_input_tvalid (enc_tvalid),
        .s_axis_input_tlast  (enc_tlast),
        .s_axis_input_tready (enc_tready),

        // 输出 32bit AXIS （本仿真不重点用）
        .output_tdata        (dec32_tdata),
        .output_tvalid       (dec32_tvalid),
        .output_tready       (dec32_tready)
    );

    //============================================================
    // 上游激励：计数器 / PRBS7
    //============================================================
    wire use_prbs = (TEST_PRBS != 0);

    // 计数器源
    reg [7:0] counter;

    // PRBS7 源（8bit）
    wire [7:0] prbs_data;

    // data_i 选择：计数器 or PRBS
    assign data_i       = use_prbs ? prbs_data : counter;
    // data_valid_i：简单处理，只要 FIFO ready 就认为上游有数据
    // assign data_valid_i = fifo_input_rdy;

    // 计数器模式：每写入一个字节（FIFO ready 时）自增
    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            counter <= 8'd0;
        end else if (!use_prbs && fifo_input_rdy) begin
            data_valid_i <= 1'b1;
            if(counter == 'd255)
                counter <= 'd1;
            else 
                counter <= counter + 1'b1;
        end else 
            data_valid_i <= 1'b0;
    end

    // PRBS7 发生器：POLY_LENGHT=7, POLY_TAP=6, NBITS=8
    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),   // 发生器
        .INV_PATTERN (0),   // 非倒置 PRBS7
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_gen (
        .RST      (rst),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (use_prbs && fifo_input_rdy),  // 每次真正送入编码器一个字节时步进
        .DATA_OUT (prbs_data)
    );

    //============================================================
    // 从 rs_decode_backend 内部偷看 8bit 解码结果（层次引用）
    // 注意：Dec_output_tdata / Dec_output_valid 是你模块内部的信号名
    //============================================================
    wire [7:0] dec_byte;
    wire       dec_valid;

    assign dec_byte  = u_rs_dec_backend.Dec_output_tdata;
    assign dec_valid = u_rs_dec_backend.Dec_output_valid;

    //============================================================
    // 检查逻辑 1：计数器模式
    //============================================================
    integer err_cnt_counter;
    reg [7:0] expected_byte;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            err_cnt_counter <= 0;
            expected_byte   <= 8'd0;
        end else if (!use_prbs && dec_valid) begin
            // 计数器模式下，期望解码出来的是 0,1,2,3,...
            if (dec_byte !== expected_byte) begin
                err_cnt_counter <= err_cnt_counter + 1;
                $display("[%0t ns] COUNTER MISMATCH: expect=%0d, got=%0d, total_err=%0d",
                         $time, expected_byte, dec_byte, err_cnt_counter);
            end
            expected_byte <= expected_byte + 1'b1;
        end
    end

    //============================================================
    // 检查逻辑 2：PRBS7 模式
    //============================================================
    wire [7:0] prbs_err_vec;
    wire       prbs_match;
    integer    err_cnt_prbs;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),   // 检测器
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_chk (
        .RST      (rst),
        .CLK      (core_clk),
        .DATA_IN  (dec_byte),                    // 解码后的字节
        .EN       (use_prbs && dec_valid),       // 有效解码数据时才检查
        .DATA_OUT (prbs_err_vec)
    );

    assign prbs_match = ~|prbs_err_vec;

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            err_cnt_prbs <= 0;
        end else if (use_prbs && dec_valid) begin
            if (!prbs_match) begin
                err_cnt_prbs <= err_cnt_prbs + 1;
                $display("[%0t ns] PRBS ERROR: data=%02x, err_vec=%02x, total_err=%0d",
                         $time, dec_byte, prbs_err_vec, err_cnt_prbs);
            end
        end
    end

    //============================================================
    // 仿真结束条件 & 波形
    // //============================================================
    // initial begin
    //     $dumpfile("tb_rs_codec.vcd");
    //     $dumpvars(0, tb_rs_codec);

    //     // 跑一段时间
    //     #200000;

    //     $display("==========================================");
    //     $display("TEST_PRBS = %0d", TEST_PRBS);
    //     $display("Counter mode error count = %0d", err_cnt_counter);
    //     $display("PRBS7    mode error count = %0d", err_cnt_prbs);
    //     $display("==========================================");

    //     $finish;
    // end

endmodule
