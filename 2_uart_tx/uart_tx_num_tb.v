`timescale 1ns/1ps
module uart_tx_num_tb;

reg     sys_clk;
reg     sys_rst_n;
wire    tx;

initial begin
    sys_clk = 0;
    sys_rst_n = 0;
    #10
    sys_rst_n = 1;
end

always #10 sys_clk = ~sys_clk;

uart_tx_num
#(
    .TIME_MS(1) //time unit: ms
)
uart_inst 
(
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .tx        (tx)
);
initial begin
    #2_000_000
    $stop;
end

initial begin
    $dumpfile("build/wave.vcd");
    $dumpvars(0, uart_tx_num_tb);
end

endmodule