module uart_tx_num
#(
    parameter TIME_MS = 1_000 //time unit: ms

)
(
    input wire  sys_clk,
    input wire  sys_rst_n,
    output wire tx
    // output reg  led
);
parameter MAX_TIMER_COUNT = (50_000_000)/(1_000) * TIME_MS - 1;
reg         pi_flag;
reg [25:0]  timer_count;

reg [7:0]   pi_data = 8'd9;
// it's bad using the following method
// initial begin
//     pi_data <= 8'd9;
// end

//delay count
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        timer_count <= 1'b0;
    else if(timer_count == MAX_TIMER_COUNT)begin
        timer_count <= 1'b0;
    end
    else begin
        timer_count <= timer_count + 1'b1;
    end
end

// reg [0:0] delay_flag;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0) begin
        pi_flag <= 1'b0;
        // delay_flag <= 1'b0;
    end
    else if(timer_count == MAX_TIMER_COUNT)
        pi_flag <= 1'b1;
    else
        pi_flag <= 1'b0;
end

// led
// reg        led;
// always @(posedge sys_clk or negedge sys_rst_n) begin
//     if(!sys_rst_n)begin
//         led <= 1'b0;
//     end
//     else if(pi_flag == 1) begin
//         led <= ~led;
//     end
//     else 
//         led <= led;
// end


uart_tx
#(
    .UART_BPS(115200),         //串口波特率
    .CLK_FREQ(50_000_000)      //时钟频率
)
u_uart_inst
(
     .sys_clk    (sys_clk),   //系统时钟50MHz
     .sys_rst_n  (sys_rst_n),   //全局复位
     .pi_data    (pi_data),   //模块输入的8bit数据
     .pi_flag    (pi_flag),   //并行数据有效标志信号
 
     .tx         (tx)    //串转并后的1bit数据
);
endmodule