
module inst_decoder_tb;
	logic [7:0] opcode;
	logic dec, exc;
	logic load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc;
	
	inst_decoder uut(
		opcode, dec, exc,
		load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc
	);

	initial begin
		dec = 1; exc = 1;
		#10 opcode = 4'h0;
		#10 opcode = 4'h1;
		#10 opcode = 4'h2;
		#10 opcode = 4'h3;
		#10 opcode = 4'h4;
		#10 opcode = 4'h5;
		#10 opcode = 4'h6;
		#10 opcode = 4'h7;
		#10 opcode = 4'h8;
		#10 opcode = 4'h9;
		#10 opcode = 4'hA;
		
		// disable decode during fetching
		dec = 0; exc = 0;
		#10 opcode = 4'h7;
		#10 opcode = 4'hA;

		#10 $finish;
	end
	
endmodule
