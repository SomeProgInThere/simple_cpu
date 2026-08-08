
module register_tb;
	localparam DATA_WIDTH = 8;

	logic clk, en, rst;
	logic [DATA_WIDTH - 1:0] d;
	logic [DATA_WIDTH - 1:0] q;
	
	register #(.N(DATA_WIDTH)) uut(clk, en, rst, d, q);
	
	initial clk = 0;
	always #5 clk = ~clk;
	
	initial begin
		rst = 0; en = 0; d = 0;
		
		#10 rst = 1;
		#10 en = 1; d = 'd67;
		#10 d = 'd42;
		#10 en = 0; d = 'd90;
		#10 en = 1;
		#10 rst = 0;

		#10 $finish;
	end
	
endmodule
