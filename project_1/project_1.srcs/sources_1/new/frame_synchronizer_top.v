`timescale 1ns/1ps
module frame_synchronizer_top #(
    parameter PARALLEL          = 32,      // 数据总线位宽
    parameter MASK_LEN          = 192,     // 帧同步码 (ASM) 掩码长度 (bits)
    parameter ASM_LEN           = 192,     // 帧同步码 (ASM) 总长度 (bits)
    parameter TOLERANCE         = 0,       // ASM 匹配允许的最大误码
    parameter FRAME_LEN_BYTE    = 64,      // 完整数据帧的总长度 (bytes)
    parameter M_VERIFY          = 2,       // 连续 M 帧命中进入 LOCK
    parameter N_PROTECT         = 2,       // 连续 N 帧丢失从 LOCK 跌到 PROTECT
    parameter PIPELINE_LATENCY  = 4,        // 匹配引擎内部流水线延迟 
    parameter FRAME_CNT_W       = 16       // fcnt4 位宽 与帧长度相应修改
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [PARALLEL-1:0]    din,
    input  wire                   din_valid,
    input  wire [MASK_LEN-1:0]    asm_pattern,
    input  wire [MASK_LEN-1:0]    asm_mask,

    output reg                    frame_lock,
    output reg                    frame_sync_found,
    output reg  [4:0]             wnumber_dec,
    output reg  [3:0]             flocation,
    output reg                    sof,            // 帧首脉冲
    output reg  [PARALLEL-1:0]    dout,
    output reg                    dout_valid
);
  // ---------------- Const ----------------
  localparam integer BYTES_PER_CYCLE       = PARALLEL/8;
  localparam integer HEADER_LEN_WORDS      = ((ASM_LEN/8)+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE; // 192b@32b=6
  localparam integer TOTAL_WORDS_PER_FRAME = (FRAME_LEN_BYTE+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE;
  localparam integer HDR_CNT_W             = (HEADER_LEN_WORDS<=1)?1:$clog2(HEADER_LEN_WORDS+1);
  localparam integer HEADER_LEN_BYTES      = (ASM_LEN/8);

  // 有效延迟 = 引擎内部 + 顶层打一拍(wflag_delayed)
  localparam integer CORE_LATENCY        = PIPELINE_LATENCY;
  localparam integer EXTRA_REG_LATENCY   = 1;
  localparam integer EFFECTIVE_LATENCY   = CORE_LATENCY + EXTRA_REG_LATENCY;

  localparam [1:0] S_SEARCH  = 2'b00;
  localparam [1:0] S_VERIFY  = 2'b01;
  localparam [1:0] S_LOCK    = 2'b10;
  localparam [1:0] S_PROTECT = 2'b11;

  reg [1:0] state, next_state;

  // ---------------- Match engine ----------------
  wire [PARALLEL-1:0] wflag_bits;          // 引擎结果位向量
  wire [PARALLEL-1:0] wflag_reg_out_wire;  // 调试直连
  wire                wflag_valid;         // 引擎末级有效位

  frame_synchronizer_pipelined #(
      .PARALLEL   (PARALLEL),
      .MASK_LEN   (MASK_LEN),
      .ASM_LEN    (ASM_LEN),
      .TOLERANCE  (TOLERANCE)
  ) u_pipelined (
      .clk                (clk),
      .rst_n              (rst_n),
      .din                (din),
      .din_valid          (din_valid),
      .asm_pattern        (asm_pattern),
      .asm_mask           (asm_mask),
      .wflag_reg_out_wire (wflag_reg_out_wire),
      .wflag_reg_out      (wflag_bits),     // 32bit 匹配位向量
      .wflag_valid        (wflag_valid)     // 1bit 末级有效位
  );

  // 顶层再打一拍（形成 EXTRA_REG_LATENCY=1），并让 valid 同步打一拍
  reg  [PARALLEL-1:0] wflag_delayed;
  reg                 wflag_valid_d;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wflag_delayed <= {PARALLEL{1'b0}};
      wflag_valid_d <= 1'b0;
    end else begin
      wflag_delayed <= wflag_bits;
      wflag_valid_d <= wflag_valid;
    end
  end

  // ---------------- Helpers for FSM ----------------
  wire        detector_data_valid = wflag_valid_d;           // 用引擎给出的末级 valid（已对齐）
  wire        found_any           = |wflag_delayed;
  wire        found_pulse         = detector_data_valid && found_any;

  function [4:0] priority_low_idx;
    input [PARALLEL-1:0] vec;
    integer j; reg found; reg [4:0] idx;
    begin
      idx = 5'd0; found = 1'b0;
      for (j=0; j<PARALLEL; j=j+1)
        if (vec[j] && !found) begin
          idx = j[4:0]; found = 1'b1;
        end
      priority_low_idx = idx;
    end
  endfunction
  wire [4:0] found_idx_latch = priority_low_idx(wflag_delayed);

  reg hit_in_frame;

  // ---------------- Input-side frame counter (for FSM only) ----------------
  reg  [FRAME_CNT_W-1:0] fcnt4;
  wire [FRAME_CNT_W-1:0] fcnt4_plus      = fcnt4 + BYTES_PER_CYCLE;
  wire        will_wrap       = din_valid && (fcnt4_plus >= FRAME_LEN_BYTE);
  wire        frame_end_raw   = will_wrap;
  wire        is_at_phase     = (fcnt4 == fcnt4_phase);
  wire        frame_start_raw = din_valid && is_at_phase;

  // 帧头期（原始）信号（均受 din_valid 门控）
  wire        in_header_raw   = din_valid && (fcnt4 < HEADER_LEN_BYTES);
  wire        header_end_raw  = din_valid && (fcnt4 == (HEADER_LEN_BYTES - BYTES_PER_CYCLE)); // 24-4=20

  // “下一帧首” = frame_end_raw 的下一拍
  // always @(posedge clk or negedge rst_n) begin
  //   if (!rst_n) frame_start_raw <= 1'b0;
  //   else        frame_start_raw <= frame_end_raw;
  // end

  // 延迟所有控制信号 EFFECTIVE_LATENCY 拍（不再派生 detector_data_valid）
  reg [EFFECTIVE_LATENCY-1:0] start_shift, end_shift, in_header_shift, header_end_shift;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_shift      <= {EFFECTIVE_LATENCY{1'b0}};
      end_shift        <= {EFFECTIVE_LATENCY{1'b0}};
      in_header_shift  <= {EFFECTIVE_LATENCY{1'b0}};
      header_end_shift <= {EFFECTIVE_LATENCY{1'b0}};
    end else begin
      start_shift      <= {start_shift     [EFFECTIVE_LATENCY-2:0], frame_start_raw};
      end_shift        <= {end_shift       [EFFECTIVE_LATENCY-2:0], frame_end_raw};
      in_header_shift  <= {in_header_shift [EFFECTIVE_LATENCY-2:0], in_header_raw};
      header_end_shift <= {header_end_shift[EFFECTIVE_LATENCY-2:0], header_end_raw};
    end
  end

  // 先取“未门控”的延迟输出，再用 detector_data_valid 统一门控，防止帧间空档误脉冲
  wire frame_start_ungated        = start_shift     [EFFECTIVE_LATENCY-1];
  wire frame_end_ungated          = end_shift       [EFFECTIVE_LATENCY-1];
  wire in_header_delayed_ungated  = in_header_shift [EFFECTIVE_LATENCY-1];
  wire header_end_delayed_ungated = header_end_shift[EFFECTIVE_LATENCY-1];

  wire frame_start        = frame_start_ungated        && detector_data_valid;
  wire frame_end          = frame_end_ungated          && detector_data_valid;
  wire in_header_delayed  = in_header_delayed_ungated  && detector_data_valid;
  wire header_end_delayed = header_end_delayed_ungated && detector_data_valid;

  // ================ 相位寄存器 =================
  reg  [FRAME_CNT_W-1:0] fcnt4_phase;
  wire [FRAME_CNT_W-1:0] fcnt4_phase_next =
      (state == S_SEARCH && next_state == S_VERIFY) ? { {(FRAME_CNT_W-2){1'b0}}, found_idx_latch[4:3] } :
      (next_state == S_SEARCH)                       ? {FRAME_CNT_W{1'b0}} :
                                                       fcnt4_phase;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fcnt4_phase <= {FRAME_CNT_W{1'b0}};
    end else begin
      fcnt4_phase <= fcnt4_phase_next;
    end
  end

  // 计数器：wrap > 帧首加载 > 正常计数
  wire entering_lock = (state!=S_LOCK) && (next_state==S_LOCK);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fcnt4 <= {FRAME_CNT_W{1'b0}};
    end else begin 
      if (state == S_SEARCH && next_state == S_VERIFY) begin
        // 加载下一拍的值，即 (当前相位 + 1个步长)
        fcnt4 <= fcnt4_phase_next + BYTES_PER_CYCLE; 
      end 
      // 优先级 2: Wrap
      else if (will_wrap) begin
        fcnt4 <= fcnt4_phase;   
      end 
      // 优先级 3: 计数
      else if (din_valid) begin
        fcnt4 <= fcnt4_plus;
      end
    end
  end

  // “本帧是否命中过”标志
  reg  prev_hit;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      hit_in_frame <= 1'b0;
      prev_hit     <= 1'b0;
    end else begin
      if (frame_start) begin
        prev_hit     <= hit_in_frame;
        hit_in_frame <= 1'b0;
      end else if (found_pulse && in_header_delayed) begin
        hit_in_frame <= 1'b1;
      end else if (found_pulse && state == S_SEARCH) begin
        hit_in_frame <= 1'b1;
      end
    end
  end

  // ---------------- FIFO & 输出门控 ----------------
  wire wr_allowed     = 1'b1;
  wire wr_ok = din_valid && !wr_rst_busy && wr_allowed && !full; //必须检查 !full
  // wire wr_ok          = din_valid && !wr_rst_busy && wr_allowed;
// ========= 写口帧首打标 =========
  reg start_pending;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_pending <= 1'b0;
    end else begin
      // 进入 LOCK/PROTECT 后 FIFO 被 srst，同步清理 pending
      if (entering_lock_d1 || entering_protect)
        start_pending <= 1'b0;
      // 在输入侧发现 wrap（frame_end_raw），置位“待打标”
      else if (frame_end_raw)
        start_pending <= 1'b1;
      // 真正写入到 FIFO 的第一拍，完成打标并清除
      if (wr_ok && start_pending)
        start_pending <= 1'b0;
    end
  end

  wire frame_start_wr = wr_ok && start_pending;  // 取代原先的 wr_ok && frame_start_raw
  wire [PARALLEL:0] fifo_din = {frame_start_wr, din};
  wire [PARALLEL:0] fifo_dout_ext;
  wire              full, empty;
  wire              wr_rst_busy, rd_rst_busy;
  wire              tag_dout    = fifo_dout_ext[PARALLEL];
  wire [PARALLEL-1:0] data_dout = fifo_dout_ext[PARALLEL-1:0];

  // always @(posedge clk) 
  // if (dout_fire_gate) begin
  //   $display("[%0t] [DOUT] sof=%0b dout=%h", $time, sof, data_dout);
  // end

  reg squelch_this_frame;
  wire have_word  = !empty && !rd_rst_busy;
 wire consume = (state==S_LOCK) && have_word;
  // PROTECT/LOCK 边沿信号（
  wire entering_protect = (state!=S_PROTECT) && (next_state==S_PROTECT);

  reg entering_lock_d1;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) entering_lock_d1 <= 1'b0;
    else        entering_lock_d1 <= entering_lock;
  end

  wire fifo_srst = ~rst_n | entering_protect | entering_lock_d1;

  sync_fifo u_fifo (
    .clk  (clk),
    .srst (fifo_srst),
    .din  (fifo_din),
    .wr_en(wr_ok),
    .rd_en(consume),
    .dout (fifo_dout_ext),
    .full (full), .empty(empty),
    .wr_rst_busy(wr_rst_busy), .rd_rst_busy(rd_rst_busy)
  );

  // 本帧静默 
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      squelch_this_frame <= 1'b1; // 默认静默
    end else if (frame_start) begin
      squelch_this_frame <= 1'b0; // 新帧放行
    end else if (header_end_delayed && !hit_in_frame) begin
      squelch_this_frame <= 1'b1; // 帧头未命中，静默剩余负载
    end
  end

  // 头部抑制（FWFT：当拍判断当拍丢弃）
  localparam integer SUPPRESS_AFTER_TAG = (HEADER_LEN_WORDS>0)?(HEADER_LEN_WORDS-1):0; // 192b→6-1=5
  reg [HDR_CNT_W-1:0] hdr_sup_cnt;

// ========= 读口 seen_tag =========
// 读侧“已见tag”标志：仅由 FIFO 读口事件驱动
  reg seen_tag;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      seen_tag <= 1'b0;
    end else if (fifo_srst) begin
      // 进入 LOCK/PROTECT 或复位时，同步清零，避免跨帧遗留
      seen_tag <= 1'b0;
    end else if (consume && tag_dout) begin
      // 真正消费到了 tag 字（FWFT 可见 + rd_en 生效的当拍）
      seen_tag <= 1'b1;
    end else begin
      // 其余维持
      seen_tag <= seen_tag;
    end
  end

// 只有“本拍是 tag”或“之前已见过 tag”才允许消费
wire allow_read = tag_dout | seen_tag;
wire header_blocking = (!seen_tag) | tag_dout | (hdr_sup_cnt != {HDR_CNT_W{1'b0}});
wire dout_fire_gate  = consume && !header_blocking;

// 其余：hdr_sup_cnt 在消费到 tag 时装载 5（192b→6-1）
always @(posedge clk or negedge rst_n) begin
  if (!rst_n || entering_lock) begin
    hdr_sup_cnt <= {HDR_CNT_W{1'b0}};
  end else if (consume) begin
    if (tag_dout)
      hdr_sup_cnt <= SUPPRESS_AFTER_TAG[HDR_CNT_W-1:0]; // 5
    else if (hdr_sup_cnt != {HDR_CNT_W{1'b0}})
      hdr_sup_cnt <= hdr_sup_cnt - {{(HDR_CNT_W-1){1'b0}},1'b1};
  end
end

  reg header_blocking_reg;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) header_blocking_reg <= 1'b1;
    else       header_blocking_reg <= header_blocking;
  end

  wire sof_pulse = consume && header_blocking_reg && !header_blocking;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout_valid <= 1'b0;
      dout       <= {PARALLEL{1'b0}};
      sof        <= 1'b0;
    end else begin
      sof <= sof_pulse; // 1 拍脉冲
      if (dout_fire_gate) begin
        dout_valid <= 1'b1;
        dout       <= data_dout; // FWFT
      end else begin
        dout_valid <= 1'b0;
      end
    end
  end

  // ---------------- FSM & book-keeping ----------------
  reg [7:0] verify_cnt, miss_cnt;
  localparam [7:0] M_VERIFY_U8  = M_VERIFY;
  localparam [7:0] N_PROTECT_U8 = N_PROTECT;

  reg header_end_d1, header_end_d2;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      header_end_d1 <= 1'b0;
      header_end_d2 <= 1'b0;
    end else begin
      header_end_d1 <= header_end_delayed;
      header_end_d2 <= header_end_d1;
    end
  end

  wire verify_reached        = (state==S_VERIFY) && header_end_d2 && (verify_cnt >= M_VERIFY_U8 - 1);
  wire protect_timeout       = (state==S_PROTECT) && header_end_d1 && !hit_in_frame && ((miss_cnt + 8'd1) >= N_PROTECT_U8);
  wire protect_relock        = (state==S_PROTECT) && header_end_d1 &&  hit_in_frame;
  wire lock_missed_header    = (state==S_LOCK)    && header_end_d2 && !hit_in_frame;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state            <= S_SEARCH;
      verify_cnt       <= 8'd0;
      miss_cnt         <= 8'd0;
      frame_lock       <= 1'b0;
      frame_sync_found <= 1'b0;
      wnumber_dec      <= 5'd0;
      flocation        <= 4'b0000;
    end else begin
      state            <= next_state;
      frame_sync_found <= 1'b0;

      case (state)
        S_SEARCH: begin
          frame_lock <= 1'b0;
          verify_cnt <= 8'd0;
          miss_cnt   <= 8'd0;
          if (detector_data_valid && found_any) begin
            frame_sync_found <= 1'b1;
            wnumber_dec      <= found_idx_latch; // 比特索引 0..31
          end
        end

        S_VERIFY: begin
          frame_lock <= 1'b0;
          if (header_end_d1) begin
            if (hit_in_frame) verify_cnt <= verify_cnt + 1'b1;
            else              verify_cnt <= 8'd0;
          end
        end

        S_LOCK: begin
          frame_lock <= 1'b1;
          if (frame_end) begin
            if (found_any) wnumber_dec <= priority_low_idx(wflag_delayed);
          end
        end

        S_PROTECT: begin
          frame_lock <= 1'b0;
          if (header_end_d1) begin
            if (hit_in_frame) miss_cnt <= 8'd0;
            else              miss_cnt <= miss_cnt + 1'b1;
          end
        end
      endcase

      if (frame_lock) begin
        case (wnumber_dec[4:3])
          2'd0: flocation <= 4'b0001;
          2'd1: flocation <= 4'b0010;
          2'd2: flocation <= 4'b0100;
          2'd3: flocation <= 4'b1000;
          default: flocation <= 4'b0000;
        endcase
      end else begin
        flocation <= 4'b0000;
      end
    end
  end

  always @(*) begin
    next_state = state;
    case (state)
      S_SEARCH:
        if (detector_data_valid && found_any)
          next_state = S_VERIFY;

      S_VERIFY: begin
        if (verify_reached)                 next_state = S_LOCK;
        else if (header_end_d1 && !hit_in_frame) next_state = S_SEARCH;
      end

      S_LOCK:
        if (lock_missed_header)             next_state = S_PROTECT;

      S_PROTECT: begin
        if (protect_timeout)                next_state = S_SEARCH;
        else if (protect_relock)            next_state = S_LOCK;
      end
    endcase
  end

// 延迟数据和使能，sof信号在数据前输出
  parameter OUTPUT_DELAY = 3;
  reg                  vpipe   [0:OUTPUT_DELAY];
  reg [PARALLEL-1:0]   dpipe   [0:OUTPUT_DELAY];

  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i=0;i<=OUTPUT_DELAY;i=i+1) begin
        vpipe[i] <= 1'b0;
        dpipe[i] <= '0;
      end
    end else begin
      vpipe[0] <= dout_fire_gate;
      dpipe[0] <= data_dout;
      for (i=1;i<=OUTPUT_DELAY;i=i+1) begin
        vpipe[i] <= vpipe[i-1];
        dpipe[i] <= dpipe[i-1];
      end
    end
  end

  reg                 data_valid_o;
  reg [PARALLEL-1:0]  data_o;

  always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
      data_valid_o <= 'd0;
      data_o <= 'd0;
    end else begin
      data_valid_o <= vpipe[OUTPUT_DELAY];
      data_o <= dpipe[OUTPUT_DELAY];
    end
  end



  /* synthesis translate_off */

// =======================================================================================================================================================
// ========================================= 监控 / 自检（仅仿真） ========================================================================================
// =======================================================================================================================================================

// 打印友好：把状态编码转成字符串（使用独立名字，避免与你上面已有函数冲突）
function [15*9-1:0] ascii_state_dbg;
  input [1:0] in_state;
  begin
    case(in_state)
      2'b00: ascii_state_dbg = "SEARCH";
      2'b01: ascii_state_dbg = "S_VERIFY";
      2'b10: ascii_state_dbg = "S_LOCK";
      2'b11: ascii_state_dbg = "S_PROTECT";
      default: ascii_state_dbg = "INVALID";
    endcase
  end
endfunction

// —— 影子寄存器（上一拍） ——
reg  din_valid_prev_dbg, header_end_d1_prev_dbg, sof_prev_dbg;
reg  will_wrap_prev_dbg; // 修复：已声明
reg [1:0]  prev_state_dbg;
reg [15:0] fcnt4_prev_dbg;
reg [7:0]  verify_cnt_prev_dbg, miss_cnt_prev_dbg;
reg [31:0] dout_prev_dbg;
reg  dout_valid_prev_dbg;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    din_valid_prev_dbg   <= 1'b0;
    header_end_d1_prev_dbg <= 1'b0;
    sof_prev_dbg       <= 1'b0;
    // will_wrap_prev_dbg (见 L877)
    prev_state_dbg       <= 2'b00;
    fcnt4_prev_dbg       <= 16'd0;
    verify_cnt_prev_dbg  <= 8'd0;
    miss_cnt_prev_dbg    <= 8'd0;
    dout_prev_dbg        <= 32'h0;
    dout_valid_prev_dbg  <= 1'b0;
  end else begin
    din_valid_prev_dbg   <= din_valid;
    header_end_d1_prev_dbg <= header_end_d1;
    sof_prev_dbg       <= sof;
    // will_wrap_prev_dbg (见 L877)
    prev_state_dbg       <= state;
    fcnt4_prev_dbg       <= fcnt4;
    verify_cnt_prev_dbg  <= verify_cnt;
    miss_cnt_prev_dbg    <= miss_cnt;
    dout_prev_dbg        <= dout;
    dout_valid_prev_dbg  <= dout_valid;
  end
end

// —— 基本可视化 ——
// 状态跳变
always @(posedge clk) if (state != prev_state_dbg) begin
  $display("[%0t] [STATE] %s -> %s", $time, ascii_state_dbg(prev_state_dbg), ascii_state_dbg(state));
end

// [新增] 监控 din 和 fcnt4 对齐
always @(posedge clk) begin
  if (din_valid && rst_n) begin
    $display("[%0t] [DIN_FCNT] fcnt4=%0d din=%h", $time, fcnt4, din);
  end
end

// 匹配到任意窗口（已门控 detector_data_valid）
always @(posedge clk) if (found_pulse) begin
  $display("[%0t] [FOUND] st=%s in_hdr=%0b hdr_end=%0b wflag=%032b low_idx=%0d",
           $time, ascii_state_dbg(state), in_header_delayed, header_end_delayed, wflag_delayed, found_idx_latch);
end

// header_end 判决点（已门控的 header_end_d1）
always @(posedge clk) if (header_end_d1) begin
  $display("[%0t] [HDR_END] st=%s hit_in_frame=%0b verify_cnt=%0d miss_cnt=%0d",
           $time, ascii_state_dbg(state), hit_in_frame, verify_cnt, miss_cnt);
end

// 帧边界
always @(posedge clk) if (frame_end)
  $display("[%0t] [FRAME_END]   fcnt4=%0d", $time, fcnt4);
always @(posedge clk) if (frame_start)
  $display("[%0t] [FRAME_START] fcnt4=%0d", $time, fcnt4);

// SOF 脉冲（首个有效负载字）
always @(posedge clk) if (sof && !sof_prev_dbg)
  $display("[%0t] [SOF] sof_pulse=1 (header blocking released)", $time);

// 读到 tag（FWFT，读口侧第一字）
always @(posedge clk) if (consume && tag_dout)
  $display("[%0t] [TAG_CONSUME] tag_dout=1 (first word of a frame at read side)", $time);

// 实际输出数据（已经过抑头门控）
always @(posedge clk) if (dout_fire_gate) begin
  $display("[%0t] [DOUT] sof=%0b dout=%h", $time, sof, data_dout);
end

// —— 严格一致性检查 ——

// 1) fcnt4 在 “本拍 & 上拍” din_valid 都为 0 时，不应变化
always @(posedge clk) if (!rst_n) begin end else begin
  if (!din_valid && !din_valid_prev_dbg && (fcnt4 != fcnt4_prev_dbg)) begin
    $error("[%0t] fcnt4 changed while din_valid=0 for two consecutive cycles! prev=%0d now=%0d",
           $time, fcnt4_prev_dbg, fcnt4);
  end
end

// 2) verify_cnt 只能在“上一拍处于 S_VERIFY 且 header_end_d1==1”那次更新
always @(posedge clk) if (!rst_n) begin end else begin
  if (verify_cnt != verify_cnt_prev_dbg) begin
    $display("[%0t] [VCNT] state=%s hdr_end_d1=%b (prev=%b) hit_in_frame=%b verify_cnt: %0d -> %0d",
             $time, ascii_state_dbg(state), header_end_d1, header_end_d1_prev_dbg, hit_in_frame,
             verify_cnt_prev_dbg, verify_cnt);
    if (!(prev_state_dbg==2'b01 /*S_VERIFY*/ && header_end_d1_prev_dbg)) begin
      $error("[%0t] verify_cnt changed outside valid update condition (expected at previous HDR_END in S_VERIFY)!",
             $time);
    end
  end
end

// 3) miss_cnt 只能在“上一拍处于 S_PROTECT 且 header_end_d1==1”那次更新
always @(posedge clk) if (!rst_n) begin end else begin
  if (miss_cnt != miss_cnt_prev_dbg) begin
    $display("[%0t] [MCNT] state=%s hdr_end_d1=%b (prev=%b) hit_in_frame=%b miss_cnt: %0d -> %0d",
             $time, ascii_state_dbg(state), header_end_d1, header_end_d1_prev_dbg, hit_in_frame,
             miss_cnt_prev_dbg, miss_cnt);
    if (!(prev_state_dbg==2'b11 /*S_PROTECT*/ && header_end_d1_prev_dbg)) begin
      $error("[%0t] miss_cnt changed outside valid update condition (expected at previous HDR_END in S_PROTECT)!",
             $time);
    end
  end
end

// =======================================================================
// ===================== FIFO / 握手 详细监控（仿真） =====================
// =======================================================================
reg empty_prev_dbg, full_prev_dbg, wr_ok_prev_dbg, rd_en_prev_dbg;
reg have_word_prev_dbg, allow_read_prev_dbg, header_blocking_prev_dbg;
reg start_pending_prev_dbg, frame_start_wr_prev_dbg;
reg seen_tag_prev_dbg;
reg wr_rst_busy_prev_dbg, rd_rst_busy_prev_dbg;
reg fifo_srst_prev_dbg;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    empty_prev_dbg       <= 1'b1;
    full_prev_dbg        <= 1'b0;
    wr_ok_prev_dbg       <= 1'b0;
    rd_en_prev_dbg       <= 1'b0;
    have_word_prev_dbg   <= 1'b0;
    allow_read_prev_dbg  <= 1'b0;
    header_blocking_prev_dbg<= 1'b1;
    start_pending_prev_dbg  <= 1'b0;
    frame_start_wr_prev_dbg <= 1'b0;
    seen_tag_prev_dbg       <= 1'b0;
    wr_rst_busy_prev_dbg    <= 1'b0;
    rd_rst_busy_prev_dbg    <= 1'b0;
    fifo_srst_prev_dbg      <= 1'b0;
  end else begin
    empty_prev_dbg       <= empty;
    full_prev_dbg        <= full;
    wr_ok_prev_dbg       <= wr_ok;
    rd_en_prev_dbg       <= consume;
    have_word_prev_dbg   <= have_word;
    allow_read_prev_dbg  <= allow_read;
    header_blocking_prev_dbg<= header_blocking;
    start_pending_prev_dbg  <= start_pending;
    frame_start_wr_prev_dbg <= frame_start_wr;
    seen_tag_prev_dbg       <= seen_tag;
    wr_rst_busy_prev_dbg    <= wr_rst_busy;
    rd_rst_busy_prev_dbg    <= rd_rst_busy;
    fifo_srst_prev_dbg      <= fifo_srst;
  end
end

// —— FIFO 状态变化 —— 
always @(posedge clk) begin
  if (fifo_srst && !fifo_srst_prev_dbg)
    $display("[%0t] [FIFO] srst=1 (entering_lock_d1=%0b entering_protect=%0b)", 
             $time, entering_lock_d1, entering_protect);
  if (!fifo_srst && fifo_srst_prev_dbg)
    $display("[%0t] [FIFO] srst=0", $time);

  if (wr_rst_busy != wr_rst_busy_prev_dbg)
    $display("[%0t] [FIFO] wr_rst_busy=%0b", $time, wr_rst_busy);
  if (rd_rst_busy != rd_rst_busy_prev_dbg)
    $display("[%0t] [FIFO] rd_rst_busy=%0b", $time, rd_rst_busy);

  if (empty != empty_prev_dbg)
    $display("[%0t] [FIFO] empty -> %0b", $time, empty);
  if (full != full_prev_dbg)
    $display("[%0t] [FIFO] full  -> %0b", $time, full);
end

// —— 写口（打标） —— 
always @(posedge clk) begin
  if (frame_end_raw)
    $display("[%0t] [WR] frame_end_raw=1 -> start_pending will be set", $time);
  if (start_pending && !start_pending_prev_dbg)
    $display("[%0t] [WR] start_pending=1", $time);
  if (wr_ok && !wr_ok_prev_dbg)
    $display("[%0t] [WR] wr_ok=1 (din_valid=%0b wr_rst_busy=%0b)", $time, din_valid, wr_rst_busy);
  if (frame_start_wr && !frame_start_wr_prev_dbg)
    $display("[%0t] [WR] WRITE TAG (frame_start_wr=1) WDATA=%h", $time, din);
  if (!start_pending && start_pending_prev_dbg && wr_ok)
    $display("[%0t] [WR] start_pending cleared by wr_ok", $time);
end

// —— 读口（FWFT 可见 / rd_en / gating） —— 
always @(posedge clk) begin
  if (have_word && !have_word_prev_dbg)
    $display("[%0t] [RD] have_word=1 (empty=0 rd_rst_busy=%0b) tag_dout=%0b data_dout=%h", 
             $time, rd_rst_busy, tag_dout, data_dout);
  if (allow_read && !allow_read_prev_dbg)
    $display("[%0t] [RD] allow_read=1 (tag_dout=%0b seen_tag=%0b)", $time, tag_dout, seen_tag);
  if (consume && !rd_en_prev_dbg)
    $display("[%0t] [RD] rd_en=1 (consume). tag_dout=%0b header_blocking=%0b", 
             $time, tag_dout, header_blocking);
  if (consume && tag_dout)
    $display("[%0t] [TAG_CONSUME] consume & tag_dout -> first word of frame consumed", $time);

  if (header_blocking != header_blocking_prev_dbg)
    $display("[%0t] [GATE] header_blocking -> %0b (seen_tag=%0b tag_dout=%0b hdr_sup_cnt=%0d)",
             $time, header_blocking, seen_tag, tag_dout, hdr_sup_cnt);
end

// =======================================================================
// ================ will_wrap / 边界一致性 专用监控 ======================
// =======================================================================

// 影子寄存器
reg frame_end_raw_prev_dbg, frame_start_raw_prev_dbg;
reg detector_data_valid_prev_dbg; // 你用的 detector_data_valid = wflag_valid_d

// 为了更直观，我们也算一个“期望 wrap”作为对照
wire [15:0] fcnt4_plus_dbg   = fcnt4 + BYTES_PER_CYCLE[15:0];
wire        exp_wrap_dbg     = din_valid && (fcnt4_plus_dbg >= FRAME_LEN_BYTE);

// 统计一些越界/边界信息
wire [15:0] last_word_byte_idx   = (FRAME_LEN_BYTE >= BYTES_PER_CYCLE) ? (FRAME_LEN_BYTE - BYTES_PER_CYCLE) : 16'd0;
wire        at_last_word_before  = din_valid && (fcnt4 == last_word_byte_idx); // wrap 前最后一个有效拍
wire        byte_aligned_dbg     = (fcnt4[ ($clog2(BYTES_PER_CYCLE)-1) : 0 ] == 0);

// 延迟对齐链（仅用于 debug 对照，和你已有的 end_shift/start_shift 吻合）
reg [EFFECTIVE_LATENCY-1:0] wrap_shift_dbg, start_shift_dbg;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    wrap_shift_dbg  <= {EFFECTIVE_LATENCY{1'b0}};
    start_shift_dbg <= {EFFECTIVE_LATENCY{1'b0}};
  end else begin
    wrap_shift_dbg  <= {wrap_shift_dbg [EFFECTIVE_LATENCY-2:0], frame_end_raw};
    start_shift_dbg <= {start_shift_dbg[EFFECTIVE_LATENCY-2:0], frame_start_raw};
  end
end

// 记录上一拍
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    frame_end_raw_prev_dbg   <= 1'b0;
    frame_start_raw_prev_dbg <= 1'b0;
    detector_data_valid_prev_dbg <= 1'b0;
  end else begin
    frame_end_raw_prev_dbg   <= frame_end_raw;
    frame_start_raw_prev_dbg <= frame_start_raw;
    detector_data_valid_prev_dbg <= detector_data_valid;
  end
end

// --------- 基本打印：检测到 wrap 的当拍 ----------
// [注]：为避免重复，我们使用 L877 的 will_wrap_prev_dbg
always @(posedge clk) begin
  if (will_wrap && !will_wrap_prev_dbg) begin
    $display("[%0t] [WRAP-RAW] will_wrap=1  fcnt4(cur)=%0d  fcnt4_plus=%0d  FRAME_LEN_BYTE=%0d  at_last_word=%0b byte_aligned=%0b",
             $time, fcnt4, fcnt4_plus_dbg, FRAME_LEN_BYTE, at_last_word_before, byte_aligned_dbg);
  end
end

// --------- 一致性检查 1：计算式 vs will_wrap -----------
always @(posedge clk) if (!rst_n) begin end else begin
  if (din_valid && (exp_wrap_dbg !== will_wrap)) begin
    $error("[%0t] [WRAP-CHECK-1] exp_wrap(din_valid && fcnt4+%0d >= %0d)=%0b  but will_wrap=%0b  (fcnt4=%0d fcnt4_plus=%0d)",
           $time, BYTES_PER_CYCLE, FRAME_LEN_BYTE, exp_wrap_dbg, will_wrap, fcnt4, fcnt4_plus_dbg);
  end
end

// --------- 一致性检查 2：will_wrap 的必要条件 ----------
always @(posedge clk) if (!rst_n) begin end else begin
  if (will_wrap && !(din_valid && (fcnt4 <= FRAME_LEN_BYTE) && (fcnt4_plus_dbg >= FRAME_LEN_BYTE))) begin
    $error("[%0t] [WRAP-CHECK-2] will_wrap=1 但不满足: din_valid=1 && fcnt4<=FRAME_LEN_BYTE && fcnt4+%0d>=FRAME_LEN_BYTE (fcnt4=%0d fcnt4_plus=%0d FRAME_LEN_BYTE=%0d)",
           $time, BYTES_PER_CYCLE, fcnt4, fcnt4_plus_dbg, FRAME_LEN_BYTE);
  end
end

// --------- 一致性检查 3：wrap 的位置应发生在“最后一个word之后” ----------
always @(posedge clk) if (!rst_n) begin end else begin
  if (will_wrap && !at_last_word_before) begin
    // 注意：若你的 TB 在帧末尾插入空洞，这里可能不是严格必要条件；先作为 WARN
    $display("[%0t] [WRAP-WARN] will_wrap 在非最后数据拍触发: fcnt4=%0d (期望=%0d). 若有空洞/空拍请忽略。",
             $time, fcnt4, last_word_byte_idx);
  end
end

// --------- 一致性检查 4：frame_end_raw / frame_start_raw 的相位关系 ----------
always @(posedge clk) if (!rst_n) begin end else begin
  // frame_start_raw 应该是 frame_end_raw 的下一拍，你代码里就是这样
  if (frame_start_raw && !frame_end_raw_prev_dbg) begin
    $error("[%0t] [WRAP-CHECK-3] frame_start_raw=1 但上一拍 frame_end_raw!=1", $time);
  end
end

// --------- 一致性检查 5：延迟链与门控后的 frame_end/frame_start ----------
always @(posedge clk) if (!rst_n) begin end else begin
  // 你的最终门控：frame_end = end_shift[EL-1] && detector_data_valid
  if (frame_end && !(wrap_shift_dbg[EFFECTIVE_LATENCY-1] && detector_data_valid)) begin
    $error("[%0t] [WRAP-CHECK-4] frame_end=1 但 wrap_shift_dbg(EL-1)=%0b detector_data_valid=%0b 不满足与门",
           $time, wrap_shift_dbg[EFFECTIVE_LATENCY-1], detector_data_valid);
  end
  if (frame_start && !(start_shift_dbg[EFFECTIVE_LATENCY-1] && detector_data_valid)) begin
    $error("[%0t] [WRAP-CHECK-5] frame_start=1 但 start_shift_dbg(EL-1)=%0b detector_data_valid=%0b 不满足与门",
           $time, start_shift_dbg[EFFECTIVE_LATENCY-1], detector_data_valid);
  end
end

// --------- 辅助打印：真正门控后的边界到来 ----------
always @(posedge clk) begin
  if (frame_end)
    $display("[%0t] [FRAME_END(GATED)] fcnt4=%0d  (EL=%0d)", $time, fcnt4, EFFECTIVE_LATENCY);
  if (frame_start)
    $display("[%0t] [FRAME_START(GATED)] fcnt4=%0d (相当于wrap后一拍的对齐时刻)", $time, fcnt4);
end

// =======================================================================
// ==================== [新增] fcnt4 决策监控 =========================
// =======================================================================

always @(posedge clk) begin
    if (rst_n) begin
        // 监控 fcnt4 决策的 *输入* (组合逻辑)
        if (state == S_SEARCH && next_state == S_VERIFY) begin
            $display("[%0t] [FCNT4_DECISION] LOAD: S_SEARCH->S_VERIFY. Next fcnt4 will be %0d", $time, fcnt4_phase_next);
        end 
        else if (will_wrap) begin
            $display("[%0t] [FCNT4_DECISION] WRAP: will_wrap=1 (cur_fcnt4=%0d). Next fcnt4 will be %0d", $time, fcnt4, fcnt4_phase);
        end
    end
end

// =======================================================================
// ==================== [修复] 断言 (Assertions) =========================
// =======================================================================

// 断言A：will_wrap 这一拍，下一拍 fcnt4 必须等于 fcnt4_phase（LOCK态）
// [注]：这里使用了 顶层 声明的 will_wrap_prev_dbg
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) will_wrap_prev_dbg <= 1'b0;
  else        will_wrap_prev_dbg <= will_wrap;
end

always @(posedge clk) if (!rst_n) begin end else begin
  // [修复]：断言的核心是：如果上一拍 *发生* 了 wrap...
  if (will_wrap_prev_dbg) begin 
    if (fcnt4 !== fcnt4_phase) begin
        $error("[%0t] ASSERT-A FAILED: After wrap (prev will_wrap=1), fcnt4(%0d) != fcnt4_phase(%0d). din_valid(now)=%0b",
               $time, fcnt4, fcnt4_phase, din_valid);
    end else begin
        $display("[%0t] [ASSERT-A-PASS] After wrap, fcnt4 correctly reset to %0d. din_valid(now)=%0b",
               $time, fcnt4, din_valid);
    end
  end
end

// 断言B：SEARCH->VERIFY 当拍，fcnt4 必须装载 fcnt4_phase_next
reg search2verify_prev_dbg;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) search2verify_prev_dbg <= 1'b0;
  else        search2verify_prev_dbg <= (state==S_SEARCH && next_state==S_VERIFY && din_valid);
end
always @(posedge clk) if (search2verify_prev_dbg) begin
  if (fcnt4 !== fcnt4_phase_next) begin
    $error("[%0t] ASSERT-B FAILED: 进VERIFY当拍 fcnt4(%0d) != fcnt4_phase_next(%0d)",
           $time, fcnt4, fcnt4_phase_next);
  end
end

/* synthesis translate_on */



endmodule