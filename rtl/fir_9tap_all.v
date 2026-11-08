`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:14:50
// Design Name: 
// Module Name: fir_9tap_all
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


module fir_9tap_all (
    input clk,
    input rst,
    input [1:0] mode,
    input signed [15:0] x_in,

    output reg signed [31:0] y_out

);

//////////////////////////////////////////////////
// Delay Line (UNOPTIMIZED)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7,x8;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
        x5<=0; x6<=0; x7<=0; x8<=0;
    end
    else
    begin
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
// Coefficients
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8;

always @(*)
begin
    case(mode)

    //////////////////////////////////////////////////
    // LPF
    //////////////////////////////////////////////////
    2'b00:
    begin
        h0=-2;  h1=-3;  h2=13;  h3=68;
        h4=104; h5=68;  h6=13;  h7=-3;
        h8=-2;
    end

    //////////////////////////////////////////////////
    // HPF
    //////////////////////////////////////////////////
    2'b01:
    begin
        h0=2;   h1=3;   h2=-13; h3=-67;
        h4=152; h5=-67; h6=-13; h7=3;
        h8=2;
    end

    //////////////////////////////////////////////////
    // BPF
    //////////////////////////////////////////////////
    2'b10:
    begin
        h0=1;   h1=-12; h2=-46; h3=35;
        h4=140; h5=35;  h6=-46; h7=-12;
        h8=1;
    end

    //////////////////////////////////////////////////
    // BSF
    //////////////////////////////////////////////////
    2'b11:
    begin
        h0=-1;  h1=12;  h2=46;  h3=-35;
        h4=210; h5=-35; h6=46;  h7=12;
        h8=-1;
    end

    default:
    begin
        h0=0; h1=0; h2=0; h3=0;
        h4=0; h5=0; h6=0; h7=0; h8=0;
    end

    endcase
end

//////////////////////////////////////////////////
// MULTIPLIERS
//////////////////////////////////////////////////

// SMALL COEFF -> LUT
wire signed [31:0] m0 = x0*h0;
wire signed [31:0] m1 = x1*h1;
wire signed [31:0] m7 = x7*h7;
wire signed [31:0] m8 = x8*h8;

// LARGE COEFF -> DSP
(* use_dsp = "yes" *) wire signed [31:0] m2 = x2*h2;
(* use_dsp = "yes" *) wire signed [31:0] m3 = x3*h3;
(* use_dsp = "yes" *) wire signed [31:0] m4 = x4*h4;
(* use_dsp = "yes" *) wire signed [31:0] m5 = x5*h5;
(* use_dsp = "yes" *) wire signed [31:0] m6 = x6*h6;

//////////////////////////////////////////////////
// DIRECT ADDER TREE
//////////////////////////////////////////////////
wire signed [31:0] sum =
      m0 + m1 + m2 + m3 + m4
    + m5 + m6 + m7 + m8;

//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin
    if (rst)
        y_out <= 0;
    else
        y_out <= sum;
end

endmodule