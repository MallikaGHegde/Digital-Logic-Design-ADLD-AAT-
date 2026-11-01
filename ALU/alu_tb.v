`timescale 1ns/1ps
// Self-checking testbench for alu_3bit
module tb_alu_3bit;

    reg  [2:0] A, B, ALU_Sel;
    wire [2:0] ALU_Out;
    wire       Carry_Out, Zero;

    alu_3bit uut (.A(A), .B(B), .ALU_Sel(ALU_Sel),
                  .ALU_Out(ALU_Out), .Carry_Out(Carry_Out), .Zero(Zero));

    integer errors, tests;

    task check;
        input condition;
        input [8*48-1:0] label;
        begin
            tests = tests + 1;
            if (condition) $display("PASS: %0s", label);
            else begin
                errors = errors + 1;
                $display("FAIL: %0s (time %0t)", label, $time);
            end
        end
    endtask

    // Apply one operation and compare result, carry and zero flag
    task run;
        input [2:0] sel, ia, ib, exp_out;
        input       exp_c;
        input [8*48-1:0] label;
        begin
            ALU_Sel = sel; A = ia; B = ib;
            #10;
            check((ALU_Out === exp_out) && (Carry_Out === exp_c) &&
                  (Zero === (exp_out == 3'b000)), label);
            if (ALU_Out !== exp_out)
                $display("      got out=%b carry=%b, expected out=%b carry=%b",
                         ALU_Out, Carry_Out, exp_out, exp_c);
        end
    endtask

    initial begin
        $dumpfile("alu_3bit.vcd");
        $dumpvars(0, tb_alu_3bit);
        errors = 0; tests = 0;
        A = 0; B = 0; ALU_Sel = 0;
        #10;
        //  sel   A     B     out    carry
        run(3'b000, 3'd5, 3'd3, 3'd0, 1, "ADD 5+3 = 8 -> out 000, carry, zero");
        run(3'b000, 3'd2, 3'd3, 3'd5, 0, "ADD 2+3 = 5");
        run(3'b000, 3'd7, 3'd7, 3'd6, 1, "ADD 7+7 = 14 -> out 110, carry");
        run(3'b001, 3'd6, 3'd2, 3'd4, 0, "SUB 6-2 = 4");
        run(3'b001, 3'd3, 3'd3, 3'd0, 0, "SUB 3-3 = 0 (zero flag)");
        run(3'b001, 3'd2, 3'd6, 3'd4, 1, "SUB 2-6 -> borrow, out 100");
        run(3'b010, 3'd5, 3'd5, 3'd5, 0, "AND 101 & 101");
        run(3'b010, 3'd5, 3'd2, 3'd0, 0, "AND 101 & 010 = 0 (zero flag)");
        run(3'b011, 3'd4, 3'd3, 3'd7, 0, "OR 100 | 011");
        run(3'b100, 3'd5, 3'd3, 3'd6, 0, "XOR 101 ^ 011");
        run(3'b100, 3'd5, 3'd5, 3'd0, 0, "XOR same -> zero flag");
        run(3'b101, 3'd3, 3'd0, 3'd6, 0, "SHL 011 -> 110");
        run(3'b101, 3'd5, 3'd0, 3'd2, 0, "SHL 101 -> 010 (MSB lost)");
        run(3'b110, 3'd6, 3'd0, 3'd3, 0, "SHR 110 -> 011");
        run(3'b110, 3'd1, 3'd0, 3'd0, 0, "SHR 001 -> 000 (zero flag)");
        run(3'b111, 3'd6, 3'd6, 3'd1, 0, "EQ: 110 == 110 -> 001");
        run(3'b111, 3'd6, 3'd2, 3'd0, 0, "EQ: 110 != 010 -> 000");

        $display("----------------------------------------");
        $display("Tests run: %0d, Failures: %0d", tests, errors);
        if (errors == 0) $display("RESULT: PASSED");
        else             $display("RESULT: FAILED");
        $finish;
    end

    // Timeout guard
    initial begin
        #100000;
        $display("FAIL: simulation timeout");
        $display("RESULT: FAILED");
        $finish;
    end

endmodule
