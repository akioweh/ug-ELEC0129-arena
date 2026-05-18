# ELEC0129: Introduction to Robotics — Conceptual Syllabus

This syllabus distils the 8 lecture topics of the module into a single map of what is — and is not — in scope for the final exam. It is organised by topic, not by week, since two weeks each cover Spatial Description (W2 + W3).

**Module context.** UCL EEE Year-2 module, first of the IEP Robotics Minor. Focuses exclusively on **serial articulated robotic manipulators** (industrial robot arms) — not mobile robots, not parallel mechanisms beyond a one-slide mention, not soft robotics, not perception/AI. Notation follows John J. Craig, _Introduction to Robotics: Mechanics and Control_ throughout (modified DH convention; leading-superscript frame notation ${}^{A}P$, ${}^A_B R$, ${}^A_B T$).

**How to use this for exam prep.**

1. The final exam is **40% of the module**, **in-person, closed-book** (a recent change from prior years' open-book online format — older papers carry that caveat).
2. The official **formula sheet** (`materials/Formula_Sheet.md`, source PDF in `meta/formula_sheet/`) is *not* handed out as a separate page in the exam — its formulae appear inline as hints with the questions that need them. Use it as the definitive index of "formulae I don't need to memorise (because they'll be supplied)". **In scope on the sheet:** equivalent angle-axis matrix + Euler-parameter rotation matrix; modified-DH per-link transform; velocity-propagation equations (revolute + prismatic); LSPB blend-time + piecewise trajectory; Newton-Euler outward + inward iteration; Cartesian-space dynamics `M_x, V_x, G_x`; inertia-tensor matrix + integrals. **Not on the sheet (so memorise / be able to derive):** elementary rotation matrices, HTM block-form and inverse, fixed-/Euler-angle recovery, cubic/quintic polynomial coefficients, mass-spring-damper free response, PD / partitioned-control / computed-torque laws, DC-motor model, and **all inverse-kinematics formulae** (the IK and Control sections on the sheet are literally listed as "None").
3. Items marked **(NE)** are explicitly **non-examinable** per Moodle. They appear in the lecture decks but are out of scope.
4. The 20% Robot Offline Programming coursework (RoboDK) and the 40% Group Coursework (Build + Demo) — including all MATLAB implementation tasks and workshop instructions — are **out of scope** for this syllabus and were stripped from `meta/`.

---

## Part I — Foundations

### 1. Manipulator Anatomy & Terminology (W2 intro)

Definitions only; no derivations.

- **Robot classifications:** by appearance (humanoid, animal-like); by application (service, surgical, mobile/AGV, education, military, **industrial — the module's focus**); ISO 8373 industrial-manipulator definition.
- **Industrial applications:** pick-and-place, machine tending, welding, spray painting; the "**Dirty, Dull, Dangerous**" 3D paradigm; contact tasks (assembly, polishing, deburring).
- **Architecture:** **serial vs parallel** manipulators (module covers serial only).
- **Mechanical primitives:** links and joints; **revolute (R) and prismatic (P)** joints; joint axis; **degree of freedom (DOF)**; link/joint numbering (base = 0 to tip = n); common configurations (3R, RRP, 6-DOF anthropomorphic arm).
- **End-effectors:** vacuum gripper, pinching gripper, welding torch.
- **Frames:** RGB axis-colour convention, right-hand rule; the robot-system reference frames **Base, Work-object (Wobj), Tool0, Tool Centre Point (TCP)**.

### 2. Spatial Description & Transformations (W2 + W3)

The mathematical machinery underlying every later topic. Heavily examined.

**Position, orientation, and the homogeneous transformation matrix (W2):**

- Position of a point relative to a frame.
- Position of a rigid body via a body-attached frame.
- **Rotation matrix** derived from the projection of one frame's axes onto another's.
- **Elementary rotations** about the $x$, $y$, $z$ axes ($\mathrm{Rot}(x, \theta)$, etc.).
- **Orthonormality** of rotation matrices; consequently $R^{-1} = R^{T}$.
- Frame description as the pair (rotation, origin position).
- Coordinate-mapping formulas: pure translation; pure rotation; **combined translation and rotation** ${}^{A}P = {}^A_B R \, {}^{B}P + {}^{A}P_{B\text{org}}$.
- The **4×4 homogeneous transformation matrix (HTM)** ${}^A_B T$; **compound transformations** ${}^A_C T = {}^A_B T \, {}^B_C T$ along a kinematic chain.
- **Transform equations:** solving for one unknown HTM in a closed loop.

**Inverse HTM and orientation parameterisations (W3):**

- **Inverse of the HTM** in closed form, exploiting $R^{-1} = R^{T}$ and the resulting expression for the translation block.
- Motivation: 9 rotation-matrix entries vs only 3 independent rotational DOF — alternative 3-parameter and 4-parameter representations.
- **XYZ fixed angles** (roll-pitch-yaw): parameters→matrix; matrix→parameters via $\mathrm{atan2}$; singularity when $\cos\beta = 0$.
- **ZYX Euler angles** (moving-axis convention); equivalence to XYZ-fixed; the existence of **24 distinct fixed/Euler conventions**.
- **Equivalent angle-axis** representation: the **Rodrigues rotation formula**; recovery of $(\hat{k}, \theta)$ from $R$; singularities at $\theta = 0$ and $\theta = \pi$; sign ambiguity.
- **Euler parameters / unit quaternions**: rotation matrix in terms of $(\epsilon_1, \epsilon_2, \epsilon_3, \epsilon_4)$; recovery via the trace; alternative diagonal recipe when the trace is near zero.

---

## Part II — Kinematics

### 3. Forward Kinematics (W4)

Given joint variables, find end-effector pose.

- **Motivation:** mapping joint-space coordinates to Cartesian-space end-effector pose; planar three-link trigonometric solution as a hand-built example.
- **Frame attachment** to robot links; transformation **chaining** ${}^0_N T = \prod_{i=1}^{N} {}^{i-1}_i T$.
- **Denavit-Hartenberg (DH) parameters:** the 4 link/joint parameters — **link length $a_{i-1}$**, **link twist $\alpha_{i-1}$**, **link offset $d_i$**, **joint angle $\theta_i$**; justification of why exactly 4 are needed.
- **Craig modified DH convention** (frame placed at the _proximal_ end of link $i$); the systematic **DH frame-assignment recipe**; DH-table construction.
- **Per-link transformation formula** (from the formula sheet) yielding ${}^{i-1}_i T$ from the 4 DH parameters.
- Base-frame $\lbrace 0 \rbrace$ and end-effector frame $\lbrace N \rbrace$ conventions; end-effector position via a constant body-frame offset; sanity-check configurations.
- **Worked examples** in the deck: 3-link RRR planar, 3-link RPR, 4-link RPRR non-planar, 6-link Stanford Scheinman.

### 4. Inverse Kinematics (W5)

Given desired end-effector pose, find joint variables.

- **Problem statement:** invert ${}^0_N T$; counting equations vs unknowns for a 6-link arm (12 entries in the rotation+translation, but only **6 independent** giving 6 equations in 6 unknowns); distinction between end-effector frame and the last DH frame.
- **Existence of solutions:**
  - **Workspace** definition; **dexterous vs reachable** workspaces.
  - Two-link planar example with equal and unequal link lengths (disc / annulus shapes).
  - **Interior-point vs boundary-point** orientations.
  - **Joint-limit** effects on the reachable workspace.
- **Uniqueness and multiplicity of solutions:**
  - 3-link RRR planar has 2 solutions; PUMA-style 6-DOF has **8 solutions** (elbow up/down × shoulder left/right × wrist flip).
  - Minimum DOF for an arbitrary pose; **redundant manipulators** (>6 DOF).
  - Multi-solution selection criteria: collision avoidance vs choose-closest heuristic.
- **Solution methods:**
  - **Closed-form vs numerical**; under "closed-form": **algebraic** vs **geometric** approaches.
  - **No general algorithm** exists — case-by-case.
- **Geometric solution** of the 3-link RRR planar arm:
  - **Cosine rule** for $\theta_2$ from link lengths and $(x, y)$.
  - $\mathrm{atan2}$ for $\theta_1$.
  - **Sum-of-angles** constraint for $\theta_3$ using desired orientation $\phi$.
  - Both elbow-up and elbow-down cases.
- **Algebraic solution** of the 3-link RRR planar arm:
  - **Square-and-sum** technique to eliminate one variable.
  - **Trigonometric substitution**: introduce $K_1, K_2, r, \gamma$ such that $r\cos(\theta - \gamma) = c$ → $\theta = \gamma \pm \cos^{-1}(c/r)$.
  - Final closed-form $\mathrm{atan2}$ expressions for $\theta_1, \theta_2, \theta_3$.
- **(NE)** Full **PUMA 560 6-DOF worked example** (lecture content corresponding to optional videos 5.6-5.9): isolation of $\theta_1, \theta_3, \theta_2$ via pre-multiplication; $\theta_4$ with the $s_5 = 0$ wrist-singularity degenerate case; $\theta_5, \theta_6$; wrist-flip giving 8 total solutions; the general "isolate one joint variable at a time" recipe. **Per Moodle, explicitly non-examinable.**

### 5. Jacobians (W7)

Velocity and static-force mapping between joint and Cartesian space.

- **The two relationships the Jacobian encodes:** joint velocity $\dot{\boldsymbol{\theta}}$ → Cartesian velocity $(\boldsymbol{v}, \boldsymbol{\omega})$; joint torque $\boldsymbol{\tau}$ ← Cartesian force/moment $\boldsymbol{F}$.
- **Velocity notations:** relative vs absolute angular and linear velocities; **frame of expression** (a velocity can be expressed in any frame; convert with the rotation matrix); the leading-super/sub-script convention $^{A}\omega_{B}$, $^{A}v_{B}$.
- **Velocity propagation algorithm** — link-by-link recursion from base to end-effector:
  - **Rotational velocity propagation** for revolute joints (adds $\dot{\theta}_{i+1} \hat{Z}_{i+1}$) and prismatic joints (no rotational contribution).
  - **Linear velocity propagation** for revolute (tangential $\boldsymbol{\omega} \times \boldsymbol{r}$ only) and prismatic (adds $\dot{d}_{i+1} \hat{Z}_{i+1}$).
  - End-effector velocity from the last link's velocity; transformation to base frame via ${}^0_N R$.
  - Worked example: planar 2-link arm velocity propagation.
- **Direct differentiation method** for the Jacobian:
  - Build forward kinematics ${}^{0}P_{\text{ee}}(\boldsymbol{\theta})$ and differentiate column-wise to get the **linear Jacobian** $J_v$.
  - Build the rotation chain to get the **rotational Jacobian** $J_\omega$.
  - Time-varying nature: $J = J(\boldsymbol{\theta}(t))$.
  - Worked example: 2-link arm Jacobian via direct differentiation.
- **Singularities:**
  - Geometric meaning — a configuration where the end-effector loses one or more directions of instantaneous motion.
  - **Mathematical condition:** $\det(J) = 0$ (square $J$) or rank deficiency (non-square).
  - **Two-link fully-stretched** singularity (workspace-boundary).
  - **Spherical-wrist** singularity (collinear joint axes 4 and 6) — workspace-interior.
  - Mechanical-advantage interpretation: infinite force in lost directions.
- **Static forces:** the duality $\boldsymbol{\tau} = J^{T} \boldsymbol{F}$; deriving joint torques to hold the end-effector against an external force; worked example (2-link arm with a horizontal tip force).

---

## Part III — Motion Generation

### 6. Trajectory Planning (W8)

Generate smooth motion profiles for the manipulator to follow.

- **Trajectory vs path:** trajectory carries a time profile $u(t)$, $\dot{u}(t)$, $\ddot{u}(t)$; the planner produces _reference signals_ consumed downstream by the controller.
- **Joint-space vs Cartesian-space schemes:**
  - Joint-space: plan in $\boldsymbol{\theta}$ directly, low cost, no IK at runtime.
  - Cartesian-space: plan straight-line / shaped Cartesian paths; **inverse kinematics at every sample**; vulnerability to workspace boundaries and singularities mid-trajectory.
- **Straight-line / linear** trajectory: velocity discontinuity at endpoints — motivates the polynomial schemes.
- **Cubic polynomial trajectory:**
  - 4 boundary conditions (position + velocity at start and end) → 4 coefficients.
  - Closed-form coefficients via the boundary-condition matrix.
  - **Acceleration discontinuity** at endpoints.
- **Quintic polynomial trajectory:**
  - 6 BCs (additionally initial/final acceleration) → 6 coefficients.
  - **Continuous acceleration** at endpoints.
- **Linear function with parabolic blends (LSPB):**
  - Symmetric blend regions (constant acceleration) joined by a constant-velocity linear segment.
  - **Derivation of blend duration $t_b$** in terms of acceleration $\ddot{u}$, total time $t_f$, travel $(u_f - u_0)$.
  - **Minimum-acceleration existence bound** $\ddot{u} \ge 4(u_f - u_0) / t_f^2$.
  - Worked example.
- **Multi-segment via-point** trajectories (sketched; full extension typically not pushed deep).

### 7. Manipulator Dynamics (W9)

Equations of motion of the manipulator.

- **Canonical form** in joint space (formula sheet):
  $$\boldsymbol{\tau} = M(\boldsymbol{\theta}) \ddot{\boldsymbol{\theta}} + V(\boldsymbol{\theta}, \dot{\boldsymbol{\theta}}) + G(\boldsymbol{\theta})$$
  with **mass/inertia matrix** $M$ (perceived inertia), **velocity-coupling vector** $V$ (centrifugal + Coriolis), **gravity vector** $G$.
- **Underlying physics:** Newton's second law for the linear motion of a link's centre of mass; **Euler's equation** for the rotational motion ${}^{C}N = {}^{C}I \, {}^{C}\dot{\boldsymbol{\omega}} + {}^{C}\boldsymbol{\omega} \times ({}^{C}I \, {}^{C}\boldsymbol{\omega})$.
- **Newton-Euler recursive algorithm:**
  - **Outward iteration** (base → tip): propagate angular velocity, angular acceleration, linear acceleration, centre-of-mass acceleration; compute per-link inertial force $F_i$ and moment $N_i$. The **"gravity via base acceleration" trick** absorbs gravity into the recursion.
  - **Inward iteration** (tip → base): propagate force $^{i}f_{i}$ and moment $^{i}n_{i}$ across each joint; extract **joint torque** $\tau_i$ (revolute: $\tau_i = {}^{i}n_{i}^{T} \hat{Z}_i$) or **joint force** (prismatic: $\tau_i = {}^{i}f_{i}^{T} \hat{Z}_i$).
- **Two-link planar worked example** through $\tau_1, \tau_2$.
- **Structural decomposition** of the Newton-Euler output into the canonical $M$, $V$, $G$ form.
- **Friction models** added to the joint torque: **viscous** (linear in $\dot{\theta}$), **Coulomb** (sign-of-velocity), combined viscous + Coulomb, **Stribeck** (low-velocity dip).
- **Cartesian-space dynamics:** the analogous form $\boldsymbol{F} = M_{x}(\boldsymbol{\theta}) \ddot{X} + V_{x} + G_{x}$ relating end-effector force to Cartesian acceleration via the Jacobian; rationale (end-effector force control).
- **Inertia tensor:**
  - Definition $I = \int (\|r\|^2 \mathbb{I} - r r^{T}) \rho \, dV$ — diagonal entries are **mass moments of inertia**, off-diagonal are **products of inertia**.
  - **Principal axes** and principal moments (diagonalisation).
  - **Worked example:** rectangular block — inertia tensor about a corner-attached frame.
- **Forward dynamic simulation** via time-stepping (briefly; the MATLAB code is illustrative).

### 8. Manipulator Control (W10)

Closed-loop control to track desired trajectories.

- **Two architectures:** individual-joint control (treat each joint independently as a SISO loop) vs **complete-manipulator** model-based control.
- **Second-order linear system review:**
  - Mass-spring: natural frequency $\omega_n = \sqrt{k/m}$.
  - Mass-spring-damper: characteristic equation $s^2 + 2\zeta\omega_n s + \omega_n^2 = 0$.
  - Three response regimes — **overdamped** ($\zeta > 1$), **critically damped** ($\zeta = 1$), **underdamped** ($\zeta < 1$); determination of integration constants from initial conditions.
- **PD feedback control of the second-order plant:**
  - Pure mass; mass-spring-damper.
  - Gain choice to place the closed-loop poles at a desired $(\omega_n, \zeta)$.
- **Control-law partitioning:**
  - Decompose the controller into a **model-based compensator** ($\alpha, \beta$ — cancels the plant) plus a **servo controller** (PD-style on the error).
  - Closed-loop equation reduces to a unit-mass error system.
  - Equivalence of partitioned control to PD in the closed-loop response.
- **Trajectory following:**
  - Regulation to a non-zero set point.
  - Full trajectory tracking with **feedforward** $\ddot{u}_d, \dot{u}_d$ + PD on $e = u_d - u$.
  - Closed-loop **tracking-error dynamics**.
- **Single-joint model:**
  - **DC-motor + gear-reduction** linkage.
  - Armature electrical equation (torque constant $K_t$, back-EMF constant $K_e$), motor-side and load-side mechanical dynamics, gear-ratio transformation of torque and speed; final load-side reduced joint equation.
- **Single-joint control:** partitioned design applied to the DC-motor joint model; translation of required torque into a **voltage / current command**.
- **Complete-manipulator (MIMO) control:**
  - Coupling and inertia variation across DOFs.
  - **Computed-torque / partitioned MIMO** controller using $M(\boldsymbol{\theta})$, $V(\boldsymbol{\theta}, \dot{\boldsymbol{\theta}})$, $G(\boldsymbol{\theta})$ from the dynamic model.
  - Diagonal servo-gain matrices $K_p$, $K_v$.

---

## Out of scope (explicit)

The following appear in the module ecosystem but are **not in scope for the exam**:

- All **robot-building** material (`Build Physical Robot`, hand-tools lists, team-list lookups).
- All **RoboDK / Offline Programming** content (RoboDK GUI, CAD files, station-file submission).
- All **MATLAB implementation code** (`.m` files: dynamics simulator, control servo loop).
- All **workshop instruction PDFs** (`Read Instructions for X Task [During Workshop]`).
- All **tutorial recordings / optional videos** (the "Q&A walkthrough" media items in every week's "Optional" sub-section).
- **Inverse Kinematics — PUMA 560 6-DOF worked example** (Tasks 5.6-5.9 and the corresponding deck section), explicitly marked non-examinable on Moodle.
- **20/21 past paper Question 5** — that paper is from sister module ELEC0140; Q5 covers material outside ELEC0129.
- **Demo schedules**, IPAC peer reviews, group-report scaffolding.

## What you DO get in the exam room

- Formulae from the official **`meta/formula_sheet/Formula_Sheet.pdf`** (`materials/Formula_Sheet.md` for the markdown version), supplied **inline with each question that needs them** — not as a separate reference page. The set of formulae on the sheet is confirmed unchanged between 23/24 and 25/26. See `materials/LORE.md` for the in-scope / out-of-scope breakdown.
- Closed book, in-person, paper and pencil.
- Past papers for revision: `meta/past_papers/ELEC0129_{2122,2223,2324}_{paper,solutions}.pdf`. Note 21/22 and 22/23 were **online, open-book** so question styles may be shorter / more reference-heavy than the current closed-book format; **23/24 is the most representative**. The 20/21 paper is from ELEC0140 — useful drill, but Q5 is out of scope.
