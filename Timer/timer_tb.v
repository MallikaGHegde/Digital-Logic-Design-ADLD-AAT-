module tb_timer_module;
parameter WIDTH = 4;
reg clk;
reg rst_n;
reg start;
reg load;
reg [WIDTH-1:0] preset_val;
wire timeout;
wire [WIDTH-1:0] count_out;
timer_module (.WIDTH(WIDTH)) uut (
.clk(clk), .rst_n(rst_n), .start(start), .load(load),
.preset_val(preset_val), .timeout(timeout),
.count_out(count_out) );
always #5 clk = ~clk;
initial begin
clk = 0; rst_n = 0; start = 0; load = 0;
preset_val = 4'd0; #12;
rst_n = 1; #10; // Load a preset value of 5
preset_val = 4'd5;
load = 1; #10;
load = 0;
countdown start = 1; #60;
start = 0; #10;
rst_n = 0; #10;
$finish;
end
endmodule