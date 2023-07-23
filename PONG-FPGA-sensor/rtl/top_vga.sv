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


// VGA signals from timing
vga_if vga_tim();

// VGA signals from background
vga_if vga_bg();

// VGA signals from draw_rect
vga_if vga_rct();

//Signals assignments:

assign vs = vga_rct.vsync;
assign hs = vga_rct.hsync;
assign {r,g,b} = vga_rct.rgb;


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

    .btn_out(btnu_debounced)
);

debouncer u_button_down (
    .clk(clk),
    .rst(rst),
    .btn(btnd),

    .btn_out(btnd_debounced)
);

btn_synchro u_button_synchro (
    .clk,
    .rst,
    .btnu(btnu_debounced),
    .btnd(btnd_debounced),

    .btn_up,
    .btn_down

);

draw_rect u_draw_rect (
    .clk,
    .rst,
    .btn_up,
    .btn_down,

    .vga(vga_bg),
    .vga_out(vga_rct)
);

endmodule
