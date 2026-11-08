`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 03:51:06
// Design Name: 
// Module Name: fir_7tap_ultra_lowpower
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fir_7tap_ultra_lowpower (

    input  wire clk,
    input  wire rst,
    input  wire ce,
    input  wire [1:0] mode,
    input  wire signed [15:0] x_in,

    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (CE CONTROLLED)
//////////////////////////////////////////////////

reg signed [15:0] x0,x1,x2,x3,x4,x5,x6;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0; x5<=0; x6<=0;
    end
    else if(ce) begin
        x6 <= x5;
        x5 <= x4;
        x4 <= x3;
        x3 <= x2;
        x2 <= x1;
        x1 <= x0;
        x0 <= x_in;
    end
end

//////////////////////////////////////////////////
// SYMMETRIC REDUCTION (7 → 4 MULTS)
//////////////////////////////////////////////////

wire signed [16:0] s0 = x0 + x6;
wire signed [16:0] s1 = x1 + x5;
wire signed [16:0] s2 = x2 + x4;
wire signed [15:0] s3 = x3;   // center tap

//////////////////////////////////////////////////
// COEFFICIENTS
//////////////////////////////////////////////////

reg signed [15:0] h0,h1,h2,h3;

always @(*) begin
    case(mode)

    2'b00: begin // LPF
        h0 = 7;   h1 = 16;  h2 = 30;  h3 = 50;
    end

    2'b01: begin // HPF
        h0 = 2;   h1 = -10; h2 = -40; h3 = 80;
    end

    2'b10: begin // BPF
        h0 = -5;  h1 = -20; h2 = 40;  h3 = 60;
    end

    2'b11: begin // BSF
        h0 = 3;   h1 = 15;  h2 = -25; h3 = 100;
    end

    default: begin
        h0=0; h1=0; h2=0; h3=0;
    end

    endcase
end

//////////////////////////////////////////////////
// MULTIPLIERS (DSP ENABLED)
//////////////////////////////////////////////////

wire signed [31:0] m0 = s0 * h0;
wire signed [31:0] m1 = s1 * h1;
wire signed [31:0] m2 = s2 * h2;
wire signed [31:0] m3 = s3 * h3;

//////////////////////////////////////////////////
// PIPELINED ADDER TREE
//////////////////////////////////////////////////

reg signed [31:0] a1,a2;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        a1 <= 0;
        a2 <= 0;
    end
    else if(ce) begin
        a1 <= m0 + m1;
        a2 <= m2 + m3;
    end
end

wire signed [31:0] sum = a1 + a2;

//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin
    if(rst)
        y_out <= 0;
    else if(ce)
        y_out <= sum;
end

endmodule