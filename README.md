---

## 🚀 AHB Protocol Verification Suite

This repository contains a fully UVM-compliant testbench for verifying an Advanced High-performance Bus (AHB) design, along with a configurable DUT that supports burst and single read/write transfers. The environment is architected to facilitate both functional and protocol-level validation using scalable, reusable components.

### 🔧 DUT Features

- ✅ Supports `HTRANS`, `HWRITE`, `HADDR`, `HWIDTH`, `HBURST`, `HLENGTH`, `HREADY`, `HSIZE`, `HRDATA`, and `HRESP`
- 🧠 Handles:
  - Single transfers (`HTRANS_NONSEQ`)
  - Incrementing bursts (`HTRANS_SEQ`)
  - Error flags on illegal `HTRANS`, misaligned addresses, invalid bursts
- 💾 Internal memory of 256 words (word-aligned)

---

### 🧪 Testbench Components (UVM-Based)

| Component     | Role                                                |
|---------------|-----------------------------------------------------|
| `ahb_seq_item` | Transaction definition including enums and constraints |
| `ahb_base_sequence` | Generates legal transfers                        |
| `ahb_negative_seq`  | Injects illegal conditions for negative scenarios |
| `ahb_sequencer`     | Passes sequence items to driver                 |
| `ahb_driver`        | Drives DUT signals and burst logic              |
| `ahb_monitor`       | Samples interface and publishes transactions    |
| `ahb_scoreboard`    | Verifies protocol correctness                   |
| `ahb_agent`         | Wraps sequencer, monitor, driver                |
| `ahb_env`           | Connects all agents and scoreboard              |
| `tb_top`            | Instantiates DUT and launches UVM tests         |

---

### ✅ Functional Tests Included

- Single Read/Write
- Burst Read/Write
- Transfer size and alignment
- Burst sequencing: NONSEQ → SEQ
- Response handling and memory visibility

---

### ❌ Negative Protocol Tests (T1–T20)

> 20 targeted error scenarios, each tested with dedicated sequences and classes

| Category                     | Examples                                   |
|-----------------------------|--------------------------------------------|
| Transfer Type Errors        | Reserved `HTRANS`, persistent IDLE         |
| Size & Alignment            | Oversized `HSIZE`, misaligned addresses    |
| Burst Misuse & Addressing   | Wrap misalignments, 1KB boundary violations|
| Master/Slave Misbehavior    | Stall, RETRY loops, invalid `HRESP`, etc.  |
| Arbitration & Clock Issues  | Bus lock, glitch injection, signal toggling|
| Illegal Configurations      | Undefined control signals (`X`), reserved `HBURST`|

Each test is independently runnable and logged for traceability. Easily extendable to support random testing, coverage, or multi-agent configurations.

---

### 🛠 Requirements

- SystemVerilog & UVM 1.2+
- Simulator with support for enum types and virtual interfaces
- Recommended: coverage and waveform viewer for debugging

---
