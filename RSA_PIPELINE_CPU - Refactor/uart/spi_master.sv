/* 
	Serial Peripheral Interface (SPI)
	https://alchitry.com/serial-peripheral-interface-spi-verilog
		
	
	Arduino Pines
	https://forum.arduino.cc/t/spi-slave-mode-example-code/6661DATA_WIDTH-1
	https://www.makerguides.com/master-slave-spi-communication-arduino/
	https://circuitdigest.com/microcontroller-projects/arduino-spi-communication-tutorial
	
	best
	https://www.makerguides.com/master-slave-spi-communication-arduino/
*/

module spi_master #(parameter CLK_DIV = 2, DATA_WIDTH = 8) (
    input clk,					// clock
    input rst,					// reset
    input miso,				// (Master Out Slave In) – Using MOSI pin Master sends data to Slave.
    output mosi,				// (Master In Slave Out) – Using MISO Slave can send data to the Master.
    output sck,				// (Serial Clock) – The Master generates the clock signal, and it provides synchronization between Master and Slave.
    input start,				// enable
    input [DATA_WIDTH-1:0] data_in,		// data 
    output [DATA_WIDTH-1:0] data_out,	// 
    output busy,
    output valid_data
  );
 
  localparam STATE_SIZE = 2;
  localparam IDLE = 2'd0, WAIT_HALF = 2'd1, TRANSFER = 2'd2;
  logic [STATE_SIZE-1:0] state_d, state_q;
 
  // d stands for input, q for output
  logic [DATA_WIDTH-1:0] data_d, data_q; 			// data flip flop auxiliars
  logic [CLK_DIV-1:0] sck_d, sck_q;		// serial clock flip flop auxiliars
  logic mosi_d, mosi_q;						// master output flip flop auxiliars
  logic [2:0] ctr_d, ctr_q;				// bit counter flip flop auxiliars
  logic valid_data_d, valid_data_q;		// valid data flag flip flop auxiliar
  logic [DATA_WIDTH-1:0] data_out_d, data_out_q;	// received data from slave arduino.
 
 
  // output assignments
  assign mosi = mosi_q;
  assign sck = (~sck_q[CLK_DIV-1]) & (state_q == TRANSFER);
  assign busy = state_q != IDLE;
  assign data_out = data_out_q;
  assign valid_data = valid_data_q;
 
	always @(*) begin
		// set input data to previous output.
		sck_d = sck_q;
		data_d = data_q;
		mosi_d = mosi_q;
		ctr_d = ctr_q;
		valid_data_d = 1'b0;
		data_out_d = data_out_q;
		state_d = state_q;
 
		case (state_q)
			
			IDLE: begin
			  sck_d = 4'b0;              // reset clock counter
			  ctr_d = 3'b0;              // reset bit counter
			  if (start == 1'b1) begin   // if start command
				 data_d = data_in;        // copy data to send
				 state_d = WAIT_HALF;     // change state
			  end
			end
			
			WAIT_HALF: begin
			  sck_d = sck_q + 1'b1;                  // increment clock counter
			  if (sck_q == {CLK_DIV-1{1'b1}}) begin  // if clock is half full (about to fall)
				 sck_d = 1'b0;                        // reset to 0
				 state_d = TRANSFER;                  // change state
			  end
			end
			
			TRANSFER: begin
				sck_d = sck_q + 1'b1;                           // increment clock counter
				if (sck_q == 4'b0000) begin                     // if clock counter is 0
					mosi_d = data_q[DATA_WIDTH-1];                           // output the MSB of data
				end 
				else if (sck_q == {CLK_DIV-1{1'b1}}) begin  // else if it's half full (about to fall)
					data_d = {data_q[6:0], miso};                 // read in data (shift in)
				end 
				else if (sck_q == {CLK_DIV{1'b1}}) begin    // else if it's full (about to rise)
					ctr_d = ctr_q + 1'b1;                         // increment bit counter
					if (ctr_q == 3'b111) begin                    // if we are on the last bit
						state_d = IDLE;                             // change state
						data_out_d = data_q;                        // output data
						valid_data_d = 1'b1;                        // signal data is valid
					end
				end
			end
		endcase
   end
 
   always @(posedge clk) begin
		if (rst) begin
			ctr_q <= 3'b0;				// default bit counter -> 0
			data_q <= 8'b0;			// default 1byte input -> 0
			sck_q <= 4'b0;				// default serial clock -> 0
			mosi_q <= 1'b0;			// default master output -> 0
			state_q <= IDLE;			//	default status -> IDLE
			data_out_q <= 8'b0;		// default output data -> 0
			valid_data_q <= 1'b0;	// default valid data -> 0
		end else begin
			// update the ouput values
			ctr_q <= ctr_d;
			data_q <= data_d;
			sck_q <= sck_d;
			mosi_q <= mosi_d;
			state_q <= state_d;
			data_out_q <= data_out_d;
			valid_data_q <= valid_data_d;
		end
	end
 
endmodule