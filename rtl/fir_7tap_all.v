`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 03:42:51
// Design Name: 
// Module Name: fir_7tap_all
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

module fir_7tap_all (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  mode,
    input  wire signed [15:0] x_in,
    output reg  signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (UNOPTIMIZED)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4,x5,x6;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0; x5<=0; x6<=0;
    end
    else
    begin
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
// COEFFICIENTS (UNCHANGED)
//////////////////////////////////////////////////
reg signed [15:0] h0,h1,h2,h3,h4,h5,h6;

always @(*) begin
    case(mode)

    // ================= LPF =================
    2'b00: begin
        h0=-1;  h1=8;   h2=30;  h3=50;
        h4=30;  h5=8;   h6=-1;
    end

    // ================= HPF =================
    2'b01: begin
        h0=2;   h1=-10; h2=-40; h3=80;
        h4=-40; h5=-10; h6=2;
    end

    // ================= BPF =================
    2'b10: begin
        h0=-5;  h1=-20; h2=40;  h3=60;
        h4=40;  h5=-20; h6=-5;
    end

    // ================= BSF =================
    2'b11: begin
        h0=3;   h1=15;  h2=-25; h3=100;
        h4=-25; h5=15;  h6=3;
    end

    default: begin
        h0=0; h1=0; h2=0; h3=0; h4=0; h5=0; h6=0;
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
wire signed [31:0] m6 = x6*h6;

wire signed [31:0] sum =
    m0 + m1 + m2 + m3 + m4 + m5 + m6;

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