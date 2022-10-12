///////////////////////////////////////////////////////////////////////////////
// Description:       Simple test bench for SPI Master
///////////////////////////////////////////////////////////////////////////////

timeunit 1ns;
timeprecision 1ns;
module spi_master_tb();

   localparam DATA_WIDTH = 8;
   localparam CLK_DIV = 2;
	localparam DELAY = CLK_DIV*2;
	
	logic clk, rst, miso, start;
	logic [DATA_WIDTH-1:0] data_in;
	
	logic mosi, sck, busy, valid_data;
   logic [DATA_WIDTH-1:0] data_out;

	// Clock Generators:
	parameter MAIN_CLK_DELAY = 2;     // 25 MHz
	always #(MAIN_CLK_DELAY) begin
		clk = ~clk;
   end

	
   //-----------------------------------------------------------------------------
   // DUT
   spi_master #(CLK_DIV, DATA_WIDTH) dut(.clk(clk),
													  .rst (rst),
													  .miso (miso),
													  .start (start),
													  .data_in (data_in),
													  .mosi (mosi),
													  .sck (sck),
													  .busy (busy),
													  .data_out (data_out),
													  .valid_data (valid_data)); 

	
	
	task Print();
		$display("\n\nstart   :  %b", start); 
		$display("MOSI   :  %b", mosi);
		$display("MISO   :  %b", miso); 
		$display("input  :  %b", data_in); 
		$display("out    :  %b", data_out); 
		$display("busy	 :  %b", busy);
		$display("valid  :  %b", valid_data);
	endtask // SendSingleByte
  
	initial begin
		clk = 0;
		data_in = 8'b11111111;
		start = 0;
		rst = 1; 
		#DELAY;
		
		rst <= 0; 
		#DELAY;
		
		start = ~busy;
		#DELAY;
		
		miso = data_in[DATA_WIDTH-1];
		repeat(10) @(posedge clk);
		Print();
		
		#DELAY;
	
	end // initial begin
	
endmodule