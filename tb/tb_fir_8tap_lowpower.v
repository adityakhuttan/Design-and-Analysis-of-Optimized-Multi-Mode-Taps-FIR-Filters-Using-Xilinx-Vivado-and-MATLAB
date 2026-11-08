`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 04:13:50
// Design Name: 
// Module Name: tb_fir_8tap_lowpower
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


module tb_fir_8tap_lowpower;

reg clk = 0;
reg rst;
reg ce;
reg [1:0] mode;
reg signed [15:0] x_in;

wire signed [31:0] y_out;

fir_8tap_all_lowpower uut (
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

always #5 clk = ~clk;

task apply_input;
begin
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
end
endtask

initial begin
    rst = 1;
    ce = 0;
    mode = 0;
    x_in = 0;

    #20;
    rst = 0;
    ce = 1;

    mode = 2'b00; apply_input();
    mode = 2'b01; apply_input();
    mode = 2'b10; apply_input();
    mode = 2'b11; apply_input();

    #200;
    $stop;
end

endmodule