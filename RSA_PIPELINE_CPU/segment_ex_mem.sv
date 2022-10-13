module segment_ex_mem 
(
	// Entradas
	input logic clk, reset, RegWriteE, MemtoRegE, MemWriteE, FlagsWriteE, ALUFlagZeroE,
	input logic [3:0] WA3E,
	input logic [31:0] ALUResultE, WriteDataE,
	
	// Salidas
	output logic RegWriteM, MemtoRegM, MemWriteM, FlagsWriteM, ALUFlagZeroM,
	output logic [3:0] WA3M,
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
				ALUFlagZeroM = 0;
				
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
				ALUFlagZeroM = ALUFlagZeroE;
				
			end
		
endmodule