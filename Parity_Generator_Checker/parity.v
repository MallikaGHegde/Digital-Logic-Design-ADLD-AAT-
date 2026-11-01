`timescale 1ns/1ps
// parity_generator : builds a 5-bit frame {parity, data} for 4-bit data
//   parity_bit = ^data_in  -> 1 when the number of 1s is odd, so the frame
//   always carries an EVEN number of 1s.
//   odd_parity_bit is the opposite bit (frame with an ODD number of 1s).
module parity_generator (
    input  [3:0] data_in,          // 4-bit input data
    output [4:0] framed_out,       // {even parity bit, data}
    output       odd_parity_bit    // parity bit for odd-parity framing
);
    wire parity_bit;
    assign parity_bit     = ^data_in;
    assign framed_out     = {parity_bit, data_in};
    assign odd_parity_bit = ~parity_bit;
endmodule

// parity_checker : checks a received 5-bit frame
//   odd_mode = 0 : even parity expected    odd_mode = 1 : odd parity expected
//   error_detected = 1 when the frame breaks the expected parity.
//   (Single-bit errors are detected, double-bit errors are not.)
module parity_checker (
    input  [4:0] rx_frame,         // received frame {parity, data}
    input        odd_mode,
    output [3:0] data_out,
    output       error_detected
);
    assign data_out       = rx_frame[3:0];
    assign error_detected = (^rx_frame) ^ odd_mode;
endmodule
