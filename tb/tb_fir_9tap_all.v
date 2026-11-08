`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:15:18
// Design Name: 
// Module Name: tb_fir_9tap_all
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

module tb_fir_9tap_all;

reg clk = 0;
reg rst;
reg [1:0] mode;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

/////////////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////////////
fir_9tap_all uut (
    .clk(clk),
    .rst(rst),
    .x_in(x_in),
    .mode(mode),
    .y_out(y_out)
);

/////////////////////////////////////////////////////////
// CLOCK
/////////////////////////////////////////////////////////
always #5 clk = ~clk;

/////////////////////////////////////////////////////////
// MONITOR
/////////////////////////////////////////////////////////
always @(posedge clk)
    $display("t=%0t | mode=%b | x=%d | y=%d", $time, mode, x_in, y_out);

/////////////////////////////////////////////////////////
// MODE CONTROL (UNCHANGED STYLE)
/////////////////////////////////////////////////////////
initial begin
    mode = 2'b00;
    #200;

    mode = 2'b01;
    #200;

    mode = 2'b10;
    #200;

    mode = 2'b11;
end

/////////////////////////////////////////////////////////
// INPUT STIMULUS (UNCHANGED EXACT SEQUENCE)
/////////////////////////////////////////////////////////
initial begin
    rst = 1;
    x_in = 0;
    #20;
    rst = 0;

    x_in = 8'd0; #10;
    x_in = 8'd127; #10;
    x_in = 8'd29; #10;
    x_in = 8'd127; #10;
    x_in = -8'd75; #10;
    x_in = 8'd127; #10;
    x_in = 8'd127; #10;
    x_in = 8'd57; #10;
    x_in = 8'd121; #10;
    x_in = -8'd128; #10;

    x_in = 8'd0; #10;
    x_in = 8'd127; #10;
    x_in = -8'd121; #10;
    x_in = -8'd57; #10;
    x_in = -8'd128; #10;
    x_in = -8'd127; #10;
    x_in = 8'd75; #10;
    x_in = -8'd128; #10;
    x_in = -8'd29; #10;
    x_in = -8'd128; #10;

    x_in = 8'd0; #10;
    x_in = 8'd127; #10;
    x_in = 8'd29; #10;
    x_in = 8'd127; #10;
    x_in = -8'd75; #10;
    x_in = 8'd127; #10;
    x_in = 8'd127; #10;
    x_in = 8'd57; #10;
    x_in = 8'd121; #10;
    x_in = -8'd128; #10;

    #200;
    $stop;
end

endmodule