module  timer_start
#(
    parameter HZ = 1
)
(
    input       wire        sys_clk,
    input       wire        sys_rst_n,
    input       wire        timer_start_flag,

    output      reg         timer_flag
);

parameter TIMER_CNT_MAX = 50_000_000 / HZ;

reg [25:0] timer_cnt;
reg        timer_en;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        timer_en <= 0;
    else if(timer_start_flag == 1)
        timer_en <= 1;
    else if(timer_flag == 1)
        timer_en <= 0;
    else
        timer_en <= timer_en;

end
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        timer_cnt <= 0;
    else if(timer_cnt == TIMER_CNT_MAX - 1)
        timer_cnt <= 0;
    else if(timer_en == 1)
        timer_cnt <= timer_cnt + 1;
    else
        timer_cnt <= timer_cnt;
    
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        timer_flag <= 0;
    else if(timer_cnt == TIMER_CNT_MAX - 2)
        timer_flag <= 1;
    else 
        timer_flag <= 0;
    
end




endmodule