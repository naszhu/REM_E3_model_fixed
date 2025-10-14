# Asymptotic Function Applications in REM E3 Model

## Mathematical Formula

The core asymptotic function follows the exponential approach formula:

**F(k) = s + (a - s) × (1 - e^(-rk))**

Where:
- **F(k)** = Value at step k
- **s** = Starting value (initial parameter value)
- **a** = Asymptote value (value approached as k → ∞)
- **r** = Rate parameter (controls speed of approach)
- **k** = Step index (typically list number - 1, ranging from 0 to 9)

---

## Table 1
*Asymptotic Function Parameters and Applications in E3 Memory Model*

| Process | Function Type | Location | s (Start) | a (Asymptote) | r (Rate) | k Range | Description |
|---------|--------------|----------|-----------|---------------|----------|---------|-------------|
| h(j) increase | `asym_increase_shift_hj` | constants.jl:171 | 0.35 | 0.58 | 0.85 | 0–9 | Confusing foil strength increase: Controls how confusing foils become more difficult to reject across lists |
| κu constant | `asym_decrease_shift_fj` | constants.jl:175 | 0.25 | 0.25 | N/A | 0–9 | Study-only target probability: **CONSTANT** at 0.25 (fj_asymptote_decrease_val=0.00 disables asymptotic change) |
| κs constant | `1 - asym_decrease_shift_fj` | constants.jl:176 | 0.80 | 0.80 | N/A | 0–9 | Study-only confusing foil probability: **CONSTANT** at 0.80 (fj_asymptote_decrease_val=0.00 disables asymptotic change) |
| κb constant | `1 - asym_decrease_shift_fj` | constants.jl:177 | 0.99 | 0.99 | N/A | 0–9 | Study-and-test confusing foil probability: **CONSTANT** at 0.99 (fj_asymptote_decrease_val=0.00 disables asymptotic change) |
| κt constant | `1 - asym_decrease_shift_fj` | constants.jl:178 | 0.99 | 0.99 | N/A | 0–9 | Test-only confusing foil probability: **CONSTANT** at 0.99 (fj_asymptote_decrease_val=0.00 disables asymptotic change) |
| UC distortion | `asym_decrease` | feature_updates.jl:86 | 0.00 | 0.00 | 5.0 | 0–29 | Unchanging context distortion: Probability of distorting UC features decreases across probe positions (currently disabled with s=a=0) |
| CC distortion | `asym_decrease` | feature_updates.jl:86 | 0.30 | 0.00 | 5.0 | 0–29 | Changing context distortion: Probability of distorting CC features decreases across probe positions within each test |
| Initial criterion | `generate_asymptotic_values` | constants.jl:74 | 1.0 | 0.16 | 3.0 | 0–29 | Decision criterion decrease: Old-new recognition criterion decreases across probe positions within initial test |

---

## Notes

1. **Z Feature System**: The κ parameters control the Z feature (tested-before feature) update probabilities, which track whether items have been encountered during testing. Higher κ values increase the probability of storing Z=1 (indicating test exposure).

2. **Asymptotic vs Constant Parameters**: With `fj_asymptote_decrease_val = 0.00`, the κ parameters (κu, κs, κb, κt) are currently **constant across lists** rather than asymptotically changing. The h(j) parameter does asymptotically increase (0.35 → 0.58). If `fj_asymptote_decrease_val` were non-zero (e.g., 0.35 as shown in comments), κu would decrease and κs/κb/κt would increase across lists.

3. **Rate Parameter**: Higher rate values (r) produce faster asymptotic approach. The context distortion functions use r=5.0 for rapid decay, while Z feature functions use r=0.26 for gradual change across lists.

4. **Step Index**: For Z feature parameters (h(j), κ values), k represents list number minus 1 (k = 0 to 9 for 10 lists). For distortion and criterion parameters, k represents probe position within a test (k = 0 to 29 for 30 probes).

5. **Context Distortion**: UC (unchanging context) distortion is currently disabled (s=a=0.00), while CC (changing context) distortion starts at 30% probability for early probes and decays to 0% by probe position 30.

6. **Geometric Distribution**: When features are distorted or stored with copying errors, new feature values are drawn from Geometric(g=0.3) + 1 distribution.

---

## Detailed Process Descriptions

### Z Feature Parameters (κ values)

The Z feature system tracks whether items have been tested before. Four κ parameters control the probability of storing Z=1 (tested-before status) for different item types.

**IMPORTANT**: With current parameter setting `fj_asymptote_decrease_val = 0.00`, all κ values are **CONSTANT across lists** (no asymptotic change):

- **κu (Study-only targets)**: **Constant at 0.25** across all lists. The asymptotic function is called but with asymptote = start, resulting in no change. (If `fj_asymptote_decrease_val` were 0.25, it would decrease from 0.25 → 0.00)

- **κs (Study-only confusing foils - SOn)**: **Constant at 0.80** across all lists. Computed as 1 - f(j) where f(j) is constant at 0.20. (If `fj_asymptote_decrease_val` were non-zero, it would increase toward 1.00)

- **κb (Study-and-test confusing foils - Tn)**: **Constant at 0.99** across all lists. Computed as 1 - f(j) where f(j) is constant at 0.01. These items were both studied and tested, so they have very high probability of being marked as tested.

- **κt (Test-only confusing foils - Fn)**: **Constant at 0.99** across all lists. Computed as 1 - f(j) where f(j) is constant at 0.01. These items appear only at test, and they have very high probability of being marked as tested.

**Note**: The commented-out value `fj_asymptote_decrease_val = 0.35` suggests asymptotic change was tested previously but is currently disabled.

### Context Distortion Parameters

Context distortion simulates the decay of context retrieval accuracy across probe positions within a test:

- **UC (Unchanging Context)**: Currently disabled (base_distortion_prob_UC = 0.0). When enabled, it would distort features in the unchanging context portion with asymptotically decreasing probability.

- **CC (Changing Context)**: Active with base_distortion_prob_CC = 0.3. The first probe has 30% probability of having each CC feature distorted, and this probability asymptotically decreases to 0% by probe position 30.

### Decision Criterion

The initial test decision criterion uses an asymptotic decrease from 1.0 to 0.16 across the 30 probe positions within each test. This reflects participants becoming more liberal in their "old" responses as the test progresses, which helps maintain performance when memory traces accumulate.

---

## References

Implementation files:
- `constants.jl`: Parameter definitions and asymptotic function calls
- `feature_updates.jl`: Context distortion implementation
- `utils.jl`: Asymptotic function implementations

Related issues:
- Issue #50: Context distortion features for UC and CC
- Issue #64: Z feature implementation aligned with E3 rules
