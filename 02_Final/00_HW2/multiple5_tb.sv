module tb3();

    reg  [4:0] multin;
    wire       multout;

    multiple5 DUT (
        .x(multin),
        .y(multout)
    );

    initial begin
        multin = 5'b00000;

        repeat (32) begin
            #10;
            multin = multin + 1;
        end
    end

endmodule