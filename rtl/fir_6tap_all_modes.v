`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 22:32:02
// Design Name: 
// Module Name: fir_6tap_all_modes
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

module fir_6tap_all_modes (
    input clk,
    input rst,
    input [1:0] mode,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (UNOPTIMIZED)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4,x5;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0; x5<=0;
    end
    else
    begin
        x5 <= x4;
        x4 <= x3;
        x3 <= x2;
        x2 <= x1;
        x1 <= x0;
        x0 <= x_in;
    end
end

//////////////////////////////////////////////////
// COEFFICIENTS (UNCHANGED)
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3,h4,h5;

always @(*) begin
    case(mode)

    // LPF
    2'b00: begin
        h0=0;   h1=97;  h2=414; h3=414; h4=97;  h5=0;
    end

    // HPF
    2'b01: begin
        h0=5;   h1=-30; h2=-239; h3=616; h4=-239; h5=-30;
    end

    // BPF
    2'b10: begin
        h0=-29; h1=-192; h2=504; h3=504; h4=-192; h5=-29;
    end

    // BSF
    2'b11: begin
        h0=0;   h1=122; h2=0;   h3=780; h4=0;   h5=122;
    end

    default: begin
        h0=0; h1=0; h2=0; h3=0; h4=0; h5=0;
    end
    endcase
end

//////////////////////////////////////////////////
// FULL PARALLEL MAC (UNOPTIMIZED CORE)
//////////////////////////////////////////////////
wire signed [31:0] m0 = x0*h0;
wire signed [31:0] m1 = x1*h1;
wire signed [31:0] m2 = x2*h2;
wire signed [31:0] m3 = x3*h3;
wire signed [31:0] m4 = x4*h4;
wire signed [31:0] m5 = x5*h5;

wire signed [31:0] sum =
    m0 + m1 + m2 + m3 + m4 + m5;

//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin
    if(rst)
        y_out <= 0;
    else
        y_out <= sum;
end

endmodule