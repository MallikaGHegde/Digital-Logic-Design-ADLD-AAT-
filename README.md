# Verilog Digital Design Library

A collection of 14 small, beginner-friendly digital designs written in **Verilog-2001**, each with a self-checking testbench and its own README. The designs follow the simple style of the ADLD AAT report (same module and port names). It covers the 12 requested categories; synchronous/asynchronous counters and Mealy/Moore FSMs are separate designs, which is why there are 14. The code targets **Icarus Verilog** and is suitable for learning RTL design and verification, college lab work, and a GitHub portfolio.

## Designs

| # | Design | Source | Testbench |
|---|---|---|---|
| 1 | [Arithmetic Logic Unit (ALU)](ALU/) | `alu.v` | `alu_tb.v` |
| 2 | [Comparator](Comparator/) | `comparator.v` | `comparator_tb.v` |
| 3 | [4-Bit Parity Generator and Checker](Parity_Generator_Checker/) | `parity.v` | `parity_tb.v` |
| 4 | [4-Bit Barrel Shifter](Barrel_Shifter/) | `barrel_shifter.v` | `barrel_shifter_tb.v` |
| 5 | [Timer Module](Timer/) | `timer.v` | `timer_tb.v` |
| 6 | [Ring Counter](Ring_Counter/) | `ring_counter.v` | `ring_counter_tb.v` |
| 7 | [Johnson Counter](Johnson_Counter/) | `johnson_counter.v` | `johnson_counter_tb.v` |
| 8 | [Synchronous Counter](Synchronous_Counter/) | `sync_counter.v` | `sync_counter_tb.v` |
| 9 | [Asynchronous (Ripple) Counter](Asynchronous_Counter/) | `async_counter.v` | `async_counter_tb.v` |
| 10 | [Universal Shift Register](Shift_Register/) | `shift_register.v` | `shift_register_tb.v` |
| 11 | [Divide-by-N Counter](Divide_by_N_Counter/) | `divide_by_n.v` | `divide_by_n_tb.v` |
| 12 | [Mealy FSM - 101 Sequence Detector](Mealy_FSM/) | `mealy_fsm.v` | `mealy_fsm_tb.v` |
| 13 | [Moore FSM - 101 Sequence Detector](Moore_FSM/) | `moore_fsm.v` | `moore_fsm_tb.v` |
| 14 | [LFSR Random Sequence Generator](LFSR_Random_Generator/) | `lfsr.v` | `lfsr_tb.v` |

## Folder structure

```
Verilog_Digital_Design_Library/
|-- README.md
|-- run_all.sh            (Linux / macOS / Git Bash / WSL)
|-- run_all.bat           (Windows Command Prompt)
|-- ALU/                   alu.v, alu_tb.v, README.md
|-- Comparator/            comparator.v, comparator_tb.v, README.md
|-- Parity_Generator_Checker/  parity.v, parity_tb.v, README.md
|-- Barrel_Shifter/        barrel_shifter.v, barrel_shifter_tb.v, README.md
|-- Timer/                 timer.v, timer_tb.v, README.md
|-- Ring_Counter/          ring_counter.v, ring_counter_tb.v, README.md
|-- Johnson_Counter/       johnson_counter.v, johnson_counter_tb.v, README.md
|-- Synchronous_Counter/   sync_counter.v, sync_counter_tb.v, README.md
|-- Asynchronous_Counter/  async_counter.v, async_counter_tb.v, README.md
|-- Shift_Register/        shift_register.v, shift_register_tb.v, README.md
|-- Divide_by_N_Counter/   divide_by_n.v, divide_by_n_tb.v, README.md
|-- Mealy_FSM/             mealy_fsm.v, mealy_fsm_tb.v, README.md
|-- Moore_FSM/             moore_fsm.v, moore_fsm_tb.v, README.md
`-- LFSR_Random_Generator/ lfsr.v, lfsr_tb.v, README.md
```

## Tools and installation

- **Icarus Verilog** (`iverilog` and `vvp`), version 10 or newer.
  - Ubuntu / Debian / WSL: `sudo apt install iverilog`
  - macOS (Homebrew): `brew install icarus-verilog`
  - Windows: install a Windows build of Icarus Verilog and tick "Add to PATH" in the installer (or add its `bin` folder to PATH manually).
- Optional: **GTKWave** for viewing waveforms. Every testbench writes a `.vcd` file (`$dumpfile` / `$dumpvars`); `run_all.sh` places them in `build/`.

## Running one simulation

```bash
cd ALU
iverilog -g2001 -o alu_sim alu.v alu_tb.v
vvp alu_sim
```

