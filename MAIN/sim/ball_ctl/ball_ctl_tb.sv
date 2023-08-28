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
logic [10:0] rect2_y_pos;
logic [3:0] random_4;
logic [3:0] points_second_player;
logic [3:0] points_first_player;
// Outputs
logic [10:0] xpos;
logic [10:0] ypos;

// Instantiate the ball_ctl module
ball_ctl dut (
    .clk(clk),
    .rst(rst),
    .rect_y_pos(rect_y_pos),
    .rect2_y_pos(rect2_y_pos),
    .points_second_player(points_second_player),
    .points_first_player(points_first_player),
    .random_4(random_4),
    .xpos(xpos),
    .ypos(ypos),
    .score_flag(score_flag)
);

// Random number for ypos
random #(.N(4)) random_gen (
    .clk(clk),
    .rst(rst),
    .Q(random_4)
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
    //rect_y_pos = 384; // LOW_PRECISION
    rect_y_pos = 0; // Miss
    //xpos  zmieniony w module z CENTER na 50 dla szybszego testu
    
    // Reset
    #10 rst = 0;

end

logic [31:0] xpos_prev;
logic [2:0] dut_state_prev;

always_ff @(posedge clk) begin
    if (xpos != xpos_prev) begin
        $display("xpos = %d, ypos = %d, state = %b, time = %0t, points_first_player = %d, points_second_player = %d", xpos, ypos, dut.state, $realtime, points_first_player, points_second_player);
    end
    xpos_prev <= xpos;
    dut_state_prev <= dut.state;
    if ((xpos == 1024 || xpos == 0) && dut.state != dut_state_prev) begin
        $display("xpos = %d, ypos = %d, state = %b, time = %0t, points_first_player = %d, points_second_player = %d", xpos, ypos, dut.state, $realtime, points_first_player, points_second_player);
        $display("Simulation ended at time = %t", $realtime);
        $finish;
    end
end

endmodule