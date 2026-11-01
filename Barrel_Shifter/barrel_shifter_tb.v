module tb_barrel_shifter_4bit; // Inputs
reg [3:0] data_in;
reg [1:0] shift_amt; reg dir; // Outputs
wire [3:0] data_out;
barrel_shifter_4bit uut ( .data_in(data_in),
.shift_amt(shift_amt), .dir(dir), .data_out(data_out)
);
initial begin
$dumpfile("barrel_shifter.vcd");
$dumpvars(0, tb_barrel_shifter_4bit);
$monitor("Time=%0t | Dir(0=L,1=R)=%b |
Data_In=%b | Shift_Amt=%b | Data_Out=%b",
$time, dir, data_in, shift_amt, data_out);
data_in = 4'b1011;shift_amt = 2'b01; dir = 1'b0;
#10;
data_in = 4'b1011; shift_amt = 2'b10; dir = 1'b0;
#10;
data_in = 4'b1101; shift_amt = 2'b01; dir = 1'b1;
#10;
data_in = 4'b1101; shift_amt = 2'b11; dir = 1'b1;
#10;
$finish;
end
endmodule