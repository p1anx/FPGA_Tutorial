`timescale 1ns/1ns
module key #(
    parameter CNT_MAX = 20'd999_999
) (
    input wire  sys_clk,
    input wire  sys_rst_n,
    input wire  key_in,

    output reg  key_flag
    // output  reg led
);

reg [19:0] cnt_20ms;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 1'b0)
        cnt_20ms <= 20'd0;
    else if(key_in == 1'b1)
        cnt_20ms <= 20'd0;
    else if(cnt_20ms == CNT_MAX && key_in == 1'b0)
        cnt_20ms <= cnt_20ms;
    else 
        cnt_20ms <= cnt_20ms + 1'b1;
    
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        key_flag <= 0;
    else if(cnt_20ms ==CNT_MAX -1)
        key_flag <= 1;
    else
        key_flag <= 0;
end


endmodule