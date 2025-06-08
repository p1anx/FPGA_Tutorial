`timescale 1ns / 1ps

module test_uart_tx_tb;
    // 参数配置
    localparam CLK_FREQ = 100_000_000;  // 100 MHz
    localparam BAUD_RATE = 115200;
    localparam DATA_BITS = 8;
    localparam STOP_BITS = 1;
    localparam PARITY = "NONE";
    
    // 计算一个bit的时间 (ns)
    localparam BIT_TIME = 1_000_000_000 / BAUD_RATE;
    
    // 信号定义
    reg clk = 0;
    reg reset = 1;
    reg tx_start = 0;
    reg [DATA_BITS-1:0] tx_data = 0;
    wire tx;
    wire tx_busy;
    
    // 实例化UART发送模块
    test_uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .DATA_BITS(DATA_BITS),
        .STOP_BITS(STOP_BITS),
        .PARITY(PARITY)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    
    // 时钟生成 (100 MHz)
    always #5 clk = ~clk;
    
    // 接收到的数据存储
    reg [DATA_BITS-1:0] received_data = 0;
    integer bit_count = 0;
    
    // UART接收模拟
    always @(negedge tx) begin
        if (tx_busy) begin
            // 检测到起始位
            #(BIT_TIME/2); // 等待到bit中间采样
            
            // 接收数据位
            for (bit_count = 0; bit_count < DATA_BITS; bit_count = bit_count + 1) begin
                #BIT_TIME;
                received_data[bit_count] = tx;
            end
            
            // 如果有校验位，跳过
            if (PARITY != "NONE") begin
                #BIT_TIME;
            end
            
            // 跳过停止位
            #(BIT_TIME * STOP_BITS);
            
            $display("[%0t] Received data: 0x%h", $time, received_data);
        end
    end
    
    // 测试流程
    initial begin
        // 初始化
        reset = 1;
        #100;
        reset = 0;
        #100;
        
        // 测试1: 发送0x55
        tx_data = 8'h55;
        tx_start = 1;
        #10;
        tx_start = 0;
        wait(!tx_busy);
        #100;
        
        // 测试2: 发送0xAA
        tx_data = 8'hAA;
        tx_start = 1;
        #10;
        tx_start = 0;
        wait(!tx_busy);
        #100;
        
        // 测试3: 发送0x00
        tx_data = 8'h00;
        tx_start = 1;
        #10;
        tx_start = 0;
        wait(!tx_busy);
        #100;
        
        // 测试4: 发送0xFF
        tx_data = 8'hFF;
        tx_start = 1;
        #10;
        tx_start = 0;
        wait(!tx_busy);
        #100;
        
        $finish;
    end
    
    // 波形记录
    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, test_uart_tx_tb);
    end
endmodule