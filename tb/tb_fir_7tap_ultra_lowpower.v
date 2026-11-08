`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 03:51:49
// Design Name: 
// Module Name: tb_fir_7tap_ultra_lowpower
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


module tb_fir_7tap_ultra_lowpower;

reg clk;
reg rst;
reg ce;
reg [1:0] mode;
reg signed [15:0] x_in;

wire signed [31:0] y_out;

//////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////
fir_7tap_ultra_lowpower DUT (
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

//////////////////////////////////////////////////
// CLOCK (100 MHz equivalent)
//////////////////////////////////////////////////
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//////////////////////////////////////////////////
// STIMULUS ENABLE
//////////////////////////////////////////////////
initial begin
    ce = 1;   // keep active for power measurement
end

//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////
initial begin
    rst = 1;
    x_in = 0;
    mode = 0;

    #20;
    rst = 0;
end

//////////////////////////////////////////////////
// INPUT PATTERN TASK
//////////////////////////////////////////////////
task apply_input;
begin

    x_in = 16'd0;     #10;
    x_in = 16'd120;   #10;
    x_in = 16'd45;    #10;
    x_in = -16'd60;   #10;
    x_in = 16'd90;    #10;
    x_in = -16'd30;   #10;
    x_in = 16'd127;   #10;
    x_in = -16'd127;  #10;
    x_in = 16'd75;    #10;
    x_in = 16'd0;     #10;

    x_in = 16'd0;     #10;
    x_in = 16'd120;   #10;
    x_in = 16'd45;    #10;
    x_in = -16'd60;   #10;
    x_in = 16'd90;    #10;
    x_in = -16'd30;   #10;
    x_in = 16'd127;   #10;
    x_in = -16'd127;  #10;
    x_in = 16'd75;    #10;
    x_in = 16'd0;     #10;

    x_in = 16'd0;     #10;
    x_in = 16'd120;   #10;
    x_in = 16'd45;    #10;
    x_in = -16'd60;   #10;
    x_in = 16'd90;    #10;
    x_in = -16'd30;   #10;
    x_in = 16'd127;   #10;
    x_in = -16'd127;  #10;
    x_in = 16'd75;    #10;
    x_in = 16'd0;     #10;

end
endtask

//////////////////////////////////////////////////
// MODE STIMULUS
//////////////////////////////////////////////////
initial begin

    #25;

    mode = 2'b00; apply_input(); // LPF
    mode = 2'b01; apply_input(); // HPF
    mode = 2'b10; apply_input(); // BPF
    mode = 2'b11; apply_input(); // BSF

    #100;
    $stop;
end

//////////////////////////////////////////////////
// MONITOR OUTPUT
//////////////////////////////////////////////////
initial begin
    $monitor("t=%0t mode=%b x_in=%d y_out=%d",
              $time, mode, x_in, y_out);
end

endmodule