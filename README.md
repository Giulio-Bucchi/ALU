# 32-bit ALU in VHDL

## Description

This project implements a **32-bit Arithmetic Logic Unit (ALU)** using the VHDL hardware description language.  
The ALU is a fundamental component in processors, responsible for executing core arithmetic and logical operations.

The repository also includes a **testbench** for functional verification through simulation, allowing validation of the ALU's behavior under various operating scenarios.

## Files

- `alu.vhdl`: Contains the architectural and behavioral description of the ALU.
- `alu_tb.vhdl`: Complete testbench for simulating and verifying the ALU's correct functionality.

## Features

The ALU supports various operations on two 32-bit operands, selected via a control signal (`opcode`).

| Opcode | Operation              | Description                           |
|--------|------------------------|---------------------------------------|
| "000"  | Addition               | Adds A and B (`A + B`)                |
| "001"  | Subtraction            | Subtracts B from A (`A - B`)          |
| "010"  | Bitwise AND            | Logical AND between A and B (`A AND B`) |
| "011"  | Bitwise OR             | Logical OR between A and B (`A OR B`)   |
| "100"  | Bitwise XOR            | Logical XOR between A and B (`A XOR B`) |
| "101"  | Bitwise NOT            | Bitwise negation of A (`~A`)          |
| "110"  | Increment              | Increments A by 1 (`A + 1`)           |
| "111"  | Decrement              | Decrements A by 1 (`A - 1`)           |

> *Note: The exact behavior may vary depending on the specific implementation. Refer to `alu.vhdl` for full details.*

## Simulation Instructions

You can simulate the project using tools such as **GHDL**, and view the resulting waveforms with **GTKWave**.

### Simulating with GHDL

```bash
ghdl -a alu.vhdl
ghdl -a alu_tb.vhdl
ghdl -e alu_tb
ghdl -r alu_tb --vcd=wave.vcd
```
⚠️ If you encounter issues opening wave.vcd in GTKWave, you can simulate and visualize the waveform using EDA Playground instead.

![Waveform Screenshot](https://github.com/user-attachments/assets/6e720640-1189-45fb-80d2-0f4006490c6b)

