 module segment_id_ex (input logic clk, rst, 
								input logic PCSrcD, RegWriteD, MemtoRegD, ALUControlD, BranchD,
								input logic ALUSrcD, FlagWriteD, ImmSrcD,	
								input logic [3:0] condD, FlagsD, WA3D,
								input logic [31:0] rd1D, rd2D, ExtImmD,
								
								output logic PCSrcE, RegWriteE, MemtoRegE, ALUControlE, BranchE,
								output logic ALUSrcE, FlagWriteE, ImmSrcE,	
								output logic [3:0] condE, FlagsE, WA3E,
								output logic [31:0] rd1E, rd2E, ExtImmE
								
								);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				PCSrcE = 0;
				RegWriteE = 0;
				MemtoRegE = 0;
				ALUControlE = 0;
				BranchE = 0;
				ALUSrcE = 0;
				FlagWriteE = 0;
				ImmSrcE = 0;	
				condE = 0; 
				FlagsE = 0;
				WA3E = 0;
				rd1E = 0;
				rd2E = 0; 
				ExtImmE = 0;
			end
			
		else 
			begin
				PCSrcE = PCSrcD;
				RegWriteE = RegWriteD;
				MemtoRegE = MemtoRegD;
				ALUControlE = ALUControlD;
				BranchE = BranchD;
				ALUSrcE = ALUSrcD;
				FlagWriteE = FlagWriteD;
				ImmSrcE = ImmSrcD;
				condE = condD;
				FlagsE = FlagsD;
				WA3E = WA3D;
				rd1E = rd1D;
				rd2E = rd2D;
				ExtImmE = ExtImmD;
			end
		
endmodule