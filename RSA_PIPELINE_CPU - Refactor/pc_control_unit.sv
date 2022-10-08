module pc_control_unit
(	
	// Entradas
	input logic clk, reset, FlagsWrite, start,
	input logic [1:0] Branch, 
	input logic [3:0] Cond, ALUFlags,
	input logic [23:0] Imm,
	
	// Salidas
	output logic [31:0] PCNext
	
);

	logic [3:0] Flags;
	logic [31:0] PC;
	logic CondEx;
	
	flopenr #(4)flagreg1(clk, reset, FlagsWrite, ALUFlags, Flags);
	
	flopr #(32) pcreg(clk, reset, start, PC, PCNext);
	
	condcheck cc(Cond, Flags, CondEx);

	always_comb begin
	
				
		if((Branch == 2'b10) & CondEx) begin
		
			PC <= Imm; 
		
		end
		else begin
			
			PC <= PCNext + 4;
			
		end

		
	end
			
endmodule