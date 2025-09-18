module cnt32_gen (
    input  wire       wr_clk,
    input  wire       rst,
    input  wire       encoder_fifo_wrrdy, // 下游FIFO就绪
    output reg [31:0] data_o,
    output reg        data_valid
);

    reg [7:0]  byte_cnt;   // 1~229
    reg [1:0]  pack_cnt;   // 累计到4个字节
    reg [31:0] shift_buf;  // 拼接缓冲

    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            byte_cnt   <= 8'd1;
            pack_cnt   <= 2'd0;
            shift_buf  <= 32'd0;
            data_o     <= 32'd0;
            data_valid <= 1'b0;
        end else if (encoder_fifo_wrrdy) begin
            // 拼接字节：最高字节先放
            shift_buf <= {shift_buf[23:0], byte_cnt};

            if (pack_cnt == 2'd3) begin
                // 累计到4字节 -> 输出32位
                data_o     <= {shift_buf[23:0], byte_cnt};
                data_valid <= 1'b1;
                pack_cnt   <= 2'd0;
            end else begin
                data_valid <= 1'b0;
                pack_cnt   <= pack_cnt + 1'b1;
            end

            // 递增byte计数，满229回到1
            if (byte_cnt == 8'd229)
                byte_cnt <= 8'd1;
            else
                byte_cnt <= byte_cnt + 1'b1;
        end else begin
            data_valid <= 1'b0;
        end
    end

endmodule
