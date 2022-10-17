module TB_TOP();
	logic clk, reset, start, EndFlag, COMFlag, ReadEnable;
	logic [1:0] ALUFlags;
	logic [7:0] ByteOut;
	
	// instantiate device to be tested
	top dut(
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.ALUFlags(ALUFlags),
		.EndFlag(EndFlag),
		.COMFlag(COMFlag),
		.clk_out(ReadEnable),
		.ReadDataOut(ByteOut)
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