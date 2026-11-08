`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:19:24
// Design Name: 
// Module Name: fir_9tap_all_pipe
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

module fir_9tap_all_pipe (

    input clk,
    input rst,
    input ce,                 // clock enable
    input [1:0] mode,
    input signed [15:0] x_in,

    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// Delay Line (CE controlled)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7,x8;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
        x5<=0; x6<=0; x7<=0; x8<=0;
    end
    else if (ce) begin
        x8 <= x7;
        x7 <= x6;
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
// Coefficients (mode dependent)
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3,h4;

always @(*) begin
    case(mode)

    2'b00: begin // LPF
        h0 = -2; h1 = -3; h2 = 13; h3 = 68; h4 = 104;
    end

    2'b01: begin // HPF
        h0 = 2; h1 = 3; h2 = -13; h3 = -67; h4 = 152;
    end

    2'b10: begin // BPF
        h0 = 1; h1 = -12; h2 = -46; h3 = 35; h4 = 140;
    end

    2'b11: begin // BSF
        h0 = -1; h1 = 12; h2 = 46; h3 = -35; h4 = 210;
    end

    default: begin
        h0 = 0; h1 = 0; h2 = 0; h3 = 0; h4 = 0;
    end

    endcase
end

//////////////////////////////////////////////////
// Symmetric Reduction (9 taps → 5 multipliers)
//////////////////////////////////////////////////
wire signed [16:0] s0 = x0 + x8;
wire signed [16:0] s1 = x1 + x7;
wire signed [16:0] s2 = x2 + x6;
wire signed [16:0] s3 = x3 + x5;

//////////////////////////////////////////////////
// Multiplier Stage
//////////////////////////////////////////////////
wire signed [31:0] m0 = s0 * h0;
wire signed [31:0] m1 = s1 * h1;
wire signed [31:0] m2 = s2 * h2;
wire signed [31:0] m3 = s3 * h3;
wire signed [31:0] m4 = x4 * h4;

//////////////////////////////////////////////////
// Balanced Adder Tree
//////////////////////////////////////////////////
wire signed [31:0] sum =
    (m0 + m1) +
    (m2 + m3) +
    m4;

//////////////////////////////////////////////////
// Output Register
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst)
        y_out <= 0;
    else if (ce)
        y_out <= sum;
end

endmodule