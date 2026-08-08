# Simple CPU

### Simple CPU is an 8-bit accumulator-based processor implemented in Verilog for the Lattice iCE40UP5K FPGA.

>This project is my implementation of the simpleCPU design from [mike@simplecpudesign.com](https://www.simplecpudesign.com).
>It uses a compact multi-cycle architecture, unified instruction and data memory, and a small instruction set supporting arithmetic, logical, memory, I/O, and branch operations.

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

>[!TIP]
>View the synthesized of the latest RTL at [Docs](docs/v1).

## Toolchain

>[!NOTE]
>The custom tcl workflow only works for windows with Lattice Radiant installed on path. An open-source version using [OSS Cad Suite](https://github.com/YosysHQ/oss-cad-suite-build) is planned.
>
>Codex (gpt-5.6-sol) is used in this project for analysis, debugging and documentation.

The project is configured for:

- **FPGA:** Lattice iCE40UP5K-SG48I
- **Synthesis:** Synplify Pro
- **Implementation:** Lattice Radiant
- **Simulation:** Questa/ModelSim

## Prerequisites

Building the project requires:

- Lattice Radiant with Synplify Pro
- `radiantc` available on `PATH`
- GNU Make
- Questa or ModelSim with `vsim` available on `PATH` for simulation

## Build

Create the Lattice Radiant project:

    make init

Open the synthesized design in Synplify Pro:

    make synp

Run synthesis, mapping, place-and-route, and export:

    make build

Run a simulation:

    make qrun top=cpu_tb time=-all

Remove generated project files:

    make clean

The `build` target automatically initializes the Radiant project before starting the FPGA implementation flow.
