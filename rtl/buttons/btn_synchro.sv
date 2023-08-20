//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module btn_synchro(
    input logic clk,
    input logic rst,
    input logic btnu,
    //input logic btnd,
    output logic btn_up
   // output logic btn_down
);

logic btnu_prev;
//logic btnd_prev;

always @(posedge clk) begin
    if (rst) begin
        btnu_prev <= 0;
       // btnd_prev <= 0;
        btn_up <= 0;
       // btn_down <= 0;
    end
    else begin
        btn_up <= (btnu == 1 && btnu_prev == 0);
      //  btn_down <= (btnd == 1 && btnd_prev == 0);
        btnu_prev <= btnu;
      //  btnd_prev <= btnd;
       
    end
end

endmodule