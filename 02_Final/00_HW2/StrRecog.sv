module StrRecog (
    input  wire i_clk,
    input  wire i_rst_n,
    input  wire in,
    output wire out
);

    reg [2:0] S;

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S01 = 3'b010;
    localparam S10 = 3'b011;
    localparam S010 = 3'b100;
    localparam S100 = 3'b101;

    always @(posedge i_clk) begin
        if (~i_rst_n) begin
            S <= S0;
        end
        else begin
            case ({S, in})
                {S0, 1'b0}:   S <= S0;
                {S0, 1'b1}:   S <= S01;
                {S1, 1'b0}:   S <= S10;
                {S1, 1'b1}:   S <= S1;
                {S01, 1'b0}:  S <= S010;
                {S01, 1'b1}:  S <= S1;
                {S10, 1'b0}:  S <= S100;
                {S10, 1'b1}:  S <= S01;
                {S010, 1'b0}: S <= S100;
                {S010, 1'b1}: S <= S01;
                {S100, 1'b0}: S <= S100;
                {S100, 1'b1}: S <= S100;
                default: S <= S0;
            endcase
        end
    end

    assign out = (S == S010) ? 1'b1 : 1'b0;
endmodule