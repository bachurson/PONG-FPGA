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
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
/*
module Sensor(
    input logic clk,
    input logic btnC,
    input logic Echo,
    output logic Trig,
    output logic [8:0] led
);
 
    logic [32:0] counter;
    logic [32:0] counter_nxt;
    logic [32:0] counter_echo;
    logic [32:0] counter_echo_nxt;
    
always_ff @(posedge clk) begin 
    if(btnC) begin
        counter <= 0;
        counter_nxt <= 0;
        Trig <= 1'b0;
        led[4:0] <= 5'b00000;
    end
    else if(counter < 1100) begin
            Trig <= 1'b1;
            led[4:0] <= 5'b11111;
            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else if (counter >= 1100 && counter < 1_000_000) begin
            led[4:0] <= 5'b00000;
            Trig <= 1'b0;
            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else 
            counter <= 0;
end

always_ff @(posedge clk) begin 
   if(btnC) begin
        counter_echo <= 0;
        counter_echo_nxt <= 0;
    end
    else if(Echo == 1'b1) begin 
            counter_echo_nxt <= counter_echo + 1;
            counter_echo <= counter_echo_nxt; 
            if (counter_echo == 0) begin
                led[6:5] <= 2'b11;
            end
            else if (counter_echo > 0 && counter_echo <= 100) begin
                led [6:5] <= 2'b00;
            end
            else if (counter_echo > 1000 && counter_echo <= 50_000) begin
                led [8] <= 1'b1;  
            end
            else if (counter_echo > 50_000) begin
                led [7] <= 1'b1; 
            end
    end
    else if(counter_echo == 1_000_000) begin
        counter_echo <= 0;
   end
end
endmodule 
*/
module Sensor(
    input logic clk,
    input logic btnC,
    input logic Echo,
    output logic Trig,
    output logic [8:0] led
);
    logic [32:0] echo_time;
    logic [32:0] counter;
    logic [32:0] counter_nxt;
    logic [32:0] counter_echo;
    logic [32:0] counter_echo_nxt;
    bit y;
    
always_ff @(posedge clk) begin 
    if(btnC) begin
        counter <= 0;
        counter_nxt <= 0;
        Trig <= 1'b0;
    end
    else if(counter == 0) begin
            Trig <= 1'b1;
            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else if (counter == 1100) begin
            Trig <= 1'b0;
            y <= 1;
            counter_nxt <= counter + 1;
            counter <= counter_nxt;
       end
       else if (counter == 10_000_000) begin
            counter <= 0;
            Trig <= 1'b1;
       end

    if(Echo == 1) begin
            counter_echo_nxt <= counter_echo + 1;
            counter_echo <= counter_echo_nxt;
    end 
    else if (Echo == 0 && y==1) begin
        echo_time   <=  counter_echo;
        counter_echo <= 0;
        y <= 0;
    end
    if (echo_time == 0) begin
     led[8:0] <= 9'b111111111;
    end
    else if(echo_time > 0 && echo_time < 100000) begin
     led[4] <= 1'b1;
    end else if(echo_time > 300000) begin
     led[6] <= 1'b1;
     end else begin 
     led[8:7] <= 2'b11;
    end
  end

endmodule