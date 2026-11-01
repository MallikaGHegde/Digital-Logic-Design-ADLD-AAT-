`timescale 1ns/1ps
// Self-checking testbench for sync_counter_4bit
module tb_sync_counter_4bit;

    reg        clk, rst_n, enable;
    wire [3:0] q;
    integer    i;
    reg        ok;

    sync_counter_4bit uut (.clk(clk), .rst_n(rst_n), .enable(enable), .q(q));

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
        $dumpfile("sync_counter.vcd");
        $dumpvars(0, tb_sync_counter_4bit);
        errors = 0; tests = 0;
        rst_n = 1'b0; enable = 1'b0;
        tick; tick;
        check(q === 4'd0, "Reset: count = 0");
        rst_n = 1'b1;
        tick;
        check(q === 4'd0, "Disabled: count held at 0");

        // ---- Count through two rollovers (35 clocks) ----
        enable = 1'b1;
        ok = 1'b1;
        for (i = 1; i <= 35; i = i + 1) begin
            tick;
            if (q !== (i % 16)) begin
                ok = 1'b0;
                $display("      clock %0d: got %0d expected %0d", i, q, i % 16);
            end
        end
        check(ok, "Counts 0..15 and wraps to 0 (two rollovers)");

        // ---- Enable low holds the count (q = 3 here) ----
        enable = 1'b0;
        tick; tick; tick;
        check(q === 4'd3, "enable = 0 holds the count");
        enable = 1'b1;
        tick;
        check(q === 4'd4, "Counting resumes when enable returns");

        // ---- Asynchronous reset ----
        rst_n = 1'b0;
        #1;
        check(q === 4'd0, "Async reset clears the count immediately");
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
