//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b 
);

//Local variables and signals:


// VGA signals from timing
vga_if vga_tim();

// VGA signals from background
vga_if vga_bg();


//Signals assignments:

assign vs = vga_bg.vsync;
assign hs = vga_bg.hsync;
assign {r,g,b} = vga_bg.rgb;


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

endmodule
