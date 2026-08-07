
module reg_16 (
	input clk, en, rst,
	input [15:0] d,
	output [15:0] q
);
	reg_8 reg_1(clk, en, rst, d[7:0], q[7:0]);
	reg_8 reg_2(clk, en, rst, d[15:8], q[15:8]);
	
endmodule
