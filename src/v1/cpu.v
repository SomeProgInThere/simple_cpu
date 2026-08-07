
module cpu (
    input clk, nrst,
    output sout
);
    localparam MEM_DATA_WIDTH = 16;
    localparam MEM_ADDR_WIDTH = 8;
    
    wire en_1 = 1'b1;

    wire rst;
    dff rst_reg(clk, en_1, 1'b1, ~nrst, rst);

    wire [MEM_ADDR_WIDTH - 1:0] addr;
    wire [MEM_DATA_WIDTH - 1:0] din, dout;

    wire sout_reg;
    dff serial_reg(clk, &addr, rst, dout[0], sout_reg);
    assign sout = ~sout_reg;

    wire carry, zero;
    wire [7:0] opcode;
    wire mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we;
    wire [4:0] alu_s;

    control_unit cu(
        clk, en_1, rst, carry, zero,
        opcode,
        mux_a, mux_b, mux_c, en_da, en_pc, en_in, mem_we,
        alu_s
    );

    wire [7:0] alu_out, acc_out, pc_out;
    wire [15:0] ins_out;
    wire mux_i, mux_d;

    alu alu_(mux_i, mux_d, alu_s, alu_out, carry);

    reg_8 acc_reg(clk, en_da, rst, alu_out, acc_out);
    reg_8 pc_reg(clk, en_pc, rst, alu_out, pc_out);
    reg_16 ins_reg(clk, en_in, rst, din, ins_out);

    mux_2 #(.N(8)) mux_ins(ins_out[7:0], pc_out, mux_a, mux_i);
    mux_2 #(.N(8)) mux_dec(din[7:0], acc_out, mux_b, mux_d);
    mux_2 #(.N(8)) mux_acc(pc_out, ins_out[7:0], mux_c, addr);

    assign zero = ~|acc_out;
    assign dout = { { 8{8'hA0} }, acc_out };

    sp_ram #(
        .DATA_WIDTH(MEM_DATA_WIDTH), .ADDR_WIDTH(MEM_ADDR_WIDTH)
    ) memory (
        ~clk, mem_we,
        addr,
        dout, din
    );

endmodule
