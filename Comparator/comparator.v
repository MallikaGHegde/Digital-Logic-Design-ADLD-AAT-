`timescale 1ns/1ps
// comparator_3bit : unsigned magnitude comparator (exactly one output is high)
module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output A_greater,   // High if A > B
    output A_less,      // High if A < B
    output A_equal      // High if A == B
);
    assign A_greater = (A > B);
    assign A_less    = (A < B);
    assign A_equal   = (A == B);
endmodule
