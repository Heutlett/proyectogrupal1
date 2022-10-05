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
	logic RegWrite, PCSrc;
	
	
	
	// Control_unit
	logic [1:0] FlagW, RegSrc, ImmSrc;
	logic [2:0] ALUControl;
	logic PCS, RegW, MemW, MemtoReg, ALUSrc, Branch;
	
	
	control_unit c(Instr[27:26], Instr[25:20], Instr[15:12], 
					// Salidas
					PCS, RegW, MemtoReg, 
					MemW, ALUControl, Branch, ALUSrc, 
					FlagW, ImmSrc, RegSrc);
					
	cond_unit cl(clk, reset, Instr[31:28], ALUFlags,
					FlagW, PCS, RegW, MemW,
					// Salidas
					PCSrc, RegWrite, MemWrite);
					
	datapath dp(clk, reset, start,
					RegSrc, RegWrite, ImmSrc,
					ALUSrc, ALUControl,
					MemtoReg, PCSrc,
					ALUFlags, PC, Instr,
					ALUResult, WriteData, ReadData);
	
endmodule