module control_unit
(	
	// Entradas
	input logic [1:0] Op,
	input logic [5:0] Funct,
	
	// Salidas
	output logic RegWrite, MemtoReg, MemWrite, ALUSrc, FlagsWrite, ImmSrc, RegSrc,
	output logic [2:0] ALUControl
);
	
	// RegSrc: señal de seleccion de los dos mux que entran al banco de registros.
					// El MSB (ra2mux): selecciona entre RM y RD
					
	//	ImmSrc: señal del extensor:
					// 0: 8-bit unsigned immediate
					// 1: 12-bit unsigned immediate
					
	// ALUSrc: señal de seleccion de la entrada B del ALU.
					// 0: selecciona el registro RD2.
				   // 1: selecciona el immediato exentedido.
	
	// MemtoReg: señal del mux que selecciona entre el resultado de la ALU o el dato leido de mem.
					// 0: ALURESULT
					// 1: ReadData (mem)
	
	// RegWrite: enable para escribir en el banco de registros
	
	// MemWrite: enable para escribir en la memoria
	
	
	// Instruction decoder
	always_comb
		casex(Op)
										
			2'b00: begin	// Data-processing 
			
					if (Funct[5]) ALUSrc = 1;			// Si la instruccion utiliza el inmediato
					else ALUSrc = 0;
					
					if (Funct[4:1] == 4'b1010) begin // CMP: modifica las banderas pero no registros
						FlagsWrite = 1;
						RegWrite = 0;
						
					end else begin 						// Operaciones sobre registros: modifica registros pero no banderas
						FlagsWrite = 0;
						RegWrite = 1;
					end
					
					RegSrc = 0; 
					ImmSrc = 0;
					MemtoReg = 0;
					MemWrite = 0;
				
			end
				
			2'b01: begin
					
					if (Funct[0])	begin // LDR	
					
						FlagsWrite = 0;
						RegSrc = 0; 
						ImmSrc = 1;
						ALUSrc = 1;
						MemtoReg = 1;
						RegWrite = 1;
						MemWrite = 0;
						
					end else begin // STR
						
						FlagsWrite = 0;
						RegSrc = 1; 
						ImmSrc = 1;
						ALUSrc = 1;
						MemtoReg = 1;
						RegWrite = 0;
						MemWrite = 1;
					end
			end

			default: begin // Unimplemented
						
						FlagsWrite = 1'bx;
						RegSrc = 2'bx; 
						ImmSrc = 1'bx;
						ALUSrc = 1'bx;
						MemtoReg = 1'bx;
						RegWrite = 1'bx;
						MemWrite = 1'bx;
			end		    
			
		endcase
	
	// ALU Decoder
	always_comb
		case(Funct[4:1])
			4'b0100: ALUControl = 3'b000; // ADD
			4'b0010: ALUControl = 3'b001; // SUB
			4'b0000: ALUControl = 3'b010; // AND
			4'b1100: ALUControl = 3'b011; // ORR
			4'b1010: ALUControl = 3'b001; // COMPARE
			4'b1101: ALUControl = 3'b100; // MOV
			default: ALUControl = 3'bx; // unimplemented
		endcase
					
endmodule