module TB_TOP();
	logic clk;
	logic reset;
	logic start;
	logic [3:0] result;
	
	// instantiate device to be tested
	top dut(
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.result(result)
	);
	
	// initialize test
	initial begin
		reset <= 1; # 22; reset <= 0;
		start <= 0; # 3; start <= 1;
	end
	
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
	
		
endmodule