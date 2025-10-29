// 接受 DDR 交织器的 8-bit 流，转换为 AXI-Stream（带 TLAST）
// 设计要点：
// 1) 只在“块内或块起始”才接收（避免块外误采样）。
// 2) 输入端用 s_axis_tready 表达我们的“ready”；accept= valid & ready。
// 3) 输出端一次采样、在握手完成前保持 TDATA/TLAST/TVALID 不变（完整反压）。
// 4) 帧状态 in_frame 只在 accept 的那拍更新，保证与 data_i 对齐。

module tlast_generator_rx #(
    parameter integer BLOCK_SIZE = 65025 // 未参与控制，可选做一致性检查
)(
    input  wire        clk,
    input  wire        reset, // 高电平同步复位

    // --- 自定义 Slave 接口 (来自 DDR) ---
    input  wire [7:0]  data_i,
    input  wire        data_valid,
    input  wire        start_of_block, // 与 data_i 同拍有效
    input  wire        end_of_block,   // 与 data_i 同拍有效
    output wire        s_axis_tready,  // 我们的 ready（给 DDR 源）

    // --- AXI-Stream Master 接口 (去往 SID) ---
    output reg  [7:0]  m_axis_tdata,
    output reg         m_axis_tvalid,
    output reg         m_axis_tlast,
    input  wire        m_axis_tready
);

    // 是否处于帧内（块内）
    reg in_frame;

    // 下游是否允许我们“推进一拍”（我们这侧能否腾出寄存器）
    // 当 m_axis_tvalid=0（空闲）或 m_axis_tready=1（本拍会被消费）即可接受新数据
    wire can_accept = (~m_axis_tvalid) || m_axis_tready;

    // 仅在“块内或块起始”才把数据纳入流
    wire in_block_now = in_frame || start_of_block;

    // 输入握手（我们把 ready 明确给到上游）
    assign s_axis_tready = can_accept && in_block_now;

    // 真正“接收了一拍”的判定
    wire accept = data_valid && s_axis_tready;

    // 帧状态：只在 accept 的那拍依据标志更新，与 data_i 对齐
    always @(posedge clk) begin
        if (reset) begin
            in_frame <= 1'b0;
        end else if (accept) begin
            if (start_of_block) 
                in_frame <= 1'b1; // 支持背靠背块
            if (end_of_block)   
                in_frame <= 1'b0; // 单拍块时 SOB/EOB 可同拍
        end
    end

    // AXIS 输出寄存器：一次采样，直到握手完成前保持不变
    always @(posedge clk) begin
        if (reset) begin
            m_axis_tvalid <= 1'b0;
            m_axis_tdata  <= 8'd0;
            m_axis_tlast  <= 1'b0;
        end else begin
            if (accept) begin
                // 采样输入到输出寄存器，并拉高 TVALID
                m_axis_tdata  <= data_i;
                m_axis_tlast  <= end_of_block; // TLAST 与该拍 data 对齐
                m_axis_tvalid <= 1'b1;
            end else if (m_axis_tvalid && m_axis_tready) begin
                // 下游完成握手，且本拍没有新 accept，则拉低 TVALID
                m_axis_tvalid <= 1'b0;
            end
            // 反压时（TVALID=1 & TREADY=0）自动保持所有输出寄存不变 —— 满足 AXIS 要求
        end
    end

    // （可选）一致性检查：统计块长与 BLOCK_SIZE 是否匹配
    // 取消注释可启用——只做调试/断言用，不参与功能
    /*
    reg [$clog2(BLOCK_SIZE+1)-1:0] blk_cnt;
    always @(posedge clk) begin
        if (reset) begin
            blk_cnt <= 'd0;
        end else if (accept) begin
            blk_cnt <= start_of_block ? 1 : (blk_cnt + 1);
            if (end_of_block) begin
                // 这里可放断言：blk_cnt 应等于 BLOCK_SIZE
                // synopsys translate_off
                if (blk_cnt != BLOCK_SIZE)
                    $display("WARN: block length %0d != BLOCK_SIZE %0d", blk_cnt, BLOCK_SIZE);
                // synopsys translate_on
                blk_cnt <= 'd0;
            end
        end
    end
    */

endmodule
