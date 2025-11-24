//////////////////////////////////////////////////////////////////////////////////
// Company:    Chung-Ang University
// Department: Electrical and Electronics Engineering
// Engineer:   SANGHYEOK PARK
// 
// Create Date:    2025/11/20 20:30:00
// Design Name:    Pipelined_Matmul_16x16
// Module Name:    sram_controller
// Project Name:   ASIC_Design_Project
// Target Devices: Nexys-A7-100T/ARTIX-7
// Tool Versions:  VIVADO 2024.1
// Description:    SRAM Control for Read/Write
// Dependencies:   No dependency
// 
//////////////////////////////////////////////////////////////////////////////////

module sram_controller (
    // Control signals 
    // Global signals
    input   wire            i_clk,
    input   wire            i_rstn,
    input   wire            i_cen,
    input   wire            i_wen,
    input   wire    [8:0]   i_addr,
    input   wire    [31:0]  i_din,
    // Data output    
    output  wire    [31:0]  o_dout,

    // SRAM interfaces
    // SRAM outputs
    input   wire    [15:0]  i_amem_dout,
    input   wire    [15:0]  i_bmem_dout,
    input   wire    [31:0]  i_omem_dout,
    // SRAM inputs
    // AMEM interface
    output  wire            o_amem_cen,
    output  wire            o_amem_wen,
    output  wire    [6:0]   o_amem_addr,
    output  wire    [15:0]  o_amem_din,
    // BMEM interface
    output  wire            o_bmem_cen,
    output  wire            o_bmem_wen,
    output  wire    [6:0]   o_bmem_addr,
    output  wire    [15:0]  o_bmem_din,
    // OMEM interface
    output  wire            o_omem_cen,
    output  wire            o_omem_wen,
    output  wire    [7:0]   o_omem_addr,
    output  wire    [31:0]  o_omem_din
);
    // Address one-hot decoding
    wire sel_amem = (i_addr[8:7] == 2'b00);
    wire sel_bmem = (i_addr[8:7] == 2'b01);
    wire sel_omem = (i_addr[8] == 1'b1);
    // Pipelined select signals
    reg reg_i_cen_pipe;
    reg reg_sel_amem_pipe;
    reg reg_sel_bmem_pipe;
    reg reg_sel_omem_pipe;
    // Delayed 1-cycle select signals
    always @(posedge i_clk) begin
        if (!i_rstn) begin
            reg_i_cen_pipe <= 1'b1;
            reg_sel_amem_pipe <= 1'b0;
            reg_sel_bmem_pipe <= 1'b0;
            reg_sel_omem_pipe <= 1'b0;
        end 
        else begin
            reg_i_cen_pipe <= i_cen;
            reg_sel_amem_pipe <= sel_amem;
            reg_sel_bmem_pipe <= sel_bmem;
            reg_sel_omem_pipe <= sel_omem;
        end
    end

    // Select one-hot decode
    // Chip select
    assign o_amem_cen = ~(sel_amem & ~i_cen);
    assign o_bmem_cen = ~(sel_bmem & ~i_cen);
    assign o_omem_cen = ~(sel_omem & ~i_cen);
    // Read Write enable
    assign o_amem_wen = ~(sel_amem & ~i_wen);
    assign o_bmem_wen = ~(sel_bmem & ~i_wen);
    assign o_omem_wen = ~(sel_omem & ~i_wen);

    // Address input routing
    assign o_amem_addr = i_addr[6:0];
    assign o_bmem_addr = i_addr[6:0];
    assign o_omem_addr = i_addr[7:0];
    // Data input routing
    assign o_amem_din = i_din[15:0];
    assign o_bmem_din = i_din[15:0];
    assign o_omem_din = i_din;
    // Data output routing
    assign o_dout = 
        (reg_i_cen_pipe)  ? 32'h0000_0000 :
        reg_sel_amem_pipe ? {16'b0, i_amem_dout} :
        reg_sel_bmem_pipe ? {16'b0, i_bmem_dout} :
        reg_sel_omem_pipe ? i_omem_dout : 32'h0000_0000;
endmodule