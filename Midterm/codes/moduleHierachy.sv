`timescale 1ps/1ps

module dEdgeFF (
    output reg q,
    input wire clock, data
);
    always @(negedge clock)
        #10 q = data;
endmodule

module m555(
    output reg clock
);
    initial 
        #5 clock = 1;
    always
        #50 clock = ~clock;
endmodule

module m16 (
    output wire [3:0] value,
    input wire clock,
    output wire fifteen, altFifteen
);
    dEdgeFF a(value[0], clock, ~value[0]);
    dEdgeFF b(value[1], clock, value[1]^value[0]);
    dEdgeFF c(value[2], clock, value[2]^&value[1:0]);
    dEdgeFF d(value[3], clock, value[3]^&value[2:0]);
    
    assign fifteen = value[0] & value[1] & value[2] & value[3];
    assign altfifteen = &value;
endmodule

module board();
    wire [3:0] count;
    wire clock, f, af;

    m16 counter(count, clock, f, af);
    m555 clockGen(clock);

    always @ (posedge clock)
        $display($time, "count=%d, f=%d,af=%d", count, f, af);
endmodule