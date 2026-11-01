module tb_comparator_3bit; // Inputs
reg [2:0] A;
reg [2:0] B; // Outputs
wire A_greater;
wire A_less;
wire A_equal; // Instantiate the Unit Under Test
comparator_3bit uut (.A(A),
.B(B),.A_greater(A_greater), .A_less(A_less),
.A_equal(A_equal) );
initial begin
$dumpfile("comparator_3bit.vcd");
$dumpvars(0, tb_comparator_3bit);
$monitor("Time=%0t | A=%b (%0d) | B=%b
(%0d) | A>B=%b | A<B=%b | A==B=%b", $time,
A, A, B, B, A_greater, A_less, A_equal);
A = 3'b000; B = 3'b000; #10;
A = 3'b101; B = 3'b011; #10;
A = 3'b010; B = 3'b110; #10;
A = 3'b111; B = 3'b111; #10;
A = 3'b100; B = 3'b001; #10;
$finish;
end
endmodule