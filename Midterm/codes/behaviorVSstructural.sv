module AND2_1(
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

module AND2_2(
    input in1,
    input in2,
    output reg out
);
    always @(in1, in2) begin
        out = in1 & in2;
    end
endmodule