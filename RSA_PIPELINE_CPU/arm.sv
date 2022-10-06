module arm // Controller and Datapath
(
	input logic clk, reset, start,
	output logic [31:0] PC,
	input logic [31:0] Instr,
	output logic MemWrite,
	output logic [31:0] ALUResult, WriteData,
	input logic [31:0] ReadData
);

	// Cond_unit
	logic [3:0] ALUFlags;
	logic CondEx;
	logic [3:0] FlagsE, FlagsD;
	
	
	
	// Control_unit
	logic [1:0] FlagW, RegSrc, ImmSrc;
	logic [2:0] ALUControl;
	logic PCS, RegW, MemtoReg, ALUSrc, Branch;
	logic MemWriteD;
	
	// Datapath
	logic [31:0] InstrD;
	
	
	control_unit c(InstrD[27:26], InstrD[25:20], InstrD[15:12], 
					// Salidas
					PCS, RegW, MemtoReg, 
					MemWriteD, ALUControl, Branch, ALUSrc, 
					FlagW, ImmSrc, RegSrc);
					
	cond_unit2 cl(FlagW, InstrD[31:28], ALUFlags, FlagsE,
					// Salidas
					CondEx, FlagsD);
					
	datapath dp(clk, reset, start,
					RegSrc, RegW, ImmSrc,
					ALUSrc, ALUControl,
					MemtoReg, PCS, MemWriteD, Branch, FlagW, CondEx,
					// Salidas
					ALUFlags, PC, Instr,
					ALUResult, WriteData, ReadData,InstrD, MemWrite, FlagsE, FlagsD);
	
endmodule