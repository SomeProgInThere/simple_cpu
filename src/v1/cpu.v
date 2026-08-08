
module cpu (
    input clk, nrst,
    output sout
);
    // -- internal buses --

    localparam DATA_WIDTH = 16;
    localparam ADDR_WIDTH = 8;
    
    wire [ADDR_WIDTH - 1:0] addr;
    wire [DATA_WIDTH - 1:0] din, dout;

    wire en_1 = 1'b1;

    wire rst;
    dff rst_reg(clk, en_1, 1'b1, ~nrst, rst);

    // -- control signals --

    wire carry, zero;
    wire [ADDR_WIDTH - 1:0] opcode;
    wire mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we;
    wire [4:0] alu_s;

    control_unit cu(
        clk, en_1, rst, carry, zero,
        opcode,
        mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we,
        alu_s
    );

    // -- ALU --

    wire [DATA_WIDTH - 1:0] ins_out;
    wire [ADDR_WIDTH - 1:0] alu_out, acc_out, pc_out;
    wire [ADDR_WIDTH - 1:0] mux_i, mux_d;

    alu #(.N(ADDR_WIDTH)) alu_(mux_i, mux_d, alu_s, alu_out, carry);

    // -- registers and status/data signals -- 

    register #(.N(DATA_WIDTH)) ins_reg(clk, en_in, rst, din, ins_out);
    register #(.N(ADDR_WIDTH)) acc_reg(clk, en_da, rst, alu_out, acc_out);
    register #(.N(ADDR_WIDTH)) pc_reg(clk, en_pc, rst, alu_out, pc_out);

    mux_2 #(.N(ADDR_WIDTH)) mux_ins(acc_out, pc_out, mux_a, mux_i);
    mux_2 #(.N(ADDR_WIDTH)) mux_dec(din[ADDR_WIDTH - 1:0], ins_out[ADDR_WIDTH - 1:0], mux_b, mux_d);
    mux_2 #(.N(ADDR_WIDTH)) mux_acc(pc_out, ins_out[ADDR_WIDTH - 1:0], mux_c, addr);

    assign zero = ~|alu_out;
    assign opcode = ins_out[DATA_WIDTH - 1:ADDR_WIDTH];
    assign dout = { 8'h00, acc_out };

    // -- main memory --

    sp_ram #(
        .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
        .PROGRAM_FILE("src/v1/main.hex")
    ) memory (
        ~clk, mem_we,
        addr,
        dout, din
    );

    // -- serial output with buffer --

    wire sout_reg;
    dff serial_reg(clk, mem_we & (&addr), rst, dout[0], sout_reg);
    assign sout = ~sout_reg;

endmodule
