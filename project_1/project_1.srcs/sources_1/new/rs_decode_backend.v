`timescale 1ns/1ps

module rs_decode_backend #(
    parameter integer RS_N           = 255,
    parameter integer OUT_FIFO_DEPTH = 1024,   // decoder 输出 FIFO 深度
    parameter integer ORDER_DEPTH    = 32      // order token FIFO 深度
)(
    input  wire        rst,
    input  wire        core_clk,
    input  wire        output_clk,   // 目前未用（等于 core_clk 也行）

    // 8-bit AXI Stream Input（来自 encoder）
    input  wire [7:0]  s_axis_input_tdata,
    input  wire        s_axis_input_tvalid,
    input  wire        s_axis_input_tlast,
    output wire        s_axis_input_tready,

    // 8-bit AXI Stream Output（给后级）
    output wire [7:0]  output_tdata,
    output wire        output_tvalid,
    input  wire        output_tready
);

    wire clk = core_clk;
    localparam integer IN_AW = $clog2(RS_N); // 255 -> 8

    // ============================================================
    // 0) 两块输入码字缓冲：每块缓存 1 个 RS_N 字节码字
    // ============================================================
    (* ram_style="distributed" *) reg [7:0] inbuf0_mem [0:RS_N-1];
    (* ram_style="distributed" *) reg [7:0] inbuf1_mem [0:RS_N-1];

    reg [IN_AW:0] inbuf0_cnt, inbuf1_cnt;   // 接收计数 0..RS_N
    reg           inbuf0_full, inbuf1_full; // 仅“好码字”才置 1（等待喂 decoder）

    // 码字接收状态：锁定一个 buffer 直到看到输入 tlast
    reg fill_active;
    reg fill_sel;   // 0->buf0, 1->buf1

    // drop 模式：遇到“长帧”后丢弃直到输入 tlast
    reg drop_active;

    // ============================================================
    // 1) 每路 decoder 的 busy：确保同一时刻最多 1 个码字在飞
    // ============================================================
    reg dec0_busy, dec1_busy;

    // ============================================================
    // 2) order_fifo：记录码字输出顺序（0->路0，1->路1）
    // ============================================================
    wire order_full, order_empty;
    wire order_dout;
    wire order_wr, order_rd;

    // ============================================================
    // 3) 输入 ready：只有当“能选择到一条非 busy 的 buffer”且 order_fifo 不满才 ready
    // ============================================================
    wire buf0_can_take_new = (~inbuf0_full) & (~dec0_busy);
    wire buf1_can_take_new = (~inbuf1_full) & (~dec1_busy);

    wire choose_buf0 = buf0_can_take_new;
    wire choose_buf1 = (~buf0_can_take_new) & buf1_can_take_new;

    wire have_any_buf = (buf0_can_take_new | buf1_can_take_new);

    // fill_active 时必须继续写同一个 buf，因此检查对应 buf 的可写性
    wire sel_can_accept = (fill_sel==1'b0) ? buf0_can_take_new : buf1_can_take_new;

    wire ready_core = fill_active ? sel_can_accept : have_any_buf;

    // drop_active 时：我们要尽快把这一帧吃完直到 tlast，所以 ready=1
    assign s_axis_input_tready = (~rst) & (drop_active ? 1'b1 : ((~order_full) & ready_core));

    wire in_fire      = s_axis_input_tvalid && s_axis_input_tready;
    wire in_last_fire = in_fire && s_axis_input_tlast;

    // 当前写入目标：fill_active 用 fill_sel；否则用 choose_buf0/1 决定
    wire cur_sel = fill_active ? fill_sel : (choose_buf0 ? 1'b0 : 1'b1);

    wire [IN_AW:0] cur_cnt = (cur_sel==1'b0) ? inbuf0_cnt : inbuf1_cnt;

    // “好码字 last”：输入 last 且长度恰好 RS_N（cur_cnt==RS_N-1 表示本拍写第 RS_N 个字节）
    wire good_last_fire = (!drop_active) && in_last_fire && (cur_cnt == (RS_N-1));

    // token 只在“好码字 last”写入
    assign order_wr = good_last_fire;

    rs_backend_fifo #(
        .WIDTH (1),
        .DEPTH (ORDER_DEPTH)
    ) u_order_fifo (
        .clk   (clk),
        .rst   (rst),
        .din   (cur_sel),
        .wr_en (order_wr),
        .full  (order_full),
        .dout  (order_dout),
        .rd_en (order_rd),
        .empty (order_empty)
    );

    // ============================================================
    // ★ FIX(MDRV-1): 用 start_feed0/1 表示“该 buffer 正被提交给 decoder”
    //    用它在“输入收码字 always”里清 inbuf*_full / inbuf*_cnt
    //    这样 inbuf*_cnt/full 只由一个 always 驱动
    // ============================================================
    wire start_feed0 = (inbuf0_full && !dec0_busy); // 等价于 feed0 的启动条件（不必引用 feed0）
    wire start_feed1 = (inbuf1_full && !dec1_busy);

    // ============================================================
    // 4) 输入收码字：严格依赖 s_axis_input_tlast 还原码字边界
    // ============================================================
    reg err_len_short;
    reg err_len_long;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fill_active   <= 1'b0;
            fill_sel      <= 1'b0;

            inbuf0_cnt    <= 'd0;
            inbuf1_cnt    <= 'd0;
            inbuf0_full   <= 1'b0;
            inbuf1_full   <= 1'b0;

            drop_active   <= 1'b0;

            err_len_short <= 1'b0;
            err_len_long  <= 1'b0;
        end else begin
            // ★ FIX(MDRV-1): buffer 被提交给 decoder 的同拍，清 full/计数（只在此 always 写）
            if (start_feed0) begin
                inbuf0_full <= 1'b0;
                inbuf0_cnt  <= 'd0;
            end
            if (start_feed1) begin
                inbuf1_full <= 1'b0;
                inbuf1_cnt  <= 'd0;
            end

            // drop 模式：直到吃到 tlast 才退出
            if (drop_active) begin
                if (in_last_fire) begin
                    drop_active <= 1'b0;
                    fill_active <= 1'b0;
                    // 重置计数（安全）
                    inbuf0_cnt  <= (dec0_busy ? inbuf0_cnt : 'd0);
                    inbuf1_cnt  <= (dec1_busy ? inbuf1_cnt : 'd0);
                end
            end else begin
                // 新码字开始：第一次 in_fire 时锁定 fill_sel
                if (!fill_active && in_fire) begin
                    fill_active <= 1'b1;
                    fill_sel    <= choose_buf0 ? 1'b0 : 1'b1;
                end

                if (in_fire) begin
                    if (cur_sel==1'b0) begin
                        // 写 buf0
                        if (inbuf0_cnt < RS_N) begin
                            inbuf0_mem[inbuf0_cnt[IN_AW-1:0]] <= s_axis_input_tdata;
                            inbuf0_cnt <= inbuf0_cnt + 1'b1;
                        end else begin
                            // 长帧：进入 drop，丢弃直到 tlast
                            err_len_long <= 1'b1;
                            drop_active  <= 1'b1;
                            fill_active  <= 1'b0;
                            inbuf0_cnt   <= 'd0;
                            inbuf0_full  <= 1'b0;
                        end

                        if (s_axis_input_tlast) begin
                            if (cur_cnt != (RS_N-1)) begin
                                // 短帧：丢弃
                                err_len_short <= 1'b1;
                                inbuf0_cnt    <= 'd0;
                                inbuf0_full   <= 1'b0;
                            end else begin
                                // 好码字：置 full（order_wr 同拍写 token）
                                inbuf0_full <= 1'b1;
                            end
                            fill_active <= 1'b0;
                        end
                    end else begin
                        // 写 buf1
                        if (inbuf1_cnt < RS_N) begin
                            inbuf1_mem[inbuf1_cnt[IN_AW-1:0]] <= s_axis_input_tdata;
                            inbuf1_cnt <= inbuf1_cnt + 1'b1;
                        end else begin
                            err_len_long <= 1'b1;
                            drop_active  <= 1'b1;
                            fill_active  <= 1'b0;
                            inbuf1_cnt   <= 'd0;
                            inbuf1_full  <= 1'b0;
                        end

                        if (s_axis_input_tlast) begin
                            if (cur_cnt != (RS_N-1)) begin
                                err_len_short <= 1'b1;
                                inbuf1_cnt    <= 'd0;
                                inbuf1_full   <= 1'b0;
                            end else begin
                                inbuf1_full <= 1'b1;
                            end
                            fill_active <= 1'b0;
                        end
                    end
                end
            end
        end
    end

    // ============================================================
    // 5) 将 inbuf0/inbuf1 喂给各自的 decoder
    //    ★ FIX(MDRV-1): 这里不再写 inbuf*_cnt/full，也不再写 dec*_busy
    // ============================================================
    reg [IN_AW-1:0] rd_ptr0, rd_ptr1;
    reg [IN_AW:0]   rd_cnt0, rd_cnt1;
    reg             feed0, feed1;

    wire [7:0] dec_in_data0 = inbuf0_mem[rd_ptr0];
    wire [7:0] dec_in_data1 = inbuf1_mem[rd_ptr1];

    wire dec_in_last0 = (rd_cnt0 == RS_N-1);
    wire dec_in_last1 = (rd_cnt1 == RS_N-1);

    wire s_axis_input_tready0, s_axis_input_tready1;

    wire dec_in_fire0 = feed0 && s_axis_input_tready0;
    wire dec_in_fire1 = feed1 && s_axis_input_tready1;

    // 启动喂：buffer_full 且 decoder 不 busy 且当前不在 feed
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            feed0 <= 1'b0; feed1 <= 1'b0;
            rd_ptr0 <= 'd0; rd_ptr1 <= 'd0;
            rd_cnt0 <= 'd0; rd_cnt1 <= 'd0;
        end else begin
            // start feed0
            if (!feed0 && inbuf0_full && !dec0_busy) begin
                feed0    <= 1'b1;
                rd_ptr0  <= 'd0;
                rd_cnt0  <= 'd0;
                // ★ 不再在此处清 inbuf0_full/inbuf0_cnt（已移到输入 always）
                // ★ 不再在此处置 dec0_busy（已移到输出仲裁 always）
            end
            // start feed1
            if (!feed1 && inbuf1_full && !dec1_busy) begin
                feed1    <= 1'b1;
                rd_ptr1  <= 'd0;
                rd_cnt1  <= 'd0;
                // ★ 同上
            end

            // feed0 진행
            if (dec_in_fire0) begin
                if (dec_in_last0) begin
                    feed0 <= 1'b0; // 输入喂完（busy 等输出 tlast 被读走再清）
                end else begin
                    rd_ptr0 <= rd_ptr0 + 1'b1;
                    rd_cnt0 <= rd_cnt0 + 1'b1;
                end
            end

            // feed1 진행
            if (dec_in_fire1) begin
                if (dec_in_last1) begin
                    feed1 <= 1'b0;
                end else begin
                    rd_ptr1 <= rd_ptr1 + 1'b1;
                    rd_cnt1 <= rd_cnt1 + 1'b1;
                end
            end
        end
    end

    wire [7:0] s_axis_input_tdata0  = dec_in_data0;
    wire       s_axis_input_tvalid0 = feed0;
    wire       s_axis_input_tlast0  = feed0 && dec_in_last0;

    wire [7:0] s_axis_input_tdata1  = dec_in_data1;
    wire       s_axis_input_tvalid1 = feed1;
    wire       s_axis_input_tlast1  = feed1 && dec_in_last1;

    // ============================================================
    // 6) 两个 RS 解码 IP（严格按你给的端口）
    // ============================================================
    wire [7:0] m_axis_output_tdata0, m_axis_output_tdata1;
    wire       m_axis_output_tvalid0, m_axis_output_tvalid1;
    wire       m_axis_output_tlast0,  m_axis_output_tlast1;

    wire [7:0] m_axis_stat_tdata0, m_axis_stat_tdata1;
    wire       m_axis_stat_tvalid0, m_axis_stat_tvalid1;

    wire event_s_input_tlast_missing0;
    wire event_s_input_tlast_unexpected0;
    wire event_s_ctrl_tdata_invalid0;

    wire event_s_input_tlast_missing1;
    wire event_s_input_tlast_unexpected1;
    wire event_s_ctrl_tdata_invalid1;

    wire decoder_out_ready0, decoder_out_ready1;

    rs_decoder_0 Decoder_U0 (
      .aclk                           (clk),
      .s_axis_input_tdata             (s_axis_input_tdata0),
      .s_axis_input_tvalid            (s_axis_input_tvalid0),
      .s_axis_input_tlast             (s_axis_input_tlast0),
      .s_axis_input_tready            (s_axis_input_tready0),

      .m_axis_output_tdata            (m_axis_output_tdata0),
      .m_axis_output_tvalid           (m_axis_output_tvalid0),
      .m_axis_output_tready           (decoder_out_ready0),
      .m_axis_output_tlast            (m_axis_output_tlast0),

      .m_axis_stat_tdata              (m_axis_stat_tdata0),
      .m_axis_stat_tvalid             (m_axis_stat_tvalid0),
      .m_axis_stat_tready             (1'b1),

      .event_s_input_tlast_missing    (event_s_input_tlast_missing0),
      .event_s_input_tlast_unexpected (event_s_input_tlast_unexpected0),
      .event_s_ctrl_tdata_invalid     (event_s_ctrl_tdata_invalid0)
    );

    rs_decoder_0 Decoder_U1 (
      .aclk                           (clk),
      .s_axis_input_tdata             (s_axis_input_tdata1),
      .s_axis_input_tvalid            (s_axis_input_tvalid1),
      .s_axis_input_tlast             (s_axis_input_tlast1),
      .s_axis_input_tready            (s_axis_input_tready1),

      .m_axis_output_tdata            (m_axis_output_tdata1),
      .m_axis_output_tvalid           (m_axis_output_tvalid1),
      .m_axis_output_tready           (decoder_out_ready1),
      .m_axis_output_tlast            (m_axis_output_tlast1),

      .m_axis_stat_tdata              (m_axis_stat_tdata1),
      .m_axis_stat_tvalid             (m_axis_stat_tvalid1),
      .m_axis_stat_tready             (1'b1),

      .event_s_input_tlast_missing    (event_s_input_tlast_missing1),
      .event_s_input_tlast_unexpected (event_s_input_tlast_unexpected1),
      .event_s_ctrl_tdata_invalid     (event_s_ctrl_tdata_invalid1)
    );

    // ============================================================
    // 7) 两路 decoder 输出各进一个 FWFT FIFO（存 {tlast,data}）
    // ============================================================
    wire [8:0] fifo0_din  = {m_axis_output_tlast0, m_axis_output_tdata0};
    wire       fifo0_wr   = m_axis_output_tvalid0 && decoder_out_ready0;

    wire [8:0] fifo1_din  = {m_axis_output_tlast1, m_axis_output_tdata1};
    wire       fifo1_wr   = m_axis_output_tvalid1 && decoder_out_ready1;

    wire [8:0] fifo0_dout, fifo1_dout;
    wire       fifo0_full, fifo0_empty;
    wire       fifo1_full, fifo1_empty;

    assign decoder_out_ready0 = ~fifo0_full;
    assign decoder_out_ready1 = ~fifo1_full;

    wire fifo0_rd, fifo1_rd;

    rs_backend_fifo #(
        .WIDTH (9),
        .DEPTH (OUT_FIFO_DEPTH)
    ) u_out_fifo0 (
        .clk   (clk),
        .rst   (rst),
        .din   (fifo0_din),
        .wr_en (fifo0_wr),
        .full  (fifo0_full),
        .dout  (fifo0_dout),
        .rd_en (fifo0_rd),
        .empty (fifo0_empty)
    );

    rs_backend_fifo #(
        .WIDTH (9),
        .DEPTH (OUT_FIFO_DEPTH)
    ) u_out_fifo1 (
        .clk   (clk),
        .rst   (rst),
        .din   (fifo1_din),
        .wr_en (fifo1_wr),
        .full  (fifo1_full),
        .dout  (fifo1_dout),
        .rd_en (fifo1_rd),
        .empty (fifo1_empty)
    );

    // ============================================================
    // 8) 输出仲裁：严格按 order_fifo 队头选择输出来源
    // ============================================================
    wire sel_is_1  = order_dout; // 0->fifo0, 1->fifo1
    wire sel_empty = sel_is_1 ? fifo1_empty : fifo0_empty;
    wire [8:0] sel_dout = sel_is_1 ? fifo1_dout : fifo0_dout;

    assign output_tvalid = (~order_empty) & (~sel_empty);
    assign output_tdata  = sel_dout[7:0];

    wire out_fire = output_tvalid && output_tready;

    assign fifo0_rd = out_fire && (~sel_is_1);
    assign fifo1_rd = out_fire && ( sel_is_1);

    // ★码字输出结束（读到 tlast）才 pop order
    assign order_rd = out_fire && sel_dout[8];

    // ============================================================
    // ★ FIX(MDRV-1): dec*_busy 只在这里一个 always 写（置位+清除）
    // ============================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dec0_busy <= 1'b0;
            dec1_busy <= 1'b0;
        end else begin
            // 置 busy：启动喂该路 decoder（与 feed0/feed1 start 条件一致）
            if (!feed0 && inbuf0_full && !dec0_busy) dec0_busy <= 1'b1;
            if (!feed1 && inbuf1_full && !dec1_busy) dec1_busy <= 1'b1;

            // 清 busy：对应路的“码字输出 tlast 被读走”
            if (fifo0_rd && fifo0_dout[8]) dec0_busy <= 1'b0;
            if (fifo1_rd && fifo1_dout[8]) dec1_busy <= 1'b0;
        end
    end

endmodule


// ================================================================
// Simple sync FIFO (1-clock), show-ahead/FWFT style
//   - dout = mem[rd_ptr] always
//   - rd_en pops current element
// ================================================================
module rs_backend_fifo #(
    parameter integer WIDTH = 9,
    parameter integer DEPTH = 512
)(
    input  wire             clk,
    input  wire             rst,

    input  wire [WIDTH-1:0] din,
    input  wire             wr_en,
    output wire             full,

    output wire [WIDTH-1:0] dout,
    input  wire             rd_en,
    output wire             empty
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    reg [$clog2(DEPTH):0]     count;
    reg [$clog2(DEPTH)-1:0]   wr_ptr, rd_ptr;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // FWFT/show-ahead
    assign dout = mem[rd_ptr];

    wire do_wr = wr_en && ~full;
    wire do_rd = rd_en && ~empty;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count  <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            if (do_wr) begin
                mem[wr_ptr] <= din;
                if (wr_ptr == DEPTH-1) wr_ptr <= 0;
                else wr_ptr <= wr_ptr + 1'b1;
            end

            if (do_rd) begin
                if (rd_ptr == DEPTH-1) rd_ptr <= 0;
                else rd_ptr <= rd_ptr + 1'b1;
            end

            case ({do_wr, do_rd})
              2'b10: count <= count + 1'b1;
              2'b01: count <= count - 1'b1;
              default: count <= count;
            endcase
        end
    end
endmodule
