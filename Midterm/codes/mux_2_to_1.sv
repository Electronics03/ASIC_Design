module mux_2_to_1_exm1 (
    input a, b, sel,
    output out, outbar
);
    assign out = sel ? a : b;
    assign outbar = ~out;
endmodule

module mux_2_to_1_exm2 (
    input a, b, sel,
    output out, outbar
);
    wire out1, out2, selb;
    and a1(out1, a, sel);
    not i1(selb, sel);
    and a2(out2, b, selb);
    or o1(out, out1, out2);
    not i2(outbar, out);
endmodule

module mux_2_to_1_exm3 (
    input a, b, sel,
    output out, outbar
);
    assign out = (a&sel) | (b&(~sel));
    assign outbar = ~out;
endmodule