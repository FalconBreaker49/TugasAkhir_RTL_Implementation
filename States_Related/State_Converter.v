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
        // Jika Reset == 1 maka dimulai dari initial conditions
        if (rst) begin
            // Initial state untuk intersection A  ?
            L0_A <= 3'b000;
            L1_A <= 3'b000;
            L2_A <= 3'b000;
            L3_A <= 3'b000;
            // Initial state untuk intersection B  ?
            L0_B <= 3'b000;
            L1_B <= 3'b000;
            L2_B <= 3'b000;
            L3_B <= 3'b000;
        end else begin
            // Jika Reset == 0 maka apapun yang ada di output wire dimasukkan ke register.
            L0_A <= level0_A;
            L1_A <= level1_A;
            L2_A <= level2_A;
            L3_A <= level3_A;

            L0_B <= level0_B;
            L1_B <= level1_B;
            L2_B <= level2_B;
            L3_B <= level3_B;

        end
    end   
    // Kombinasi aritmatika jika lane tertentu diberikan action untuk Intersection A / Interseciton 1
    assign level0_A = (A_A==0)? (L0_A>>1): 
                      ((L0_A!=3'b111)? (L0_A + 1'b1):(3'b111));
    assign level1_A = (A_A==1)? (L1_A>>1): 
                      ((L1_A!=3'b111)? (L1_A + 1'b1):(3'b111)); 
    assign level2_A = (A_A==2)? (L2_A>>1): 
                      ((L2_A!=3'b111)? (L2_A + 1'b1):(3'b111));
    assign level3_A = (A_A==3)? (L3_A>>1):
                      ((L3_A!=3'b111)? (L3_A + 1'b1):(3'b111));
    // Untuk Intersection B bagian update state traffic nya
    assign level0_B = (A_B==0)? (L0_B>>1): 
                      ((L0_B!=3'b111)? (L0_B + 1'b1):(3'b111));
    assign level1_B = (A_B==1)? (L1_B>>1): 
                      ((L1_B!=3'b111)? (L1_B + 1'b1):(3'b111)); 
    assign level2_B = (A_B==2)? (L2_B>>1): 
                      ((L2_B!=3'b111)? (L2_B + 1'b1):(3'b111));
    assign level3_B = (A_B==3)? (L3_B>>1):
                      ((L3_B!=3'b111)? (L3_B + 1'b1):(3'b111));
    
//    wire [11:0] Stemp;
    //Jika Learning adalah True artinya masih learning sehingga S di assign ke Level0 sampai Level3
    //Untuk Intersection A
    assign S_A = learning? (((L0_A)|(L1_A<<3)|(L2_A<<6)|(L3_A<<9))|12'h000) : traffic_A;
    assign S_B = learning? (((L0_B)|(L1_B<<3)|(L2_B<<6)|(L3_B<<9))|12'h000) : traffic_B;
    
//    enabler_12bit en0(  .en(en),
//                        .in0(Stemp),    .out0(S));
endmodule
