module test_uart_tx #(
    parameter CLK_FREQ = 100_000_000,  // 时钟频率 (Hz)
    parameter BAUD_RATE = 115200,       // 波特率
    parameter DATA_BITS = 8,            // 数据位 (5-9)
    parameter STOP_BITS = 1,            // 停止位 (1或2)
    parameter PARITY = "NONE"           // 校验位 ("NONE", "ODD", "EVEN")
) (
    input wire clk,
    input wire reset,
    input wire tx_start,                // 发送启动信号
    input wire [DATA_BITS-1:0] tx_data, // 发送数据
    output reg tx,                      // UART 发送线
    output wire tx_busy                 // 发送忙标志
);

    // 计算波特率分频系数
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;
    localparam BIT_COUNTER_WIDTH = $clog2(BIT_PERIOD);
    
    // 状态定义
    typedef enum logic [2:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        PARITY_BIT,
        STOP_BIT
    } state_t;
    
    reg [BIT_COUNTER_WIDTH-1:0] bit_counter = 0;
    reg [2:0] bit_index = 0;
    reg [DATA_BITS-1:0] data_reg = 0;
    reg parity_bit = 0;
    state_t state = IDLE;
    
    // 忙标志输出
    assign tx_busy = (state != IDLE);
    
    // 奇偶校验计算
    function automatic logic calc_parity(input [DATA_BITS-1:0] data);
        logic result;
        result = ^data; // 异或所有位
        if (PARITY == "ODD") result = ~result;
        return result;
    endfunction
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1; // 空闲状态为高电平
            bit_counter <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        state <= START_BIT;
                        data_reg <= tx_data;
                        bit_counter <= 0;
                        // 预计算奇偶校验位
                        if (PARITY != "NONE") begin
                            parity_bit <= calc_parity(tx_data);
                        end
                    end
                end
                
                START_BIT: begin
                    tx <= 1'b0; // 起始位为低电平
                    if (bit_counter == BIT_PERIOD - 1) begin
                        state <= DATA_BITS;
                        bit_counter <= 0;
                        bit_index <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                DATA_BITS: begin
                    tx <= data_reg[bit_index];
                    if (bit_counter == BIT_PERIOD - 1) begin
                        bit_counter <= 0;
                        if (bit_index == DATA_BITS - 1) begin
                            if (PARITY != "NONE") begin
                                state <= PARITY_BIT;
                            end else begin
                                state <= STOP_BIT;
                            end
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                PARITY_BIT: begin
                    tx <= parity_bit;
                    if (bit_counter == BIT_PERIOD - 1) begin
                        state <= STOP_BIT;
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                STOP_BIT: begin
                    tx <= 1'b1; // 停止位为高电平
                    if (bit_counter == BIT_PERIOD * STOP_BITS - 1) begin
                        state <= IDLE;
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule