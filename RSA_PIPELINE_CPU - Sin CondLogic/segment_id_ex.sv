 module segment_id_ex (input logic clk, rst, 
								input logic RegWriteD, MemtoRegD, MemWriteD, 
								input logic [2:0] ALUControlD, 
								input logic ALUSrcD,
								input logic FlagsWriteD,
								input logic [3:0] WA3D,
								input logic [31:0] rd1D, rd2D, ExtImmD,
								
								output logic RegWriteE, MemtoRegE, MemWriteE,
								output logic [2:0] ALUControlE, 
								output logic ALUSrcE,
								output logic FlagsWriteE,
								output logic [3:0] WA3E,
								output logic [31:0] rd1E, rd2E, ExtImmE
								
								);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				RegWriteE = 0;
				MemtoRegE = 0;
				MemWriteE = 0;
				ALUControlE = 0;
				ALUSrcE = 0;
				WA3E = 0;
				rd1E = 0;
				rd2E = 0; 
				ExtImmE = 0;
				FlagsWriteE = 0;
			end
			
		else 
			begin
				RegWriteE = RegWriteD;
				MemtoRegE = MemtoRegD;
				MemWriteE = MemWriteD;
				ALUControlE = ALUControlD;
				ALUSrcE = ALUSrcD;
				WA3E = WA3D;
				rd1E = rd1D;
				rd2E = rd2D;
				ExtImmE = ExtImmD;
				FlagsWriteE = FlagsWriteD;
			end
		
endmodule