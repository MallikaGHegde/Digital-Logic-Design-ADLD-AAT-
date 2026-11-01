`timescale 1ns/1ps
// Self-checking testbench for async_ripple_counter_4bit
module tb_async_ripple_counter_4bit;

    reg        clk, rst_n;
    wire [3:0] q;
    integer    i;
    reg        ok;

    async_ripple_counter_4bit uut (.clk(clk), .rst_n(rst_n), .q(q));

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
        $dumpfile("async_counter.vcd");
        $dumpvars(0, tb_async_ripple_counter_4bit);
        errors = 0; tests = 0;
        // Reset applied as a real 1 -> 0 event; outputs are sampled 1 ns after the
        // clock edge, after the ripple has finished (zero-delay model).
        rst_n = 1'b1;
        #3 rst_n = 1'b0;
        tick;                              // hold reset across the first clock edge
        check(q === 4'd0, "Reset: all stages cleared");
        rst_n = 1'b1;

        // ---- Count through two rollovers (35 clocks) ----
        ok = 1'b1;
        for (i = 1; i <= 35; i = i + 1) begin
            tick;
            if (q !== (i % 16)) begin
                ok = 1'b0;
                $display("      clock %0d: got %0d expected %0d", i, q, i % 16);
            end
        end
        check(ok, "Counts 0..15 and wraps to 0 (two rollovers)");

        // ---- The carry ripples through every stage: 0111 -> 1000 ----
        tick; tick; tick; tick;            // q = 7
        check(q === 4'b0111, "Reached 0111");
        tick;
        check(q === 4'b1000, "Ripple through all stages: 0111 + 1 = 1000");

        // ---- Asynchronous reset ----
        tick;                              // 1001
        rst_n = 1'b0;
        #1;
        check(q === 4'd0, "Async reset clears the count immediately");
        #1;
        rst_n = 1'b1;
        tick;
        check(q === 4'd1, "Counting restarts from 0 after reset");

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
