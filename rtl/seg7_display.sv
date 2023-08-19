`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Wiktor Dziedzic
// 
// Create Date: 30.07.2023 17:42:39
// Design Name: 
// Module Name: Seg7_Display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Modul do wyswietlania wyniku na wyswietlaczu 7seg
// 
//////////////////////////////////////////////////////////////////////////////////

module seg7_display(
    input logic clk,
    input logic rst,
    input logic [6:0] points_first_player,
    input logic [6:0] points_second_player,
    output logic [3:0] an,
    output logic [6:0] seg
);

logic [2:0] an_counter;
logic [26:0] timer_counter;
logic [2:0] an_counter_nxt;
logic [26:0] timer_counter_nxt;


localparam TIMER_MAX = 275000; 
localparam AN_MAX = 4;

always_ff @(posedge clk) begin
    if (rst) begin
        timer_counter <= 0;
        an_counter <= 0;
    end else begin    
        timer_counter <= timer_counter_nxt;
        an_counter <= an_counter_nxt;
    end
end

always_comb begin 
    if (timer_counter >= TIMER_MAX) begin
        timer_counter_nxt = 0;
        if (an_counter >= AN_MAX) begin
            an_counter_nxt = 0;
        end else begin
            an_counter_nxt = an_counter + 1;
        end
    end else begin
        timer_counter_nxt = timer_counter + 1; 
        an_counter_nxt = an_counter;
    end
end

always_comb begin
    case(an_counter)
        3'b000: an = 4'b1110;
        3'b001: an = 4'b1101;
        3'b010: an = 4'b1011;
        3'b011: an = 4'b0111;
        default: an = 4'b1111; 
    endcase
end

always_comb begin
    case(an_counter)
        3'b000: begin
            if (points_second_player > 9) begin
                seg[6:0] = 7'b1111111; 
            end else 
                seg[6:0] = 7'b1111111; 
                case(points_second_player)
                    4'h0: seg[6:0] = 7'b1000000;    // digit 0
                    4'h1: seg[6:0] = 7'b1111001;    // digit 1
                    4'h2: seg[6:0] = 7'b0100100;    // digit 2
                    4'h3: seg[6:0] = 7'b0110000;    // digit 3
                    4'h4: seg[6:0] = 7'b0011001;    // digit 4
                    4'h5: seg[6:0] = 7'b0010010;    // digit 5
                    4'h6: seg[6:0] = 7'b0000010;    // digit 6
                    4'h7: seg[6:0] = 7'b1111000;    // digit 7
                    4'h8: seg[6:0] = 7'b0000000;    // digit 8
                    4'h9: seg[6:0] = 7'b0010000;    // digit 9
            endcase
        end
        3'b001: begin 
            seg[6:0] = 7'b0111111; // Display "-"
        end
        3'b010: begin 
            seg[6:0] = 7'b0111111; // Display "-"
        end
        3'b011: begin
            if (points_first_player > 9) begin
                seg[6:0] = 7'b1111111; 
            end else 
                seg[6:0] = 7'b1111111;
                case(points_first_player)
                    4'h0: seg[6:0] = 7'b1000000;    // digit 0
                    4'h1: seg[6:0] = 7'b1111001;    // digit 1
                    4'h2: seg[6:0] = 7'b0100100;    // digit 2
                    4'h3: seg[6:0] = 7'b0110000;    // digit 3
                    4'h4: seg[6:0] = 7'b0011001;    // digit 4
                    4'h5: seg[6:0] = 7'b0010010;    // digit 5
                    4'h6: seg[6:0] = 7'b0000010;    // digit 6
                    4'h7: seg[6:0] = 7'b1111000;    // digit 7
                    4'h8: seg[6:0] = 7'b0000000;    // digit 8
                    4'h9: seg[6:0] = 7'b0010000;    // digit 9
                endcase
            end
        default: seg[6:0] = 7'b1111111; 
    endcase

end
endmodule
