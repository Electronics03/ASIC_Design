`timescale 1ns / 1ps

module mm_tester(
    input   wire            i_clk,
    
    // To custom_matmul
    output  reg             o_cen,
    output  reg             o_wen,       // 0: Write, 1: Read (일반적 SRAM)
    output  reg     [8:0]   o_addr,
    output  reg     [31:0]  o_din,
    input   wire    [31:0]  i_dout,
    
    output  reg             o_rstn,
    output  reg             o_matmul_en,
    output  reg     [2:0]   o_fl,
    input   wire            i_done
    );

    // 1. 내부 메모리 (파일에서 읽어올 버퍼)
    reg [15:0] local_amem  [0:127];
    reg [15:0] local_bmem  [0:127];
    reg [31:0] golden_omem [0:255]; // 정답 비교용 (있다면 사용)

    integer i;
    integer err_cnt;

    // 2. 초기화 및 테스트 시나리오 실행
    initial begin
        // --- (Step 0) 초기화 및 파일 로드 ---
        init_ports();
        load_hex_files();
        
        // 리셋 인가
        #50 o_rstn = 0;
        #50 o_rstn = 1;
        #50;

        $display("-------------------------------------------");
        $display(" [Step 1] Writing Data to AMEM & BMEM ... ");
        $display("-------------------------------------------");
        
        // --- (Step 1) 데이터 쓰기 (Tester -> IP) ---
        write_mem_data();
        
        #100;
        
        $display("-------------------------------------------");
        $display(" [Step 2] Verifying Written Data ... ");
        $display("-------------------------------------------");

        // --- (Step 2) 데이터가 잘 들어갔는지 읽어서 확인 ---
        verify_input_data();

        if (err_cnt == 0) $display(" -> Input Data Verification PASSED!");
        else begin 
            $display(" -> Input Data Verification FAILED! Errors: %d", err_cnt);
            $finish; // 데이터가 안 들어갔으면 연산 의미 없음
        end

        #100;

        $display("-------------------------------------------");
        $display(" [Step 3] Starting Matrix Multiplication ... ");
        $display("-------------------------------------------");

        // --- (Step 3) 연산 시작 ---
        // Done 신호가 1(Idle)인지 확인 후 시작
        wait(i_done == 1'b1);
        
        @(posedge i_clk);
        o_matmul_en = 1; // Start Pulse
        @(posedge i_clk);
        o_matmul_en = 0;

        // 연산이 끝날 때까지 대기
        // (i_done이 0으로 떨어졌다가(Busy), 다시 1(Idle)이 될 때까지)
        wait(i_done == 1'b0); // Busy 진입 확인
        wait(i_done == 1'b1); // 완료 확인
        
        $display(" -> Calculation Finished detected by o_done signal.");

        #100;

        $display("-------------------------------------------");
        $display(" [Step 4] Reading & Checking Results ... ");
        $display("-------------------------------------------");

        // --- (Step 4) 결과 읽기 및 확인 ---
        check_output_data();

        $display("-------------------------------------------");
        $display(" All Tests Completed.");
        $display("-------------------------------------------");
        $finish;
    end

    // =========================================================
    // Tasks (기능별 함수)
    // =========================================================

    // 포트 초기화
    task init_ports;
        begin
            o_cen = 1;
            o_wen = 1; // Read mode
            o_addr = 0;
            o_din = 0;
            o_rstn = 1;
            o_matmul_en = 0;
            o_fl = 4; // 예시 설정
            err_cnt = 0;
        end
    endtask

    // Hex 파일 로드 (경로는 사용자 환경에 맞게 수정 필요)
    task load_hex_files;
        begin
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Project/amem.hex", local_amem);
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Project/bmem.hex", local_bmem);
            $readmemh("C:/Users/PSH/Documents/25_2_Lectures/ASIC_design/ASIC_Project/omem_fl4.hex", golden_omem);
        end
    endtask

    // SRAM에 데이터 쓰기 (AMEM: 0~127, BMEM: 128~255)
    task write_mem_data;
        begin
            // 1. Write AMEM
            for (i=0; i<128; i=i+1) begin
                @(posedge i_clk);
                o_cen = 0; 
                o_wen = 0; // Write Enable (Active Low 가정)
                o_addr = i; 
                o_din = {16'b0, local_amem[i]}; // 32bit 입력에 16bit 데이터
            end
            
            // 2. Write BMEM
            for (i=0; i<128; i=i+1) begin
                @(posedge i_clk);
                o_cen = 0; 
                o_wen = 0; 
                o_addr = i + 128; // Offset 128
                o_din = {16'b0, local_bmem[i]};
            end

            // 쓰기 종료
            @(posedge i_clk);
            o_cen = 1;
            o_wen = 1;
        end
    endtask

// -----------------------------------------------------------
    // Task: verify_input_data
    // -----------------------------------------------------------
    task verify_input_data;
        reg [31:0] read_val;
        begin
            // 1. Check AMEM
            for (i=0; i<128; i=i+1) begin
                @(posedge i_clk);
                o_cen = 0; o_wen = 1; // Read
                o_addr = i;
                
                @(posedge i_clk); // Latency 1 (데이터 나오는 클럭)
                
                // [수정 전] #1;  <-- RAM 딜레이와 겹침!
                // [수정 후] RAM이 #1 뒤에 데이터를 주니까, 우리는 여유 있게 #5 뒤에 읽자
                #5; 
                
                read_val = i_dout;
                
                if (read_val[15:0] !== local_amem[i]) begin
                    $display("[Error] AMEM Addr %d : Exp %h, Got %h", i, local_amem[i], read_val[15:0]);
                    err_cnt = err_cnt + 1;
                end
            end

            // 2. Check BMEM (동일하게 수정)
            for (i=0; i<128; i=i+1) begin
                @(posedge i_clk);
                o_cen = 0; o_wen = 1; 
                o_addr = i + 128;

                @(posedge i_clk);
                #5; // [수정] 샘플링 시점 늦춤
                read_val = i_dout;

                if (read_val[15:0] !== local_bmem[i]) begin
                    $display("[Error] BMEM Addr %d : Exp %h, Got %h", i+128, local_bmem[i], read_val[15:0]);
                    err_cnt = err_cnt + 1;
                end
            end
            
            @(posedge i_clk);
            o_cen = 1;
        end
    endtask

    // -----------------------------------------------------------
    // Task: check_output_data (동일하게 수정)
    // -----------------------------------------------------------
    task check_output_data;
        reg [31:0] read_val;
        begin
            $display(" --- Output Dump (Non-zero values) ---");
            
            for (i=0; i<256; i=i+1) begin
                @(posedge i_clk);
                o_cen = 0; o_wen = 1; 
                o_addr = i + 256;
                
                @(posedge i_clk);
                #5; // [수정] 샘플링 시점 늦춤
                read_val = i_dout;

                if (read_val != 0) begin
                    $display("OMEM[%d] = %h (Decimal: %d)", i, read_val, read_val);
                end
            end
            
            @(posedge i_clk);
            o_cen = 1;
        end
    endtask

endmodule