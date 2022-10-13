module arith_unit
#(parameter N = 4)
(
	// Entradas
	input logic [N-1:0] a_i, b_i,
	input logic [2:0] opcode_i,
	
	// Salidas
	output logic [N-1:0] result_o
);
	import alu_defs::ARITH_ADD;
	import alu_defs::ARITH_SUB;
	import alu_defs::ARITH_MOD;
	import alu_defs::MOV_;
	
	logic [N:0] result_r;
	
	always_comb
	begin
		case (opcode_i)
			ARITH_ADD:
			begin
				result_r = (a_i + b_i);
			end
			ARITH_SUB:
			begin
				result_r = (a_i - b_i);
			end
			ARITH_MOD:
			begin
				result_r = (a_i % b_i);
			end
			MOV_:
			begin
				result_r = b_i; 
			end
			default:
			begin
				result_r = '0;
			end
		endcase
	end
	
	assign result_o = result_r[N-1:0];
endmodule