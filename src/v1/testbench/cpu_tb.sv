
module cpu_tb;
    logic clk, nrst, sout;

    cpu uut(clk, nrst, sout);

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        nrst = 1'b1;
        #10 nrst = 1'b0;
        #300 $finish;
    end

endmodule