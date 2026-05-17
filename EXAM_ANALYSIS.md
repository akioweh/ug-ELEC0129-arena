# ELEC0129 — Exam analysis

Synthesised from four past papers (20/21 ELEC0140 sister, 21/22, 22/23, 23/24). The upcoming exam (25/26) is **in-person, closed-book** with the official **`Formula_Sheet.pdf` supplied**. **23/24 is the canonical reference** — it is the only past paper that matches the upcoming format. Earlier years were online open-book and read differently in shape (longer, fewer questions) even though they sit on the same syllabus.

Full transcripts live in `meta/past_papers_transcribed/`.

---

## 1 — Format shift: open-book → closed-book

| Year | Format | Question count | Style |
| --- | --- | --- | --- |
| 20/21 (ELEC0140) | Online, open-book | 6 (Q5 non-examinable for ELEC0129) | Long compute-heavy derivations; ~15–20 marks per question. |
| 21/22 | Online, open-book | 6 | Long derivations, occasional creative-construction parts; no recall. |
| 22/23 | Online, open-book | 5 | Two ~25-mark monsters (full dynamics + full PUMA-style IK) + three medium. |
| **23/24** | **In-person, closed-book** | **30** | **Highly fragmented: ~11 short recall questions (0.5–1 mark each), ~6 worked computations, plus two big set-piece compute questions (Q12 = 23 marks, Q18 = 13 marks).** |

The structural difference matters: open-book papers traded breadth for depth (no rote-recall content; long unbroken derivations); the closed-book paper does the opposite (broad recall sweep, isolated deep compute). The upcoming exam will almost certainly follow the 23/24 template.

---

## 2 — Topic coverage across all four papers

Marks shown as percentages of each paper's total. ELEC0140 Q5 (image moments) excluded.

| Topic block | 20/21 | 21/22 | 22/23 | **23/24** | Notes |
| --- | --- | --- | --- | --- | --- |
| Spatial descriptions / rotations / Euler-Fixed-angles / quaternions / HTM inverse | 25% | 20% | 19% | **15%** | Every year. Heavy in 22/23 (Q1 chains 5 sub-parts on the topic). |
| Forward kinematics (DH + chained transforms) | 15% | 20% | 14% | **34%** | Every year. **Dominant block in 23/24** (Q11 + Q12 alone = 30%). |
| Inverse kinematics | 0% | 0% | 25% | **10%** | Variable. 22/23 had a full 6-DOF IRB120 IK; 23/24 has a 6-mark geometric 3R IK. **Not in 21/22 or 20/21**. |
| Jacobians & singularity | 15% | 20% | embedded in Q2 (14%) | **14%** | Every year. Usually pairs with a singularity-determinant or static-force calculation. |
| Trajectory planning | 20% | 20% | 17% | **7%** | Every year, but 23/24 reduced to a cubic-coefficient procedure + a sketch. Earlier years did septic / half-cosine / LSPB. |
| Dynamics (Newton-Euler + inertia tensor) | 20% | 20% | 25% | **11%** | Every year. 23/24 split into Q22 (procedure), Q23 (spot-the-bug), Q24 (friction recall), Q25 (block inertia integral). |
| Control (2nd-order, PD, partitioned/computed-torque) | embedded in Q4 (20%) | 20% | 0% | **9%** | Every year except 22/23. 23/24 cores: MSD free response + control block diagram + tracking-error proof. |

**Bottom-line topic priorities for the upcoming exam:**

1. **Forward kinematics + DH** is the single biggest block — expect a major matrix-multiplication-by-hand question (the 23/24 Q12 was 23 marks). Drill this until it's mechanical.
2. **Spatial descriptions** is the easy-marks zone: 15+% reliably, mostly definitional and arithmetic.
3. **Jacobians + singularity** (≈14%) is highly formulaic — direct-differentiation of the FK; determinant; identify where it goes to zero.
4. **Dynamics** has shrunk in the closed-book format (11%) but is still examined every year. The inertia-tensor integration question keeps reappearing.
5. **Control** (≈9%) is reliably present — most likely a mass-spring-damper closed-form free response and a tracking-error / partitioned-control argument.
6. **Trajectory planning** (≈7% in 23/24) — practice the cubic-coefficient derivation and one quintic / LSPB.
7. **Inverse kinematics** — unpredictable. In 23/24 it was a geometric 3R for 6 marks. Do not over-invest here; the textbook 6-DOF PUMA case is explicitly **non-examinable** for ELEC0129 per Moodle.

---

## 3 — Question-type taxonomy (23/24 closed-book template)

The 23/24 paper introduces a question-type mix that earlier (open-book) papers don't have. These are the categories to rehearse:

### A. Short recall (≈10 questions × 0.5–1 mark each, ~10% of paper)

Single-bullet answers worth half to one mark. Memorise the answer to each of these recurrently-asked prompts:

- "What is a rigid-body position described by?" → reference frame + body-attached frame + position vector.
- "Write the homogeneous-transform form of `${}^{A}P = {}^{A}_{B}R \, {}^{B}P + {}^{A}P_{B\text{org}}$`."
- "Advantage of Euler parameters?" → no singularities; always a solution.
- "How many fixed-angle conventions?" → 12 (and similarly 12 Euler) = 24 total.
- "Name the four DH parameters." → `α_{i-1}` (link twist), `a_{i-1}` (link length), `d_i` (link offset), `θ_i` (joint angle).
- "What are the two IK questions?" → existence and uniqueness.
- "When does IK have no solution?" → target outside reachable workspace.
- "Definition of kinematic singularity?" → end-effector loses a DOF / Jacobian non-invertible.
- "Disadvantages of Cartesian-space trajectory planning?" → IK at every sample, vulnerability to singularities / workspace boundary.
- "Coulomb friction equation?" → `τ_friction = c·sgn(q̇)`.
- "Overdamped condition?" → `b² > 4mk` (or `ζ > 1`).

### B. Short derivations (≈3 questions × 2.5–4 marks, ~10% of paper)

- Prove a planar rotation matrix is orthonormal (unit columns + pairwise orthogonal).
- Derive `${}^{A}_{B}T^{-1}` from scratch (`R^T` block; `−R^T·p`; `[0 0 0 1]` last row).
- Map a point through a single rotation in closed form (e.g. 45° about Z).

### C. Worked-example computations (≈4 questions × 5–7 marks, ~25% of paper)

- DH parameter derivation from a given schematic (typical: 7 marks).
- Geometric inverse kinematics of a 3R planar / 3R spatial arm.
- Cubic-trajectory coefficient derivation from boundary conditions.
- Inertia-tensor integration of a primitive shape (rectangular block, triangular cross-section).
- Mass-spring-damper closed-form free response from numerical `(m, b, k)` and initial conditions.

### D. Big set-piece computations (2 questions × 13–23 marks, ~35% of paper)

These are where the time goes. Practise the mechanics until they are automatic:

- **Heavy DH × chained transform** (Q12, 23 marks): multiply three modified-DH per-link matrices by hand to get `${}^{0}_{3}T$`. The marking scheme literally allocates marks per matrix product step.
- **Jacobian + symbolic determinant + singular configurations** (Q18, 13 marks): differentiate the position FK column-wise, compute `det J`, set `det J = 0`, enumerate configurations.

### E. Sketches / diagrams (≈3 questions × 0.75–3 marks, ~5% of paper)

- Workspace shape of an RPR / RPP robot in 3D (typically a swept volume).
- Position / velocity / acceleration profile of a quintic trajectory.
- Control block diagram (often Cartesian reference → `J^{-1}` → per-joint feedback).

### F. Spot-the-error / classify (1 question × 3 marks)

23/24 Q23 planted three bugs in a printed 2-link dynamic equation; the candidate identifies and corrects them. Likely a recurring 23/24-style novelty. Common bug types to look for:

- Missing `q̇_i q̇_j` Coriolis cross-term.
- Wrong sign on a gravity component.
- A `q̇²` term where there should be a `q̈`.
- Dimensional mismatch (an `L` where an `L²` should be).
- Asymmetric mass matrix off-diagonals.

---

## 4 — Recurring concrete drills

These specific computations have shown up in *multiple* past papers. Prioritise practising them end-to-end without notes:

| Drill | Appears in | Notes |
| --- | --- | --- |
| Derive `${}^{A}_{B}T^{-1}` in closed form | 22/23 Q1d, 23/24 Q5, 20/21 Q1d | Standard `R^T, −R^T·p` block-matrix derivation. |
| Inverse-extract `α, β, γ` from a numerical rotation matrix | 20/21 Q6, 21/22 Q6, 22/23 Q1, 23/24 Q6 | Use `atan2`; state the gimbal-lock case. |
| DH-table derivation from a schematic | All four years | Modified DH; α₀ = 0, a₀ = 0 by convention; check sanity at home configuration. |
| Multiply chained modified-DH transforms by hand | 22/23 Q2, 23/24 Q12 | Practice 3-link chain in ≤15 min including the simplifications `c₁c₂ − s₁s₂ = c_{12}` etc. |
| Linear Jacobian of an FK + identify singular configurations | 21/22 Q2b, 22/23 Q2b, 23/24 Q18 | Direct-differentiation method; `det J = 0` enumeration. |
| Newton-Euler outward + inward iteration for a 2-link / RP arm | 20/21 Q3, 21/22 Q5 (single-joint), 22/23 Q4 | Including the "gravity via base acceleration" trick. |
| Inertia tensor of a primitive shape by triple integration | 21/22 Q3, 23/24 Q25 | Rectangular block (`m/12·(l²+h²)`), triangular cross-section, rod. The slide's diagonal-negative sign convention on products of inertia. |
| Cubic / quintic / LSPB trajectory coefficient solve | 20/21 Q4, 21/22 Q4, 22/23 Q3b, 23/24 Q20 | Cubic: 4 BCs → 4 coefficients in closed form. The deck's formula sheet supplies the templates. |
| Mass-spring-damper free response with numerical `(m, b, k)` and ICs | 21/22 Q5, 23/24 Q27 | Decide damping regime; assemble the matching closed-form (over / critical / under). |
| Tracking-error closed-loop `ë + k_v ė + k_p e = 0` → `e → 0` | 20/21 Q4c, 21/22 Q5b, 23/24 Q30 | Partitioned-control argument. |

---

## 5 — Exam strategy

### Before the exam

1. **Read the formula sheet cover-to-cover until you know what's on it and where**. The 23/24 paper *relies* on the candidate to know the formula sheet has the modified-DH transform template, the Newton-Euler iteration, the polynomial-trajectory coefficient tables, and the inertia tensor integral form. You won't be re-deriving these — but you need to find them in seconds.
2. **Drill the two big-mark mechanical questions** (chained DH multiplication; Jacobian-and-determinant). Together they're worth ~35% in 23/24. Most of the marks are scoring atomic algebra steps that are itemised in the mark scheme. Speed and reliability matter more than insight.
3. **Memorise the recall bullets** in §3.A. These are free marks if rehearsed.
4. **Drill the recurring derivations** in §4 — `T^{-1}`, Euler-angle extraction, cubic coefficients, MSD response, tracking-error proof — each should be a 3–5 minute reflex.
5. **Skip non-examinable revision**: the PUMA 560 6-DOF IK section in Week 5 is explicitly out of scope per Moodle. Earlier-year 22/23 Q5 (full IRB120 IK) is unlikely to recur in closed-book format because it's a 25-mark monolith.

### During the exam

1. **Triage by mark value, not order.** The 23/24-style paper rewards a "pick off all the recall + sketches first" pass before sinking time into Q12-style monsters. Aim to lock in all 0.5–3-mark items in the first 30 minutes; that's ≈40 marks at high speed.
2. **For chained-transform / Jacobian questions, lay out your work cleanly.** Marks are per intermediate step, not per final-answer correctness. A sign error halfway through still scores most of the procedural marks if the *structure* of the work is visible.
3. **Always sanity-check** worked examples at a home configuration (`θ_i = 0`) — the deck's own examples do this. A failed sanity check tells you where to backtrack.
4. **Don't forget to identify the second IK branch / second β branch.** Past papers explicitly award marks for stating the alternative solution (elbow-up vs elbow-down; `β` vs `π − β`).
5. **When you see a "spot the error" question (Q23-style)**, look for: sign on gravity, missing Coriolis cross-term, dimensional mismatch, asymmetric off-diagonal mass matrix entries.
6. **Read the formula sheet before each major question** to remind yourself of the exact template. The "modified DH transform" matrix in particular has a sign pattern that's easy to recall *wrongly* from memory.

### Time budget (180-minute exam, ~100 marks at 23/24 weighting)

| Block | Marks | Suggested time |
| --- | --- | --- |
| Quick-recall sweep (Q-types A, E) | ~15 | 25 min |
| Short derivations + sketches | ~10 | 20 min |
| Worked examples (DH derivation, geometric IK, MSD response, inertia integral) | ~25 | 50 min |
| Big chained-DH-multiply (Q12-style) | ~23 | 35 min |
| Big Jacobian + determinant (Q18-style) | ~13 | 25 min |
| Buffer / sanity-check / re-read | — | 25 min |

(Adjust if the actual paper splits the heavy marks differently.)

---

## 6 — What is NOT in scope (don't waste time)

- **Full PUMA 560 / IRB120 6-DOF inverse kinematics.** Non-examinable for ELEC0129 (Moodle: Tasks 5.6–5.9). Appears in 22/23 Q5 (open-book) but not in 23/24.
- **Image moments / blob analysis / machine vision.** ELEC0140 only — the 20/21 Q5 content. Does not appear in any ELEC0129-year paper.
- **Lagrangian dynamics.** Not in the syllabus; all four past papers use only Newton-Euler.
- **RoboDK / offline programming.** Coursework only; not exam-relevant.
- **MATLAB code-reading.** No past paper has asked for MATLAB code interpretation.
- **Spherical wrist IK derivation** (deeper than the 3R geometric case). Not present in 23/24; was the 22/23 IRB120 territory only.

---

## 7 — Quick reference: known per-year topic list

(Useful for targeted re-revision.)

**23/24 (closed-book, canonical):** rotation matrix orthonormality • 45° Z-rotation point mapping • HTM as matrix form • derive `T^{-1}` • Z-Y-X Euler-angle extraction + singular condition • count of fixed-angle conventions (12) • DH parameter names • forward-kinematics procedure • RPR DH derivation • **chained ${}^{0}_{3}T$ matrix multiplication (23 marks)** • IK existence/uniqueness recall • RPR workspace sketch • geometric IK of 3R • singularity definition • **linear Jacobian + det + singularities (13 marks)** • Cartesian-trajectory drawbacks • cubic-coefficient derivation • quintic profile sketch • Newton-Euler procedure • spot-3-errors in 2-link dynamics • Coulomb friction equation • rectangular-block `I_{xx}` triple integral • Cartesian control block diagram • underdamped MSD free response with numbers • overdamped condition • independent linear control limitation • tracking-error → `x → x_d`.

**22/23 (open-book):** rotation matrix from frame triads • wrist position under planar rotation • HTM inverse • composed rotations + quaternion • RP-on-linear-stage FK + Jacobian + static forces • workspace + 7th-order trajectory polynomial • full RP Newton-Euler dynamics in canonical form • full IRB120 closed-form 6-DOF IK.

**21/22 (open-book):** angle-axis ↔ quaternion identities + θ=180° axis extraction + unit-column proof • modified-DH for 3-DoF human wrist + rotational Jacobian + singularity • inertia tensor of equilateral-triangle-cross-section rod via triple integration • cubic trajectory + half-cosine custom trajectory • single-joint partitioned controller + tracking-error ODE + damping-regime sweep • Z-Y-Z fixed-angle inverse extraction.

**20/21 (ELEC0140, Q5 non-examinable):** composite rotation from Euler sequence + Euler parameters + angle-axis + HTM inverse • DH derivation for 3-link RPP + linear Jacobian • Newton-Euler dynamics for RP robot in canonical form • LSPB Cartesian trajectory + computed-torque control with critical damping • ~~image moments / blob analysis~~ • X-Y-Z fixed-angle composite + inverse extraction.
