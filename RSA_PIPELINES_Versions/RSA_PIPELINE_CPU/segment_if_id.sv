 module segment_if_id (input logic clk, rst,
								input logic [31:0] instrF,
								output logic [31:0] instrD);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				instrD = 0;
			end
			
		else 
			begin
				instrD = instrF;
			end
		
endmodule