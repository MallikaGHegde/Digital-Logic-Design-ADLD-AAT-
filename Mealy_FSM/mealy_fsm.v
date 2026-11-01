`timescale 1ns/1ps
// mealy_seq_detector : Mealy FSM that detects the serial pattern 101
// (overlapping detection allowed: 10101 gives two detections).
//
//   State  meaning       din=0 -> next, det    din=1 -> next, det
//   S0     no match      S0, 0                 S1, 0
//   S1     seen "1"      S2, 0                 S1, 0
//   S2     seen "10"     S0, 0                 S1, 1   <-- detection
//
// det depends on the current state AND the current input din (Mealy).
module mealy_seq_detector (
    input      clk,
    input      rst_n,
    input      din,
    output reg det
);
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

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
            S2:      next_state = din ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (depends on state and input)
    always @(*) begin
        case (current_state)
            S0:      det = 1'b0;
            S1:      det = 1'b0;
            S2:      det = (din == 1'b1) ? 1'b1 : 1'b0;
            default: det = 1'b0;
        endcase
    end
endmodule
