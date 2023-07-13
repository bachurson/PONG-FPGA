//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,
    
    vga_if.out vga_out
);


import vga_pkg::*;


logic [10:0] vcount_nxt, hcount_nxt;
logic hsync_nxt, vsync_nxt, hblnk_nxt, vblnk_nxt;


//********************************************************************//
always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.hcount <= 0;
        vga_out.vcount <= 0;
        vga_out.hsync <= 0;
        vga_out.vsync <= 0;
        vga_out.hblnk <= 0;
        vga_out.vblnk <= 0;
        vga_out.rgb <= 0;
    end
    else begin
        vga_out.hcount <= hcount_nxt;
        vga_out.vcount <= vcount_nxt;
        vga_out.hsync <= hsync_nxt;
        vga_out.vsync <= vsync_nxt;
        vga_out.hblnk <= hblnk_nxt;
        vga_out.vblnk <= vblnk_nxt;
    end
end
//********************************************************************//

//Logical
//********************************************************************//

always_comb begin
    //Horizontal counter
    if(vga_out.hcount == HOR_TOTAL_TIME-1) hcount_nxt = 10'b0;
        else hcount_nxt = vga_out.hcount + 1;
    
    //Vertical counter
    if(vga_out.hcount == (HOR_TOTAL_TIME-1) && vga_out.vcount == (VER_TOTAL_TIME-1)) 
        vcount_nxt = 10'b0;
    else if (vga_out.hcount == (HOR_TOTAL_TIME-1)) 
        vcount_nxt = vga_out.vcount + 1;
    else 
        vcount_nxt = vga_out.vcount;
        
    //Synchronization time
    if (vga_out.hcount >= (HOR_SYNC_START-1) && vga_out.hcount <= (HOR_SYNC_START+HOR_SYNC_TIME-2)) 
        hsync_nxt = 1;
    else 
        hsync_nxt = 0;
        
    if (vga_out.vcount == (VER_SYNC_START - 1) && vga_out.hcount == (HOR_TOTAL_TIME-1)) 
        vsync_nxt = 1;
    else if (vga_out.vcount >= (VER_SYNC_START) && vga_out.vcount <= (VER_SYNC_START + VER_SYNC_TIME - 2)) 
        vsync_nxt = 1;
    else if (vga_out.vcount == (VER_SYNC_START + VER_SYNC_TIME - 1) && vga_out.hcount <= (HOR_TOTAL_TIME - 2)) 
        vsync_nxt = 1;
    else if (vga_out.vcount == (VER_SYNC_START + VER_SYNC_TIME - 1) && vga_out.hcount <= (HOR_TOTAL_TIME - 1)) 
        vsync_nxt = 0;
    else 
        vsync_nxt = 0;
        
    //Blank spaces
    if (vga_out.hcount >= (HOR_BLANK_START-1) && vga_out.hcount <= (HOR_BLANK_START+HOR_BLANK_TIME-2)) 
        hblnk_nxt = 1;
    else
        hblnk_nxt = 0;
    
    if (vga_out.vcount == (VER_BLANK_START - 1) && vga_out.hcount == (HOR_TOTAL_TIME-1)) 
        vblnk_nxt = 1;
    else if (vga_out.vcount >= (VER_BLANK_START) && vga_out.vcount <= (VER_BLANK_START + VER_BLANK_TIME - 2)) 
        vblnk_nxt = 1;
    else if (vga_out.vcount == (VER_BLANK_START + VER_BLANK_TIME - 1) && vga_out.hcount <= (HOR_TOTAL_TIME - 2)) 
        vblnk_nxt = 1;
    else if (vga_out.vcount == (VER_BLANK_START + VER_BLANK_TIME - 1) && vga_out.hcount <= (HOR_TOTAL_TIME - 1)) 
        vblnk_nxt = 0;
    else 
        vblnk_nxt = 0;   
        
end


endmodule
