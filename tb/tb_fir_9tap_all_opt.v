`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 12:20:12
// Design Name: 
// Module Name: tb_fir_9tap_all_opt
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


module tb_fir_9tap_all_opt;

reg clk = 0;
reg rst;
reg ce;
reg [1:0] mode;
reg signed [15:0] x_in;

wire signed [31:0] y_out;

/////////////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////////////
fir_9tap_all_pipe uut (
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

/////////////////////////////////////////////////////////
// CLOCK
/////////////////////////////////////////////////////////
always #5 clk = ~clk;

/////////////////////////////////////////////////////////
// WAVEFORM DUMP
/////////////////////////////////////////////////////////
initial begin
    $dumpfile("fir_9tap.vcd");
    $dumpvars(0, tb_fir_9tap_all_opt);
end

/////////////////////////////////////////////////////////
// MONITOR
/////////////////////////////////////////////////////////
always @(posedge clk)
    $display("t=%0t | mode=%b | x=%d | y=%d",
             $time, mode, x_in, y_out);

/////////////////////////////////////////////////////////
// STIMULUS (FIXED)
/////////////////////////////////////////////////////////
initial begin
    rst  = 1;
    ce   = 0;
    mode = 2'b00;
    x_in = 0;

    repeat(2) @(posedge clk);
    rst = 0;
    ce  = 1;

    /////////////////////////////////////////////////////////
    // MODE 00
    /////////////////////////////////////////////////////////
    mode = 2'b00;
    apply_stream();

    repeat(5) @(posedge clk);

    /////////////////////////////////////////////////////////
    // MODE 01
    /////////////////////////////////////////////////////////
    mode = 2'b01;
    apply_stream();

    repeat(5) @(posedge clk);

    /////////////////////////////////////////////////////////
    // MODE 10
    /////////////////////////////////////////////////////////
    mode = 2'b10;
    apply_stream();

    repeat(5) @(posedge clk);

    /////////////////////////////////////////////////////////
    // MODE 11
    /////////////////////////////////////////////////////////
    mode = 2'b11;
    apply_stream();

    repeat(10) @(posedge clk);
    $stop;
end

/////////////////////////////////////////////////////////
// TASK: INPUT STREAM (CLEAN)
/////////////////////////////////////////////////////////
task apply_stream;
begin
    @(posedge clk); x_in =  8'd0;
    @(posedge clk); x_in =  8'd127;
    @(posedge clk); x_in =  8'd29;
    @(posedge clk); x_in =  8'd127;
    @(posedge clk); x_in = -8'd75;
    @(posedge clk); x_in =  8'd127;
    @(posedge clk); x_in =  8'd127;
    @(posedge clk); x_in =  8'd57;
    @(posedge clk); x_in =  8'd121;
    @(posedge clk); x_in = -8'd128;
    @(posedge clk); x_in =  8'd0;
    @(posedge clk); x_in =  8'd127;
    @(posedge clk); x_in = -8'd121;
    @(posedge clk); x_in = -8'd57;
    @(posedge clk); x_in = -8'd128;
    @(posedge clk); x_in = -8'd127;
    @(posedge clk); x_in =  8'd75;
    @(posedge clk); x_in = -8'd128;
    @(posedge clk); x_in = -8'd29;
    @(posedge clk); x_in = -8'd128;
end
endtask

endmodule