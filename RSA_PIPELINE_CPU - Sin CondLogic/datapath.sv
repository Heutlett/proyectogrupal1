module datapath
(
	input logic clk, reset, start,
	
	input logic [1:0] RegSrc,
	input logic RegWrite,
	input logic [1:0] ImmSrc,
	input logic ALUSrc,
	input logic [2:0] ALUControl,
	input logic MemtoReg, MemWrite, Branch, FlagsWriteD, PCSrc,

	output logic [31:0] PCW,
	input logic [31:0] InstrF,
	output logic [31:0] ALUOutM, WriteDataM,
	input logic [31:0] ReadData,
	output logic [31:0] InstrD,
	output logic MemWriteM, BranchW, FlagsWriteW, 
	output logic [3:0] CondW,
	output logic [3:0] ALUFlagsW,
	input logic [31:0] PCNext
);	

	// Wires
	
	// Fetch *****************************************************************************
	
	logic [31:0] PCPlus4, PCF, PCD;
	
	// Decode ****************************************************************************
	
	logic [3:0] RA1, RA2;
	logic [31:0] ExtImm;
	logic [31:0] RD1D, RD2D;
	logic RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, FlagsWriteE;
	logic [2:0] ALUControlE;
	logic [3:0] CondE, WA3E, ALUFlagsE;
	logic [31:0] rd1E, rd2E, ExtImmE, PCE;
	
	
	// Execute ***************************************************************************
	
	logic [31:0] SrcBE, ALUResultE, PCM;
	logic BranchM, RegWriteM, MemtoRegM, FlagsWriteM;
	logic [3:0] WA3M, CondM, ALUFlagsM;
	// Compuertas resultados
	//logic PCSrcEX1, PCSrcEX2, RegWriteEX, MemWriteEX, BranchEX;

	// MEM *******************************************************************************
	
	logic RegWriteW, MemtoRegW;
	logic [31:0] ReadDataW, ALUOutW;
	logic [3:0] WA3W;
	
	// WB ********************************************************************************
	logic [31:0] Result;

	
	// Etapas:
	
	
	// Fetch ---------------------------------------------------------------------
	
	//mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	
	//flopr #(32) pcreg(clk, reset, start, PCNext, PCF);
	
	//adder #(32) pcadd1(PCF, 32'b100, PCPlus4);
	//adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);
	
	segment_if_id seg_if_id (clk, reset, InstrF, PCNext, InstrD, PCD);
	
	
	// Decode ----------------------------------------------------------------------
	
	
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
	
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
	
	regfile rf(clk, RegWriteW, RA1, RA2, WA3W, Result,RD1D, RD2D);
	// Tambien hay que quitar regwrite
					
	extend ext(InstrD[23:0], ImmSrc, ExtImm);
	
	segment_id_ex seg_id_ex (clk, reset, 
								RegWrite, MemtoReg, MemWrite, 
								ALUControl,
								Branch, 
								ALUSrc, 
								FlagsWriteD,
								InstrD[15:12], InstrD[31:28], RD1D, RD2D, ExtImm, PCD,
								// salidas
								RegWriteE, MemtoRegE, MemWriteE,
								ALUControlE, 
								BranchE,
								ALUSrcE, 
								FlagsWriteE,
								WA3E,CondE,
								rd1E, rd2E, ExtImmE, PCE);
	
	// Execute ------------------------------------------------------------------------------
	
	mux2 #(32) srcbmux(rd2E, ExtImmE, ALUSrcE, SrcBE);
	
	alu #(32) alu(rd1E, SrcBE, ALUControlE, ALUResultE, ALUFlagsE); // Las ALU FLAGS ESTÁN HACIENDO NADA
	
//	and_2 a1 (PCSrcE, CondEx, PCSrcEX1);
//	
//	and_2 a2 (RegWriteE, CondEx, RegWriteEX);
//	
//	and_2 a3 (MemWriteE, CondEx, MemWriteEX);
//	
//	and_2 a4 (BranchE, CondEx, BranchEX);
//	
//	or_2 o1 (PCSrcEX1, BranchEX, PCSrcEX2);
	
	segment_ex_mem seg_ex_mem (clk, reset,
								BranchE, RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE,
								ALUResultE, rd2E, PCE, WA3E, CondE, ALUFlagsE,
								// Salidas
								BranchM, RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM,
								ALUOutM, WriteDataM, PCM, WA3M, CondM, ALUFlagsM);
		
	// MEM -----------------------------------------------------------------
	
	segment_mem_wb seg_mem_wb (clk, reset,
								BranchM, RegWriteM, MemtoRegM, FlagsWriteM,
								ReadData, ALUOutM, PCM, 
								WA3M, CondM, ALUFlagsM,
								// salidas
								BranchW, RegWriteW, MemtoRegW, FlagsWriteW,
								ReadDataW, ALUOutW, PCW,
								WA3W, CondW, ALUFlagsW);
								
	// WB --------------------------------------------------------------------
					
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoRegW, Result);
	
endmodule