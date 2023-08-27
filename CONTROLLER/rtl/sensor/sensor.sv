`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Wiktor Dziedzic
//
// Create Date: 05.08.2023 00:24:33
// Design Name:
// Module Name: sensor
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

module sensor(
    input logic clk,
    input logic rst,
    input logic echo,
    output logic trig,
    output logic [7:0] distance,
    output logic flag
);

logic [25:0] counter_10us;
logic [25:0] counter_50ms;
logic [25:0] counter_nxt_10us;
logic [25:0] counter_nxt_50ms;
logic trig_nxt;
logic [25:0] counter_echo;
logic [25:0] counter_echo_nxt;
logic [7:0] distance_nxt;
logic [7:0] distance_raw;
logic [7:0] distance_raw_nxt;
logic [7:0] distance_raw_prev;
logic [7:0] distance_raw_prev_nxt;
logic [7:0] distance_echo;
logic [7:0] distance_echo_nxt;
logic [25:0] trig_counter;
logic [25:0] trig_counter_nxt;
logic flag_nxt;


localparam CYCLE_COUNT_10US = 650;
localparam CYCLE_COUNT_50MS = 3250000;
localparam COUNTER_MAX = 150000;

always_ff @(posedge clk) begin
    if (rst) begin
        counter_10us <= 0;
        counter_50ms <= 0;
        counter_echo <= 0;
        trig <= 0;
        distance <= 0;
        distance_raw <= 0;
        distance_raw_prev <= 0;
        distance_echo <= 0;
        trig_counter <= 0;
        flag <= 0;
    end else begin
        counter_10us <= counter_nxt_10us;
        counter_50ms <= counter_nxt_50ms;
        trig <= trig_nxt;
        counter_echo <= counter_echo_nxt;
        trig_counter <= trig_counter_nxt;
        distance <= distance_nxt;
        distance_raw <= distance_raw_nxt;
        distance_raw_prev <= distance_raw;
        distance_echo <= distance_echo_nxt;
        flag <= flag_nxt;
    end
end

always_comb begin
    if (trig == 1) begin
        counter_nxt_50ms = counter_50ms;
        if(counter_10us == CYCLE_COUNT_10US) begin
             trig_nxt = 0;
             counter_nxt_10us = 0;
        end
        else begin
            trig_nxt = 1;
            counter_nxt_10us = counter_10us + 1;
        end
    end
    else begin
        counter_nxt_10us = counter_10us;

        if(counter_50ms == CYCLE_COUNT_50MS) begin
            counter_nxt_50ms = 0;
            trig_nxt = 1;
        end
        else begin
            trig_nxt = 0;
            counter_nxt_50ms = counter_50ms + 1;
        end

    end
end

always_comb begin
     if(echo == 1) begin
         counter_echo_nxt = counter_echo + 1;
         if (counter_echo <= COUNTER_MAX )
            distance_echo_nxt = counter_echo/600;
         else 
            distance_echo_nxt = 255;
     end
     else begin
       counter_echo_nxt = counter_echo;
       distance_echo_nxt = distance_echo;
    end
    if(trig == 1)
       counter_echo_nxt = 0;
end

always_comb begin

    flag_nxt = 0;

    if(trig == 1) begin
       if(trig_counter == 0) begin
            distance_raw_nxt = distance_echo;
            distance_nxt = distance;
            trig_counter_nxt = trig_counter + 1;
            flag_nxt = 1;
       end else if(trig_counter == 1) begin
            distance_raw_nxt = distance_raw;
            trig_counter_nxt = trig_counter + 1;
            if( (distance_raw >= distance_raw_prev - 20) && (distance_raw <= distance_raw_prev + 20 )) begin
                distance_nxt = distance_raw;
            end else begin
                distance_nxt = distance;
            end
       end
       else begin
            distance_raw_nxt = distance_raw;
            distance_nxt = distance;
            trig_counter_nxt = trig_counter + 1;
       end
    end else begin
        distance_raw_nxt = distance_raw;
        distance_nxt = distance;
        trig_counter_nxt = 0;

    end
end

endmodule