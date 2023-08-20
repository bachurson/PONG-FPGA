
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Wiktor Dziedzic
// 
// Create Date: 13.08.2023 13:32:39
// Design Name: 
// Module Name: uart_rx
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

module uart_rx(
    input logic clk,
    input logic rst,
    input logic RxD,
    output logic [7:0] RxData
    );
    
    logic shift, shift_nxt; 
    logic [3:0] bit_counter, bit_counter_nxt;
    logic [1:0] sample_counter, sample_counter_nxt;
    logic [13:0] baudrate_counter, baudrate_counter_nxt;
    logic [9:0] rxshift_reg, rxshift_reg_nxt;
    logic clear_bitcounter, clear_bitcounter_nxt;
    logic inc_bitcounter, inc_bitcounter_nxt;
    logic inc_samplecounter, inc_samplecounter_nxt;
    logic clear_samplecounter, clear_samplecounter_nxt;
    logic state, state_nxt;

    localparam clk_freq = 65_000_000;
    localparam baud_rate = 9_600;
    localparam div_sample = 4;
    localparam div_counter = clk_freq / (baud_rate * div_sample);
    localparam mid_sample = (div_sample / 2);
    localparam div_bit = 10;

    assign RxData = rxshift_reg[8:1];

    always_ff @(posedge clk) begin
        if (rst) begin
            bit_counter <= 0;
            baudrate_counter <= 0;
            sample_counter <= 0;
            shift <= 0;
            clear_samplecounter <= 0;
            inc_samplecounter <= 0;
            clear_bitcounter <= 0;
            inc_bitcounter <= 0;
            state <= 0;
        end else begin
            bit_counter <= bit_counter_nxt;
            baudrate_counter <= baudrate_counter_nxt;
            sample_counter <= sample_counter_nxt;
            rxshift_reg <= rxshift_reg_nxt;
            shift <= shift_nxt;
            clear_samplecounter <= clear_samplecounter_nxt;
            inc_samplecounter <= inc_samplecounter_nxt;
            clear_bitcounter <= clear_bitcounter_nxt;
            inc_bitcounter <= inc_bitcounter_nxt;
            state <= state_nxt;
        end
    end


    always_comb begin
        
        baudrate_counter_nxt = baudrate_counter + 1;
        if (baudrate_counter >= div_counter - 1) begin
            baudrate_counter_nxt = 0;
            state_nxt = state;
            
            if (shift)  rxshift_reg_nxt = {RxD, rxshift_reg[9:1]};
            else rxshift_reg_nxt = rxshift_reg;
           
            if (clear_samplecounter) sample_counter_nxt = 0;
            else if (inc_samplecounter) sample_counter_nxt = sample_counter + 1;
            else sample_counter_nxt = sample_counter; 
            
            if (clear_bitcounter) bit_counter_nxt = 0;
            else if (inc_bitcounter) bit_counter_nxt = bit_counter + 1;
            else bit_counter_nxt = bit_counter;
        
        end else begin
            baudrate_counter_nxt = baudrate_counter + 1;
            sample_counter_nxt = sample_counter;
            bit_counter_nxt = bit_counter;
            rxshift_reg_nxt = rxshift_reg;
            state_nxt = state;
            clear_samplecounter_nxt = clear_samplecounter;
            inc_samplecounter_nxt = inc_samplecounter;
            clear_bitcounter_nxt = clear_bitcounter;
            inc_bitcounter_nxt = inc_bitcounter;
        end

        if (sample_counter == mid_sample - 1) 
            shift_nxt = 1;
        else 
            shift_nxt = 0;
            
            
        clear_samplecounter_nxt = 0;
        inc_samplecounter_nxt = 0;
        clear_bitcounter_nxt = 0;
        inc_bitcounter_nxt = 0;
        state_nxt = 0;
                
        case (state)
            0: begin
                if (RxD) begin
                    state_nxt = 0;
                end else begin
                    state_nxt = 1;
                    clear_bitcounter_nxt = 1;
                    clear_samplecounter_nxt = 1;
                end
            end
            1: begin 
                state_nxt = 1;
                if (sample_counter == mid_sample - 1) begin
                    shift_nxt = 1;
                end
                if (sample_counter == div_sample - 1) begin
                    if (bit_counter == div_bit - 1) begin
                        state_nxt = 0;
                        clear_bitcounter_nxt = 1;
                        clear_samplecounter_nxt = 1;
               
                    end else begin
                        inc_bitcounter_nxt = 1;
                        clear_samplecounter_nxt = 1;
                    end
                end else begin
                    inc_samplecounter_nxt = 1;
                end
            end
            default: state_nxt = 0;
        endcase
    end
endmodule
