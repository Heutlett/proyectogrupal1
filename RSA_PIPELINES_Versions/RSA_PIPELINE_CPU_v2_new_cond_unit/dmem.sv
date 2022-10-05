module dmem
(
	input logic clk, we,
	input logic [31:0] a, wd,
	output logic [31:0] rd
);

	logic ram_select;
	logic vram_select;
	logic [13:0] addr;
	
	assign addr = a[13:0];
	
	
	initial $readmemh("data_mem_init.dat",RAM);
	
	logic [31:0] RAM[255:0];
	
	always_ff @(posedge clk) begin
		if (we) begin
			RAM[a[13:2]] = wd;
			
			$display("\n\n---Write cycle DMEM----");
			$display("Address (hex):---------- %h", a);
			$display("Write data (hex):------- %h", wd);
			$display("Write data (dec):------- %d", wd);

		end
	end
	
	assign rd = RAM[a[13:2]];
	
	
	
endmodule
