//////////////////////////////////////////////////////////////////////////////////
// Company :    Chung-Ang University
// Department : Electrical and Electronics Engineering
// Engineer:    SANGHYEOK PARK
// 
// Create Date:    2025/11/20 20:30:00
// Design Name:    Pipelined_Matmul_16x16
// Module Name:    custom_matmul16x16
// Project Name:   ASIC_Design_Project
// Target Devices: Nexys-A7-100T/ARTIX-7
// Tool Versions:  VIVADO 2024.1
// Description:    Custom 16x16 Matrix Multiplication Module 
//                 with SRAM Interfaces
// 
// Dependencies: sram_16x1_128.sv, 
//               sram_32x1_256.sv, 
//               sram_controller.sv, 
//               accumulator.sv, 
//               readwrite_fsm.sv
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
    // Memory Interface Signals
    // AMEM
    wire amem_cen;
    wire amem_wen;
    wire [6:0] amem_addr;
    wire [15:0] amem_din;
    wire [15:0] amem_dout;
    // BMEM
    wire bmem_cen;
    wire bmem_wen;
    wire [6:0] bmem_addr;
    wire [15:0] bmem_din;
    wire [15:0] bmem_dout;
    // OMEM
    wire omem_cen;
    wire omem_wen;
    wire [7:0] omem_addr;
    wire [31:0] omem_din;
    wire [31:0] omem_dout;

    // Read/Write FSM Interface Signals
    // AMEM
    wire rw_amem_cen;
    wire rw_amem_wen;
    wire [6:0] rw_amem_addr;
    wire [15:0] rw_amem_din;
    // BMEM
    wire rw_bmem_cen;
    wire rw_bmem_wen;
    wire [6:0] rw_bmem_addr;
    wire [15:0] rw_bmem_din;
    // OMEM
    wire rw_omem_cen;
    wire rw_omem_wen;
    wire [7:0] rw_omem_addr;
    wire [31:0] rw_omem_din;
    // Data output
    wire [31:0] rw_o_dout;

    // Matrix Multiplication Interface Signals
    // Chip-Enable Signals
    wire mx_amem_cen;
    wire mx_bmem_cen;    
    wire mx_omem_cen;
    // Piped Chip-Enable Signal 4-Delay
    wire mx_omem_cen_pipe;

    // Write-Enable Signals
    wire mx_amem_wen; 
    wire mx_bmem_wen;
    wire mx_omem_wen;
    // Piped Write-Enable Signal 4-Delay
    wire mx_omem_wen_pipe;

    // Address Signals
    wire [6:0] mx_amem_addr;
    wire [6:0] mx_bmem_addr;
    wire [7:0] mx_omem_addr;
    // Piped Address Signal 4-Delay
    wire [7:0] mx_omem_addr_pipe;

    // Data Input Signal
    wire [31:0] mx_omem_din;

    // Control Signals
    // Read Signal
    wire mx_read;
    // Piped Read Signal 4-Delay
    wire mx_read_pipe;
    // Eight Pulse Signal
    wire mx_eight_pulse;
    // Piped Eight Pulse Signal 4-Delay
    wire mx_eight_pulse_pipe;
    // Done Signal
    wire mx_done;

    // SRAM Instances
    //////////////////////////////////////////////////////////////////////////////
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
    //////////////////////////////////////////////////////////////////////////////

    // SRAM Controller for Read/Write
    sram_controller sram_controller_inst (
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_cen          (i_cen),
        .i_wen          (i_wen),
        .i_addr         (i_addr),
        .i_din          (i_din),
        .o_dout         (rw_o_dout),

        .i_amem_dout    (amem_dout),
        .i_bmem_dout    (bmem_dout),
        .i_omem_dout    (omem_dout),

        .o_amem_cen     (rw_amem_cen),
        .o_amem_wen     (rw_amem_wen),
        .o_amem_addr    (rw_amem_addr),
        .o_amem_din     (rw_amem_din),

        .o_bmem_cen     (rw_bmem_cen),
        .o_bmem_wen     (rw_bmem_wen),
        .o_bmem_addr    (rw_bmem_addr),
        .o_bmem_din     (rw_bmem_din),

        .o_omem_cen     (rw_omem_cen),
        .o_omem_wen     (rw_omem_wen),
        .o_omem_addr    (rw_omem_addr),
        .o_omem_din     (rw_omem_din)
    );

    // Accumulator and Pipelined Signals
    accumulator accumulator_inst (
        .i_clk              (i_clk),
        .i_rstn             (i_rstn),
        .i_eight_pulse      (mx_eight_pulse),
        .i_read             (mx_read),
        .i_amem_dout        (amem_dout),
        .i_bmem_dout        (bmem_dout),
        .i_fl               (i_fl),
        .o_acc              (mx_omem_din),

        .i_omem_cen        (mx_omem_cen),
        .i_omem_wen        (mx_omem_wen),
        .i_omem_addr       (mx_omem_addr),

        .o_omem_cen_pipe    (mx_omem_cen_pipe),
        .o_omem_wen_pipe    (mx_omem_wen_pipe),
        .o_omem_addr_pipe   (mx_omem_addr_pipe),

        .o_read_pipe        (mx_read_pipe),
        .o_eight_pulse_pipe (mx_eight_pulse_pipe),
        .o_calc_done        (mx_done)
    );

    // FSM for MatMul
    readwrite_fsm readwrite_fsm_inst(
        .i_clk          (i_clk),
        .i_rstn         (i_rstn),
        .i_matmul_en    (i_matmul_en),

        .o_amem_cen     (mx_amem_cen),
        .o_bmem_cen     (mx_bmem_cen),
        .o_omem_cen     (mx_omem_cen),

        .o_amem_wen     (mx_amem_wen),
        .o_bmem_wen     (mx_bmem_wen),
        .o_omem_wen     (mx_omem_wen),

        .o_amem_addr    (mx_amem_addr),
        .o_bmem_addr    (mx_bmem_addr),
        .o_omem_addr    (mx_omem_addr),

        .o_read         (mx_read),
        .o_eight_pulse  (mx_eight_pulse)
    );

    // Mux between Read/Write and MatMul
    assign amem_cen  = mx_done ? rw_amem_cen : mx_amem_cen;
    assign amem_wen  = mx_done ? rw_amem_wen : mx_amem_wen;
    assign amem_addr = mx_done ? rw_amem_addr : mx_amem_addr;
    assign amem_din  = rw_amem_din;

    assign bmem_cen  = mx_done ? rw_bmem_cen : mx_bmem_cen;
    assign bmem_wen  = mx_done ? rw_bmem_wen : mx_bmem_wen;
    assign bmem_addr = mx_done ? rw_bmem_addr : mx_bmem_addr; 
    assign bmem_din  = rw_bmem_din;

    assign omem_cen  = mx_done ? rw_omem_cen : mx_omem_cen_pipe;
    assign omem_wen  = mx_done ? rw_omem_wen : mx_omem_wen_pipe;
    assign omem_addr = mx_done ? rw_omem_addr : mx_omem_addr_pipe;
    assign omem_din  = mx_done ? rw_omem_din : mx_omem_din;
    
    assign o_dout = mx_done ? rw_o_dout : 32'd0;
    assign o_done = mx_done;
endmodule