
module dff (
	input clk, en, rst, d,
	output reg q
);
	wire d_mux;
	assign d_mux = en ? d : q;
	
	always @(posedge clk or negedge rst) begin
		q <= ~rst ? 1'b0 : d_mux;
	end
	
endmodule
