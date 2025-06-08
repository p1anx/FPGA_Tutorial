module uart_string_sender_top (
    input clk,
    input reset,
    input send_button,    // 发送按钮信号
    output uart_tx        // UART发送线
);

wire tx_start;
wire [7:0] tx_data;
wire tx_busy;
wire send_done;

// 去抖动模块(可选)
reg send_enable;
reg [19:0] debounce_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        send_enable <= 1'b0;
        debounce_counter <= 20'd0;
    end else if (send_button) begin
        if (debounce_counter < 20'd1_000_000) begin  // 20ms @ 50MHz
            debounce_counter <= debounce_counter + 20'd1;
        end else begin
            send_enable <= 1'b1;
        end
    end else begin
        send_enable <= 1'b0;
        debounce_counter <= 20'd0;
    end
end

// UART发送模块
uart_tx uart_tx_inst (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(uart_tx),
    .tx_busy(tx_busy)
);

// 字符串发送控制器
string_sender sender_inst (
    .clk(clk),
    .reset(reset),
    .send_enable(send_enable),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_busy(tx_busy),
    .done(send_done)
);

endmodule