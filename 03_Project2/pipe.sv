module acc(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  data_in,
    input  logic        data_valid,
    output logic [7:0] acc_out
);

    logic [7:0] acc_reg;
    logic [7:0] data_in_ext;

    assign data_in_ext = {4'b0, data_in};
    
    always @(posedge clk) begin
        if (!rst_n) begin
            acc_reg <= 8'b0;
        end 
        else if (data_valid) begin
            acc_reg <= acc_reg + data_in_ext;
        end
    end

    assign acc_out = acc_reg;

endmodule