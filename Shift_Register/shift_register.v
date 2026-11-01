`timescale 1ns/1ps
// universal_shift_register : hold / shift right / shift left / parallel load
//   sel = 00 hold      sel = 01 shift right (serial_in_right enters the MSB)
//   sel = 10 shift left (serial_in_left enters the LSB)   sel = 11 parallel load
// Reset: asynchronous, active-low.
// Serial-in serial-out (SISO) use: sel = 01 and watch q_out[0] (or sel = 10 and q_out[WIDTH-1]).
module universal_shift_register #(
    parameter WIDTH = 4
) (
    input                  clk,
    input                  rst_n,
    input  [1:0]           sel,
    input                  serial_in_right,
    input                  serial_in_left,
    input  [WIDTH-1:0]     parallel_in,
    output reg [WIDTH-1:0] q_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_out <= {WIDTH{1'b0}};
        end else begin
            case (sel)
                2'b00:   q_out <= q_out;
                2'b01:   q_out <= {serial_in_right, q_out[WIDTH-1:1]};
                2'b10:   q_out <= {q_out[WIDTH-2:0], serial_in_left};
                2'b11:   q_out <= parallel_in;
                default: q_out <= q_out;
            endcase
        end
    end
endmodule
