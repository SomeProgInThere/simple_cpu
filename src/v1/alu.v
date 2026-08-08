
module alu #(
	parameter N = 2
) (
	input [N - 1:0] a, b,
	input [4:0] s,
	output [N - 1:0] out,
	output carry
);
	wire [N - 1:0] b_inv = b ^ { N{s[3]} };
	wire [N - 1:0] b_sign = { N{~s[4]} } & b_inv;
	wire [N - 1:0] c = a & b;
	
	wire [N - 1:0] sum;
	rca #(.N(N)) adder (a, b_sign, s[2], sum, carry);
	mux_4 #(.N(N)) mux (sum, c, a, b, s[1:0], out);
	
endmodule
