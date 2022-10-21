module regfile
(
	// Entradas
	input logic clk, WE3,
	input logic [3:0] RA1, RA2, RA3,
	input logic [31:0] WD3,
	// Salidas
	output logic [31:0] RD1, RD2
);

	logic [31:0] rf[8:0];
	
	always_ff @(posedge clk) begin
	
		if (WE3) rf[RA3] <= WD3;
		
	end
		
	assign RD1 = rf[RA1];
	assign RD2 = rf[RA2];
	
endmodule