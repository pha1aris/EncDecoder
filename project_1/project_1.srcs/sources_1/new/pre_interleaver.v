// 
// 预交织器，接受上游32位数据使用round robin成分散到4个码字(4个bram中)
// 码字长度255bytes + 1 填充到256bytes 再将这4个码字按序发送
// 
module pre_interleaver #(
    parameter CODEWORD_SIZE     = 64,  // 每个码字长度 (32-bit words)
    parameter NUM_CODEWORDS     = 4    // 预交织4个码字
)(
    input  wire         clk,
    input  wire         rst,

    // Upstream interface (32-bit stream)
    input  wire [31:0]  s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    output wire         s_axis_input_tready,

    // Downstream interface (32-bit stream, to DDR writer)
    output reg  [31:0]  m_axis_output_tdata,
    output reg          m_axis_output_tvalid,
    input  wire         m_axis_output_tready
);

reg [1:0] input_cnt;
// 每个 BRAM 独立写地址 bram最大深度64
reg [5:0] wr_addr0, wr_addr1, wr_addr2, wr_addr3;
wire use_bram0,use_bram1,use_bram2,use_bram3;
wire wea0,wea1,wea2,wea3;
assign use_bram0 = (input_cnt == 0);
assign use_bram1 = (input_cnt == 1);
assign use_bram2 = (input_cnt == 2);
assign use_bram3 = (input_cnt == 3);

assign wea0 = (s_axis_input_tvalid && s_axis_input_tready && use_bram0);
assign wea1 = (s_axis_input_tvalid && s_axis_input_tready && use_bram1);
assign wea2 = (s_axis_input_tvalid && s_axis_input_tready && use_bram2);
assign wea3 = (s_axis_input_tvalid && s_axis_input_tready && use_bram3);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        input_cnt <= 0;
    end else if(s_axis_input_tvalid && s_axis_input_tready) begin
        if(input_cnt == 'd3)begin
            input_cnt <= 'd0;
        end else begin
            input_cnt <= input_cnt + 1;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        wr_addr0 <= 'd0;
        wr_addr1 <= 'd0;
        wr_addr2 <= 'd0;
        wr_addr3 <= 'd0;
    end else if(s_axis_input_tvalid && s_axis_input_tready) begin
        case(input_cnt)
            2'd0:wr_addr0 <= wr_addr0 + 1;
            2'd1:wr_addr1 <= wr_addr1 + 1;
            2'd2:wr_addr2 <= wr_addr2 + 1;
            2'd3:wr_addr3 <= wr_addr3 + 1;   
        endcase
    end
end

reg bram_full3;
reg clear_flag;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        bram_full3 <= 1'b0;
    end else begin
        if(wea3 && (wr_addr3 == CODEWORD_SIZE-1)) begin
            bram_full3 <= 1'b1;   // 写满保持
        end else if(clear_flag) begin
            bram_full3 <= 1'b0;   // 读完后清零
        end
    end
end

//从四个bram中依次读出数据
reg [1:0] rd_bram_sel;
reg [5:0] rd_addr;
reg rd_finish;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        rd_addr <= 'd0;
        rd_bram_sel <= 'd0;
        rd_finish <= 0;
    end else if(bram_full3) begin //所有bram写入完成
        if(rd_addr == CODEWORD_SIZE-1)begin
            rd_addr <= 'd0;
            if(rd_bram_sel == 'd3)begin
                rd_bram_sel <= 'd0;
                rd_finish <= 1;
            end else begin 
                rd_bram_sel <= rd_bram_sel + 1;
            end 
        end else begin
            rd_addr <= rd_addr + 1'b1;
        end
    end
end

wire [31:0] doutb0,doutb1,doutb2,doutb3;


    always @(*) begin
        case(rd_bram_sel)
            3'd0: m_axis_output_tdata <= doutb0;
            3'd1: m_axis_output_tdata <= doutb1;
            3'd2: m_axis_output_tdata <= doutb2;
            3'd3: m_axis_output_tdata <= doutb3;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            clear_flag <= 1'b0;
        end else if(rd_finish) begin
            clear_flag <= 1'b1;
        end else begin
            clear_flag <= 1'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            m_axis_output_tvalid <= 1'b0;
        end else if(bram_full3) begin
            m_axis_output_tvalid <= 1'b1;
        end else if(rd_finish) begin
            m_axis_output_tvalid <= 1'b0;
        end
    end



//  round robin方式存放在四个bram中 深度64
// A端口只写 B端口只读
    blk_mem_gen_0   BRAM0 (
      .clka             (clk),    // input wire clka
      .ena              (1),      // input wire ena
      .wea              (wea0),      // input wire [0 : 0] wea
      .addra            (wr_addr0),  // input wire [5 : 0] addra
      .dina             (dina),    // input wire [31 : 0] dina
      .douta            (douta),  // output wire [31 : 0] douta

      .clkb             (clk),    // input wire clkb
      .enb              (1),      // input wire enb
      .web              (0),      // input wire [0 : 0] web
      .addrb            (rd_addr),  // input wire [5 : 0] addrb
      .dinb             (32'd0),    // input wire [31 : 0] dinb
      .doutb            (doutb0)  // output wire [31 : 0] doutb
    );

    blk_mem_gen_0 BRAM1 (
      .clka             (clk),    // input wire clka
      .ena              (1),      // input wire ena
      .wea              (wea1),      // input wire [0 : 0] wea
      .addra            (wr_addr1),  // input wire [5 : 0] addra
      .dina             (dina),    // input wire [31 : 0] dina
      .douta            (douta),  // output wire [31 : 0] douta

      .clkb             (clk),    // input wire clkb
      .enb              (1),      // input wire enb
      .web              (0),      // input wire [0 : 0] web
      .addrb            (rd_addr),  // input wire [5 : 0] addrb
      .dinb             (32'd0),    // input wire [31 : 0] dinb
      .doutb            (doutb1)  // output wire [31 : 0] doutb
    );

    blk_mem_gen_0 BRAM2 (
      .clka             (clk),    // input wire clka
      .ena              (1),      // input wire ena
      .wea              (wea2),      // input wire [0 : 0] wea
      .addra            (wr_addr2),  // input wire [5 : 0] addra
      .dina             (dina),    // input wire [31 : 0] dina
      .douta            (douta),  // output wire [31 : 0] douta

      .clkb             (clk),    // input wire clkb
      .enb              (1),      // input wire enb
      .web              (0),      // input wire [0 : 0] web
      .addrb            (rd_addr),  // input wire [5 : 0] addrb
      .dinb             (32'd0),    // input wire [31 : 0] dinb
      .doutb            (doutb2)  // output wire [31 : 0] doutb
    );

    blk_mem_gen_0 BRAM3 (
      .clka             (clk),    // input wire clka
      .ena              (1),      // input wire ena
      .wea              (wea3),      // input wire [0 : 0] wea
      .addra            (wr_addr3),  // input wire [5 : 0] addra
      .dina             (dina),    // input wire [31 : 0] dina
      .douta            (douta),  // output wire [31 : 0] douta

      .clkb             (clk),    // input wire clkb
      .enb              (1),      // input wire enb
      .web              (0),      // input wire [0 : 0] web
      .addrb            (rd_addr),  // input wire [5 : 0] addrb
      .dinb             (32'd0),    // input wire [31 : 0] dinb
      .doutb            (doutb3)  // output wire [31 : 0] doutb
    );


endmodule
