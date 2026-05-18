# ELEC0129 Arena

A study-aid project for the UCL module **ELEC0129 — Introduction to Robotics**. The aim is to equip an agent (you) with the full context of this module so it can carry out any task that draws on it.

## About the module

ELEC0129 is a UCL EEE Year-2 module — the first module of the **IEP Robotics Minor**. It provides a working understanding of the theory of serial articulated **robotic manipulators** (industrial robot arms) and how to analyse and control them.

The module is delivered over **10 weeks**, with **8 lecture topics** spanning weeks 2–10 (weeks 1 and 6 are off; reading week sits between 5 and 7). The lecture series is built bottom-up in a clean dependency chain:

1. **Spatial description and transformation** — rotation matrices, fixed-angle / Euler-angle / equivalent-angle-axis / Euler-parameter parameterisations, the 4×4 homogeneous transformation matrix and its inverse (W2 + W3).
2. **Forward kinematics** — Craig modified DH parameters, frame attachment, per-link transforms, chained `${}^{0}_{N}T`, worked examples on planar and Stanford-Scheinman robots (W4).
3. **Inverse kinematics** — existence/uniqueness, reachable vs dexterous workspace, geometric and algebraic solutions for the 3-link RRR planar arm (W5).
4. **Jacobians** — rotational/linear velocity propagation, direct differentiation, kinematic singularities, the `τ = J^T F` static-force duality (W7).
5. **Trajectory planning** — cubic, quintic, linear-with-parabolic-blends (W8).
6. **Manipulator dynamics** — Newton-Euler outward/inward iteration, the canonical form `τ = M(θ)θ̈ + V(θ,θ̇) + G(θ)`, inertia tensor (W9).
7. **Manipulator control** — second-order systems, PD on a mass / on a mass-spring-damper, control-law partitioning, single-joint DC-motor model, computed-torque MIMO control (W10).

The course focuses exclusively on **serial articulated manipulators** — not mobile robots, not parallel mechanisms beyond a one-slide mention, not soft robotics, not perception/AI. Notation follows **John J. Craig, _Introduction to Robotics: Mechanics and Control_** throughout (modified DH convention; leading-superscript frame notation `${}^{A}P$`, `${}^{A}_{B}R$`, `${}^{A}_{B}T$`).

Learning outcomes (paraphrased): analyse and design serial robotic manipulators; describe spatial poses across multiple frames; solve forward and inverse kinematics; reason about velocities, singularities, and statics via the Jacobian; derive joint torques via Newton-Euler dynamics; plan smooth trajectories; design model-based controllers. The final exam (40% of the module, **in-person, closed-book** with a supplied formula sheet) tests only the lecture content above — group coursework (Build + RoboDK demo, 60%) is out of scope for this project.

## Layout

- `materials/` — **the default reading bundle.** Everything needed for general module knowledge. Sized to fit in one context window. See "Default behaviour" below.
- `meta/` — workflows and conventions for tasks that maintain or extend the project itself (see "Meta tasks" below). Holds the original PDFs, full per-lecture transcripts, exercise sheets, past papers, formula sheet, and the original Moodle source.
- `MODULE.md` — cross-cutting module context (LOs, assessment, schedule, examinability caveats, conventions). Useful preamble.
- `SYLLABUS.md` — conceptual syllabus mapping each lecture topic to in-scope / out-of-scope content. The structured "what's on the exam" map.
- `PROBLEMS.md` — registry of source-slide issues found by adversarial review. Most are now annotated inline in the transcripts.
- `EXAM_ANALYSIS.md` — patterns synthesised from past papers + recommended exam strategy.
- There may be loose files at the root level. Without specific instructions, there is no need to proactively read them.

## Default behaviour

`materials/` is **mandatory context** — (not including subfolders) read every file in it **end-to-end** at session start, before doing anything else. In particular, `materials/ALL_SLIDES.md` and `materials/LORE.md` must be read **in their entirety** — not skimmed, not grepped, not partially read. They are the core module content and any non-trivial answer depends on having them fully in context. Searching into them after the fact instead of reading them up-front is the failure mode to avoid.

The only exception is when the task at hand is clearly a **meta task** (see below) and so does not draw on the module content.

## Meta tasks

Some tasks maintain or extend the project itself rather than draw on the module content — transcribing new slide decks, expanding the `materials/` bundle, refining indexes, rebuilding `ALL_SLIDES.md`, and so on. Workflows and conventions for these **meta tasks** live in `meta/README.md`.
