# ELEC0129 — Module Context

Cross-cutting module information that doesn't fit cleanly into any single lecture transcript. The authoritative source is the scraped Moodle page at `meta/_moodle_source/moodle_page.html`; this file distils the parts an agent needs in order to reason about the module.

## What this module is

**ELEC0129: Introduction to Robotics** — a 10-week UCL undergraduate Year-2 module run by the EEE department. It is the **first module of the IEP Robotics Minor** and provides a general understanding of the theory of robotic **manipulators** (articulated robotic arms) and how industrial robots are programmed to perform automation tasks.

The module is run by **Dr Chow Yin Lai** (module leader, uceecyl@ucl.ac.uk) and **Dr Yu Wu** (yu.wu.09@ucl.ac.uk); the teaching/learning rep is Dr Roselina Arelhi (r.arelhi@ucl.ac.uk).

## Stated learning outcomes

At the end of the module, students should be able to:

1. Demonstrate learning of the theory of robotic manipulators for analysis and synthesis of armed robots.
2. Simulate the motion of articulated robots.
3. Control the robot arms to follow a prescribed trajectory.
4. Program an actual robotic manipulator using state-of-the-art software (RoboDK).

LOs 2-4 are workshop / coursework outcomes; **only LO 1 maps to the final exam**, which is the project's focus.

## Syllabus topics (Moodle's own list)

1. Spatial transformations and descriptions
2. Robot kinematics (forward + inverse)
3. Jacobians
4. Robot dynamics
5. Trajectory planning
6. Control of robots
7. Offline robot programming **(coursework only, not exam-relevant)**

## Assessment

| Component | Weight | Format | Notes |
| --- | --- | --- | --- |
| Individual Coursework — Robot Offline Programming (RoboDK) | 20% | Submit `.rdk` station files | Released 19/01/2026, due 20/02/2026. **Coursework — out of scope for this project.** |
| Group Coursework — Robot Report + Pick-and-Place Demo | 40% | Group report PDF + live demo | Released 26/01/2026, due 27/03/2026. **Coursework — out of scope for this project.** |
| **Final Exam** | **40%** | **In-person, closed-book** | **This project's sole focus.** Date TBC. |

Peer review (IPAC) is required for the group coursework but is not exam-relevant.

## Exam format

- **In-person, closed-book** (changed from prior years' online open-book format — see past papers).
- A printed **formula sheet** is provided in the exam (`meta/formula_sheet/Formula_Sheet.pdf` matches the in-exam sheet — verified against the 23/24 zip which bundled the same PDF).
- Past papers from 21/22, 22/23, 23/24 are direct ELEC0129 instances; **20/21 is from sister module ELEC0140 — Question 5 in that paper is explicitly out of scope per Moodle.**

## Weekly schedule

Synchronous sessions Mondays (11:00-13:00) and Wednesdays (9:00-11:00); venue MPEB 6.02 (or Roberts 7.04 for some weeks). Async videos + lecture-notes released the Friday before.

| Week | Lecture topic | Tutorial? | Workshop |
| --- | --- | --- | --- |
| 1 | — (Year 2 Scenario Week, no class) | — | — |
| 2 | Introduction to the Course + Spatial Description & Transformation (Part 1) | — | Offline programming (RoboDK intro) |
| 3 | Spatial Description & Transformation (Part 2) | ✓ | Build physical robot |
| 4 | Forward Kinematics | ✓ | Forward kinematics on student robot |
| 5 | Inverse Kinematics | ✓ | Offline programming continued |
| RW | Reading Week (RoboDK assignment due Fri 20/02/2026) | — | — |
| 6 | — (Year 2 Scenario Week, no class) | — | — |
| 7 | Jacobians | ✓ | Inverse kinematics on student robot |
| 8 | Trajectory Planning | — | Trajectory coding on student robot |
| 9 | Manipulator Dynamics | ✓ | Trajectory + demo prep |
| 10 | Manipulator Control | ✓ | Pick-and-place robot demo |

There is **no Week 6 or Week 1 lecture**; **no Week 8 tutorial** (only Weeks 3, 4, 5, 7, 9, 10 have tutorials).

## Lecture-to-file map (theory only)

| Week | Lecture deck | Transcript |
| --- | --- | --- |
| 2 | `slides_original/ELEC0129_02_intro.pdf` | `slides_transcribed/ELEC0129_02_intro.md` |
| 2 | `slides_original/ELEC0129_02_spatial.pdf` (Part 1: position, orientation, HTM) | `slides_transcribed/ELEC0129_02_spatial.md` |
| 3 | `slides_original/ELEC0129_03_spatial.pdf` (Part 2: HTM inverse, fixed/Euler angles, angle-axis, Euler parameters) | `slides_transcribed/ELEC0129_03_spatial.md` |
| 4 | `slides_original/ELEC0129_04_forward_kinematics.pdf` (DH parameters, frame attachment, examples) | `slides_transcribed/ELEC0129_04_forward_kinematics.md` |
| 5 | `slides_original/ELEC0129_05_inverse_kinematics.pdf` (existence/uniqueness, geometric, algebraic) | `slides_transcribed/ELEC0129_05_inverse_kinematics.md` |
| 7 | `slides_original/ELEC0129_07_jacobians.pdf` (velocity propagation, direct differentiation, singularities, static forces) | `slides_transcribed/ELEC0129_07_jacobians.md` |
| 8 | `slides_original/ELEC0129_08_trajectory_planning.pdf` (cubic/quintic poly, LSPB) | `slides_transcribed/ELEC0129_08_trajectory_planning.md` |
| 9 | `slides_original/ELEC0129_09_dynamics.pdf` (Newton-Euler in/out iteration, inertia tensor, friction, Cartesian form) | `slides_transcribed/ELEC0129_09_dynamics.md` |
| 10 | `slides_original/ELEC0129_10_control.pdf` (2nd-order systems, control-law partitioning, single-joint, full manipulator) | `slides_transcribed/ELEC0129_10_control.md` |

## Examinability caveats (from Moodle)

- **Week 5, Tasks 5.6-5.9: "6DOF Robot" videos — Optional, *not examinable*.** If equivalent content appears in the Week 5 lecture-notes PDF (`ELEC0129_05_inverse_kinematics.pdf`), it is also out of scope. The exam-relevant inverse-kinematics core is: existence/uniqueness, geometric solution, algebraic solution.
- All "tutorial recording" videos and "Question N" walkthrough videos are labelled *Optional*; the **written** tutorial sheets + solutions in `meta/exercise_sheets/` are the authoritative tutorial materials.
- **20/21 past paper Question 5 — out of scope** (different module, ELEC0140).

## Conventions used in this project

- **Notation** follows John J. Craig, *Introduction to Robotics: Mechanics and Control* (the standard text for this kind of UK robotics module):
  - `${}^{A}P$` — position vector P expressed in frame A.
  - `${}^{A}_{B}R$` — rotation matrix mapping frame-B coordinates to frame-A coordinates.
  - `${}^{A}_{B}T$` — 4×4 homogeneous transformation matrix.
  - Modified DH parameters: `\alpha_{i-1}, a_{i-1}, d_i, \theta_i`.
  - Newton-Euler outward iteration: `${}^{i+1}\omega_{i+1}, {}^{i+1}\dot\omega_{i+1}, {}^{i+1}\dot v_{i+1}, {}^{i+1}\dot v_{C_{i+1}}, {}^{i+1}F_{i+1}, {}^{i+1}N_{i+1}$`; inward: `${}^{i}f_i, {}^{i}n_i, \tau_i$`.
- Math is in LaTeX (`$...$`, `$$...$$`).
- Transcripts are **lossless on information, lossy on presentation** — prefer them over the original PDFs for retrieval, Q&A, and revision.

## Out-of-scope reminder

Anything related to **robot building, RoboDK offline programming, MATLAB implementation code, workshop instructions, demo schedules, or team lists** has been removed from `meta/` per the project's exam-only focus. The corresponding Moodle "Tasks" (e.g. 2.9, 3.22, 4.20, 5.19, 7.18, 8.9, 9.15, 9.20, 10.11, 10.19, 10.20) are not represented here.
