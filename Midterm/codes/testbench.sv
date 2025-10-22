module test_and2;
    reg i1, i2;
    wire o;

    AND2 u2(i1, i2, o);

    initial begin
        i1=0; i2=0;
        #1 $display("i1=%b, i2=%b, o=%b", i1, i2, o);
        i1=0; i2=1;
        #1 $display("i1=%b, i2=%b, o=%b", i1, i2, o);
    end
endmodule