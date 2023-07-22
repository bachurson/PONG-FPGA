//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module draw_ball (
    input  logic clk,
    input  logic rst,
    input logic [10:0] x_position,
    input logic [10:0] y_position,
    vga_if.in vga,
    vga_if.out vga_out
);


 logic [11:0] rgb_nxt;
 
 import vga_pkg::*;


//local parameters
//********************************************************************//
    localparam HEIGHT = 10;
    localparam WIDTH = 10;
    localparam COLOR_WHITE = 12'hf_f_f; 

//procedural
//********************************************************************//
    always @(posedge clk) begin
      if (rst) begin
        vga_out.hcount <= '0;
        vga_out.vcount <= '0;
        vga_out.hsync <= '0;
        vga_out.vsync <= '0;
        vga_out.hblnk <= '0;
        vga_out.vblnk <= '0;
        vga_out.rgb <= '0;
      end
      else begin
        vga_out.hcount <= vga.hcount;
        vga_out.vcount <= vga.vcount; 
        vga_out.hsync <= vga.hsync;
        vga_out.vsync <= vga.vsync;
        vga_out.hblnk <= vga.hblnk;
        vga_out.vblnk <= vga.vblnk;
        vga_out.rgb <= rgb_nxt;
      end 
    end


  //combinational 
  //********************************************************************//
  always_comb begin : rect_comb_blk
    if (vga_out.hcount >= x_position && vga_out.hcount <= (x_position+ WIDTH ) && vga_out.vcount >= y_position  && vga_out.vcount <= (y_position+HEIGHT )) rgb_nxt = COLOR_WHITE;

    else 
      rgb_nxt = vga.rgb;
    
  end

//********************************************************************//
endmodule