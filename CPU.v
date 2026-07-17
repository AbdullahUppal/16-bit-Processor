module CPU(clk, reset, instr, PC);

input reset, clk;

output reg [7:0] PC; // program counter
output [15:0] instr; // instruction wire
wire zero, negative, overflow, carry; // flag wires from ALU to register file
wire [3:0] flags; // flags from register file to branch MUX

wire [2:0] writeReg, readReg1, readReg2; // register address inputs to register file
wire regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite; // control signal wires from control unit
wire [5:0] const; // constant wire from decoder to sign extender
wire [15:0] constSE;
wire [15:0] dataInRegFile; // data in for register file
wire [15:0] readData1, readData2; // data outs from register file
wire [15:0] ALUIn1, ALUIn2; // ALU inputs
wire [15:0] ALUResult; // ALU output
wire [3:0] op, ALUOp, BraOp; // opcode wires
wire [2:0] Rd, Rs, Rt; // register addresses
wire [2:0] shamt; // shift amount
wire [7:0] address; // address wire from decoder
wire [7:0] newPC; // next value of PC from Branch MUX
wire [15:0] ALUlo, ALUhi; // lo and hi register outputs from ALU
wire [15:0] dataOutMem; // data out wire from data memory

initial PC <= 8'h00;

BranchMUX PCSelector(PC, address, BraOp, branch, flags[3], flags[2], flags[1], flags[0], newPC); // next PC calculation
InstructionMemory IM(PC, instr);
Decoder dec(instr, op, Rd, Rs, Rt, shamt, const, address, BraOp); // divide the instruction into parts
ControlUnit CU(op, regDst, branch, memRead, memToReg, memWrite, aluSrc, regWrite); // update control signals

assign readReg1 = Rs;
MUX_3_2to1 readReg2Selector(regDst, Rd, Rt, readReg2); // select the second register address
assign writeReg = Rd;
RegisterFile regFile(clk, reset, regWrite, zero, negative, carry, overflow, writeReg, readReg1, readReg2, dataInRegFile, readData1, readData2, flags);

ALUControl aluCon(op, ALUOp); // get ALU opcode from instruction opcode
assign ALUIn1 = readData1;
SignExtend6To16 constSignExtender(const, constSE); // extend sign of constant
MUX_16_2to1 ALUSrcSelector(aluSrc, readData2, constSE, ALUIn2); // select the second input to ALU
ALU alu(ALUIn1, ALUIn2, ALUOp, ALUResult, ALUhi, ALUlo, zero, negative, carry, overflow);

DataMemory DM(ALUResult, readData2, memWrite, memRead, reset, dataOutMem); // data memory
MUX_16_2to1 writeRegSelector(memToReg, ALUResult, dataOutMem, dataInRegFile); // select data in to register file

// update value of PC every clock cycle
always@(posedge clk) begin
	PC <= newPC;
end

// PC = 0 on reset
always@(posedge reset) begin
	PC <= 8'h00;
end


endmodule
