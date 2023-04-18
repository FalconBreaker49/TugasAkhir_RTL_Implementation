
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Decide coordinated action based on epsilon-greedy algorithm
//////////////////////////////////////////////////////////////////////////////////
// Qvalues dari Q-matrix A dan B. Setelah itu, Random Action untuk A dan B. Selected Action (Greedy) A & B.
// Outputnya memberikan action A dan B
// Output wire untuk Action Max dan Min A & B belum tau untuk apa. --> Untuk reward based kah?
module PG(
    input wire clk, rst,
    input wire [31:0] Q0_A, Q1_A, Q2_A, Q3_A,
    input wire [31:0] Q0_B, Q1_B, Q2_B, Q3_B,
    input wire [1:0] Arand_A,Arand_B,
    input wire Asel_A, Asel_B
    input wire learning,
    output wire [1:0] Amax_A, Amax_B
    output wire [1:0] Amin_A, Amin_B 
    output wire [1:0] A_A,A_B
    );
    // Mencari Q-value minimum dan maximum untuk Q-matrix A
    wire [31:0] Q_min_A;                  
    min4to1_32bit min0(.in0(Q0_A), .in1(Q1_A), .in2(Q2_A), .in3(Q3_A),
                       .out0(Q_min_A));
                      
    wire [31:0] Q_max_A;
    max4to1_32bit max0(.in0(Q0_A), .in1(Q1_A), .in2(Q2_A), .in3(Q3_A),
                       .out0(Q_max_A));
    
    
    // Mencari Q-value minimum dan maximum untuk Q-matrix B
    wire [31:0] Q_min_B;                  
    min4to1_32bit min1(.in0(Q0_B), .in1(Q1_B), .in2(Q2_B), .in3(Q3_B),
                       .out0(Q_min_B));
                      
    wire [31:0] Q_max_B;
    max4to1_32bit max1(.in0(Q0_B), .in1(Q1_B), .in2(Q2_B), .in3(Q3_B),
                       .out0(Q_max_B));
    
    
    //Register untuk menyimpan sementara? Untuk bagian sekuensial.
    reg [31:0] Q_min_reg0_A, Q_max_reg0_A;
    reg [31:0] Q_min_reg0_B, Q_max_reg0_B;
    reg [11:0] Stest_A,Stest_B; //State penguji untuk intersection A dan B
    //Belum bikin deklarasi register penyimpan sementara Q0 sampai Q3 untuk A dan B 
    reg [31:0] Q0_reg0_A,Q1_reg0_A,Q2_reg0_A,Q3_reg0_A; 
    reg [31:0] Q0_reg0_B,Q1_reg0_B,Q2_reg0_B,Q3_reg0_B;
    //Bagian Sekuensial 
    always @(posedge clk) begin
        // Jika reset == 1 (true) maka inisialisasi semua nilai ke 0
        if(rst)begin
            // Untuk yang berhubungan dengan Intersection A
            Q_min_reg0_A <= 32'd0;
            Q_max_reg0_A <= 32'd0;
            Q0_reg0_A <= 32'd0;
            Q1_reg0_A <= 32'd0;
            Q2_reg0_A <= 32'd0;
            Q3_reg0_A <= 32'd0;
            
            // Untuk yang berhubungan dengan Intersection A
            Q_min_reg0_B <= 32'd0;
            Q_max_reg0_B <= 32'd0;
            Q0_reg0_B <= 32'd0;
            Q1_reg0_B <= 32'd0;
            Q2_reg0_B <= 32'd0;
            Q3_reg0_B <= 32'd0;
            
        end else begin
            //Jika bukan reset (bukan kondisi awal) 
            Q_min_reg0_A <= Q_min_A;
            Q_max_reg0_A <= Q_max_A;
            Q0_reg0_A <= Q0_A;
            Q1_reg0_A <= Q1_A;
            Q2_reg0_A <= Q2_A;
            Q3_reg0_A <= Q3_A;
            
            Q_min_reg0_B <= Q_min_B;
            Q_max_reg0_B <= Q_max_B;
            Q0_reg0_B <= Q0_B;
            Q1_reg0_B <= Q1_B;
            Q2_reg0_B <= Q2_B;
            Q3_reg0_B <= Q3_B;
        end
    end
    
    
    //Bagian Kombinasional
    //Menentukan minimum Action berdasarkan Q-value minimum dan Maximum Action berdasarkan Q-value maximum? 
    assign Amin_A = (Q0_reg0_A == Q_min_reg0_A)? 2'd0:
                  (Q1_reg0_A == Q_min_reg0_A)? 2'd1: 
                  (Q2_reg0_A == Q_min_reg0_A)? 2'd2: 2'd3;
    

    assign Amax_A = (Q0_reg0_A == Q_max_reg0_A)? 2'd0:
                  (Q1_reg0_A == Q_max_reg0_A)? 2'd1: 
                  (Q2_reg0_A == Q_max_reg0_A)? 2'd2: 2'd3;
    
    
    assign Amin_B = (Q0_reg0_B == Q_min_reg0_B)? 2'd0:
                    (Q1_reg0_B == Q_min_reg0_B)? 2'd1: 
                    (Q2_reg0_B == Q_min_reg0_B)? 2'd2: 2'd3;
    

    assign Amax_B = (Q0_reg0_B == Q_max_reg0_B)? 2'd0:
                    (Q1_reg0_B == Q_max_reg0_B)? 2'd1: 
                    (Q2_reg0_B == Q_max_reg0_B)? 2'd2: 2'd3;
    
    reg [1:0] Agreed_A,Agreed_B; // Untuk greedy action A dan B
    
    //Bagian sekuensial penentuan action greedy (jika greedy)
    always @(posedge clk)begin
        if (rst) begin
            Agreed_A <= 2'd0;
            Agreed_B <= 2'd0;
        end else begin 
            Agreed_A <= Amax_A;
            Agreed_B <= Amax_B;
        end
    end 
    //Bagian sekuensial untuk selection action. 
    reg Asel_reg_A, Asel_reg_B;
    reg [1:0] Arand_reg_A, Arand_reg_A;
    always @(posedge clk) begin
        Asel_reg_A <= Asel_A;
        Asel_reg_A <= Asel_A;
        
        Arand_reg_A <= Arand_A;
        Arand_reg_B <= Arand_B;
    end
    //Assigning kombinasional terakhir untuk menentukan output Action A dan Action B. 
    // Ditambah learning agar ketika sudah selesai learning selalu mengambil greedy action?
    assign A_A = ((Asel_reg_A)&(learning))? Agreed_A : Arand_reg_A;
    assign A_B = ((Asel_reg_B)&(learning))? Agreed_B : Arand_reg_B;
    
//    wire [1:0] Atemp;
//    enabler_2bit en0(.en(en),
//                    .in0(Atemp), .out0(A));           
endmodule

//module PG(
//    input wire clk, rst,
//    input wire [11:0] S,
//    input wire [1:0] Arand,
//    input wire Asel,
//    input wire learning,
//    output wire [1:0] Amax,
//    output wire [1:0] Amin,
//    output wire [1:0] A
//    );
       
//    wire [2:0] Min_temp;                  
//    min4to1_3bit min0(.in0(S[2:0]), .in1(S[5:3]), .in2(S[8:6]), .in3(S[11:9]),
//                      .out0(Min_temp));
                      
//    wire [2:0] Max_temp;
//    max4to1_3bit max0(.in0(S[2:0]), .in1(S[5:3]), .in2(S[8:6]), .in3(S[11:9]),
//                      .out0(Max_temp));
    
//    reg [2:0] Min, Max;
//    reg [11:0] Stest;                  
//    always @(posedge clk) begin
//        if(rst)begin
//            Min <= 3'd0;
//            Max <= 3'd0;
//            Stest <= 12'd0;
//        end else begin
//            Min <= Min_temp;
//            Max <= Max_temp;
//            Stest <= S;
//        end
//    end
    
//    assign Amin = (Min==Stest[2:0])? 2'd0:
//                  (Min==Stest[5:3])? 2'd1: 
//                  (Min==Stest[8:6])? 2'd2: 2'd3;
    

//    assign Amax = (Max==Stest[2:0])? 2'd0:
//                  (Max==Stest[5:3])? 2'd1: 
//                  (Max==Stest[8:6])? 2'd2: 2'd3;
    
//    reg [1:0] Agreed;
//    always @(posedge clk)begin
//        if (rst) begin
//            Agreed <= 2'd0;
//        end else begin 
//            Agreed <= Amax;
//        end
//    end 
    
//    reg Asel_reg;
//    reg [1:0] Arand_reg;
//    always @(posedge clk) begin
//        Asel_reg <= Asel;
//        Arand_reg <= Arand;
//    end
//    assign A = ((Asel_reg)&(learning))? Agreed : Arand_reg;
    
////    wire [1:0] Atemp;
////    enabler_2bit en0(.en(en),
////                    .in0(Atemp), .out0(A));           
//endmodule
