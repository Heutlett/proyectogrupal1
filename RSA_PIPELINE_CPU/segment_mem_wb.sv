module segment_mem_wb 
(
	// Entradas
	input logic clk, reset, RegWriteM, MemtoRegM, FlagsWriteM, ALUFlagZeroM,
	input logic [3:0] WA3M, 
	input logic [31:0] ReadDataM, ALUOutM,
	
	
	// Salidas
	output logic RegWriteW, MemtoRegW, FlagsWriteW, ALUFlagZeroW,
	output logic [3:0] WA3W,
	output logic [31:0] ReadDataW, ALUOutW
);
			
	always_ff@(negedge clk, posedge reset)
		if(reset)
			begin
				
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutW = 0;
				WA3W = 0;
				FlagsWriteW = 0;
				ALUFlagZeroW = 0;
				
			end
			
		else 
			begin
			
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutW = ALUOutM;
				WA3W = WA3M;
				FlagsWriteW = FlagsWriteM;
				ALUFlagZeroW = ALUFlagZeroM;
				
			end
		
endmodule
