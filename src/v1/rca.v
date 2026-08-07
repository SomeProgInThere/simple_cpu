
module rca #(
	parameter N = 1
) (
	input [N - 1:0] a, b,
	input cin,
	output [N - 1:0] sum,
	output cout
);
	wire [N:0] c;
	assign c[0] = cin;

	genvar i;
	generate
		for (i = 0; i < N; i = i + 1) begin : gen_adders
			fadder fa_inst(a[i], b[i], c[i], sum[i], c[i + 1]);
		end
	endgenerate

	assign cout = c[N];

endmodule
