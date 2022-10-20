module clock_manager
(
	input clk_FPGA,
	input COMFlag, // COM Flag
	output logic clk
);

	// Example: 10 MHz Clock, 115200 baud UART
	// (10000000)/(115200) = 87
	// Numero de clocks por bit
	localparam CLK_FREQ = 50_000_000;
	localparam BAUD_RATE = 9600;
   //localparam PULSE_WIDTH = CLK_FREQ / BAUD_RATE;
	clockDivider #(BAUD_RATE) div (.clk_in(clk_FPGA), .clk_out(clk_Serial));
	mux2 #(1) clk_mux	(.d0(clk_FPGA), .d1(clk_Serial), .s(COMFlag), .y(clk));
	
endmodule