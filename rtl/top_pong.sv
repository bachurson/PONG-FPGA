//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_pong (
    input  logic clk,
    input  logic rst,
    input  logic btnd,
    input  logic btnu,
    output logic TxD 
);

//Local variables and signals:

logic btn_up;
logic btn_down;


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

//if we want paddle move on click
/*btn_synchro u_button_synchro (
    .clk,
    .rst,
    .btnu(btnu_debounced),
    .btnd(btnd_debounced),

    .btn_up,
    .btn_down

);*/

TxD u_TxD(
    .clk(clk),
    .rst(rst),
    .btnU(btn_up),
    .btnD(btn_down),
    .TxD(TxD)
);




endmodule
