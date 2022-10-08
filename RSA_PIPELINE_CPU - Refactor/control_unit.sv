module control_unit
(	
	// Entradas
	input logic [1:0] Op,
	input logic [5:0] Funct,
	
	// Salidas
	output logic RegWriteD, MemtoRegD, MemWriteD,
	output logic [2:0] ALUControlD,
	output logic ALUSrcD,
	output logic [1:0] ImmSrcD, RegSrcD,
	output logic FlagsWriteD
	
);

	
	logic [10:0] controls;
	logic ALUOp;
	
	// Main Decoder
	always_comb
		casex(Op)
										
			2'b00: if (Funct[5] & Funct[4:1] == 4'b1010) 		controls = 11'b10000100001; // CMP Immediate
					else if(!Funct[5] & Funct[4:1] == 4'b1010) 	controls = 11'b10000000001; // CMP Register
					
					else if(Funct[5])										controls = 11'b00000101001; // Data-processing immediate			
					else 														controls = 11'b00000001001; // Data-processing register 
				
			2'b01: if (Funct[0])											controls = 11'b00001111000; // LDR														    				
			else 					 											controls = 11'b01001110100; // STR
										
			2'b10: 															controls = 11'b00110100010; // Be

			default: 														controls = 11'bx; 		    // Unimplemented
			
		endcase
	
	// Señales
	
	// RegSrcD: señal de seleccion de los dos mux que entran al banco de registros.
					// El LSB (ra1mux): selecciona entre RN y "15" (pc)
					// El MSB (ra2mux): selecciona entre RM y RD
					
	//	ImmSrcD: señal del extensor:
					// 00: 8-bit unsigned immediate
					// 01: 12-bit unsigned immediate
					// 10. 24-bit two's complement shifted BranchD
					
	// ALUSrcD: señal de seleccion de la entrada B del ALU.
					// 0: selecciona el registro RD2.
				   // 1: selecciona el immediato exentedido.
	
	// MemtoRegD: señal del mux que selecciona entre el resultado de la ALU o el dato leido de mem.
					// 0: ALURESULT
					// 1: ReadData (mem)
	
	// RegWriteD: enable para escribir en el banco de registros
	
	// MemWriteD: enable para escribir en la memoria
	
	// BranchD: bandera del branch, se utiliza para definir el PCSrc (al final esta el assign)
	
	// ALUOp: bandera para indicar  si se necesita la ALU, con esta se define el valor de
	// ALUControlD, abajo esta el decoder.
	
		
	//	CMP IMMEDIATE
	//			1					00			00			1			0		  		0     	0     	0      	1
	//	CMP REGISTER			
	//			1					00			00			0			0		  		0	  		0	  		0			1
	// Data-processing immediate
	//			0					00			00			1			0	  	  		1	  		0	  		0			1		
	// Data-processing register
	// 		0					00			00			0			0		  		1	  		0	  		0			1		
	// LDR
	//			0					00			01			1			1		  		1	  		0	  		0			0		
	// LDRB
	//			0					00			01			1			1		  		1	  		0	  		0	   	0		
	// STR
	// 		0					10			01			1			1		  		0	  		1	  		0			0		
	// STRB
	//			0 					10			01			1			1		  		0	  		1	  		0			0		
	// B
	// 		0					01			10			1			0		  		0	  		0	 		1			0		
	assign {FlagsWriteD, RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;
	
	// ALU Decoder
	always_comb
		case(Funct[4:1])
			4'b0100: ALUControlD = 3'b000; // ADD
			4'b0010: ALUControlD = 3'b001; // SUB
			4'b0000: ALUControlD = 3'b010; // AND
			4'b1100: ALUControlD = 3'b011; // ORR
			4'b1010: ALUControlD = 3'b001; // COMPARE
			4'b1101: ALUControlD = 3'b100; // MOV
			default: ALUControlD = 3'bx; // unimplemented
		endcase
		
					
endmodule