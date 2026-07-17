// sets the control signals given the instruction opcode
module ControlUnit(op, regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite);

input [3:0] op;
output reg regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite;

always@(*) begin

	case(op)

		4'b0000: begin // add
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 1;
			end

		4'b0001: begin // sll
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 1;
				regWrite <= 1;
			end

		4'b0010: begin // srl
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 1;
				regWrite <= 1;
			end

		4'b0011: begin // or
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 1;
			end

		4'b0100: begin // and
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 1;
			end

		4'b0101: begin // addi
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 1;
				regWrite <= 1;
			end

		4'b0110: begin // li
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 1;
				regWrite <= 1;
			end
	
		4'b0111: begin // lw
				regDst <= 1;
				branch <= 0;
				memRead <= 1;
				memToReg <= 1;
				memWrite <= 0;
				aluSrc <= 1;
				regWrite <= 1;
			end

		4'b1000: begin // sw
				regDst <= 0;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 1;
				aluSrc <= 1;
				regWrite <= 0;
			end

		4'b1001: begin // branch
				regDst <= 1;
				branch <= 1;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 0;
			end

		4'b1010: begin // multiply
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 0;
			end

		4'b1011: begin // move lo
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 1;
			end

		4'b1100: begin // move hi
				regDst <= 1;
				branch <= 0;
				memRead <= 0;
				memToReg <= 0;
				memWrite <= 0;
				aluSrc <= 0;
				regWrite <= 1;
			end

	endcase

end

endmodule