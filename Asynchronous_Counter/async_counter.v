`timescale 1ns/1ps
// async_ripple_counter_4bit : asynchronous (ripple) binary up-counter.
// Only q[0] is driven by clk. Each higher bit toggles on the FALLING edge of the
// bit below it, so the clock "ripples" through the stages.
// Reset: asynchronous, active-low.
module async_ripple_counter_4bit (
    input            clk,
    input            rst_n,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q[0] <= 1'b0;
        else        q[0] <= ~q[0];
    end

    always @(negedge q[0] or negedge rst_n) begin
        if (!rst_n) q[1] <= 1'b0;
        else        q[1] <= ~q[1];
    end

    always @(negedge q[1] or negedge rst_n) begin
        if (!rst_n) q[2] <= 1'b0;
        else        q[2] <= ~q[2];
    end

    always @(negedge q[2] or negedge rst_n) begin
        if (!rst_n) q[3] <= 1'b0;
        else        q[3] <= ~q[3];
    end
endmodule
