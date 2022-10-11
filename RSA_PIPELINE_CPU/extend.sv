module extend
(
	// Entradas
	input logic [23:0] Instr,
	
	// Salidas
	output logic [31:0] ExtImm
);

	assign ExtImm = {24'b0, Instr[7:0]} ;											

endmodule