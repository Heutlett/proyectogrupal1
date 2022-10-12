module TOP_spi(
	input clk,					// clock
   input rst,					// reset
	input start,				// enable
//   output logic mosi,
//   output logic sck,		
   output logic [3:0] data_out,
   output logic busy,
   output logic valid_data
  );
  
  logic [3:0] data_in;
  
  always @(posedge clk) begin
		if (! rst)
			data_in <= 0;
		else
			data_in <= data_in +1;
			
	end
	
	assign data_out = data_in;
endmodule
	
//	// Memoria de instrucciones
//	spi_master spi(.clk(clk),
//					  .rst (rst),
//					  .miso (miso),
//					  .start (start),
//					  .data_in (data_in),
//					  .mosi (mosi),
//					  .sck (sck),
//					  .busy (busy),
//					  .data_out (data_out),
//					  .valid_data (valid_data));