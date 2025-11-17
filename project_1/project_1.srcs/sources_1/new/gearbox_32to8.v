module gearbox_32to8 (
    input              clk,
    input              rst,

    input      [31:0]  in_data,
    input              in_valid,

    output reg [7:0]   out_data,
    output reg         out_valid
);
    reg [31:0] shreg;
    reg [1:0]  byte_idx;
    reg        holding;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shreg    <= 32'd0;
            byte_idx <= 2'd0;
            holding  <= 1'b0;
            out_data <= 8'd0;
            out_valid<= 1'b0;
        end else begin
            out_valid <= 1'b0;

            // 如果当前没有在输出 4 个字节，则等待新的 in_valid
            if (!holding) begin
                if (in_valid) begin
                    shreg    <= in_data;
                    byte_idx <= 2'd0;
                    holding  <= 1'b1;

                    out_data  <= in_data[7:0];
                    out_valid <= 1'b1;
                    byte_idx  <= 2'd1;
                end
            end else begin
                // 正在从 shreg 里依次吐出 4 个字节
                case (byte_idx)
                    2'd1: begin out_data <= shreg[15:8];  out_valid <= 1'b1; byte_idx <= 2'd2; end
                    2'd2: begin out_data <= shreg[23:16]; out_valid <= 1'b1; byte_idx <= 2'd3; end
                    2'd3: begin out_data <= shreg[31:24]; out_valid <= 1'b1; byte_idx <= 2'd0; holding <= 1'b0; end
                endcase
            end
        end
    end
endmodule
