`timescale 1ns / 1ps

module uart_tb;

  // Inputs
  reg sys_clk;
  reg sys_rst_n;

  // Outputs
  wire uart_tx_data;

  // Instantiate the Unit Under Test (UUT)
  uart uut (
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    .uart_tx_data(uart_tx_data)
  );

  // Clock generation
  always #10 sys_clk = ~sys_clk;  // 50 MHz clock (20ns period)

  // Initial block - reset and simulation control
  initial begin
    // Initialize Inputs
    sys_clk = 0;
    sys_rst_n = 0;

    // Apply reset
    #20;  // Wait for 2 clock cycles
    sys_rst_n = 1;
  end

  // Monitor the UART output (optional)
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, uart_tb);
  end

  //Task to monitor uart_tx_data and decode to ASCII

  initial begin
    // After monitor_uart completes, display the received string:
    #100_000_000;
    $finish;
  end



endmodule