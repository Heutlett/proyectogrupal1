module pc_control_unit
(	
	// Entradas
	input logic clk, reset, FlagsWrite, start,
	input logic ZeroFlagIn,
	input logic [3:0] Id,
	input logic [17:0] Imm,
	
	// Salidas
	output logic ZeroFlagOut, EndFlag, COMFlag,
	output logic [31:0] PCNext
);

	logic FlagTemp, COMFlagTemp;
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
								
	flopenr #(1) flagreg2(
								// Entradas
								.clk(clk), 
								.reset(reset), 
								.en(COMFlagTemp), 
								.d(1'b1), 
								// Salidas
								.q(COMFlag)
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
	
			4'b0000: PC <= PCNext + 4;		 		// NOP
		
		
			4'b0001: begin 							// COM
			
				PC <= PCNext + 4;							
				$display("\n\n *** Se inicia la comunicacion con el interprete ***");
				
			end
		
			4'b0010: begin 
			
				PC <= PCNext;							// END
				$display("\n\n *** El programa ha terminado exitosamente ***");
				
			end
	
			4'b1100: PC <= Imm; 						// JMP
			
			4'b1110: if (FlagTemp) PC <= Imm;	// JEQ
						else PC <= PCNext + 4;
			
			default: PC <= PCNext + 4;				// Not control instruction
		
		endcase
		
	end
	
	assign ZeroFlagOut = FlagTemp;
	assign EndFlag = (Id == 4'b0010);
	assign COMFlagTemp = (Id == 4'b0001);
	
endmodule