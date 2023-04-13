`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Pusat Mikroelektronika ITB
// Engineer: Zulfikar N. Arifuzzaki
// 
// Module Name: CU
// Project Name: Optimized Intelligent Traffic Light
// Target Devices: Board PYNQ-Z1
// Description: Control Unit
//////////////////////////////////////////////////////////////////////////////////

module CU(
    input wire clk, rst, start,
    // From Processing System 
    input wire [15:0] max_step,
    input wire [15:0] max_episode,
    input wire [15:0] seed,
    // Output for Policy Generator 
    output reg Asel,
    output reg [1:0] Arand,
    output reg [11:0] S0,
    // Control Signal
    output wire PG,
    output wire QA,
    output wire SD,
    output wire RD,
        // for debugging 
    output wire [15:0] wire_sc,
    output wire [15:0] wire_ec,
    output wire [4:0] wire_cs,
    output wire [4:0] wire_ns,
    output wire [15:0] wire_epsilon,
    output reg finish,
    output reg wen,
    output reg idle,
    input wire active
    );
    
    // State variable for FSM implementation 
    localparam
        // Preprocessing states
        S_IDLE  = 5'd15,
        S_INIT  = 5'd16,
        // Learning states
        S_L0    = 5'd0,
        S_L1    = 5'd1,
        S_L2    = 5'd2,
        S_L3    = 5'd3,
        S_L4    = 5'd4,
        S_L5    = 5'd5,
        S_L6    = 5'd6,
        S_L7    = 5'd7,
        S_L8    = 5'd8,
        S_L9    = 5'd9,
        S_L10    = 5'd10,
        S_L11    = 5'd11,
        S_L12    = 5'd12,
        S_L13    = 5'd13,
        S_L14    = 5'd14,
        S_DONE   = 5'd17;
        
    // Counter variabel 
    reg [15:0] sc; // step counter
    reg [15:0] ec; // episode counter
    reg [4:0] ns;
    reg [4:0] cs;
    reg [15:0] epsilon;
    // Variables for generating random number 
    reg  [15:0] i_lsfr;
    wire [15:0] o_lsfr;
    lsfr_16bit rand(.in0(i_lsfr), .out0(o_lsfr));
        
    // LSFR Configuration 
    always@(posedge clk) begin
        case(cs)
            S_IDLE:
                i_lsfr <= seed;
            default:
                i_lsfr <= o_lsfr;
        endcase
    end
    
    // Reset handler
    always@(posedge clk) begin 
        if(rst) begin 
            cs <= S_IDLE;
        end else begin
            cs <= ns;
        end
    end
    
    always @(posedge clk) begin 
        if (cs == S_IDLE) begin
            idle = 1'b1;
        end else begin
            idle = 1'b0;
        end
    end
    
    // FSM State Controller
    always@(*) begin
        case (cs)
            S_IDLE :
                if ((start)&(!active)) begin
                    ns <= S_INIT;
                end else if ((!start)&(active)) begin
                    ns <= S_L0;
                end else begin
                    ns <= S_IDLE;
                end
            S_INIT :
                if (ec < max_episode)
                    ns <= S_L0;
                else
                    ns <= S_DONE;
            S_L0 : 
                ns <= S_L1;
            S_L1 :
                ns <= S_L2;
            S_L2 :
                ns <= S_L3;
            S_L3 :
                ns <= S_L4;
            S_L4 :
                ns <= S_L5;
            S_L5 :
                ns <= S_L6;
            S_L6 :
                ns <= S_L7;
            S_L7 :
                ns <= S_L8;
            S_L8 :
                if(sc > max_step)
                    ns <= S_L9;
                else 
                    ns <= S_L8;
            S_L9 :
                ns <= S_L10;
            S_L10 :
                ns <= S_L11;
            S_L11 :
                ns <= S_L12;
            S_L12 :
                ns <= S_L13;
            S_L13 :
                ns <= S_L14;
            S_L14 :
                if ((start)&(!active))
                    ns <= S_INIT;
                else 
                    ns <= S_DONE;
            S_DONE :
                if ((start)|(active))
                    ns <= S_DONE;
                else 
                    ns <= S_IDLE;
            default
                ns <= S_IDLE;
         endcase
    end
    
    // Step Counter Machine 
    always@(posedge clk) begin
        if ((cs == S_INIT)|(cs == S_L0)) begin
            sc = 16'd0;
        end else if(cs == S_L8) begin
            sc = sc + 1'b1;
        end else begin
            sc = sc;
        end
    end
    
    // Memory Handling 
    always @(*) begin
        if ((ns == S_L13)|(ns == S_L14)|(ns == S_L8)|(ns == S_L9)|(ns == S_L10)|(ns == S_L11)|(ns == S_L12)) begin 
            wen = 1'b1;
        end else begin 
            wen = 1'b0;
        end
    end
    
    // Episode Counter Machine 
    always @(posedge clk) begin
        if(cs == S_IDLE) begin
            ec = 16'd0;
        end else if (cs == S_L14) begin
            ec = ec + 16'd1;
        end else begin
            ec = ec;
        end
    end
    
    // Epsilon updating machine
    always @(posedge clk) begin
        if (cs == S_IDLE) begin 
            epsilon = 16'd0;
        end else if (cs == S_L14) begin
            epsilon = max_episode - ec;
        end else begin
            epsilon = epsilon;
        end
    end
    
    // Control signal generator
    reg [3:0] ctrl_sig;
    always @(*) begin
        // Format Control Signal : |SD|PG|RD|QA| 
        case(cs)
            S_L0 :
                ctrl_sig = 4'b1000;
            S_L1 :
                ctrl_sig = 4'b1000;
            S_L2 :
                ctrl_sig = 4'b1100;
            S_L3 :
                ctrl_sig = 4'b1100;
            S_L4 :
                ctrl_sig = 4'b1110;
            S_L5 :
                ctrl_sig = 4'b1110;
            S_L6 :
                ctrl_sig = 4'b1111;
            S_L7 :
                ctrl_sig = 4'b0111;
            S_L8 :
                ctrl_sig = 4'b0111;
            S_L9 :
                ctrl_sig = 4'b0011;
            S_L10 :
                ctrl_sig = 4'b0011;
            S_L11 :
                ctrl_sig = 4'b0001;
            S_L12 :
                ctrl_sig = 4'b0001;
            default
                ctrl_sig = 4'b0000;       
        endcase
    end
    
    // Finish signal generator 
    always @(posedge clk) begin
        if (ns==S_DONE) begin
            finish = 1'b1;
        end else begin
            finish = 1'b0;
        end
    end
    
    // Random numbers for Policy Generator 
    always @(posedge clk) begin
        Asel <= (epsilon > o_lsfr[15:0])? 1'b0 : 1'b1;
        Arand <= o_lsfr[1:0];
        S0 <= o_lsfr[12:1];
    end
  
    
    // Control signal decoder
    assign SD = ctrl_sig[3];
    assign PG = ctrl_sig[2];
    assign RD = ctrl_sig[1];
    assign QA = ctrl_sig[0];
    
    assign wire_cs = cs;
    assign wire_ec = ec;
    assign wire_sc = sc;  
    assign wire_ns = ns;
    assign wire_epsilon = epsilon;  
endmodule

