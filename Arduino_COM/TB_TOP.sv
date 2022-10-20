module TB_TOP();
	logic clk, reset, start, fin,fin2;
	logic clk_out;
	logic [3:0] ReadDataOut;
	
	// instantiate device to be tested
	top dut(
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.fin(fin),
		.fin2(fin2),
		.clk_out(clk_out),
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