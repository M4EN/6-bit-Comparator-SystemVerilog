# 6-bit Signed/Unsigned Comparator (SystemVerilog)

## Overview

This project implements a 6-bit comparator using structural (gate-level) SystemVerilog.
It supports both unsigned and signed (2’s complement) comparisons and produces three outputs:

* Equal (A == B)
* Greater (A > B)
* Smaller (A < B)

The comparison mode is selected using a control signal:

* S = 0 → Unsigned
* S = 1 → Signed

The design is extended with a synchronous output stage and verified using an exhaustive self-checking testbench.

---

## Design

### Structural Comparator

* Implemented using basic logic gates (AND, OR, NAND, NOR, XNOR, INV)
* Equality is computed using bitwise XNOR followed by reduction
* Magnitude comparison is built hierarchically from MSB to LSB

### Signed vs Unsigned Logic

* Unsigned comparison follows standard magnitude logic
* Signed comparison evaluates the MSB (sign bit) first, then compares remaining bits
* A 2:1 multiplexer selects the correct result based on S

### Synchronous Output

* Outputs are registered using a clock
* Ensures stable results after propagation delay

---

## Timing

* Maximum propagation delay: 37 time units
* Clock period: 38 time units
* Outputs are sampled on the clock edge after stabilization

---

## Verification

* Exhaustive testing of all input combinations
* Behavioral reference model used for expected results
* Automatic comparison between structural and expected outputs
* Simulation stops on mismatch and reports failure

---

## Expected Output

If all tests pass:

```
============= PASS ===========
```

If a mismatch is detected:

```
============= FAIL ===========
```

---
