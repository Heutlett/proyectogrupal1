 module segment_mem_wb (input logic clk, rst,
								input logic RegWriteM, MemtoRegM, FlagsWriteM,
								input logic [31:0] ReadDataM, ALUOutM,
								input logic [3:0] WA3M, ALUFlagsM,
								output logic RegWriteW, MemtoRegW, FlagsWriteW,
								output logic [31:0] ReadDataW, ALUOutW,
								output logic [3:0] WA3W, ALUFlagsW);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutW = 0;
				WA3W = 0;
				FlagsWriteW = 0;
				ALUFlagsW = 0;
				
			end
			
		else 
			begin
			
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutW = ALUOutM;
				WA3W = WA3M;
				FlagsWriteW = FlagsWriteM;
				ALUFlagsW = ALUFlagsM;
				
			end
		
endmodule
