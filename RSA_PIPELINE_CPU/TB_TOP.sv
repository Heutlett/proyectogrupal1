module TB_TOP();
	logic clk, reset, start, FlagZero, EndFlag, COMFlag;
	logic [31:0] ReadDataOut;
	
	// instantiate device to be tested
	top dut(
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.FlagZero(FlagZero),
		.EndFlag(EndFlag),
		.COMFlag(COMFlag),
		.ReadDataOut(ReadDataOut)
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