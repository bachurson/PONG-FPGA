//Author: Dominik Bachurski

interface vga_if;

logic [10:0] vcount, hcount;
logic vsync;
logic vblnk;   
 
logic hsync;   
logic hblnk; 

logic [11:0] rgb;  

modport in (
    input vcount, hcount, vsync, hsync, vblnk, hblnk, rgb
 );
 
 modport out (
    output vcount, hcount, vsync, hsync, vblnk, hblnk, rgb
 );

   
endinterface
