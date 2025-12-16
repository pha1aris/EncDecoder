// 每 4 个 8bit 字节打成一个 32bit word，同时把块起始标志 OR 到这个 word 上。
module gearbox_8to32_bs (
    input             clk,
    input             rst,

    input      [7:0]  in_data,
    input             in_valid,
    input             in_block_start,   
    output wire       in_ready,          

    input             out_ready,         
    output reg [31:0] out_data,
    output reg        out_valid,
    output reg        out_block_start   
);

    reg [1:0]  byte_cnt;
    reg [31:0] word_reg;
    reg        word_has_block_start;
    assign in_ready   = out_ready; 
    wire allow_shift  = in_valid && in_ready;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_cnt             <= 2'd0;
            word_reg             <= 32'd0;
            word_has_block_start <= 1'b0;
            out_data             <= 32'd0;
            out_valid            <= 1'b0;
            out_block_start      <= 1'b0;
        end else begin
            
            if (out_valid && out_ready) begin
                out_valid <= 1'b0;
            end

            if (allow_shift) begin
                word_has_block_start <= word_has_block_start | in_block_start;

                case (byte_cnt)
                    2'd0: word_reg[7:0]   <= in_data;
                    2'd1: word_reg[15:8]  <= in_data;
                    2'd2: word_reg[23:16] <= in_data;
                    2'd3: word_reg[31:24] <= in_data; 
                endcase

                if (byte_cnt == 2'd3) begin
                    out_data        <= {in_data, word_reg[23:0]}; // MSB 在最后
                    out_valid       <= 1'b1;
                    out_block_start <= word_has_block_start | in_block_start;

                    byte_cnt             <= 2'd0;
                    word_has_block_start <= 1'b0;
                end else begin
                    byte_cnt <= byte_cnt + 1'b1;
                end
            end
        end
    end

endmodule