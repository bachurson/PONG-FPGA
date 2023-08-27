//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_pong (
    input  logic clk,
    input  logic rst,
    input  logic btnd,
    input  logic btnu,
    input logic RxD,
    input logic echo,  
    input logic echo_second,
    input logic mode,
    input logic mode_2,
    input logic mode_3,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic trig,
    output logic [7:0] RxData,
    output logic TxD,
    output logic trig_second
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
logic [3:0] points_first_player;
logic [3:0] points_second_player;
logic [7:0] measured_distance;
logic [7:0] measured_distance_second;
logic [7:0] compared_position;
logic [7:0] data_buffored;
logic score_flag;
//logic [7:0] RxData;
logic [7:0] buff;

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

debounce u_button_up (
    .clk(clk),
    .rst(rst),
    .btn(btnu),

    .btn_out(btn_up)
);

debounce u_button_down (
    .clk(clk),
    .rst(rst),
    .btn(btnd),

    .btn_out(btn_down)
);

draw_rect u_draw_rect (
    .clk,
    .rst,
    .btn_up,
    .btn_down,
    .mode(mode),
    .pos(compared_position),
    .vga(vga_bg),

    .y_position(rect_y_pos),
    .vga_out(vga_rct)
);

draw_rect_2 u_draw_rect_2 (
    .clk,
    .rst,
    .ball_y_pos(ball_ypos),
    .mode_2(mode_2),
    .mode_3(mode_3),
    .pos(data_buffored),
    .vga(vga_rct),

    .y_position(rect2_y_pos),
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
    
    .score_flag(score_flag),
    .xpos(ball_xpos),
    .ypos(ball_ypos),
    .points_first_player(points_first_player),
    .points_second_player(points_second_player)

);

draw_ball u_draw_ball (
    .clk,
    .rst,
    .x_position(ball_xpos),
    .y_position(ball_ypos),
    
    .vga(vga_rct2),
    .vga_out(vga_ball)
);

seg7_display seg7_display (
    .clk(clk),
    .rst(rst),
    .points_first_player(points_first_player),
    .points_second_player(points_second_player),

    .seg(seg),
    .an(an)
);

uart_rx u_uart_rx (
    .clk(clk),
    .mode(mode_3),
    .rst(rst),
    .RxD(RxD),

    .RxData(RxData)
);


sensor u_sensor (
    .clk(clk),
    .rst(rst),
    .echo(echo),

    .trig(trig),
    .distance(measured_distance)
);


sensor u_sensor_second (
    .clk(clk),
    .rst(rst),
    .echo(echo_second),

     .trig(trig_second),
    .distance(measured_distance_second)
);

compare_pos u_compare_pos (
    .clk(clk),
    .rst(rst),
    .pos(measured_distance),
    .pos_second(measured_distance_second),

    .y_position(compared_position)
);

buffor u_buffor (
    .clk(clk),
    .rst(rst),
    .input_data(RxData),
    .mode(mode_3),

    .data_buffored(buff)
);

buffor u_buffor_2 (
    .clk(clk),
    .rst(rst),
    .input_data(buff),
    .mode(mode_3),

    .data_buffored(data_buffored)
);

TxD u_TxD(
    .clk(clk),
    .rst(rst),
    .points_first_player(points_first_player),
    .points_second_player(points_second_player),
    .flag_transmit(score_flag),

    .TxD(TxD)
);

endmodule
