`timescale 1ns/1ps
// lfsr_4bit : 4-bit Fibonacci LFSR, feedback polynomial x^4 + x^3 + 1
//   feedback = q_out[3] ^ q_out[2];  q_out <= {q_out[2:0], feedback}
//   Reset (async, active-low) -> 0001.   load = 1 -> q_out <= seed
//   (a zero seed is replaced by 0001, because 0000 would lock the LFSR).
//   Sequence length 15 (every nonzero 4-bit value once).
//   Pseudo-random only: the same seed always gives the same sequence.
module lfsr_4bit (
    input            clk,
    input            rst_n,
    input            load,
    input      [3:0] seed,
    output reg [3:0] q_out
);
    wire feedback;
    assign feedback = q_out[3] ^ q_out[2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_out <= 4'b0001;
        end
        else if (load) begin
            q_out <= (seed == 4'b0000) ? 4'b0001 : seed;
        end
        else begin
            q_out <= {q_out[2:0], feedback};
        end
    end
endmodule
