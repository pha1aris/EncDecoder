// 8bit → 32bit 打包器，同时把“符号块起始”对齐到 word 级
module sym8_to_word32_packer (
    input         clk,
    input         rst,             // 高有效复位

    // 来自预交织器的 8bit 流
    input         in_valid,
    input  [7:0]  in_data,
    input         in_block_start,  // 该 byte 是交织块的第一个符号

    output        in_ready,        // 目前我们做满速流水，恒为 1

    // 输出到 DDR 写 FIFO 的 32bit 流
    output reg        out_valid,
    output reg [31:0] out_data,
    output reg        out_block_start_word  // 该 word 含有新块的第一个符号
);

    reg [1:0]  byte_cnt;          // 0～3
    reg [31:0] buffer;
    reg        pending_blk_flag;  // 有“块起始”在当前 word 里尚未吐出

    assign in_ready = 1'b1;       // 当前版本不反压，跟 rs_interleaver_xpm 对上

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_cnt             <= 2'd0;
            buffer                  <= 32'd0;
            pending_blk_flag     <= 1'b0;
            out_valid            <= 1'b0;
            out_data             <= 32'd0;
            out_block_start_word <= 1'b0;
        end else begin
            out_valid            <= 1'b0;
            out_block_start_word <= 1'b0;

            // 一直吃 8bit 流
            if (in_valid) begin
                // 记录块起始：当前 word 内任意一个 byte 有 in_block_start，就记住
                if (in_block_start)
                    pending_blk_flag <= 1'b1;

                case (byte_cnt)
                    2'd0: begin
                        buffer[7:0]   <= in_data;
                        byte_cnt   <= 2'd1;
                    end
                    2'd1: begin
                        buffer[15:8]  <= in_data;
                        byte_cnt   <= 2'd2;
                    end
                    2'd2: begin
                        buffer[23:16] <= in_data;
                        byte_cnt   <= 2'd3;
                    end
                    2'd3: begin
                        buffer[31:24] <= in_data;
                        byte_cnt   <= 2'd0;

                        // 4 个 byte 收齐，输出一个 32bit word
                        out_valid  <= 1'b1;
                        out_data   <= {in_data, buffer[23:0]}; // 最后一字节刚写入

                        if (pending_blk_flag) begin
                            out_block_start_word <= 1'b1;
                            pending_blk_flag     <= 1'b0;
                        end
                    end
                endcase
            end
        end
    end

endmodule
