module clock_manager
  #(parameter
    /*
     You can specify the following three parameters.
     1. DATA_WIDTH : is the width of data that is transmited by this module.  Is almost always set to eight. 
     2. BAUD_RATE  : is the rate at which the serial data is transmitted. 9600 Baud means 9600 bits per second.
     3. CLK_FREQ   : is the frequency of input clock signal.
    */
    DATA_WIDTH = 8,
    BAUD_RATE  = 115200,
    CLK_FREQ   = 50_000_000
) (
    input clk_FPGA,
	 input reset,
    input COMFlag, // COM Flag
    output clk,
	 output [7:0] tmp_Serial_ctr
);

	// Example: 10 MHz Clock, 115200 baud UART
	// (10000000)/(115200) = 87
	// Numero de clocks por bit
   localparam PULSE_WIDTH = CLK_FREQ / BAUD_RATE;
   localparam LB_PULSE_WIDTH   = $clog2(PULSE_WIDTH);		// is the number of address bits needed for a memory of size PULSE_WIDTH.
	
	
	logic [LB_PULSE_WIDTH:0] 	r_Clock_Count;
	logic r_Serial_Clock;
	
	
	always_ff @(posedge clk_FPGA or posedge reset) begin
		if (reset) begin
			r_Clock_Count <= 0;
			r_Serial_Clock <= 0;
		end

		else if(COMFlag) begin 
//			// Espere CLKS_PER_BIT-1 ciclos de reloj para que terminen los bits
			if (r_Clock_Count < 4) begin
				r_Clock_Count <= r_Clock_Count + 1;
			end else begin
				r_Clock_Count <= 0;
				r_Serial_Clock <= ~r_Serial_Clock;
			end
		end
	end
	
	
	assign clk = (COMFlag) ? r_Serial_Clock : clk_FPGA;
	assign tmp_Serial_ctr = r_Clock_Count;
	
	
endmodule