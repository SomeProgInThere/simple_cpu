# Simple CPU

Simple CPU is an 8-bit accumulator-based processor implemented in Verilog for the Lattice iCE40UP5K FPGA.

It uses a compact multi-cycle architecture, unified instruction and data memory, and a small instruction set supporting arithmetic, logical, memory, I/O, and branch operations.

>[!NOTE]
>The custom tcl workflow only works for windows with Lattice Radiant installed on path. An open-source version using [OSS Cad Suite](https://github.com/YosysHQ/oss-cad-suite-build) is planned.
>
>Codex (gpt-5.6-sol) is used in this project for analysis, debugging and documentation.

## Architecture

The processor contains:

- An 8-bit accumulator
- An 8-bit program counter
- A 16-bit instruction register
- An 8-bit parameterized ALU
- Registered carry and zero flags
- A four-phase control unit
- A 256 × 16-bit unified memory
- A buffered serial output

## Execution cycle

Instructions pass through four clock phases:

```text
Fetch → Decode → Execute → Increment
  ↑                            │
  └────────────────────────────┘
```

### Fetch

Memory is addressed by the program counter and the resulting 16-bit instruction is loaded into the instruction register.

### Decode

The upper byte of the instruction is decoded and the control unit prepares the required datapath signals.

### Execute

The selected arithmetic, logical, memory, I/O, or branch operation is performed.

### Increment

The program counter advances unless a branch operation has selected a new address.

## Instruction format

Instructions are 16 bits wide:

```text
15              8 7               0
+----------------+-----------------+
|     Opcode     | Address/Operand |
+----------------+-----------------+
```

The upper byte selects the operation. The lower byte supplies an address or operand.

Opcode decoding uses bit patterns, allowing unused opcode bits to remain available for future instruction variants.

## Instruction set

| Opcode pattern | Mnemonic | Description |
|---|---|---|
| `0000_????` | `LOAD` | Load a value into the accumulator |
| `0001_????` | `AND` | Bitwise AND with the accumulator |
| `0100_????` | `ADD` | Add a value to the accumulator |
| `0110_????` | `SUB` | Subtract a value from the accumulator |
| `1010_????` | `IN` | Read an input value |
| `1110_????` | `OUT` | Write an output value |
| `1000_????` | `JMP` | Jump unconditionally |
| `1001_00??` | `JMPZ` | Jump when zero is set |
| `1001_01??` | `JMPNZ` | Jump when zero is clear |
| `1001_10??` | `JMPC` | Jump when carry is set |
| `1001_11??` | `JMPNC` | Jump when carry is clear |

Unrecognized opcode patterns perform no decoded operation.

## Datapath

The CPU follows an accumulator architecture. Arithmetic and logical instructions operate on the accumulator and store their results back into it.

The ALU supports:

- Addition
- Subtraction
- Bitwise AND
- Increment
- Operand pass-through

Addition and subtraction use a parameterized ripple-carry adder. Subtraction is performed using two’s-complement arithmetic.

Registers are also parameterized, allowing the same register module to implement the accumulator, program counter, instruction register, and status register.

## Status flags

The control unit stores two status flags after arithmetic or logical operations:

- **Zero:** the ALU result is zero
- **Carry:** the arithmetic result produces a carry

Conditional jumps use these registered flags when deciding whether to update the program counter.

## Memory architecture

Instructions and data share a synchronous single-port memory.

| Property | Value |
|---|---:|
| Address width | 8 bits |
| Word width | 16 bits |
| Capacity | 256 words |

Memory is initialized from `src/v1/main.hex`, allowing a program to be loaded automatically for simulation and FPGA implementation.

## Output interface

The processor exposes a buffered serial output named `sout`. Output data is captured during a memory write to the designated output address.

## Verification

The project includes simulations for:

- Complete CPU operation
- ALU operations
- Instruction decoding
- Execution sequencing
- Parameterized registers
- Program memory

The CPU testbench clocks and resets the integrated processor while executing the program loaded from memory.

## Toolchain

The project is configured for:

- **FPGA:** Lattice iCE40UP5K-SG48I
- **Synthesis:** Synplify Pro
- **Implementation:** Lattice Radiant
- **Simulation:** Questa/ModelSim