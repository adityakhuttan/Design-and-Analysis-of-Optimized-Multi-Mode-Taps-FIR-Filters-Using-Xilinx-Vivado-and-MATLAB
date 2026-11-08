`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 22:10:12
// Design Name: 
// Module Name: fir_4tap_all_modes_tb
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

module fir_4tap_all_modes_tb;

reg clk;
reg rst;
reg [1:0] mode;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

// DUT
fir_4tap_all_modes DUT (
    .clk(clk),
    .rst(rst),
    .x_in(x_in),
    .mode(mode),
    .y_out(y_out)
);

// CLOCK
initial clk = 0;
always #5 clk = ~clk;

// MONITOR
initial begin
    $monitor("Time=%0t | mode=%b | x_in=%d | y_out=%d",
             $time, mode, x_in, y_out);
end

// SAME INPUT PATTERN
task apply_input;
begin
    x_in =  8'd0;    #10;
    x_in =  8'd127;  #10;
    x_in =  8'd29;   #10;
    x_in =  8'd127;  #10;
    x_in = -8'd75;   #10;
    x_in =  8'd127;  #10;
    x_in =  8'd127;  #10;
    x_in =  8'd57;   #10;
    x_in =  8'd121;  #10;
    x_in = -8'd128;  #10;
    x_in =  8'd0;    #10;
    x_in =  8'd127;  #10;
    x_in = -8'd121;  #10;
    x_in = -8'd57;   #10;
    x_in = -8'd128;  #10;
    x_in = -8'd127;  #10;
    x_in =  8'd75;   #10;
    x_in = -8'd128;  #10;
    x_in = -8'd29;   #10;
    x_in = -8'd128;  #10;
    x_in =  8'd0;    #10;
    x_in =  8'd127;  #10;
    x_in =  8'd29;   #10;
    x_in =  8'd127;  #10;
    x_in = -8'd75;   #10;
    x_in =  8'd127;  #10;
    x_in =  8'd127;  #10;
    x_in =  8'd57;   #10;
    x_in =  8'd121;  #10;
    x_in = -8'd128;  #10;
end
endtask

// STIMULUS
initial begin
    rst = 1;
    x_in = 0;
    mode = 0;
    #20;
    rst = 0;

    mode = 2'b00; apply_input();
    mode = 2'b01; apply_input();
    mode = 2'b10; apply_input();
    mode = 2'b11; apply_input();

    #100;
    $stop;
end

endmodule