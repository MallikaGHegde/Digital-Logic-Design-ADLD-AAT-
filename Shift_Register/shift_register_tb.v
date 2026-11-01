module tb_universal_shift_register;
parameter WIDTH = 4;
reg clk;
reg rst_n;
reg [1:0] sel;
reg serial_in_right;
reg serial_in_left;
reg [WIDTH-1:0] parallel_in;
wire [WIDTH-1:0] q_out;
universal_shift_register #(.WIDTH(WIDTH)) uut
( .clk(clk), .rst_n(rst_n), .sel(sel),
.serial_in_right(serial_in_right),
.serial_in_left(serial_in_left),
.parallel_in(parallel_in), .q_out(q_out) );
always #5 clk = ~clk;
initial begin
$dumpfile("shift_reg.vcd");
$dumpvars(0, tb_universal_shift_register);
$monitor("Time=%0t | Sel=%b | P_In=%b |
S_Right=%b | S_Left=%b | Q_Out=%b", $time,
sel, parallel_in, serial_in_right, serial_in_left,
q_out);
clk = 0; rst_n = 0; sel = 2'b00; serial_in_right = 0;
serial_in_left = 0; parallel_in = 4'b0000; #12;
rst_n = 1;
sel = 2'b11; parallel_in = 4'b1010; #10;
sel = 2'b01; serial_in_right = 1'b1; #30;
sel = 2'b00; #20;
sel = 2'b10; serial_in_left = 1'b0; #30;
$finish;
end
endmodule