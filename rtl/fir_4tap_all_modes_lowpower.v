`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 22:14:43
// Design Name: 
// Module Name: fir_4tap_all_modes_lowpower
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


module fir_4tap_all_modes_lowpower (
    input clk,
    input rst,
    input ce,                      // 🔥 Clock Enable (LOW POWER)
    input [1:0] mode,
    input signed [15:0] x_in,
    output reg signed [31:0] y_out
);

//////////////////////////////////////////////////
// SHIFT REGISTER (CE CONTROLLED)
//////////////////////////////////////////////////
reg signed [15:0] x0, x1, x2, x3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        x0 <= 0; x1 <= 0; x2 <= 0; x3 <= 0;
    end
    else if (ce) begin
        x3 <= x2;
        x2 <= x1;
        x1 <= x0;
        x0 <= x_in;
    end
end

//////////////////////////////////////////////////
// SYMMETRIC INPUT PRE-ADD (POWER REDUCTION)
//////////////////////////////////////////////////
wire signed [16:0] s0 = x0 + x3;
wire signed [16:0] s1 = x1 + x2;

//////////////////////////////////////////////////
// COEFFICIENTS (UNCHANGED - SYMMETRIC PAIRS)
//////////////////////////////////////////////////
reg signed [15:0] h0, h1;

always @(*) begin
    case(mode)

    // ================= LPF =================
    2'b00: begin
        h0 = 16'sd7;
        h1 = 16'sd121;
    end

    // ================= HPF =================
    2'b01: begin
        h0 = -16'sd46;
        h1 = 16'sd168;
    end

    // ================= BPF =================
    2'b10: begin
        h0 = -16'sd128;
        h1 = 16'sd128;
    end

    // ================= BSF =================
    2'b11: begin
        h0 = 16'sd10;
        h1 = 16'sd237;
    end

    default: begin
        h0 = 0;
        h1 = 0;
    end

    endcase
end

//////////////////////////////////////////////////
// LOW POWER MULTIPLIERS (OPERAND ISOLATION)
//////////////////////////////////////////////////
wire signed [31:0] m0 = ce ? (s0 * h0) : 0;
wire signed [31:0] m1 = ce ? (s1 * h1) : 0;

//////////////////////////////////////////////////
// PARTIAL ACCUMULATION (REDUCED SWITCHING)
//////////////////////////////////////////////////
wire signed [31:0] sum = m0 + m1;

//////////////////////////////////////////////////
// OUTPUT REGISTER (CE CONTROLLED)
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst)
        y_out <= 0;
    else if (ce)
        y_out <= sum;
end

endmodule