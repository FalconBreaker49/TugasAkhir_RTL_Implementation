`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: Enablers
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Control the signal propagation
//////////////////////////////////////////////////////////////////////////////////

//module enabler_1bit(
//    input wire en, rst,
//    input wire in0,
//    output reg out0
//    );
//    always @(*) begin 
//        if(rst)begin
//            out0 <= 1'b0;
//        end else begin
//            if (en) begin
//                out0 <= in0;
//            end else begin
//                out0 <= out0;
//            end
//        end
//    end
//endmodule

module enabler_2bit(
    input wire en, rst,
    input wire [1:0] in0,
    output reg [1:0] out0
    );
    always @(*) begin 
        if(rst)begin
            out0 <= 2'b00;
        end else begin
            if (en) begin
                out0 <= in0;
            end else begin
                out0 <= out0;
            end
        end
    end
endmodule

//module enabler4_32bit(
//    input wire en,
//    input wire [31:0] in0, in1, in2, in3,
//    output reg [31:0] out0, out1, out2, out3
//    );
//    always @(*) begin
//        if (en) begin
//            out0 <= in0;
//            out1 <= in1;
//            out2 <= in2;
//            out3 <= in3;
//        end
//    end
//endmodule

module enabler_12bit(
    input wire en,
    input wire [11:0] in0,
    output wire [11:0] out0
    ); 
    assign out0 = en? in0 : 12'h000;
endmodule

module enabler_32bit(
    input wire en,
    input wire [31:0] in0,
    output wire [31:0] out0
    ); 
    assign out0 = en? in0 : 32'd0;
endmodule
