//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input wire clk,
    input wire btnC,
    input wire btnD,
    input wire btnU,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1
);


//Local variables and signals

wire pclk;
wire locked;
wire pclk_mirror;


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
 

top_vga u_top_vga (
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
    .vs(Vsync)
);

endmodule
