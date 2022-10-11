module pipelined_processor // Unidades de control y ruta de datos
(
	// Entradas
	input logic clk, reset, start,
	input logic [31:0] Instr, ReadData,
	
	// Salidas
	output logic MemWrite, FlagZero,
	output logic [31:0] PC, ALUResult, WriteData
);

	// Control_unit
	logic RegW, MemtoReg, ALUSrc, MemWriteD, FlagsWrite, ImmSrc, RegSrc;
	logic [2:0] ALUControl;
	
	
	
	// Datapath
	logic FlagsWriteW;
	logic [3:0] ALUFlagsW;
	logic [31:0] InstrD;
	
	pc_control_unit pcu(
					// Entradas
					.clk(clk), 
					.reset(reset),
					.start(start),
					.Branch(Instr[27:26]), 
					.FlagsWrite(FlagsWriteW),
					.Cond(Instr[31:28]), 
					.ALUFlags(ALUFlagsW),
					.Imm(Instr[23:0]),
					// Salidas
					.FlagZero(FlagZero),
					.PCNext(PC)
					);
	
	control_unit c(
					// Entradas
					.Op(InstrD[27:26]),
					.Funct(InstrD[25:20]),
					// Salidas
					.RegWrite(RegW), 
					.MemtoReg(MemtoReg),
					.MemWrite(MemWriteD),
					.ALUSrc(ALUSrc),
					.FlagsWrite(FlagsWrite),
					.ImmSrc(ImmSrc), 
					.RegSrc(RegSrc),
					.ALUControl(ALUControl)
					);
					
					
	datapath dp(
					// Entradas
					.clk(clk), 
					.reset(reset),
					.RegWrite(RegW),
					.ALUSrc(ALUSrc),
					.MemtoReg(MemtoReg), 
					.MemWrite(MemWriteD), 
					.FlagsWriteD(FlagsWrite), 
					.RegSrc(RegSrc),
					.ImmSrc(ImmSrc),
					.ALUControl(ALUControl),
					.InstrF(Instr),
					.ReadData(ReadData),
					.PCNext(PC),
					// Salidas
					.MemWriteM(MemWrite), 
					.FlagsWriteW(FlagsWriteW), 
					.ALUFlagsW(ALUFlagsW),
					.ALUOutM(ALUResult), 
					.WriteDataM(WriteData),
					.InstrD(InstrD)
					);
	
endmodule