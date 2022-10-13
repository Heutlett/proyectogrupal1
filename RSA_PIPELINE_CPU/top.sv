module top
(
	// Entradas
	input logic clk, reset, start,
	
	// Salidas
	output logic FlagZero, EndFlag, COMFlag,
	output logic [31:0] ReadDataOut
);
	
	logic [31:0] WriteData, DataAdr, ReadData;
	logic MemWrite, MemtoReg;
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
									.MemtoRegM(MemtoReg),
									.FlagZero(FlagZero),
									.EndFlag(EndFlag),
									.COMFlag(COMFlag),
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
	
	interpreter_coumunication ic 	(
											// Entradas
											.clk(clk), 
											.reset(reset), 
											.MemtoReg(MemtoReg),
											.COM(COMFlag),
											.ReadData(ReadData),
											// Salidas
											.ReadDataOut(ReadDataOut)
											);

	
endmodule