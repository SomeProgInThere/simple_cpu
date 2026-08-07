
module alu (
	input [7:0] a, b,
	input [4:0] s,
	output [7:0] y,
	output cout
);
	wire [7:0] b_inv = b ^ { 8{s[3]} };
	wire [7:0] b_sign = { 8{~s[4]} } & b_inv;
	wire [7:0] c = a & b;
	
	rca #(.N(8)) adder (a, b_sign, s[2], sum, cout);
	mux_4 #(.N(8)) mux (sum, c, a, b, s[1:0], y);
	
endmodule
