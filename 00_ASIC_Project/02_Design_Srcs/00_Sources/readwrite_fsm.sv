//////////////////////////////////////////////////////////////////////////////////
// Company :    Chung-Ang University
// Department : Electrical and Electronics Engineering
// Engineer:    SANGHYEOK PARK
// 
// Create Date:    2025/11/20 20:30:00
// Design Name:    Pipelined_Matmul_16x16
// Module Name:    sram_controller
// Project Name:   ASIC_Design_Project
// Target Devices: Nexys-A7-100T/ARTIX-7
// Tool Versions:  VIVADO 2024.1
// Description:    Control FSM for MatMul
// Dependencies:   No dependency
// 
//////////////////////////////////////////////////////////////////////////////////

module readwrite_fsm (
    // Control input signals
    input   wire            i_clk,
    input   wire            i_rstn,
    input   wire            i_matmul_en,

    // Chip enable signals
    output  wire            o_amem_cen,
    output  wire            o_bmem_cen,
    output  wire            o_omem_cen,
    // Write enable signals
    output  wire            o_amem_wen,
    output  wire            o_bmem_wen,
    output  wire            o_omem_wen,
    // Address signals
    output  wire    [6:0]   o_amem_addr,
    output  reg     [6:0]   o_bmem_addr,
    output  reg     [7:0]   o_omem_addr,
    // Control output signals
    output  wire            o_read,
    output  reg             o_eight_pulse
);
    // State gray encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam STOP = 2'b11;
    // State registers
    reg [1:0] reg_state;
    reg [6:0] reg_bias;
    reg [2:0] reg_mini_cycle;
    reg [3:0] reg_total_cycle;

    // FSM
    always @(posedge i_clk) begin
        if (~i_rstn) begin
            // Reset all registers
            reg_state       <= IDLE;
            reg_bias        <= 7'b000_0000;
            reg_mini_cycle  <= 3'b000;
            reg_total_cycle <= 4'b0000;
            // Reset all outputs
            o_bmem_addr     <= 7'b000_0000;
            o_omem_addr     <= 8'b0000_0000;
            o_eight_pulse   <= 1'b0;
        end        
        else begin
            case (reg_state)
                IDLE: begin
                    // Start matmul
                    if (i_matmul_en == 1'b1) begin
                        reg_state   <= READ;
                    end
                    // IDLE counts reset
                    reg_bias        <= 7'b000_0000;
                    reg_mini_cycle  <= 3'b000;
                    reg_total_cycle <= 4'b0000;
                    // IDLE outputs
                    o_bmem_addr     <= 7'b000_0000;
                    o_omem_addr     <= 8'b0000_0000;
                    o_eight_pulse   <= 1'b0;
                end
                READ: begin
                    if (reg_total_cycle==4'd15) begin
                        if (reg_mini_cycle==3'd7) begin
                            if (o_amem_addr == 7'd127) begin
                                // Finish all reads
                                // Transition to STOP
                                reg_state       <= STOP;
                                // Reset all counts
                                reg_bias        <= 7'b000_0000;
                                reg_mini_cycle  <= 3'b000;
                                reg_total_cycle <= 4'b0000;
                                // Reset all outputs
                                o_bmem_addr     <= 7'b000_0000;
                                o_omem_addr     <= 8'b0000_0000;
                                o_eight_pulse   <= 1'b0;
                            end
                            else begin
                                // Set next bias
                                reg_bias        <= reg_bias + reg_mini_cycle + 7'b000_0001;
                                // Reset mini cycle
                                // Reset total cycle
                                reg_mini_cycle  <= 3'b000;
                                reg_total_cycle <= 4'b0000;
                                // Increment Outputs
                                o_bmem_addr     <= o_bmem_addr + 7'b000_0001;
                                o_omem_addr     <= o_omem_addr + 8'b0000_0001;
                                o_eight_pulse   <= 1'b0;
                            end
                        end
                        else begin
                            // Increment mini cycle
                            // Const total cycle
                            reg_mini_cycle  <= reg_mini_cycle + 3'b001;
                            // Increment Outputs
                            o_bmem_addr     <= o_bmem_addr + 7'b000_0001;
                            // Set eight pulse
                            if (reg_mini_cycle==3'd6)   o_eight_pulse   <= 1'b1;
                            else                        o_eight_pulse   <= 1'b0;
                        end
                    end 
                    else begin
                        if (reg_mini_cycle==3'd7) begin
                            // Reset mini cycle
                            // Increment total cycle
                            reg_mini_cycle  <= 3'b000;
                            reg_total_cycle <= reg_total_cycle + 4'b0001;
                            // Increment Outputs
                            o_bmem_addr     <= o_bmem_addr + 7'b000_0001;
                            o_omem_addr     <= o_omem_addr + 8'b0000_0001;
                            o_eight_pulse   <= 1'b0;
                        end
                        else begin
                            // Increment mini cycle
                            // Const total cycle
                            reg_mini_cycle  <= reg_mini_cycle + 3'b001;
                            // Increment Outputs
                            o_bmem_addr     <= o_bmem_addr + 7'b000_0001;
                            // Set eight pulse
                            if (reg_mini_cycle==3'd6)   o_eight_pulse   <= 1'b1;
                            else                        o_eight_pulse   <= 1'b0;
                        end
                    end
                end
                STOP: begin
                    // Reset all registers
                    reg_state       <= IDLE;
                    reg_bias        <= 7'b000_0000;
                    reg_mini_cycle  <= 3'b000;
                    reg_total_cycle <= 4'b0000;
                    // Reset all outputs
                    o_bmem_addr     <= 7'b000_0000;
                    o_omem_addr     <= 8'b0000_0000;
                    o_eight_pulse   <= 1'b0;
                end
                default: begin
                    // Reset all registers
                    reg_state       <= IDLE;
                    reg_bias        <= 7'b000_0000;
                    reg_mini_cycle  <= 3'b000;
                    reg_total_cycle <= 4'b0000;
                    // Reset all outputs
                    o_bmem_addr     <= 7'b000_0000;
                    o_omem_addr     <= 8'b0000_0000;
                    o_eight_pulse   <= 1'b0;
                end            
            endcase
        end
    end

    // Assign outputs
    assign o_amem_addr = reg_bias + reg_mini_cycle;
    assign o_read      = (reg_state==READ) ? 1'b1 : 1'b0;

    assign o_amem_cen = ~o_read;
    assign o_bmem_cen = ~o_read;

    assign o_amem_wen = o_read;
    assign o_bmem_wen = o_read;

    assign o_omem_cen = ~o_eight_pulse;
    assign o_omem_wen = ~o_eight_pulse;
endmodule