module ALU(in1, in2, op, result, hi, lo, zero, negative, carry, overflow);

input [15:0] in1, in2; // inputs to ALU
input [3:0] op; // ALU opcode
output reg [15:0] result, hi, lo; // registers to store result
output reg zero, negative, carry, overflow; // flags

reg [15:0] in2comp; // 2's compliment of in2 incase of sub

initial begin
	zero <= 0;
	negative <= 0;
	carry <= 0;
	overflow <= 0;
	result <= 0;
	lo <= 0;
	hi <= 0;
end

always@(*) begin

	case(op)
		// add
		4'b0000: begin
				result = in1 + in2;
				overflow = (result[15] & ((~in1[15]) & (~in2[15])));
				carry = (in1[15] & in2[15]) | ((~result[15]) & (in1[15] ^ in2[15]));
				zero = (result == 0);
				negative = (result[15]);
			end

		// subtract
		4'b0001: begin
				in2comp = (~in2) + 1; // taking 2's compliment
				result = in1 + in2comp;
				overflow = (result[15] & ((~in1[15]) & (~in2[15])));
				carry = (in1[15] & in2comp[15]) | ((~result[15]) & (in1[15] ^ in2comp[15]));
				zero = (result == 0);
				negative = (result[15]);
			end
		// or
		4'b0010: begin
			result = in1 | in2;
			zero = (result == 0);
			negative = (result[15]);
			end

		// and
		4'b0011: begin
			result = in1 & in2;
			zero = (result == 0);
			negative = (result[15]);
			end

		// shift left
		4'b0100: begin
			result = in1 << in2[2:0];
			zero = (result == 0);
			negative = (result[15]);
			end

		// shift right
		4'b0101: begin
			result = in1 >> in2[2:0];
			zero = (result == 0);
			negative = (result[15]);
			end

		// multiply
		4'b0110: begin
			{hi, lo} = in1 * in2; // storing result in hi and lo regiters
			zero = ({hi, lo} == 0);
			negative = (hi[15]);
			end

		// mflo
		4'b0111: begin
			result = lo;
			zero = (result == 0);
			negative = (result[15]);
			end

		//mfhi
		4'b1000: begin
			result = hi;
			zero = (result == 0);
			negative = (result[15]);
			end	
	endcase
end
endmodule

// Provides ALU's opcode given the instruction opcode
module ALUControl(inOp, outOp);

input [3:0] inOp; // instruction opcode
output reg [3:0] outOp; // ALU opcode

always@(inOp) begin

	case(inOp)

		4'b0000: outOp <= 4'b0000; // add

		4'b0001: outOp <= 4'b0100; // shift left

		4'b0010: outOp <= 4'b0101; // shift right

		4'b0011: outOp <= 4'b0010; // or

		4'b0100: outOp <= 4'b0011; // and

		4'b0101: outOp <= 4'b0000; // addi -> add

		4'b0110: outOp <= 4'b0000; // li -> addi -> add

		4'b0111: outOp <= 4'b0000; // lw -> add

		4'b1000: outOp <= 4'b0000; // sw -> add

		4'b1001: outOp <= 4'b1111; // branch

		4'b1010: outOp <= 4'b0110; // multiply

		4'b1011: outOp <= 4'b0111; // move lo

		4'b1100: outOp <= 4'b1000; // move hi
		
	endcase

end

endmodule
