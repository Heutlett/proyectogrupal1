module pc_control_unit
(	
	// Entradas
	input logic clk, reset, FlagsWrite, start,
	input logic ZeroFlagIn,
	input logic [2:0] Id,
	input logic [17:0] Imm,
	
	// Salidas
	output logic ZeroFlagOut, EndFlag,
	output logic [31:0] PCNext
);

	logic FlagTemp;
	logic [31:0] PC;
	
	flopenr #(1) flagreg1(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(FlagsWrite), 
								.d(ZeroFlagIn), 
								// Salidas
								.q(FlagTemp)
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
	
			3'b000: PC <= PCNext + 4;		 		// NOP
			
			3'b001: begin 
			
				PC <= PCNext;							// END
				$display("\n\n *** El programa ha terminado exitosamente ***");
				
			end
	
			3'b110: PC <= Imm; 						// JMP
			
			3'b111: if (FlagTemp) PC <= Imm;		// JEQ
						else PC <= PCNext + 4;
			
			default: PC <= PCNext + 4;				// Not control instruction
		
		endcase
		
	end
	
	assign ZeroFlagOut = FlagTemp;
	assign EndFlag = (Id == 3'b001);
			
endmodule