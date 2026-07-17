// holds instructions
module InstructionMemory(addr, out);

input [7:0] addr; // address to instruction
output reg [15:0] out; // instruction

reg [15:0] instructions [0:255];
integer i;

initial begin
	for (i = 0; i < 256; i = i + 1) begin
		instructions[i] = 0;
	end

	// initializing the instructions
	instructions[0] = 16'b0101001000010010; // addi $1, $0, b010010
	instructions[1] = 16'b1000001000000000; // sw $1, 0($0)
	instructions[2] = 16'b0111001000000000; // lw $1, 0($0)
	instructions[3] = 16'b0000010001001000; // add $2, $1, $1
	instructions[4] = 16'b0001011010000010; // sll $3, $2, 2
	instructions[5] = 16'b0000100011010000; // add $4, $3, $2
	// instructions[6] = 16'b0000111111100000; // add $7, $7, $4
	instructions[6] = 16'b0000111111111000; // add $7, $7, $7
	instructions[7] = 16'b1001000000001000; // bz 0x00;
end

always@(addr) begin
	out <= instructions[addr];
end

endmodule

// holds data
module DataMemory(addr, dataIn, memWrite, memRead, reset, dataOut);

input [15:0] addr, dataIn;
input memWrite, memRead, reset;
output reg [15:0] dataOut;

reg [15:0] data [0:1023]; // limiting data block to 1024 words for now
integer i;

initial begin
	for (i = 0; i < 1024; i = i + 1) begin
		data[i] = 0;
	end
	dataOut = 0;
end

always@(*) begin
	if (memWrite) data[addr] <= dataIn;
	if (memRead) dataOut <= data[addr];
end

always@(posedge reset) begin
	for (i = 0; i < 1024; i = i + 1) begin
		data[i] = 0;
	end
	dataOut = 0;
end


endmodule