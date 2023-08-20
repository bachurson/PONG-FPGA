//Author: Dominik Bachurski

`timescale 1ns / 1ps


module TxD (
    input logic clk,
    input logic btnU,
    input logic btnD,
    input logic rst,
    output logic TxD
);


logic [3:0] bit_counter, bit_counter_nxt; //counter to count 10 bits
logic [13:0] baudrate_counter, baudrate_counter_nxt ; //here 65Mhz/9600= 6770
logic [9:0] shift_right, shift_right_nxt; //10 bits that will be transmitted
logic transmit, transmit_nxt; //transmit or idle?
logic clear, load, shift, clear_nxt, load_nxt, shift_nxt;
logic TxD_nxt;
logic [7:0] data, data_nxt;

localparam CLK_FREQ = 65_000_000;
localparam BAUD_RATE = 9_600;
localparam COUNTER_MAX = CLK_FREQ/(BAUD_RATE);

always_ff @(posedge clk) begin
    if (rst) begin
        data <= '0;
        TxD <= '1;
        bit_counter <= '0;
        baudrate_counter <= '0;
        transmit <= '0;
        shift_right <= '0;
        clear <= '0;
        load <= '0;
        shift <= '0;
    end
    else begin
        data <= data_nxt;
        TxD <= TxD_nxt;
        bit_counter <= bit_counter_nxt;
        baudrate_counter <= baudrate_counter_nxt;
        transmit <= transmit_nxt;
        shift_right <= shift_right_nxt;
        clear <= clear_nxt;
        load <= load_nxt;
        shift <= shift_nxt;

    end
end
    
always_comb begin

    if(baudrate_counter == COUNTER_MAX - 2 ) begin
        baudrate_counter_nxt = 0;
        shift_right_nxt = shift_right;         
        bit_counter_nxt = bit_counter;
                       
        if(shift) begin
            shift_right_nxt = shift_right >> 1;
            bit_counter_nxt = bit_counter + 1;
        end
           
        if(load) begin
            shift_right_nxt = {1'b1, data, 1'b0};
            bit_counter_nxt = bit_counter;
        end 
        
        if(clear) begin
            bit_counter_nxt = 0;
            shift_right_nxt = shift_right;
        end
        
    end else begin
        baudrate_counter_nxt = baudrate_counter + 1;
        shift_right_nxt = shift_right;
        bit_counter_nxt = bit_counter;
    end
	        
    
    if(!transmit) begin
        shift_nxt = 0;
        TxD_nxt = 1;

        if (btnU || btnD) begin

            if(btnU)
                data_nxt = 8'b01000001;
            else
                data_nxt = 8'b01000010;

            transmit_nxt = 1;
            load_nxt = 1;
            clear_nxt = 0;
        end else begin
            transmit_nxt = 0;
            load_nxt = 0;
            clear_nxt = clear;
            data_nxt = 0;
        end

    end else begin
        data_nxt = data;

        if(bit_counter == 10) begin
            transmit_nxt = 0;
            clear_nxt = 1;
            TxD_nxt = TxD;
            shift_nxt = 0;
            load_nxt = 0;
        end else begin
            shift_nxt = 1;
            transmit_nxt = transmit;
            clear_nxt = clear;

            if(baudrate_counter == 0)
                TxD_nxt = shift_right[0];
            else
                TxD_nxt = TxD;

            if(baudrate_counter == COUNTER_MAX - 2)
                load_nxt = 0;
            else
                load_nxt = load;
        end     

    end
  
end   


endmodule
