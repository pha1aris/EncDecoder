`timescale 1ns/1ps
module rx_block_gate_word0 #(
  parameter integer W = 32
)(
  input  wire             clk,
  input  wire             rst_n,

  input  wire [15:0]      block_id,          // 来自 deframer（header sideband）
  input  wire             frame_start_word0, // deframer m_axis_tuser[1]

  input  wire [W-1:0]     s_tdata,
  input  wire             s_tvalid,
  output wire             s_tready,

  output wire [W-1:0]     m_tdata,
  output wire             m_tvalid,
  input  wire             m_tready,

  output wire             sync_word0
);

  localparam ST_DROP = 1'b0;
  localparam ST_PASS = 1'b1;

  reg st;

  // 1-word hold，保证切入点word0不会因下游not-ready丢失
  reg [W-1:0] hold_d;
  reg         hold_v;
  reg         hold_sync;

  reg [15:0] last_block_id;

  assign s_tready =
      (st == ST_DROP) ? 1'b1 :
      (!hold_v ? m_tready : 1'b0);

  wire s_fire = s_tvalid && s_tready;

  assign m_tvalid   = hold_v ? 1'b1 :
                      ((st == ST_PASS) ? s_tvalid : 1'b0);
  assign m_tdata    = hold_v ? hold_d : s_tdata;
  assign sync_word0 = hold_v ? hold_sync : 1'b0;

  wire m_fire = m_tvalid && m_tready;

  wire word0_fire = s_fire && frame_start_word0;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      st           <= ST_DROP;
      hold_v       <= 1'b0;
      hold_d       <= {W{1'b0}};
      hold_sync    <= 1'b0;
      last_block_id<= 16'hFFFF; // 强制第一次看到word0就可切入
    end else begin
      if (hold_v && m_fire) begin
        hold_v    <= 1'b0;
        hold_sync <= 1'b0;
      end

      case (st)
        ST_DROP: begin
          // 只在word0边界判断 block_id 是否更新
          if (word0_fire) begin
            if (block_id != last_block_id) begin
              // 在这个word0开始放行
              hold_d    <= s_tdata;
              hold_v    <= 1'b1;
              hold_sync <= 1'b1;  // 给后面的32->8/RS计数器对齐用
              st        <= ST_PASS;
            end
            last_block_id <= block_id;
          end
        end

        ST_PASS: begin
          // 最简单：一旦进入PASS就一直PASS
          // （如果你希望每次块变化都重新对齐，也可以在word0_fire时再打一拍hold_sync）
          if (word0_fire) begin
            last_block_id <= block_id;
          end
        end
      endcase
    end
  end

endmodule
