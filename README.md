
# RISC-V 32-Bit Processor — RTL-to-GDSII ASIC Implementation

**RISC-V Architecture | Verilog HDL | RTL Design | Logic Synthesis | Physical Design | Static Timing Analysis**

An end-to-end ASIC implementation project centered on a 32-bit RISC-V-style single-cycle processor, covering RTL design and integration, logic synthesis, physical implementation, and timing analysis using Cadence EDA tools.

The project connects processor architecture with the ASIC implementation flow, exploring how a hardware design described in Verilog can be transformed into a technology-mapped netlist and physical chip layout.

The implementation workflow uses **Cadence Genus** for logic synthesis, **Cadence Innovus** for physical design, and **Cadence Tempus** for static timing analysis, together with the applicable technology libraries, design constraints, and process design kit (PDK).

> **Project scope:** This is a RISC-V-style single-cycle processor implementation, not a complete RISC-V ISA implementation. Supported instructions, completed implementation stages, and verified results are documented according to the actual design and tool runs.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Design Objectives](#design-objectives)
- [Processor Architecture](#processor-architecture)
- [Instruction Support](#instruction-support)
- [RTL Design Components](#rtl-design-components)
- [RTL-to-GDSII Implementation Flow](#rtl-to-gdsii-implementation-flow)
- [EDA Tools and Technologies](#eda-tools-and-technologies)
- [Repository Structure](#repository-structure)
- [Verification and Validation](#verification-and-validation)
- [Implementation Results](#implementation-results)
- [Challenges and Learning Outcomes](#challenges-and-learning-outcomes)
- [Future Improvements](#future-improvements)
- [Disclaimer](#disclaimer)

---

## Project Overview

A processor is not complete simply because its RTL has been written. Before a digital design can be considered for ASIC fabrication, its logic must be synthesized, mapped to technology-specific standard cells, physically implemented, and checked against timing and manufacturing constraints.

This project brings these two aspects together:

1. **Processor RTL design:** Developing and integrating the functional blocks of a 32-bit RISC-V-style single-cycle datapath using Verilog HDL.
2. **ASIC backend implementation:** Taking the design through the applicable RTL-to-GDSII flow using Cadence synthesis, physical design, and timing analysis tools.

The goal is to understand the relationship between processor architecture, synthesized logic, physical implementation, and timing behavior.

### Project Highlights

- Modular 32-bit processor datapath using Verilog HDL.
- Program counter, instruction memory, register file, immediate generator, control logic, and ALU.
- Demonstration program containing selected RISC-V instruction encodings.
- RTL synthesis and technology mapping using Cadence Genus.
- Physical implementation using Cadence Innovus.
- Static timing analysis using Cadence Tempus.
- Analysis of area, timing, and physical implementation reports where available.
- Documentation of the implementation flow and its verified completion status.

---

## Design Objectives

The project focuses on the following objectives:

- Understand the organization of a single-cycle RISC-V-style processor.
- Develop and integrate modular RTL components.
- Examine how synthesis converts RTL into a gate-level netlist.
- Understand the use of timing constraints during synthesis and physical design.
- Explore floorplanning, standard-cell placement, and clock-tree synthesis.
- Understand routing and the impact of interconnect parasitics on timing.
- Analyze setup and hold timing using static timing analysis.
- Understand the generation and validation of a final GDSII layout.

---

## Processor Architecture

The processor uses a single-cycle datapath organization. Instruction fetch, decode, execution, memory access, and write-back are connected within the same instruction cycle, with combinational logic between clocked state elements.

```text
                  +-------------------+
                  |   Program Counter |
                  +---------+---------+
                            |
                            v
                  +-------------------+
                  | Instruction Memory|
                  +---------+---------+
                            |
                            v
                  +-------------------+
                  |   Control Unit    |
                  | Register File     |
                  | Immediate Generator|
                  +---------+---------+
                            |
                            v
                  +-------------------+
                  |       ALU         |
                  | Arithmetic/Logic  |
                  +---------+---------+
                            |
                   +--------+--------+
                   |                 |
                   v                 v
          +----------------+  +----------------+
          |  Data Memory   |  |  ALU Result    |
          +--------+-------+  +--------+-------+
                   |                   |
                   +---------+---------+
                             |
                             v
                  +-------------------+
                  |   Write-Back Mux  |
                  +---------+---------+
                            |
                            v
                     Register File

          Branch/Jump Control --> Next-PC Selection
```

*This is a conceptual datapath diagram. The actual RTL connectivity and implemented control paths should be confirmed against the source code.*

### Single-Cycle Design

In a single-cycle processor, an instruction is intended to complete its execution within one clock cycle. The clock period must accommodate the longest relevant combinational path, making timing analysis especially important.

The physical implementation flow helps examine how synthesis choices, standard-cell delays, clock constraints, and interconnect parasitics affect the design's timing characteristics.

---

## Instruction Support

The current demonstration instruction memory contains selected RISC-V-style instruction encodings, including:

| Instruction | Operation |
|---|---|
| `ADDI` | Add an immediate value |
| `ADD` | Integer addition |
| `SUB` | Integer subtraction |
| `AND` | Bitwise AND |
| `OR` | Bitwise OR |
| `BEQ` | Branch if equal |
| `JAL` | Jump and link |

The presence of an instruction encoding in the demonstration program does not by itself establish that its complete architectural behavior is correct.

Instruction decoding, immediate generation, branch and jump behavior, register updates, and memory access must be verified through simulation before claiming functional compliance.

**ISA compliance:** This project is not represented as a complete or formally verified RISC-V implementation.

---

## RTL Design Components

The RTL is organized into modular functional blocks.

| Component | Responsibility |
|---|---|
| Program Counter | Stores the current instruction address |
| PC + 4 Adder | Calculates the sequential next instruction address |
| Instruction Memory | Supplies instructions from a demonstration program |
| Register File | Provides register operands and stores results |
| Immediate Generator | Extracts and extends instruction immediates |
| Main Control Unit | Generates control signals from instruction fields |
| ALU Control | Selects the required ALU operation |
| ALU | Performs arithmetic and logical operations |
| Data Memory | Implements the design's data-memory interface |
| Multiplexers | Select operands, results, and write-back data |
| Branch Logic | Supports branch decisions and next-PC selection |

The implemented functionality depends on the actual RTL source. Each component should be validated individually and then as part of the integrated processor.

---

## RTL-to-GDSII Implementation Flow

The ASIC backend flow transforms the processor's RTL into a physical layout using technology-specific libraries, constraints, and implementation settings.

```text
             RISC-V Processor RTL
                      |
                      v
             RTL Elaboration
                      |
                      v
              Logic Synthesis
               Cadence Genus
                      |
                      v
          Technology-Mapped Netlist
                      |
                      v
                Floorplanning
              Cadence Innovus
                      |
                      v
                  Placement
                      |
                      v
          Clock-Tree Synthesis (CTS)
                      |
                      v
                   Routing
                      |
                      v
          Parasitic Extraction (RC)
                      |
                      v
          Static Timing Analysis
               Cadence Tempus
                      |
                      v
          Physical Verification
             Where configured
                      |
                      v
              GDSII Stream-Out
```

*The precise sequence depends on the configured flow. Timing analysis may be performed at multiple stages, and extraction, physical verification, and GDSII export require their corresponding tools and setup.*

### 1. RTL Preparation and Elaboration

- Review the processor hierarchy and RTL source.
- Resolve module dependencies and design configuration.
- Prepare synthesis constraints and required technology inputs.
- Check for elaboration errors and unsupported constructs.

### 2. Logic Synthesis — Cadence Genus

Genus translates the RTL into a logic network and maps it to cells from the selected technology library.

Activities may include:

- RTL elaboration and synthesis.
- Boolean optimization.
- Technology mapping.
- Area and timing optimization.
- Generation of a mapped netlist.
- Review of synthesis warnings and reports.

### 3. Floorplanning — Cadence Innovus

Floorplanning establishes the physical framework for implementation.

Activities may include:

- Initializing the design with the netlist and technology data.
- Defining core and die dimensions.
- Establishing placement constraints.
- Planning power distribution, where included in the flow.
- Reviewing floorplan feasibility.

### 4. Standard-Cell Placement

Placement assigns standard cells to physical locations within the core.

The implementation can be evaluated for:

- Cell utilization and placement density.
- Congestion.
- Timing-driven optimization.
- Cell area and estimated wire length.
- Placement-related design-rule violations.

### 5. Clock-Tree Synthesis

Clock-tree synthesis builds the clock distribution network for sequential elements.

Relevant considerations include:

- Clock latency.
- Clock skew.
- Clock transition.
- Clock-tree cell area.
- Setup and hold timing effects.

The actual clocking strategy depends on the design constraints and implementation configuration.

### 6. Routing

Routing establishes physical interconnections between cells.

Relevant activities include:

- Signal routing.
- Routing optimization.
- Congestion analysis.
- Metal-layer usage review.
- Inspection of routing and design-rule reports.

### 7. Parasitic Extraction and Static Timing Analysis

Physical interconnect introduces resistance and capacitance that can affect timing.

Cadence Tempus can be used to analyze timing against the supplied timing constraints and extracted parasitic data.

Key metrics include:

- Setup slack.
- Hold slack.
- Worst negative slack (WNS).
- Total negative slack (TNS).
- Critical timing paths.
- Constraint and timing violations.

Results must be associated with their actual analysis stage and configuration, such as pre-route or post-route timing.

### 8. Physical Verification and GDSII Generation

The final physical-design stages depend on the configured flow and available sign-off tools.

Where performed, they may include:

- Design-rule checking (DRC).
- Layout-versus-schematic checking (LVS).
- Additional electrical or physical verification.
- GDSII stream-out.

Generating a GDSII file alone does not prove that the design has passed all sign-off checks or is ready for manufacturing.

---

## EDA Tools and Technologies

| Tool or technology | Role |
|---|---|
| Verilog HDL | Processor RTL description |
| Cadence Genus | Logic synthesis and technology mapping |
| Cadence Innovus | Physical implementation |
| Cadence Tempus | Static timing analysis |
| PDK | Technology-specific design and manufacturing data |
| Standard-cell libraries | Cell functions, timing, and physical characteristics |
| SDC constraints | Clock definitions and timing requirements |
| Linux / Tcl | Tool environment and flow scripting, where used |

The availability of particular tools, libraries, extraction engines, and verification capabilities depends on the installed environment and authorized technology setup.

---

## Repository Structure

```text
riscv32-single-cycle-processor/
├── rtl/
│   └── riscv32_processor.v
├── constraints/
│   └── README.md
├── scripts/
│   └── README.md
├── sim/
│   └── processor_tb.v
├── reports/
│   ├── synthesis/
│   │   └── README.md
│   ├── physical_design/
│   │   └── README.md
│   └── timing/
│       └── README.md
├── docs/
│   └── rtl_to_gdsii_flow.png
└── README.md
```

This is a suggested repository layout. Update the filenames to match your real project files. Add simulation testbenches, scripts, diagrams, and reports only after they exist.

Do not commit proprietary technology files, restricted libraries, confidential design data, or generated artifacts that your organization or institution does not permit you to share.

---

## Verification and Validation

Verification is required at both the RTL and implementation levels.

### RTL Functional Verification

Recommended tests include:

- Program-counter reset and increment.
- Register-file read and write operations.
- ALU arithmetic and logical operations.
- Immediate generation for supported instruction formats.
- Branch and jump target calculation.
- Data-memory read and write behavior.
- End-to-end execution of the demonstration program.

### Implementation Validation

Where the relevant stages have been executed, record:

- Successful synthesis and mapped-netlist generation.
- Placement and clock-tree synthesis status.
- Routing completion and remaining violations.
- Timing results from the applicable analysis stage.
- DRC and LVS results, if those checks were run.
- GDSII generation status.

A completed tool run should not be treated as proof of functional correctness. RTL simulation, implementation checks, and timing analysis establish different aspects of design quality.

---

## Implementation Results

Record measured results from the actual implementation rather than using illustrative or estimated numbers.

| Parameter | Result |
|---|---|
| Target clock period | To be documented |
| Synthesized cell area | To be documented |
| Post-placement cell area | To be documented |
| Post-route setup WNS | To be documented |
| Post-route hold slack | To be documented |
| Total negative slack | To be documented |
| DRC status | To be documented |
| LVS status | To be documented |
| GDSII generation | To be documented |

When adding results, identify the technology library, analysis stage, and relevant configuration where sharing them is permitted.

---

## Challenges and Learning Outcomes

This project provides an opportunity to connect RTL-level design decisions with ASIC implementation behavior.

Key learning areas include:

- Processor datapath organization and control.
- Modular RTL integration.
- Synthesis and technology mapping.
- Timing constraints and critical-path analysis.
- Floorplanning, placement, and clock-tree synthesis.
- Routing congestion and interconnect parasitics.
- Setup and hold timing analysis.
- The relationship between physical verification and GDSII generation.

It also provides a framework for documenting practical experience with commercial EDA tools and understanding the stages involved in an ASIC implementation flow.

---

## Future Improvements

- Develop a self-checking testbench with expected-result comparisons.
- Expand and validate the supported instruction set.
- Improve and verify branch, jump, and memory behavior.
- Add synthesis and physical-design reports where permitted.
- Document timing constraints and critical-path observations.
- Compare pre-route and post-route timing results.
- Add implementation scripts and reproducibility notes where shareable.
- Record verified DRC/LVS and final layout status.
- Explore a five-stage pipelined RISC-V implementation as a separate extension.

---

## Disclaimer

This repository is intended for educational and portfolio documentation. The design should not be considered a complete, compliant, or production-ready RISC-V processor unless the required architectural verification has been performed.

The status of the ASIC flow, including synthesis, placement, CTS, routing, timing closure, physical verification, and GDSII generation, must reflect the stages actually completed and verified.

Proprietary PDKs, licensed technology data, confidential design files, and restricted tool assets are not included.

---

**Project Keywords:** RISC-V | 32-Bit Processor | Single-Cycle Datapath | Verilog HDL | RTL-to-GDSII | Cadence Genus | Cadence Innovus | Cadence Tempus | ASIC Design | Physical Design | Static Timing Analysis
