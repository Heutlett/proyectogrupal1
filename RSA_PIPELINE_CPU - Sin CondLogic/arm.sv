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
	logic RegW, MemtoReg, ALUSrc, Branch, MemWriteD, FlagsWriteD;
	
	// PC Control Unit
	
	logic PCSrc;
	
	
	// Datapath
	logic [31:0] InstrD, PCF;
	logic [3:0] CondW, ALUFlagsW;
	logic BranchW, FlagsWriteW;
	
	
	control_unit c(InstrD[27:26], InstrD[25:20],
					// Salidas
					RegW, MemtoReg, 
					MemWriteD, ALUControl, Branch, ALUSrc, 
					ImmSrc, RegSrc, FlagsWriteD);
					
	
	pc_control_unit pcu(
					.clk(clk), 
					.reset(reset),
					.Branch(Instr[27:26]), 
					.FlagsWrite(FlagsWriteW),
					.Cond(Instr[31:28]), 
					.ALUFlags(ALUFlagsW),
					.Imm(Instr[23:0]),
					.PCF(PCF),
					.PCSrc(PCSrc),
					.PCNext(PC),
					.start(start)

	);
	
					
	datapath dp(clk, reset, start,
					RegSrc, RegW, ImmSrc,
					ALUSrc, ALUControl,
					MemtoReg, MemWriteD, Branch, FlagsWriteD, PCSrc,
					// Salidas
					PCF, Instr,
					ALUResult, WriteData, ReadData,InstrD, MemWrite, BranchW, FlagsWriteW, CondW, ALUFlagsW, PC);
	
endmodule