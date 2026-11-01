`timescale 1ns/1ps
// timer_module : down-counting timer
//   load  = 1 : count_out <= preset_val, timeout cleared
//   start = 1 : count_out counts down by 1 each clock
//   timeout   : goes high when count_out reaches 0 and stays high until the
//               next load or reset.  start = 0 pauses the countdown.
// Reset is asynchronous and active-low (rst_n).
module timer_module #(
    parameter WIDTH = 4
) (
    input                  clk,         // System clock
    input                  rst_n,       // Active-low asynchronous reset
    input                  start,       // Count down while high
    input                  load,        // Load preset value
    input  [WIDTH-1:0]     preset_val,
    output reg             timeout,
    output reg [WIDTH-1:0] count_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_out <= {WIDTH{1'b0}};
            timeout   <= 1'b0;
        end
        else if (load) begin
            count_out <= preset_val;
            timeout   <= 1'b0;
        end
        else if (start) begin
            if (count_out > {WIDTH{1'b0}}) begin
                count_out <= count_out - 1'b1;
                if (count_out == {{(WIDTH-1){1'b0}}, 1'b1})
                    timeout <= 1'b1;      // count is about to become 0
            end
            else begin
                timeout <= 1'b1;          // already at 0
            end
        end
    end
endmodule
