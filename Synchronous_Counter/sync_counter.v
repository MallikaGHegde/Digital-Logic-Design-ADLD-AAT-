`timescale 1ns/1ps
// sync_counter_4bit : synchronous binary up-counter.
// Every flip-flop uses the same clock, so all bits change together.
// Reset: asynchronous, active-low.  enable = 0 holds the count.
module sync_counter_4bit (
    input            clk,
    input            rst_n,
    input            enable,
    output reg [3:0] q          // 4-bit synchronous output
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else if (enable)
            q <= q + 1'b1;
    end
endmodule
