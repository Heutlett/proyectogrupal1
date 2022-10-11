module alu
#(parameter N = 4)
(
	// Entradas
	input logic [N-1:0] a_i, b_i,
	input logic [2:0] opcode_i,
	
	// Salidas
	output logic [N-1:0] result_o,
	output logic [3:0] ALUFlags
);
	import alu_defs::*;
	
	logic [N-1:0] arith_result_w;
	logic arith_v;
	logic arith_c;
	
	arith_unit #(.N(N)) arithmetics (
		// Entradas
		.a_i(a_i),
		.b_i(b_i),
		.opcode_i(opcode_i),
		// Salidas
		.result_o(arith_result_w),
		.overflow_o(arith_v),
		.cout_o(arith_c)
	);
	
	always_comb
	begin
		case (opcode_i)
			AND_: result_o = a_i & b_i;
			OR_: result_o = a_i | b_i;
			default: result_o = arith_result_w;
		endcase
	end
	
	assign ALUFlags[0] = ~opcode_i[1] & arith_v;
	assign ALUFlags[1] = ~opcode_i[1] & arith_c;
	assign ALUFlags[2] = (result_o == '0);
	assign ALUFlags[3] = result_o[N-1];
	
endmodule