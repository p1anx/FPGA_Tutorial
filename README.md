# FPGA_Tutorial
## PIN of fire FPGA(EP4CE10F17)
时钟引脚分配表如下表所示：	
引脚名	FPGA绑定引脚
sys_clk 	E1
sys_rst_n	M15

按键引脚分配如下表所示：	
引脚名	FPGA绑定引脚
RESET	M15
KEY1	M2
KEY2	M1
KEY3	E15
KEY4	E16
	
LED灯引脚分配如下表所示：	
引脚名	FPGA绑定引脚
LED1	L7
LED2	M6
LED3	P3
LED4	N3
	
RS232串口引脚分配如下表所示：	
引脚名	FPGA绑定引脚
UART1_RX	N6
UART1_TX	N5
UART2_RX	K8
UART2_TX	M7
UART3_RX	L8
UART3_TX	P6
RS485_RE	C11

FLASH各引脚分配如下表所示：	
引脚名	FPGA绑定引脚
FLASH_NCE	D2
EPCS_CLK	H1
EPCS_ASDO	C1
EPCS_DATA0	H2

IIC各引脚分配如下表所示：	
引脚名	FPGA绑定引脚
I2C1_SCL	P15
I2C1_SDA	N14

CAN引脚分配如下表所示：	
引脚名	FPGA绑定引脚
CAN_RX	L10
CAN_TX	K10
	
触摸按键引脚分配如下表所示：	
引脚名	FPGA绑定引脚
T_PAD1	K11
T_PAD2	B14
	
## PIN of Atom(ZYNQ7020)
开发板PL IO引脚列表
|---|---|---|---|
|信号名	|方向	|管脚	|端口说明|
|---|
|系统时钟（50Mhz）|			
sys_clk	    input	U18	系统时钟，频率：50Mhz
PL复位按键			
sys_rst_n	input	N16	PL复位复位，低电平有效
2个PL功能按键			
key[0]	    input	L14	PL按键KEY0
key[1]	    input	K16	PL按键KEY1
3个PL_LED灯			
led[0]	    output	H15	（底板）PL_LED0
led[1]	    output	L15	（底板）PL_LED1
led	        output	J16	（核心板）PL_LED
触摸按键			
touch_key	input	F16	触摸按键 tpad
蜂鸣器			
beep	    output	M14	蜂鸣器
RS232/RS485串口			
uart_rxd	input	k14	串口接收端UART2_RX
uart_txd	output	M15	串口发送端
ATK MODULE			
uart_rx	    input	T19	RXD端口 UART3_RX
uart_tx	    output	J15	TXD端口
gbc_key	    input	G14	KEY端口
gbc_led	    output	N15	LED端口
IIC总线（EEPROM/RTC实时时钟/音频配置）			
iic_scl	    output	E18	IIC时钟信号线
iic_sda	    inout	F17	IIC双向数据线


