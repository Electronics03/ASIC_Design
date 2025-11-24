`timescale 1ns/1ps

module mm_tester(
    input   wire            i_clk,
    
    output  reg             o_cen,
    output  reg             o_wen,
    output  reg     [8:0]   o_addr,
    output  reg     [31:0]  o_din,
    input   wire    [31:0]  i_dout,
    
    output  reg             o_rstn,
    output  reg             o_matmul_en,
    output  reg     [2:0]   o_fl,
    input   wire            i_done
);

    reg [15:0] local_amem  [0:127];
    reg [15:0] local_bmem  [0:127];
    reg [31:0] local_omem  [0:255];
    reg [31:0] golden_omem [0:255];

    initial begin
        load_hex_files();
        initialization();
        reset_pulse();
        #100;
        wait(i_done == 1'b1);
        write_mem_data();
        o_cen = 0;
        o_wen = 1;
        verify_input_data();

        matmul_pulse();

        wait(i_done == 1'b0);
        wait(i_done == 1'b1);

        o_cen = 0;
        o_wen = 1;
        check_output_data();

        store_hex_files();
        $finish;
    end

    task load_hex_files;
        begin
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Design/00_ASIC_Project/01_Initial_Data/amem.hex", local_amem);
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Design/00_ASIC_Project/01_Initial_Data/bmem.hex", local_bmem);
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Design/00_ASIC_Project/01_Initial_Data/omem_fl4.hex", golden_omem);
        end
    endtask

    task store_hex_files;
        begin
            $writememh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Design/00_ASIC_Project/03_Ouput_Data/omem_fl4_out.hex", local_omem);
        end
    endtask

    task initialization;
        begin
            o_cen = 1'b1; 
            o_wen = 1'b1; 
            o_addr = 9'd0; 
            o_din = 32'd0; 

            o_rstn = 1'b1;
            o_matmul_en = 1'b0;
            o_fl = 3'd4;
            #40;        
        end
    endtask

    task reset_pulse;
        begin
            @(posedge i_clk)
            #10;
            o_rstn = 1'b0;
            #20;
            o_rstn = 1'b1;
            #10;
        end
    endtask

    task matmul_pulse;
        begin
            @(posedge i_clk)
            #10;
            o_matmul_en = 1'b1;
            #20;
            o_matmul_en = 1'b0;
            #10;
        end
    endtask

    task write_mem_data;
        @(posedge i_clk)
        begin
            for (integer i=0; i<128; i=i+1) begin
                #10;
                o_cen = 0;
                o_wen = 0; 
                o_addr = i;
                o_din = {16'b0, local_amem[i]};
                #10;
            end
            for (integer i=0; i<128; i=i+1) begin
                #10;
                o_cen = 0; 
                o_wen = 0; 
                o_addr = i + 128;
                o_din = {16'b0, local_bmem[i]};
                #10;
            end
            #10;
            o_cen = 1;
            o_wen = 1;
        end
    endtask

    task verify_input_data;
        reg [31:0] read_val;
        begin
            for (integer i=0; i<128; i=i+1) begin
                o_addr = i;
                @(posedge i_clk);
                #10;
                read_val = i_dout;
                if (read_val[15:0] !== local_amem[i]) begin
                    $display("[Error] AMEM Addr %d : Exp %h, Got %h", i, local_amem[i], read_val[15:0]);
                end
            end
            for (integer i=0; i<128; i=i+1) begin
                o_addr = i + 128;
                @(posedge i_clk);
                #10;
                read_val = i_dout;
                if (read_val[15:0] !== local_bmem[i]) begin
                    $display("[Error] BMEM Addr %d : Exp %h, Got %h", i+128, local_bmem[i], read_val[15:0]);
                end
            end
            @(posedge i_clk);
            o_cen = 1;
        end
    endtask

    task check_output_data;
        reg [31:0] read_val;
        begin
            for (integer i=0; i<256; i=i+1) begin
                o_addr = i + 256;
                @(posedge i_clk);
                #10;
                read_val = i_dout;
                if (read_val != 0) begin
                    local_omem[i] = read_val;
                    $display("OMEM[%d] = %h (Decimal: %d)", i, read_val, read_val);
                end
            end
            @(posedge i_clk);
            o_cen = 1;
        end
    endtask
endmodule