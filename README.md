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

Every design README lists its exact commands.

## Running all simulations

Linux / macOS / WSL / Git Bash:

```bash
chmod +x run_all.sh
./run_all.sh
```

Windows Command Prompt:

```bat
run_all.bat
```

Both scripts compile each design with its testbench, save logs in `build/`, print `[PASS]` or `[FAIL]` per design, and return a **nonzero exit status** if any compile or test fails. A design counts as passing only if its log has no `FAIL` line and contains `RESULT: PASSED`.

## Expected verification results

Each testbench prints `PASS:`/`FAIL:` for every check, then a summary:

```
Tests run: <N>, Failures: 0
RESULT: PASSED
```

`run_all.sh` should finish with:

```
Designs run: 14, failed: 0
ALL TESTBENCHES PASSED
```

> **Verification status:** this library was written in an environment without a Verilog simulator, so the simulations have **not** been executed by the author. The testbench expectations were derived by hand. Please run `run_all.sh` and treat any failure or compile warning as a bug to fix.

## Key Verilog concepts demonstrated

- Combinational logic with `assign` and `always @(*)`; `case` with defaults (no latches)
- Sequential logic with nonblocking assignments; synchronous and asynchronous resets
- Parameters, localparams, and parameterized widths and counts
- Module instantiation and parameter overriding (`#(.WIDTH(...))`, several instances of one module)
- Finite state machines: two-process style, Mealy vs. Moore output timing
- LFSRs and feedback polynomials
- Self-checking testbenches: tasks, functions, reference models, exhaustive loops, `$display`, timeouts, `$finish`
- Clock generation, avoiding race conditions by driving inputs 1 ns after the clock edge
- Event-driven clocking: a ripple counter where each stage is clocked by the previous stage (`negedge q[i]`)

## Conventions

- Verilog-2001 only, no SystemVerilog. Compile with `-g2001`.
- Reset is `rst_n`, asynchronous and active-low, in every sequential design.
- Every design has a unique module name; the testbenches use `timescale 1ns/1ps`.

## Known limitations and future improvements

- The testbenches are directed and self-checking, not randomized or constrained-random.
- The asynchronous counter is simulated with zero delay, so the ripple glitches of real hardware are not visible; ripple counters are not recommended for FPGA clocking.
- divide_by_n supports even N only (odd N would need a different method for 50% duty cycle).
- The ring and Johnson counters have no enable input (use `load` on the ring counter to restart it).
- The ALU is a 3-bit combinational block with no registers; parity detects only odd numbers of bit errors.
- Possible additions: a GitHub Actions workflow running `run_all.sh`, SystemVerilog assertion-based versions, FPGA constraint files, Verilator linting, and wider parameter sweeps.
