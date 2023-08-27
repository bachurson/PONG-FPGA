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
    input wire [2:0] sw,
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
    output wire [7:0] RxData,
    output wire TxD,
    output wire reset
);


//Local variables and signals

wire pclk;
wire locked;
wire pclk_mirror;
wire [7:0] rxData;

//Signals assignments

assign RxData = rxData;
assign JA1 = pclk_mirror;
assign reset = btnC;

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
    .echo(echo),
    .echo_second(echo_second),
    .mode(sw[0]),
    .mode_2(sw[1]),
    .mode_3(sw[2]),
    .RxD(RxD),
    //outputs
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .an(an),
    .seg(seg),
    .trig(trig),
    .TxD(TxD),
    .trig_second(trig_second),
    .RxData(rxData)
);

endmodule
