module uart_rx
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
   (input  logic                  uart_in,
    output logic [DATA_WIDTH-1:0] data,						// this will be the DATA_WIDTH bits received data.
    output logic                  valid,						// this is used to notify when the data read process is done.
    input  logic                  ready,						// this will enable or NOT the data in read
    input  logic                  clk,
    input  logic                  rstn);

   localparam LB_DATA_WIDTH    = $clog2(DATA_WIDTH);		// is the number of address bits needed for a memory of size DATA_WIDTH.
   localparam PULSE_WIDTH      = CLK_FREQ / BAUD_RATE;	// clo
   localparam LB_PULSE_WIDTH   = $clog2(PULSE_WIDTH);		// is the number of address bits needed for a memory of size PULSE_WIDTH.
   localparam HALF_PULSE_WIDTH = PULSE_WIDTH / 2;

   //-----------------------------------------------------------------------------
   // noise removing filter
   function majority5(input [4:0] val);
      case(val)
        5'b00000: majority5 = 0;
        5'b00001: majority5 = 0;
        5'b00010: majority5 = 0;
        5'b00100: majority5 = 0;
        5'b01000: majority5 = 0;
        5'b10000: majority5 = 0;
        5'b00011: majority5 = 0;
        5'b00101: majority5 = 0;
        5'b01001: majority5 = 0;
        5'b10001: majority5 = 0;
        5'b00110: majority5 = 0;
        5'b01010: majority5 = 0;
        5'b10010: majority5 = 0;
        5'b01100: majority5 = 0;
        5'b10100: majority5 = 0;
        5'b11000: majority5 = 0;
        default:  majority5 = 1;
      endcase
   endfunction

   //-----------------------------------------------------------------------------
   // description about input signal
   logic [1:0] sampling_cnt;		// sampling counter
   logic [4:0] uart_in_q;			// 
   logic       uart_in_r;			// received bit register

   always_ff @(posedge clk) begin
      if(!rstn) begin
         sampling_cnt <= 0;
         uart_in_q    <= 5'b11111;
         uart_in_r    <= 1;
      end
      else begin
         // connect to deserializer after removing noise
         if(sampling_cnt == 0) begin
            uart_in_q <= {uart_in, uart_in_q[4:1]};
         end

         uart_in_r    <= majority5(uart_in_q);
         sampling_cnt <= sampling_cnt + 1;
      end
   end

   //----------------------------------------------------------------
   // description about receive UART signal
   typedef enum logic [1:0] {STT_DATA,
                             STT_STOP,
                             STT_WAIT
                             } statetype;

   statetype                 state;

   logic [DATA_WIDTH-1:0]   data_tmp_r;	// temporal register to store the data
   logic [LB_DATA_WIDTH:0]  data_cnt;		// data counter
   logic [LB_PULSE_WIDTH:0] clk_cnt;		// clock counter
   logic                    rx_done;		// flag to indicate when read process have done

   always_ff @(posedge clk) begin
      if(!rstn) begin
         state      <= STT_WAIT;
         data_tmp_r <= 0;
         data_cnt   <= 0;
         clk_cnt    <= 0;
      end
      else begin

         //-----------------------------------------------------------------------------
         // 3-state FSM
         case(state)

           //-----------------------------------------------------------------------------
           // state      : STT_DATA
           // behavior   : deserialize and recieve data
           // next state : when all data have received -> STT_STOP
           STT_DATA: begin
              if(0 < clk_cnt) begin
                 clk_cnt <= clk_cnt - 1;
              end
              else begin
                 data_tmp_r <= {uart_in_r, data_tmp_r[DATA_WIDTH-1:1]};
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
           // behavior   : watch stop bit
           // next state : STT_WAIT
           STT_STOP: begin
              if(0 < clk_cnt) begin
                 clk_cnt <= clk_cnt - 1;
              end
              else if(uart_in_r) begin
                 state <= STT_WAIT;
              end
           end

           //-----------------------------------------------------------------------------
           // state      : STT_WAIT
           // behavior   : watch start bit
           // next state : when start bit is observed -> STT_DATA
           STT_WAIT: begin
              if(uart_in_r == 0) begin
                 clk_cnt  <= PULSE_WIDTH + HALF_PULSE_WIDTH;
                 data_cnt <= 0;
                 state    <= STT_DATA;
              end
           end

           default: begin
              state <= STT_WAIT;
           end
         endcase
      end
   end

   assign rx_done = (state == STT_STOP) && (clk_cnt == 0);

   //-----------------------------------------------------------------------------
   // description about output signal
   logic [DATA_WIDTH-1:0] data_r;
   logic                  valid_r;

   always_ff @(posedge clk) begin
      if(!rstn) begin
         data_r  <= 0;
         valid_r <= 0;
      end
      else if(rx_done && !valid_r) begin
         valid_r <= 1;
         data_r  <= data_tmp_r;
      end
      else if(valid_r && ready) begin
         valid_r <= 0;
      end
   end

   assign data  = data_r;
   assign valid = valid_r;

endmodule