//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module ball_ctl (
    input  logic clk,
    input  logic rst,
    input  logic [10:0] rect_y_pos,


    output logic [10:0] xpos,
    output logic [10:0] ypos
);
 logic [26:0] counter;
 logic [26:0] counter_nxt;
 logic [13:0] velocity;
 logic [13:0] vel_nxt;
 logic [1:0] state_nxt, state;
 logic [10:0] xpos_nxt;
 logic [10:0] ypos_nxt;
 logic [19:0] clock_divider;
 logic [19:0] divider_nxt;
 logic signed [10:0] dir;
 logic signed [10:0] dir_nxt;
 import vga_pkg::*;


//local parameters
//********************************************************************//
    localparam START = 2'b00;
    localparam PLAY = 2'b01;
    localparam SCORE = 2'b10;
    localparam [31:0] COUNTER_MAX = 50_000_000;
    localparam RECT_X_POSITION = 30;
    localparam RECT_HEIGHT = 100;
    localparam RECT_WIDTH = 15;
    

//procedural
//********************************************************************//
    always @(posedge clk) begin
      if (rst) begin
        dir <= -1;
        state <= START;
        velocity <= '0;
        counter <= '0;
        xpos <= X_CENTER;
        clock_divider <= 0;
      end
      else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        state <= state_nxt;
        velocity <= vel_nxt;
        counter <= counter_nxt;
        clock_divider <= divider_nxt;
        dir <= dir_nxt;
      end 
    end


  //combinational 
  //********************************************************************//
  always_comb begin 
    if (counter >= COUNTER_MAX) 
      counter_nxt = 0; 
    else 
      counter_nxt = counter + 1 + velocity/10; 

    if(clock_divider == 1000000) begin //velocity setup
      divider_nxt = 0;
      if (velocity <= 200)
        vel_nxt = velocity + 40;
      else if (velocity >= 100 && velocity <= 1000)
        vel_nxt = velocity + 2;
      else if (velocity >= 1000 && velocity <= 8000)
        vel_nxt = velocity + 1;
      else 
        vel_nxt = velocity;
    end else begin
      vel_nxt = velocity;
      divider_nxt = clock_divider + 1;
    end

    case(state)
        START: begin
          if (xpos > 0 && counter >= COUNTER_MAX) begin
            if (xpos == RECT_X_POSITION + RECT_WIDTH && ypos >= rect_y_pos && ypos <= rect_y_pos + RECT_HEIGHT) begin
              dir_nxt = -dir;
              xpos_nxt = xpos + dir;
              ypos_nxt = Y_CENTER;
              state_nxt = PLAY;
            end else begin
              dir_nxt = dir;
              xpos_nxt = xpos + dir;
              ypos_nxt = Y_CENTER;
              state_nxt = START;
            end
          end else begin
            dir_nxt = dir;
            xpos_nxt = xpos;
            ypos_nxt = Y_CENTER;
            state_nxt = START;          
          end
        end
 
        PLAY: begin
          if (counter >= COUNTER_MAX) begin
            dir_nxt = dir;
            xpos_nxt = xpos + dir;
            ypos_nxt = ypos;
            state_nxt = PLAY;
          end else begin
            dir_nxt = dir;
            xpos_nxt = xpos;
            state_nxt = PLAY;
            ypos_nxt = ypos;
          end
        end

        //SCORE:
        
        default: begin
          xpos_nxt = xpos;
          ypos_nxt = ypos;
          state_nxt = START;
          dir_nxt = dir;  
        end

    endcase
  end

//********************************************************************//
endmodule