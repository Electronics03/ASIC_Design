module multiple5 (
    input  wire [4:0] x,
    output reg        y
);
    always @(*) begin
        casex (x)
            5'b000101: y = 1'b1;
            5'b001010: y = 1'b1;
            5'b001111: y = 1'b1;
            5'b010100: y = 1'b1;
            5'b011001: y = 1'b1;
            5'b011110: y = 1'b1;
            default:   y = 1'b0;
        endcase
    end
endmodule