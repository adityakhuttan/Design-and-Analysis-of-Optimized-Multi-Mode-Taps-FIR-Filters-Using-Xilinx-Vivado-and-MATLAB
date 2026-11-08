`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:32:42
// Design Name: 
// Module Name: fir_10tap_all
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

module fir_10tap_all (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  mode,
    input  wire signed [15:0] x_in,
    output reg  signed [31:0] y_out
);
//////////////////////////////////////////////////
// DELAY LINE
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
        x5<=0; x6<=0; x7<=0; x8<=0; x9<=0;
    end
    else begin
        x9<=x8; x8<=x7; x7<=x6; x6<=x5;
        x5<=x4; x4<=x3; x3<=x2; x2<=x1;
        x1<=x0; x0<=x_in;
    end
end
//////////////////////////////////////////////////
// COEFFICIENTS
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3,h4,h5,h6,h7,h8,h9;
always @(*) begin
    case(mode)
    //-------- LPF --------//
    2'b00: begin
        h0 =  0;  h1 = -2;  h2 =  0;  h3 = 20;  h4 = 47;
        h5 = 47;  h6 = 20;  h7 =  0;  h8 = -2;  h9 =  0;
    end
    //-------- HPF --------//
    2'b01: begin
        h0 =  0;  h1 =  2;  h2 =  3;  h3 = -8;  h4 = -35;
        h5 = 77;  h6 =-35;  h7 = -8;  h8 =  3;  h9 =  2;
    end
    //-------- BPF --------//
    2'b10: begin
        h0 =  0;  h1 = -1;  h2 =-19;  h3 =-13;  h4 = 50;
        h5 = 50;  h6 =-13;  h7 =-19;  h8 = -1;  h9 =  0;
    end
    //-------- BSF --------//
    2'b11: begin
        h0 =  0;  h1 = -1;  h2 = -8;  h3 = 21;  h4 = 13;
        h5 = 76;  h6 = 13;  h7 = 21;  h8 = -8;  h9 = -1;
    end
    default: begin
        h0=0; h1=0; h2=0; h3=0; h4=0;
        h5=0; h6=0; h7=0; h8=0; h9=0;
    end
    endcase
end
//////////////////////////////////////////////////
// MAC — fully unoptimized, all 10 taps explicit
//////////////////////////////////////////////////
wire signed [31:0] m0 = x0 * h0;
wire signed [31:0] m1 = x1 * h1;
wire signed [31:0] m2 = x2 * h2;
wire signed [31:0] m3 = x3 * h3;
wire signed [31:0] m4 = x4 * h4;
wire signed [31:0] m5 = x5 * h5;
wire signed [31:0] m6 = x6 * h6;
wire signed [31:0] m7 = x7 * h7;
wire signed [31:0] m8 = x8 * h8;
wire signed [31:0] m9 = x9 * h9;
wire signed [31:0] sum = m0+m1+m2+m3+m4
                        +m5+m6+m7+m8+m9;
//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) y_out <= 32'sd0;
    else     y_out <= sum;
end
endmodule  

