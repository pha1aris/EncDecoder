`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// 模块名称: interleaver_self_check_sim (完整版)
// 设计目标: 
//   本模块是整个自校验仿真的顶层文件 (Testbench Top)。
//   它直接控制两个 ddr4_controler 实例和两个 DDR4 模型，并执行自校验。
//
//   修改说明 (2025-07-21):
//   - 修正了模块例化层次，将 ddr4_controler_clean 作为 DUT 直接例化。
//   - 整合了所有时钟、复位、数据生成、校验和模型逻辑。
//   - 重新加入了完整的文件写入 ($fwrite) 逻辑。
//   - 修正了 ddr4_controler_clean 例化时缺失的 dbg_* 端口连接。
//
//////////////////////////////////////////////////////////////////////////////////

// --- XSIM 兼容性模块 ---
`ifdef XILINX_SIMULATOR
module short(in1, in1);
inout in1;
endmodule
`endif

module interleaver_self_check_sim;

//=============================================================================
// 参数定义
//=============================================================================

// 读写突发长度与交织块大小的关系
//8*8（64）交织块大小下 写突发长度8 读突发长度64
//8*16(128)交织块大小下 写突发长度16 读突发长度 128
//n*m 交织块大小下 写突发长度 m*n/8 读突发长度m*n
localparam DATA_WIDTH = 32;
localparam WR_BRUST_LEN = 8'd16;
localparam RD_BRUST_LEN = 8'd128;
localparam MATRIX_COL   = 17'd8;
localparam MATRIX_ROW   = 10'd8;
localparam TEST_LENGTH  = MATRIX_COL * MATRIX_ROW * 8;
localparam FIFO_DEPTH   = TEST_LENGTH * 4;
localparam READ_LATENCY_DELAY = 500;
localparam SYSCLK_PERIOD = 5000; // 200 MHz
localparam APP_ADDR_MIN = 29'd0;
localparam APP_ADDR_MAX = MATRIX_COL * MATRIX_ROW;

// --- FSM States ---
localparam FSM_IDLE             = 4'd0;
localparam FSM_WRITE_U1         = 4'd1;
localparam FSM_REQ_READ_U1      = 4'd2;
localparam FSM_WAIT_U1          = 4'd3;
localparam FSM_READ_U1_WRITE_U2 = 4'd4;
localparam FSM_REQ_READ_U2      = 4'd5;
localparam FSM_WAIT_U2          = 4'd6;
localparam FSM_READ_U2_CHECK    = 4'd7;
localparam FSM_DONE             = 4'd8;

// DDR4 模型相关参数
localparam tCK                 = 833;
localparam DRAM_WIDTH          = 16;
localparam NUM_PHYSICAL_PARTS  = (DATA_WIDTH/DRAM_WIDTH);
localparam CS_WIDTH            = 1;
localparam RANK_WIDTH          = 1;
localparam ADDR_WIDTH_MODEL    = 17;
localparam CA_MIRROR           = "OFF";

import arch_package::*;
parameter UTYPE_density CONFIGURED_DENSITY = _8G;

// DDR4 命令编码
localparam MRS = 3'b000;
localparam REF = 3'b001;
localparam PRE = 3'b010;
localparam ACT = 3'b011;
localparam WR  = 3'b100;
localparam RD  = 3'b101;
localparam ZQC = 3'b110;
localparam NOP = 3'b111;

//=============================================================================
// 信号声明
//=============================================================================
reg  sys_clk_p, sys_clk_n, sys_rst_n;
reg  en_model;
wire model_enable_net;
assign model_enable_net = en_model;

// --- Clocks and Control ---
wire sys_clk, locked, clk_15p625;
reg [3:0] state;
reg [$clog2(TEST_LENGTH):0] transaction_counter;
reg [$clog2(READ_LATENCY_DELAY):0] latency_counter;

// --- Controller 1 Signals ---
wire init_calib_complete_u1, clk_50m_u1;
reg  wr_fifo_wen_u1;
wire [DATA_WIDTH-1:0] wr_fifo_wdata_u1;
reg  ddr4_read_valid_u1, rd_fifo_ren_u1;
wire [DATA_WIDTH-1:0] rd_fifo_rdata_u1;

// --- Controller 2 Signals ---
wire init_calib_complete_u2, clk_50m_u2;
wire wr_fifo_wen_u2;
wire [DATA_WIDTH-1:0] wr_fifo_wdata_u2;
reg  ddr4_read_valid_u2, rd_fifo_ren_u2;
wire [DATA_WIDTH-1:0] rd_fifo_rdata_u2;
wire read_start_u2;

// --- Data Generation & Checking ---
reg [31:0]                          data_gen_cnt;
reg [DATA_WIDTH-1:0]                delay_fifo [0:FIFO_DEPTH-1];
reg [$clog2(FIFO_DEPTH):0]          fifo_wptr, fifo_rptr;
reg [31:0]                          error_count, success_count;

// --- File I/O ---
integer file_u1_write,file_u1_read,
        file_u2_read , file_u2_write;

// --- DDR4 Physical Interface Wires for Controller 0 ---
wire [16:0] c0_ddr4_adr;
wire [1:0]  c0_ddr4_ba;
wire [0:0]  c0_ddr4_bg;
wire [0:0]  c0_ddr4_cke;
wire [0:0]  c0_ddr4_odt;
wire [0:0]  c0_ddr4_cs_n;
wire        c0_ddr4_act_n;
wire        c0_ddr4_reset_n;
wire [0:0]  c0_ddr4_ck_t;
wire [0:0]  c0_ddr4_ck_c;
tri  [3:0]  c0_ddr4_dm_dbi_n;
tri  [DATA_WIDTH-1:0] c0_ddr4_dq;
tri  [3:0]  c0_ddr4_dqs_c;
tri  [3:0]  c0_ddr4_dqs_t;

// --- DDR4 Physical Interface Wires for Controller 1 ---
wire [16:0] c1_ddr4_adr;
wire [1:0]  c1_ddr4_ba;
wire [0:0]  c1_ddr4_bg;
wire [0:0]  c1_ddr4_cke;
wire [0:0]  c1_ddr4_odt;
wire [0:0]  c1_ddr4_cs_n;
wire        c1_ddr4_act_n;
wire        c1_ddr4_reset_n;
wire [0:0]  c1_ddr4_ck_t;
wire [0:0]  c1_ddr4_ck_c;
tri  [3:0]  c1_ddr4_dm_dbi_n;
tri  [DATA_WIDTH-1:0] c1_ddr4_dq;
tri  [3:0]  c1_ddr4_dqs_c;
tri  [3:0]  c1_ddr4_dqs_t;

// --- 地址/命令处理逻辑信号 (接口 0) ---
reg  [ADDR_WIDTH_MODEL-1:0] c0_ddr4_adr_sdram [RANK_WIDTH-1:0];
reg  [1:0]                  c0_ddr4_ba_sdram  [RANK_WIDTH-1:0];
reg  [0:0]                  c0_ddr4_bg_sdram  [RANK_WIDTH-1:0];
reg  [31:0]                 cmdName_c0;
reg  [ADDR_WIDTH_MODEL-1:0] DDR4_ADRMOD_c0    [RANK_WIDTH-1:0];

// --- 地址/命令处理逻辑信号 (接口 1) ---
reg  [ADDR_WIDTH_MODEL-1:0] c1_ddr4_adr_sdram [RANK_WIDTH-1:0];
reg  [1:0]                  c1_ddr4_ba_sdram  [RANK_WIDTH-1:0];
reg  [0:0]                  c1_ddr4_bg_sdram  [RANK_WIDTH-1:0];
reg  [31:0]                 cmdName_c1;
reg  [ADDR_WIDTH_MODEL-1:0] DDR4_ADRMOD_c1    [RANK_WIDTH-1:0];

// --- 调试信号线 ---
wire        dbg_ui_clk_u1, dbg_ui_rst_u1;
wire [28:0] dbg_app_addr_u1;
wire [2:0]  dbg_app_cmd_u1;
wire        dbg_app_en_u1, dbg_wdf_wren_u1, dbg_rd_data_valid_u1;
wire [255:0]dbg_wr_data_u1, dbg_rd_data_u1;

wire        dbg_ui_clk_u2, dbg_ui_rst_u2;
wire [28:0] dbg_app_addr_u2;
wire [2:0]  dbg_app_cmd_u2;
wire        dbg_app_en_u2, dbg_wdf_wren_u2, dbg_rd_data_valid_u2;
wire [255:0]dbg_wr_data_u2, dbg_rd_data_u2;

// --- U2 读地址 FIFO ---
reg [28:0] rd_addr_fifo_u2 [0:1023];
reg [9:0]  rd_addr_fifo_u2_wptr, rd_addr_fifo_u2_rptr;

//=============================================================================
// 时钟和复位生成
//=============================================================================
initial begin
    sys_clk_p = 1'b0;
    sys_clk_n = 1'b1;
    forever #(SYSCLK_PERIOD / 2) {sys_clk_p, sys_clk_n} = {~sys_clk_p, ~sys_clk_n};
end

initial begin
    sys_rst_n = 1'b0; 
    en_model  = 1'b0;
    #200ns;
    sys_rst_n = 1'b1; 
    #5ns; 
    en_model  = 1'b1;
end

IBUFDS IBUFDS_inst (.O(sys_clk), .I(sys_clk_p), .IB(sys_clk_n));

clk_wiz_0 clk_wiz_0_inst (
    .clk_out1 (clk_15p625),
    .reset    (~sys_rst_n),
    .locked   (locked),
    .clk_in1  (clk_50m_u1)
);

// //=============================================================================
// // 数据生成逻辑
// //=============================================================================
// assign wr_fifo_wdata_u1 = {data_gen_cnt[7:0], data_gen_cnt[7:0], data_gen_cnt[7:0], data_gen_cnt[7:0]};

// always @(posedge clk_15p625 or negedge sys_rst_n) begin
//     if (!sys_rst_n || !locked) begin
//         data_gen_cnt <= 32'd0;
//     end else if (init_calib_complete_u1 && init_calib_complete_u2) begin
//         if (state == FSM_WRITE_U1) begin
//             data_gen_cnt <= data_gen_cnt + 1;
//         end
//     end
// end

// //=============================================================================
// // 主控制状态机
// //=============================================================================
// always @(posedge clk_15p625 or negedge sys_rst_n) begin
//     if (!sys_rst_n || !locked) begin
//         state               <= FSM_IDLE;
//         latency_counter     <= 0;
//         transaction_counter <= 0;
//         wr_fifo_wen_u1      <= 1'b0;
//         // ddr4_read_valid_u1  <= 1'b0;
//         rd_fifo_ren_u1      <= 1'b0;
//         ddr4_read_valid_u2  <= 1'b0;
//         rd_fifo_ren_u2      <= 1'b0;
//     end else begin
//         wr_fifo_wen_u1     <= 1'b0;
//         // ddr4_read_valid_u1 <= 1'b0;
//         rd_fifo_ren_u1     <= 1'b0;
//         ddr4_read_valid_u2 <= 1'b0;
//         rd_fifo_ren_u2     <= 1'b0;

//         case (state)
//             FSM_IDLE: 
//                 if (init_calib_complete_u1 && init_calib_complete_u2) begin
//                     state <= FSM_WRITE_U1;
//                     transaction_counter <= 0;
//                 end
            
//             FSM_WRITE_U1: begin
//                 wr_fifo_wen_u1 <= 1'b1;
//                 if (transaction_counter == TEST_LENGTH - 1) begin
//                     state <= FSM_REQ_READ_U1;
//                 end else begin
//                     transaction_counter <= transaction_counter + 1;
//                 end
//             end
            
//             FSM_REQ_READ_U1: begin
//                 // ddr4_read_valid_u1 <= 1'b1;
//                 state              <= FSM_WAIT_U1;
//                 latency_counter    <= 0;
//             end

//             FSM_WAIT_U1: begin
//                 latency_counter <= latency_counter + 1;
//                 if (latency_counter == READ_LATENCY_DELAY) begin
//                     state               <= FSM_READ_U1_WRITE_U2;
//                     transaction_counter <= 0;
//                 end
//             end

//             FSM_READ_U1_WRITE_U2: begin
//                 rd_fifo_ren_u1 <= 1'b1;
//                 if (transaction_counter == TEST_LENGTH - 1) begin
//                     state <= FSM_REQ_READ_U2;
//                 end else begin
//                     transaction_counter <= transaction_counter + 1;
//                 end
//             end

//             FSM_REQ_READ_U2: begin
//                 // ddr4_read_valid_u2 <= 1'b1;
//                 state              <= FSM_WAIT_U2;
//                 latency_counter    <= 0;
//             end

//             FSM_WAIT_U2: begin
//                 latency_counter <= latency_counter + 1;
//                 if (latency_counter == READ_LATENCY_DELAY) begin
//                     state               <= FSM_READ_U2_CHECK;
//                     transaction_counter <= 0;
//                 end
//             end

//             FSM_READ_U2_CHECK: begin
//                 rd_fifo_ren_u2 <= 1'b1;
//                 if (transaction_counter == TEST_LENGTH - 1) begin
//                     state <= FSM_DONE;
//                 end else begin
//                     transaction_counter <= transaction_counter + 1;
//                 end
//             end

//             FSM_DONE: begin
//                 // Wait for checker to finish
//             end
//         endcase
//     end
// end

//=============================================================================
// 数据生成逻辑 (Test Stimulus)
//=============================================================================
// 当DDR4初始化完成后，产生一个从1到0xE4循环的计数器数据流
// --- 数据生成逻辑信号 ---// --- 读请求逻辑信号 ---
reg  rd_req_reg;
wire rd_req;
reg  [$clog2(TEST_LENGTH)-1:0] write_counter; 
reg  [31:0] cnt;
reg  data_valid;
wire [DATA_WIDTH-1:0] cnt_data;

always @(posedge clk_15p625 or negedge sys_rst_n) begin
    if(!sys_rst_n || !locked) begin // 增加locked信号作为复位条件
        cnt        <= 'd0;
        data_valid <= 1'b0;
    end else if(init_calib_complete_u1) begin
        cnt        <= cnt + 1'b1;
        data_valid <= 1'b1;
        // if(cnt == 'hE4) begin
            
            // cnt <= 8'd1;
        // end
    end else begin
        cnt        <= 8'd0;
        data_valid <= 1'b0;
    end
end

// 将8位的计数器扩展为32位数据
assign cnt_data = {cnt, cnt, cnt, cnt};


//=============================================================================
// 读请求生成逻辑
//=============================================================================
// 在写入第一个交织块的最后一个数据后，拉高 rd_req
assign rd_req = rd_req_reg;

always @(posedge clk_15p625 or negedge sys_rst_n) begin
    if (!sys_rst_n || !locked) begin // 增加locked信号作为复位条件
        write_counter <= 0;
    end else begin
        if (rd_req_reg == 1'b0) begin
            if (data_valid) begin
                if (write_counter == TEST_LENGTH - 1) begin
                    rd_req_reg    <= 1'b1;
                    write_counter <= write_counter;
                end else begin
                    write_counter <= write_counter + 1;
                end
            end
        end
    end
end

//早了18个clock
reg [4:0] dly_cnt;
reg dly_rd_req;
always @(posedge clk_15p625 or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        rd_req_reg <= 0;
        dly_rd_req <= 1'b0;
        dly_cnt <= 'd0;
    end else if(rd_req_reg)begin
        if(dly_cnt == 17)begin
            dly_cnt <= 'd0;
            dly_rd_req <= 1'b1;
        end else begin
            dly_cnt <= dly_cnt + 1'b1;
        end
    end
end

reg rd_req_u2_reg;
wire rd_req_u2;
assign rd_req_u2 = rd_req_u2_reg;
reg  [$clog2(TEST_LENGTH)-1:0] write_counter_u2; 
always @(posedge clk_15p625 or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        write_counter_u2 <= 0;
        rd_req_u2_reg <= 1'b0;
    end else if(rd_req) begin
        if(write_counter_u2 == TEST_LENGTH - 1)begin
            write_counter_u2 <= write_counter_u2;
            rd_req_u2_reg <= 1'b1;
        end else begin
            write_counter_u2 <= write_counter_u2 + 1'b1;
        end
    end
end


//=============================================================================
// 数据校验与文件输出
//=============================================================================
initial begin
    file_u1_write = $fopen("U1_write_log.txt", "w");
    file_u1_read  = $fopen("U1_read_log.txt",  "w");
    file_u2_write = $fopen("U2_write_log.txt", "w"); 
    file_u2_read  = $fopen("U2_read_log.txt",  "w");

    if (file_u1_write == 0 || file_u2_read == 0 || file_u1_read == 0 || file_u2_write == 0) begin
        $display("ERROR: Could not open log files.");
        $finish;
    end
end

// 端到端数据校验逻辑 (使用延迟FIFO)
always @(posedge clk_15p625) begin
    if (wr_fifo_wen_u1) begin
        delay_fifo[fifo_wptr] <= wr_fifo_wdata_u1;
        fifo_wptr <= fifo_wptr + 1;
    end
end

always @(posedge clk_15p625 or negedge sys_rst_n) begin
    if (!sys_rst_n || !locked) begin
        fifo_wptr <= 0; fifo_rptr <= 0;
        error_count <= 0; success_count <= 0;
    end else begin
        if (rd_fifo_ren_u2) begin
            if (delay_fifo[fifo_rptr] == rd_fifo_rdata_u2) begin
                $display("SUCCESS: Data matched. Original: %h, Final: %h", delay_fifo[fifo_rptr], rd_fifo_rdata_u2);
                success_count <= success_count + 1;
            end else begin
                $display("ERROR: Data MISMATCH! Original: %h, Final: %h", delay_fifo[fifo_rptr], rd_fifo_rdata_u2);
                error_count <= error_count + 1;
            end
            fifo_rptr <= fifo_rptr + 1;
        end

        if (success_count + error_count == TEST_LENGTH && state == FSM_DONE) begin
            if (error_count == 0) $display("****** TEST PASSED! ******");
            else $display("****** TEST FAILED! Total Errors: %d ******", error_count);
            
            $fclose(file_u1_write);
            $fclose(file_u1_read); // <-- 确保关闭所有文件
            $fclose(file_u2_write); // <-- 确保关闭所有文件
            $fclose(file_u2_read);
            $finish;
        end
    end
end

//=============================================================================
// 记录U1读出和U2写入的数据
//=============================================================================
always @(posedge clk_15p625) begin
    // rd_req 信号触发U1的读FIFO和U2的写FIFO
    if (rd_req) begin
        // 记录从 U1 读出的数据
        $fwrite(file_u1_read, "Time: %0t, Read from U1: %h\n", $time, rd_fifo_rdata_u1);
        
        // 记录写入到 U2 的数据
        $fwrite(file_u2_write, "Time: %0t, Write to U2: %h\n", $time, wr_fifo_wdata_u2);
    end
end

//=============================================================================
// 现有调试信号记录 (保留)
//=============================================================================
// 记录 U1 的DDR内部写入操作
always @(posedge dbg_ui_clk_u1) begin
    if (dbg_wdf_wren_u1) begin // 使用使能信号判断更准确
        $fwrite(file_u1_write, "Write Address: %h, Write Data: %h\n", dbg_app_addr_u1, dbg_wr_data_u1);
    end
end

// 记录 U2 的DDR内部读地址
always @(posedge dbg_ui_clk_u2) begin
    if (dbg_app_en_u2 && dbg_app_cmd_u2 == 3'b001) begin // Read command
        rd_addr_fifo_u2[rd_addr_fifo_u2_wptr] <= dbg_app_addr_u2;
        rd_addr_fifo_u2_wptr <= rd_addr_fifo_u2_wptr + 1;
    end
end

// 记录 U2 的DDR内部读出数据
always @(posedge dbg_ui_clk_u2) begin
    if (dbg_rd_data_valid_u2) begin
        $fwrite(file_u2_read, "Read Address: %h, Read Data: %h\n", rd_addr_fifo_u2[rd_addr_fifo_u2_rptr], dbg_rd_data_u2);
        rd_addr_fifo_u2_rptr <= rd_addr_fifo_u2_rptr + 1;
    end
end
//=============================================================================
// 数据流连接
//=============================================================================
// assign wr_fifo_wdata_u2 = rd_fifo_rdata_u1;
// assign wr_fifo_wen_u2   = rd_fifo_ren_u1;

assign wr_fifo_wdata_u2 = rd_fifo_rdata_u1;
assign wr_fifo_wen_u2   = dly_rd_req;
wire rd_fifo_rvalid;


//=============================================================================
//随机数产生与检查模块
//=============================================================================

wire [31:0] prbs_data_gen;
  gtwizard_ultrascale_0_prbs_any # (
    .CHK_MODE    (0),   //0：prbs生成模式
    .INV_PATTERN (1),   //反转prbs模式
    .POLY_LENGHT (31),  //多项式抽头
    .POLY_TAP    (28),  //多项式级数
    .NBITS       (32)   //数据位宽
  ) prbs_gen_inst (
    .RST      (~sys_rst_n),
    .CLK      (clk_15p625),
    .DATA_IN  ('d0),
    .EN       (data_valid),
    .DATA_OUT (prbs_data_gen)
  );

    wire prbs_chk_en;
    wire [31:0] prbs_chk_data;
    wire [31:0] prbh_chk;

    reg prbs_match;
    assign prbs_chk_en = rd_req_u2;
    assign prbs_chk_data = rd_fifo_rdata_u2;

  always @(posedge clk_15p625) begin
    if (!sys_rst_n)
      prbs_match <= 1'b0;
    else
      prbs_match <= ~(|prbh_chk);
  end

wire rd_fifo_rvalid_u2;

  gtwizard_ultrascale_0_prbs_any # (
    .CHK_MODE    (1),   //1:prbs 校验模式
    .INV_PATTERN (1),   
    .POLY_LENGHT (31),
    .POLY_TAP    (28),
    .NBITS       (32)
  ) prbs_chk_inst (
    .RST      (~sys_rst_n),
    .CLK      (clk_15p625),

    .DATA_IN  (rd_fifo_rdata_u2),
    .EN       (rd_fifo_rvalid_u2),
    .DATA_OUT (prbh_chk)
  );

//=============================================================================
// DDR4 Controller 模块例化
//=============================================================================


ddr4_controler_clean #(
    .MATRIX_COL(8), 
    .MATRIX_ROW(8)
) ddr4_controler_U1 (
    .sys_clk_p              (sys_clk_p), 
    .sys_clk_n              (sys_clk_n), 
    .rst_n                  (sys_rst_n),
    .c0_ddr4_adr            (c0_ddr4_adr),
    .c0_ddr4_ba             (c0_ddr4_ba),
    .c0_ddr4_bg             (c0_ddr4_bg),
    .c0_ddr4_cke            (c0_ddr4_cke),
    .c0_ddr4_odt            (c0_ddr4_odt),
    .c0_ddr4_cs_n           (c0_ddr4_cs_n),
    .c0_ddr4_act_n          (c0_ddr4_act_n),
    .c0_ddr4_reset_n        (c0_ddr4_reset_n),
    .c0_ddr4_ck_t           (c0_ddr4_ck_t),
    .c0_ddr4_ck_c           (c0_ddr4_ck_c),
    .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n),
    .c0_ddr4_dq             (c0_ddr4_dq),
    .c0_ddr4_dqs_c          (c0_ddr4_dqs_c),
    .c0_ddr4_dqs_t          (c0_ddr4_dqs_t),
    .ui_clkout              (clk_50m_u1), 
    .c0_init_calib_complete (init_calib_complete_u1),
    .wr_bust_len            (8),
    .rd_bust_len            (64),

// //cnt data mode
//     .wr_fifo_wdata          (cnt_data),
//     .wr_fifo_wen            (data_valid), 

//prbs data mode
    .wr_fifo_wclk           (clk_15p625), 
    .wr_fifo_wdata          (prbs_data_gen),    //input 
    .wr_fifo_wen            (data_valid),       //input 

    .rd_fifo_rclk           (clk_15p625), 
    // .rd_fifo_ren            (rd_req),           //input 
    .rd_fifo_rvalid         (rd_fifo_rvalid),   //output
    .rd_fifo_rdata          (rd_fifo_rdata_u1), //output 

    .dbg_ui_clk             (dbg_ui_clk_u1), 
    .dbg_ui_rst             (dbg_ui_rst_u1), 
    .dbg_app_addr           (dbg_app_addr_u1),
    .dbg_app_cmd            (dbg_app_cmd_u1), 
    .dbg_app_en             (dbg_app_en_u1), 
    .dbg_wdf_wren           (dbg_wdf_wren_u1),
    .dbg_wr_data            (dbg_wr_data_u1), 
    .dbg_rd_data            (dbg_rd_data_u1), 
    .dbg_rd_data_valid      (dbg_rd_data_valid_u1)
);


ddr4_controler_deintv #(
    .MATRIX_COL(8), 
    .MATRIX_ROW(8)
) ddr4_controler_U2 (
    .sys_clk_p              (sys_clk_p), 
    .sys_clk_n              (sys_clk_n), 
    .rst_n                  (sys_rst_n),
    .c0_ddr4_adr            (c1_ddr4_adr),
    .c0_ddr4_ba             (c1_ddr4_ba),
    .c0_ddr4_bg             (c1_ddr4_bg),
    .c0_ddr4_cke            (c1_ddr4_cke),
    .c0_ddr4_odt            (c1_ddr4_odt),
    .c0_ddr4_cs_n           (c1_ddr4_cs_n),
    .c0_ddr4_act_n          (c1_ddr4_act_n),
    .c0_ddr4_reset_n        (c1_ddr4_reset_n),
    .c0_ddr4_ck_t           (c1_ddr4_ck_t),
    .c0_ddr4_ck_c           (c1_ddr4_ck_c),
    .c0_ddr4_dm_dbi_n       (c1_ddr4_dm_dbi_n),
    .c0_ddr4_dq             (c1_ddr4_dq),
    .c0_ddr4_dqs_c          (c1_ddr4_dqs_c),
    .c0_ddr4_dqs_t          (c1_ddr4_dqs_t),
    .ui_clkout              (clk_50m_u2), 
    .c0_init_calib_complete (init_calib_complete_u2),

    .wr_bust_len            (8),
    .rd_bust_len            (64),

    .wr_fifo_wclk           (clk_15p625), 
    .wr_fifo_wen            (rd_fifo_rvalid), 
    .wr_fifo_wdata          (rd_fifo_rdata_u1),
    .rd_fifo_rclk           (clk_15p625), 

    .data_valid_o           (rd_fifo_rvalid_u2),

    // .rd_fifo_ren            (rd_req_u2), 
    .rd_fifo_rdata          (rd_fifo_rdata_u2),

    .read_start             (read_start_u2),
    .dbg_ui_clk             (dbg_ui_clk_u2), 
    .dbg_ui_rst             (dbg_ui_rst_u2), 
    .dbg_app_addr           (dbg_app_addr_u2),
    .dbg_app_cmd            (dbg_app_cmd_u2), 
    .dbg_app_en             (dbg_app_en_u2), 
    .dbg_wdf_wren           (dbg_wdf_wren_u2),
    .dbg_wr_data            (dbg_wr_data_u2), 
    .dbg_rd_data            (dbg_rd_data_u2), 
    .dbg_rd_data_valid      (dbg_rd_data_valid_u2)
);

// 状态宏定义（不变）
localparam IDLE     = 'd0;
localparam DDR_DONE = 'd1;
localparam WRITE    = 'd2;
localparam READ     = 'd3;

// 状态信号定义
reg [103:0] U1_state_cnt;
reg [103:0] U2_state_cnt;
reg [103:0] U1_app_cmd;
reg [103:0] U2_app_cmd;

// 状态解码 U1
always @(*) begin
    case(ddr4_controler_U1.u_ddr4_rw.state_cnt)
        IDLE:     U1_state_cnt = "IDLE    ";
        DDR_DONE: U1_state_cnt = "DDR_DONE";
        WRITE:    U1_state_cnt = "WRITE   ";
        READ:     U1_state_cnt = "READ    ";
        default:  U1_state_cnt = "UNKNOWN ";
    endcase 
end 

// 状态解码 U2
always @(*) begin
    case(ddr4_controler_U2.u_ddr4_rw.state_cnt)
        IDLE:     U2_state_cnt = "IDLE    ";
        DDR_DONE: U2_state_cnt = "DDR_DONE";
        WRITE:    U2_state_cnt = "WRITE   ";
        READ:     U2_state_cnt = "READ    ";
        default:  U2_state_cnt = "UNKNOWN ";
    endcase 
end 

// 指令解码 U1
always @(*) begin
    case(ddr4_controler_U1.u_ddr4_rw.app_cmd)
        3'b001: U1_app_cmd = "READ ";
        3'b000: U1_app_cmd = "WRITE";
        default: U1_app_cmd = "UNKWN";
    endcase 
end

// 指令解码 U2
always @(*) begin
    case(ddr4_controler_U2.u_ddr4_rw.app_cmd)
        3'b001: U2_app_cmd = "READ ";
        3'b000: U2_app_cmd = "WRITE";
        default: U2_app_cmd = "UNKWN";
    endcase 
end

//=============================================================================
// 地址镜像和命令解码逻辑
//=============================================================================
// --- 逻辑 for 接口 0 ---
always @(*) begin
    c0_ddr4_adr_sdram[0] <= c0_ddr4_adr;
    if (RANK_WIDTH > 1)
        c0_ddr4_adr_sdram[1] <= (CA_MIRROR == "ON") ? 
                                {c0_ddr4_adr[16:14], c0_ddr4_adr[11], c0_ddr4_adr[12], 
                                 c0_ddr4_adr[13], c0_ddr4_adr[10:9], c0_ddr4_adr[7], 
                                 c0_ddr4_adr[8], c0_ddr4_adr[5], c0_ddr4_adr[6], 
                                 c0_ddr4_adr[3], c0_ddr4_adr[4], c0_ddr4_adr[2:0]} : 
                                c0_ddr4_adr;
    c0_ddr4_ba_sdram[0]  <= c0_ddr4_ba;
    if (RANK_WIDTH > 1)
        c0_ddr4_ba_sdram[1]  <= (CA_MIRROR == "ON") ? {c0_ddr4_ba[0], c0_ddr4_ba[1]} : c0_ddr4_ba;
    c0_ddr4_bg_sdram[0]  <= c0_ddr4_bg;
    if (RANK_WIDTH > 1)
        c0_ddr4_bg_sdram[1]  <= c0_ddr4_bg;
end

always @(*) begin
    if (c0_ddr4_cs_n == 1'b1) cmdName_c0 = "DSEL";
    else if (c0_ddr4_act_n)
        casez (DDR4_ADRMOD_c0[0][16:14])
            MRS:     cmdName_c0 = "MRS";
            REF:     cmdName_c0 = "REF";
            PRE:     cmdName_c0 = "PRE";
            WR:      cmdName_c0 = "WR";
            RD:      cmdName_c0 = "RD";
            ZQC:     cmdName_c0 = "ZQC";
            NOP:     cmdName_c0 = "NOP";
            default: cmdName_c0 = "***";
        endcase
    else cmdName_c0 = "ACT";
end

genvar rnk0;
generate
    for (rnk0 = 0; rnk0 < RANK_WIDTH; rnk0 = rnk0 + 1) begin: rankup0
        always @(*)
            if (c0_ddr4_act_n)
                casez (c0_ddr4_adr_sdram[0][16:14])
                    WR, RD: DDR4_ADRMOD_c0[rnk0] = c0_ddr4_adr_sdram[rnk0] & 17'h1C7FF;
                    default: DDR4_ADRMOD_c0[rnk0] = c0_ddr4_adr_sdram[rnk0];
                endcase
            else DDR4_ADRMOD_c0[rnk0] = c0_ddr4_adr_sdram[rnk0];
    end
endgenerate

// --- 逻辑 for 接口 1 ---
always @(*) begin
    c1_ddr4_adr_sdram[0] <= c1_ddr4_adr;
    if (RANK_WIDTH > 1)
        c1_ddr4_adr_sdram[1] <= (CA_MIRROR == "ON") ? 
                                {c1_ddr4_adr[16:14], c1_ddr4_adr[11], c1_ddr4_adr[12], 
                                 c1_ddr4_adr[13], c1_ddr4_adr[10:9], c1_ddr4_adr[7], 
                                 c1_ddr4_adr[8], c1_ddr4_adr[5], c1_ddr4_adr[6], 
                                 c1_ddr4_adr[3], c1_ddr4_adr[4], c1_ddr4_adr[2:0]} : 
                                c1_ddr4_adr;
    c1_ddr4_ba_sdram[0]  <= c1_ddr4_ba;
    if (RANK_WIDTH > 1)
        c1_ddr4_ba_sdram[1]  <= (CA_MIRROR == "ON") ? {c1_ddr4_ba[0], c1_ddr4_ba[1]} : c1_ddr4_ba;
    c1_ddr4_bg_sdram[0]  <= c1_ddr4_bg;
    if (RANK_WIDTH > 1)
        c1_ddr4_bg_sdram[1]  <= c1_ddr4_bg;
end

always @(*) begin
    if (c1_ddr4_cs_n == 1'b1) cmdName_c1 = "DSEL";
    else if (c1_ddr4_act_n)
        casez (DDR4_ADRMOD_c1[0][16:14])
            MRS:     cmdName_c1 = "MRS";
            REF:     cmdName_c1 = "REF";
            PRE:     cmdName_c1 = "PRE";
            WR:      cmdName_c1 = "WR";
            RD:      cmdName_c1 = "RD";
            ZQC:     cmdName_c1 = "ZQC";
            NOP:     cmdName_c1 = "NOP";
            default: cmdName_c1 = "***";
        endcase
    else cmdName_c1 = "ACT";
end

genvar rnk1;
generate
    for (rnk1 = 0; rnk1 < RANK_WIDTH; rnk1 = rnk1 + 1) begin: rankup1
        always @(*)
            if (c1_ddr4_act_n)
                casez (c1_ddr4_adr_sdram[0][16:14])
                    WR, RD: DDR4_ADRMOD_c1[rnk1] = c1_ddr4_adr_sdram[rnk1] & 17'h1C7FF;
                    default: DDR4_ADRMOD_c1[rnk1] = c1_ddr4_adr_sdram[rnk1];
                endcase
            else DDR4_ADRMOD_c1[rnk1] = c1_ddr4_adr_sdram[rnk1];
    end
endgenerate

//=============================================================================
// DDR4 内存模型例化
//=============================================================================
// --- Memory Model 0 for Interleaver 1 ---
generate
    if (DRAM_WIDTH == 16) begin: mem_model_0
        DDR4_if #(.CONFIGURED_DQ_BITS(16)) iDDR4_0[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();
        genvar r0, i0, s0;
        for (r0 = 0; r0 < RANK_WIDTH; r0 = r0 + 1) begin: memModels_R0
            for (i0 = 0; i0 < NUM_PHYSICAL_PARTS; i0 = i0 + 1) begin: memModel_I0
                ddr4_model #(.CONFIGURED_DQ_BITS(16), .CONFIGURED_DENSITY(CONFIGURED_DENSITY)) ddr4_model_inst_0(
                    .model_enable(model_enable_net), .iDDR4(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0])
                );
            end
        end
        for (r0 = 0; r0 < RANK_WIDTH; r0 = r0 + 1) begin: tranDQ_R0
            for (i0 = 0; i0 < NUM_PHYSICAL_PARTS; i0 = i0 + 1) begin: tranDQ_I0
                for (s0 = 0; s0 < 16; s0 = s0 + 1) begin: tranDQ_S0
                    `ifdef XILINX_SIMULATOR
                        short bidiDQ_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQ[s0], c0_ddr4_dq[s0+i0*16]);
                    `else
                        tran bidiDQ_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQ[s0], c0_ddr4_dq[s0+i0*16]);
                    `endif
                end
            end
        end
        for (r0 = 0; r0 < RANK_WIDTH; r0 = r0 + 1) begin: tranDQS_R0
            for (i0 = 0; i0 < NUM_PHYSICAL_PARTS; i0 = i0 + 1) begin: tranDQS_I0
                `ifdef XILINX_SIMULATOR
                    short bidiDQS0_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_t[0], c0_ddr4_dqs_t[(2*i0)]);
                    short bidiDQS0_0_(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_c[0], c0_ddr4_dqs_c[(2*i0)]);
                    short bidiDM0_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DM_n[0], c0_ddr4_dm_dbi_n[(2*i0)]);
                    short bidiDQS1_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_t[1], c0_ddr4_dqs_t[((2*i0)+1)]);
                    short bidiDQS1_0_(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_c[1], c0_ddr4_dqs_c[((2*i0)+1)]);
                    short bidiDM1_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DM_n[1], c0_ddr4_dm_dbi_n[((2*i0)+1)]);
                `else
                    tran bidiDQS0_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_t[0], c0_ddr4_dqs_t[(2*i0)]);
                    tran bidiDQS0_0_(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_c[0], c0_ddr4_dqs_c[(2*i0)]);
                    tran bidiDM0_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DM_n[0], c0_ddr4_dm_dbi_n[(2*i0)]);
                    tran bidiDQS1_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_t[1], c0_ddr4_dqs_t[((2*i0)+1)]);
                    tran bidiDQS1_0_(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DQS_c[1], c0_ddr4_dqs_c[((2*i0)+1)]);
                    tran bidiDM1_0(iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+i0].DM_n[1], c0_ddr4_dm_dbi_n[((2*i0)+1)]);
                `endif
            end
        end
        for (r0 = 0; r0 < RANK_WIDTH; r0 = r0 + 1) begin: ADDR_R0
            for (i0 = 0; i0 < NUM_PHYSICAL_PARTS; i0 = i0 + 1) begin: ADDR_I0
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].BG      = c0_ddr4_bg_sdram[r0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].BA      = c0_ddr4_ba_sdram[r0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].ADDR    = DDR4_ADRMOD_c0[r0][13:0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].CS_n    = c0_ddr4_cs_n[r0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].CK      = {c0_ddr4_ck_t, c0_ddr4_ck_c};
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].ACT_n   = c0_ddr4_act_n;
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].RAS_n_A16 = DDR4_ADRMOD_c0[r0][16];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].CAS_n_A15 = DDR4_ADRMOD_c0[r0][15];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].WE_n_A14  = DDR4_ADRMOD_c0[r0][14];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].CKE     = c0_ddr4_cke[r0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].ODT     = c0_ddr4_odt[r0];
                assign iDDR4_0[(r0*NUM_PHYSICAL_PARTS)+ i0].RESET_n = c0_ddr4_reset_n;
            end
        end
    end
endgenerate

// --- Memory Model 1 for Interleaver 2 ---
generate
    if (DRAM_WIDTH == 16) begin: mem_model_1
        DDR4_if #(.CONFIGURED_DQ_BITS(16)) iDDR4_1[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();
        genvar r1, i1, s1;
        for (r1 = 0; r1 < RANK_WIDTH; r1 = r1 + 1) begin: memModels_R1
            for (i1 = 0; i1 < NUM_PHYSICAL_PARTS; i1 = i1 + 1) begin: memModel_I1
                ddr4_model #(.CONFIGURED_DQ_BITS(16), .CONFIGURED_DENSITY(CONFIGURED_DENSITY)) ddr4_model_inst_1(
                    .model_enable(model_enable_net), .iDDR4(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1])
                );
            end
        end
        for (r1 = 0; r1 < RANK_WIDTH; r1 = r1 + 1) begin: tranDQ_R1
            for (i1 = 0; i1 < NUM_PHYSICAL_PARTS; i1 = i1 + 1) begin: tranDQ_I1
                for (s1 = 0; s1 < 16; s1 = s1 + 1) begin: tranDQ_S1
                    `ifdef XILINX_SIMULATOR
                        short bidiDQ_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQ[s1], c1_ddr4_dq[s1+i1*16]);
                    `else
                        tran bidiDQ_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQ[s1], c1_ddr4_dq[s1+i1*16]);
                    `endif
                end
            end
        end
        for (r1 = 0; r1 < RANK_WIDTH; r1 = r1 + 1) begin: tranDQS_R1
            for (i1 = 0; i1 < NUM_PHYSICAL_PARTS; i1 = i1 + 1) begin: tranDQS_I1
                `ifdef XILINX_SIMULATOR
                    short bidiDQS0_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_t[0], c1_ddr4_dqs_t[(2*i1)]);
                    short bidiDQS0_1_(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_c[0], c1_ddr4_dqs_c[(2*i1)]);
                    short bidiDM0_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DM_n[0], c1_ddr4_dm_dbi_n[(2*i1)]);
                    short bidiDQS1_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_t[1], c1_ddr4_dqs_t[((2*i1)+1)]);
                    short bidiDQS1_1_(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_c[1], c1_ddr4_dqs_c[((2*i1)+1)]);
                    short bidiDM1_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DM_n[1], c1_ddr4_dm_dbi_n[((2*i1)+1)]);
                `else
                    tran bidiDQS0_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_t[0], c1_ddr4_dqs_t[(2*i1)]);
                    tran bidiDQS0_1_(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_c[0], c1_ddr4_dqs_c[(2*i1)]);
                    tran bidiDM0_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DM_n[0], c1_ddr4_dm_dbi_n[(2*i1)]);
                    tran bidiDQS1_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_t[1], c1_ddr4_dqs_t[((2*i1)+1)]);
                    tran bidiDQS1_1_(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DQS_c[1], c1_ddr4_dqs_c[((2*i1)+1)]);
                    tran bidiDM1_1(iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+i1].DM_n[1], c1_ddr4_dm_dbi_n[((2*i1)+1)]);
                `endif
            end
        end
        for (r1 = 0; r1 < RANK_WIDTH; r1 = r1 + 1) begin: ADDR_R1
            for (i1 = 0; i1 < NUM_PHYSICAL_PARTS; i1 = i1 + 1) begin: ADDR_I1
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].BG      = c1_ddr4_bg_sdram[r1];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].BA      = c1_ddr4_ba_sdram[r1];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].ADDR    = DDR4_ADRMOD_c1[r1][13:0];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].CS_n    = c1_ddr4_cs_n[r1];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].CK      = {c1_ddr4_ck_t, c1_ddr4_ck_c};
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].ACT_n   = c1_ddr4_act_n;
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].RAS_n_A16 = DDR4_ADRMOD_c1[r1][16];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].CAS_n_A15 = DDR4_ADRMOD_c1[r1][15];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].WE_n_A14  = DDR4_ADRMOD_c1[r1][14];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].CKE     = c1_ddr4_cke[r1];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].ODT     = c1_ddr4_odt[r1];
                assign iDDR4_1[(r1*NUM_PHYSICAL_PARTS)+ i1].RESET_n = c1_ddr4_reset_n;
            end
        end
    end
endgenerate

endmodule
