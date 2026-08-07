
module mux_2 #(
    parameter N = 1
) (
    input [N - 1:0] a, b,
    input sel,
    output [N - 1:0] y
);
    assign y = sel ? a : b;

endmodule