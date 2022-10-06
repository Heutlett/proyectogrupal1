 module segment_mem_wb (input logic clk, rst,
								input logic PCSrcM, RegWriteM, MemtoRegM, 
								input logic [31:0] ReadDataM, ALUOutM,
								input logic [3:0] WA3M, 
								output logic PCSrcW, RegWriteW, MemtoRegW,
								output logic [31:0] ReadDataW, ALUOutW, 
								output logic [3:0] WA3W);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				
				PCSrcW = 0;
				RegWriteW = 0;
				MemtoRegW = 0;
				ReadDataW = 0;
				ALUOutW = 0;
				WA3W = 0;
				
			end
			
		else 
			begin
			
				PCSrcW = PCSrcM;
				RegWriteW = RegWriteM;
				MemtoRegW = MemtoRegM;
				ReadDataW = ReadDataM;
				ALUOutW = ALUOutM;
				WA3W = WA3M;
				
			end
		
endmodule
