 module segment_if_id (input logic clk, rst,
								input logic [31:0] instrF, PCF,
								output logic [31:0] instrD, PCD);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				instrD = 0;
				PCD = 0;
			end
			
		else 
			begin
				instrD = instrF;
				PCD = PCF;
			end
		
endmodule