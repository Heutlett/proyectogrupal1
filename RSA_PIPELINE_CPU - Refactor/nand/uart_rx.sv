/* El FPGA está continuamente muestreando la línea. Una vez que ve la transición de línea de mayor a menor, 
sabe que se acerca una palabra de datos UART. Esta primera transición indica el bit de inicio. 
Una vez que se encuentra el comienzo del bit de inicio, la FPGA espera la mitad de un período de bit. Esto asegura 
que se muestree la mitad del bit de datos. A partir de ese momento, la FPGA solo necesita esperar un 
período de un bit (según lo especificado por la velocidad en baudios) y muestrear el resto de los datos. 
La siguiente figura muestra cómo funciona el receptor UART dentro de la FPGA. Primero se detecta un flanco 
descendente en la línea de datos en serie. Esto representa el bit de inicio. El FPGA luego espera hasta la 
mitad del primer bit de datos y muestrea los datos. Hace esto para los ocho bits de datos. */


//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87

module uart_rx #(
    parameter CLKS_PER_BIT
) (
    input        i_Clock,      // clock
    input        i_Rx_Serial,  // Input Bit
    output       o_Rx_DV,      // Receive Data Valid
    output [7:0] o_Rx_Byte     // Receive Data Byte
);

  parameter s_IDLE = 3'b000;
  parameter s_RX_START_BIT = 3'b001;
  parameter s_RX_DATA_BITS = 3'b010;
  parameter s_RX_STOP_BIT = 3'b011;
  parameter s_CLEANUP = 3'b100;

  logic       r_Rx_Data_R = 1'b1;  // Received Data Read
  logic       r_Rx_Data = 1'b1;  // Received Data

  logic [7:0] r_Clock_Count = 0;
  logic [2:0] r_Bit_Index = 0;  //8 bits total
  logic [7:0] r_Rx_Byte = 0;
  logic       r_Rx_DV = 0;
  logic [2:0] r_SM_Main = 0;  // State Machine


  // Propósito: Doblemente registrar los datos entrantes.
  // Esto permite su uso en el dominio de reloj RX de la UART.
  // (Elimina los problemas causados por la metaestabilidad)
  always @(posedge i_Clock) begin
    r_Rx_Data_R <= i_Rx_Serial;
    r_Rx_Data   <= r_Rx_Data_R;
  end


  // Purpose: Control RX state machine
  always @(posedge i_Clock) begin

    case (r_SM_Main)
      s_IDLE: begin
        r_Rx_DV       <= 1'b0;  // Receive Data Valid es cero.
        r_Clock_Count <= 0;  // El contador del clock es cero.
        r_Bit_Index   <= 0;  // El contador de bits es cero.

        if (r_Rx_Data == 1'b0)  // Start bit detected
          r_SM_Main <= s_RX_START_BIT;
        else r_SM_Main <= s_IDLE;
      end

      // Check middle of start bit to make sure it's still low
      s_RX_START_BIT: begin
        if (r_Clock_Count == (CLKS_PER_BIT - 1) / 2) begin  // de 0 a la mitad de (87-1)
          if (r_Rx_Data == 1'b0) begin
            r_Clock_Count <= 0;  // se encuentra la mitad, contador se resetea.
            r_SM_Main     <= s_RX_DATA_BITS;  // se pasa al estado de agregar los otros bits.
          end else r_SM_Main <= s_IDLE;
        end else begin
          r_Clock_Count <= r_Clock_Count + 1;  // se suma 1 al contador
          r_SM_Main     <= s_RX_START_BIT;
        end
      end  // case: s_RX_START_BIT


      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      s_RX_DATA_BITS: begin
        if (r_Clock_Count < CLKS_PER_BIT - 1) begin
          r_Clock_Count <= r_Clock_Count + 1;
          r_SM_Main     <= s_RX_DATA_BITS;
        end else begin
          r_Clock_Count          <= 0;
          r_Rx_Byte[r_Bit_Index] <= r_Rx_Data;

          // Check if we have received all bits
          if (r_Bit_Index < 7) begin
            r_Bit_Index <= r_Bit_Index + 1;
            r_SM_Main   <= s_RX_DATA_BITS;
          end else begin
            r_Bit_Index <= 0;
            r_SM_Main   <= s_RX_STOP_BIT;
          end
        end
      end  // case: s_RX_DATA_BITS


      // Receive Stop bit.  Stop bit = 1
      s_RX_STOP_BIT: begin
        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        if (r_Clock_Count < CLKS_PER_BIT - 1) begin
          r_Clock_Count <= r_Clock_Count + 1;
          r_SM_Main     <= s_RX_STOP_BIT;
        end else begin
          r_Rx_DV       <= 1'b1;  // Received Data Valida Flag on
          r_Clock_Count <= 0;
          r_SM_Main     <= s_CLEANUP;
        end
      end  // case: s_RX_STOP_BIT


      // Stay here 1 clock
      s_CLEANUP: begin
        r_SM_Main <= s_IDLE;
        r_Rx_DV   <= 1'b0;
      end


      default: r_SM_Main <= s_IDLE;

    endcase
  end

  assign o_Rx_DV   = r_Rx_DV;
  assign o_Rx_Byte = r_Rx_Byte;

endmodule  // uart_rx
