//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_pong_basys3 (
    input wire clk,
    input wire btnC,
    input wire btnD,
    input wire btnU,
    output wire JA1,
    output wire TxD
);


//Local variables and signals

wire pclk;
wire locked;
wire pclk_mirror;
wire btn_right;



//Signals assignments

assign JA1 = pclk_mirror;


//FPGA submodules placement

clk_wiz_0  clk_wiz_0_my(
    .clk(clk),
    .clk_65MHz(pclk),
    .locked(locked)
 );


ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


//Project functional top module
 

top_pong u_top_pong (
    //inputs
    .clk(pclk),
    .rst(btnC),
    .btnu(btnU),
    .btnd(btnD),
    //outputs
    .TxD(TxD)
);



endmodule
