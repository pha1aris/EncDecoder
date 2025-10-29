`timescale 1ns/1ps
module frame_synchronizer_top #(
    parameter PARALLEL          = 32,       // RX word width
    parameter MASK_LEN          = 192,      // ASM bits
    parameter ASM_LEN           = 192,
    parameter TOLERANCE         = 0,
    parameter FRAME_LEN_BYTE    = 64,       // full frame length in bytes
    parameter M_VERIFY          = 2,        // need M consecutive hits to lock
    parameter N_PROTECT         = 2,        // miss N frames to drop lock
    parameter PIPELINE_LATENCY  = 4,        // match engine latency (cycles)
    parameter FIFO_DEPTH_BITS   = 4         // not used by IP here, keep for ref
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
    output reg                    slip_detected,      // kept 0
    output reg  signed [2:0]      slip_amount,        // kept 0
    output reg  [PARALLEL-1:0]    dout,
    output reg                    dout_valid
);
  // ---------------- Const ----------------
  localparam integer BYTES_PER_CYCLE        = PARALLEL/8;                         // 4
  localparam integer HEADER_LEN_WORDS       = ((ASM_LEN/8)+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE; // 24B -> 6
  localparam integer TOTAL_WORDS_PER_FRAME  = (FRAME_LEN_BYTE+BYTES_PER_CYCLE-1)/BYTES_PER_CYCLE; // 64B->16
  localparam integer HDR_CNT_W              = (HEADER_LEN_WORDS<=1)?1:$clog2(HEADER_LEN_WORDS+1);

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
      .PARALLEL (PARALLEL),
      .MASK_LEN (MASK_LEN),
      .ASM_LEN  (ASM_LEN),
      .TOLERANCE(TOLERANCE)
  ) u_pipelined (
      .clk               (clk),
      .rst_n             (rst_n),
      .din               (din),
      .din_valid         (din_valid),
      .asm_pattern       (asm_pattern),
      .asm_mask          (asm_mask),
      .wflag_reg_out_wire(wflag_reg_out_wire),
      .wflag_reg_out     (wflag_reg_out)
  );

  always @(posedge clk or negedge rst_n)
    if (!rst_n) wflag_delayed <= {PARALLEL{1'b0}};
    else        wflag_delayed <= wflag_reg_out;

  // ---------------- Helpers for FSM ----------------
  wire        found_any = |wflag_delayed;
  wire        detector_data_valid; // defined below
  wire        found_pulse = detector_data_valid && found_any;

  function [4:0] priority_low_idx;
    input [PARALLEL-1:0] vec;
    integer j; reg found; reg [4:0] idx;
    begin
      idx=5'd0; found=1'b0;
      for (j=0; j<PARALLEL; j=j+1)
        if (vec[j] && !found) begin idx=j[4:0]; found=1'b1; end
      priority_low_idx = idx;
    end
  endfunction
  wire [4:0] found_idx_latch = priority_low_idx(wflag_delayed);

  reg hit_in_frame;

  // ---------------- Input-side frame counter (for FSM only) ----------------
  reg  [15:0] fcnt4, fcnt4_init_val;
  wire will_wrap      = din_valid && (fcnt4 + BYTES_PER_CYCLE >= FRAME_LEN_BYTE);
  wire frame_end_raw  = will_wrap;
  reg  frame_start_raw;

  // “下一帧首” = frame_end_raw 的下一拍
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) frame_start_raw <= 1'b0;
    else        frame_start_raw <= frame_end_raw;
  end

  // 把边界与 valid 延迟到匹配引擎输出同拍（仅供 FSM 判据）
  reg [PIPELINE_LATENCY-1:0] start_shift, end_shift, valid_shift;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_shift <= {PIPELINE_LATENCY{1'b0}};
      end_shift   <= {PIPELINE_LATENCY{1'b0}};
      valid_shift <= {PIPELINE_LATENCY{1'b0}};
    end else begin
      start_shift <= {start_shift[PIPELINE_LATENCY-2:0], frame_start_raw};
      end_shift   <= {end_shift  [PIPELINE_LATENCY-2:0], frame_end_raw};
      valid_shift <= {valid_shift[PIPELINE_LATENCY-2:0], din_valid};
    end
  end

  wire frame_start         = start_shift[PIPELINE_LATENCY-1];
  wire frame_end           = end_shift  [PIPELINE_LATENCY-1];
  assign detector_data_valid = valid_shift[PIPELINE_LATENCY-1];

  // fcnt4 update
  wire entering_lock = (state!=S_LOCK) && (next_state==S_LOCK);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fcnt4 <= 16'd0;
    end else if (state==S_SEARCH && next_state==S_VERIFY) begin
      fcnt4 <= fcnt4_init_val;   // 0..3   （注意：这是老版本当拍加载相位的行为）
    end 
    else if (din_valid) begin
      if (will_wrap) fcnt4 <= 16'd0;
      else           fcnt4 <= fcnt4 + BYTES_PER_CYCLE;
    end
  end

  // “本帧是否命中过”标志（老版本：在 frame_start 冻结上一帧）
  reg   prev_hit;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin             
      hit_in_frame <= 1'b0;
      prev_hit <= 1'b0;
    end else begin
      if (frame_start) begin 
        prev_hit     <= hit_in_frame;  // 先冻结上一帧的结果，再清零新一帧的累计  
        hit_in_frame <= 1'b0;
      end else if (found_pulse)        // 只在非帧首的周期内累加命中     
        hit_in_frame <= 1'b1;
    end
  end

  // ---------------- 写口暂停：锁定→清空→等到下一帧首再恢复写 ----------------
  reg hold_writes_until_fs;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)               hold_writes_until_fs <= 1'b0;
    else if (entering_lock)   hold_writes_until_fs <= 1'b1;
    else if (frame_start_raw) hold_writes_until_fs <= 1'b0;
  end

  // 帧首当拍允许写入，避免漏首字
  wire wr_ok          = din_valid && !wr_rst_busy;
  wire frame_start_wr = wr_ok && frame_start_raw; 
  wire [PARALLEL:0] fifo_din = {frame_start_wr, din};

  // ---------------- 单个 Xilinx 同步 FIFO（33bit，FWFT） ----------------
  // 把 1bit 标签与 32bit 数据打包写入
  wire                 fifo_srst   = ~rst_n | entering_lock;
  wire [PARALLEL:0]    fifo_dout_ext;
  wire                 full, empty;
  wire                 wr_rst_busy, rd_rst_busy;

  wire tag_dout              = fifo_dout_ext[PARALLEL];
  wire [PARALLEL-1:0] data_dout = fifo_dout_ext[PARALLEL-1:0];

  // 统一读使能：锁定后，只要 FIFO 非空且读不在复位，就消费
  wire have_word  = !empty && !rd_rst_busy;
  wire consume    = (state==S_LOCK) && have_word;

  // 这里的模块名/端口名，用你的 FIFO IP 名称替换（需把 IP 位宽设为 33）
  sync_fifo u_fifo (
    .clk  (clk),
    .srst (~rst_n | entering_lock),   // 仅清空 FIFO，别改 fcnt4
    .din  (fifo_din),                 // 33b: {tag,data}
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
        hdr_sup_cnt <= SUPPRESS_AFTER_TAG[HDR_CNT_W-1:0]; // 帧首当拍屏蔽，装载余下个数
      end else if (hdr_sup_cnt != {HDR_CNT_W{1'b0}}) begin
        hdr_sup_cnt <= hdr_sup_cnt - {{(HDR_CNT_W-1){1'b0}},1'b1};
      end
    end
  end

  wire header_blocking = tag_dout | (hdr_sup_cnt != {HDR_CNT_W{1'b0}});
  wire dout_fire_gate  = consume && !header_blocking;

  // ---------------- FSM & book-keeping ----------------
  reg [7:0] verify_cnt, miss_cnt;
  localparam [7:0] M_VERIFY_U8  = M_VERIFY;
  localparam [7:0] N_PROTECT_U8 = N_PROTECT;

  //上一帧是否失锁（老版本：用 prev_hit）
  wire lock_missed_prev = (state == S_LOCK) && frame_start && !prev_hit;

  wire verify_reached  = (state==S_VERIFY)  && frame_end && (prev_hit ? (verify_cnt + 8'd1) >= M_VERIFY_U8 : 1'b0);
  wire protect_timeout = (state==S_PROTECT) && frame_end && !prev_hit && ((miss_cnt + 8'd1) >= N_PROTECT_U8);
  wire protect_relock  = (state==S_PROTECT) && frame_end &&  prev_hit;

  reg [31:0] wfh_deduce;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state            <= S_SEARCH;
      verify_cnt       <= 8'd0;
      miss_cnt         <= 8'd0;
      frame_lock       <= 1'b0;
      frame_sync_found <= 1'b0;
      wnumber_dec      <= 5'd0;
      flocation        <= 4'b0000;
      slip_detected    <= 1'b0;
      slip_amount      <= 3'sd0;
      wfh_deduce       <= 32'd0;
      fcnt4_init_val   <= 16'd0;
    end else begin
      state            <= next_state;
      frame_sync_found <= 1'b0;
      slip_detected    <= 1'b0;
      slip_amount      <= 3'sd0;

      case (state)
        S_SEARCH: begin
          frame_lock <= 1'b0;
          verify_cnt <= 8'd0;
          miss_cnt   <= 8'd0;
          if (detector_data_valid && found_any) begin
            frame_sync_found <= 1'b1;
            wfh_deduce       <= wflag_delayed;
            wnumber_dec      <= found_idx_latch;
            if      (|wflag_delayed[31:24]) fcnt4_init_val <= 16'd3;
            else if (|wflag_delayed[23:16]) fcnt4_init_val <= 16'd2;
            else if (|wflag_delayed[15: 8]) fcnt4_init_val <= 16'd1;
            else                            fcnt4_init_val <= 16'd0;
          end
        end

        S_VERIFY: begin
          frame_lock <= 1'b0;
          if (frame_end) begin
            if (prev_hit) verify_cnt <= verify_cnt + 1'b1;
            else          verify_cnt <= 8'd0;
          end
        end

        S_LOCK: begin
          frame_lock <= 1'b1;
          if (frame_end) begin
            case (FRAME_LEN_BYTE % 4)
              0: wfh_deduce <= wfh_deduce;
              1: wfh_deduce <= { wfh_deduce[7:0],  wfh_deduce[31:8]  };
              2: wfh_deduce <= { wfh_deduce[15:0], wfh_deduce[31:16] };
              3: wfh_deduce <= { wfh_deduce[23:0], wfh_deduce[31:24] };
            endcase
            if (found_any) wnumber_dec <= priority_low_idx(wflag_delayed);
          end
        end

        S_PROTECT: begin
          frame_lock <= 1'b0;
          if (frame_end) begin
            if (prev_hit) miss_cnt <= 8'd0;
            else          miss_cnt <= miss_cnt + 1'b1;
          end
        end
      endcase

      if (frame_lock) begin
        case (wnumber_dec[2:0])
          3'd0: flocation <= 4'b0001;
          3'd1: flocation <= 4'b0010;
          3'd2: flocation <= 4'b0100;
          3'd3: flocation <= 4'b1000;
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
        if (verify_reached)
          next_state = S_LOCK;
        else if (frame_end && !prev_hit)
          next_state = S_SEARCH;
      end

      S_LOCK:
        if (lock_missed_prev)
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
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dout_valid <= 1'b0;
      dout       <= {PARALLEL{1'b0}};
    end else if (dout_fire_gate) begin
      dout_valid <= 1'b1;
      dout       <= data_dout;   // FWFT：当前拍已经是被消费的这个字
    end else begin
      dout_valid <= 1'b0;
    end
  end

  // ---------------- Param check（仿真提示） ----------------
  // synthesis translate_off
  initial begin
    if (FRAME_LEN_BYTE < (ASM_LEN/8)) begin
      $error("FRAME_LEN_BYTE (%0d) smaller than ASM_LEN/8 (%0d): header longer than frame!",
             FRAME_LEN_BYTE, (ASM_LEN/8));
    end
    if (HEADER_LEN_WORDS != 6) begin
      $display("NOTE: HEADER_LEN_WORDS=%0d (expected 6 when ASM_LEN=192, PARALLEL=32)", HEADER_LEN_WORDS);
    end
  end
  // synthesis translate_on
endmodule
