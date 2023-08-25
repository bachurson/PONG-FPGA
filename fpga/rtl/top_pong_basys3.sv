//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_pong_basys3 (
    input wire clk,
    input wire btnC,
    input wire btnD,
    input wire btnU,
    input wire echo,
    input wire echo_second,
    input wire RxD,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire trig,
    output wire trig_second,
    output wire [7:0] RxData
);


//Local variables and signals

wire pclk;
wire locked;
wire pclk_mirror;
wire [7:0] rxData;

//Signals assignments

assign JA1 = pclk_mirror;
assign RxData = rxData;

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
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .an(an),
    .seg(seg),
    .echo(echo),
    .trig(trig),
     .echo_second(echo_second),
    .trig_second(trig_second),
    .RxD(RxD),
    .RxData(rxData)
);

endmodule
