`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedizc
// 
// Create Date: 25.07.2023 22:24:43
// Design Name: 
// Module Name: random_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Testbench dla liczb losowych 
// 
//////////////////////////////////////////////////////////////////////////////////
module random_tb;

    // Parameters
    localparam N = 3;

    // Inputs
    logic clk;
    logic rst;

    // Outputs
    logic [1:N] Q;

    random #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 0;
        #2 rst = 1; 
        #10 rst = 0; 
        #100 $finish;        
    end

    always_ff @(posedge clk)
        $display("Q = %d", Q);

endmodule
