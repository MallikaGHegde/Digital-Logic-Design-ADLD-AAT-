module tb_ring_counter;
parameter WIDTH = 4;
reg clk;
reg rst_n;
reg load;
reg [WIDTH-1:0] seed;
wire [WIDTH-1:0] q_out;
ring_counter #(.WIDTH(WIDTH)) uut ( .clk(clk),
.rst_n(rst_n), .load(load), .seed(seed),
.q_out(q_out) );
always #5 clk = ~clk;
initial begin
$dumpfile("ring_counter.vcd");
$dumpvars(0, tb_ring_counter);
$monitor("Time=%0t | Rst=%b | Load=%b |
Q_Out=%b", $time, rst_n, load, q_out);
clk = 0; rst_n = 0; load = 0; seed = 4'b0001; #12;
rst_n = 1; #40;
pattern seed = 4'b0100;
load = 1; #10;
load = 0; #30;
$finish;
end
endmodule