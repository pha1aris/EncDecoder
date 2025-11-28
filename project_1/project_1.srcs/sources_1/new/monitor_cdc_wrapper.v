`timescale 1ns / 1ps

module monitor_cdc_wrapper #(
    parameter DATA_WIDTH = 224 // 32bit * 7个寄存器 = 224
)(
    // --- 源时钟域 (Fast Domain: rx_usr_clk) ---
    input  wire                  src_clk,
    input  wire                  src_rst,      // 可选
    input  wire [DATA_WIDTH-1:0] src_data_in,  // 正在跳变的实时数据

    // --- 目的时钟域 (Slow Domain: s_axi_aclk) ---
    input  wire                  dest_clk,
    input  wire                  dest_capture_req, // 来自 AXI 寄存器的“捕获”请求 (电平信号)
    output wire [DATA_WIDTH-1:0] dest_data_out     // 输出给 AXI Slave 的稳定数据
);
    wire src_capture_req_sync;    
    reg [DATA_WIDTH-1:0] shadow_reg;

    xpm_cdc_single #(
        .DEST_SYNC_FF  (3),   // 同步级数
        .SRC_INPUT_REG (0)
    ) u_ctrl_sync(
        .src_clk       (dest_clk),
        .src_in        (dest_capture_req),
        .dest_clk      (src_clk),
        .dest_out      (src_capture_req_sync)
    );

    always @(posedge src_clk) begin
        if (src_rst) begin
            shadow_reg <= 0;
        end else begin
            if (!src_capture_req_sync) begin
                shadow_reg <= src_data_in;
            end
        end
    end

    xpm_cdc_array_single #(
        .DEST_SYNC_FF   (3),
        .SRC_INPUT_REG  (0),
        .WIDTH          (DATA_WIDTH)
    ) u_data_sync(
        .src_clk        (src_clk),
        .src_in         (shadow_reg),
        .dest_clk       (dest_clk),
        .dest_out       (dest_data_out)
    );

endmodule