module TB_TOP();
	logic clk, reset, start, FlagZero, EndFlag;
	logic [31:0] ReadData;
	
	// instantiate device to be tested
	top dut(
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.FlagZero(FlagZero),
		.EndFlag(EndFlag),
		.ReadData(ReadData)
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