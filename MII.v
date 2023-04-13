`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: MII
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Interfacing Input Data for Memory
//////////////////////////////////////////////////////////////////////////////////

module MII(
    input wire clk, rst, 
//    input wire READ_EN, WRITE_EN,
    // For state-address converter
    input wire [11:0] S,
    input wire wen, 
    output wire [31:0] RD_ADDR,
    output reg [31:0] WR_ADDR,
    // Write enable handling 
    input wire [1:0] A,
    output reg [3:0] wen0, wen1, wen2, wen3,
    output reg en0, en1, en2, en3
    );
    
    // State-Address Converter
    reg [11:0] S_reg0, S_reg1, S_reg2, S_reg3, S_reg4, S_reg5, S_reg6, S_reg7;
    always @(posedge clk) begin
        S_reg0 <= S;
        S_reg1 <= S_reg0;
        S_reg2 <= S_reg1;
        S_reg3 <= S_reg2;
        S_reg4 <= S_reg3;
        S_reg5 <= S_reg4;
        S_reg6 <= S_reg5;
        S_reg7 <= S_reg6;
    end
    wire [31:0] WR_ADDR_temp;
    assign RD_ADDR = (S<<2)|32'h0000_0000;
    assign WR_ADDR_temp = (S_reg6<<2)|32'h0000_0000;
    
    // Action register
    reg [1:0] A_reg0, A_reg1, A_reg2, A_reg3, A_reg4, A_reg5;
    always @(posedge clk) begin 
        A_reg0 <= A;
        A_reg1 <= A_reg0;
        A_reg2 <= A_reg1;
        A_reg3 <= A_reg2;
        A_reg4 <= A_reg3;
        A_reg5 <= A_reg4;
    end
    
    // RAM Write Enable handling
    wire [3:0] wen0_temp, wen1_temp, wen2_temp, wen3_temp;
    wire en0_temp, en1_temp, en2_temp, en3_temp;
    always @(posedge clk) begin
        en0 <= en0_temp;
        en1 <= en1_temp;
        en2 <= en2_temp;
        en3 <= en3_temp;
        wen0 <= wen0_temp;
        wen1 <= wen1_temp;
        wen2 <= wen2_temp;
        wen3 <= wen3_temp;     
        WR_ADDR <= WR_ADDR_temp;   
    end
    wen_decoder decod0(.A(A_reg4), .en(wen), .wen0(wen0_temp), .wen1(wen1_temp), .wen2(wen2_temp), .wen3(wen3_temp));
    en_decoder  decod1(.A(A_reg4), .en(wen), .en0(en0_temp), .en1(en1_temp), .en2(en2_temp), .en3(en3_temp));
    
endmodule

module wen_decoder(
    input wire en,
    input wire  [1:0] A,
    output wire [3:0] wen0, wen1, wen2, wen3
    );
    assign wen0 = ((A==0)&(en))? 4'b1111 : 4'b0000;
    assign wen1 = ((A==1)&(en))? 4'b1111 : 4'b0000;
    assign wen2 = ((A==2)&(en))? 4'b1111 : 4'b0000;
    assign wen3 = ((A==3)&(en))? 4'b1111 : 4'b0000;
endmodule

module en_decoder(
    input wire en,
    input wire  [1:0] A,
    output wire en0, en1, en2, en3
    );
    assign en0 = (A==0)&(en);
    assign en1 = (A==1)&(en);
    assign en2 = (A==2)&(en);
    assign en3 = (A==3)&(en);
endmodule
