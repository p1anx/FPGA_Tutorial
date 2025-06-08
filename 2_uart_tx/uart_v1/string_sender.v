module string_sender (
    input clk,
    input reset,
    input send_enable,        // 发送使能信号
    output reg tx_start,      // 连接到uart_tx的tx_start
    output reg [7:0] tx_data, // 连接到uart_tx的tx_data
    input tx_busy,           // 连接到uart_tx的tx_busy
    output reg done           // 发送完成标志
);

// 字符串存储(以null结尾)
reg [7:0] string_mem [0:31];  // 最大32字符
integer string_length = 0;

// 初始化字符串(可以在仿真时初始化)
initial begin
    // 示例字符串"Hello World!\n"
    string_mem[0] = "H";
    string_mem[1] = "e";
    string_mem[2] = "l";
    string_mem[3] = "l";
    string_mem[4] = "o";
    string_mem[5] = " ";
    string_mem[6] = "W";
    string_mem[7] = "o";
    string_mem[8] = "r";
    string_mem[9] = "l";
    string_mem[10] = "d";
    string_mem[11] = "!";
    string_mem[12] = "\n";
    string_mem[13] = 8'h00;  // null终止符
    string_length = 13;
end

// 状态定义
localparam IDLE = 2'b00;
localparam WAIT_TX = 2'b01;
localparam NEXT_CHAR = 2'b10;
localparam DONE = 2'b11;
reg [1:0] state;

reg [7:0] char_index;  // 当前发送的字符索引

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        tx_start <= 1'b0;
        char_index <= 8'd0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (send_enable) begin
                    char_index <= 8'd0;
                    if (string_length > 0) begin
                        tx_data <= string_mem[0];
                        tx_start <= 1'b1;
                        state <= WAIT_TX;
                    end else begin
                        state <= DONE;
                    end
                end
            end
            
            WAIT_TX: begin
                tx_start <= 1'b0;
                if (!tx_busy) begin  // 等待当前字符发送完成
                    state <= NEXT_CHAR;
                end
            end
            
            NEXT_CHAR: begin
                if (char_index < string_length - 1) begin
                    char_index <= char_index + 8'd1;
                    tx_data <= string_mem[char_index + 8'd1];
                    tx_start <= 1'b1;
                    state <= WAIT_TX;
                end else begin
                    state <= DONE;
                end
            end
            
            DONE: begin
                done <= 1'b1;
                if (!send_enable) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule