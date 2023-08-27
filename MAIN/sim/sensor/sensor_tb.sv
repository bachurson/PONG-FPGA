`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedzic
// 
// Create Date: 05.08.2023 01:12:25
// Design Name: 
// Module Name: sensor_tb
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

module sensor_tb;

    
    logic clk;
    logic rst;
    logic trig;

    // Instantiate the DUT
    sensor dut (
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .echo(echo)
    );

    // Clock generator (65MHz)
    always #7.6923 clk = ~clk;

    initial begin
         $timeformat(0, 6, "s");
        // Reset the module for a few clock cycles
        clk = 0;
        rst = 1;
        #100;
        rst = 0;

        // Monitor the trig signal
        $monitor("Time=%t, trig=%b", $realtime, trig);

 
        #1000000;
        $finish;
    end

endmodule