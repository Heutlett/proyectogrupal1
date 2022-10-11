module instr_mem
(
	// Entradas
	input clk,
	input logic [31:0] InstrAddress,
	
	
	// Salidas
	output logic [31:0] ReadInstr
);

	logic [31:0] RAM[150:0];
	
	// Se inicializa la memoria de instrucciones
	initial
		$readmemh("inst_mem_init.dat",RAM);
	
	assign ReadInstr = RAM[InstrAddress[31:2]];
	
endmodule