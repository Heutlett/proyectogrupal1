 module segment_ex_mem (input logic clk, rst,
								input logic RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE,
								input logic [31:0] ALUResultE, WriteDataE,
								input logic [3:0] WA3E, ALUFlagsE,
								output logic RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM,
								output logic [31:0] ALUOutM, WriteDataM, 
								output logic [3:0] WA3M, ALUFlagsM);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				
				RegWriteM = 0;
				MemtoRegM = 0;
				MemWriteM = 0;
				ALUOutM = 0;
				WriteDataM = 0;
				WA3M = 0;
				FlagsWriteM = 0;
				ALUFlagsM = 0;
				
			end
			
		else 
			begin
			
				RegWriteM = RegWriteE;
				MemtoRegM = MemtoRegE;
				MemWriteM = MemWriteE;
				ALUOutM = ALUResultE;
				WriteDataM = WriteDataE;
				WA3M = WA3E;
				FlagsWriteM = FlagsWriteE;
				ALUFlagsM = ALUFlagsE;
				
			end
		
endmodule