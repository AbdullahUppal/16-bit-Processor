// seperates a given instruction into parts
module Decoder(instr, op, Rd, Rs, Rt, shamt, const, address, BraOp);

input [15:0] instr; // instruction
output [3:0] op, // opcode
	     BraOp; // branch opcode
output [2:0] Rd, // destination register
	     Rs, // source 1 register
	     Rt, // source 2 register
	     shamt; // shift amount
output [5:0] const; // constant
output [7:0] address; // address from branch instruction

assign op = instr[15:12]; // 0-3
assign Rd = instr[11:9]; // 4-6
assign Rs = instr[8:6]; // 7-9
assign Rt = instr[5:3]; // 10-12
assign shamt = instr[2:0]; // 13-15
assign const = instr[5:0]; // 10-15
assign address = instr[11:4]; // 4-11
assign BraOp = instr[3:0]; // 12-15

endmodule

// extends a 6 bit word to 16 bits
module SignExtend6To16(in, out);

input [5:0] in;
output [15:0] out;

reg [8:0] hi;

initial hi <= 9'h000;

always@(*) begin

	if(in[5]) begin
		hi = 9'h1ff;
	end
	else begin
		hi = 9'h000;
	end

end

assign out = {hi, in};

endmodule

// extends a 9 bit word to 16 bits
module SignExtend9To16(in, out);

input [8:0] in;
output [15:0] out;

reg [6:0] hi;

initial hi <= 7'h00;

always@(*) begin

	if(in[8]) begin
		hi = 7'h7f;
	end
	else begin
		hi = 7'h00;
	end

end

assign out = {hi, in};

endmodule