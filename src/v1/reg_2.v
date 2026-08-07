
module reg_2 (
	input clk, en, rst,
    input [1:0] d,
	output [1:0] q
);
	dff dff_inst [1:0] (clk, en, rst, d, q);

endmodule
