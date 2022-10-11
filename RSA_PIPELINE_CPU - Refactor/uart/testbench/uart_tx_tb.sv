timeunit 1ns;
timeprecision 1ns;

module uart_tx_tb();
   localparam DATA_WIDTH = 8;
   localparam BAUD_RATE  = 115200;
   localparam CLK_FREQ   = 100_000_000;

   logic [DATA_WIDTH-1:0] in;
   logic clk, rstn, valid, out, ready;

   //-----------------------------------------------------------------------------
   // clock generater
   localparam CLK_PERIOD = 1_000_000_000 / CLK_FREQ;

   initial begin
      clk = 1'b0;
   end

   always #(CLK_PERIOD / 2) begin
      clk = ~clk;
   end

   //-----------------------------------------------------------------------------
   // DUT connection
   uart_tx #(DATA_WIDTH, BAUD_RATE, CLK_FREQ) dut(.data     (in),
                                                  .valid    (valid),
                                                  .clk      (clk),
                                                  .rstn     (rstn),
                                                  .uart_out (out),
                                                  .ready    (ready));

   //-----------------------------------------------------------------------------
   // test scenario
   localparam LB_DATA_WIDTH = $clog2(DATA_WIDTH);
   localparam PULSE_WIDTH   = CLK_FREQ / BAUD_RATE;

   logic [DATA_WIDTH-1:0] data     = 0;

   int                    index    = 0;
   int                    success  = 1;
   int                    end_flag = 0;

   initial begin
      #0    in    = 0;
      #0    valid = 0;
      #0    rstn  = 0;

      #100  rstn  = 1;

      while(!end_flag) begin

         while(!ready) @(posedge clk);
         in    = data;
         valid = 1;

         while(ready)  @(posedge clk);
         valid = 0;

         repeat(PULSE_WIDTH / 2) @(posedge clk);
         for(index = -1; index <= DATA_WIDTH; index++) begin
            case(index)
              -1:         if(out != 0)           success = 0;
              DATA_WIDTH: if(out != 1)           success = 0;
              default:    if(out != data[index]) success = 0;
            endcase

            repeat(PULSE_WIDTH) @(posedge clk);
         end

         if(data == $pow(2, DATA_WIDTH)-1) begin
            end_flag = 1;
         end
         else begin
            data++;
         end
      end

      if(success) begin
         $display("simulation is success!");
      end
      else begin
         $display("simulation is failure!");
      end

      $finish;
   end

endmodule