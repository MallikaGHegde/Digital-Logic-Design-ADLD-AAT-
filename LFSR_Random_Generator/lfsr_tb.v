module tb_lfsr_4bit;
reg clk;
reg rst_n;
reg load;
reg [3:0] seed;
wire [3:0] q_out;
lfsr_4bit uut ( .clk(clk), .rst_n(rst_n), .load(load),
.seed(seed), .q_out(q_out) );
always #5 clk = ~clk;
initial begin
$dumpfile("lfsr_4bit.vcd");
$dumpvars(0, tb_lfsr_4bit);
$monitor("Time=%0t | Rst=%b | Load=%b |
Random_State=%b (Decimal: %0d)", $time, rst_n,
load, q_out, q_out);
clk = 0; rst_n = 0; load = 0; seed = 4'b0000; #12;
rst_n = 1;#160;
seed = 4'b1011; load = 1; #10;
load = 0; #60;
$finish;
end
endmodule