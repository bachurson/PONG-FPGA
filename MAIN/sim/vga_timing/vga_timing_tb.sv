/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module. Zmodyfikowany testbench z zajêæ
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

vga_if vga_tim();
import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 15.3846; // 65 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

logic [10:0] vcount, hcount;
logic        vsync,  hsync;
logic        vblnk,  hblnk;


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing u_vga_timing(
    .clk(clk),
    .rst(rst),
    .vga_out(vga_tim)
);

/**
 * Tasks and functions
 */


always begin
    #37;
    assert (vga_tim.hcount <= HOR_TOTAL_TIME) //$display ("OK. Is lower: hcount %d, HOR_TOTAL_TIME %d ", hcount, HOR_TOTAL_TIME);
         else $error("Exceeded: hcount %d, HOR_TOTAL_TIME %d", vga_tim.hcount, HOR_TOTAL_TIME);
    assert (vga_tim.vcount <= VER_TOTAL_TIME) //$display ("OK. Is lower: vcount %d, VER_TOTAL_TIME %d ", vcount, VER_TOTAL_TIME);
         else $error("Exceeded: vcount %d, VER_TOTAL_TIME %d", vga_tim.vcount , VER_TOTAL_TIME);
end
/**
 * Assertions
 */

// Here you can declare concurrent assertions (assert property).


/**
 * Main test
 */

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (vga_tim.vsync == 1'b0);
    @(negedge vga_tim.vsync)
    @(negedge vga_tim.vsync)

    $finish;
end

endmodule