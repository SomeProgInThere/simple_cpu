
module inst_decoder (
    input [7:0] opcode,
    input dec, exc,
    output reg load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc
);
    wire en = dec | exc;

    always @(*) begin
        load   = 1'b0;
        in     = 1'b0;
        out    = 1'b0;
        add    = 1'b0;
        sub    = 1'b0;
        bitand = 1'b0;
        jmp    = 1'b0;
        jmpz   = 1'b0;
        jmpnz  = 1'b0;
        jmpc   = 1'b0;
        jmpnc  = 1'b0;

        casez (opcode) 
            8'b0000_????: load    = 1'b1 & en;
            8'b0100_????: add     = 1'b1 & en;
            8'b0001_????: bitand  = 1'b1 & en;
            8'b0110_????: sub     = 1'b1 & en;
            
            8'b1010_????: in      = 1'b1 & en;
            8'b1110_????: out     = 1'b1 & en;
            
            8'b1000_????: jmp     = 1'b1 & en;
            8'b1001_00??: jmpz    = 1'b1 & en;
            8'b1001_01??: jmpnz   = 1'b1 & en;
            8'b1001_10??: jmpc    = 1'b1 & en;
            8'b1001_11??: jmpnc   = 1'b1 & en;

            default: begin
            end
        endcase
    end

endmodule
