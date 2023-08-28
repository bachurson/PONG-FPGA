`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedzic
// 
// Create Date: 14.08.2023 19:38:57
// Design Name: 
// Module Name: uart_tx_tb
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

`timescale 1ns / 1ps

module TxD_tb;
    logic clk, rst, transmit_btn;
    logic [3:0] data;
    logic TxD;

    TxD dut (
        .clk(clk),
        .rst(rst),
        .flag_transmit(transmit_btn), 
        .points_first_player(data),   
        .points_second_player(data), 
        .TxD(TxD)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        rst = 1;
        transmit_btn = 0;
        data = 8'b11101111; 
               
        #10 rst = 0;

        #2000;
        transmit_btn = 1;
        $display("Transmit button pressed");

        #30000;

        transmit_btn = 0;
        $display("Transmit button released");

        #10000000;
        
        transmit_btn = 1;
 
        
        $display("Transmit button pressed");
        
        #42000;

        transmit_btn = 0;
        $display("Transmit button released");
        
        #10000000;

        $finish; 
    end


    always @(posedge clk) begin
    	if(dut.bit_counter_nxt != dut.bit_counter)
       // if(dut.baudrate_counter == 10415 || dut.baudrate_counter == 10416 || dut.baudrate_counter == 10417 || dut.baudrate_counter == 0  )
       // if(dut.shift_right_nxt != dut.shift_right)
             $display("shift_right = %b, TxD = %b, bit_counter = %d, baudrate_counter = %d, dut.shift = %b, dut.load = %b, dut.clear = %b", dut.shift_right, TxD, dut.bit_counter, dut.baudrate_counter, dut.shift, dut.load, dut.clear );
             
    end

endmodule
