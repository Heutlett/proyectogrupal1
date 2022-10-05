 module segment_if_id (input logic clk, rst,
								input logic [31:0] instruction,
								output logic [31:0] instruction_out);
			
	always_ff@(negedge clk, posedge rst)
		if(rst)
			begin
				instruction_out = 0;
			end
			
		else 
			begin
				instruction_out = instruction;
			end
		
endmodule