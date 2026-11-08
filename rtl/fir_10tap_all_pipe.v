`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:36:40
// Design Name: 
// Module Name: fir_10tap_all_pipe
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

module fir_10tap_all_pipe (

    input clk,
    input rst,
    input ce,
    input [1:0] mode,
    input signed [15:0] x_in,

    output reg signed [31:0] y_out
);

///////////////////////////////////////////////////////////////
// DELAY LINE
///////////////////////////////////////////////////////////////

reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
        x5<=0; x6<=0; x7<=0; x8<=0; x9<=0;
    end

    else if(ce) begin

        x9 <= x8;
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

///////////////////////////////////////////////////////////////
// SYMMETRIC PRE-ADDITION
///////////////////////////////////////////////////////////////

wire signed [16:0] s1 = x1 + x8;
wire signed [16:0] s2 = x2 + x7;
wire signed [16:0] s3 = x3 + x6;
wire signed [16:0] s4 = x4 + x5;

///////////////////////////////////////////////////////////////
// COEFFICIENTS
///////////////////////////////////////////////////////////////

reg signed [15:0] h1,h2,h3,h4;

always @(*) begin

    case(mode)

    2'b00: begin
        h1=-2; h2=0;  h3=20;  h4=47;
    end

    2'b01: begin
        h1=2;  h2=3;  h3=-8;  h4=-35;
    end

    2'b10: begin
        h1=-1; h2=-19; h3=-13; h4=50;
    end

    2'b11: begin
        h1=-1; h2=-8; h3=21; h4=13;
    end

    default: begin
        h1=0; h2=0; h3=0; h4=0;
    end

    endcase
end

///////////////////////////////////////////////////////////////
// OPERAND ISOLATION
///////////////////////////////////////////////////////////////

wire signed [16:0] op1 = (h1==0)?0:s1;
wire signed [16:0] op2 = (h2==0)?0:s2;
wire signed [16:0] op3 = (h3==0)?0:s3;
wire signed [16:0] op4 = (h4==0)?0:s4;

///////////////////////////////////////////////////////////////
// 4 DSP MULTIPLIERS
///////////////////////////////////////////////////////////////

(* use_dsp = "yes" *) wire signed [33:0] m1 = op1 * h1;
(* use_dsp = "yes" *) wire signed [33:0] m2 = op2 * h2;
(* use_dsp = "yes" *) wire signed [33:0] m3 = op3 * h3;
(* use_dsp = "yes" *) wire signed [33:0] m4 = op4 * h4;

///////////////////////////////////////////////////////////////
// ADDER TREE
///////////////////////////////////////////////////////////////

wire signed [35:0] sum =
      m1 + m2 + m3 + m4;

///////////////////////////////////////////////////////////////
// OUTPUT REGISTER
///////////////////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst)
        y_out <= 0;

    else if(ce)
        y_out <= sum[31:0];

end

endmodule