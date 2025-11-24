`timescale 1ns/1ps

module sram_controller_test_tb;
    reg i_clk;

    reg i_cen;
    reg i_wen;
    reg [8:0] i_addr;
    reg [31:0] i_din;
    wire [31:0] o_dout;

    reg i_rstn;

    sram_controller_test sram_controller_test_inst(
        .i_clk  (i_clk),

        .i_cen  (i_cen),
        .i_wen  (i_wen),
        .i_addr (i_addr),
        .i_din  (i_din),
        .o_dout (o_dout),

        .i_rstn (i_rstn)
    );

    // Clock generation
    always #5 i_clk = ~i_clk;

    // Initial states
    initial begin
        $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Project/amem.hex", sram_controller_test_inst.AMEM.mem);
        $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Project/bmem.hex", sram_controller_test_inst.BMEM.mem);
        i_clk = 1'b1; i_rstn = 1'b1; i_cen = 1'b1; i_wen = 1'b1; i_addr = 9'b0; i_din = 32'b0;
    end

    // Test
    initial begin
        #35;
        i_rstn = 1'b0;
        #10;
        i_rstn = 1'b1;
        #50;
        // Read data
        repeat(512) begin
            i_cen = 1'b0;
            i_wen = 1'b1;
            #10;
            i_addr = i_addr + 1'b1;
        end
        i_cen = 1'b1;
        i_addr = 9'b0;

        // Write data
        repeat(512) begin
            i_cen = 1'b0;
            i_wen = 1'b0;
            #10;
            i_addr = i_addr + 1'b1;
            i_din = i_din + 32'd1;
        end
        i_cen = 1'b1;
        i_addr = 9'b0;

        // Read data
        repeat(512) begin
            i_cen = 1'b0;
            i_wen = 1'b1;
            #10;
            i_addr = i_addr + 1'b1;
        end
        i_cen = 1'b1;
        #55;
        
        $finish;
    end
endmodule