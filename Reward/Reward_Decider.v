`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Decide the given reward for both of the Agents
//////////////////////////////////////////////////////////////////////////////////

module RD( 
    // ------------
    input wire clk, rst,
    input wire [31:0] R0, R1, R2,
    input wire [1:0] Amax_A, Amin_A, A_A,
    input wire [1:0] Amax_B, Amin_B, A_B,
    output reg [31:0] R_A,R_B        
    );
      
    reg [1:0] Amax_reg0_A, Amin_reg0_A;
    reg [1:0] Amax_reg0_B, Amin_reg0_B;
    always @(posedge clk) begin
        Amax_reg0_A <= Amax_A;
        Amin_reg0_A <= Amin_A;
        
        Amax_reg0_B <= Amax_B;
        Amin_reg0_B <= Amin_B;
    end
    
    wire [31:0] Rtemp_A, Rtemp_B;
    assign Rtemp_A = (A_A==Amax_reg0_A)? R2 : 
                     ((A_A==Amin_reg0_A)? R0 : R1);
    
    
    assign Rtemp_B = (A_B==Amax_reg0_B)? R2 : 
                     ((A_B==Amin_reg0_B)? R0 : R1);
    
    reg [31:0] R_reg0_A, R_reg0_B;
    always @(posedge clk) begin
        R_reg0_A <= Rtemp_A;
        R_reg0_B <= Rtemp_B;
        R_A <= R_reg0_A;
        R_B <= R_reg0_B;
    end
    
//    wire [31:0] R_reg0;          
//    reg_32bit reg2(.clk(clk), .rst(rst),
//                    .in0(Rtemp), .out0(R_reg0));
////    enabler_32bit en0(.en(en),
////                      .in0(R_reg0), .out0(R_reg1));
//    reg_32bit reg3(.clk(clk), .rst(rst),
//                    .in0(R_reg0), .out0(R));
endmodule
