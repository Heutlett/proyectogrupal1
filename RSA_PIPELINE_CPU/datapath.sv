module datapath
(
	input logic clk, reset, start,
	
	input logic [1:0] RegSrc,
	input logic RegWrite,
	input logic [1:0] ImmSrc,
	input logic ALUSrc,
	input logic [2:0] ALUControl,
	input logic MemtoReg, PCSrc, MemWrite, Branch,
	input logic [1:0] FlagWrite,
	input logic CondEx,
	
	output logic [3:0] ALUFlags,
	
	output logic [31:0] PC,
	input logic [31:0] InstrF,
	output logic [31:0] ALUResult, WriteData,
	input logic [31:0] ReadData,
	output logic [31:0] InstrD,
	output logic MemWriteM
);

	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result;
	logic [3:0] RA1, RA2;
	
	logic [3:0] FlagsD; 
	
	
	
	// Fetch ---------------------------------------------------------------------
	
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	
	flopr #(32) pcreg(clk, reset, start, PCNext, PC);
	
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	//adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);
	
	segment_if_id seg_if_id (clk, rst, instrF, instrD);
	
	
	// Decode ----------------------------------------------------------------------
	
	logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, FlagWriteE, ImmSrcE;
	logic [2:0] ALUControlE;
	logic [3:0] condE, FlagsE, WA3E;
	logic [31:0] rd1E, rd2E, ExtImmE;
	
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
	
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
	
	regfile rf(clk, RegWrite, RA1, RA2, InstrD[15:12], Result, PCPlus4,SrcA, WriteData); // quitar InstrD[15:12] mas adelante
	// Tambien hay que quitar regwrite
					
	extend ext(InstrD[23:0], ImmSrc, ExtImm);
	
	segment_id_ex seg_id_ex (clk, rst, 
								PCSrc, RegWrite, MemtoReg, MemWrite, ALUControl,
								Branch, ALUSrc, FlagWrite, ImmSrc, InstrD[31:28],
								FlagsD, InstrD[15:12], SrcA, WriteData, ExtImm,
								// salidas
								PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
								ALUControlE, 
								BranchE,
								ALUSrcE, FlagWriteE, ImmSrcE,	
								condE, FlagsE, WA3E,
								rd1E, rd2E, ExtImmE);
	
	// Execute ------------------------------------------------------------------------------
	
	logic [31:0] SrcBE, ALUResultE;
	
	logic PCSrcM, RegWriteM, MemtoRegM;
	logic [31:0] ALUOutM, WriteDataM, WA3M;
	
	
	// Compuertas resultados
	
	logic PCSrcEX1, PCSrcEX2, RegWriteEX, MemWriteEX, BranchEX;
	
	mux2 #(32) srcbmux(rd2E, ExtImmE, ALUSrcE, SrcBE);
	
	alu #(32) alu(rd1E, SrcBE, ALUControlE, ALUResultE, ALUFlags);
	
	and2 and_1 (PCSrcE, CondEx, PCSrcEX1);
	
	and2 and_2 (RegWriteE, CondEx, RegWriteEX);
	
	and2 and_3 (MemWriteE, CondEx, MemWriteEX);
	
	and2 and_4 (BranchE, CondEx, BranchEX);
	
	or2 or_1 (PCSrcEX1, BranchEX, PCSrcEX2);
	
	segment_ex_mem seg_ex_mem (clk, rst,
								PCSrcEX2, RegWriteEX, MemtoRegE, MemWriteEX,
								ALUResultE, rd2E, WA3E,
								// Salidas
								PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
								ALUOutM, WriteDataM, WA3M);
		
	// MEM -----------------------------------------------------------------
	
	logic PCSrcW, RegWriteW, MemtoRegW;
	logic [31:0] ReadDataW, ALUOutW;
	logic [3:0] WA3W;
	
	segment_mem_wb seg_mem_wb (clk, rst,
								PCSrcM, RegWriteM, MemtoRegM, 
								ReadData, ALUOutM, WA3M, 
								// salidas
								PCSrcW, RegWriteW, MemtoRegW,
								ReadDataW, ALUOutW, 
								WA3W);
								
	// WB --------------------------------------------------------------------
					
					
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoRegW, Result);
	
endmodule