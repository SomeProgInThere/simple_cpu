
module control_unit (
    input clk, en, rst, carry, zero,
    input [7:0] opcode,
    output mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we,
    output [4:0] alu_s 
);
    
    // -- sequence generator --

    wire fch, dec, exc, inc; 
    seq_gen sg_1(
        clk, en, rst, 
        fch, dec, exc, inc
    );

    // -- instruction decoder --

    wire load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc;
    inst_decoder decoder(
        opcode, dec, exc, 
        load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc
    );

    // -- status register --

    wire carry_reg, zero_reg;
    wire en_al = add | sub | bitand;
    reg_2 status_reg(
		clk, en_al, rst, 
		{ carry, zero },
		{ carry_reg, zero_reg }
	);

    // -- jump control --

    wire jmp_t = |{ 
        jmp, 
        zero & jmpz, ~zero & jmpnz, 
        carry & jmpc, ~carry & jmpnc 
    };

    wire jmp_nt;
    dff dff_1(clk, 1'b0, rst, ~jmp_t, jmp_nt);
    assign en_pc = (inc & jmp_nt) | (exc & jmp_t);

    // -- other peripheral signals --

    assign mux_a = inc;
    assign mux_b = load | en_al;
    assign mux_c = in | out;
    assign en_da = exc & (load | in | en_al);
    assign en_in = fch;
    assign mem_we = exc & out;

    // -- alu instruction signals --

    wire en_jmp = |{ jmp, jmpz, jmpnz, jmpc, jmpnc };
    assign alu_s = {
        |{ en_jmp, load, in, bitand },
        |{ en_jmp, load, in, out },
        inc | sub,
        sub,
        inc
    };

endmodule
