`timescale 1ns/1ns

module uart_tx_nbyte_tb;

parameter PERIOD = 20; //ns
parameter RUN_TIME = 2000_000*2; //4ms

reg sys_clk;
reg sys_rst_n;

reg [7:0] pi_data;
reg       pi_flag;
wire      tx;
wire      tx_cmp_flag;

initial begin
  pi_data <= "h";
  #1000_000
  pi_data <= "e";
end

initial begin
  pi_flag <= 0;
  #100
  pi_flag <= 1;
  #PERIOD
  pi_flag <= 0;

end


uart_tx_nbyte uart_tx1
(
   .sys_clk    (sys_clk),
   .sys_rst_n  (sys_rst_n),   //全局复位
   .pi_data    (pi_data),   //模块输入的8bit数据
   .pi_flag    (pi_flag),   //并行数据有效标志信号
   .baudrate   (9600),
   .n_byte      (3),
 
   .tx         (tx),  //串转并后的1bit数据
   .tx_cmp_flag(tx_cmp_flag)

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
    $dumpvars(0, uart_tx_nbyte_tb);
end
//*******************************************
endmodule