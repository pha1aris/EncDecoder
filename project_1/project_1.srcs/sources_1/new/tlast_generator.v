`timescale 1ns / 1ps

module tlast_generator #(
    parameter BLOCK_SIZE = 65025
) (
    input               aclk,
    input               reset,

    input      [7:0]    s_axis_tdata,
    input               s_axis_tvalid,
    input               s_axis_tlast,
    output              s_axis_tready, // 保持组合逻辑输出

    output reg [7:0]    m_axis_tdata,
    output reg          m_axis_tvalid,
    output reg          m_axis_tlast,
    input               m_axis_tready
);

    localparam COUNT_WIDTH = $clog2(BLOCK_SIZE);
    reg [COUNT_WIDTH-1:0] byte_count_reg; // 只需要一个计数器寄存器

    // 握手信号，现在可以直接在 clocked block 中使用
    wire can_transfer_now = s_axis_tvalid && s_axis_tready;

    // --- 合并后的时序逻辑块 ---
    always @(posedge aclk) begin
        if (reset) begin
            byte_count_reg  <= {COUNT_WIDTH{1'b0}};
            m_axis_tvalid   <= 1'b0;
            m_axis_tlast    <= 1'b0;
            m_axis_tdata    <= 8'd0;
        end else begin
            // --- 更新计数器 ---
            // 只有当实际发生数据传输时才更新计数器
            if (can_transfer_now) begin
                if (byte_count_reg == BLOCK_SIZE - 1) begin
                    byte_count_reg <= {COUNT_WIDTH{1'b0}}; // 复位
                end else begin
                    byte_count_reg <= byte_count_reg + 1'b1; // 递增
                end
            end
            // else: 如果没有传输 (上游无效或下游反压)，byte_count_reg 保持不变

            // --- 更新输出寄存器 ---
            // 同样，只有在下游准备好或当前输出无效时才更新输出寄存器
            if (m_axis_tready || ~m_axis_tvalid) begin
                 m_axis_tvalid  <= s_axis_tvalid;
                 m_axis_tdata   <= s_axis_tdata;
                 // TLAST 逻辑: 基于 *当前周期* 能否传输 以及 *当前周期* 的计数器值
                 m_axis_tlast   <= s_axis_tvalid && (byte_count_reg == BLOCK_SIZE - 1);
            end
            // else: 下游反压时，m_axis_tvalid, m_axis_tdata, m_axis_tlast 保持不变
        end
    end

    // --- s_axis_tready 仍然是组合逻辑 ---
    // s_axis_tready 的计算依赖于 m_axis_tvalid (寄存器输出) 和 m_axis_tready (输入)
    assign s_axis_tready = m_axis_tready || ~m_axis_tvalid;

endmodule