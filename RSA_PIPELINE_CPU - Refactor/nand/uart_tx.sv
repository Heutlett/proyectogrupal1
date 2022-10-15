//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87

module uart_tx #(
    parameter CLKS_PER_BIT
) (
    input i_Clock,
    input i_Tx_DV,  // Input Data Valid Flag
    input [7:0] i_Tx_Byte,  // Transmit Data Byte
    output o_Tx_Active,  // This is used to infer a tri-state buffer for half-duplex communication. 
    output logic o_Tx_Serial,  // Output Bit
    output o_Tx_Done  // Transmision Done.
);

  parameter s_IDLE = 3'b000;
  parameter s_TX_START_BIT = 3'b001;
  parameter s_TX_DATA_BITS = 3'b010;
  parameter s_TX_STOP_BIT = 3'b011;
  parameter s_CLEANUP = 3'b100;

  logic [2:0] r_SM_Main = 0;  // State Machine
  logic [7:0] r_Clock_Count = 0;  // Counter
  logic [2:0] r_Bit_Index = 0;  // 8 bits total
  logic [7:0] r_Tx_Data = 0;  // Transmit Data
  logic       r_Tx_Done = 0;  // Done Flag
  logic       r_Tx_Active = 0;  // Full duplex or half duplex

  always @(posedge i_Clock) begin

    case (r_SM_Main)
      s_IDLE: begin
        o_Tx_Serial   <= 1'b1;  // Siempre la salida en 1 para que cuando se detecte un 0 empiece a analizar.
        r_Tx_Done <= 1'b0;  // Flag Done en cero.
        r_Clock_Count <= 0;  // Contador en cero.
        r_Bit_Index <= 0;  // Indice del bit en cero.


        // Si enable está activo.
        if (i_Tx_DV == 1'b1) begin
          r_Tx_Active <= 1'b1;  // Se activa bandera de envio de datos.
          r_Tx_Data   <= i_Tx_Byte;  // Se carga la entrada al registro de datos.
          r_SM_Main   <= s_TX_START_BIT;  // Pasamos al estado de start bit.
        end else r_SM_Main <= s_IDLE;
      end  // case: s_IDLE


      // Send out Start Bit. Start bit = 0
      s_TX_START_BIT: begin
        // Se envia un cero como start bit para que el receptor detecte que se va a enviar una cadena
        o_Tx_Serial <= 1'b0;

        // Espere CLKS_PER_BIT-1 ciclos de reloj para que finalice el bit de inicio
        if (r_Clock_Count < CLKS_PER_BIT - 1) begin
          r_Clock_Count <= r_Clock_Count + 1;
          r_SM_Main     <= s_TX_START_BIT;
        end else begin
          r_Clock_Count <= 0;
          r_SM_Main     <= s_TX_DATA_BITS;
        end
      end  // case: s_TX_START_BIT


      // Espere CLKS_PER_BIT-1 ciclos de reloj para que terminen los bits de datos
      s_TX_DATA_BITS: begin
        o_Tx_Serial <= r_Tx_Data[r_Bit_Index];

        if (r_Clock_Count < CLKS_PER_BIT - 1) begin
          r_Clock_Count <= r_Clock_Count + 1;
          r_SM_Main     <= s_TX_DATA_BITS;
        end else begin
          r_Clock_Count <= 0;

          // Check if we have sent out all bits
          if (r_Bit_Index < 7) begin
            r_Bit_Index <= r_Bit_Index + 1;
            r_SM_Main   <= s_TX_DATA_BITS;
          end else begin
            r_Bit_Index <= 0;
            r_SM_Main   <= s_TX_STOP_BIT;
          end
        end
      end  // case: s_TX_DATA_BITS


      // Send out Stop bit.  Stop bit = 1
      s_TX_STOP_BIT: begin
        o_Tx_Serial <= 1'b1;

        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        if (r_Clock_Count < CLKS_PER_BIT - 1) begin
          r_Clock_Count <= r_Clock_Count + 1;
          r_SM_Main     <= s_TX_STOP_BIT;
        end else begin
          r_Tx_Done     <= 1'b1;
          r_Clock_Count <= 0;
          r_SM_Main     <= s_CLEANUP;
          r_Tx_Active   <= 1'b0;
        end
      end  // case: s_Tx_STOP_BIT


      // Stay here 1 clock
      s_CLEANUP: begin
        r_Tx_Done <= 1'b1;
        r_SM_Main <= s_IDLE;
      end


      default: r_SM_Main <= s_IDLE;

    endcase
  end

  assign o_Tx_Active = r_Tx_Active;
  assign o_Tx_Done   = r_Tx_Done;

endmodule
