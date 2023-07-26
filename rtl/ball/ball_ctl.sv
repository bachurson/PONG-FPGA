//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module ball_ctl (
    input logic clk,
    input logic rst,
    input logic [10:0] rect_y_pos,
    //input logic [1:3] random_3,
    //input logic [1:4] random_4,
    //input logic [1:5] random_5,
    input logic [2:0] random_3,
    input logic [3:0] random_4,
    input logic [4:0] random_5,

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
 logic [4:0] angle_counter_x;
 logic [4:0] angle_x_nxt;
 logic [4:0] angle_counter_y;
 logic [4:0] angle_y_nxt;
 logic [4:0] random;
 logic [4:0] random_nxt;
 logic IN_RECT;
 logic LOW_PRECISION;
 logic MEDIUM_PRECISION;
 logic HIGH_PRECISION;
 import vga_pkg::*;


//local parameters
//********************************************************************//
    localparam START = 2'b00;
    localparam PLAY = 2'b01;
    localparam SCORE = 2'b10;
    localparam [26:0] COUNTER_MAX = 50_000_000;
    localparam RECT_X_POSITION = 30;
    localparam RECT_HEIGHT = 100;
    localparam RECT_WIDTH = 15;
    //localparam IN_RECT = (xpos == RECT_X_POSITION + RECT_WIDTH + 1 && ypos >= rect_y_pos && ypos <= rect_y_pos + RECT_HEIGHT);
    //localparam LOW_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ((ypos >= rect_y_pos && ypos <= rect_y_pos + 15) || (ypos >= rect_y_pos + 85 && ypos <= rect_y_pos + RECT_HEIGHT )));
    //localparam MEDIUM_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ((ypos >= rect_y_pos + 15 && ypos <= rect_y_pos + RECT_HEIGHT - 65) || (ypos >= rect_y_pos + 65 && ypos <= rect_y_pos + RECT_HEIGHT - 15)));
    //localparam HIGH_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ypos >= rect_y_pos + 35 && ypos <= rect_y_pos + RECT_HEIGHT - 35);

    

//procedural
//********************************************************************//
    always_ff @(posedge clk) begin
      if (rst) begin
        dir <= -1;
        state <= START;
        velocity <= '0;
        counter <= '0;
        xpos <= X_CENTER;
        clock_divider <= 0;
        angle_counter_x <= 0;
        angle_counter_y <= 0;
        random <= 0;
      end
      else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        state <= state_nxt;
        velocity <= vel_nxt;
        counter <= counter_nxt;
        clock_divider <= divider_nxt;
        dir <= dir_nxt;
        angle_counter_x <= angle_x_nxt; 
        angle_counter_y <= angle_y_nxt; 
        random <= random_nxt;
      end 
    end


  //combinational 
  //********************************************************************//
  always_comb begin
    IN_RECT = (xpos == RECT_X_POSITION + RECT_WIDTH  && ypos >= rect_y_pos && ypos <= rect_y_pos + RECT_HEIGHT);
    LOW_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ((ypos >= rect_y_pos && ypos <= rect_y_pos + 15) || (ypos >= rect_y_pos + 85 && ypos <= rect_y_pos + RECT_HEIGHT )));
    MEDIUM_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ((ypos >= rect_y_pos + 15 && ypos <= rect_y_pos + RECT_HEIGHT - 65) || (ypos >= rect_y_pos + 65 && ypos <= rect_y_pos + RECT_HEIGHT - 15)));
    HIGH_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ypos >= rect_y_pos + 35 && ypos <= rect_y_pos + RECT_HEIGHT - 35);
  end

  always_comb begin 
    if (counter >= COUNTER_MAX) 
      counter_nxt = 0; 
    else 
      if(state==PLAY)
        counter_nxt = counter + 1 + velocity/3;
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
            if (IN_RECT) begin
              random_nxt = 0;
              angle_x_nxt = 0;
              angle_y_nxt = 0;
              dir_nxt = -dir;
              xpos_nxt = xpos;
              ypos_nxt = Y_CENTER;
              state_nxt = PLAY;
            end else begin
              random_nxt = 0;
              angle_x_nxt = 0;
              angle_y_nxt = 0;
              dir_nxt = dir;
              xpos_nxt = xpos + dir;
              ypos_nxt = Y_CENTER;
              state_nxt = START;
            end
          end else begin
            random_nxt = 0;
            angle_x_nxt = 0;
            angle_y_nxt = 0;
            dir_nxt = dir;
            xpos_nxt = xpos;
            ypos_nxt = Y_CENTER;
            state_nxt = START;          
          end
        end
 
        PLAY: begin
          if (xpos > 0 && xpos < HOR_PIXELS) begin
            if (counter >= COUNTER_MAX) begin
              if(IN_RECT) begin
                angle_x_nxt = 0;
                angle_y_nxt = 0;
                dir_nxt = dir;
                xpos_nxt = xpos + dir;
                ypos_nxt = ypos + dir;
                state_nxt = PLAY;
                if(HIGH_PRECISION)
                  random_nxt = random_3;
                else if (MEDIUM_PRECISION)
                  random_nxt = random_4;
                else 
                  random_nxt = random_5;
              end else begin
                random_nxt = random;
                state_nxt = PLAY;
                dir_nxt = dir;
                if(angle_counter_x == 3) begin
                  xpos_nxt = xpos + dir;
                  angle_x_nxt = 0;
                end else begin
                  xpos_nxt = xpos;
                  angle_x_nxt = angle_counter_x + 1; 
                end
                if(angle_counter_y == random) begin
                  ypos_nxt = ypos + dir;
                  angle_y_nxt = 0;
                end else begin
                  ypos_nxt = ypos;  
                  angle_y_nxt = angle_counter_y + 1; 
                end
              end 
            end else begin
              random_nxt = random;
              angle_x_nxt = angle_counter_x;
              angle_y_nxt = angle_counter_y;
              state_nxt = PLAY;
              dir_nxt = dir;
              xpos_nxt = xpos;
              ypos_nxt = ypos;
            end
          end else begin
            random_nxt = 0;
            angle_x_nxt = 0;
            angle_y_nxt = 0;
            state_nxt = SCORE;
            dir_nxt = dir;
            xpos_nxt = xpos;
            ypos_nxt = ypos;
          end
        end

        SCORE: begin
          random_nxt = 0;
          angle_x_nxt = 0;
          angle_y_nxt = 0;
          dir_nxt = dir;
          xpos_nxt = xpos;
          ypos_nxt = ypos;
          state_nxt = SCORE;    
        end

        default: begin
          random_nxt = 0;
          angle_x_nxt = 0;
          angle_y_nxt = 0;
          xpos_nxt = xpos;
          ypos_nxt = ypos;
          state_nxt = START;
          dir_nxt = dir;  
        end

    endcase
  end

//********************************************************************//
endmodule