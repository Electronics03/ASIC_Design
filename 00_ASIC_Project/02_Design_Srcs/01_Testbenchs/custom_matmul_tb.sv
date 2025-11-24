`timescale 1ns/1ps

module custom_matmul16x16_tb;
    reg            i_clk;
    
    reg            i_cen;
    reg            i_wen;
    reg    [8:0]   i_addr;
    reg    [31:0]  i_din;
    wire   [31:0]  o_dout;

    reg            i_rstn;
    reg            i_matmul_en;
    reg    [2:0]   i_fl;
    wire           o_done;

    reg [15:0] local_amem  [0:127];
    reg [15:0] local_bmem  [0:127];
    reg [31:0] local_omem  [0:255];
    reg [31:0] golden_omem [0:255];

    custom_matmul16x16 custom_matmul16x16_inst (
        .i_clk       (i_clk),

        .i_cen       (i_cen),
        .i_wen       (i_wen),
        .i_addr      (i_addr),
        .i_din       (i_din),
        .o_dout      (o_dout),

        .i_rstn      (i_rstn),
        .i_matmul_en (i_matmul_en),
        .i_fl        (i_fl),
        .o_done      (o_done)
    );

    always #5 i_clk = ~i_clk;

    initial begin
        load_hex_files();
        initialization();
        reset_pulse();
        #100;
        wait(o_done == 1'b1);
        write_mem_data();
        i_cen = 0;
        i_wen = 1;
        verify_input_data();

        matmul_pulse();

        wait(o_done == 1'b0);
        wait(o_done == 1'b1);

        i_cen = 0;
        i_wen = 1;
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
            i_clk = 1'b1;

            i_cen = 1'b1; 
            i_wen = 1'b1; 
            i_addr = 9'd0; 
            i_din = 32'd0; 

            i_rstn = 1'b1;
            i_matmul_en = 1'b0;
            i_fl = 3'd4;
            #20;        
        end
    endtask

    task reset_pulse;
        begin
            @(posedge i_clk)
            #5;
            i_rstn = 1'b0;
            #10;
            i_rstn = 1'b1;
            #5;
        end
    endtask

    task matmul_pulse;
        begin
            @(posedge i_clk)
            #5;
            i_matmul_en = 1'b1;
            #10;
            i_matmul_en = 1'b0;
            #5;
        end
    endtask

    task write_mem_data;
        @(posedge i_clk)
        begin
            for (integer i=0; i<128; i=i+1) begin
                #5;
                i_cen = 0;
                i_wen = 0; 
                i_addr = i;
                i_din = {16'b0, local_amem[i]};
                #5;
            end
            for (integer i=0; i<128; i=i+1) begin
                #5;
                i_cen = 0; 
                i_wen = 0; 
                i_addr = i + 128;
                i_din = {16'b0, local_bmem[i]};
                #5;
            end
            #5;
            i_cen = 1;
            i_wen = 1;
        end
    endtask

    task verify_input_data;
        reg [31:0] read_val;
        begin
            for (integer i=0; i<128; i=i+1) begin
                i_addr = i;
                @(posedge i_clk);
                #5;
                read_val = o_dout;
                if (read_val[15:0] !== local_amem[i]) begin
                    $display("[Error] AMEM Addr %d : Exp %h, Got %h", i, local_amem[i], read_val[15:0]);
                end
            end
            for (integer i=0; i<128; i=i+1) begin
                i_addr = i + 128;
                @(posedge i_clk);
                #5;
                read_val = o_dout;
                if (read_val[15:0] !== local_bmem[i]) begin
                    $display("[Error] BMEM Addr %d : Exp %h, Got %h", i+128, local_bmem[i], read_val[15:0]);
                end
            end
            @(posedge i_clk);
            i_cen = 1;
        end
    endtask

    task check_output_data;
        reg [31:0] read_val;
        begin
            for (integer i=0; i<256; i=i+1) begin
                i_addr = i + 256;
                @(posedge i_clk);
                #5;
                read_val = o_dout;
                if (read_val != 0) begin
                    local_omem[i] = read_val;
                    $display("OMEM[%d] = %h (Decimal: %d)", i, read_val, read_val);
                end
            end
            @(posedge i_clk);
            i_cen = 1;
        end
    endtask
endmodule