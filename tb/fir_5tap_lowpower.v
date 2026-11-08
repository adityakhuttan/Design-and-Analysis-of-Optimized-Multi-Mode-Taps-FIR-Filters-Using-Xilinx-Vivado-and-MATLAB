`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2026 14:04:07
// Design Name: 
// Module Name: fir_5tap_lowpower
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

module fir_5tap_lowpower_tb;
reg clk;
reg rst;
reg ce;
reg [1:0] mode;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

//////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////
fir_5tap_lowpower dut (
    .clk(clk),
    .rst(rst),
    .ce(ce),
    .mode(mode),
    .x_in(x_in),
    .y_out(y_out)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////
always #5 clk = ~clk;

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////
initial begin
    $monitor("t=%0t | mode=%b | x=%d | y=%d",
              $time, mode, x_in, y_out);
end

//////////////////////////////////////////////////
// SAME INPUT VECTOR FOR ALL FILTERS
//////////////////////////////////////////////////
task apply_input;
    integer i;
    reg signed [15:0] v [0:29];
begin
    v[0]=0;       v[1]=127;   v[2]=29;
    v[3]=127;     v[4]=-75;   v[5]=127;
    v[6]=127;     v[7]=57;    v[8]=121;
    v[9]=-128;    v[10]=0;    v[11]=127;
    v[12]=-121;   v[13]=-57;  v[14]=-128;
    v[15]=-127;   v[16]=75;   v[17]=-128;
    v[18]=-29;    v[19]=-128; v[20]=0;
    v[21]=127;    v[22]=29;   v[23]=127;
    v[24]=-75;    v[25]=127;  v[26]=127;
    v[27]=57;     v[28]=121;  v[29]=-128;

    for (i = 0; i < 30; i = i + 1) begin
        x_in = v[i];
        #10;
    end
end
endtask

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////
initial begin

    clk = 0;
    rst = 1;
    ce  = 0;
    x_in = 0;
    mode = 0;

    #20;
    rst = 0;
    ce  = 1;

    //////////////////////////////////////////////////
    // SAME INPUTS FOR ALL FILTER MODES
    //////////////////////////////////////////////////

    mode = 2'b00;   // LPF
    apply_input();

    mode = 2'b01;   // HPF
    apply_input();

    mode = 2'b10;   // BPF
    apply_input();

    mode = 2'b11;   // BSF
    apply_input();

    #100;
    $stop;

end

endmodule
