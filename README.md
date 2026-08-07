# Simple CPU

Simple CPU is an 8-bit accumulator-based processor implemented in Verilog for the Lattice iCE40UP5K FPGA.

The project explores the architecture of a small processor using a compact datapath, a shared instruction/data memory, and a multi-cycle control unit.

## Architecture

The processor consists of:

- An 8-bit accumulator
- An 8-bit program counter
- A 16-bit instruction register
- An 8-bit arithmetic logic unit
- Carry and zero status flags
- A four-phase control unit
- A 256-word, 16-bit memory
- A simple output interface

## Execution cycle

Instructions are processed over four clock phases:

```text
    Fetch --> Decode --> Execute --> Fetch
```

### Fetch

The instruction at the program counter is read from memory and stored in the instruction register.

### Decode

The control unit interprets the opcode and prepares the datapath for the requested operation.

### Execute

The selected arithmetic, memory, input/output, or branch operation is performed.

### Increment

The program counter advances to the next instruction unless execution selected a branch target.

## Datapath

The CPU uses an accumulator architecture. Most arithmetic and logical operations use the accumulator as one operand and store their result back into it.

The ALU supports:

- Addition
- Subtraction
- Bitwise AND
- Increment
- Operand pass-through

A ripple-carry adder performs addition and two's-complement subtraction.

The processor maintains two status conditions:

- **Zero:** the accumulator contains zero
- **Carry:** an arithmetic operation produced a carry

These conditions support conditional branch instructions.

## Instruction format

Instructions are 16 bits wide:

```text
15              8 7               0
+----------------+-----------------+
|     Opcode     | Address/Operand |
+----------------+-----------------+
```

The upper byte identifies the operation. The lower byte contains a memory address, branch target, or immediate operand, depending on the instruction.

## Instruction set

| Opcode | Mnemonic | Description |
|---:|---|---|
| `0x0` | `LOAD` | Load a value into the accumulator |
| `0x1` | `IN` | Read an input value |
| `0x2` | `OUT` | Write the accumulator to an output location |
| `0x3` | `ADD` | Add a value to the accumulator |
| `0x4` | `SUB` | Subtract a value from the accumulator |
| `0x5` | `AND` | Perform a bitwise AND |
| `0x6` | `JMP` | Jump unconditionally |
| `0x7` | `JMPZ` | Jump when the zero condition is set |
| `0x8` | `JMPNZ` | Jump when the zero condition is clear |
| `0x9` | `JMPC` | Jump when the carry condition is set |
| `0xA` | `JMPNC` | Jump when the carry condition is clear |

## Memory architecture

The CPU uses a shared memory for instructions and data:

| Property | Value |
|---|---:|
| Address width | 8 bits |
| Word width | 16 bits |
| Capacity | 256 words |

The shared-memory design keeps the processor small and gives instructions and data a common address space.

## Control unit

The control unit coordinates the instruction cycle and generates signals for:

- Register updates
- ALU operation selection
- Memory access
- Program-counter updates
- Conditional branches

A one-hot sequence generator tracks the current execution phase, while the instruction decoder translates opcodes into datapath operations.

## Verification

Component-level testbenches cover the primary processor building blocks:

- ALU
- Instruction decoder
- Sequence generator
- Registers
- Memory

Simulation is supported through Questa or ModelSim, while synthesis and FPGA implementation use the Lattice Radiant toolchain.

## Target platform

The project is configured for:

- **FPGA:** Lattice iCE40UP5K-SG48I
- **Synthesis:** Synplify Pro
- **Implementation:** Lattice Radiant
- **Simulation:** Questa/ModelSim
