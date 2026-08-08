
module register #(
    parameter N = 2
) (
    input clk, en, rst,
    input [N - 1:0] din, 
    output [N - 1:0] dout
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_dff
            dff bit_reg(clk, en, rst, din[i], dout[i]);
        end
    endgenerate

endmodule