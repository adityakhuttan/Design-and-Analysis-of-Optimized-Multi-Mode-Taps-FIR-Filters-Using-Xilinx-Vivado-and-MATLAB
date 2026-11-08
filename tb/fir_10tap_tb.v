`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2026 17:25:48
// Design Name: 
// Module Name: fir_10tap_tb
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




module fir_10tap_tb;

reg clk;
reg rst;
reg enable;
reg [1:0] mode;
reg signed [15:0] x_in;

wire signed [31:0] y_out;

//////////////////////////////////////
// Instantiate DUT
//////////////////////////////////////
fir_10tap dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

//////////////////////////////////////
// Clock (100 MHz)
//////////////////////////////////////
always #5 clk = ~clk;

//////////////////////////////////////
// Stimulus
//////////////////////////////////////
initial begin
    clk = 0;
    rst = 1;
    enable = 0;
    x_in = 0;
    mode = 2'b00;

    #20;
    rst = 0;
    enable = 1;

    //////////////////////////////////////
    // Test LPF
    //////////////////////////////////////
    mode = 2'b00;
    repeat(20) begin
        #10 x_in = $random % 1000;
    end

    //////////////////////////////////////
    // Test HPF
    //////////////////////////////////////
    mode = 2'b01;
    repeat(20) begin
        #10 x_in = $random % 1000;
    end

    //////////////////////////////////////
    // Test BPF
    //////////////////////////////////////
    mode = 2'b10;
    repeat(20) begin
        #10 x_in = $random % 1000;
    end

    //////////////////////////////////////
    // Test BSF
    //////////////////////////////////////
    mode = 2'b11;
    repeat(20) begin
        #10 x_in = $random % 1000;
    end

    #100;
    $stop;

end

endmodule
