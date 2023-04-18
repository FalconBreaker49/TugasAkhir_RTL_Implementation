`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// States converter to simulate the traffic environment
//////////////////////////////////////////////////////////////////////////////////
// A_A : Action A, A_B : Action B
// S0_A & S0_B : Intial state untuk A dan B??
// traffic_A dan B itu real traffic in terms of vehicles kan?
// S_A dan S_B adalah converted traffic states to state
module SD(
    input wire clk, rst, learning,
    input wire [1:0] A_A,A_B,
    input wire [11:0] S0_A, S0_B,
    input wire [11:0] traffic_A,traffic_B,
    output wire [11:0] S_A,S_B
    // for debugging 
    output wire [2:0] level0_A, level1_A, level2_A, level3_A,
    output wire [2:0] level0_B, level1_B, level2_B, level3_B,
    output reg [2:0] L0_A, L1_A, L2_A, L3_A,
    output reg [2:0] L0_B, L1_B, L2_B, L3_B
    );
       
//    reg [2:0] L0, L1, L2, L3;
//    wire [2:0] level0, level1, level2, level3;
    always@(posedge clk) begin
        if (rst) begin
            L0 <= 3'b000;
            L1 <= 3'b000;
            L2 <= 3'b000;
            L3 <= 3'b000;
        end else begin
            L0 <= level0;
            L1 <= level1;
            L2 <= level2;
            L3 <= level3;
        end
    end   
    
    assign level0 = (A==0)? (L0>>1): 
                    ((L0!=3'b111)? (L0 + 1'b1):(3'b111));
    assign level1 = (A==1)? (L1>>1): 
                    ((L1!=3'b111)? (L1 + 1'b1):(3'b111)); 
    assign level2 = (A==2)? (L2>>1): 
                    ((L2!=3'b111)? (L2 + 1'b1):(3'b111));
    assign level3 = (A==3)? (L3>>1):
                    ((L3!=3'b111)? (L3 + 1'b1):(3'b111));
    
//    wire [11:0] Stemp;
    assign S = learning? (((L0)|(L1<<3)|(L2<<6)|(L3<<9))|12'h000) : traffic;
    
//    enabler_12bit en0(  .en(en),
//                        .in0(Stemp),    .out0(S));
endmodule
