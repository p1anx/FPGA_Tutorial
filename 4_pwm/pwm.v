module pwm
#(
    parameter PERIOD_HZ = 1000,
    parameter DUTY   = 0.5
)
(
    input       wire        sys_clk,
    input       wire        sys_rst_n,

    output      reg         pwm_out

);

parameter integer PERIOD_MAX = 50_000_000 / PERIOD_HZ;
parameter integer DUTY_MAX   = PERIOD_MAX * DUTY;
reg  [25:0]   pwm_period_cnt;
reg  [25:0]   pwm_duty_cnt;

reg           pwm_period_flag;
reg           pwm_duty_flag;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        pwm_period_cnt <= 0;
    else if(pwm_period_cnt == PERIOD_MAX - 1)
        pwm_period_cnt <= 0;
    else 
        pwm_period_cnt <= pwm_period_cnt + 1;
end



always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        pwm_period_flag <= 0;
    else if(pwm_period_cnt == PERIOD_MAX - 2)
        pwm_period_flag <= 1;
    else
        pwm_period_flag <= 0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        pwm_duty_cnt <= 0;
    else if(pwm_duty_cnt == DUTY_MAX -1 && pwm_period_flag == 1)
        pwm_duty_cnt <= 0;
    else if(pwm_duty_cnt < DUTY_MAX - 1)
        pwm_duty_cnt <= pwm_duty_cnt + 1;
    else
        pwm_duty_cnt <= pwm_duty_cnt;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        pwm_duty_flag <= 0;
    else if(pwm_duty_cnt == DUTY_MAX - 2)
        pwm_duty_flag <= 1;
    else
        pwm_duty_flag <= 0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        pwm_out <= 0;
    else if(pwm_period_flag == 1)
        pwm_out <= 1;
    else if(pwm_duty_flag == 1)
        pwm_out <= 0;
    else 
        pwm_out <= pwm_out;
end



endmodule