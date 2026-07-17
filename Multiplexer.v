// 2-to-1 MUX for 16 bit channel
module MUX_16_2to1(sel, a, b, out);

input [15:0] a, b;
output reg [15:0] out;
input sel;

always@(*) begin
	if(sel == 1) out = b;
	else out = a;
end

endmodule

// 2-to-1 MUX for 8 bit channel
module MUX_8_2to1(sel, a, b, out);

input [7:0] a, b;
output reg [7:0] out;
input sel;

always@(*) begin
	if(sel == 1) out = b;
	else out = a;
end

endmodule

// 2-to-1 MUX for 3 bit channel
module MUX_3_2to1(sel, a, b, out);

input [2:0] a, b;
output reg [2:0] out;
input sel;

always@(*) begin
	if(sel == 1) out = b;
	else out = a;
end

endmodule

// MUX for new value of PC
module BranchMUX(PC, address, BraOp, branch, zero, negative, carry, overflow, newPC);

input [3:0] BraOp;
input [7:0] PC, address;
input branch, zero, negative, carry, overflow;
output reg [7:0] newPC;

always@(*) begin

	if (branch) begin
		if ((zero) & (BraOp[3])) newPC <= address; // if branch and zero and BraOp == 1000
		if ((negative) & (BraOp[2])) newPC <= address; // if branch and negative and BraOp == 0100
		if ((carry) & (BraOp[1])) newPC <= address; // if branch and carry and BraOp == 0010
		if ((overflow) & (BraOp[0])) newPC <= address; // if branch and overflow and BraOp == 0001
		if (BraOp == 0) newPC <= address; // if branch and BraOp == 0000
	end
	else newPC <= PC + 1;

end


endmodule