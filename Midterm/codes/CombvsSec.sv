module COMB_exm (
    input wire a,
    input wire b,
    input wire [1:0] sel,
    output wire out
);
    assign out = 
            (sel==2'b00)? (a & b):
            (sel==2'b01)? (a | b):
            (a ^ b);
endmodule

module SEC_exm (
    input wire DATA, CLK, CLR,
    output reg Q
);
    always @(posedge CLK, negedge CLR) begin
        if (CLR == 0) begin
            Q <= 1'b0;
        end
        else
            Q <= DATA;
    end
endmodule