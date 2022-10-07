module pc_control_unit
(	
	// Entradas
	input logic clk, reset,
	input logic Branch, FlagsWrite,
	input logic [3:0] Cond, ALUFlags,
	input logic [23:0] Imm,
	input logic [31:0] PCF,
	
	// Salidas
	output logic PCSrc, 
	output logic [31:0] PCNext
	
);

	logic [3:0] Flags;
	logic [31:0] PC;
	logic PCSrcAux;
	logic CondEx;
	
	flopenr #(4)flagreg1(clk, reset, FlagsWrite, ALUFlags, Flags);
	
	condcheck cc(Cond, Flags, CondEx);

	always_ff @(posedge clk, posedge reset) begin
	
		
		if (reset) begin 
		
			PC <= 0;
			PCSrcAux <= 0;
		
		end 
		
		else begin
		
				
			if(Branch & CondEx) begin
			
				PCSrcAux <= 1;
				PC <= Imm + PCF; 
			
			end
			else begin
			
				PC <= PCF;
				
			end
		
		end

		
	end
	
	

	assign PCSrc = PCSrcAux;
	assign PCNext = PC;
	
					
endmodule