module segment_ex_mem 
(
	// Entradas
	input logic clk, reset, RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE,
	input logic [3:0] WA3E, ALUFlagsE,
	input logic [31:0] ALUResultE, WriteDataE,
	
	// Salidas
	output logic RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM,
	output logic [3:0] WA3M, ALUFlagsM,
	output logic [31:0] ALUOutM, WriteDataM
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
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