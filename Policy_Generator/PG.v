
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Decide coordinated action based on epsilon-greedy algorithm
//////////////////////////////////////////////////////////////////////////////////

module PG(
    input wire clk, rst,
    input wire [31:0] Q0, Q1, Q2, Q3,
    input wire [1:0] Arand,
    input wire Asel,
    input wire learning,
    output wire [1:0] Amax,
    output wire [1:0] Amin,
    output wire [1:0] A
    );
       
    wire [31:0] Q_min;                  
    min4to1_32bit min0(.in0(Q0), .in1(Q1), .in2(Q2), .in3(Q3),
                       .out0(Q_min));
                      
    wire [31:0] Q_max;
    max4to1_32bit max0(.in0(Q0), .in1(Q1), .in2(Q2), .in3(Q3),
                       .out0(Q_max));
    
    reg [31:0] Q_min_reg0, Q_max_reg0;
    reg [11:0] Stest;                  
    always @(posedge clk) begin
        if(rst)begin
            Q_min_reg0 <= 32'd0;
            Q_max_reg0 <= 32'd0;
            Q0_reg0 <= 32'd0;
            Q1_reg0 <= 32'd0;
            Q2_reg0 <= 32'd0;
            Q3_reg0 <= 32'd0;
        end else begin
            Q_min_reg0 <= Q_min;
            Q_max_reg0 <= Q_max;
            Q0_reg0 <= Q0;
            Q1_reg0 <= Q1;
            Q2_reg0 <= Q2;
            Q3_reg0 <= Q3;
        end
    end
    
    assign Amin = (Q0_reg0 == Q_min_reg0)? 2'd0:
                  (Q1_reg0 == Q_min_reg0)? 2'd1: 
                  (Q2_reg0 == Q_min_reg0)? 2'd2: 2'd3;
    

    assign Amax = (Q0_reg0 == Q_max_reg0)? 2'd0:
                  (Q1_reg0 == Q_max_reg0)? 2'd1: 
                  (Q2_reg0 == Q_max_reg0)? 2'd2: 2'd3;
    
    reg [1:0] Agreed;
    always @(posedge clk)begin
        if (rst) begin
            Agreed <= 2'd0;
        end else begin 
            Agreed <= Amax;
        end
    end 
    
    reg Asel_reg;
    reg [1:0] Arand_reg;
    always @(posedge clk) begin
        Asel_reg <= Asel;
        Arand_reg <= Arand;
    end
    assign A = ((Asel_reg)&(learning))? Agreed : Arand_reg;
    
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
