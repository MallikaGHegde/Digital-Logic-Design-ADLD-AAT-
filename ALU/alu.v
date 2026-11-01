`timescale 1ns/1ps
// alu_3bit : simple 3-bit combinational ALU with carry/borrow and zero flags
//
//  ALU_Sel  operation
//  000      A + B            (Carry_Out = carry)
//  001      A - B            (Carry_Out = borrow, 1 when A < B)
//  010      A & B
//  011      A | B
//  100      A ^ B
//  101      A << 1 (logical shift left)
//  110      A >> 1 (logical shift right)
//  111      equality check (001 if A == B, else 000)
module alu_3bit (
    input  [2:0] A,             // Input operand A
    input  [2:0] B,             // Input operand B
    input  [2:0] ALU_Sel,       // Operation select
    output reg [2:0] ALU_Out,   // 3-bit result
    output reg Carry_Out,       // Carry / borrow flag
    output reg Zero             // Zero flag
);
    always @(*) begin
        // Default assignments to prevent latches
        ALU_Out   = 3'b000;
        Carry_Out = 1'b0;

        case (ALU_Sel)
            3'b000: {Carry_Out, ALU_Out} = A + B;
            3'b001: {Carry_Out, ALU_Out} = A - B;
            3'b010: ALU_Out = A & B;
            3'b011: ALU_Out = A | B;
            3'b100: ALU_Out = A ^ B;
            3'b101: ALU_Out = A << 1;
            3'b110: ALU_Out = A >> 1;
            3'b111: ALU_Out = (A == B) ? 3'b001 : 3'b000;
            default: begin
                ALU_Out   = 3'b000;
                Carry_Out = 1'b0;
            end
        endcase

        // Zero flag goes high if the output is 0
        Zero = (ALU_Out == 3'b000) ? 1'b1 : 1'b0;
    end
endmodule
