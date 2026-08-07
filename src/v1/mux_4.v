
module mux_4 #(
	parameter N = 1
) (
	input [N - 1:0] a, b, c, d,
	input [1:0] sel,
	output reg [N - 1:0] y
);
	always @(*) begin
		case (sel)
			2'b00: y = a;
			2'b01: y = b;
			2'b10: y = c;
			2'b11: y = d;

			default: y = 2'b00;
		endcase
	end

endmodule
