
module sp_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3,
    parameter PROGRAM_FILE = "program.hex"
) (
    input      clk, w_en,
    input      [ADDR_WIDTH - 1:0] addr,
    input      [DATA_WIDTH - 1:0] w_data,
    output reg [DATA_WIDTH - 1:0] r_data
);
    reg [DATA_WIDTH - 1:0] mem [0:(1 << ADDR_WIDTH) - 1];

    integer i;
    initial begin
        for (i = 0; i < (1 << ADDR_WIDTH); i = i + 1)
            mem[i] = { DATA_WIDTH{1'b0} };

        $readmemh(PROGRAM_FILE, mem);
    end

    always @(posedge clk) begin
        if (w_en)
            mem[addr] <= w_data;

        r_data <= mem[addr];
    end

endmodule
