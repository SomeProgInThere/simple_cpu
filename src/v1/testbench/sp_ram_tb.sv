
module sp_ram_tb;
    localparam DATA_WIDTH = 16;
    localparam ADDR_WIDTH = 4;

    logic clk, w_en;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] w_data;
    logic [DATA_WIDTH-1:0] r_data;

    sp_ram #(
        .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
        .PROGRAM_FILE("src/v1/testbench/test.hex")
    ) uut (
        clk, w_en,
        addr,
        w_data,r_data
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        w_en   = 1'b0;
        addr   = 4'h0;
        w_data = 16'h0000;

        // read addresses loaded from test.hex
        #10 addr = 4'h1;
        #10 addr = 4'h2;
        #10 addr = 4'h3;
        #10 addr = 4'h4;

        // manual data write and read 
        #10;
        addr   = 4'h4;
        w_data = 16'hA55A;
        w_en   = 1'b1;

        #10 w_en = 1'b0;
        #10 addr = 4'h4;

        #10 $finish;
    end

endmodule
