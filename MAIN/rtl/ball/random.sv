//Author: Dominik Bachurski


`timescale 1 ns / 1 ps

module random
    #(parameter N = 3) (
        input logic clk,
        input logic rst,
        output logic [1:N] Q
    );

logic [1:N] Q_next;
logic taps;

//procedural
//********************************************************************//
always @(posedge clk) begin
    if(rst)
        Q <= 'd1;
    else
        Q <= Q_next;
end

//combinational 
//********************************************************************//
always_comb begin
    case (N)
        3: taps = Q[3] ^ Q[2];
        4: taps = Q[3] ^ Q[4];
        5: taps = Q[5] ^ Q[3];
    endcase
    Q_next = {taps, Q[1:N - 1]};
end


endmodule
