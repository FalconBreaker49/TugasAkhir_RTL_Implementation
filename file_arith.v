`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Basic Arithmatic Logics
// Implementing the faster multiplication algorithm for computing the Bellman-Equation
//////////////////////////////////////////////////////////////////////////////////

module multiply(
    input wire [31:0] in0,
    input wire [2:0] c,
    output wire [31:0] out0
    );
    
    wire [1:0] i, j, k; 
    assign i = (c[2])? 2'd1 : 2'd0; // if i==1, then times by 0.5
    assign j = (c[1])? 2'd2 : 2'd0; // if j==1, then times by 0.25 
    assign k = (c[0])? 2'd3 : 2'd0; // if k==1, then times by 0.125
    
    wire [31:0] w0, w1, w2, w3, w4;
    r_shift s0(.in0(in0),   .step(i),   .out0(w0));
    r_shift s1(.in0(in0),   .step(j),   .out0(w1));
    r_shift s3(.in0(in0),   .step(k),   .out0(w2));
    assign w3 = w0 + w1;
    assign w4 = w2 + w3;
    
    assign out0 = w4;
endmodule

module r_shift(

    input wire [31:0] in0,
    input wire [1:0] step,
    output wire [31:0] out0
    );
    assign out0 =
        (step == 2'd0)                      ? 32'd0 :
        (step == 2'd1) && (in0[31] == 1'b1) ? (in0 >> step)|32'h8000_0000 :
        (step == 2'd2) && (in0[31] == 1'b1) ? (in0 >> step)|32'hc000_0000 :
        (step == 2'd3) && (in0[31] == 1'b1) ? (in0 >> step)|32'he000_0000 :
        (in0 >> step) ;
endmodule

module lsfr_16bit(
    input wire  [15:0] in0,
    output wire [15:0] out0
    );
    wire w0;
    
    assign w0 = in0[15] ^ in0[13] ^ in0[12] ^ in0[10];
    assign out0 = {in0[14:0],w0};
endmodule

module lsfr_12bit(
    input wire  [11:0] in0,
    output wire [11:0] out0
    );
    wire w0;
    
    assign w0 = in0[11] ^ in0[10] ^ in0[9] ^ in0[3];
    assign out0 = {in0[10:0],w0};
endmodule

module lsfr_32bit(
    input wire  [31:0] in0,
    output wire [31:0] out0
    );
    wire w0, temp0;
    assign w0 = in0[31] ^~ in0[21] ^~ in0[1] ^~ in0[0];
    assign out0 = {in0[30:0],w0};
endmodule

//module encoder(
//    input wire en,
//    input  wire [6:0] in0,
//    output reg [2:0] out0
//    );
//    always@(in0) begin
//        if(en)begin
//            if (in0[6]) begin
//                out0 = 3'b111;
//            end else if (in0[5]) begin
//                out0 = 3'b110;
//            end else if (in0[4]) begin
//                out0 = 3'b101;
//            end else if (in0[3]) begin
//                out0 = 3'b100;
//            end else if (in0[2]) begin
//                out0 = 3'b011;
//            end else if (in0[1]) begin
//                out0 = 3'b010;
//            end else if (in0[0]) begin
//                out0 = 3'b001;
//            end else begin
//                out0 = 3'b000;
//            end
//         end else begin 
//            out0 = 3'b000;
//         end
//    end
//endmodule 
    
