module arm // Unidades de control y datapath
(
	input logic clk, reset, start,
	output logic [31:0] PC,
	input logic [31:0] Instr,
	output logic MemWrite,
	output logic [31:0] ALUResult, WriteData,
	input logic [31:0] ReadData
);

	
	
	// Control_unit
	logic [1:0] RegSrc, ImmSrc;
	logic [2:0] ALUControl;
	logic RegW, MemtoReg, ALUSrc, Branch;
	logic MemWriteD;
	
	// Datapath
	logic [31:0] InstrD;
	
	
	control_unit c(InstrD[27:26], InstrD[25:20],
					// Salidas
					RegW, MemtoReg, 
					MemWriteD, ALUControl, Branch, ALUSrc, 
					ImmSrc, RegSrc);
					
					
	datapath dp(clk, reset, start,
					RegSrc, RegW, ImmSrc,
					ALUSrc, ALUControl,
					MemtoReg, MemWriteD, Branch,
					// Salidas
					PC, Instr,
					ALUResult, WriteData, ReadData,InstrD, MemWrite);
	
endmodule