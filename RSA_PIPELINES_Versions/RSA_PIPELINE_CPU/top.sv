//import arm_const::*;
module top
(
	input logic clk, reset, start
);
	
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;
	logic [31:0] PC, Instr, ReadData;
	
	
	
	// instantiate processor and memories
	arm arm(clk, reset, start, PC, Instr, MemWrite, DataAdr,
				WriteData, ReadData);
	
	imem imem(PC, clk, Instr);
	
	dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
	
endmodule