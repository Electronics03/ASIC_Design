//////////////////////////////////////////////////////////////////////////////////
// University : Chung-Ang University
// Department : Electrical and Electronics Engineering
// Engineer   : SANGHYEOK PARK
// 
// Create Date:    2025/11/20 20:30:00
// Design Name:    Pipelined_Matmul_16x16
// Module Name:    accumulator
// Project Name:   ASIC_Design_Project
// Target Devices: Nexys-A7-100T/ARTIX-7
// Tool Versions:  VIVADO 2024.1
// Description:    Accumulator and Pipelining Signals for 16x16 MatMul
// Dependencies:   No dependency
// 
//////////////////////////////////////////////////////////////////////////////////

module accumulator (
    // Control inputs
    input  wire         i_clk,
    input  wire         i_rstn,
    input  wire         i_eight_pulse,
    input  wire         i_read,

    // SRAM data output
    input  wire [15:0]  i_amem_dout,
    input  wire [15:0]  i_bmem_dout,
    // Fraction length
    input  wire [2:0]   i_fl,
    // Accumulate result
    output wire [31:0]  o_acc,

    // Input SRAM Control signals
    input  wire         i_omem_cen,
    input  wire         i_omem_wen,
    input  wire [7:0]   i_omem_addr,

    // Piped SRAM Controls
    output wire         o_omem_cen_pipe,
    output wire         o_omem_wen_pipe,
    output wire [7:0]   o_omem_addr_pipe,

    // Piped Controls
    output wire         o_read_pipe,
    output wire         o_eight_pulse_pipe,

    // Done signal
    output wire         o_calc_done
);

    // Signed Calculate results
    wire signed [7:0]  matA_data [0:1];
    wire signed [7:0]  matB_data [0:1];
    wire signed [15:0] mul_AB    [0:1];
    wire signed [16:0] sum;
    // Pipelining Register between mul and adder
    reg signed [15:0] reg_mul_AB_pipe [0:1];
    // Accumulator Register
    reg signed [31:0] reg_acc;

    // Pipelining Register for Control signals
    reg [3:0] reg_read_pipe;
    reg [2:0] reg_eight_pulse_pipe;
    reg [7:0] reg_omem_addr_pipe [2:0];
    reg [2:0] reg_omem_cen_pipe; 
    reg [2:0] reg_omem_wen_pipe;
    // Propagate Control signals to next Register
    always @(posedge i_clk) begin
        if (~i_rstn) begin
            reg_read_pipe           <= 4'b0000;
            reg_eight_pulse_pipe    <= 1'b0;
            reg_omem_addr_pipe[0]   <= 8'd0;
            reg_omem_addr_pipe[1]   <= 8'd0;
            reg_omem_addr_pipe[2]   <= 8'd0;
            reg_omem_cen_pipe       <= 3'b111;
            reg_omem_wen_pipe       <= 3'b111;
        end
        else begin
            reg_read_pipe           <= {reg_read_pipe[2:0], i_read};
            reg_eight_pulse_pipe    <= {reg_eight_pulse_pipe[1:0], i_eight_pulse};
            reg_omem_addr_pipe[0]   <= i_omem_addr;
            reg_omem_addr_pipe[1]   <= reg_omem_addr_pipe[0];
            reg_omem_addr_pipe[2]   <= reg_omem_addr_pipe[1];
            reg_omem_cen_pipe       <= {reg_omem_cen_pipe[1:0], i_omem_cen};
            reg_omem_wen_pipe       <= {reg_omem_wen_pipe[1:0], i_omem_wen};
        end
    end

    // Pipelining Register between mul and adder
    always @(posedge i_clk) begin
        if (~i_rstn) begin
            reg_mul_AB_pipe[0] <= 17'd0;
            reg_mul_AB_pipe[1] <= 17'd0;
        end
        else begin
            reg_mul_AB_pipe[0] <= mul_AB[0];
            reg_mul_AB_pipe[1] <= mul_AB[1];
        end
    end

    // Signed integer calculate
    assign matA_data[0] = $signed(i_amem_dout[7:0]);
    assign matA_data[1] = $signed(i_amem_dout[15:8]);
    assign matB_data[0] = $signed(i_bmem_dout[7:0]);
    assign matB_data[1] = $signed(i_bmem_dout[15:8]);

    // Multiplier
    assign mul_AB[0] = matA_data[0] * matB_data[0];
    assign mul_AB[1] = matA_data[1] * matB_data[1];

    // Adder
    assign sum = reg_mul_AB_pipe[0] + reg_mul_AB_pipe[1];

    // Acc operate
    always @(posedge i_clk) begin
        if (~i_rstn) begin
            reg_acc <= 32'd0;
        end
        else begin
            if (~(reg_read_pipe[2]|reg_read_pipe[1]|i_read)) begin
                reg_acc <= 32'd0;
            end
            else if (reg_read_pipe[1]) begin
                if (reg_eight_pulse_pipe[2]) begin
                    reg_acc <= sum;
                end
                else begin
                    reg_acc <= reg_acc + sum;
                end
            end
        end
    end

    // Truncation
    assign o_acc = reg_acc >>> i_fl;
    // Output piplined signals
    assign o_read_pipe        = reg_read_pipe[2];
    assign o_eight_pulse_pipe = reg_eight_pulse_pipe[2];
    assign o_omem_addr_pipe   = reg_omem_addr_pipe[2];
    assign o_omem_cen_pipe    = reg_omem_cen_pipe[2];
    assign o_omem_wen_pipe    = reg_omem_wen_pipe[2];
    // Done signal
    assign o_calc_done = ~(reg_read_pipe[3]|reg_read_pipe[2]|reg_read_pipe[1]|i_read);
endmodule