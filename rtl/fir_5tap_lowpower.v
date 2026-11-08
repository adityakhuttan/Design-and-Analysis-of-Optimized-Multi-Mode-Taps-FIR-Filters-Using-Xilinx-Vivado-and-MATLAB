`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 14:02:47
// Design Name: 
// Module Name: fir_5tap_lowpower
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


module fir_5tap_lowpower (
    input clk,
    input rst,
    input ce,
    input [1:0] mode,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (CE CONTROLLED)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
    end
    else if (ce) begin
        x4 <= x3;
        x3 <= x2;
        x2 <= x1;
        x1 <= x0;
        x0 <= x_in;
    end
end

//////////////////////////////////////////////////
// SYMMETRY REDUCTION (CRITICAL POWER SAVE)
//////////////////////////////////////////////////
wire signed [16:0] s0 = x0 + x4;
wire signed [16:0] s1 = x1 + x3;
wire signed [15:0] s2 = x2;

//////////////////////////////////////////////////
// COEFFICIENTS (UNCHANGED)
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2;

always @(*) begin
    case(mode)
    2'b00: begin h0=3;   h1=56;  h2=138; end
    2'b01: begin h0=-2;  h1=-46; h2=168; end
    2'b10: begin h0=-11; h1=34;  h2=218; end
    2'b11: begin h0=10;  h1=-31; h2=299; end
    endcase
end

//////////////////////////////////////////////////
// DSP MULTIPLIERS (NO SHIFT-ADD)
//////////////////////////////////////////////////
wire signed [31:0] m0 = s0 * h0;
wire signed [31:0] m1 = s1 * h1;
wire signed [31:0] m2 = s2 * h2;

//////////////////////////////////////////////////
// PIPELINED ADDER (GLITCH REDUCTION)
//////////////////////////////////////////////////
wire signed [31:0] sum = m0 + m1 + m2;

reg signed [31:0] sum_reg;

always @(posedge clk or posedge rst) begin
    if (rst)
        sum_reg <= 0;
    else if (ce)
        sum_reg <= sum;
end

//////////////////////////////////////////////////
// OUTPUT REGISTER (CE CONTROLLED)
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst)
        y_out <= 0;
    else if (ce)
        y_out <= sum_reg;
end

endmodule