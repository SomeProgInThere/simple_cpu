
module seq_gen_tb;
	logic clk, en, rst;
	logic fch, dec, exc, inc;
	
	seq_gen uut(clk, en, rst, fch, dec, exc, inc);

initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0; en = 0;
		#10 rst = 1;
		#10 en = 1;
		
		#100
		
		// freeze count
		en = 0;
		#20 en = 1;
		
		// restart count
		#30 rst = 0;
		#10 rst = 1;
		
		#100
		$finish;
    end
	
endmodule
