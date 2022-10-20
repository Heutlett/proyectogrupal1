module alu
#(parameter N = 4)
(
	// Entradas
	input logic [N-1:0] a_i, b_i,
	input logic [2:0] opcode_i,
	
	// Salidas
	output logic [N-1:0] result_o,
	output [1:0] ALUFlags
);
	import alu_defs::*;
	
	logic [N-1:0] arith_result_w;

	arith_unit #(.N(N)) arithmetics (
		// Entradas
		.a_i(a_i),
		.b_i(b_i),
		.opcode_i(opcode_i),
		// Salidas
		.result_o(arith_result_w)
	);
	
	always_comb
	begin
		case (opcode_i)
			AND_: begin
				result_o = a_i & b_i;
			end
			OR_: begin
				result_o = a_i | b_i;
			end	
			default: result_o = arith_result_w;
		endcase
	end
	
	assign ALUFlags[0] = (result_o == '0);
	assign ALUFlags[1] = result_o[N-1];
	
endmodule