module tb_HW;

    reg in;
    wire out;
    reg clk;
    reg resetn;

    // Your state machine module has a name of "SimpleFSM"
    // First port: clock input
    // Second port: active-low resetn input (resets the machine if resetn is 0)
    // Third port: input to the machine
    // Fourth port: output of the machine
    SimpleFSM myFSM(clk, resetn, in, out);

    initial begin
        clk    = 1'b1;
        resetn = 1'b1;
        in     = 1'b0;

        #9  resetn = 1'b0;
        #10 resetn = 1'b1;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #20 in = 1'b0;
        #20 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10;
    end

    initial begin
        repeat (26)
            #5 clk = ~clk;
    end

endmodule
