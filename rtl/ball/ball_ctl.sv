//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module ball_ctl (
    input logic clk,
    input logic rst,
    input logic [10:0] rect_y_pos,
    input logic [10:0] rect2_y_pos,
    input logic [3:0] random_4,

    output logic [10:0] xpos,
    output logic [10:0] ypos
);
 logic [26:0] counter, counter_nxt;
 logic [13:0] velocity, vel_nxt;
 logic [2:0] state, state_nxt;
 logic [10:0] xpos_nxt;
 logic [10:0] ypos_nxt;
 logic [19:0] clock_divider, divider_nxt;;
 logic signed [10:0] dirx, dirx_nxt;
 logic signed [10:0] diry, diry_nxt;
 logic [5:0] angle_counter_x, angle_x_nxt;
 logic [5:0] angle_counter_y, angle_y_nxt;
 logic [5:0] random, random_nxt;
 logic IN_RECT;
 logic LOW_PRECISION;
 logic MEDIUM_PRECISION;
 logic HIGH_PRECISION;
 logic EDGE;
 logic which_edge, which_edge_nxt;



 import vga_pkg::*;


//local parameters
//********************************************************************//
    localparam START = 3'b000;
    localparam PADDLE = 3'b001;
    localparam WALL = 3'b010;
    localparam SCORE = 3'b100;
    localparam [26:0] COUNTER_MAX = 40_000_000;
    localparam RECT_X_POSITION = 30;
    localparam RECT_X_POSITION_2 = HOR_PIXELS - 30;
    localparam RECT_HEIGHT = 100;
    localparam RECT_WIDTH = 20;
    localparam BALL_SIZE = 10;

//procedural
//********************************************************************//
    always_ff @(posedge clk) begin
      if (rst) begin
        dirx <= -1;
        diry <= 1;
        state <= START;
        velocity <= '0;
        counter <= '0;
        xpos <= X_CENTER;
        clock_divider <= '0;
        angle_counter_x <= '0;
        angle_counter_y <= '0;
        random <= '0;
        which_edge <= '0;
      end
      else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        state <= state_nxt;
        velocity <= vel_nxt;
        counter <= counter_nxt;
        clock_divider <= divider_nxt;
        dirx <= dirx_nxt;
        diry <= diry_nxt;
        angle_counter_x <= angle_x_nxt; 
        angle_counter_y <= angle_y_nxt; 
        random <= random_nxt;
        which_edge <= which_edge_nxt;
      end 
    end


  //combinational 
  //********************************************************************//
  always_comb begin
    IN_RECT = ((xpos == RECT_X_POSITION + RECT_WIDTH) && ((ypos >= rect_y_pos - BALL_SIZE) || (ypos >= rect_y_pos)) && ypos <= rect_y_pos + RECT_HEIGHT) || ((xpos == RECT_X_POSITION_2 - RECT_WIDTH - BALL_SIZE) && ((ypos >= rect2_y_pos - BALL_SIZE) || (ypos >= rect2_y_pos)) && ypos <= rect2_y_pos + RECT_HEIGHT);
    MEDIUM_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ((ypos >= rect_y_pos + 15  && ypos <= rect_y_pos + RECT_HEIGHT - 65) || (ypos >= rect_y_pos + 65 && ypos <= rect_y_pos + RECT_HEIGHT - 15))) || (xpos == RECT_X_POSITION_2 - RECT_WIDTH && ((ypos >= rect2_y_pos + 15  && ypos <= rect2_y_pos + RECT_HEIGHT - 65) || (ypos >= rect2_y_pos + 65 && ypos <= rect2_y_pos + RECT_HEIGHT - 15)));
    HIGH_PRECISION = (xpos == RECT_X_POSITION + RECT_WIDTH && ypos >= rect_y_pos + 35 && ypos <= rect_y_pos + RECT_HEIGHT - 35) || (xpos == RECT_X_POSITION_2 - RECT_WIDTH && ypos >= rect2_y_pos + 35 && ypos <= rect2_y_pos + RECT_HEIGHT - 35);
    EDGE = ((xpos <= RECT_X_POSITION + RECT_WIDTH && xpos > RECT_X_POSITION - BALL_SIZE) && (ypos >= rect_y_pos - BALL_SIZE && ypos < rect_y_pos + RECT_HEIGHT)) || ((xpos <= RECT_X_POSITION_2 - RECT_WIDTH - BALL_SIZE && xpos > RECT_X_POSITION_2 + BALL_SIZE) && (ypos >= rect2_y_pos - BALL_SIZE && ypos < rect2_y_pos + RECT_HEIGHT));
  end


  always_comb begin : clock_divide
    if (counter >= COUNTER_MAX) 
      counter_nxt = 0; 
    else 
      if(state==START)
        counter_nxt = counter + 1 + velocity/10;
      else 
        counter_nxt = counter + 1 + velocity; 

    if(clock_divider == 1000000) begin //velocity setup
      divider_nxt = 0;
      if (velocity <= 600)
        vel_nxt = velocity + 60;
      else if (velocity >= 600 && velocity <= 2000)
        vel_nxt = velocity + 2;
      else if (velocity >= 2000 && velocity <= 8000)
        vel_nxt = velocity + 1;
      else 
        vel_nxt = velocity;
    end else begin
      vel_nxt = velocity;
      divider_nxt = clock_divider + 1;
    end

    if(( (dirx == -1) && (ypos >= rect_y_pos + RECT_HEIGHT) ) || ( (dirx == 1) && (ypos >= rect2_y_pos + RECT_HEIGHT) ))
      which_edge_nxt = 0;
    else if(( (dirx == -1) && (ypos < rect_y_pos - BALL_SIZE) ) || ( (dirx == 1) && (ypos < rect2_y_pos - BALL_SIZE) ) )
      which_edge_nxt = 1;
    else
      which_edge_nxt = which_edge;


    case(state)
        START: begin
          if (xpos > 0 && counter >= COUNTER_MAX) begin
            if (IN_RECT || EDGE) begin
              random_nxt = random_4;
              angle_x_nxt = 0;
              angle_y_nxt = 0;
              dirx_nxt = dirx;
              diry_nxt = diry;
              xpos_nxt = xpos;
              ypos_nxt = Y_CENTER;
              state_nxt = PADDLE;
            end else begin
              random_nxt = 0;
              angle_x_nxt = 0;
              angle_y_nxt = 0;
              dirx_nxt = dirx;
              diry_nxt = diry;
              xpos_nxt = xpos + dirx;
              ypos_nxt = Y_CENTER;
              state_nxt = START;
            end
          end else begin
            random_nxt = 0;
            angle_x_nxt = 0;
            angle_y_nxt = 0;
            dirx_nxt = dirx;
            diry_nxt = diry;
            xpos_nxt = xpos;
            ypos_nxt = Y_CENTER;
            state_nxt = START;          
          end
        end
 
        PADDLE: begin
          if (xpos > 0 && xpos < HOR_PIXELS) begin
             if (counter >= COUNTER_MAX) begin

              if(IN_RECT) begin
                angle_x_nxt = 0;
                angle_y_nxt = 0;
                dirx_nxt = - dirx;
                xpos_nxt = xpos - dirx; 
                state_nxt = PADDLE;

                if (HIGH_PRECISION) 
                  random_nxt = random_4 + 20;
                else if (MEDIUM_PRECISION) 
                  random_nxt = random_4 + 10;
                else 
                  random_nxt = random_4 + 2;
                if(random[0] == 1'b0) 
                  diry_nxt = - diry;
                else 
                  diry_nxt = diry;

                ypos_nxt = ypos + diry;
              end else if (EDGE) begin
                random_nxt = 2;
                angle_x_nxt = angle_counter_x;
                angle_y_nxt = angle_counter_y;
                state_nxt = PADDLE;
                dirx_nxt = - dirx;
                xpos_nxt = xpos - dirx;
                if(which_edge) begin
                  diry_nxt = -1;
                  ypos_nxt = ypos - 1;
                end else begin
                  diry_nxt = 1;
                  ypos_nxt = ypos + 1;
                end
              end else if(ypos == 0 || ypos == VER_PIXELS) begin
                random_nxt = random;
                angle_x_nxt = angle_counter_x;
                angle_y_nxt = angle_counter_y;
                state_nxt = WALL;
                dirx_nxt = dirx;
                diry_nxt = diry;
                xpos_nxt = xpos;
                ypos_nxt = ypos;
              end else begin
                random_nxt = random;
                state_nxt = PADDLE;
                dirx_nxt = dirx;
                diry_nxt = diry;

                if(angle_counter_x == 10) begin
                  xpos_nxt = xpos + dirx;
                  angle_x_nxt = 0;
                end else begin
                  xpos_nxt = xpos;
                  angle_x_nxt = angle_counter_x + 1; 
                end

                if(angle_counter_y == random) begin      
                  ypos_nxt = ypos + diry;             
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
              state_nxt = PADDLE;
              dirx_nxt = dirx;
              diry_nxt = diry;
              xpos_nxt = xpos;
              ypos_nxt = ypos;
            end
          end else begin
            random_nxt = 0;
            angle_x_nxt = 0;
            angle_y_nxt = 0;
            state_nxt = SCORE;
            dirx_nxt = dirx;
            diry_nxt = diry;
            xpos_nxt = xpos;
            ypos_nxt = ypos;
          end
        end

        WALL: begin
          if (xpos > 0 && xpos < HOR_PIXELS) begin

            if (counter >= COUNTER_MAX) begin   
              
              if (IN_RECT || EDGE) begin
                random_nxt = random_4;
                angle_x_nxt = 0;
                angle_y_nxt = 0;
                dirx_nxt = dirx;
                diry_nxt = diry;
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                state_nxt = PADDLE;      
              end else begin  
                dirx_nxt = dirx;
                random_nxt = random;
                state_nxt = WALL;   
                
                if(angle_counter_x == 10) begin
                  xpos_nxt = xpos + dirx;
                  angle_x_nxt = 0;
                end else begin
                  xpos_nxt = xpos;
                  angle_x_nxt = angle_counter_x + 1; 
                end

                if(angle_counter_y == random) begin      

                  if (ypos == 0 || ypos == VER_PIXELS) begin
                    diry_nxt = -diry;
                    ypos_nxt = ypos - diry;
                  end else begin
                    diry_nxt = diry;
                    ypos_nxt = ypos + diry;
                  end

                  angle_y_nxt = 0;
                end else begin
                  ypos_nxt = ypos;  
                  diry_nxt = diry;
                  angle_y_nxt = angle_counter_y + 1;  
                end

              end

            end else begin
              random_nxt = random;
              angle_x_nxt = angle_counter_x;
              angle_y_nxt = angle_counter_y;
              state_nxt = WALL;
              dirx_nxt = dirx;
              diry_nxt = diry;
              xpos_nxt = xpos;
              ypos_nxt = ypos; 
            end

          end else begin
            random_nxt = 0;
            angle_x_nxt = 0;
            angle_y_nxt = 0;
            state_nxt = SCORE;
            dirx_nxt = dirx;
            diry_nxt = diry;
            xpos_nxt = xpos;
            ypos_nxt = ypos;   
          end
        end

        SCORE: begin
          random_nxt = 0;
          angle_x_nxt = 0;
          angle_y_nxt = 0;
          dirx_nxt = dirx;
          diry_nxt = diry;
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
          dirx_nxt = dirx;  
          diry_nxt = diry; 
        end

    endcase
  end

//********************************************************************//
endmodule