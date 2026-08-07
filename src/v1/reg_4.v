
module reg_4 (
	input clk, en, rst,
	input [3:0] d,
	output [3:0] q
);
	reg_2 reg_2_1(clk, en, rst, d[1:0], q[1:0]);
	reg_2 reg_2_2(clk, en, rst, d[3:2], q[3:2]);

endmodule
