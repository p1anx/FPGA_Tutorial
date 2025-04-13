module uart
#(
    parameter PERIOD_HZ = 1000,
    parameter DUTY   = 0.3
)
(
    input       wire        sys_clk,
    input       wire        sys_rst_n,

    output      wire        uart_tx_data

);
parameter DATA_LENGTH = 13; // Increased length to include null terminator
localparam integer BAUD_RATE = 9600;
localparam integer CLK_FREQ = 50_000_000;

wire timer_flag;
wire tx_cmp_flag;
reg [7:0] pi_data [DATA_LENGTH-1:0];

// Use hex values for character assignment in initial block
initial begin
    pi_data[0]  = 8'h68; // "h"
    pi_data[1]  = 8'h65; // "e"
    pi_data[2]  = 8'h6c; // "l"
    pi_data[3]  = 8'h6c; // "l"
    pi_data[4]  = 8'h6f; // "o"
    pi_data[5]  = 8'h2c; // ","
    pi_data[6]  = 8'h77; // "w"
    pi_data[7]  = 8'h6f; // "o"
    pi_data[8]  = 8'h72; // "r"
    pi_data[9]  = 8'h6c; // "l"
    pi_data[10] = 8'h64; // "d"
    pi_data[11] = 8'h0A; // "\n" - Line feed
    pi_data[12] = 8'h00; // Null terminator - very important
end

// States
reg [1:0] state;
localparam [1:0] IDLE = 2'b00;
localparam [1:0] SEND = 2'b01;
localparam [1:0] DELAY = 2'b10;
localparam [1:0] RESET = 2'b11;

// Data counter and transmitter
// reg [integer'log2(DATA_LENGTH)-1:0] data_cnt; // Reduced size for efficiency
reg [25:0] data_cnt;
reg [7:0]  data_tx;
reg transmitting; // Flag to know when sending

//Delay Counter
localparam integer DELAY_MAX = 50000000; // 1 second delay
reg [31:0] delay_cnt; // Counter for delay

//Main logic with state machine
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        state <= IDLE;
        data_cnt <= 0;
        data_tx <= 0;
        delay_cnt <= 0;
        transmitting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (timer_flag) begin // Start sending upon timer_flag
                    data_cnt <= 0;
                    data_tx <= pi_data[data_cnt];
                    state <= SEND;
                    transmitting <= 1;
                end
            end
            SEND: begin
                if (tx_cmp_flag) begin // Check uart is finished.
                    if(data_cnt < DATA_LENGTH - 1) begin // Send next character
                        data_cnt <= data_cnt + 1'b1;
                        data_tx <= pi_data[data_cnt];
                        state <= SEND;
                        transmitting <= 1;
                    end
                    else begin
                        state <= DELAY;
                        transmitting <= 0;
                        delay_cnt <= 0;
                    end
                end
            end

            DELAY: begin
                if (delay_cnt < DELAY_MAX - 1) begin
                    delay_cnt <= delay_cnt + 1'b1;
                end
                else begin
                    state <= RESET; //reset all
                    delay_cnt <= 0; //Reset Delay counter
                    data_cnt <= 0; //Reset Data Counter.
                end
            end

            RESET: begin //Reset State
                state <= IDLE;
            end

            default:
                 state <= IDLE;
        endcase
    end
end

uart_tx
#(
    .UART_BPS (BAUD_RATE),         //串口波特率
    .CLK_FREQ (CLK_FREQ)    //时钟频率
)
uart_tx1
(
     .sys_clk   (sys_clk) ,   //系统时钟50MHz
     .sys_rst_n (sys_rst_n) ,   //全局复位
     .pi_data   (data_tx) ,   //模块输入的8bit数据
     .pi_flag   (transmitting) ,   //并行数据有效标志信号.  This is what needed to be corrected.
 
     .tx        (uart_tx_data),     //串转并后的1bit数据
     .tx_cmp_flag  (tx_cmp_flag)
);

timer
#(
    .HZ (1) // Set timer to 1 Hz for one-second interval
)
timer1
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),

    .timer_flag(timer_flag)
);

endmodule