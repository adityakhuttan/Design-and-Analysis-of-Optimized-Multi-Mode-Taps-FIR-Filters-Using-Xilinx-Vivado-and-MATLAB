`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2026 19:31:43
// Design Name: 
// Module Name: fir_6tap_lowpower
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


module fir_6tap_lowpower(
    input clk,
    input rst,
    input enable,          // Enable for power saving
    input [1:0] mode,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out

);

// Shift registers
reg signed [15:0] x0,x1,x2,x3,x4,x5;

// Symmetric coefficients (only 3 needed)
reg signed [15:0] h0,h1,h2;

// Pre-adders (to reduce multipliers)
reg signed [16:0] s0,s1,s2;

// Select filter coefficients
always @(*) begin
    case(mode)

        2'b00: begin // LPF
            h0=0;   h1=97;  h2=414;
        end

        2'b01: begin // HPF
            h0=5;   h1=-30; h2=-239;
        end

        2'b10: begin // BPF
            h0=-29; h1=-192; h2=504;
        end

        2'b11: begin // BSF
            h0=0;   h1=122; h2=0;
        end

    endcase
end

// Shift register with enable (reduces switching)
always @(posedge clk or posedge rst) begin
    if(rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0; x5<=0;
    end 
    else if(enable) begin
        x5<=x4;
        x4<=x3;
        x3<=x2;
        x2<=x1;
        x1<=x0;
        x0<=x_in;
    end
end

// Pre-adders (reduce multipliers)
always @(*) begin
    s0 = x0 + x5;
    s1 = x1 + x4;
    s2 = x2 + x3;
end

// Output computation (only 3 multipliers now)
always @(posedge clk or posedge rst) begin
    if(rst)
        y_out <= 0;
    else if(enable)
        y_out <= s0*h0 + s1*h1 + s2*h2;
end

endmodule