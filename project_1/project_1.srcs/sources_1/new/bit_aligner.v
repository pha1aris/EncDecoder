module bit_aligner #(
    parameter integer W                 = 32,
    parameter integer VERIFY_CNT_MAX    = 8,
    parameter integer SLIDE_COOLDOWN    = 5,
    parameter integer ERR_TH            = 0,
    parameter integer CHECK_TIMEOUT_MAX = 2048 
)(
    input                       clk,
    input                       rst_n,
    input                       rx_reset_done,
    input                       rx_cdr_stable,
    
    input       [W-1:0]         i_rx_data,
    input                       i_rx_valid,
    
    input                       i_realign_req,

    output  reg                 o_rxslide,
    output  wire                o_aligned_valid,   // 由内部寄存器驱动
    output                      o_bit_locked,
    output      [W-1:0]         o_data_aligned
);

    localparam [W-1:0] ALIGN_WORD = 32'hEB94_BDA3;

    localparam [1:0] S_IDLE            = 2'd0;
    localparam [1:0] S_CHECK_ALIGNMENT = 2'd1;
    localparam [1:0] S_SLIP_BIT        = 2'd2;

    reg [1:0]  state;
    reg [7:0]  verify_cnt;
    reg [7:0]  slide_cooldown_cnt;
    reg        locked_reg;

    localparam integer CHECK_TIMEOUT_WIDTH = $clog2(CHECK_TIMEOUT_MAX + 1);
    reg [CHECK_TIMEOUT_WIDTH-1:0] timeout_counter;

    assign o_bit_locked = locked_reg;

    // ---------------- popcount & 匹配 ----------------
    function [5:0] popcount;
        input [W-1:0] v;
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < W; i = i + 1)
                popcount = popcount + v[i];
        end
    endfunction

    wire [W-1:0] diff         = i_rx_data ^ ALIGN_WORD;
    wire [5:0]   err_bits     = popcount(diff);
    wire         header_match = i_rx_valid && (err_bits <= ERR_TH);

    // ---------------- 数据 & valid 打一拍 ----------------

    wire lock_now = (state == S_CHECK_ALIGNMENT) &&
                    (!locked_reg) &&
                    i_rx_valid &&
                    header_match &&
                    (verify_cnt == VERIFY_CNT_MAX-1);

    // 这一拍结束后，locked 将要变成的值
    wire locked_next = locked_reg | lock_now;
        
    reg [W-1:0] data_aligned_reg;
    reg         aligned_valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_aligned_reg  <= {W{1'b0}};
            aligned_valid_reg <= 1'b0;
        end else begin
            // 数据：有 valid 就采样
            if (i_rx_valid)
                data_aligned_reg <= i_rx_data;

            // valid：用 locked_next 来门控
            if (!locked_next)
                aligned_valid_reg <= 1'b0;
            else
                aligned_valid_reg <= i_rx_valid;
        end
    end

    assign o_data_aligned  = data_aligned_reg;
    assign o_aligned_valid = aligned_valid_reg;
    assign o_bit_locked    = locked_reg;


    // ---------------- 主状态机：搜索 + 滑位 ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || !rx_cdr_stable || !rx_reset_done || i_realign_req) begin
            state              <= S_IDLE;
            verify_cnt         <= 8'd0;
            slide_cooldown_cnt <= 8'd0;
            o_rxslide          <= 1'b0;
            locked_reg         <= 1'b0;
            timeout_counter    <= 'd0;
        end else begin
            o_rxslide <= 1'b0;

            // 统一在这里更新 locked_reg
            locked_reg <= locked_next;

            if (slide_cooldown_cnt != 0)
                slide_cooldown_cnt <= slide_cooldown_cnt - 1'b1;

            case (state)
                S_IDLE: begin
                    verify_cnt      <= 8'd0;
                    timeout_counter <= 'd0;
                    if (rx_cdr_stable && rx_reset_done)
                        state <= S_CHECK_ALIGNMENT;
                end

                S_CHECK_ALIGNMENT: begin
                    if (!locked_reg) begin
                        if (i_rx_valid) begin
                            if (header_match) begin
                                timeout_counter <= 'd0;
                                // 只管计数，不再这里锁定
                                if (verify_cnt != VERIFY_CNT_MAX-1)
                                    verify_cnt <= verify_cnt + 1'b1;
                            end else begin
                                if (timeout_counter == CHECK_TIMEOUT_MAX) begin
                                    verify_cnt      <= 8'd0;
                                    state           <= S_SLIP_BIT;
                                    timeout_counter <= 'd0;
                                end else begin
                                    timeout_counter <= timeout_counter + 1'b1;
                                end
                            end
                        end
                    end
                    // locked_reg=1 之后，这里就不再动 verify_cnt/timeout
                end

                S_SLIP_BIT: begin
                    if (!locked_reg) begin
                        if (slide_cooldown_cnt == 0) begin
                            o_rxslide          <= 1'b1;
                            slide_cooldown_cnt <= SLIDE_COOLDOWN;
                        end
                    end
                    state <= S_CHECK_ALIGNMENT;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
