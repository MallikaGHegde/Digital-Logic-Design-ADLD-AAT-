`timescale 1ns/1ps
// Self-checking testbench for divide_by_n (N = 4, 6 and 2 in parallel)
module tb_divide_by_n;

    reg  clk, rst_n;
    wire out4, out6, out2;
    integer i;
    integer rises4 = 0, rises6 = 0, rises2 = 0;
    reg ok4, ok6, ok2;

    divide_by_n #(.N(4)) d4 (.clk(clk), .rst_n(rst_n), .clk_out(out4));
    divide_by_n #(.N(6)) d6 (.clk(clk), .rst_n(rst_n), .clk_out(out6));
    divide_by_n #(.N(2)) d2 (.clk(clk), .rst_n(rst_n), .clk_out(out2));

    // Count rising edges of each divided clock
    always @(posedge out4) rises4 = rises4 + 1;
    always @(posedge out6) rises6 = rises6 + 1;
    always @(posedge out2) rises2 = rises2 + 1;

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

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Wait for a rising edge, then 1 ns so outputs have settled.
    // Inputs are changed right after this, away from the clock edge.
    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        $dumpfile("div_n.vcd");
        $dumpvars(0, tb_divide_by_n);
        errors = 0; tests = 0;
        rst_n = 1'b0;
        tick; tick;
        check(out4 === 1'b0 && out6 === 1'b0 && out2 === 1'b0, "Reset: divided clocks are low");
        rst_n = 1'b1;

        // clk_out toggles every N/2 clocks: after edge i it equals ((i / (N/2)) % 2)
        ok4 = 1'b1; ok6 = 1'b1; ok2 = 1'b1;
        for (i = 1; i <= 24; i = i + 1) begin
            tick;
            if (out4 !== (((i / 2) % 2) == 1)) ok4 = 1'b0;
            if (out6 !== (((i / 3) % 2) == 1)) ok6 = 1'b0;
            if (out2 !== (((i / 1) % 2) == 1)) ok2 = 1'b0;
        end
        check(ok4, "N = 4: output toggles every 2 clocks");
        check(ok6, "N = 6: output toggles every 3 clocks");
        check(ok2, "N = 2: output toggles every clock");
        check(rises4 == 6,  "N = 4: 6 output cycles in 24 clocks");
        check(rises6 == 4,  "N = 6: 4 output cycles in 24 clocks");
        check(rises2 == 12, "N = 2: 12 output cycles in 24 clocks");

        // ---- Asynchronous reset ----
        rst_n = 1'b0;
        #1;
        check(out4 === 1'b0 && out6 === 1'b0 && out2 === 1'b0, "Async reset forces outputs low");
        #1;
        rst_n = 1'b1;

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
