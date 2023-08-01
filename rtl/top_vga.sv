//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic rst,
    input  logic btnd,
    input  logic btnu,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b 
);

//Local variables and signals:
logic btn_up;
logic btn_down;
logic [10:0] rect_y_pos;
logic [10:0] rect2_y_pos;
logic [10:0] ball_xpos;
logic [10:0] ball_ypos;
logic [1:3] random_3;
logic [1:4] random_4;
logic [1:5] random_5;

// VGA signals from timing
vga_if vga_tim();

// VGA signals from background
vga_if vga_bg();

// VGA signals from draw_rect
vga_if vga_rct();

// VGA signals from draw_rect_2
vga_if vga_rct2();

// VGA signals from draw_ball
vga_if vga_ball();

//Signals assignments:

assign vs = vga_ball.vsync;
assign hs = vga_ball.hsync;
assign {r,g,b} = vga_ball.rgb;


//Submodules instances:

vga_timing u_vga_timing (
    .clk,
    .rst,
    .vga_out(vga_tim)
);

draw_bg u_draw_bg (
    .clk,
    .rst,

    .vga(vga_tim),
    .vga_out(vga_bg)
);


debouncer u_button_up (
    .clk(clk),
    .rst(rst),
    .btn(btnu),

    .btn_out(btn_up)
);

debouncer u_button_down (
    .clk(clk),
    .rst(rst),
    .btn(btnd),

    .btn_out(btn_down)
);

//if we want paddle move on click
/*btn_synchro u_button_synchro (
    .clk,
    .rst,
    .btnu(btnu_debounced),
    .btnd(btnd_debounced),

    .btn_up,
    .btn_down

);*/

draw_rect u_draw_rect (
    .clk,
    .rst,
    .btn_up,
    .btn_down,

    .y_position(rect_y_pos),
    .vga(vga_bg),
    .vga_out(vga_rct)
);

draw_rect_2 u_draw_rect_2 (
    .clk,
    .rst,
    .ball_y_pos(ball_ypos),

    .y_position(rect2_y_pos),
    .vga(vga_rct),
    .vga_out(vga_rct2)
);


random #(.N(4)) u_random_4 (
    .clk,
    .rst(btn_down),
    
    .Q(random_4)
);


ball_ctl u_ball_ctl (
    .clk,
    .rst,
    .rect_y_pos,
    .rect2_y_pos(rect2_y_pos),
    .random_4,
    
    .xpos(ball_xpos),
    .ypos(ball_ypos)

);

draw_ball u_draw_ball (
    .clk,
    .rst,
    .x_position(ball_xpos),
    .y_position(ball_ypos),
    
    .vga(vga_rct2),
    .vga_out(vga_ball)
);

endmodule
