# Van der Pol Oscillator – Verilog Implementation

## Overview
This project presents a hardware-oriented implementation of the Van der Pol oscillator using Verilog HDL. The Van der Pol oscillator is a nonlinear second-order dynamical system known for its self-sustained oscillations and stable limit-cycle behavior.

The continuous-time differential equations are discretized using the forward Euler method and implemented in digital hardware using fixed-point arithmetic.



## Mathematical Model
The Van der Pol oscillator is described by the equations:

y' = u  
u' = μ(1 − y²)u − y  

These equations are discretized using the forward Euler method with a fixed time step Δt.



## Numerical Method
The forward Euler discretization is given by:

y(k+1) = y(k) + Δt · u(k)  
u(k+1) = u(k) + Δt · [ μ(1 − y(k)²)u(k) − y(k) ]



## Hardware Architecture
The design consists of:
- A **datapath** implementing arithmetic operations (adders and multipliers)
- A **finite state machine (FSM)** acting as the control unit
- Multi-cycle execution to satisfy data dependencies and reduce hardware resource usage

Fixed-point **Q16.16** arithmetic is used to represent real-valued signals.



## Fixed-Point Representation
- Format: Q16.16
- Range: approximately −32768 to +32767
- Time step: Δt = 0.01 (represented in Q16.16)
- Parameter: μ = 1

This format provides sufficient precision while maintaining numerical stability.



## Simulation and Verification
A Verilog testbench is provided to:
- Generate clock and reset signals
- Log oscillator outputs at discrete time steps
- Convert fixed-point values to real numbers for analysis

Behavioral simulation results demonstrate bounded oscillations and convergence to a stable limit cycle, consistent with theoretical expectations.



## Project Structure
