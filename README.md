# Custom 16-bit Processor in Verilog

## Overview
This project implements a custom 16-bit Instruction Set Architecture (ISA) processor using Verilog HDL back in 2022. The processor is based on the **Harvard Architecture**, featuring separate instruction and data memories. It includes a custom ALU, a Register File with 8 general-purpose registers, and a Status Register (SR) for handling conditional execution based on flags.

## Architecture Highlights
* **Data Width:** 16-bit data registers and memory datapath.
* **Program Counter (PC):** 8-bit wide, with execution starting at `0x00`.
* **Memory Structure:**
  * **Instruction Memory:** Read-Only Memory (ROM) containing up to 256 instructions.
  * **Data Memory:** Read/Write Random Access Memory (RAM) of 1024 words.
* **Register File:** 8 general-purpose 16-bit registers and Special Purpose Registers (SPR) including `Hi`, `Lo`, and `Status Register (SR)`.
* **Status Flags:** Zero (Z), Negative (N), Carry (C), Overflow (OF).

## Instruction Set Architecture (ISA)
The CPU supports three main instruction formats: **R (Register)**, **I (Immediate)**, and **J (Jump)**.

### Instruction Formats
| Type | Bits [15:12] | Bits [11:9] | Bits [8:6] | Bits [5:3] | Bits [2:0] |
|---|---|---|---|---|---|
| **R** | Opcode | Dest ($R_d$) | Src 1 ($R_s$) | Src 2 ($R_t$) | Shift Amt |
| **I** | Opcode | Dest ($R_d$) | Src ($R_s$) | Constant/Addr | (part of const)|
| **J** | Opcode | Address (8-bit)| Unused | Unused | Unused |

### Supported Instructions
| Instruction | Opcode | Type | Operation |
|---|---|---|---|
| `add` | `0000` | R | $R_d = R_s + R_t$ |
| `sll` | `0001` | R | $R_d = R_s \ll 	ext{shamt}$ |
| `slr` | `0010` | R | $R_d = R_s \gg 	ext{shamt}$ |
| `or` | `0011` | R | $R_d = R_s \| R_t$ |
| `and` | `0100` | R | $R_d = R_s \& R_t$ |
| `addi` | `0101` | I | $R_d = R_s + 	ext{constant}$ |
| `li` | `0110` | I | $R_d = 	ext{constant}$ |
| `lw` | `0111` | I | $R_d = 	ext{memory}[R_s + 	ext{constant}]$ |
| `sw` | `1000` | I | $	ext{memory}[R_s + 	ext{constant}] = R_d$ |
| `b` | `1001` | J | $PC = 	ext{address}$ (Supports conditional branching based on flags) |
| `mul` | `1010` | R | $[Hi, Lo] = R_s 	imes R_t$ |
| `mflo` | `1011` | R | $R_d = Lo$ |
| `mfhi` | `1100` | R | $R_d = Hi$ |

## Modules Description
* `CPU`: The top-level module connecting the control unit, datapath, memory, and registers.
* `ALU` & `ALUControl`: Implements arithmetic and logical operations, and sets status flags (Z, N, C, OF).
* `ControlUnit`: Decodes the 4-bit instruction opcode to generate necessary control signals (`regWrite`, `memRead`, `branch`, etc.).
* `RegisterFile`: Handles read/write operations for the 8 general-purpose registers and maintains the Status Register.
* `InstructionMemory` & `DataMemory`: Manages 16-bit storage blocks for instructions and data.
* `Decoder` & `SignExtend`: Utility modules to split instructions into respective fields and extend immediate values safely.
* `BranchMUX` & `MUX_*`: Routing components including conditional branch logic to update the PC value based on evaluated flags.

## Conditional Execution
The processor supports conditional branches by evaluating the lower bits of the opcode (`BraOp`) combined with the flags from the Status Register. If a specified condition (Zero, Negative, Carry, or Overflow) is met, the `BranchMUX` redirects the PC to the target address instead of proceeding to `PC + 1`.

## Getting Started
1. Import all the provided `.v` files into your preferred Verilog simulator (e.g., ModelSim, Vivado, Icarus Verilog).
2. The `InstructionMemory` module is pre-loaded with a small test program (adding, shifting, and branching).
3. Create a testbench to instantiate the `CPU` module, providing it with a clock (`clk`) and `reset` signal.
4. Run the simulation and monitor the output waveforms, specifically observing `PC`, `ALUResult`, and the contents of the `RegisterFile` to verify proper instruction execution.
