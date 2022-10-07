module pc_control_unit
(	
	// Entradas
	input logic clk, reset,
	input logic [1:0] Branch, 
	input logic FlagsWrite,
	input logic [3:0] Cond, ALUFlags,
	input logic [23:0] Imm,
	input logic [31:0] PCF,
	input logic start,
	
	// Salidas
	output logic PCSrc, 
	output logic [31:0] PCNext
	
);

	logic [3:0] Flags;
	logic [31:0] PC;
	logic PCSrcAux;
	logic CondEx;
	
	flopenr #(4)flagreg1(clk, reset, FlagsWrite, ALUFlags, Flags);
	
	flopr #(32) pcreg(clk, reset, start, PC, PCNext);
	
	condcheck cc(Cond, Flags, CondEx);

	always_comb begin
	
				
		if((Branch == 2'b10) & CondEx) begin
		
			//PCSrcAux <= 1;
			PC <= Imm + PCNext; 
		
		end
		else begin
			
			//PCSrcAux <= 0;
			PC <= PCNext + 4;
			
		end

		
	end
	
	

	//assign PCSrc = PCSrcAux;
	//assign PCNext = PC;
	
					
endmodule