
module inst_decoder (
    input [7:0] opcode,
    input dec, exc,
    output reg load, in, out, add, sub, bitand, jmp, jmpz, jmpnz, jmpc, jmpnc
);
    localparam OP_LOAD      = 4'h0;
    localparam OP_IN        = 4'h1;
    localparam OP_OUT       = 4'h2;
    localparam OP_ADD       = 4'h3;
    localparam OP_SUB       = 4'h4;
    localparam OP_AND       = 4'h5;
    localparam OP_JMP       = 4'h6;
    localparam OP_JMPZ      = 4'h7;
    localparam OP_JMPNZ     = 4'h8;
    localparam OP_JMPC      = 4'h9;
    localparam OP_JMPNC     = 4'hA;

    wire en;
    assign en = dec | exc;

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

        case (opcode) 
            OP_LOAD:    load    = 1'b1 & en;
            OP_IN:      in      = 1'b1 & en;
            OP_OUT:     out     = 1'b1 & en;
            OP_ADD:     add     = 1'b1 & en;
            OP_SUB:     sub     = 1'b1 & en;
            OP_AND:     bitand  = 1'b1 & en;
            OP_JMP:     jmp     = 1'b1 & en;
            OP_JMPZ:    jmpz    = 1'b1 & en;
            OP_JMPNZ:   jmpnz   = 1'b1 & en;
            OP_JMPC:    jmpc    = 1'b1 & en;
            OP_JMPNC:   jmpnc   = 1'b1 & en;

            default:    load = 1'b1 & en;
        endcase
    end

endmodule
