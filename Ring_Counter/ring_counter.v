`timescale 1ns/1ps
// ring_counter : one-hot ring counter with optional seed load
//   Reset (async, active-low) -> 0001.   load = 1 -> q_out <= seed.
//   Otherwise the register rotates left every clock.
module ring_counter #(
    parameter WIDTH = 4
) (
    input                  clk,
    input                  rst_n,
    input                  load,
    input  [WIDTH-1:0]     seed,
    output reg [WIDTH-1:0] q_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q_out <= {{(WIDTH-1){1'b0}}, 1'b1};
        else if (load)
            q_out <= seed;
        else
            q_out <= {q_out[WIDTH-2:0], q_out[WIDTH-1]};
    end
endmodule
