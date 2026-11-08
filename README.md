# Design and Analysis of Optimized Multi-Mode Taps FIR Filters Using Xilinx Vivado and MATLAB

B.Tech Major Project | Dept. of Electronics and Communication Engineering
School of Technology, Pandit Deendayal Energy University (PDEU), Gandhinagar | 2026

**Author:** Aditya Khuttan (22BEC053)
**Guide:** Dr. Ankur Changela

## Overview
FIR filters are a core building block of DSP systems because they are stable, have linear phase and are easy to implement in hardware. As the tap count grows, conventional designs need more multipliers and adders, which increases power, delay and FPGA area.

This project designs **scalable multi-mode FIR filters from 4 to 10 taps** in Verilog HDL and compares a **conventional (non-optimized) MAC architecture** against an **optimized architecture**. Filter coefficients are generated in MATLAB, and the designs are simulated and implemented in Xilinx Vivado on the **Nexys A7-100T** FPGA board.

## Multi-Mode Operation
A single architecture supports four filter types, selected by a 2-bit mode input:

| Mode | Filter |
|------|--------|
| 00 | Low-Pass (LPF) |
| 01 | High-Pass (HPF) |
| 10 | Band-Pass (BPF) |
| 11 | Band-Stop (BSF) |

## Optimization Techniques
- **Coefficient symmetry:** pre-adders share multiplications, so fewer multipliers and DSP slices
- **Balanced adder tree:** parallel addition stages shorten the critical path
- **Pipelining:** registers split long combinational paths
- **Clock-enable (CE) based low-power operation:** arithmetic units stay idle when not needed
- **Resource sharing and DSP optimization**

## Design Flow
MATLAB FDATool (coefficients) → Fixed-point conversion → Verilog RTL → Testbench simulation (Vivado) → Synthesis and implementation → Timing, power and utilization analysis (Nexys A7-100T)

## Results (Optimized vs Non-Optimized)

| Taps | Power (W) WO → OPT | Delay (ns) WO → OPT | Total LUT WO → OPT |
|:---:|:---:|:---:|:---:|
| 4  | 0.127 → 0.126 | 9.007 → 8.496  | 1561 → 790  |
| 5  | 0.129 → 0.126 | 10.838 → 7.282 | 1950 → 1180 |
| 6  | 0.130 → 0.127 | 12.423 → 8.722 | 2338 → 1180 |
| 7  | 0.131 → 0.129 | 14.035 → 7.691 | 2722 → 1582 |
| 8  | 0.133 → 0.129 | 16.056 → 11.178 | 3107 → 1567 |
| 9  | 0.135 → 0.130 | 20.330 → 11.029 | 3191 → 1954 |
| 10 | 0.135 → 0.129 | 19.675 → 10.716 | 3878 → 1597 |

*WO = without optimization, OPT = with optimization.*

### Improvement
| Taps | Power | Delay | Total LUT |
|:---:|:---:|:---:|:---:|
| 4  | 0.79% | 5.67%  | 49.39% |
| 5  | 2.33% | 32.81% | 39.49% |
| 6  | 2.31% | 29.79% | 49.53% |
| 7  | 1.53% | 45.20% | 41.88% |
| 8  | 3.01% | 30.38% | 49.57% |
| 9  | 3.70% | 45.75% | 38.77% |
| 10 | 4.44% | 45.54% | 58.82% |

**Maximum improvements:** power **4.44%**, delay **45.75%**, total LUT **58.82%**. Gains generally grow with tap count.

### Even vs Odd Taps
| Taps | LPF | HPF | BPF | BSF |
|------|-----|-----|-----|-----|
| Even | Good | Moderate | Good | Moderate |
| Odd  | Relatively good | Good | Relatively good | Good |

Odd-tap designs suit a generalized multi-mode filter; even-tap designs suit LPF and BPF.

## Tools Used
Verilog HDL | Xilinx Vivado (simulation, synthesis, implementation, power analysis) | MATLAB FDATool | Nexys A7-100T FPGA

## Repository Structure
```
rtl/            Verilog design files (4-10 taps, optimized and non-optimized)
tb/             Testbenches
matlab/         Coefficient generation and frequency response scripts
constraints/    XDC files for Nexys A7-100T
results/        Simulation, utilization, timing and power screenshots
docs/           Project report (PDF) and presentation
```

## Future Scope
Higher-order and adaptive FIR filters, ASIC implementation, advanced multipliers (Booth, Wallace, Vedic, approximate), AI/ML-based optimization, and real-time DSP, wireless and biomedical applications.
