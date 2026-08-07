
module reg_8_tb;
	logic clk, en, rst;
	logic [7:0] d;
	logic [7:0] q;
	
	reg_8 uut(clk, en, rst, d, q);
	
	initial clk = 0;
	always #5 clk = ~clk;
	
	initial begin
		rst = 0; en = 0; d = 0;
		
		#10 rst = 1;
		#10 en = 1; d = 8'd67;
		#10 d = 8'd42;
		#10 en = 0; d = 8'd90;
		#10 en = 1;
		#10 rst = 0;

		#10 $finish;
	end
	
endmodule
