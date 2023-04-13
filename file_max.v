`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: MAX File
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Maximum Selector Logics
//////////////////////////////////////////////////////////////////////////////////

//module max4to1_2bit(
//    input wire [1:0] in0, in1, in2, in3,
//    output wire [1:0] out0
//    );
//    wire [1:0] w0, w1;
//    assign w0   = (in0>in1) ? in0 : in1;
//    assign w1   = (in2>in3) ? in2 : in3;
//    assign out0 = (w1>w0)   ?  w1 : w0;
//endmodule

module max4to1_3bit(
    input wire [2:0] in0, in1, in2, in3,
    output wire [2:0] out0
    );
    wire [2:0] w0, w1;
    assign w0   = (in0>in1) ? in0 : in1;
    assign w1   = (in2>in3) ? in2 : in3;
    assign out0 = (w1>w0)   ?  w1 : w0;
endmodule

//module max4to1_4bit(
//    input wire [3:0] in0, in1, in2, in3,
//    output wire [3:0] out0
//    );
//    wire [3:0] w0, w1;
//    assign w0   = (in0>in1) ? in0 : in1;
//    assign w1   = (in2>in3) ? in2 : in3;
//    assign out0 = (w1>w0)   ?  w1 : w0;
//endmodule

//module min4to1_2bit(
//    input wire [1:0] in0, in1, in2, in3,
//    output wire [1:0] out0
//    );
//    wire [1:0] w0, w1;
//    assign w0   = (in0<in1) ? in0 : in1;
//    assign w1   = (in2<in3) ? in2 : in3;
//    assign out0 = (w1<w0)   ?  w1 : w0;
//endmodule

module min4to1_3bit(
    input wire [2:0] in0, in1, in2, in3,
    output wire [2:0] out0
    );
    wire [2:0] w0, w1;
    assign w0   = (in0<in1) ? in0 : in1;
    assign w1   = (in2<in3) ? in2 : in3;
    assign out0 = (w1<w0)   ?  w1 : w0;
endmodule

//module min4to1_4bit(
//    input wire [3:0] in0, in1, in2, in3,
//    output wire [3:0] out0
//    );
//    wire [3:0] w0, w1;
//    assign w0   = (in0<in1) ? in0 : in1;
//    assign w1   = (in2<in3) ? in2 : in3;
//    assign out0 = (w1<w0)   ?  w1 : w0;
//endmodule

//module min2to1_2bit(
//    input [1:0] in0, in1,
//    output [1:0] out0
//    );
//    assign out0 = (in0<in1) ? in0 : in1;
//endmodule

module max2to1_32bit(
    input wire signed [31:0] in0, in1,
    output wire signed [31:0] out0
    );
    assign out0 = (in0 > in1)? in0 : in1;
endmodule

module min2to1_32bit(
    input wire signed [31:0] in0, in1,
    output wire signed [31:0] out0
    );
    assign out0 = (in0 < in1)? in0 : in1;
endmodule

module max4to1_32bit(
    input wire signed [31:0] in0, in1, in2, in3,
    output wire signed [31:0] out0
    );
    wire [31:0] w0, w1;
    assign w0 = (in0 > in1)? in0 : in1;
    assign w1 = (in2 > in3)? in2 : in3;
    assign out0 = (w0 > w1)? w0 : w1;
endmodule

module min4to1_32bit(
    input wire signed [31:0] in0, in1, in2, in3,
    output wire signed [31:0] out0
    );
    wire [31:0] w0, w1;
    assign w0 = (in0 < in1)? in0 : in1;
    assign w1 = (in2 < in3)? in2 : in3;
    assign out0 = (w0 < w1)? w0 : w1;
endmodule

//module comp_2bit(
//    input [1:0] in0, in1,
//    output [1:0] out0, out1
//    );
//    assign out0 = (in0<in1) ? in0 : in1; // nilai rendah
//    assign out1 = (in0<in1) ? in1 : in0; // nilai tinggi
//endmodule





