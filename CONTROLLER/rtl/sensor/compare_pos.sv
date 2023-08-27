//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module compare_pos (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] pos,
    input  logic [7:0] pos_second,
    output logic [7:0] y_position
);

 logic [7:0] y_position_nxt;


//procedural
//********************************************************************//
    always_ff @(posedge clk) begin
        if (rst) begin
            y_position <= '0;
        end
        else begin
            y_position <= y_position_nxt;
        end
    end


  //combinational
  //********************************************************************//
  always_comb begin : rect_comb_blk

      
        if ( y_position >= pos && y_position >= pos_second)

            if(y_position - pos >= y_position - pos_second)
                y_position_nxt = pos_second;
            else
                y_position_nxt = pos;

        else if (y_position < pos && y_position < pos_second)

            if(pos - y_position >= pos_second - y_position)
                y_position_nxt = pos_second;
            else
                y_position_nxt = pos;

        else 
            y_position_nxt = pos;
      
  end

//********************************************************************//
endmodule