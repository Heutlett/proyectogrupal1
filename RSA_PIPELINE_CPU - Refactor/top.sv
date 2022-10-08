//import arm_const::*;
module top
(
	input logic clk, reset, start,
	output logic [3:0] result
);
	
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;
	logic [31:0] PC, Instr, ReadData;
	
	// Instancia del procesador
	arm arm(clk, reset, start, PC, Instr, MemWrite, DataAdr,
				WriteData, ReadData);
	
	// Memoria de instrucciones
	imem imem(PC, clk, Instr);
	
	// Memoria de datos
	dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData, result);
	
endmodule