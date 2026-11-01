`timescale 1ns/1ps
// divide_by_n : divides the clock frequency by N (50% duty cycle output).
//   clk_out toggles every N/2 input clocks, so its period is N input clocks.
//   N must be an EVEN number >= 2.  WIDTH must be large enough to hold N/2 - 1.
//   Reset: asynchronous, active-low.
module divide_by_n #(
    parameter N     = 4,
    parameter WIDTH = 8
) (
    input      clk,
    input      rst_n,
    output reg clk_out
);
    reg [WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= {WIDTH{1'b0}};
            clk_out <= 1'b0;
        end
        else if (count == (N/2 - 1)) begin
            count   <= {WIDTH{1'b0}};
            clk_out <= ~clk_out;
        end
        else begin
            count <= count + 1'b1;
        end
    end
endmodule
