
module alu_tb;
	logic [7:0] a, b;
	logic [4:0] s;
	logic [7:0] y;
	logic co;
	
	alu uut(a, b, s, y, co);
	
	initial begin
		#0  a = 8'd5; b = 8'd7; s = 5'b0_0000;	// a + b
		#10 a = 8'd0; b = 8'd8; s = 5'b0_0001;	// a & b
		#10 a = 8'd9; b = 8'd0; s = 5'b0_0010;	// a
		#10 a = 8'd0; b = 8'd4; s = 5'b0_0011;   // b
		#10 a = 8'd7; b = 8'd2; s = 5'b0_1100;   // a - b
		#10 a = 8'd3; b = 8'd0; s = 5'b1_0100;	// a + 1
		#10 a = 8'd5; b = 8'd7; s = 5'b0_0100;	// (a + b) + 1
		#10 a = 8'd7; b = 8'd2; s = 5'b0_1000;	// (a - b) - 1
		
		#10 $finish;
	end
	
endmodule
