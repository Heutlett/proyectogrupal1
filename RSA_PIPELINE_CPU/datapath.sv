module datapath
(
	input logic clk, reset, RegWrite, ALUSrc, MemtoReg, MemWrite, FlagsWriteD,
	input logic [1:0] RegSrc, ImmSrc,
	input logic [2:0] ALUControl,
	input logic [31:0] InstrF, ReadData, PCNext,
	
	output logic MemWriteM, FlagsWriteW, 
	output logic [3:0] ALUFlagsW,
	output logic [31:0] ALUOutM, WriteDataM, InstrD
);	

	// ***************************** Wires ***********************************************
	
	// Fetch *****************************************************************************
	
	
	// Decode ****************************************************************************
	
	logic [3:0] RA1, RA2;
	logic [31:0] ExtImm;
	logic [31:0] RD1D, RD2D;
	logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, FlagsWriteE;
	logic [2:0] ALUControlE;
	logic [3:0] WA3E, ALUFlagsE;
	logic [31:0] rd1E, rd2E, ExtImmE;
	
	
	// Execute ***************************************************************************
	
	logic [31:0] SrcBE, ALUResultE;
	logic RegWriteM, MemtoRegM, FlagsWriteM;
	logic [3:0] WA3M, ALUFlagsM;

	// MEM *******************************************************************************
	
	logic RegWriteW, MemtoRegW;
	logic [31:0] ReadDataW, ALUOutW;
	logic [3:0] WA3W;
	
	// WB ********************************************************************************
	logic [31:0] Result;

	
	// ------------------------------- Etapas --------------------------------------
	
	
	// Fetch -----------------------------------------------------------------------
	
	segment_if_id seg_if_id (clk, reset, InstrF, InstrD);
	
	
	// Decode ----------------------------------------------------------------------
	
	
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
	
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
	
	regfile rf(clk, RegWriteW, RA1, RA2, WA3W, Result,RD1D, RD2D);
					
	extend ext(InstrD[23:0], ImmSrc, ExtImm);
	
	segment_id_ex seg_id_ex (clk, reset, 
								RegWrite, MemtoReg, MemWrite, 
								ALUControl,
								ALUSrc, 
								FlagsWriteD,
								InstrD[15:12], RD1D, RD2D, ExtImm,
								// salidas
								RegWriteE, MemtoRegE, MemWriteE,
								ALUControlE, 
								ALUSrcE, 
								FlagsWriteE,
								WA3E,
								rd1E, rd2E, ExtImmE);
	
	// Execute ------------------------------------------------------------------------------
	
	mux2 #(32) srcbmux(rd2E, ExtImmE, ALUSrcE, SrcBE);
	
	alu #(32) alu(rd1E, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);
	
	segment_ex_mem seg_ex_mem (clk, reset,
								RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE,
								ALUResultE, rd2E, WA3E, ALUFlagsE,
								// Salidas
								RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM,
								ALUOutM, WriteDataM, WA3M, ALUFlagsM);
		
	// MEM -----------------------------------------------------------------
	
	segment_mem_wb seg_mem_wb (clk, reset,
							   RegWriteM, MemtoRegM, FlagsWriteM,
								ReadData, ALUOutM, 
								WA3M, ALUFlagsM,
								// salidas
								RegWriteW, MemtoRegW, FlagsWriteW,
								ReadDataW, ALUOutW,
								WA3W, ALUFlagsW);
								
	// WB --------------------------------------------------------------------
					
	mux2 #(32) resmux(ALUOutW, ReadDataW, MemtoRegW, Result);
	
endmodule