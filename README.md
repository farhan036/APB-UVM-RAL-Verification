# APB Peripheral Verification Using UVM RAL

[![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)](https://www.accellera.org/downloads/standards/uvm)
[![Methodology](https://img.shields.io/badge/Methodology-UVM-orange)](https://www.accellera.org/downloads/standards/uvm)
[![RAL](https://img.shields.io/badge/Register%20Model-UVM%20RAL-green)](https://www.accellera.org/downloads/standards/uvm)
[![Protocol](https://img.shields.io/badge/Protocol-AMBA%20APB-purple)](https://developer.arm.com/architectures/system-architectures/amba/amba-specifications)

A coverage-driven SystemVerilog/UVM verification environment for an AMBA APB-based peripheral register bank. The project demonstrates UVM Register Abstraction Layer (RAL) modeling, frontdoor and backdoor register access, an APB bus adapter, register prediction, scoreboard checking, and functional coverage.

---

## Project Overview

The Design Under Test (DUT) is an APB-compliant peripheral containing five memory-mapped registers:

- `CNTRL` at address `0x00`
- `REG1` at address `0x04`
- `REG2` at address `0x08`
- `REG3` at address `0x0C`
- `REG4` at address `0x10`

The verification environment uses UVM RAL to separate register-level stimulus from bus-level implementation. RAL operations are converted into APB transactions through an adapter and executed by the APB UVM agent.

### Main Verification Features

- UVM Register Abstraction Layer (RAL)
- Frontdoor register read/write access
- Backdoor register read/write access
- APB `uvm_reg_adapter`
- UVM register predictor
- APB driver, monitor, sequencer, and agent
- Reference-model-based scoreboard
- Register-level functional coverage
- Questa/ModelSim compilation and simulation scripts

---

## DUT Register Map

| Address | Register | Width | Reset Value | Access | Description |
|:------:|----------|:-----:|-------------|--------|-------------|
| `0x00` | `CNTRL` | 32-bit | `0x00000000` | RW | Four active control bits; bits `[31:4]` reserved |
| `0x04` | `REG1` | 32-bit | `0x00000000` | RW | General-purpose data register 1 |
| `0x08` | `REG2` | 32-bit | `0x00000000` | RW | General-purpose data register 2 |
| `0x0C` | `REG3` | 32-bit | `0x00000000` | RW | General-purpose data register 3 |
| `0x10` | `REG4` | 32-bit | `0x00000000` | RW | General-purpose data register 4 |

### CNTRL Register Fields

| Bits | Field | Access | Reset | Description |
|------|-------|--------|-------|-------------|
| `[0]` | `CTRL0` | RW | `0` | Control bit 0 |
| `[1]` | `CTRL1` | RW | `0` | Control bit 1 |
| `[2]` | `CTRL2` | RW | `0` | Control bit 2 |
| `[3]` | `CTRL3` | RW | `0` | Control bit 3 |
| `[31:4]` | `F_Reserved` | RO | `0` | Reserved; reads as zero |

---

## Verification Architecture

```text
                         +----------------------+
                         |      my_test         |
                         +----------+-----------+
                                    |
                         +----------v-----------+
                         |       my_env          |
                         +------+-------+--------+
                                |       |
                    +-----------+       +----------------+
                    |                                    |
          +---------v---------+                +---------v---------+
          |      my_agent     |                |   my_scoreboard   |
          +----+---------+----+                +-------------------+
               |         |
       +-------+--+   +--+--------+
       | Sequencer |   |  Driver  |
       +-----------+   +-----+----+
                             |
                       +-----v------+
                       | APB_If     |
                       +-----+------+
                             |
                       +-----v------+
                       | APB DUT    |
                       +------------+

          Register Abstraction Layer
          --------------------------
          reg_block
             |
       +-----+-----+-----+-----+-----+
       | CNTRL REG1 REG2 REG3 REG4   |
       +-----------------------------+
             |
        apb_adapter
             |
       APB sequence items
```

### RAL Data Flow

1. A register sequence changes a register's desired value.
2. `update()` converts the desired value into a register bus operation.
3. `apb_adapter::reg2bus()` converts the RAL operation into `my_sequence_item`.
4. The sequencer and driver transfer the transaction over APB.
5. The monitor observes the bus transaction.
6. The predictor updates the RAL mirror.
7. The scoreboard compares read data with the expected register contents.
8. Register covergroups collect functional coverage.

---

## Repository Structure

```text
APB-UVM-RAL-Verification/
│
├── coverage/
│   └── Coverage reports and exported coverage results
│
├── docs/
│   └── Project3_Report.pdf
│
├── rtl/
│   └── APB.sv
│
├── scripts/
│   ├── files.txt
│   └── run.do
│
├── tb/
│   ├── agent/
│   │   ├── my_agent.sv
│   │   ├── my_config.sv
│   │   ├── my_driver.sv
│   │   ├── my_monitor.sv
│   │   └── my_sequencer.sv
│   │
│   ├── env/
│   │   ├── my_env.sv
│   │   └── my_test.sv
│   │
│   ├── interface/
│   │   └── APB_If.sv
│   │
│   ├── ral/
│   │   ├── regs.sv
│   │   ├── reg_block.sv
│   │   └── adapter.sv
│   │
│   ├── scoreboard/
│   │   └── my_scoreboard.sv
│   │
│   ├── sequence_item/
│   │   └── my_sequence_item.sv
│   │
│   ├── sequences/
│   │   ├── cntrl_seq.sv
│   │   ├── reg1_seq.sv
│   │   ├── reg2_seq.sv
│   │   ├── reg3_seq.sv
│   │   └── reg4_seq.sv
│   │
│   └── top.sv
│
└── README.md
```

---

## Source File Description

| File | Purpose |
|------|---------|
| `rtl/APB.sv` | APB peripheral RTL and five-register implementation |
| `tb/interface/APB_If.sv` | APB virtual interface |
| `tb/sequence_item/my_sequence_item.sv` | APB transaction object |
| `tb/agent/my_sequencer.sv` | Sends APB sequence items |
| `tb/agent/my_driver.sv` | Drives APB setup and access phases |
| `tb/agent/my_monitor.sv` | Samples APB transactions |
| `tb/agent/my_agent.sv` | Encapsulates sequencer, driver, and monitor |
| `tb/agent/my_config.sv` | Agent configuration object |
| `tb/ral/regs.sv` | Register classes and register covergroups |
| `tb/ral/reg_block.sv` | RAL register block and address map |
| `tb/ral/adapter.sv` | Converts RAL operations to/from APB transactions |
| `tb/sequences/cntrl_seq.sv` | CNTRL frontdoor/backdoor and coverage sequence |
| `tb/sequences/reg1_seq.sv` | REG1 frontdoor/backdoor and coverage sequence |
| `tb/sequences/reg2_seq.sv` | REG2 frontdoor/backdoor and coverage sequence |
| `tb/sequences/reg3_seq.sv` | REG3 frontdoor/backdoor and coverage sequence |
| `tb/sequences/reg4_seq.sv` | REG4 frontdoor/backdoor and coverage sequence |
| `tb/env/my_env.sv` | Connects the agent, scoreboard, RAL model, adapter, and predictor |
| `tb/env/my_test.sv` | Creates the environment and runs all register sequences |
| `tb/scoreboard/my_scoreboard.sv` | Checks APB read data against expected values |
| `tb/top.sv` | Instantiates the DUT, interface, clock, and UVM test |
| `scripts/files.txt` | Questa compilation file list |
| `scripts/run.do` | Questa simulation macro script |

---

## Register Sequences

Each register sequence verifies the following flow:

### 1. CNTRL Sequence

- Read the initial desired value.
- Set `CNTRL` to `0xA`.
- Update the hardware through the RAL model.
- Perform a frontdoor read and compare the result.
- Perform a backdoor write of `0x5`.
- Perform a backdoor read and compare the result.
- Write `0x0` and `0xF` through the frontdoor path to exercise control-bit coverage.

### 2. REG1–REG4 Sequences

Each data-register sequence:

- Reads the initial desired value.
- Sets the desired value to `0xAA`.
- Updates the DUT.
- Performs a frontdoor read check.
- Performs a backdoor write/read check using `0x55`.
- Writes representative values for lower, middle, and high coverage bins.

---

## Functional Coverage

The RAL register classes contain covergroups enabled through `UVM_CVR_FIELD_VALS`.

| Covergroup | Coverage Points | Bins |
|------------|-----------------|------|
| `cntrl_cov` | `CTRL0`–`CTRL3` | `0`, `1` for each control bit |
| `reg1_cov` | `REG1.data` | Lower `[0:63]`, Mid `[64:127]`, High `[128:255]` |
| `reg2_cov` | `REG2.data` | Lower `[0:63]`, Mid `[64:127]`, High `[128:255]` |
| `reg3_cov` | `REG3.data` | Lower `[0:63]`, Mid `[64:127]`, High `[128:255]` |
| `reg4_cov` | `REG4.data` | Lower `[0:63]`, Mid `[64:127]`, High `[128:255]` |

The project report records 100% functional coverage for all five register covergroups.

---

## Simulation

The project was developed for Questa/ModelSim-style simulation.

### Compile and Run

From the directory containing `files.txt` and `run.do`:

```tcl
do run.do
```

The macro script performs:

```tcl
vlib work
vlog -f files.txt +cover
vsim -voptargs=+acc work.top -cover
run 0
do wave.do
run -all
```

> Note: `wave.do` is used by the simulation script. Add it to `scripts/` if you want to preserve the waveform configuration in the repository.

### Expected Simulation Flow

The testbench builds the UVM environment, creates the RAL model and APB agent, then runs:

```text
cntrl_seq
reg1_seq
reg2_seq
reg3_seq
reg4_seq
```

The report shows successful frontdoor and backdoor checks, zero UVM errors/fatals at completion, and a simulation finish around 1430 ns.

---

## Tools and Technologies

- SystemVerilog
- UVM
- UVM Register Abstraction Layer (RAL)
- AMBA APB
- QuestaSim / ModelSim
- Functional Coverage
- Git and GitHub

---

## Learning Objectives

This project demonstrates:

- Building a UVM verification environment from scratch.
- Modeling registers with `uvm_reg` and `uvm_reg_field`.
- Creating a `uvm_reg_block` with an address map.
- Implementing a custom `uvm_reg_adapter`.
- Connecting a `uvm_reg_predictor` to a monitor.
- Using frontdoor and backdoor register access.
- Writing reusable register sequences.
- Checking register data integrity with a scoreboard.
- Measuring functional coverage.

---

## Author

**Mostafa Mohamed Farhan**

Digital Verification Course — Project 3

Project: Digital Verification – Project 3  
Topic: APB Peripheral Verification Using UVM RAL
