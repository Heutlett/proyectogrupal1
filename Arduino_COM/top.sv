module top
(
	// Entradas
	input logic clk, reset, start, 
	
	// Salidas
	output logic clk_out, fin, fin2,
	output logic [3:0] ReadDataOut
);
	logic [3:0] contador;
	
	clockDivider cd (clk, clk2);
	
	always_ff@(negedge clk2, posedge reset)
		if(reset)
			begin
				ReadDataOut = 0;
				contador = 0;
				clk_out = 0;
				fin = 0;
				fin2 = 0;
			end
			
		else 
			begin
				
				if(start & !fin) begin
				
					contador = contador + 1;
					ReadDataOut = contador;
					
					if(contador == 15) begin 
					
						contador = 0;
						fin = 1;
						fin2 = 1;
						clk_out = 0;
					
					end
					
					if(contador %2 == 0 & !fin) begin
					
						clk_out = 1;
					
					end
					else
						clk_out = 0;
						
					
					
				
				end
				
			end
		

	
endmodule