## Architecture implementation

The processor is implemented as an 8-bit accumulator-based CPU with a 16-bit instruction word. It combines a small datapath, a four-phase control unit, unified program and data memory, and a buffered output interface.

### Datapath

The main datapath contains three registers:

| Register | Width | Purpose |
|---|---:|---|
| Accumulator | 8 bits | Stores arithmetic, logical, load, and input results |
| Program counter | 8 bits | Holds the address of the current instruction |
| Instruction register | 16 bits | Holds the opcode and address operand |

All registers use the same parameterized register module. Each bit is implemented using an enabled D-type flip-flop with asynchronous reset.

The instruction register divides each instruction into two fields:

```text
15              8 7               0
+----------------+-----------------+
|     Opcode     | Address/Operand |
+----------------+-----------------+
```

The upper byte is connected to the instruction decoder. The lower byte is used as a memory address, branch target, or datapath operand.

### Arithmetic logic unit

The ALU is parameterized by operand width and instantiated as an 8-bit unit. It supports:

- Addition
- Subtraction
- Increment
- Bitwise AND
- First-operand pass-through
- Second-operand pass-through

Addition uses a ripple-carry adder constructed from one-bit full adders. Subtraction uses two’s-complement arithmetic by conditionally inverting the second operand and applying a carry-in.

A five-bit control word selects operand inversion, carry-in, and the final ALU result.

### Status flags

The processor maintains two registered status flags:

- **Carry:** records the carry output from the ALU
- **Zero:** indicates that the ALU result is zero

The flags are updated after arithmetic and logical operations. Conditional jump instructions use the registered values so that branch decisions are based on the previous ALU result.

### Control unit

The control unit combines:

- A four-phase sequence generator
- An instruction decoder
- Status flag storage
- Branch-condition logic
- Datapath control-signal generation

The sequence generator produces a repeating one-hot execution cycle:

```text
Fetch → Decode → Execute → Increment → Fetch
```

During **Fetch**, memory data is loaded into the instruction register.

During **Decode**, the opcode is translated into an internal instruction signal.

During **Execute**, the accumulator, program counter, status register, or memory is updated.

During **Increment**, the program counter advances when execution has not selected a branch target.

### Instruction decoder

The decoder uses masked opcode patterns. Unused opcode bits are ignored, leaving room for future instruction variants.

| Opcode pattern | Instruction |
|---|---|
| `0000_????` | Load |
| `0001_????` | Bitwise AND |
| `0100_????` | Add |
| `0110_????` | Subtract |
| `1010_????` | Input |
| `1110_????` | Output |
| `1000_????` | Unconditional jump |
| `1001_00??` | Jump if zero |
| `1001_01??` | Jump if not zero |
| `1001_10??` | Jump if carry |
| `1001_11??` | Jump if not carry |

Unknown opcode patterns do not activate an instruction signal.

### Branch control

The branch unit evaluates unconditional and conditional jump instructions during execution.

A taken jump loads the instruction operand into the program counter. When a jump is not taken, the program counter advances during the increment phase.

Supported branch conditions are:

- Zero set
- Zero clear
- Carry set
- Carry clear

### Memory

The CPU uses a synchronous single-port memory shared by instructions and data.

| Property | Value |
|---|---:|
| Address width | 8 bits |
| Data width | 16 bits |
| Capacity | 256 words |

Memory is initialized using `$readmemh` and the program stored in `src/v1/main.hex`. Unused memory locations are initialized to zero before the program is loaded.

The memory operates on the inverted CPU clock. This separates memory access from the positive clock edge used by the processor registers.

Memory writes store the accumulator in the lower byte of a 16-bit word:

```text
15              8 7               0
+----------------+-----------------+
|     0x00       |   Accumulator   |
+----------------+-----------------+
```

### Output interface

The CPU exposes an active-low serial output named `sout`.

An internal flip-flop buffers the low bit of output data during a write to the designated output address. Buffering keeps the external output stable between write operations.

### Reset handling

The external reset input is converted into the internal reset signal through a flip-flop. This internal signal resets the sequence generator, datapath registers, status flags, and output buffer to a known state.

After reset, the sequence generator enters the fetch phase and instruction execution begins from the reset program-counter address.