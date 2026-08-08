
module control_unit (
    input clk, en, rst, carry, zero,
    input [7:0] opcode,
    output mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we,
    output [4:0] alu_s 
);
    
    // -- sequence generator --

    wire fch, dec, exc, inc; 
    seq_gen seq(
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
    register #(.N(2)) status_reg(clk, en_al, rst, { carry, zero },{ carry_reg, zero_reg });

    // -- jump control & other peripheral signals --

    wire jmp_t = |{ 
        jmp,
        zero_reg & jmpz, ~zero_reg & jmpnz, 
        carry_reg & jmpc, ~carry_reg & jmpnc 
    };

    wire jmp_nt;
    dff dff_1(clk, 1'b1, rst, ~jmp_t, jmp_nt);
    
    wire en_jmp = |{ jmp, jmpz, jmpnz, jmpc, jmpnc };
    
    assign mux_a = inc;
    assign mux_b = load | en_al | en_jmp;
    assign mux_c = in | out;
    
    assign en_pc = (inc & jmp_nt) | (exc & jmp_t);
    assign en_da = exc & (load | in | en_al);
    assign en_in = fch;
    
    assign mem_we = exc & out;

    // -- alu instruction signals --

    assign alu_s = {
        inc,
        sub,
        inc | sub,
        |{ en_jmp, load, in, out },
        |{ en_jmp, load, in, bitand }
    };

endmodule
