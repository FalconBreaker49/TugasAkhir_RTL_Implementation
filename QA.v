`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: QA
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Performing Bellman Equation Q-Learning
//////////////////////////////////////////////////////////////////////////////////

module QA(
    input wire clk, rst,
    input wire [31:0] Q0, Q1, Q2, Q3,
    input wire [31:0] R,
    input wire [1:0] A, Amax,
    input wire [2:0] alpha, gamma,
    output reg [31:0] Qnew
    );
    
    // REGISTERS
    reg [31:0] Q0_reg0, Q1_reg0, Q2_reg0, Q3_reg0;
    reg [31:0] Q0_reg1, Q1_reg1, Q2_reg1, Q3_reg1;
    reg [1:0] Amax_reg0, A_reg0;
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
        // Q-VALUES
        Q0_reg0 <= Q0;
        Q1_reg0 <= Q1;
        Q2_reg0 <= Q2;
        Q3_reg0 <= Q3;
        Q0_reg1 <= Q0_reg0;
        Q1_reg1 <= Q1_reg0;
        Q2_reg1 <= Q2_reg0;
        Q3_reg1 <= Q3_reg0;
        // ACTIONS
        Amax_reg0 <= Amax;
        A_reg0 <= A;
        // REWARD
        R_reg0 <= R;
    end

    wire [31:0] Qmax;
    mux4to1_32bit max0( .in0(Q0_reg0),   .in1(Q1_reg0),   .in2(Q2_reg0),   .in3(Q3_reg0),
                        .sel(Amax_reg0),  .out0(Qmax)
                        );
    
    wire [31:0] Qsel;
    mux4to1_32bit mux0( .in0(Q0_reg1),   .in1(Q1_reg1),   .in2(Q2_reg1),   .in3(Q3_reg1),
                        .sel(A_reg0),    .out0(Qsel)
                        );
    
    // REGISTER SELECTED Q-VALUES                    
    reg [31:0] Qsel_reg0, Qsel_reg1, Qsel_reg2, Qsel_reg3;  
    always @(posedge clk) begin
        Qsel_reg0 <= Qsel;
        Qsel_reg1 <= Qsel_reg0;
        Qsel_reg2 <= Qsel_reg1;
        Qsel_reg3 <= Qsel_reg2;
    end              
    
    // Bellman Equation : Qnew = Qsel + a(R + g*Qmax' - Qsel)
    wire [31:0] Gm;
    reg [31:0] Gm_reg0;
    multiply mul0(.in0(Qmax), .c(gamma), .out0(Gm));
    always @(posedge clk) begin
        Gm_reg0 <= Gm;
    end
    
    wire [31:0] RQ, RQg, Ap;
    reg [31:0] R_reg0, Ap_reg0;
    assign RQ  = R_reg0 - Qsel_reg1;
    assign RQg = RQ + Gm_reg0;
    reg [31:0] RQg_reg0;
    always @(posedge clk) begin
        RQg_reg0 <= RQg;
    end
    multiply mul1(.in0(RQg_reg0), .c(alpha), .out0(Ap));
    always @(posedge clk) begin
        Ap_reg0 <= Ap;
    end
                    
    wire [31:0] Qnew_temp0;
    assign Qnew_temp0 = Ap_reg0 + Qsel_reg3;
    always @(posedge clk) begin
        Qnew <= Qnew_temp0;
    end
    
//    enabler_32bit en(.en(en),
//                    .in0(Qnew_temp1), .out0(Qnew));

endmodule
