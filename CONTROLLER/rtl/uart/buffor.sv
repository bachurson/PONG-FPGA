//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module buffor (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] input_data,
    output logic [7:0] data_buffored
);

logic [7:0] data_buf;

always_ff @(posedge clk) begin
    if (rst) begin
        data_buffored <= '0;
        data_buf <= '0;
    end
    else begin
        data_buffored <= data_buf;
        data_buf <= input_data;
    end
end


endmodule
