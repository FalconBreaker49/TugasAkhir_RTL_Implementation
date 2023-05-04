// Testbench file for the Q-updater Module
'timescale 1ns / 1ps
//Testbench module for QA module.  
module QA_tb();
localparam INC = 32'h0005_0000;
//Initialize Reg for all Input Ports and Wire for all Output Ports
reg clk,rst;
reg [31:0] q0_A, q1_A, q2_A, q3_A;
reg [31:0] q0_B, q1_B, q2_B, q3_B;
reg [31:0] r;
reg [1:0] a_A, amax_A, a_B, amax_B;
real alph = 0.2;
real gamm = 0.8;
wire [31:0] qnew_A,qnew_B;

QA DUT ( 
	//Input Ports
	.clk(clk),
	.rst(rst),
	.Q0_A(q0_A), .Q1_A(q1_A), .Q2_A(q2_A), .Q3_A(q3_A),
	.Q0_B(q0_B), .Q1_B(q1_B), .Q2_B(q2_B), .Q3_B(q3_B), 
	.R(r), A_A(a_A),.Amax_A(amax_A), .A_B(a_B), Amax_B(amax_B),
	.alpha(alph),.gamma(gamm),
	//Output Ports
	.Qnew_A(qnew_A),.Qnew_B(qnew_B)
);
//Clock dengan periode 20ns
always 
begin
    clk = 0;
    #10;
    clk = 1;
    #10;
end


initial begin
	rst = 1;
	#20
	rst = 0;
	//Using the real only in Testbench since it's not synthesizable. 
	//Should put this in the beginning. 
	//real alph = 0.2;
	//real gamm = 0.8;
end
initial begin 
	q0_A= 32'h0000_1000; q1_A= 32'h0000_2000; q2_A=32'h0000_3000 ; q3_A= 32'h0000_4000;
	q0_B= 32'h0000_2000; q1_B= 32'h0000_3000; q2_B=32'h0000_4000 ; q3_B= 32'h0000_7000 ;
	r = 32'hfffffffa ; //-10 (dengan two's complement) 
	a_A = 2'd1; amax_A = 2'd3; a_B =2'd2 ; amax_B =2'd0 ;
end



// Q-value updating. Q-0 updated by shift, Q_1 & Q_2 updated by increment+-, Q_3 updated by 
 always @(posedge clk) begin
	 #2;
	 q0_A=q0_A<<1 ; q1_A=q1_A-INC ; q2_A=q2_A+INC ; q3_A=q3_A>>1 ;
	 q0_B=q0_B<<1 ; q1_B=q1_B-INC ; q2_B=q2_B+INC ; q3_B=q3_B>>1 ;
 end

endmodule

