//Author: Dominik Bachurski

`timescale 1 ns / 1 ps


module debouncer (
    input logic clk,
    input logic rst,
    input logic btn,
    output logic btn_out
);

logic [19:0] btn_cnt;
logic [19:0] btn_cnt_nxt;
logic btn_nxt;

always @(posedge clk) begin
    if (rst) begin
        btn_cnt <= '0;
        btn_out <= '0;
    end
    else begin
        btn_cnt <= btn_cnt_nxt;
        btn_out <= btn_nxt;
    end
end

always_comb begin
    if (btn==1) begin
        if (btn_cnt == 20'h9EAD0) begin
            btn_nxt = '1;
            btn_cnt_nxt = '0;
        end else begin
            btn_cnt_nxt = btn_cnt + 1;
            btn_nxt = btn_out;
        end
    end else begin
        btn_nxt = '0;
        btn_cnt_nxt = '0;
    end
end


endmodule 