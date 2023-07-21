`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedzic
// 
// Create Date: 19.07.2023 17:59:46
// Design Name: 
// Module Name: ledy
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Pierwszy test zegarow do wysylania poprawnego sygnalu na Trigger czujnika HC-SR04 
// 
//////////////////////////////////////////////////////////////////////////////////
module Sensor(
    input logic clk,
    input logic btnC,
    input logic Echo,
    output logic Trig,
    output logic [8:0] led
);

    logic [32:0] counter;
    logic [32:0] counter_nxt;
     
always_ff @(posedge clk) begin 
    if(btnC) begin
        counter <= 0;
        counter_nxt <= 0;
        led <= 9'b000000000; 
    end
    else if(counter < 20_000_000) begin
            led <= 9'b111111111;

            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else if (counter >= 20_000_000 && counter < 100_000_000) begin
            led <= 9'b000000000;
            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else 
            counter <= 0;
end

endmodule 
