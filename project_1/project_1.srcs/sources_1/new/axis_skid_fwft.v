`timescale 1ns/1ps

module axis_skid_fwft #(
    parameter integer WIDTH = 32
)(
    input  wire             clk,
    input  wire             rst,     // 同步高有效复位

    // ===== Source (FWFT FIFO side) =====
    input  wire [WIDTH-1:0] src_data,
    input  wire             src_valid,
    output reg              src_rd_en,  // 连接到 FIFO rd_en（打一拍即可）

    // ===== Sink (AXIS-like) =====
    output wire [WIDTH-1:0] m_axis_tdata,
    output wire             m_axis_tvalid,
    input  wire             m_axis_tready
);

    reg             hold_v;
    reg [WIDTH-1:0] hold_d;

    // 输出：hold 优先
    assign m_axis_tvalid = hold_v ? 1'b1 : src_valid;
    assign m_axis_tdata  = hold_v ? hold_d : src_data;

    // 下游是否发生握手（我们确实“交付”了一个 word）
    wire out_fire = m_axis_tvalid && m_axis_tready;

    // 我们当前输出来自 hold 还是 src
    wire out_from_hold = hold_v;

    always @(posedge clk) begin
        if (rst) begin
            hold_v    <= 1'b0;
            hold_d    <= {WIDTH{1'b0}};
            src_rd_en <= 1'b0;
        end else begin
            src_rd_en <= 1'b0;

            // 1) 若下游不 ready 且当前输出来自 src（hold 空），需要把 src 缓存到 hold
            //    并 rd_en 弹出 FIFO（避免未来继续看到同一个 head）
            if (!hold_v && src_valid && !m_axis_tready) begin
                hold_d    <= src_data;   // 缓存当前 head
                hold_v    <= 1'b1;
                src_rd_en <= 1'b1;       // 弹出 FIFO，使下一条成为新的 head（但我们本拍不使用它）
            end

            // 2) 若下游握手发生：
            //    - 如果输出来自 hold：我们消耗掉 hold
            //    - 如果输出来自 src：我们消耗掉 FIFO head，需要 rd_en
            if (out_fire) begin
                if (out_from_hold) begin
                    // 吃掉 hold
                    hold_v <= 1'b0;
                    // 这里不要试图同拍把“下一条 src”塞回 hold
                    // 如果下拍下游仍不 ready，会走(1)分支把新的 head 再缓存
                end else begin
                    // 直通消耗 src head
                    if (src_valid) begin
                        src_rd_en <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
