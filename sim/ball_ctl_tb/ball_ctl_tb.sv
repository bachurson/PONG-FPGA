`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedizc
// 
// Create Date: 27.07.2023 13:25:03
// Design Name: 
// Module Name: ball_ctl_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Testbench do fizyki pileczki
// 

module ball_ctl_tb;

// Inputs
logic clk;
logic rst;
logic [10:0] rect_y_pos;
logic [2:0] random_3;
logic [3:0] random_4;
logic [4:0] random_5;

// Outputs
logic [10:0] xpos;
logic [10:0] ypos;

// Instantiate the ball_ctl module
ball_ctl dut (
    .clk(clk),
    .rst(rst),
    .rect_y_pos(rect_y_pos),
    .random_4(random_4),
    .xpos(xpos),
    .ypos(ypos)
);

logic [31:0] counter;
// Clock generation
always #5 clk = ~clk;

initial begin
    $timeformat(0, 6, "s");
    // Initialize inputs
    clk = 0;
    rst = 1;
    //rect_y_pos = 334; //HIGH_PRECISION 
    //rect_y_pos = 384; // MEDIUM_PRECISION
    rect_y_pos = 0; // Miss
    //xpos  zmieniony w module z CENTER na 50 dla szybszego testu
    
    // Reset
    #10 rst = 0;


    $finish;
end

// Display changes
logic [31:0] xpos_prev;

always_ff@(posedge clk) begin
    if (xpos != xpos_prev) begin
        $display("xpos = %d, ypos = %d, state = %b, time = %0t", xpos, ypos, dut.state,  $realtime);
    end
    xpos_prev <= xpos;
    if ( xpos > 512 ) begin // || dut.state != 0
        $display("Simulation ended at time = %t", $realtime);
        $finish;
    end
end

endmodule