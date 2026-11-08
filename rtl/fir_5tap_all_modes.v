`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 14:27:45
// Design Name: 
// Module Name: fir_5tap_all_modes
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
module fir_5tap_all_modes (
    input clk,
    input rst,
    input [1:0] mode,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (UNOPTIMIZED)
//////////////////////////////////////////////////
reg signed [15:0] x0,x1,x2,x3,x4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0<=0; x1<=0; x2<=0; x3<=0; x4<=0;
    end
    else begin
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
reg signed [15:0] h0,h1,h2,h3,h4;

always @(*) begin
    case(mode)

    // ================= LPF =================
    2'b00: begin
        h0 = 16'sd3;
        h1 = 16'sd56;
        h2 = 16'sd138;
        h3 = 16'sd56;
        h4 = 16'sd3;
    end

    // ================= HPF =================
    2'b01: begin
        h0 = -16'sd2;
        h1 = -16'sd46;
        h2 = 16'sd168;
        h3 = -16'sd46;
        h4 = -16'sd2;
    end

    // ================= BPF =================
    2'b10: begin
        h0 = -16'sd11;
        h1 = 16'sd34;
        h2 = 16'sd218;
        h3 = 16'sd34;
        h4 = -16'sd11;
    end

    // ================= BSF =================
    2'b11: begin
        h0 = 16'sd10;
        h1 = -16'sd31;
        h2 = 16'sd299;
        h3 = -16'sd31;
        h4 = 16'sd10;
    end

    default: begin
        h0=0; h1=0; h2=0; h3=0; h4=0;
    end

    endcase
end

//////////////////////////////////////////////////
// FULL PARALLEL MAC (PURE UNOPTIMIZED)
//////////////////////////////////////////////////
wire signed [31:0] m0 = x0 * h0;
wire signed [31:0] m1 = x1 * h1;
wire signed [31:0] m2 = x2 * h2;
wire signed [31:0] m3 = x3 * h3;
wire signed [31:0] m4 = x4 * h4;

wire signed [31:0] sum =
    m0 + m1 + m2 + m3 + m4;

//////////////////////////////////////////////////
// OUTPUT REGISTER
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst)
        y_out <= 0;
    else
        y_out <= sum;
end

endmodule