 module segment_mem_wb (input logic clk, rst,
								input logic PCSrcM, RegWriteM, MemtoRegM, FlagsWriteM,
								input logic [31:0] ReadDataM, ALUOutM, PCM,
								input logic [3:0] WA3M, CondM, ALUFlagsM,
								output logic PCSrcW, RegWriteW, MemtoRegW, FlagsWriteW,
								output logic [31:0] ReadDataW, ALUOutW, PCW,
								output logic [3:0] WA3W, CondW, ALUFlagsW);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				
				PCSrcW = 0;
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutW = 0;
				WA3W = 0;
				CondW = 0; 
				FlagsWriteW = 0;
				ALUFlagsW = 0;
				PCW = 0;
				
			end
			
		else 
			begin
			
				PCSrcW = PCSrcM;
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutW = ALUOutM;
				WA3W = WA3M;
				CondW = CondM;
				FlagsWriteW = FlagsWriteM;
				ALUFlagsW = ALUFlagsM;
				PCW = PCM;
				
			end
		
endmodule
