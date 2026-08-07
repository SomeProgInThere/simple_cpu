
module block_ram_tb;
    localparam DATA_WIDTH = 16;
    localparam ADDR_WIDTH = 4;

    logic clk, w_en;
    logic [ADDR_WIDTH - 1:0] addr;
    logic [DATA_WIDTH - 1:0] w_data, r_data;

    sp_ram #(
        .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        clk, w_en,
        addr,
        w_data,
        r_data
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        addr = 'h0;

        #10 addr = 'h0;
        w_en = 1'b1;
        w_data = 'hA;

        #10 addr = 'h0;
        
        #10 $finish;
    end

endmodule
