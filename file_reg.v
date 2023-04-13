`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: Register File
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Array Registers Logics
//////////////////////////////////////////////////////////////////////////////////

module latch_32bit(
    input wire clk, active,
    input wire [31:0] in0, in1, in2, in3,
    output reg [31:0] out0, out1, out2, out3
    );
    always @(posedge clk) begin 
        if (active) begin
            out0 <= in0;
            out1 <= in1;
            out2 <= in2;
            out3 <= in3;
        end
    end
    
endmodule

module reg_32bit(
    input wire clk, rst,
    input wire [31:0] in0,
    output reg [31:0] out0
    );
    always@(posedge clk) begin
        if (rst) begin
            out0 <= 32'h0000_0000;
        end else begin
            out0 <= in0;
        end
    end
endmodule

module reg4_32bit(
    input wire clk,
    input wire [31:0] in0, in1, in2, in3,
    output reg [31:0] out0, out1, out2, out3
    );
    always@(posedge clk) begin
        out0 <= in0;
        out1 <= in1;
        out2 <= in2;
        out3 <= in3;
    end
endmodule

module reg_16bit(
    input wire clk, rst,
    input wire [15:0] in0,
    output reg [15:0] out0
    );
    always@(posedge clk) begin
        if (rst) begin
            out0 <= 16'h0000;
        end else begin
            out0 <= in0;
        end
    end
endmodule

module reg_12bit(
    input wire clk, rst,
    input wire [11:0] in0,
    output reg [11:0] out0
    );
    always@(posedge clk) begin
        if (rst) begin
            out0 <= 12'h000;
        end else begin
            out0 <= in0;
        end
    end
endmodule

module reg_2bit(
    input wire clk, rst,
    input wire [1:0] in0,
    output reg [1:0] out0
    );
    always@(posedge clk) begin
        if (rst) begin
            out0 <= 2'b00;
        end else begin
            out0 <= in0;
        end
    end
endmodule


module couunter_10(
    input wire clk, rst,
    output reg [3:0] Q
    );
    always @(posedge clk) begin 
        if (rst) begin
            Q <= 4'b0;
        end else begin
            if (Q == 4'd9) begin
                Q <= Q;
            end else begin 
                Q <= Q + 1'b1;
            end
        end
    end
 endmodule 
