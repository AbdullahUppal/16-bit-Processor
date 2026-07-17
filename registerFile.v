// holds all the registers
module RegisterFile(clk, reset, regWrite, Z, N, C, OF, D_addr, S_addr, T_addr, dataIn, S_out, T_out, flagsOut);

input clk, reset, regWrite, Z, N, C, OF;
input [2:0] D_addr, S_addr, T_addr;
input [15:0] dataIn;
output reg [15:0] S_out, T_out;
output [3:0] flagsOut;

reg [15:0] registers [7:0];
reg [15:0] statusReg;
integer i;

assign flagsOut = statusReg;

initial begin
	S_out <= 0;
	T_out <= 0;
	for(i=0; i<8; i=i+1) begin
		registers[i] <= 0;
	end
	statusReg <= 0;
end

always@(posedge clk) begin
	if(regWrite == 1) registers[D_addr] <= dataIn; // write data
end

always@(*) begin
	S_out <= registers[S_addr]; // read data 1
	T_out <= registers[T_addr]; // read data 2

	statusReg[0] <= OF; // overflow
	statusReg[1] <= C; // carry
	statusReg[2] <= N; // negative
	statusReg[3] <= Z; // zero
end

always@(posedge reset)
begin
	for(i=0; i<8; i=i+1) 
	begin
		registers[i] <= 0;
	end
	S_out <= 0;
	T_out <= 0;
	statusReg <= 0;
end

endmodule