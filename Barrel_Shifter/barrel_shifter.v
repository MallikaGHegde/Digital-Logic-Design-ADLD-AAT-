`timescale 1ns/1ps
// barrel_shifter_4bit : logical shifter, shifts by 0..3 in one step
module barrel_shifter_4bit (
    input  [3:0] data_in,          // 4-bit input data
    input  [1:0] shift_amt,        // 2-bit shift amount
    input        dir,              // 0: shift left, 1: shift right
    output reg [3:0] data_out      // 4-bit shifted output
);
    always @(*) begin
        if (dir == 1'b0) begin     // Logical shift left
            case (shift_amt)
                2'b00:   data_out = data_in;
                2'b01:   data_out = {data_in[2:0], 1'b0};
                2'b10:   data_out = {data_in[1:0], 2'b00};
                2'b11:   data_out = {data_in[0], 3'b000};
                default: data_out = data_in;
            endcase
        end else begin             // Logical shift right
            case (shift_amt)
                2'b00:   data_out = data_in;
                2'b01:   data_out = {1'b0, data_in[3:1]};
                2'b10:   data_out = {2'b00, data_in[3:2]};
                2'b11:   data_out = {3'b000, data_in[3]};
                default: data_out = data_in;
            endcase
        end
    end
endmodule
