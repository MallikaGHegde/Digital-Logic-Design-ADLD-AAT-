`timescale 1ns/1ps
// moore_seq_detector : Moore FSM that detects the serial pattern 101
// (overlapping detection allowed).
//
//   State  meaning         din=0   din=1   det
//   S0     no match        S0      S1      0
//   S1     seen "1"        S2      S1      0
//   S2     seen "10"       S0      S3      0
//   S3     seen "101"      S2      S1      1
//
// det depends only on the state (Moore), so it appears one clock after the last bit.
module moore_seq_detector (
    input      clk,
    input      rst_n,
    input      din,
    output reg det
);
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] current_state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= S0;
        else        current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (current_state)
            S0:      next_state = din ? S1 : S0;
            S1:      next_state = din ? S1 : S2;
            S2:      next_state = din ? S3 : S0;
            S3:      next_state = din ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic (depends on state only)
    always @(*) begin
        det = (current_state == S3) ? 1'b1 : 1'b0;
    end
endmodule
