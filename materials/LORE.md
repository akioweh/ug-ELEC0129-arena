# Lore

Information from outside the lecture decks — Moodle posts, scope notes, source-slide corrections, exam conventions — that is not in `ALL_SLIDES.md` but matters for the exam (or for reading the slides correctly).

Two kinds of entries live here:

1. **Corrections** to information in the slides that is wrong or misleading.
2. **Clarifications and conventions** communicated outside the slides (Moodle, scope notes, exam format) that the exam relies on.

Compare with the inline `<!-- transcription-audit: -->` blocks in `ALL_SLIDES.md`, which document fidelity-of-transcription decisions only — _not_ the truth value of the underlying content. Compare also with `../PROBLEMS.md` at the project root, which holds the full per-lecture issue index.

---

## Exam format

### In-person, closed-book — changed from prior years

**The slides imply** (and the 20/21, 21/22, 22/23 past papers were sat under): online, open-book.

**Currently correct:** the final exam is **40% of the module**, **in-person, closed-book**, in the format introduced in 23/24 and retained for 25/26. The 23/24 past paper (and its model solutions) is the canonical reference for what the upcoming exam looks like — earlier years should be used for topical drilling but not as a stylistic template, because their question shape (5–6 long open-book derivations) is very different from the 23/24 format (≈30 fragmented short questions + 2 big set-piece computations together carrying ~35% of the marks).

**Source:** Moodle "Module assessment details" section. See `../EXAM_ANALYSIS.md` for the full format analysis.

### Formula-sheet delivery model

**The formula sheet does *not* appear in the exam as a separate consulted page.** The sheet's own opening note states:

> "Instead, they will appear in the particular question where required. For e.g. 'Given the rotation matrix, calculate the Euler parameters. Hint: Formula is …'"

So the role of `Formula_Sheet.pdf` / `Formula_Sheet.md` is to tell you *in advance* which formulae you don't need to memorise — because if a question requires one of them, it will be supplied inline as a hint with that question. There is no separate reference page to flip to during the exam.

**Practical implications:**

- Memorise what *isn't* on the sheet (everything in the lectures that the sheet doesn't list — see below), because those won't be hinted in-question either.
- For what *is* on the sheet, focus revision on slick *application* rather than recall. You will get the formula but you still need to apply it under time pressure.
- The list of in-sheet formulae also tells you what topics the exam is likely to test: the sheet exists for formulae the lecturer plans to supply, which strongly correlates with what's compute-intensive enough to be examined at length.

### What the formula sheet actually contains

A complete list (3 pages — see `Formula_Sheet.md` for the verbatim formulae):

| Section | Contents |
| --- | --- |
| **Spatial description and transformation** | Equivalent angle-axis matrix (with versine shorthand `vθ = 1 − cθ`); Euler-parameter rotation matrix. |
| **Forward kinematics** | Craig modified-DH per-link transform `${}^{i-1}_{i}T`$. |
| **Inverse kinematics** | **None.** Explicitly listed with the word "None". |
| **Jacobians** | Velocity-propagation equations — revolute joints, prismatic joints, end-effector recovery from the last propagated link. |
| **Trajectory planning** | Linear-segment-with-parabolic-blends (LSPB): the blend-time / blend-position formulas `t_b`, `u_b`, and the three-segment piecewise `u(t)`. |
| **Dynamics** | Newton-Euler outward iteration (full set: `ω, ω̇, v̇, v̇_C, F, N`); inward iteration (`f, n`, plus revolute/prismatic τ extraction); Cartesian-space dynamics `J^{-T} M(q) J^{-1} = M_x` (with `V_x`, `G_x` likewise); the inertia tensor matrix and the six integrals (mass moments and products of inertia). |
| **Control** | **None.** Explicitly listed with the word "None". |

### What the formula sheet does **NOT** contain (memorise / be able to derive these)

- **Elementary rotation matrices** `Rot(x, θ)`, `Rot(y, θ)`, `Rot(z, θ)`.
- **The 4×4 HTM block form** (rotation + translation + `[0 0 0 1]`).
- **HTM inverse closed form** `[R^T, −R^T·p; 0, 1]`.
- **Fixed-angle / Euler-angle** parameter↔matrix recipes (and the `atan2`-based recovery formulas).
- **Cubic and quintic polynomial trajectory** coefficient solutions — only LSPB is on the sheet.
- **Mass-spring-damper** standard form and the over/critical/under-damped closed-form responses.
- **PD / partitioned-control / computed-torque** law structures (the model-based compensator + servo controller split).
- **Single-joint DC-motor model** equations.
- **All inverse-kinematics** content (workspace, geometric/algebraic solution techniques) — Moodle: "None".

**Source:** the formula sheet PDF itself + Moodle.

---

## Scope — non-examinable content that appears in the slides

The following appears in lecture material but is explicitly **not in scope** per Moodle. Don't waste revision time on it.

### W5 Inverse Kinematics — full PUMA 560 6-DOF derivation

The deck contains a complete 25-slide PUMA 560 worked example (slides 45–69 of the W5 PDF / the corresponding section of `ALL_SLIDES.md`). Moodle marks the supporting video material as "Optional, not examinable" (Tasks 5.6–5.9). The examinable inverse-kinematics core is: workspace + existence/uniqueness; the geometric solution of the 3-link RRR planar arm; the algebraic solution of the same; the multiplicity-of-solutions discussion.

Inline `(non-examinable)` flags are present throughout the PUMA section of the transcript.

**Source:** Moodle weekly schedule, Week 5.

### Past-paper sister-module question

`materials/past_papers/ELEC0140_2021.md` is from ELEC0140 (sister module), not ELEC0129. Moodle explicitly states: **"From ELEC0140 – Please Ignore Question 5"**. Q5 is about image moments / machine-vision blob analysis — outside the ELEC0129 syllabus. The other questions (Q1–Q4, Q6) parallel ELEC0129 topics and are good practice.

**Source:** Moodle, "Past Exam Papers" section heading.

### Anything labelled "Optional" in the per-week task lists

Every week's "Optional" sub-section on Moodle (Q&A walkthrough videos, tutorial recordings) is examinable in *substance* — those videos walk through the tutorial sheets that ARE in scope — but you do not need to watch the videos themselves. The authoritative tutorial materials are the **written** Q+A PDFs in `../meta/exercise_sheets/`.

---

## Known source-slide errors (exam-impacting)

The full per-lecture issue index lives in `../PROBLEMS.md`. The four entries below are worth memorising verbatim so you don't propagate them from memory under exam pressure.

### W4 slide 68 — chained `${}^{0}_{4}T(1,1)` matrix entry typo

**Slide writes:** the (1,1) entry of the chained transform as `s₁·s₃·s₄ + c₁·s₄`.

**Correct:** `c₁·s₄ + s₁·s₃·c₄`. The second term must pair `s₃` with `c₄`, not `s₄`.

The slide-71 sanity check masks the typo because it sets `θ₄ = 0`, so `s₄ = 0` and both forms collapse to zero. **Always derive a chained transform yourself from the DH table rather than copying.** The fix is applied silently in the transcript with an inline flag.

### W7 slide 46 — spherical-wrist singularity wording is back-to-front

**Slide says:** at the wrist singularity the end-effector "loses ability to rotate about the axis".

**Correct:** when wrist axes 4 and 6 become collinear, joints 4 and 6 actuate the **same** rotation axis — that DOF is, if anything, redundantly retained. What's lost is the ability to rotate about an axis **perpendicular** to the collinear pair (the third orientation DOF that joint 5 was providing in combination with the others). Phrase exam answers using the corrected statement.

The transcript carries the corrected wording in the prose with the slide's original wording quoted in the inline `<!-- suspected-source-error -->` flag.

### W10 slide 25 — closed-loop equivalence stiffness term

**Slide writes:** `mẍ + b·ẋ + bx = 0`.

**Correct:** `mẍ + b·ẋ + kx = 0`. The intended typographic mapping for PD-on-a-pure-mass is `kᵥ ↔ b` (damping) and `kₚ ↔ k` (stiffness). The slide accidentally mistypes the stiffness as `b`.

If memorised verbatim, you'd later derive `kₚ = b` from "compare the position coefficients", which is wrong. Treat the canonical mass-spring-damper equation as `mẍ + bẋ + kx` everywhere.

### W10 slide 78 — MATLAB simulation is silently pure-P, not PD

The MATLAB closed-loop simulation used in lecture has two distinct problems:

1. **Missing feedforward** — `servoControl` uses only position error, dropping the `q̈_d`, `q̇_d` terms from the partitioned-control law. The slide's inline comment frames this as "regulation, not trajectory tracking".
2. **Case-sensitivity bug not acknowledged on the slide.** The variables `q1dot`, `q2dot` (lowercase, used in `servoControl`) are initialised to 0 and **never updated**. The actually-integrated velocities are `q1Dot`, `q2Dot` (capital D). MATLAB identifiers are case-sensitive, so the velocity-feedback term is permanently zero.

**Effect:** the simulation video shown in lecture is demonstrating proportional-only behaviour, not the PD partitioned controller the lecture is teaching. **Do not trust the qualitative behaviour shown in the demo videos.** The theoretical partitioned-control structure on slides 36 and 67 is correct — only the demo is buggy.

---

## Notation conventions (recap)

The whole module follows John J. Craig, _Introduction to Robotics: Mechanics and Control_:

- `${}^{A}P$` — position vector P expressed in frame A.
- `${}^{A}_{B}R$` — rotation matrix mapping frame-B coordinates to frame-A coordinates.
- `${}^{A}_{B}T$` — 4×4 homogeneous transformation matrix.
- **Modified** DH parameters (frame at proximal end of link `i`): `α_{i-1}` (link twist), `a_{i-1}` (link length), `d_i` (link offset), `θ_i` (joint angle). Per-link transform on the formula sheet.
- Newton-Euler outward iteration: `${}^{i+1}\omega_{i+1}, {}^{i+1}\dot\omega_{i+1}, {}^{i+1}\dot v_{i+1}, {}^{i+1}\dot v_{C_{i+1}}, {}^{i+1}F_{i+1}, {}^{i+1}N_{i+1}$`. Inward: `${}^{i}f_i, {}^{i}n_i, \tau_i$`.
- Canonical dynamics: `τ = M(θ)θ̈ + V(θ,θ̇) + G(θ)`. Mass matrix M is symmetric positive-definite.
- Gravity trick: `${}^{0}\dot v_{0} = G$`, where G is opposite to gravity (magnitude g).

Past papers occasionally use `artan2` (the source slides do too); read as `atan2` everywhere — they are the same function.
