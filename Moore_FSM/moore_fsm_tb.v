module tb_seq_detector;
reg clk;
reg rst_n;
reg din;
wire det;
moore_seq_detector uut ( .clk(clk), .rst_n(rst_n),
.din(din), .det(det)
always #5 clk = ~clk;
initial begin
$dumpfile("moore_fsm.vcd");
$dumpvars(0, tb_moore_seq_detector);
$monitor("Time=%0t | Rst=%b | Din=%b |
Det_Out=%b", $time, rst_n, din, det);
clk = 0; rst_n = 0; din = 0; #12;
rst_n = 1;
@(posedge clk); din = 1'b1;
@(posedge clk); din = 1'b0;
@(posedge clk); din = 1'b1;
@(posedge clk); din = 1'b0;
@(posedge clk); din = 1'b1;
@(posedge clk); din = 1'b0;
@(posedge clk); din = 1'b0;
@(posedge clk); din = 1'b1;
@(posedge clk); din = 1'b0;
@(posedge clk);
$finish;
end
endmodule