module regfile
(
	// Entradas
	input logic clk, WriteEnable,
	input logic [3:0] ra1, ra2, ra3,
	input logic [31:0] WriteData,
	// Salidas
	output logic [31:0] rd1, rd2
);

	logic [31:0] rf[14:0];
	
	always_ff @(posedge clk) begin
	
		if (WriteEnable) rf[ra3] <= WriteData;
		
	end
		
	assign rd1 = rf[ra1];
	assign rd2 = rf[ra2];
	
endmodule