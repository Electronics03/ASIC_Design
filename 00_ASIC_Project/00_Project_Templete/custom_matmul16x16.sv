//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/12 21:48:00
// Design Name: 
// Module Name: custom_matmul16x16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module custom_matmul16x16(
        input   wire            i_clk,
        
        input   wire            i_cen,
        input   wire            i_wen,
        input   wire    [8:0]   i_addr,
        input   wire    [31:0]  i_din,
        output  wire    [31:0]  o_dout,
        
        input   wire            i_rstn,
        input   wire            i_matmul_en,
        input   wire    [2:0]   i_fl,
        output  wire            o_done
    );
    
    sram_16x1_128 AMEM (
        .CLK    (i_clk      ),
        .CEN    (amem_cen   ),
        .WEN    (amem_wen   ),
        .A      (amem_addr  ),
        .D      (amem_din   ),
        .Q      (amem_dout  )
    );
    
    sram_16x1_128 BMEM (
        .CLK    (i_clk      ),
        .CEN    (bmem_cen   ),
        .WEN    (bmem_wen   ),
        .A      (bmem_addr  ),
        .D      (bmem_din   ),
        .Q      (bmem_dout  )
    );
    
    sram_32x1_256 OMEM (
        .CLK    (i_clk      ),
        .CEN    (omem_cen   ),
        .WEN    (omem_wen   ),
        .A      (omem_addr  ),
        .D      (omem_din   ),
        .Q      (omem_dout  )
    );
    
    
endmodule

