`timescale 1ns/1ns

module timer_start_tb;

parameter PERIOD = 20;
parameter RUN_TIME = 2000_000; //1ms

reg sys_clk;
reg sys_rst_n;

reg timer_start_flag;

wire  timer_flag;


// always @(posedge sys_clk or negedge sys_rst_n) begin

    
// end


initial begin
    timer_start_flag <= 0;
    #100
    timer_start_flag <= 1;
    #PERIOD
    timer_start_flag <= 0;
end

timer_start
#(
    .HZ (1000)
)
timer1
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .timer_start_flag(timer_start_flag),

    .timer_flag(timer_flag)
);
//*******************************************
//set sys_clk
initial begin
    sys_clk = 0;
    forever begin
        #(PERIOD/2) sys_clk <= ~sys_clk;
    end
end

//set reset
initial begin
    sys_rst_n = 0;
    #PERIOD
    sys_rst_n = 1;
end

//set run time of system
initial begin
    #RUN_TIME
    $stop;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, timer_start_tb);
end
//*******************************************
endmodule