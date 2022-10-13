module top
(
	// Entradas
	input logic clk, reset, start,
	
	// Salidas
	output logic FlagZero, EndFlag,
	output logic [31:0] ReadData
);
	
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;
	logic [31:0] PC, Instr;
	
	// Instancia del procesador
	pipelined_processor cpu(
									// Entradas
									.clk(clk), 
									.reset(reset), 
									.start(start), 
									.Instr(Instr), 
									.ReadData(ReadData), 
									// Salidas
									.MemWrite(MemWrite), 
									.FlagZero(FlagZero),
									.EndFlag(EndFlag),
									.PC(PC), 
									.ALUResult(DataAdr),
									.WriteData(WriteData)
									); 
									
									
	// Memoria de instrucciones
	instr_mem instr_mem(
								// Entradas
								.clk(clk), 
								.InstrAddress(PC),
								// Salidas
								.ReadInstr(Instr)
								);
	
	// Memoria de datos
	data_mem data_mem(
							// Entradas
							.clk(clk), 
							.WriteEnable(MemWrite), 
							.DataAddress(DataAdr), 
							.WriteData(WriteData),
							// Salidas
							.ReadData(ReadData)
							);

	
endmodule