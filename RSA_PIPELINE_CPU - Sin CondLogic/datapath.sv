module datapath
(
	input logic clk, reset, start,
	
	input logic [1:0] RegSrc,
	input logic RegWrite,
	input logic [1:0] ImmSrc,
	input logic ALUSrc,
	input logic [2:0] ALUControl,
	input logic MemtoReg, MemWrite, Branch, FlagsWriteD,
	
	output logic [31:0] PC,
	input logic [31:0] InstrF,
	output logic [31:0] ALUOutM, WriteDataM,
	input logic [31:0] ReadData,
	output logic [31:0] InstrD,
	output logic MemWriteM
);	

	// Wires
	
	// Fetch *****************************************************************************
	
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	
	// Decode ****************************************************************************
	
	logic [3:0] RA1, RA2;
	logic [31:0] ExtImm;
	logic [31:0] RD1D, RD2D;
	logic RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, FlagWriteE;
	logic [2:0] ALUControlE;
	logic [3:0] CondE, WA3E;
	logic [31:0] rd1E, rd2E, ExtImmE;
	
	
	// Execute ***************************************************************************
	
	logic [31:0] SrcBE, ALUResultE;
	logic PCSrcM, RegWriteM, MemtoRegM;
	logic [3:0] WA3M;
	// Compuertas resultados
	//logic PCSrcEX1, PCSrcEX2, RegWriteEX, MemWriteEX, BranchEX;

	// MEM *******************************************************************************
	
	logic PCSrcW, RegWriteW, MemtoRegW;
	logic [31:0] ReadDataW, ALUOutW;
	logic [3:0] WA3W;
	
	// WB ********************************************************************************
	logic [31:0] Result;

	
	// Etapas:
	
	
	// Fetch ---------------------------------------------------------------------
	
	mux2 #(32) pcmux(PCPlus4, Result, PCSrcW, PCNext);
	
	flopr #(32) pcreg(clk, reset, start, PCNext, PC);
	
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	//adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);
	
	segment_if_id seg_if_id (clk, reset, InstrF, InstrD);
	
	
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
								InstrD[15:12], InstrD[31:28], RD1D, RD2D, ExtImm,
								// salidas
								RegWriteE, MemtoRegE, MemWriteE,
								ALUControlE, 
								BranchE,
								ALUSrcE, 
								WA3E,CondE,
								rd1E, rd2E, ExtImmE);
	
	// Execute ------------------------------------------------------------------------------
	
	mux2 #(32) srcbmux(rd2E, ExtImmE, ALUSrcE, SrcBE);
	
	alu #(32) alu(rd1E, SrcBE, ALUControlE, ALUResultE, ALUFlags); // Las ALU FLAGS ESTÁN HACIENDO NADA
	
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
								BranchE, RegWriteE, MemtoRegE, MemWriteE,
								ALUResultE, rd2E, WA3E,
								// Salidas
								PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
								ALUOutM, WriteDataM, WA3M);
		
	// MEM -----------------------------------------------------------------
	
	segment_mem_wb seg_mem_wb (clk, reset,
								PCSrcM, RegWriteM, MemtoRegM, 
								ReadData, ALUOutM, WA3M, 
								// salidas
								PCSrcW, RegWriteW, MemtoRegW,
								ReadDataW, ALUOutW, 
								WA3W);
								
	// WB --------------------------------------------------------------------
					
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoRegW, Result);
	
endmodule