`timescale 1ns/1ps

module tb_rs_codec;

    //============================================================
    // 参数
    //============================================================
    localparam integer RS_K            = 229;     // 信息字节数
    localparam integer MODE_RST_CYCLES = 20;      // sel 切换后的自动复位周期数

    // CNT 同步字：建议都选 payload 不会出现的值（payload=0..224 => 0x00..0xE0）
    localparam [7:0]   SYNC0           = 8'hEE;
    localparam [7:0]   SYNC1           = 8'hE1;   // ★从 5A 改为 E1：避免 payload/cw_id 里误触发概率

    // CNT 格式（总长=RS_K=229）：
    // [0]=SYNC0 [1]=SYNC1 [2]=cw_id[7:0] [3]=cw_id[15:8] [4..228]=payload_idx(0..224)

    //============================================================
    // 时钟 & 复位
    //============================================================
    reg clk;
    reg rst; // 异步高有效

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;   // 100MHz
    end

    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
    end

    wire core_clk   = clk;
    wire enc_clk    = clk;
    wire output_clk = clk;

    //============================================================
    // 手动模式选择：sel=1 PRBS，sel=0 CNT
    //============================================================
    reg sel = 1'b1; // 默认 PRBS（你可以在仿真时手动改成 0）

    //============================================================
    // sel 切换自动打一段复位（避免残留流水造成误判）
    //============================================================
    reg sel_d;
    reg [$clog2(MODE_RST_CYCLES+1)-1:0] mode_rst_cnt;
    wire mode_sw = (sel ^ sel_d);

    always @(posedge core_clk or posedge rst) begin
        if (rst) begin
            sel_d        <= 1'b0;
            mode_rst_cnt <= 'd0;
        end else begin
            sel_d <= sel;
            if (mode_sw) begin
                mode_rst_cnt <= MODE_RST_CYCLES[$clog2(MODE_RST_CYCLES+1)-1:0];
            end else if (mode_rst_cnt != 0) begin
                mode_rst_cnt <= mode_rst_cnt - 1'b1;
            end
        end
    end

    wire mode_rst = (mode_rst_cnt != 0);
    wire rst_all  = rst | mode_rst;

    //============================================================
    // DUT1: RS 编码前端
    //============================================================
    wire       fifo_input_rdy;
    wire [7:0] data_i;
    wire       data_valid_i;

    wire [7:0] enc_tdata;
    wire       enc_tvalid;
    wire       enc_tlast;
    wire       enc_tready;

    rs_encode_frontend #(
        .RS_K (RS_K)
    ) u_rs_enc_frontend (
        .clk                  (core_clk),
        .enc_clk              (enc_clk),
        .rst                  (rst_all),

        .fifo_input_rdy       (fifo_input_rdy),
        .data_i               (data_i),
        .data_valid_i         (data_valid_i),

        .m_axis_output_tready (enc_tready),
        .m_axis_output_tdata  (enc_tdata),
        .m_axis_output_tvalid (enc_tvalid),
        .m_axis_output_tlast  (enc_tlast)
    );

    //============================================================
    // DUT2: RS 解码后端（输出 8bit）
    //============================================================
    wire [7:0]  dec_byte;
    wire        dec_valid;
    wire        dec_ready;

    assign dec_ready = 1'b1;

    rs_decode_backend #(
        .RS_N(255)
    ) u_rs_dec_backend (
        .rst                 (rst_all),
        .core_clk            (core_clk),
        .output_clk          (output_clk),

        .s_axis_input_tdata  (enc_tdata),
        .s_axis_input_tvalid (enc_tvalid),
        .s_axis_input_tlast  (enc_tlast),
        .s_axis_input_tready (enc_tready),

        .output_tdata        (dec_byte),
        .output_tvalid       (dec_valid),
        .output_tready       (dec_ready)
    );

    //============================================================
    // 源：PRBS7 / CNT
    //============================================================
    wire use_prbs = sel;
    wire use_cnt  = ~sel;

    assign data_valid_i = 1'b1;
    wire src_fire = fifo_input_rdy & data_valid_i & ~rst_all; // 真正写进 encoder frontend FIFO 的字节

    // ---------------- CNT：插入同步头 + cw_id + payload_idx ----------------
    reg [15:0] tx_cw_id;
    reg [7:0]  tx_pos_in_k; // 0..RS_K-1

    always @(posedge core_clk or posedge rst_all) begin
        if (rst_all) begin
            tx_cw_id     <= 16'd0;
            tx_pos_in_k  <= 8'd0;
        end else if (use_cnt && src_fire) begin
            if (tx_pos_in_k == (RS_K-1)) begin
                tx_pos_in_k <= 8'd0;
                tx_cw_id    <= tx_cw_id + 1'b1;
            end else begin
                tx_pos_in_k <= tx_pos_in_k + 1'b1;
            end
        end
    end

    function [7:0] cnt_fmt_byte;
        input [15:0] cw;
        input [7:0]  pos;
        begin
            case (pos)
                8'd0: cnt_fmt_byte = SYNC0;
                8'd1: cnt_fmt_byte = SYNC1;
                8'd2: cnt_fmt_byte = cw[7:0];
                8'd3: cnt_fmt_byte = cw[15:8];
                default: cnt_fmt_byte = (pos - 8'd4); // 0..224
            endcase
        end
    endfunction

    wire [7:0] cnt_byte = cnt_fmt_byte(tx_cw_id, tx_pos_in_k);

    // ---------------- PRBS7 ----------------
    wire [7:0] prbs_byte;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (0),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_gen (
        .RST      (rst_all),
        .CLK      (core_clk),
        .DATA_IN  (8'd0),
        .EN       (use_prbs && src_fire),
        .DATA_OUT (prbs_byte)
    );

    assign data_i = use_prbs ? prbs_byte : cnt_byte;

    //============================================================
    // PRBS checker（打印 total_err 修正：显示新值）
    //============================================================
    integer err_cnt_prbs;
    wire [7:0] prbs_err_vec;
    wire       prbs_match = ~|prbs_err_vec;

    gtwizard_ultrascale_0_prbs_any #(
        .CHK_MODE    (1),
        .INV_PATTERN (0),
        .POLY_LENGHT (7),
        .POLY_TAP    (6),
        .NBITS       (8)
    ) u_prbs7_chk (
        .RST      (rst_all),
        .CLK      (core_clk),
        .DATA_IN  (dec_byte),
        .EN       (use_prbs && dec_valid),
        .DATA_OUT (prbs_err_vec)
    );

    always @(posedge core_clk or posedge rst_all) begin
        if (rst_all) begin
            err_cnt_prbs <= 0;
        end else if (use_prbs && dec_valid) begin
            if (!prbs_match) begin
                // ★display 打印 +1，避免你看到 total_err=0 的误导
                $display("[%0t ns] PRBS ERROR: data=%02x err_vec=%02x total_err=%0d  (建议切 sel=0 进 CNT 定位)",
                         $time, dec_byte, prbs_err_vec, err_cnt_prbs + 1);
                err_cnt_prbs <= err_cnt_prbs + 1;
            end
        end
    end

    //============================================================
    // CNT checker：带“重同步”的解析器 + cw_id 连续性检查
    //============================================================
    integer err_cnt_cnt;

    localparam [2:0] S_SEARCH0 = 3'd0;
    localparam [2:0] S_SEARCH1 = 3'd1;
    localparam [2:0] S_ID_L    = 3'd2;
    localparam [2:0] S_ID_H    = 3'd3;
    localparam [2:0] S_PAYLOAD = 3'd4;

    reg [2:0]  st;
    reg [15:0] rx_cw_id;        // 当前解析到的 cw_id
    reg [15:0] exp_cw_id;       // 期望 cw_id（用于连续性检查）
    reg [7:0]  payload_idx;     // 0..224

    localparam [7:0] PAYLOAD_LAST = (RS_K-5); // 224

    reg [15:0] cw_tmp;
    always @(posedge core_clk or posedge rst_all) begin
        if (rst_all) begin
            err_cnt_cnt <= 0;
            st          <= S_SEARCH0;
            rx_cw_id     <= 16'd0;
            exp_cw_id    <= 16'd0;
            payload_idx  <= 8'd0;
        end else if (use_cnt && dec_valid) begin
            case (st)
                S_SEARCH0: begin
                    if (dec_byte == SYNC0) st <= S_SEARCH1;
                end

                S_SEARCH1: begin
                    if (dec_byte == SYNC1) st <= S_ID_L;
                    else if (dec_byte == SYNC0) st <= S_SEARCH1; // 连续 SYNC0，继续等
                    else st <= S_SEARCH0;
                end

                S_ID_L: begin
                    rx_cw_id[7:0] <= dec_byte;
                    st <= S_ID_H;
                end

                S_ID_H: begin
                    // ★这里 rx_cw_id[7:0] 已在上一拍采到；本拍 dec_byte 是高字节
                    //    组装 cw_tmp 来做连续性检查（避免 NBA 时序问题）
                    cw_tmp = {dec_byte, rx_cw_id[7:0]};

                    rx_cw_id[15:8] <= dec_byte;

                    // cw_id 连续性检查（第一次锁上后应当 0,1,2...）
                    if (cw_tmp !== exp_cw_id) begin
                        $display("[%0t ns] CNT CW_ID JUMP: expect=%0d got=%0d (forcing resync)",
                                 $time, exp_cw_id, cw_tmp);
                        // 发生 cw_id 跳变：大概率错位/丢插 -> 直接回去找同步
                        st <= S_SEARCH0;
                        // 重新以当前 cw_tmp 为基准（便于后续继续观察）
                        exp_cw_id <= cw_tmp + 1'b1;
                    end else begin
                        exp_cw_id   <= exp_cw_id + 1'b1;
                        payload_idx <= 8'd0;
                        st <= S_PAYLOAD;
                    end
                end

                S_PAYLOAD: begin
                    if (dec_byte !== payload_idx) begin
                        $display("[%0t ns] CNT MISMATCH: cw_id=%0d payload_idx=%0d expect=%0d got=%0d total_err=%0d",
                                 $time, rx_cw_id, payload_idx, payload_idx, dec_byte, err_cnt_cnt + 1);
                        err_cnt_cnt <= err_cnt_cnt + 1;

                        // 一旦 payload 错位，立刻重新抓同步边界
                        st <= S_SEARCH0;
                    end else begin
                        if (payload_idx == PAYLOAD_LAST) begin
                            // 一个 RS_K 信息块结束，下一字节应回到 SYNC0
                            st <= S_SEARCH0;
                        end else begin
                            payload_idx <= payload_idx + 1'b1;
                        end
                    end
                end

                default: st <= S_SEARCH0;
            endcase
        end
    end

    //============================================================
    // Dump TX bytes to CSV
    //============================================================
    integer ftx;
    reg [63:0] tx_seq;

    initial begin
        ftx = $fopen("tx_dump.csv", "w");
        $fwrite(ftx, "time_ns,sel,tx_seq,data_hex\n");
        tx_seq = 0;
    end

    always @(posedge core_clk or posedge rst_all) begin
        if (rst_all) begin
            tx_seq <= 0;
        end else if (src_fire) begin
            $fwrite(ftx, "%0t,%0d,%0d,%02x\n", $time, sel, tx_seq, data_i);
            tx_seq <= tx_seq + 1;
            if (tx_seq[9:0] == 10'h3FF) $fflush(ftx);
        end
    end

    //============================================================
    // Dump decoded bytes to CSV
    //============================================================
    integer fdec;
    reg [63:0] dec_seq;

    initial begin
        fdec = $fopen("dec_dump.csv", "w");
        $fwrite(fdec, "time_ns,sel,dec_seq,data_hex\n");
        dec_seq = 0;
    end

    always @(posedge core_clk or posedge rst_all) begin
        if (rst_all) begin
            dec_seq <= 0;
        end else if (dec_valid && ~rst_all) begin
            $fwrite(fdec, "%0t,%0d,%0d,%02x\n", $time, sel, dec_seq, dec_byte);
            dec_seq <= dec_seq + 1;
            if (dec_seq[9:0] == 10'h3FF) $fflush(fdec);
        end
    end

    //============================================================
    // 可选：仿真结束（避免文件不落盘）
    //============================================================
    initial begin
        // 你可以按需调大/调小
        #200_000_000; // 200ms 仿真时间（按 100MHz）
        $fflush(ftx);
        $fflush(fdec);
        $fclose(ftx);
        $fclose(fdec);
        $display("SIM DONE. prbs_err=%0d cnt_err=%0d", err_cnt_prbs, err_cnt_cnt);
        $finish;
    end

endmodule
