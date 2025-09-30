//****************************************************************************************//
//
// Module Name: ddr4_rw (Fixed)
// Description: 基于突发读写的交织读写模块
//
//****************************************************************************************//
module ddr4_rw # (
    parameter integer BRUST_LEN = 8,
    parameter integer ADDR_WIDTH = 29,      // DDR4地址的地址位宽
    parameter integer CMD_WIDTH = 3,        // 指令位宽
    parameter integer MATRIX_COL = 8,      // 调试用较小值
    parameter integer MATRIX_ROW = 8       // 调试用较小值
)
(
    input                       ui_clk,                 // 用户时钟
    input                       ui_clk_sync_rst,        // 复位,高有效
    input                       init_calib_complete,    // DDR4初始化完成
    input                       app_rdy,                // MIG 命令接收准备好标致
    input                       app_wdf_rdy,            // MIG数据接收准备好
    input                       app_rd_data_valid,      // 读数据有效
    input  [8:0]                wfifo_rcount,           // 写端口FIFO中的数据量
    input  [8:0]                rfifo_wcount,           // 读端口FIFO中的数据量
    input  [7:0]                rd_bust_len,            // 从DDR4中读数据时的突发长度
    input  [7:0]                wr_bust_len,            // 往DDR4中写数据时的突发长度
    
    input                       ddr4_read_valid,        // DDR4读数据有效

    output                      rfifo_wren,             // 从ddr4读出数据的有效使能
    output [ADDR_WIDTH-1:0]     app_addr,               // [28:0] app_addr DDR4地址
    output                      app_en,                 // MIG IP发送命令使能
    output                      app_wdf_wren,           // 用户写数据使能
    output                      app_wdf_end,            // 突发写当前时钟最后一个数据
    output [CMD_WIDTH-1:0]      app_cmd                 // MIG IP核操作命令，读或者写
);

// localparameter define
localparam  IDLE      = 3'd0; // ddr初始化未完成，不进行任何操作状态
localparam  DDR_DONE  = 3'd1; // ddr初始化完成状态
localparam  WRITE     = 3'd2; // 写状态
localparam  READ      = 3'd3; // 读状态

parameter BRUST_TIME = (MATRIX_COL * MATRIX_ROW) / BRUST_LEN;

// reg define
reg                  read_start;
reg    [3:0]                state_cnt;              // 状态计数器
wire   [ADDR_WIDTH-1:0]     app_addr_rd;            // DDR4读地址
wire   [ADDR_WIDTH-1:0]     app_addr_wr;            // DDR4写地址
reg    [23:0]               rd_addr_cnt;            // 用户读地址计数
reg    [23:0]               wr_addr_cnt;            // 用户写地址计数
reg    [7:0]                rd_bust_len_a;          // 从DDR4中读数据时的突发长度
reg    [7:0]                wr_bust_len_a;          // 从DDR4中写数据时的突发长度

// wire define
wire                        rst_n;                  // 复位，低有效

reg [15:0] wr_row_addr;
reg [9:0]  wr_col_addr;

reg [15:0] rd_row_addr;
reg [9:0]  rd_col_addr;

// 地址跟踪，控制
reg [ADDR_WIDTH-1:0] app_addr_rd_r;
reg [ADDR_WIDTH-1:0] app_addr_wr_r;

//页面大小
localparam [28:0] PAGE_SIZE = MATRIX_COL * MATRIX_ROW * 8;
reg rd_end;
reg wr_end;
reg wr_addr_bank;
reg rd_addr_bank;
//乒乓操作中写入较慢

// 乒乓换页逻辑 - 修正阈值
wire wr_end_w = (app_addr_wr_r >= PAGE_SIZE) ? 1'b1 : 1'b0;
wire rd_end_w = (app_addr_rd_r >= PAGE_SIZE) ? 1'b1 : 1'b0;

//*****************************************************
//** main code
//*****************************************************

assign rst_n = ~ui_clk_sync_rst;
assign rfifo_wren =  app_rd_data_valid;
assign app_en = ((state_cnt == WRITE && (app_rdy && app_wdf_rdy))
                 ||(state_cnt == READ && app_rdy)) ? 1'b1:1'b0;
assign app_wdf_wren = (state_cnt == WRITE && (app_rdy && app_wdf_rdy)) ? 1'b1:1'b0;
assign app_wdf_end = app_wdf_wren;
assign app_cmd = (state_cnt == READ) ? 3'd1 :3'd0;
assign app_addr = (state_cnt == READ) ? app_addr_rd : app_addr_wr;


// assign app_addr_rd = {rd_row_addr, rd_col_addr, 2'b00, rd_addr_bank};
// assign app_addr_wr = {wr_row_addr, wr_col_addr, 2'b00, wr_addr_bank};


//快端处于的bank寄存器
reg fast_end_wbank;

//写入为慢端，写入正常写
always @(posedge ui_clk or negedge rst_n) begin
    if(~rst_n) begin
        fast_end_wbank <= 0;
    end else if(wr_end_w) begin
        fast_end_wbank <= ~fast_end_wbank;
    end
end

reg wr_end_w0;

always @(posedge ui_clk or negedge rst_n) begin
    if(~rst_n) begin
        wr_end_w0 <= 0;
    end else begin
        wr_end_w0 <= wr_end_w;
    end
end

//读出为快端，读出bank切换按照快端相反

reg slow_end_wbank0;
reg slend_wbank0_en;

reg slow_end_wbank1;
reg slend_wbank1_en;

always @(posedge ui_clk or negedge rst_n) begin
    if(~rst_n) begin
        slow_end_wbank0 <= 0;
        slend_wbank0_en <= 0;
        slow_end_wbank1 <= 0;
        slend_wbank1_en <= 0;
    end else begin
        if(wr_end_w0 && fast_end_wbank == 0)begin   //写端离开bank0-读bank0
            slow_end_wbank0 <= 1;
            slow_end_wbank1 <= 0;
            slend_wbank0_en <= 1;
        end
        else if(wr_end_w0 && fast_end_wbank == 1) begin //写端离开bank1-读bank1
            slow_end_wbank0 <= 0;
            slow_end_wbank1 <= 1;
            slend_wbank1_en <= 1;
        end
        else begin
            slend_wbank0_en <= 0;
            slend_wbank1_en <= 0;
        end
    end
end

wire fast_end_rbank;
wire slow_end_wbank;
assign fast_end_rbank = slow_end_wbank0;
assign slow_end_wbank = slow_end_wbank1;

// --- 最终修正的地址映射 (ROW_COLUMN_BANK 方案) ---
// 拼接结构: {ROW[15:0], COL[9:3], BA[1:0], BG[0], COL[2:0]}
assign app_addr_wr = {
    wr_row_addr,            // [28:13] <- 16位行地址
    wr_col_addr[9:3],       // [12:6]  <- 10位列地址的高7位
    {1'b0, slow_end_wbank}, // [5:4]   <- 1位乒乓信号控制BA[0]，BA[1]固定为0
    1'b0,                   // [3]     <- Bank Group固定为0
    wr_col_addr[2:0]        // [2:0]   <- 10位列地址的低3位 (用于突发偏移)
};

// 读取地址映射
assign app_addr_rd = {
    rd_row_addr,            // [28:13] <- 16位行地址
    rd_col_addr[9:3],       // [12:6]  <- 10位列地址的高7位
    {1'b0, fast_end_rbank}, // [5:4]   <- 1位乒乓信号控制BA[0]，BA[1]固定为0
    1'b0,                   // [3]     <- Bank Group固定为0
    rd_col_addr[2:0]        // [2:0]   <- 10位列地址的低3位
};

// 读bank切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)begin
        rd_addr_bank <= 1'b1;
    end else if(rd_end_w && read_start) begin
        rd_addr_bank <= ~rd_addr_bank;
    end
end
reg [1:0] rd_bank_cnt;
// 写bank切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)begin
        wr_addr_bank <= 1'b0;
        rd_bank_cnt <= 2'd0;
    end else if(wr_end_w) begin
        rd_bank_cnt <= rd_bank_cnt + 1'b1;
        wr_addr_bank <= ~wr_addr_bank;
    end else begin
        wr_addr_bank <= wr_addr_bank;
    end
end

reg rd_begin;
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)begin
        rd_begin <= 0;
    end else if(wr_end_w && rd_bank_cnt == 2) begin
        rd_begin <= 1'b1;
    end
end

// 对异步信号进行打拍处理
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)begin
        rd_bust_len_a     <= 'd0;
        wr_bust_len_a     <= 'd0;
    end else begin
        rd_bust_len_a <= rd_bust_len;
        wr_bust_len_a <= wr_bust_len;
    end
end

// DDR4读写逻辑实现
always @(posedge ui_clk or negedge rst_n) begin
    if(~rst_n) begin
        state_cnt        <= IDLE;
        wr_addr_cnt      <= 24'd0;
        rd_addr_cnt      <= 24'd0;
        rd_end           <= 1'b0;
        wr_end           <= 1'b0;
        // 写地址
        wr_row_addr      <= 'd0;
        wr_col_addr      <= 'd0;
        // 读地址
        rd_row_addr      <= 'd0;
        rd_col_addr      <= 'd0;
        read_start       <= 1'b0;
        app_addr_rd_r    <= 'd0;
        app_addr_wr_r    <= 'd0;
    end
    else begin
        case(state_cnt)

            IDLE:begin
                if(init_calib_complete)
                    state_cnt <= DDR_DONE;
                else
                    state_cnt <= IDLE;
            end

            DDR_DONE:begin
                // 当写到一个完整页面时，切换bank并开始读取
                if(app_addr_wr_r >= PAGE_SIZE)begin
                    app_addr_wr_r <= 'd0;
                    state_cnt <= DDR_DONE;
                    wr_col_addr <= 'd0;
                    wr_row_addr <= 'd0;
                    read_start <= 1'b1;
                    //pingpang
                    rd_end <= 1'b1;
                end
                // 当读完一个完整页面时，重置读地址
                else if(app_addr_rd_r >= PAGE_SIZE && read_start)begin
                    app_addr_rd_r <= 'd0;
                    state_cnt <= DDR_DONE;
                    rd_addr_cnt <= 24'd0;
                    rd_col_addr <= 'd0;
                    rd_row_addr <= 'd0;
                    //pingpang 
                    rd_end <= 1'b1;
                end
                // 写条件：FIFO有足够数据进行突发
                else if(wfifo_rcount >= wr_bust_len_a)begin
                    state_cnt <= WRITE;
                    wr_addr_cnt <= 24'd0;
                end
                // 读条件：已写入一块数据并FIFO有足够空间且已经开始读取
                else if(rfifo_wcount <= ('d512 - rd_bust_len_a) &&
                        read_start && ddr4_read_valid && 
                        (wr_end_w0 && fast_end_wbank == 0) ||
                        (wr_end_w0 && fast_end_wbank == 1) )begin
                    state_cnt <= READ;
                    rd_addr_cnt <= 24'd0;
                end
                else begin
                    state_cnt <= state_cnt;
                    wr_addr_cnt  <= 24'd0;
                    rd_addr_cnt  <= 24'd0;

                    //pingpang
                    rd_end <= 1'b0;
                    wr_end <= 1'b0;
                end
            end

            WRITE: begin
                // 等待MIG准备好接收命令和数据
                if (app_rdy && app_wdf_rdy) begin
                    // 增加页面事务计数器
                    app_addr_wr_r <= app_addr_wr_r + 8;

                    if (wr_col_addr + 8 >= MATRIX_COL * 8) begin
                        wr_col_addr <= 0;
                        if (wr_row_addr >= MATRIX_ROW - 1) begin
                            wr_row_addr <= 0;
                        end else begin
                            wr_row_addr <= wr_row_addr + 1;
                        end
                    end else begin
                        wr_col_addr <= wr_col_addr + 8;
                    end

                    // 检查突发是否完成
                    if (wr_addr_cnt == (wr_bust_len_a - 1)) begin//wr_addr_cnt达到突发长度
                        state_cnt   <= DDR_DONE;
                        wr_addr_cnt <= 'd0; // 为下次突发复位计数器
                    end else begin
                        wr_addr_cnt <= wr_addr_cnt + 1'd1;
                    end

                end
            end

            READ: begin
                // 等待MIG准备好接收命令
                if (app_rdy) begin
                    // 增加页面事务计数器
                    app_addr_rd_r <= app_addr_rd_r + 8;

                    if (rd_row_addr >= (MATRIX_ROW - 1)) begin
                        rd_row_addr <= 'd0;

                        // 检查 col 地址是否越界
                        if (rd_col_addr + 8 >= MATRIX_COL * 8) begin
                            rd_col_addr <= 'd0; // 或设置结束标志
                        end else begin
                            rd_col_addr <= rd_col_addr + 8;
                        end

                    end else begin
                        rd_row_addr <= rd_row_addr + 1'b1;
                    end

                    // 检查突发是否完成
                    if (rd_addr_cnt == (rd_bust_len_a - 1)) begin
                        state_cnt   <= DDR_DONE;
                        rd_addr_cnt <= 'd0; // 为下次突发复位计数器
                    end else begin
                        rd_addr_cnt <= rd_addr_cnt + 1'd1;
                    end
                end
            end

            default:begin
                state_cnt    <= IDLE;
                wr_addr_cnt  <= 24'd0;
                rd_addr_cnt  <= 24'd0;
            end
        endcase
    end
end

//**********************************************************************************************************
//** >>>>>> 新增代码：用于文件操作 与调试<<<<<<
//**********************************************************************************************************
// integer wr_file_handle; // 写地址文件的句柄
// integer rd_file_handle; // 读地址文件的句柄

// initial begin
//     wr_file_handle = $fopen("wr_addr/write_addresses.txt", "w");
//     if (wr_file_handle == 0 ) begin
//         $display("Error: Could not open wr address log files.");
//         $finish;
//     end
// end

// initial begin
//     rd_file_handle = $fopen("wr_addr/read_addresses.txt", "w");
//     // 检查文件是否成功打开
//     if (rd_file_handle == 0) begin
//         $display("Error: Could not open rd address log files.");
//         $finish;
//     end
// end

// always @(posedge ui_clk) begin
//     if (state_cnt == WRITE && app_rdy && app_wdf_rdy) begin
//         $fdisplay(wr_file_handle, "Time: %0t, Write Address: %h", $time, app_addr_wr);
//     end
// end

// always @(posedge ui_clk) begin
//     if (state_cnt == READ && app_rdy) begin
//         $fdisplay(rd_file_handle, "Time: %0t, Read Address: %h", $time, app_addr_rd);
//     end
// end

// reg [110:0] state_asii;

// always @(*) begin
//     case(state_cnt)
//         3'd0:state_asii = "IDLE";
//         3'd1:state_asii = "DDR_DONE";
//         3'd2:state_asii = "WRITE";
//         3'd3:state_asii = "READ";
//     endcase
// end

// //-------------------------------------------
// //-------------bank pingpang 检查
// //-------------------------------------------
// wire bank_txt;
// assign bank_txt = slow_end_wbank1;

// integer write_addr;
// integer read_addr;

// initial begin
//     write_addr = $fopen("write_bank_address.txt","w");
//     if (write_addr == 0) begin
//         $display("Error: Could not open write_addr files.");
//         $finish;
//     end
// end

// initial begin
//     read_addr = $fopen("read_bank_address.txt","w");
//     if (read_addr == 0) begin
//         $display("Error: Could not open read_addr files.");
//         $finish;
//     end
// end

// always @(posedge ui_clk) begin
//     if(state_cnt == WRITE && app_rdy && app_wdf_rdy)begin
//         $fdisplay(write_addr, "Write Address: %h", {wr_row_addr, wr_col_addr, 2'b00, slow_end_wbank1});
//     end
// end

// always @(posedge ui_clk) begin
//     if(state_cnt == READ && app_rdy)begin
//         $fdisplay(read_addr, "Read Address: %h", {rd_row_addr, rd_col_addr, 2'b00, ~slow_end_wbank1});
//     end
// end

endmodule
