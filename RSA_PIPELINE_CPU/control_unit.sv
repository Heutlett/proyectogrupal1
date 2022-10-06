module control_unit
(	
	// Entradas
	input logic [1:0] Op,
	input logic [5:0] Funct,
	input logic [3:0] Rd,
	
	// Salidas
	output logic PCSrcD, RegWriteD, MemtoRegD, MemWriteD,
	output logic [2:0] ALUControlD,
	output logic BranchD, ALUSrcD,
	output logic [1:0] FlagWriteD,
	output logic [1:0] ImmSrcD, RegSrcD
	
);

	
	logic [9:0] controls;
	logic ALUOp;
	
	// Main Decoder
	always_comb
		casex(Op)
										
			2'b00: if (Funct[5] & Funct[4:1] == 4'b1010) 		controls = 10'b0000100001; // CMP Immediate
					else if(!Funct[5] & Funct[4:1] == 4'b1010) 	controls = 10'b0000000001; // CMP Register
					
					else if(Funct[5])										controls = 10'b0000101001; // Data-processing immediate			
					else 														controls = 10'b0000001001; // Data-processing register 
				
			2'b01: if (Funct[0])											controls = 10'b0001111000; // LDR														    				
			else 					 											controls = 10'b1001110100; // STR
										
			2'b10: 															controls = 10'b0110100010; // Be
										
			default: 														controls = 10'bx; 		    // Unimplemented
			
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
	//			00			00			1			0		  0     0     0      1
	//	CMP REGISTER			
	//			00			00			0			0		  0	  0	  0		1
	// Data-processing immediate
	//			00			00			1			0	  	  1	  0	  0		1		
	// Data-processing register
	// 		00			00			0			0		  1	  0	  0		1		
	// LDR
	//			00			01			1			1		  1	  0	  0		0		
	// LDRB
	//			00			01			1			1		  1	  0	  0	   0		
	// STR
	// 		10			01			1			1		  0	  1	  0		0		
	// STRB
	//			10			01			1			1		  0	  1	  0		0		
	// B
	// 		01			10			1			0		  0	  0	  1		0		
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOp} = controls;
	
	// ALU Decoder
	always_comb
	
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: ALUControlD = 3'b000; // ADD
				4'b0010: ALUControlD = 3'b001; // SUB
				4'b0000: ALUControlD = 3'b010; // AND
				4'b1100: ALUControlD = 3'b011; // ORR
				4'b1010: ALUControlD = 3'b001; // COMPARE
				4'b1101: ALUControlD = 3'b100; // MOV
				default: ALUControlD = 3'bx; // unimplemented
			endcase
			
		// update flags if S bit is set (C & V only for arith)
		FlagWriteD[1] = Funct[0];
		FlagWriteD[0] = Funct[0] & (ALUControlD == 3'b000 | ALUControlD == 3'b001);
		
		end else begin
			ALUControlD 	= 3'b000; 	// add for non-DP instructions
			FlagWriteD 		= 2'b00; 		// don't update Flags
		end
		
	// PC Logic
	assign PCSrcD = BranchD;
					
endmodule