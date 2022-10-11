module data_mem
(
	// Entradas
	input logic clk, WriteEnable,
	input logic [31:0] DataAddress, WriteData,
	
	// Salidas
	output logic [31:0] ReadData
);
	
	// Se inicializa la memoria de datos
	initial 
		$readmemh("data_mem_init.dat",RAM);
	
	logic [31:0] RAM[50:0];
	
	always_ff @(posedge clk) begin
	
		if (WriteEnable) begin
		
			RAM[DataAddress[13:2]] = WriteData;
			
			$display("\n\n---Write cycle DataMem----");
			$display("Address (hex):---------- %h", DataAddress);
			$display("Write data (hex):------- %h", WriteData);
			$display("Write data (dec):------- %d", WriteData);

		end
		
	end
	
	assign ReadData = RAM[DataAddress[13:2]];
	
	
	
endmodule
