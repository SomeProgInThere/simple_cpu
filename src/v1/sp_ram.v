
module sp_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input      clk, w_en,
    input      [ADDR_WIDTH - 1:0] addr,
    input      [DATA_WIDTH - 1:0] w_data,
    output reg [DATA_WIDTH - 1:0] r_data
);
    reg [DATA_WIDTH - 1:0] mem [0:(1 << ADDR_WIDTH) - 1];

    always @(posedge clk) begin
        if (w_en)
            mem[addr] <= w_data;

        r_data <= mem[addr];
    end

endmodule
