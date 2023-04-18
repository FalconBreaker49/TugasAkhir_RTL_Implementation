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
        Amax_reg0 <= Amax;
        Amin_reg0 <= Amin;
    end
    
    wire [31:0] Rtemp;
    assign Rtemp = (A==Amax_reg0)? R2 : 
                   ((A==Amin_reg0)? R0 : R1);
    
    reg [31:0] R_reg0;
    always @(posedge clk) begin
        R_reg0 <= Rtemp;
        R <= R_reg0;
        
    end
    
//    wire [31:0] R_reg0;          
//    reg_32bit reg2(.clk(clk), .rst(rst),
//                    .in0(Rtemp), .out0(R_reg0));
////    enabler_32bit en0(.en(en),
////                      .in0(R_reg0), .out0(R_reg1));
//    reg_32bit reg3(.clk(clk), .rst(rst),
//                    .in0(R_reg0), .out0(R));
endmodule
