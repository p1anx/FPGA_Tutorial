`timescale 1ns/1ns

module pwm_tb;

parameter  PERIOD = 20; //20ns-->50MHz

reg sys_clk;
reg sys_rst_n;

wire pwm_out;


initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #PERIOD
    sys_rst_n <= 1'b1;
    #100_000_000 //run time is 100ms
    $stop;
end

always #(PERIOD/2) sys_clk = ~sys_clk;


pwm
#(
    .PERIOD_HZ (1000),
    .DUTY   (0.3)
)
pwm1
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .pwm_out(pwm_out)

);
//for iverilog compilation
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, pwm_tb);
end

endmodule