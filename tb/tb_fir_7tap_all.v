`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 03:43:28
// Design Name: 
// Module Name: tb_fir_7tap_all
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


module tb_fir_7tap_all;
reg clk;
reg rst;
reg [1:0] mode;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

//////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////
fir_7tap_all DUT (
    .clk(clk),
    .rst(rst),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////////////////
// INPUT TASK (SAME PATTERN STYLE)
//////////////////////////////////////////////////
task apply_input;
begin
    x_in = 16'd0;    #10;
    x_in = 16'd127;  #10;
    x_in = 16'd29;   #10;
    x_in = 16'd127;  #10;
    x_in = -16'd75;  #10;
    x_in = 16'd127;  #10;
    x_in = 16'd127;  #10;
    x_in = 16'd57;   #10;
    x_in = 16'd121;  #10;
    x_in = -16'd128; #10;

    x_in = 16'd0;    #10;
    x_in = 16'd127;  #10;
    x_in = -16'd121; #10;
    x_in = -16'd57;  #10;
    x_in = -16'd128; #10;
    x_in = -16'd127; #10;
    x_in = 16'd75;   #10;
    x_in = -16'd128; #10;
    x_in = -16'd29;  #10;
    x_in = -16'd128; #10;

    x_in = 16'd0;    #10;
    x_in = 16'd127;  #10;
    x_in = 16'd29;   #10;
    x_in = 16'd127;  #10;
    x_in = -16'd75;  #10;
    x_in = 16'd127;  #10;
    x_in = 16'd127;  #10;
    x_in = 16'd57;   #10;
    x_in = 16'd121;  #10;
    x_in = -16'd128; #10;
end
endtask

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////
initial begin
    rst = 1;
    mode = 0;
    x_in = 0;

    #20 rst = 0;

    mode = 2'b00; apply_input(); // LPF
    mode = 2'b01; apply_input(); // HPF
    mode = 2'b10; apply_input(); // BPF
    mode = 2'b11; apply_input(); // BSF

    #100 $stop;
end

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////
initial begin
    $monitor("t=%0t mode=%b x_in=%d y_out=%d",
              $time, mode, x_in, y_out);
end

endmodule