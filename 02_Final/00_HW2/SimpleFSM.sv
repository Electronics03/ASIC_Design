module SimpleFSM(
    input  wire i_clk,
    input  wire i_rst_n,
    input  wire in,
    output wire out
);
    reg [1:0] S;

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b11;
    localparam S3 = 2'b10;

    always @(posedge i_clk) begin
        if (~i_rst_n) begin
            S <= S0;
        end
        else begin
            case ({S, in})
                {S0, 1'b0}: S <= S0;
                {S0, 1'b1}: S <= S1;
                {S1, 1'b0}: S <= S2;
                {S1, 1'b1}: S <= S1;
                {S2, 1'b0}: S <= S0;
                {S2, 1'b1}: S <= S3;
                {S3, 1'b0}: S <= S2;
                {S3, 1'b1}: S <= S1;
                default: S <= S0;
            endcase
        end
    end

    assign out = (S == S3) ? 1'b1 : 1'b0;
endmodule