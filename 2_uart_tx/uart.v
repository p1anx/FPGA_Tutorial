module uart
(
    sys_clk,
    sys_rst_n,

    uart_tx_data

);
input           sys_clk;
input           sys_rst_n;
output          uart_tx_data;

wire timer_flag;
wire tx_cmp_flag;

parameter DATA_LENGTH = 3;

reg [7:0] pi_data [DATA_LENGTH-1:0];

reg [7:0] tx_data;

initial begin
    pi_data[0] <= "h";
    // pi_data[1] <= "e";
    // pi_data[2] <= "l";
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)
        tx_data <= pi_data[0];
    else
        tx_data <= pi_data[0];
end


uart_tx_nbyte u_uart_tx1
(
   .sys_clk    (sys_clk),
   .sys_rst_n  (sys_rst_n),   //全局复位
   .pi_data    (tx_data),   //模块输入的8bit数据
   .pi_flag    (timer_flag),   //并行数据有效标志信号
   .baudrate   (9600),
   .n_byte     (1),
 
   .tx         (uart_tx_data),  //串转并后的1bit数据
   .tx_cmp_flag(tx_cmp_flag)

);
timer
#(
    .HZ (1000)
)
timer1
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .timer_flag(timer_flag)
);
endmodule