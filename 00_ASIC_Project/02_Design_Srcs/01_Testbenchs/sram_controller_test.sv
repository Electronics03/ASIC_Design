module sram_controller_test (
    input   wire            i_clk,
    
    input   wire            i_cen,
    input   wire            i_wen,
    input   wire    [8:0]   i_addr,
    input   wire    [31:0]  i_din,
    output  wire    [31:0]  o_dout,

    input   wire            i_rstn
);
    wire amem_cen;
    wire amem_wen;

    wire bmem_cen;
    wire bmem_wen;

    wire omem_cen;
    wire omem_wen;

    wire [6:0] amem_addr;
    wire [6:0] bmem_addr;
    wire [7:0] omem_addr;

    wire [15:0] amem_din;
    wire [15:0] bmem_din;
    wire [31:0] omem_din;

    wire [15:0] amem_dout;
    wire [15:0] bmem_dout;
    wire [31:0] omem_dout;

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

    sram_controller sram_controller_inst (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_cen          (i_cen),
        .i_wen          (i_wen),
        .i_addr         (i_addr),
        .i_din          (i_din),
        .o_dout         (o_dout),

        .i_amem_dout    (amem_dout),
        .i_bmem_dout    (bmem_dout),
        .i_omem_dout    (omem_dout),

        .o_amem_cen     (amem_cen),
        .o_amem_wen     (amem_wen),
        .o_amem_addr    (amem_addr),
        .o_amem_din     (amem_din),

        .o_bmem_cen     (bmem_cen),
        .o_bmem_wen     (bmem_wen),
        .o_bmem_addr    (bmem_addr),
        .o_bmem_din     (bmem_din),

        .o_omem_cen     (omem_cen),
        .o_omem_wen     (omem_wen),
        .o_omem_addr    (omem_addr),
        .o_omem_din     (omem_din)
    );

endmodule