
module reg_8 (
	input clk, en, rst,
	input [7:0] d,
	output [7:0] q
);
	reg_4 reg_1(clk, en, rst, d[3:0], q[3:0]);
	reg_4 reg_2(clk, en, rst, d[7:4], q[7:4]);

endmodule
