`timescale 1ns/1ps
module frame_synchronizer_top #(
    parameter PARALLEL          = 32,      // 数据总线位宽
    parameter MASK_LEN          = 192,     // 帧同步码 (ASM) 的掩码长度 (bits)。
    parameter ASM_LEN           = 192,     // 帧同步码 (ASM) 的总长度 (bits)。
    parameter TOLERANCE         = 0,       // 帧同步码 (ASM) 匹配时允许的最大误码位数 (容错)。
    parameter FRAME_LEN_BYTE    = 64,      // 完整数据帧的总长度 (bytes)。(注：此默认值会被 TB 覆盖为 48)
    parameter M_VERIFY          = 2,       // FSM: 需要连续 M 帧(帧头)命中才能进入 LOCK 状态。
    parameter N_PROTECT         = 2,       // FSM: 需要连续 N 帧(帧头)丢失才能从 LOCK 跌落到 PROTECT 状态。
    parameter PIPELINE_LATENCY  = 4        // 匹配引擎 (u_pipelined) 内部的流水线延迟 (时钟周期数)。(注：此默认值会被 TB 覆盖为 9)
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
    // ★ 清理：删除无效的 slip_detected 和 slip_amount 端口
    output reg  [PARALLEL-1:0]    dout,
    output reg                    dout_valid
);
  // ---------------- Const ----------------
  localparam integer BYTES_PER_CYCLE     = PARALLEL/8;                                        //每个时钟周期处理的字节数
  localparam integer HEADER_LEN_WORDS    = ((ASM_LEN/8)+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE; // 帧头 (ASM) 占用的时钟周期数 (Words)
  localparam integer TOTAL_WORDS_PER_FRAME = (FRAME_LEN_BYTE+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE; // 整帧数据占用的时钟周期数 (Words)
  localparam integer HDR_CNT_W           = (HEADER_LEN_WORDS<=1)?1:$clog2(HEADER_LEN_WORDS+1);//头部抑制计数器 (hdr_sup_cnt) 所需的位宽
  // ★ 新增：帧头字节长度 (用于新架构)
  localparam integer HEADER_LEN_BYTES    = (ASM_LEN/8); //帧头的总字节数它被 fcnt4 计数器用来判断 "in_header_raw" 和 "header_end_raw"。

  // ★ 修正 #2：有效延迟 = 内核延迟 + 顶层打一拍(wflag_delayed)
  localparam integer CORE_LATENCY        = PIPELINE_LATENCY; //匹配引擎的内核延迟
  localparam integer EXTRA_REG_LATENCY   = 1;                // 顶层为 wflag_delayed 额外增加的 1 拍寄存器延迟。
  localparam integer EFFECTIVE_LATENCY   = CORE_LATENCY + EXTRA_REG_LATENCY;
  localparam [1:0] S_SEARCH  = 2'b00;
  localparam [1:0] S_VERIFY  = 2'b01;
  localparam [1:0] S_LOCK    = 2'b10;
  localparam [1:0] S_PROTECT = 2'b11;

  reg [1:0] state, next_state;

  // ---------------- Match engine ----------------
  wire [PARALLEL-1:0] wflag_reg_out;
  wire [PARALLEL-1:0] wflag_reg_out_wire; // debug
  reg  [PARALLEL-1:0] wflag_delayed;

  frame_synchronizer_pipelined #(
      .PARALLEL           (PARALLEL),
      .MASK_LEN           (MASK_LEN),
      .ASM_LEN            (ASM_LEN),
      .TOLERANCE          (TOLERANCE)
  ) u_pipelined (
      .clk                (clk),
      .rst_n              (rst_n),
      .din                (din),
      .din_valid          (din_valid),
      .asm_pattern        (asm_pattern),
      .asm_mask           (asm_mask),
      .wflag_reg_out_wire (wflag_reg_out_wire),
      .wflag_reg_out      (wflag_reg_out)
  );

  // 顶层再打一拍（形成 EXTRA_REG_LATENCY=1）
  always @(posedge clk or negedge rst_n)
    if (!rst_n) wflag_delayed <= {PARALLEL{1'b0}};
    else        wflag_delayed <= wflag_reg_out;

  // ---------------- Helpers for FSM ----------------
  wire        found_any = |wflag_delayed;  //延迟 EFFECTIVE_LATENCY 拍
  wire        detector_data_valid; // defined below
  wire        found_pulse = detector_data_valid && found_any;

  function [4:0] priority_low_idx;
    input [PARALLEL-1:0] vec;
    integer j; reg found; reg [4:0] idx;
    begin
      idx = 5'd0; 
      found = 1'b0;
      for (j=0; j<PARALLEL; j=j+1)
        if (vec[j] && !found) begin 
          idx = j[4:0]; 
          found = 1'b1; 
        end
      priority_low_idx = idx;
    end
  endfunction

  wire [4:0] found_idx_latch = priority_low_idx(wflag_delayed);

  reg hit_in_frame;

  // ---------------- Input-side frame counter (for FSM only) ----------------
  reg  [15:0] fcnt4;
  wire [15:0] fcnt4_plus      = fcnt4 + BYTES_PER_CYCLE;
  wire        will_wrap       = din_valid && (fcnt4_plus >= FRAME_LEN_BYTE);
  wire        frame_end_raw   = will_wrap;
  reg         frame_start_raw;
 
  // 帧头期（原始）信号
  wire        in_header_raw   = din_valid && (fcnt4 < HEADER_LEN_BYTES);
  // 帧头最后一个周期的（原始）信号
  wire        header_end_raw  = din_valid && (fcnt4 == (HEADER_LEN_BYTES - BYTES_PER_CYCLE)); // 24-4=20

  // “下一帧首” = frame_end_raw 的下一拍
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) frame_start_raw <= 1'b0;
    else        frame_start_raw <= frame_end_raw;
  end

  // 延迟所有控制信号 EFFECTIVE_LATENCY 拍
  reg [EFFECTIVE_LATENCY-1:0] start_shift, end_shift, valid_shift, in_header_shift, header_end_shift;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_shift      <= {EFFECTIVE_LATENCY{1'b0}};
      end_shift        <= {EFFECTIVE_LATENCY{1'b0}};
      valid_shift      <= {EFFECTIVE_LATENCY{1'b0}};
      in_header_shift  <= {EFFECTIVE_LATENCY{1'b0}}; 
      header_end_shift <= {EFFECTIVE_LATENCY{1'b0}}; 
    end else begin
      start_shift      <= {start_shift[EFFECTIVE_LATENCY-2:0], frame_start_raw};
      end_shift        <= {end_shift  [EFFECTIVE_LATENCY-2:0], frame_end_raw};
      valid_shift      <= {valid_shift[EFFECTIVE_LATENCY-2:0], din_valid};
      in_header_shift  <= {in_header_shift[EFFECTIVE_LATENCY-2:0], in_header_raw};
      header_end_shift <= {header_end_shift[EFFECTIVE_LATENCY-2:0], header_end_raw};
    end
  end
//延迟 EFFECTIVE_LATENCY 后的信号输出
  wire frame_start         = start_shift[EFFECTIVE_LATENCY-1];
  wire frame_end           = end_shift  [EFFECTIVE_LATENCY-1];
  assign detector_data_valid = valid_shift[EFFECTIVE_LATENCY-1];
  wire in_header_delayed   = in_header_shift[EFFECTIVE_LATENCY-1];
  wire header_end_delayed  = header_end_shift[EFFECTIVE_LATENCY-1];


  // ================ 修复竞争/双重复位/重锁 问题 =================
  
  reg [15:0] fcnt4_phase;    // 持久化的相位寄存器
  
  // ★ 1. 组合逻辑线网，计算“下一拍”的相位
  wire [15:0] fcnt4_phase_next; 

  // ★ 2. 组合逻辑：计算下一拍的相位
  assign fcnt4_phase_next = (state == S_SEARCH && next_state == S_VERIFY)
                              // 1. 捕获新相位
                              ? {14'd0, found_idx_latch[4:3]}
                              // 2. 掉锁，清除相位
                              : (next_state == S_SEARCH)
                                  ? 16'd0
                                  // 3. 保持当前相位
                                  : fcnt4_phase; 
  
  // ---------------- 相位寄存器更新逻辑 (时序) ----------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fcnt4_phase <= 16'd0;
    end else begin
      fcnt4_phase <= fcnt4_phase_next; // 寄存器锁存组合逻辑的输出
      
// synthesis translate_off
      // 调试显示：
      if (state == S_SEARCH && next_state == S_VERIFY) begin
          $display("[%0t] [INFO] lock new phase: found_idx=%0d phase=%0d",
                   $time, found_idx_latch[4:3], fcnt4_phase_next);
      end
// synthesis translate_on
    end
  end
  // =====================================================================

  // fcnt4 update：wrap > 帧首加载 > 正常计数
  wire entering_lock = (state!=S_LOCK) && (next_state==S_LOCK);

  // ---------------- fcnt4 主计数器 (最终修复版) ----------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fcnt4 <= 16'd0;
    end 
    else if (din_valid) begin

      // 1️⃣ [NEW] 最高优先级：FSM 强制重载相位
      // (修复了“双重复位” 和 “重锁失败” 问题)
      if (state == S_SEARCH && next_state == S_VERIFY) begin
        fcnt4 <= fcnt4_phase_next; // 立即强制加载新相位
// synthesis translate_off
        // $display("[%0t] [FSM_RELOAD] fcnt4 forced to %0d", $time, fcnt4_phase_next);
// synthesis translate_on
      end
      
      // 2️⃣ 帧尾：计数溢出，回绕到 *持久相位*
      // (修复了“相位丢失”问题)
      else if (will_wrap) begin
        fcnt4 <= fcnt4_phase_next; // 必须回绕到 phase, 而不是 0
      end 

      // 3️⃣ 默认递增
      else begin
        fcnt4 <= fcnt4_plus;
      end

    end
  end
  // ==========================================================

  // “本帧是否命中过”标志
  reg  prev_hit;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      hit_in_frame <= 1'b0;
      prev_hit     <= 1'b0;
    end else begin
      if (frame_start) begin
        prev_hit     <= hit_in_frame; // 冻结上一帧(帧头)结果
        hit_in_frame <= 1'b0;         // 新帧清零累计
      end 
      // 改造：语义变更，只在“帧头期”内累计命中
      else if (found_pulse && in_header_delayed) begin
        hit_in_frame <= 1'b1;         // 帧头任意命中置位
      end
      // ★ 新增：在 S_SEARCH 状态，即使 in_header_delayed 无效，也要设置 hit
      // (这有助于 S_VERIFY 在第一帧就计数)
      else if (found_pulse && state == S_SEARCH) begin
        hit_in_frame <= 1'b1;
      end
    end
  end



  // ---------------- 写口暂停：锁定→清空→等到下一帧首再恢复写 ----------------
  reg hold_writes_until_fs;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)             hold_writes_until_fs <= 1'b0;
    else if (entering_lock) hold_writes_until_fs <= 1'b1;
    else if (frame_start_raw) hold_writes_until_fs <= 1'b0;
  end

  // ★ 修正 [Bug]：增加 hold_writes_until_fs 门控，防止锁定后脏数据入队
  wire wr_allowed     = !hold_writes_until_fs || frame_start_raw;
  wire wr_ok          = din_valid && !wr_rst_busy && wr_allowed;
  wire frame_start_wr = wr_ok && frame_start_raw;
  wire [PARALLEL:0] fifo_din = {frame_start_wr, din};


  // ★ 新增：帧头门控流的核心 —— "本帧静默" (Squelch) 逻辑
  reg squelch_this_frame;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      squelch_this_frame <= 1'b1; // 默认静默
    end else if (frame_start) begin
      squelch_this_frame <= 1'b0; // 新帧开始，默认放行
    end else if (header_end_delayed && !hit_in_frame) begin
      // ★ 帧头结束时判决：本帧帧头未命中，则静默本帧的剩余负载
      squelch_this_frame <= 1'b1; 
    end
  end

  // ---------------- 单个 Xilinx 同步 FIFO（33bit，FWFT） ----------------
  wire [PARALLEL:0]   fifo_dout_ext;
  wire                full, empty;
  wire                wr_rst_busy, rd_rst_busy;

  wire tag_dout            = fifo_dout_ext[PARALLEL];
  wire [PARALLEL-1:0] data_dout = fifo_dout_ext[PARALLEL-1:0];

  wire have_word  = !empty && !rd_rst_busy;

  // ★ 改造：使用“本帧静默”信号来门控数据输出
  wire consume            = (state==S_LOCK) && have_word && !squelch_this_frame;

  // ★ 防脏负载 #2：进入 PROTECT 时复位 FIFO
  wire entering_protect = (state!=S_PROTECT) && (next_state==S_PROTECT);
  wire fifo_srst        = ~rst_n | entering_lock | entering_protect;

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

  // ---------------- 头部抑制（FWFT：当拍判断当拍丢弃） ----------------
  localparam integer SUPPRESS_AFTER_TAG = (HEADER_LEN_WORDS>0)?(HEADER_LEN_WORDS-1):0; // 192b→6-1=5
  reg [HDR_CNT_W-1:0] hdr_sup_cnt;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n || entering_lock) begin
      hdr_sup_cnt <= {HDR_CNT_W{1'b0}};
    end else if (consume) begin
      if (tag_dout) begin
        hdr_sup_cnt <= SUPPRESS_AFTER_TAG[HDR_CNT_W-1:0];
      end else if (hdr_sup_cnt != {HDR_CNT_W{1'b0}}) begin
        hdr_sup_cnt <= hdr_sup_cnt - {{(HDR_CNT_W-1){1'b0}},1'b1};
      end
    end
  end

  // ---------------- FSM & book-keeping ----------------
  reg [7:0] verify_cnt, miss_cnt;
  localparam [7:0] M_VERIFY_U8  = M_VERIFY;
  localparam [7:0] N_PROTECT_U8 = N_PROTECT;

  // ★ 改造：FSM 判决点从 frame_end 前移到 header_end_delayed
  wire a=header_end_delayed;
  wire b=!hit_in_frame;
  wire c=(state==S_PROTECT);

  reg header_end_d1,header_end_d2;
  always @(posedge clk or negedge rst_n)begin
    if (!rst_n)begin
      header_end_d1 <= 1'b0;
      header_end_d2 <= 1'b0;
    end else begin
      header_end_d1 <= header_end_delayed;
      header_end_d2 <= header_end_d1;
    end 
  end

  wire verify_reached =  (state==S_VERIFY) && header_end_d2 && (verify_cnt >= M_VERIFY_U8 - 1);
  wire protect_timeout = (state==S_PROTECT)   && header_end_d1 && !hit_in_frame && ((miss_cnt + 8'd1) >= N_PROTECT_U8);
  wire protect_relock  = (state==S_PROTECT)   && header_end_d1 &&  hit_in_frame;
  wire lock_missed_header = (state==S_LOCK)   && header_end_d2 && !hit_in_frame;

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
          // ================ 修复 `S_SEARCH` 死锁 (Fix 1) =================
          // ★ 必须移除 in_header_delayed 检查，以允许重锁
          // if (detector_data_valid && found_any && in_header_delayed) begin // <-- 错误的代码
          if (detector_data_valid && found_any) begin                          // <-- 修正后的代码
            frame_sync_found <= 1'b1;
            wnumber_dec      <= found_idx_latch; // 比特索引 0..31
          end
          // ===============================================================
        end

        S_VERIFY: begin
          frame_lock <= 1'b0;
          // ★ 改造：FSM 计数器在 header_end_delayed 更新
          if (header_end_d1) begin
            if (hit_in_frame) verify_cnt <= verify_cnt + 1'b1;
            else              verify_cnt <= 8'd0;
          end
        end

        S_LOCK: begin
          frame_lock <= 1'b1;
         
          // ★ 改造：wnumber_dec 的更新可以在 header_end_delayed 或 frame_end，这里保留在 frame_end
          if (frame_end) begin
            if (found_any) wnumber_dec <= priority_low_idx(wflag_delayed);
          end
        end

        S_PROTECT: begin
          frame_lock <= 1'b0;
          // ★ 改造：FSM 计数器在 header_end_delayed 更新
          if (header_end_d1) begin
            if (hit_in_frame) miss_cnt <= 8'd0;
            else              miss_cnt <= miss_cnt + 1'b1;
          end
        end
      endcase

      if (frame_lock) begin
        // ★ 修正 [Bug]：flocation 逻辑使用 [4:3] (字节车道)
        case (wnumber_dec[4:3]) 
          2'd0: flocation <= 4'b0001; // 字节 0
          2'd1: flocation <= 4'b0010; // 字节 1
          2'd2: flocation <= 4'b0100; // 字节 2
          2'd3: flocation <= 4'b1000; // 字节 3
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
        // ================ 修复 `S_SEARCH` 死锁 (Fix 2) =================
        // ★ 必须移除 in_header_delayed 检查
        // if (detector_data_valid && found_any && in_header_delayed) // <-- 错误的代码
        if (detector_data_valid && found_any)                          // <-- 修正后的代码
          next_state = S_VERIFY;
        // ===============================================================

      S_VERIFY: begin
        if (verify_reached)
          next_state = S_LOCK;
        // ★ 改造：FSM 判决点前移
        else if (header_end_d1 && !hit_in_frame)
          next_state = S_SEARCH;
      end

      S_LOCK:
        // ★ 改造：使用新的判决信号
        if (lock_missed_header)
          next_state = S_PROTECT;

      S_PROTECT: begin
        if (protect_timeout)
          next_state = S_SEARCH;
        else if (protect_relock)
          next_state = S_LOCK;
      end
    endcase
  end

  // ---------------- Output register ----------------

  assign header_blocking = tag_dout | (hdr_sup_cnt != {HDR_CNT_W{1'b0}});
  assign dout_fire_gate  = consume && !header_blocking;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout_valid <= 1'b0;
      dout       <= {PARALLEL{1'b0}};
    end else if (dout_fire_gate) begin
      dout_valid <= 1'b1;
      dout       <= data_dout; // FWFT
    end else begin
      dout_valid <= 1'b0;
    end
  end

  // ---------------- Param check（仿真提示） ----------------
  // // synthesis translate_off
  // initial begin
  //   if (FRAME_LEN_BYTE < (ASM_LEN/8)) begin
  //     $error("FRAME_LEN_BYTE (%0d) smaller than ASM_LEN/8 (%0d): header longer than frame!",
  //            FRAME_LEN_BYTE, (ASM_LEN/8));
  //   end
  //   if (HEADER_LEN_WORDS != 6) begin
  //     $display("NOTE: HEADER_LEN_WORDS=%0d (expected 6 when ASM_LEN=192, PARALLEL=32)", HEADER_LEN_WORDS);
  //   end
  // end
  // synthesis translate_on


  reg [15*9-1:0] ascii_state;

  always@(*)begin
    case(state)
      S_SEARCH :ascii_state = "SEARCH";
      S_VERIFY :ascii_state = "S_VERIFY";
      S_LOCK   :ascii_state = "S_LOCK";
      S_PROTECT:ascii_state = "S_PROTECT";
    endcase
  end

  // ==========================================================
  // ================ 仿真状态监控 (仅用于 TB) =================
  // ==========================================================
  // synthesis translate_off
  reg [1:0] prev_state;
  reg       prev_frame_lock;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      prev_state      <= S_SEARCH;
      prev_frame_lock <= 1'b0;
    end else begin
      
      // 监控 FSM 状态变化
      if (prev_state != state) begin
        $display("[%0t] [FSM] State change: %s -> %s", $time, ascii_state_str(prev_state), ascii_state_str(state));
      end
      
      // 监控锁存状态变化
      if (prev_frame_lock != frame_lock) begin
        if (frame_lock) $display("[%0t] >>> Frame LOCK ACQUIRED <<< (M_Verify=%d)", $time, M_VERIFY);
        else            $display("[%0t] !!! Frame LOCK LOST !!!", $time);
      end
      
      // 监控 FSM 关键判决点 (header_end_d1)
      if (header_end_d1) begin
         $display("[%0t] [FSM_TICK] state=%s | hit_in_frame=%b | verify_cnt=%d | miss_cnt=%d", 
                  $time, ascii_state_str(state), hit_in_frame, verify_cnt, miss_cnt);
      end
      
      // 监控丢帧 (S_LOCK)
      if (lock_missed_header) begin
          $display("[%0t] [WARN] Locked but current frame missed header!", $time);
      end

      // 监控 found_pulse
      if (found_pulse) begin
          $display("[%0t] [FOUND_PULSE] state=%s | in_header_delayed=%b | header_end_delayed=%b", 
                   $time, ascii_state_str(state), in_header_delayed, header_end_delayed);
          if (in_header_delayed && header_end_delayed) begin
              $display("[%0t] [WARN] found_pulse overlaps header_end_delayed, possible timing race!", $time);
          end
      end
      
      // 监控数据输出
      if (dout_fire_gate) begin
         $display("[%0t] [DOUT] Output data: %h", $time, data_dout);
      end
      
      prev_state      <= state;
      prev_frame_lock <= frame_lock;
    end
  end
  
  // 辅助函数：将 FSM 状态转换为字符串
  function [15*9-1:0] ascii_state_str;
    input [1:0] in_state;
    begin
       case(in_state)
         S_SEARCH : ascii_state_str = "SEARCH";
         S_VERIFY : ascii_state_str = "S_VERIFY";
         S_LOCK   : ascii_state_str = "S_LOCK";
         S_PROTECT: ascii_state_str = "S_PROTECT";
         default  : ascii_state_str = "INVALID";
       endcase
    end
  endfunction
  // synthesis translate_on
  // ==========================================================


endmodule

