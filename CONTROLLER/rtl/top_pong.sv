//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_pong (
    input  logic clk,
    input  logic rst,
    input  logic btnd,
    input  logic btnu,
    input logic mode,
    input logic echo,  
    input logic echo_second,
    input logic RxD,
    output logic TxD,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic trig,
    output logic trig_second
);

//Local variables and signals:

logic btn_up;
logic btn_down;
logic [7:0] RxData;
logic btnU;
logic btnD;
logic [7:0] measured_distance;
logic [7:0] measured_distance_second;
logic flag;
logic [7:0] compared_position;
logic [7:0] buff;
logic [7:0] data_buffored;

//Submodules instances:

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

TxD u_TxD(
    .clk(clk),
    .rst(rst),
    .mode(mode),
    .flag_transmit(flag),
    .pos(compared_position),
    .btnU(btn_up),
    .btnD(btn_down),

    .TxD(TxD)
);

sensor u_sensor (
    .clk(clk),
    .rst(rst),
    .echo(echo),

    .trig(trig),
    .distance(measured_distance),
    .flag(flag)
);

sensor u_sensor_second (
    .clk(clk),
    .rst(rst),
    .echo(echo_second),

    .trig(trig_second),
    .distance(measured_distance_second),
    .flag(flag_second)
);

compare_pos u_compare_pos (
    .clk(clk),
    .rst(rst),
    .pos(measured_distance),
    .pos_second(measured_distance_second),
    
    .y_position(compared_position)
);

uart_rx u_uart_rx (
    .clk(clk),
    .rst(rst),
    .RxD(RxD),

    .RxData(RxData)
);

buffor u_buffor (
    .clk(clk),
    .rst(rst),
    .input_data(RxData),

    .data_buffored(buff)
);

buffor u_buffor_2 (
    .clk(clk),
    .rst(rst),
    .input_data(buff),

    .data_buffored(data_buffored)
);

seg7_display seg7_display (
    .clk(clk),
    .rst(rst),
    .points(data_buffored),

    .seg(seg),
    .an(an)
);



endmodule
