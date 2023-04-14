`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Performing Bellman Equation Q-Learning for Double Agent 
//////////////////////////////////////////////////////////////////////////////////

module QA(
    input wire clk, rst,
    input wire [31:0] Q0_A, Q1_A, Q2_A, Q3_A,
    input wire [31:0] Q0_B, Q1_B, Q2_B, Q3_B,
    input wire [31:0] R,
    input wire [1:0] A_A, Amax_A, A_B, Amax_B,
    input wire [2:0] alpha, gamma,
    output reg [31:0] Qnew_A,Qnew_B
    );
    
    // Reward R for both agents are the same. Action (A) and Action Max (Amax) are separate for both agents. 
    
    // REGISTERS
    //For Intersection A (Intersection 1)
    reg [31:0] Q0_reg0_A, Q1_reg0_A, Q2_reg0_A, Q3_reg0_A;
    reg [31:0] Q0_reg1_A, Q1_reg1_A, Q2_reg1_A, Q3_reg1_A;
    reg [1:0] Amax_reg0_A, A_reg0_A;
    //For Intersection B (Intersection 2)
    reg [31:0] Q0_reg0_B, Q1_reg0_B, Q2_reg0_B, Q3_reg0_B;
    reg [31:0] Q0_reg1_B, Q1_reg1_B, Q2_reg1_B, Q3_reg1_B;
    reg [1:0] Amax_reg0_B, A_reg0_B;
//    always @(posedge clk) begin 
//        if (rst) begin
//            Q0_reg0 <= 32'd0;
//            Q1_reg0 <= 32'd0;
//            Q2_reg0 <= 32'd0;
//            Q3_reg0 <= 32'd0;
//            Q0_reg1 <= 32'd0;
//            Q1_reg1 <= 32'd0;
//            Q2_reg1 <= 32'd0;
//            Q3_reg1 <= 32'd0;
//            Amax_reg0 <= 2'b00;
//            A_reg0 <= 2'b00;
//            R_reg0 <= 32'd0;
//        end else begin 
//            // Q-VALUES
//            Q0_reg0 <= Q0;
//            Q1_reg0 <= Q1;
//            Q2_reg0 <= Q2;
//            Q3_reg0 <= Q3;
//            Q0_reg1 <= Q0_reg0;
//            Q1_reg1 <= Q1_reg0;
//            Q2_reg1 <= Q2_reg0;
//            Q3_reg1 <= Q3_reg0;
//            // ACTIONS
//            Amax_reg0 <= Amax;
//            A_reg0 <= A;
//            // REWARD
//            R_reg0 <= R;
//        end
//    end
    always @(posedge clk) begin 
        // Q-VALUES for Intersection A
        Q0_reg0_A <= Q0_A;
        Q1_reg0_A <= Q1_A;
        Q2_reg0_A <= Q2_A;
        Q3_reg0_A <= Q3_A;
        Q0_reg1_A <= Q0_reg0_A;
        Q1_reg1_A <= Q1_reg0_A;
        Q2_reg1_A <= Q2_reg0_A;
        Q3_reg1_A <= Q3_reg0_A;
        // ACTIONS for Intersection A
        Amax_reg0_A <= Amax_A;
        A_reg0_A <= A_A;
        // REWARD for Intersection A
        R_reg0_A <= R;
        
        // Q-VALUES for Intersection B
        Q0_reg0_B <= Q0_B;
        Q1_reg0_B <= Q1_B;
        Q2_reg0_B <= Q2_B;
        Q3_reg0_B <= Q3_B;
        Q0_reg1_B <= Q0_reg0_B;
        Q1_reg1_B <= Q1_reg0_B;
        Q2_reg1_B <= Q2_reg0_B;
        Q3_reg1_B <= Q3_reg0_B;
        // ACTIONS for Intersection B
        Amax_reg0_B <= Amax_B;
        A_reg0_B <= A_B;
        // REWARD for Intersection B
        R_reg0_B <= R;
        
    end
    //For maximum Q-value Intersection A 
    wire [31:0] Qmax_A;
    mux4to1_32bit max0_A( .in0(Q0_reg0_A),   .in1(Q1_reg0_A),   .in2(Q2_reg0_A),   .in3(Q3_reg0_A),
                       .sel(Amax_reg0_A),  .out0(Qmax_A)
                        );
    
    wire [31:0] Qsel_A;
    mux4to1_32bit mux0_A( .in0(Q0_reg1_A),   .in1(Q1_reg1_A),   .in2(Q2_reg1_A),   .in3(Q3_reg1_A),
                       .sel(A_reg0_A),    .out0(Qsel_A)
                        );
    //For maximum Q-value Intersection B
    wire [31:0] Qmax_B;
    mux4to1_32bit max0_B( .in0(Q0_reg0_B),   .in1(Q1_reg0_B),   .in2(Q2_reg0_B),   .in3(Q3_reg0_B),
                       .sel(Amax_reg0_B),  .out0(Qmax_B)
                        );
    
    wire [31:0] Qsel_B;
    mux4to1_32bit mux0_B( .in0(Q0_reg1_B),   .in1(Q1_reg1_B),   .in2(Q2_reg1_B),   .in3(Q3_reg1_B),
                       .sel(A_reg0_B),    .out0(Qsel_B)
                        );
    
    
    // REGISTER SELECTED Q-VALUES FOR INTERSECTION A                    
    reg [31:0] Qsel_reg0_A, Qsel_reg1_A, Qsel_reg2_A, Qsel_reg3_A;  
    always @(posedge clk) begin
        Qsel_reg0_A <= Qsel_A;
        Qsel_reg1_A <= Qsel_reg0_A;
        Qsel_reg2_A <= Qsel_reg1_A;
        Qsel_reg3_A <= Qsel_reg2_A;
    end              
    // REGISTER SELECTED Q-VALUES FOR INTERSECTION B                    
    reg [31:0] Qsel_reg0_B, Qsel_reg1_B, Qsel_reg2_B, Qsel_reg3_B;  
    always @(posedge clk) begin
        Qsel_reg0_B <= Qsel_B;
        Qsel_reg1_B <= Qsel_reg0_B;
        Qsel_reg2_B <= Qsel_reg1_B;
        Qsel_reg3_B <= Qsel_reg2_B;
    end
    
    
    
    // Bellman Equation : Qnew_A = Qsel_a + a(R + g*Qmax_A' - Qsel_A) FOR INTERSECTION A & B
    //Setup Wires for initial Multiplication
    wire [31:0] Gm_A, Gm_B;
    reg [31:0] Gm_reg0_A, Gm_reg0_B;
    multiply mul0_A(.in0(Qmax_A), .c(gamma), .out0(Gm_A));
    multiply mul0_B(.in0(Qmax_B), .c(gamma), .out0(Gm_B));
    always @(posedge clk) begin
        Gm_reg0_A <= Gm_A;
        Gm_reg0_B <= Gm_B;
    end
    //Setup Wires for addition with reward and substraction from Temporal Difference
    wire [31:0] RQ_A, RQg_A, Ap_A;
    reg [31:0] R_reg0_A, Ap_reg0_A;
    
    wire [31:0] RQ_B, RQg_B, Ap_B;
    reg [31:0] R_reg0_B, Ap_reg0_B;
    
    //Arithmetic process
    assign RQ_A  = R_reg0_A - Qsel_reg1_A;
    assign RQg_A = RQ_A + Gm_reg0_A;
    assign RQ_B  = R_reg0_B - Qsel_reg1_B;
    assign RQg_B = RQ_B + Gm_reg0_B;
    
    reg [31:0] RQg_reg0_A, RQg_reg0_B;
    always @(posedge clk) begin
        RQg_reg0_A <= RQg_A;
        RQg_reg0_B <= RQg_B;
    end
    
    //Final Arithmetic process
    multiply mul1_A(.in0(RQg_reg0_A), .c(alpha), .out0(Ap_A));
    multiply mul1_B(.in0(RQg_reg0_B), .c(alpha), .out0(Ap_B));
    always @(posedge clk) begin
        Ap_reg0_A <= Ap_A;
        Ap_reg0_B <= Ap_B;
    end
    //Storing the updated Q-values                
    wire [31:0] Qnew_temp0_A, Qnew_temp0_B;
    assign Qnew_temp0_A = Ap_reg0_A + Qsel_reg3_A;
    assign Qnew_temp0_B = Ap_reg0_B + Qsel_reg3_B;
    always @(posedge clk) begin
        Qnew_A <= Qnew_temp0_A;
        Qnew_B <= Qnew_temp0_B;
    end
    
//    enabler_32bit en(.en(en),
//                    .in0(Qnew_temp1), .out0(Qnew));

endmodule
