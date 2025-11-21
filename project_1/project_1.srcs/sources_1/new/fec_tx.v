`timescale 1ns/1ps

module fec_tx #(
    parameter integer W                 = 32,
    parameter integer PAYLOAD_WORDS     = 16,
    parameter integer RS_K              = 229,
    parameter integer RS_N              = 255,
    parameter integer INTLV_D           = 4808,
    parameter integer INTLV_N           = 255,
    parameter integer FRAMES_PER_BLOCK  = 255 
)(
    input  wire             line_clk,
    input  wire             core_clk,
    input  wire             rst_n,
    // 原始 8bit 数据
    input  wire [7:0]       i_data,
    input  wire             i_valid,
    output wire             i_ready,
    // 输出给 GTH TX 的 32bit 数据
    output wire [W-1:0]     o_tx_data,
    output wire             o_tx_valid,
    output wire [31:0]      o_tx_data_line,
    output wire             o_tx_valid_line,
    output wire [15:0]      o_tx_frame_index
);

    wire rst = ~rst_n;

    // ================= RS 编码 =================
    wire [7:0] enc_data;
    wire       enc_valid;
    wire       enc_last;
    wire       xpm_input_tready;

    rs_encode_frontend  rs_encode_frontend (
        .clk                    (line_clk),                   // 上游 8bit 数据时钟
        .rst                    (rst),
        .enc_clk                (core_clk),  
        // 上游 8 bit 输入
        .fifo_input_rdy         (i_ready),
        .data_i                 (i_data),
        .data_valid_i           (i_valid),

        // 下游 RS 编码 IP 的 AXIS 输出
        .m_axis_output_tready   (1),
        .m_axis_output_tlast    (enc_last),
        .m_axis_output_tdata    (enc_data),
        .m_axis_output_tvalid   (enc_valid)
    );
    
    // integer tx_sym_idx;
    // always @(posedge core_clk or posedge rst) begin
    //     if (rst) begin
    //         tx_sym_idx <= 0;
    //     end else if (enc_valid) begin
    //         $display("TX_RS_OUT: idx=%0d data=%0d last=%0b time=%t",
    //                  tx_sym_idx, enc_data, enc_last, $time);
    //         tx_sym_idx <= tx_sym_idx + 1;
    //     end
    // end
    // ================= 交织器 ==================
    wire        intlv_valid;
    wire [7:0]  intlv_data;
    wire        intlv_block_start;
    // 暂时绕过交织器
    // assign intlv_data        = enc_data;
    // assign intlv_valid       = enc_valid;
    // assign intlv_block_start = 1'b0;
    rs_interleaver_xpm #(
        .D (INTLV_D),
        .N (INTLV_N)
    ) u_interleaver (
        .clk            (core_clk),
        .rst            (rst),
        .in_valid       (enc_valid),
        .in_data        (enc_data),
        .in_ready       (xpm_input_tready),    
        .out_valid      (intlv_valid),
        .out_data       (intlv_data),
        .out_block_start(intlv_block_start)
    );
    // ================= 8bit 数据 + 1bit block_start 标志的同步 FIFO =================

    // FIFO 输出
    wire        fifo_valid;
    wire [7:0]  fifo_data;
    wire        fifo_flag;
    wire        fifo_ready;


    fifo_8b_flag_sync #(
        .DEPTH     (64))
    u_intlv_fifo (
        .clk       (core_clk),
        .rst       (rst),

        .in_data   (intlv_data),
        .in_flag   (intlv_block_start),
        .in_valid  (intlv_valid),
        .in_ready  (),              // 如果以后想反压交织器，就把这根接上去

        .out_data  (fifo_data),
        .out_flag  (fifo_flag),
        .out_valid (fifo_valid),
        .out_ready (fifo_ready)
    );

    // =============== 8bit → 32bit 打包 + 块起始 ===============
    // gearbox 输出
    wire [31:0] gb_data;
    wire        gb_valid;
    wire        gb_block_start;
    wire        gb_ready; 
    // gearbox 8 → 32
    gearbox_8to32_bs u_gb_8to32 (
        .clk            (core_clk),
        .rst            (rst),

        .in_data        (fifo_data),
        .in_valid       (fifo_valid),
        .in_block_start (fifo_flag),
        .in_ready       (fifo_ready),       // ★ 直接用 FIFO 的读侧 ready

        .out_ready      (gb_ready),         // 来自 framer（再往下 async FIFO）
        .out_data       (gb_data),
        .out_valid      (gb_valid),
        .out_block_start(gb_block_start)
    );

    wire tx32_wr_ready;
    // ================= 帧封装器 =================
    fso_framer #(
        .W                  (W),
        .PAYLOAD_WORDS      (PAYLOAD_WORDS),
        .FRAMES_PER_BLOCK   (FRAMES_PER_BLOCK)
    ) u_fso_framer (
        .clk                (core_clk),
        .rst_n              (rst_n),
        .i_payload_data     (gb_data),
        .i_payload_valid    (gb_valid),
        .i_block_start_word (gb_block_start),
        .o_payload_ready    (gb_ready),            
        .o_tx_data          (o_tx_data),
        .o_tx_valid         (o_tx_valid),
        .i_tx_ready         (tx32_wr_ready),
        .o_frame_index      (o_tx_frame_index)
    );  

    wire [31:0] tx32_fifo_dout;
    wire        tx32_fifo_empty;
    wire        tx32_fifo_full;
    wire        tx32_fifo_rd_en;             
    wire        tx32_fifo_wrstbsy;
    wire        tx32_fifo_rrstbsy;
    wire [7:0]  tx_fifo_rdcnt;
    wire [7:0]  tx_fifo_wrcnt;
//加入计数逻辑 每次发送一个帧 而不是一有数据就发送 

    reg rst_sync_d0,rst_sync_d1;
    
    always@(posedge core_clk or posedge rst)begin
        if(rst)begin
            rst_sync_d0 <= 1'b1;
            rst_sync_d1 <= 1'b1;
        end else begin
            rst_sync_d0 <= 1'b0;
            rst_sync_d1 <= rst_sync_d0;
        end
    end

    async_fifo_32w_32r u_tx_fifo (
        .rst           (rst_sync_d1),
        .wr_clk        (core_clk),
        .rd_clk        (line_clk),
        .din           (o_tx_data),
        .wr_en         (o_tx_valid),
        .rd_en         (tx32_fifo_rd_en),     
        .dout          (tx32_fifo_dout),      
        .full          (tx32_fifo_full),
        .empty         (tx32_fifo_empty),     
        .rd_data_count (tx_fifo_rdcnt),       
        .wr_data_count (tx_fifo_wrcnt),
        .wr_rst_busy   (tx32_fifo_wrstbsy), 
        .rd_rst_busy   (tx32_fifo_rrstbsy) 
    );

// Store-and-Forward 参数
    localparam integer FRAME_LEN_WORDS = 2 + 1 + PAYLOAD_WORDS; // 19
    localparam [31:0]  IDLE_WORD       = 32'h0707_0707;

    // 状态控制
    reg        sending_state;
    reg [7:0]  sent_word_cnt;
    reg        tx_fifo_rd_en_reg;

    // 输出打拍寄存器
    reg        tx_valid_out_reg;
    reg [31:0] tx_data_out_reg;

    // ------------------------------------------------------------
    // 读控制状态机
    // ------------------------------------------------------------
    always @(posedge line_clk or posedge rst) begin
        if (rst) begin
            sending_state     <= 1'b0;
            sent_word_cnt     <= 8'd0;
            tx_fifo_rd_en_reg <= 1'b0;
        end else begin
            tx_fifo_rd_en_reg <= 1'b0;

            if (tx32_fifo_rrstbsy) begin
                sending_state <= 1'b0;
            end else begin
                case (sending_state)
                    1'b0: begin 
                        if (tx_fifo_rdcnt >= FRAME_LEN_WORDS) begin
                            sending_state     <= 1'b1;
                            tx_fifo_rd_en_reg <= 1'b1; // 启动信号
                            sent_word_cnt     <= 8'd1;
                        end
                    end

                    1'b1: begin
                        if (sent_word_cnt < FRAME_LEN_WORDS) begin
                            tx_fifo_rd_en_reg <= 1'b1;
                            sent_word_cnt     <= sent_word_cnt + 1'b1;
                        end else begin
                            sending_state     <= 1'b0;
                            tx_fifo_rd_en_reg <= 1'b0;
                            sent_word_cnt     <= 8'd0;
                        end
                    end
                endcase
            end
        end
    end

    // ------------------------------------------------------------
    //  数据输出逻辑 
    // ------------------------------------------------------------
    always @(posedge line_clk or posedge rst) begin
        if (rst) begin
            tx_valid_out_reg <= 1'b0;
            tx_data_out_reg  <= IDLE_WORD;
        end else begin
            tx_valid_out_reg <= tx_fifo_rd_en_reg;
            if (tx_fifo_rd_en_reg) begin
                tx_data_out_reg <= tx32_fifo_dout;
            end else begin
                tx_data_out_reg <= IDLE_WORD;
            end
        end
    end

    // ------------------------------------------------------------
    // 接口赋值
    // ------------------------------------------------------------
    assign tx32_fifo_rd_en = tx_fifo_rd_en_reg;
    
    assign o_tx_data_line  = tx_data_out_reg;
    assign o_tx_valid_line = tx_valid_out_reg;
    
    assign tx32_wr_ready   = ~tx32_fifo_full & ~tx32_fifo_wrstbsy;

endmodule
