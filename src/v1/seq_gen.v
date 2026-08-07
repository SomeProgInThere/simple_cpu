
module seq_gen (
    input clk, en, rst,
    output fch, dec, exc, inc
);
	wire z, w0, w1, w2, w3;
	
	assign z = ~(|{ fch, dec, exc, inc });
	assign w0 = inc | z;
	assign w1 = fch;
	assign w2 = dec;
	assign w3 = exc;
	
	dff dff_1(clk, en, rst, w0, fch);
	dff dff_2(clk, en, rst, w1, dec);
	dff dff_3(clk, en, rst, w2, exc);
	dff dff_4(clk, en, rst, w3, inc);

endmodule
