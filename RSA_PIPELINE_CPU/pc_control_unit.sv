module pc_control_unit
(	
	// Entradas
	input logic clk, reset, FlagsWrite, start,
	input logic [3:0] ALUFlags,
	input logic [3:0] Id,
	input logic [17:0] Imm,
	
	// Salidas
	output logic FlagZero,
	output logic [31:0] PCNext
);

	logic [3:0] Flags;
	logic [31:0] PC;
	
	flopenr #(4) flagreg1(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(FlagsWrite), 
								.d(ALUFlags), 
								// Salidas
								.q(Flags)
								);
	
	flopr #(32) pcreg	(
							// Entradas
							.clk(clk), 
							.reset(reset), 
							.start(start), 
							.d(PC), 
							// Salidas
							.q(PCNext)
							);
							
	always_comb begin
	
		case(Id)
	
			4'b1100: PC <= Imm; 						// JMP
			
			4'b1101: if (Flags[2]) PC <= Imm;	// JEQ
						else PC <= PCNext + 4;
			
			4'b1110: if (!Flags[2]) PC <= Imm;	// JNE
						else PC <= PCNext + 4;
			
			default: PC <= PCNext + 4;				// Not control instruction
		
		endcase
		
	end
	
	assign FlagZero = Flags[2];
			
endmodule