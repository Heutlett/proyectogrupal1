 module segment_ex_mem (input logic clk, rst,
								input logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
								input logic [31:0] ALUResultE, WriteDataE, 
								input logic [3:0] WA3E,
								output logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
								output logic [31:0] ALUOutM, WriteDataM, WA3M);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				
				PCSrcM = 0;
				RegWriteM = 0;
				MemtoRegM = 0;
				MemWriteM = 0;
				ALUOutM = 0;
				WriteDataM = 0;
				WA3M = 0;
				
			end
			
		else 
			begin
			
				PCSrcM = PCSrcE;
				RegWriteM = RegWriteE;
				MemtoRegM = MemtoRegE;
				MemWriteM = MemWriteE;
				ALUOutM = ALUResultE;
				WriteDataM = WriteDataE;
				WA3M = WA3E;
				
			end
		
endmodule