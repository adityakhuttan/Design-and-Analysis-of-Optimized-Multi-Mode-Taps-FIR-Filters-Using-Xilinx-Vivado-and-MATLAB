`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 04:13:27
// Design Name: 
// Module Name: fir_8tap_lowpower
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


module fir_8tap_all_lowpower (

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
reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0;
        x4<=0; x5<=0; x6<=0; x7<=0;
    end
    else if (ce) begin
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
// COEFFICIENTS (same as original, no change)
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3;

always @(*) begin
    case(mode)

    // ================= LPF =================
    2'b00: begin
        h0 = -2; h1 = 0; h2 = 35; h3 = 95;
    end

    // ================= HPF =================
    2'b01: begin
        h0 = 2; h1 = 3; h2 = -13; h3 = -67;
    end

    // ================= BPF =================
    2'b10: begin
        h0 = -1; h1 = -25; h2 = -26; h3 = 117;
    end

    // ================= BSF =================
    2'b11: begin
        h0 = -2; h1 = 0; h2 = 46; h3 = 168;
    end

    default: begin
        h0 = 0; h1 = 0; h2 = 0; h3 = 0;
    end

    endcase
end

//////////////////////////////////////////////////
// SYMMETRIC REDUCTION (8 → 4 multipliers)
//////////////////////////////////////////////////

wire signed [16:0] s0 = x0 + x7;
wire signed [16:0] s1 = x1 + x6;
wire signed [16:0] s2 = x2 + x5;
wire signed [16:0] s3 = x3 + x4;

//////////////////////////////////////////////////
// MULTIPLIER STAGE (REDUCED)
//////////////////////////////////////////////////

wire signed [31:0] m0 = s0 * h0;
wire signed [31:0] m1 = s1 * h1;
wire signed [31:0] m2 = s2 * h2;
wire signed [31:0] m3 = s3 * h3;

//////////////////////////////////////////////////
// BALANCED ADDER TREE (LOW GLITCH POWER)
//////////////////////////////////////////////////

wire signed [31:0] sum =
    (m0 + m1) +
    (m2 + m3);

//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst)
        y_out <= 0;
    else if (ce)
        y_out <= sum;
end

endmodule