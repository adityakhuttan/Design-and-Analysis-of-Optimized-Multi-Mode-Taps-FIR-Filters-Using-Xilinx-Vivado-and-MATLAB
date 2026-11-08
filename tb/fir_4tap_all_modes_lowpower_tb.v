`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 22:15:37
// Design Name: 
// Module Name: fir_4tap_all_modes_lowpower_tb
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


module fir_4tap_all_modes_lowpower_tb;

reg clk;
reg rst;
reg ce;
reg [1:0] mode;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

// DUT (UPDATED WITH ce)
fir_4tap_all_modes_lowpower DUT (
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .x_in(x_in),
    .mode(mode),
    .y_out(y_out)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////
initial clk = 0;
always #5 clk = ~clk;

//////////////////////////////////////////////////
// WAVEFORM DUMP (VERY IMPORTANT)
//////////////////////////////////////////////////
initial begin
    $dumpfile("fir_tb.vcd");
    $dumpvars(0, fir_4tap_all_modes_lowpower_tb);
end

//////////////////////////////////////////////////
// INPUT TASK (SYNC TO CLOCK)
//////////////////////////////////////////////////
task apply_input;
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

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////
initial begin
    $monitor("Time=%0t | mode=%b | ce=%b | x_in=%d | y_out=%d",
             $time, mode, ce, x_in, y_out);
end

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////
initial begin
    rst = 1;
    ce = 0;
    x_in = 0;
    mode = 0;

    repeat(2) @(posedge clk);
    rst = 0;
    ce = 1;

    // ================= LPF =================
    mode = 2'b00;
    apply_input();

    // small gap
    repeat(2) @(posedge clk);

    // ================= HPF =================
    mode = 2'b01;
    apply_input();

    repeat(2) @(posedge clk);

    // ================= BPF =================
    mode = 2'b10;
    apply_input();

    repeat(2) @(posedge clk);

    // ================= BSF =================
    mode = 2'b11;
    apply_input();

    repeat(5) @(posedge clk);
    $stop;
end

endmodule