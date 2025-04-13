`timescale 1ns/1ns
module led #(
    parameter CNT_MAX = 20'd999_999
) (
    input wire  sys_clk,
    input wire  sys_rst_n,

    // output reg  key_flag
    output  reg led
);

wire  timer_flag;
timer
#(
    .HZ (1)
)
timer1
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .timer_flag(timer_flag)
);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        led <= 1;
    else if(timer_flag == 1)
        led <= ~led;
    else 
        led <= led;
end


endmodule