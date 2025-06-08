module uart_tx (
    input clk,
    input reset,
    input tx_start,          // 发送启动信号
    input [7:0] tx_data,      // 要发送的数据(8位)
    output reg tx,            // UART发送线
    output reg tx_busy        // 发送忙标志
);

parameter CLK_FREQ = 50_000_000;  // 系统时钟频率(Hz)
parameter BAUD_RATE = 115200;     // 波特率

localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;
localparam HALF_BIT_PERIOD = BIT_PERIOD / 2;

reg [15:0] bit_timer;
reg [3:0] bit_counter;
reg [7:0] tx_reg;

// 状态定义
localparam IDLE = 2'b00;
localparam START_BIT = 2'b01;
localparam DATA_BITS = 2'b10;
localparam STOP_BIT = 2'b11;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        tx <= 1'b1;          // 空闲时保持高电平
        tx_busy <= 1'b0;
        bit_timer <= 16'd0;
        bit_counter <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                tx <= 1'b1;  // 空闲状态
                if (tx_start) begin
                    state <= START_BIT;
                    tx_reg <= tx_data;
                    tx_busy <= 1'b1;
                    bit_timer <= 16'd0;
                end else begin
                    tx_busy <= 1'b0;
                end
            end
            
            START_BIT: begin
                tx <= 1'b0;  // 发送起始位
                if (bit_timer < BIT_PERIOD - 1) begin
                    bit_timer <= bit_timer + 16'd1;
                end else begin
                    bit_timer <= 16'd0;
                    state <= DATA_BITS;
                    bit_counter <= 4'd0;
                end
            end
            
            DATA_BITS: begin
                tx <= tx_reg[bit_counter];  // 发送数据位(LSB first)
                if (bit_timer < BIT_PERIOD - 1) begin
                    bit_timer <= bit_timer + 16'd1;
                end else begin
                    bit_timer <= 16'd0;
                    if (bit_counter < 7) begin
                        bit_counter <= bit_counter + 4'd1;
                    end else begin
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                tx <= 1'b1;  // 发送停止位
                if (bit_timer < BIT_PERIOD - 1) begin
                    bit_timer <= bit_timer + 16'd1;
                end else begin
                    bit_timer <= 16'd0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule