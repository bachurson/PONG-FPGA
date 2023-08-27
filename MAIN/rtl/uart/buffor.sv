//Author: Dominik Bachurski

`timescale 1 ns / 1 ps

module buffor (
    input  logic clk,
    input  logic rst,
    input  logic mode,
    input  logic [7:0] input_data,
    output logic [7:0] data_buffored
);

logic [7:0] data_buf;
logic [7:0] data_buf_nxt;
logic [7:0] data_prev;
logic flag, flag_nxt;

always_ff @(posedge clk) begin
    if (rst) begin
        data_buffored <= '0;
        data_buf <= '0;
        data_prev <= '0;
        flag <= '0;
    end
    else begin
        data_buffored <= data_buf;
        data_buf <= data_buf_nxt;
        data_prev <= input_data;
        flag <= flag_nxt;
    end
end

always_comb begin

    if(mode == 0) begin

        if(input_data != data_prev) begin

            if (flag == 0) begin
                data_buf_nxt = input_data;
                flag_nxt = 1;
            end else begin
                flag_nxt = 1;
                data_buf_nxt = '1;
            end

        end else begin
            flag_nxt = 0;
            data_buf_nxt = '1;
        end

    end 
    else begin
        data_buf_nxt = input_data;
        flag_nxt = 0;
    end

end

endmodule
