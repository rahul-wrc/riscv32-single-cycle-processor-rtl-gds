
# RISC-V 32-Bit Single-Cycle Processor

**Verilog HDL | RTL Design | Computer Architecture | Digital Logic**

A modular 32-bit RISC-V processor RTL implementation using Verilog HDL. The design integrates a program counter, instruction memory, register file, immediate generator, control unit, ALU, data memory, and supporting multiplexers.

## Architecture

The processor follows a single-cycle datapath organization in which instruction fetch, decode, execution, memory access, and write-back are connected combinationally between clocked state elements.

```text
                 +------------------+
                 | Program Counter  |
                 +--------+---------+
                          |
                          v
                 +------------------+
                 | Instruction      |
                 | Memory           |
                 +--------+---------+
                          |
                          v
                 +------------------+
                 | Control Unit     |
                 | Register File    |
                 | Immediate Gen.   |
                 +--------+---------+
                          |
                          v
                 +------------------+
                 | ALU and Muxes    |
                 +--------+---------+
                          |
                +---------+----------+
                |                    |
                v                    v
        +---------------+    +---------------+
        | Data Memory   |    | ALU Result    |
        +-------+-------+    +-------+-------+
                |                    |
                +----------+---------+
                           v
                 +------------------+
                 | Write-Back Mux   |
                 +--------+---------+
                          |
                          v
                    Register File
```

## Implemented Components

- Program counter with reset
- PC + 4 calculation
- Instruction memory with a hard-coded demonstration program
- 32-entry, 32-bit register file
- Immediate generation for selected instruction formats
- Main control unit and ALU control logic
- Arithmetic and logical ALU operations
- Data memory with read and write controls
- Branch decision logic and next-PC selection
- Write-back selection multiplexers

## Instruction Support

The demonstration instruction memory includes encodings for selected instructions:

- ADDI
- ADD
- SUB
- AND
- OR
- BEQ
- JAL

Instruction execution and control behavior should be validated before claiming complete ISA compliance. Although these are RISC-V-style instructions, this implementation is not a complete RISC-V processor.

## Repository Structure

```text
riscv32-single-cycle-processor/
├── rtl/
│   └── riscv32_processor.v
├── sim/
│   └── processor_tb.v
└── README.md
```

The testbench shown above is a planned file and should be added when available.

## Tools and Technologies

- Verilog HDL
- RTL design and modular integration
- Digital logic design
- Computer architecture
- HDL simulation and waveform analysis

## Verification Plan

Recommended tests include:

- Program-counter reset and increment behavior
- Register-file read and write operations
- ALU arithmetic and logical operations
- Immediate generation for supported instruction formats
- Branch and next-PC selection
- Data-memory read and write behavior
- End-to-end execution of the demonstration program

Simulation results should be documented after the tests have been run.

## Current Status

The RTL source contains the main components of a single-cycle RISC-V-style datapath and a hard-coded demonstration instruction sequence. Simulation, instruction correctness, and full processor behavior require verification.

## Future Improvements

- Add a self-checking Verilog testbench
- Expand and validate instruction support
- Improve branch and jump handling
- Add memory access and alignment checks
- Document simulation waveforms and verified results
- Explore a five-stage pipelined implementation as a separate project

---

**Project Focus:** RISC-V RTL | Processor Datapath | Verilog HDL | Computer Architecture
