//Author: Dominik Bachurski

`timescale 1 ns / 1 ps
 
module draw_bg (
    input  logic clk,
    input  logic rst,
    
    vga_if.in vga,
    vga_if.out vga_out
);

import vga_pkg::*;


//Local variables and signals

logic [11:0] rgb_nxt;


//Internal logic

always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
    end else begin
        vga_out.vcount <= vga.vcount;
        vga_out.vsync  <= vga.vsync;
        vga_out.vblnk  <= vga.vblnk;
        vga_out.hcount <= vga.hcount;
        vga_out.hsync  <= vga.hsync;
        vga_out.hblnk  <= vga.hblnk;
        vga_out.rgb    <= rgb_nxt;
    end 
end
 
always_comb begin : bg_comb_blk
    if (vga.vblnk || vga.hblnk)                                                             // Blanking region:
        rgb_nxt = 12'h0_0_0;                                                                // - make it it black.
    else                                                                                    // Active region:       
        if (vga.hcount >= 511 && vga.hcount <= 513 && (vga.vcount / 10) % 2 == 0)           // - middle of the screen:
            rgb_nxt = 12'hf_f_f;                                                            // - make it white.
        
        else                                                                                // Rest of active display pixels:
            rgb_nxt = 12'h0_0_0;                                                            // - fill with black.

end

endmodule
