`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Testbench for ScramblerDescrambler_Final (Corrected)
//
// Test Plan:
//   1. Reset the system.
//   2. Send a stream of known data (a simple counter) through the Scrambler.
//   3. Feed the scrambled data to the Descrambler.
//   4. Verify that the Descrambler's output matches the original data after initial latency.
//   5. Inject a single-bit error into the channel.
//   6. Verify that the Descrambler outputs a short burst of errors and then
//      AUTOMATICALLY recovers (self-synchronizes) to the correct data stream.
//
//////////////////////////////////////////////////////////////////////////////////
module tb_scrambler_descrambler;

    // --- Parameters (Must match the DUT) ---
    parameter POLY_LENGHT = 16;
    parameter NBITS       = 8;

    // --- Testbench Signals ---
    reg                CLK = 0;
    reg                RST;
    reg                EN = 0;
    reg  [NBITS-1:0]   original_data;

    wire [NBITS-1:0]   scrambled_data;
    wire [NBITS-1:0]   descrambled_data;
    
    // --- Error Injection ---
    reg                inject_error = 0;
    wire [NBITS-1:0]   channel_data;

    // --- Instantiate the Scrambler (CHK_MODE = 0) ---
    // [修改] 模块名与您的实际RTL文件名匹配
    ScramblerDescrambler #(
        .CHK_MODE     (0),
        .POLY_LENGHT  (POLY_LENGHT),
        .NBITS        (NBITS)
        // Using default taps
    ) u_scrambler (
        .RST      (RST),
        .CLK      (CLK),
        .DATA_IN  (original_data),
        .EN       (EN),
        .DATA_OUT (scrambled_data)
    );

    // --- Channel Model with Error Injection ---
    // Normally, channel_data is just scrambled_data.
    // When inject_error is high, we flip the LSB to create an error.
    assign channel_data = inject_error ? {scrambled_data[NBITS-1:1], ~scrambled_data[0]} : scrambled_data;

    // --- Instantiate the Descrambler (CHK_MODE = 1) ---
    // [修改] 模块名与您的实际RTL文件名匹配
    ScramblerDescrambler #(
        .CHK_MODE     (1),
        .POLY_LENGHT  (POLY_LENGHT),
        .NBITS        (NBITS)
        // Using default taps
    ) u_descrambler (
        .RST      (RST),
        .CLK      (CLK),
        .DATA_IN  (channel_data),
        .EN       (EN),
        .DATA_OUT (descrambled_data)
    );

    // --- Clock Generation ---
    always #5 CLK = ~CLK; // 100MHz clock

    // --- Test Stimulus ---
    initial begin
        // 1. Initialize and Reset
        RST = 1;
        EN = 0;
        original_data = 8'h00;
        $display("T=%0t: System Reset Asserted.", $time);
        #100;
        RST = 0;
        $display("T=%0t: System Reset De-asserted.", $time);
        #50;
        
        // 2. Start sending data
        EN = 1;
        $display("T=%0t: Starting data transmission.", $time);

        // Send 30 bytes of normal data
        repeat (30) begin
            @(posedge CLK);
            original_data <= original_data + 1;
        end

        // 3. Inject a single-cycle error
        @(posedge CLK);
        $display("T=%0t: >>> Injecting single-cycle error! <<<", $time);
        inject_error <= 1;
        original_data <= original_data + 1;
        
        @(posedge CLK);
        inject_error <= 0; // Error lasts for only one cycle
        original_data <= original_data + 1;
        
        $display("T=%0t: Error injection finished. Observing recovery.", $time);

        // 4. Send more data to observe recovery
        repeat (30) begin
            @(posedge CLK);
            original_data <= original_data + 1;
        end

        // 5. Finish simulation
        $display("T=%0t: Test finished.", $time);
        $finish;
    end
    
    // --- Self-Checking and Monitoring (Corrected Version) ---

    // [修改] 我们需要两级延迟寄存器来匹配2个周期的模块流水线延迟
    reg [NBITS-1:0] original_data_d1; // Delay stage 1
    reg [NBITS-1:0] original_data_d2; // Delay stage 2

    always @(posedge CLK) begin
        original_data_d1 <= original_data;
        original_data_d2 <= original_data_d1;
    end

    always @(posedge CLK) begin
        if (EN && !RST) begin
             // 等待系统稳定后再开始检查
            if ($time > 200) begin
                // [修改] 使用延迟2拍的数据进行对比
                if (descrambled_data !== original_data_d2) begin
                    $display("T=%0t: MISMATCH! Original: %h, Descrambled: %h", $time, original_data_d2, descrambled_data);
                end
            end
        end
    end

endmodule

