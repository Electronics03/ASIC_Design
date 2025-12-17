module FullAdder (
    input  wire a,
    input  wire b,
    input  wire cin,

    output wire sum,
    output wire cout
);
    wire sum1;
    wire carry1
    wire carry2;
    HalfAdder HA1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );
    HalfAdder HA2 (
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(carry2)
    );
    assign cout = carry1 | carry2;
endmodule