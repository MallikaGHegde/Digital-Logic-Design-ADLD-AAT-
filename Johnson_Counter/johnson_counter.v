`timescale 1ns/1ps
// johnson_counter : twisted-ring counter (2*WIDTH states)
//   Reset (async, active-low) -> 0000.  Each clock: shift left and feed the
//   INVERTED MSB back into the LSB.
module johnson_counter #(
    parameter WIDTH = 4
) (
    input                  clk,
    input                  rst_n,
    output reg [WIDTH-1:0] q_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q_out <= {WIDTH{1'b0}};
        else
            q_out <= {q_out[WIDTH-2:0], ~q_out[WIDTH-1]};
    end
endmodule
