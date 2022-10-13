module interpreter_coumunication
(
	// Entradas
	input logic clk, reset, MemtoReg, COM,
	input logic [31:0] ReadData,
	
	// Salidas
	output logic [31:0] ReadDataOut
);

	always_ff @(posedge clk, posedge reset) begin
	
		if (reset) ReadDataOut <= 0;
		else if(MemtoReg & COM) ReadDataOut <= ReadData;
		
	end
	
	
endmodule
