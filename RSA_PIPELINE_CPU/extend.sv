module extend
(
	// Entradas
	input logic ImmSrc,
	input logic [23:0] Instr,
	
	// Salidas
	output logic [31:0] ExtImm
);
	logic [4:0] shift;
	logic [31:0] val;

	assign shift = {Instr[11:8], 1'b0};
	assign val   = {24'b0, Instr[7:0]};

	always_comb
	
		if (ImmSrc) ExtImm = (val >> shift) | (val << (32 - shift));	// 8-bit unsigned immediate
		else ExtImm = (val >> shift) | (val << (32 - shift));				// 12-bit unsigned immediate

endmodule