`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: SD
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Simulate the environment
//////////////////////////////////////////////////////////////////////////////////

module SD(
    input wire clk, rst, learning,
    input wire [1:0] A,
    input wire [11:0] S0,
    input wire [11:0] traffic,
    output wire [11:0] S,
    // for debugging 
    output wire [2:0] level0, level1, level2, level3,
    output reg [2:0] L0, L1, L2, L3
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
