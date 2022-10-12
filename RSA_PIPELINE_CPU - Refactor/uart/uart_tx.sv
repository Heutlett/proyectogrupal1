module uart_tx
  #(parameter
    /*
     You can specify the following three parameters.
     1. DATA_WIDTH : is the width of data that is transmited by this module.  Is almost always set to eight. 
     2. BAUD_RATE  : is the rate at which the serial data is transmitted. 9600 Baud means 9600 bits per second.
     3. CLK_FREQ   : is the frequency of input clock signal.
    */
    DATA_WIDTH = 8,
    BAUD_RATE  = 115200,
    CLK_FREQ   = 100_000_000)
   (output logic                  uart_out,
    input  logic [DATA_WIDTH-1:0] data,
    input  logic                  valid,
    output logic                  ready,
    input  logic                  clk,
    input  logic                  rstn);

   localparam LB_DATA_WIDTH    = $clog2(DATA_WIDTH);		// is the number of address bits needed for a memory of size DATA_WIDTH.
   localparam PULSE_WIDTH      = CLK_FREQ / BAUD_RATE;	
   localparam LB_PULSE_WIDTH   = $clog2(PULSE_WIDTH);		// is the number of address bits needed for a memory of size PULSE_WIDTH.
   localparam HALF_PULSE_WIDTH = PULSE_WIDTH / 2;

	
	// STATE MACHINE - Possible states of the state machine for data transmission..
   typedef enum logic [1:0] {STT_DATA,
                             STT_STOP,
                             STT_WAIT
                             } statetype;
   statetype                 state;

   logic [DATA_WIDTH-1:0]     data_r;
   logic                      uart_out_r;
   logic                      ready_r;
   logic [LB_DATA_WIDTH-1:0]  data_cnt;
   logic [LB_PULSE_WIDTH:0] 	clk_cnt;
	
	
   always_ff @(posedge clk) begin
      if(!rstn) begin
         state      <= STT_WAIT;
         uart_out_r <= 1;
         data_r     <= 0;
         ready_r    <= 1;
         data_cnt   <= 0;
         clk_cnt    <= 0;
      end
      else begin

         //-----------------------------------------------------------------------------
         // 3-state FSM
         case(state)

           //-----------------------------------------------------------------------------
           // state      : STT_DATA
           // behavior   : serialize and transmit data
           // next state : when all data have transmited -> STT_STOP
           STT_DATA: begin
              if(0 < clk_cnt) begin
                 clk_cnt <= clk_cnt - 1;
              end
              else begin
                 uart_out_r <= data_r[data_cnt];
                 clk_cnt    <= PULSE_WIDTH;

                 if(data_cnt == DATA_WIDTH - 1) begin
                    state <= STT_STOP;
                 end
                 else begin
                    data_cnt <= data_cnt + 1;
                 end
              end
           end

           //-----------------------------------------------------------------------------
           // state      : STT_STOP
           // behavior   : assert stop bit
           // next state : STT_WAIT
           STT_STOP: begin
              if(0 < clk_cnt) begin
                 clk_cnt <= clk_cnt - 1;
              end
              else begin
                 state      <= STT_WAIT;
                 uart_out_r <= 1;
                 clk_cnt    <= PULSE_WIDTH + HALF_PULSE_WIDTH;
              end
           end

           //-----------------------------------------------------------------------------
           // state      : STT_WAIT
           // behavior   : watch valid signal, and assert start bit when valid signal assert
           // next state : when valid signal assert -> STT_STAT
           STT_WAIT: begin
              if(0 < clk_cnt) begin
                 clk_cnt <= clk_cnt - 1;
              end
              else if(!ready_r) begin
                 ready_r <= 1;
              end
              else if(valid) begin
                 state      <= STT_DATA;
                 uart_out_r <= 0;
                 data_r     <= data;
                 ready_r    <= 0;
                 data_cnt   <= 0;
                 clk_cnt    <= PULSE_WIDTH;
              end
           end

           default: begin
              state <= STT_WAIT;
           end
         endcase
      end
   end

   assign uart_out = uart_out_r;
   assign ready    = ready_r;

endmodule