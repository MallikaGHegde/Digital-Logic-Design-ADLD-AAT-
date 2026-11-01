module tb_johnson_counter;
parameter WIDTH = 4;
reg clk;
reg rst_n;
wire [WIDTH-1:0] q_out;
johnson_counter #(.WIDTH(WIDTH)) uut (
.clk(clk), .rst_n(rst_n), .q_out(q_out) );
always #5 clk = ~clk;
initial begin
$dumpfile("johnson_counter.vcd");
$monitor("Time=%0t | Rst=%b | Q_Out=%b",
$time, rst_n, q_out);
clk = 0; rst_n = 0; #12;
rst_n = 1;#160;
$finish;
end
endmodule