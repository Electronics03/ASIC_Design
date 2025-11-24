`timescale 1ns/1ps

module readwrite_fsm_tb;
    reg i_clk;
    reg i_rstn;
    reg i_matmul_en;

    wire o_amem_cen;
    wire o_bmem_cen;
    wire o_omem_cen;

    wire o_amem_wen;
    wire o_bmem_wen;
    wire o_omem_wen;

    wire [6:0] o_amem_addr;
    wire [6:0] o_bmem_addr;
    wire [7:0] o_omem_addr;
    
    wire o_read;
    wire o_eight_pulse;

    readwrite_fsm readwrite_fsm_inst(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_matmul_en(i_matmul_en),

        .o_amem_cen(o_amem_cen),
        .o_bmem_cen(o_bmem_cen),
        .o_omem_cen(o_omem_cen),

        .o_amem_wen(o_amem_wen),
        .o_bmem_wen(o_bmem_wen),
        .o_omem_wen(o_omem_wen),

        .o_amem_addr(o_amem_addr),
        .o_bmem_addr(o_bmem_addr),
        .o_omem_addr(o_omem_addr),

        .o_read(o_read),
        .o_eight_pulse(o_eight_pulse)
    );

    always #5 i_clk = ~i_clk;

    initial begin
        i_clk = 1'b1; i_rstn = 1'b1; i_matmul_en = 1'b0;
        #35;
        i_rstn = 1'b0;
        #10;
        i_rstn = 1'b1;
        #100;
        i_matmul_en = 1'b1;
        #10;
        i_matmul_en = 1'b0;
        #20900;
        $finish;
    end
endmodule