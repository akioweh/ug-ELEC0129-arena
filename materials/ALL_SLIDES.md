# Week 2 — Introduction to the Course

## Types of Robots

Robots can be classified by **appearance** or by **application**.

### By appearance

- **Humanoid robots** — e.g. Honda ASIMO, TOSY ping-pong-playing robot, Atlas (Boston Dynamics).
- **Animal-like robots** — e.g. Sony AIBO robot dog, snake robots, Jessiko swimming robot, kangaroo robots.

### By application

- **Service robots** — perform services useful to the well-being of humans; explicitly *excludes manufacturing operations*. E.g. robotic vacuum cleaners, robotic waiters, Care-O-Bot (Fraunhofer).
- **Surgical robots** — allow doctors to perform complex procedures with more precision; usually used in minimally invasive surgery. E.g. Da Vinci.
- **Mobile robots / Automated guided vehicles (AGVs)** — move materials around a manufacturing facility or warehouse. E.g. automated forklifts, Amazon warehouse robots.
- **Education robots** — teach language, singing, etc.; help students with autism. E.g. Keepon, NAO.
- **Military robots** — e.g. BigDog, explosive-checking ground robots.
- **Industrial robotic manipulators** — the focus of this course (see below).

## Industrial Robotic Manipulators

### ISO 8373 definition

An industrial robot manipulator is an "automatically controlled, programmable, multipurpose manipulator programmable in three or more axes, which may be either fixed in place or mobile for use in industrial automation applications."

<!-- suspected-source-error: slide 9's quote uses "programmable" twice. The actual ISO 8373:2021 wording is "automatically controlled, **re**programmable, multipurpose manipulator, programmable in three or more axes…" — the first "programmable" should be "reprogrammable". Substantively the same idea (a robot is reconfigurable software, not rebuilt hardware) but the standard's "re-" prefix is its definitional point. Transcribed verbatim from the slide. -->

### Course focus

This course concentrates on **industrial robotic manipulators**. The fundamentals developed here also transfer to other robot types (humanoids, mobile robots, surgical robots, etc.) and may be explored further in research projects.

### Typical applications

Industrial manipulators are widely used for:

- **Pick-and-place** — e.g. rapidly taking drink cartons from a conveyor belt and placing them into a box.
- **Machine tending** — e.g. loading and unloading machines.
- **Welding.**
- **Spray painting.**

These are characteristically **Dirty, Dull and Dangerous (3D) tasks** — tasks for which automation is well-suited.

They are also increasingly being used for **contact-type operations** that require a sense of **touch / force**:

- **Assembly** (e.g. peg-in-hole).
- **Polishing.**
- **Deburring.**

### Two main structural types

- **Serial manipulators** — links and joints arranged in an open kinematic chain (e.g. a standard 6-DOF industrial arm, SCARA).
- **Parallel manipulators** — multiple kinematic chains connect the base to the end-effector in parallel (e.g. DELTA robot).

## Terminology

### Links and joints

Industrial robots are mostly made of **links** connected by **joints**. Each joint has an **axis of joint**. Two joint types are used:

- **Revolute (R)** — allows rotation about the joint axis.
- **Prismatic (P)** — allows translation along the joint axis.

Each joint provides exactly **one degree-of-freedom (DOF)**.

<!-- For reference: an unconstrained rigid body in free 3-D space has 6 DOFs (3 translational + 3 rotational). The slide poses this as a question deferred to the lecture video. -->

### Degree-of-freedom (DOF) of a manipulator

The total number of DOFs of a manipulator equals the number of independent joints. Manipulators are commonly classified by joint sequence:

- **3-DOF examples** (3 joints):
  - **3R robot** — three revolute joints, configured as base/shoulder/elbow with joint angles $\theta_1, \theta_2, \theta_3$ driving rotations about successive axes $z_0, z_1, z_2$.
  - **RRP robot** — two revolute joints ($\theta_1, \theta_2$) followed by a prismatic joint ($d$) along $z_2$.
- **6-DOF examples** (6 joints) — typical anthropomorphic arm with named segments: **trunk**, **shoulder**, **upper arm**, **forearm**, **wrist**, and joint axes $z_1, \ldots, z_6$ (with a base $z_0$). A 6-DOF arm is the minimum required to position and orient the end-effector arbitrarily in 3-D space. <!-- editorial-addition: the "minimum 6 DOF" claim is not on the slide; it's a standard, exam-relevant fact added by the transcriber. -->

<!-- caveat-on-source-figure: slide 19 labels **seven** z-axes ($z_0$ through $z_6$) on a 6-joint arm and places them at unusual anatomical locations ($z_3, z_4$ at the wrist, $z_5, z_6$ at the forearm). This doesn't map cleanly to either modified DH ($z_0, \ldots, z_{n-1}$ are the joint axes) or standard DH ($z_1, \ldots, z_n$). The figure is purely illustrative — no derivation in this lecture depends on it — but a student trying to align it with the Week-4 DH conventions will be confused. Use the Week-4 lecture's frame-assignment recipe as the authoritative source for axis numbering. -->

### Numbering convention

Links and joints are numbered **from the robot base (0) to the tip (n)**:

- Base (fixed) — link 0.
- Joint 1 (between link 0 and link 1), joint 2, joint 3, ..., joint n.
- Link 1, link 2, ..., link n; link n carries the end-effector.

A joint between link $i-1$ and link $i$ is labelled **joint $i$**, and is either revolute (R) or prismatic (P).

### End-effectors

An **end-effector** is the device attached to the end of the robot (link $n$) that interacts with the environment. Examples:

- **Vacuum gripper** — for flat, smooth objects (e.g. glass sheets).
- **Pinching / parallel-jaw gripper** — general-purpose grasping.
- **Welding torch** — process tool, not a gripper.

### Frames (coordinate systems)

A **frame** is a coordinate system used as a reference for describing the **position** and **orientation** of objects. Conventions used throughout the course:

- **RGB colour code** for axes when drawing frames: **Red = X, Green = Y, Blue = Z.**
- All frames are **right-handed** and must obey the **right-hand rule**. The slide depicts the three-finger orthogonal form (thumb = X, index finger = Y, middle finger = Z); the equivalent curl form (point fingers along X, curl toward Y; thumb gives Z) is a useful alternative.

### Special frames on a robotic system

- **Base frame** — attached to the base of the robot; fixed in the world.
- **Work-object frame (Wobj)** — attached to the object being worked on or to the work table.
- **Tool0** — frame at the mechanical tip of the robot (last link / mounting flange), independent of any tool attached.
- **Tool Centre Point (TCP)** — the working point of the end-effector (e.g. the centre between gripper fingers, the tip of a welding torch). The TCP frame moves with the tool.

In a typical task description, the pose of the **TCP relative to the Wobj** is what the controller is asked to achieve, while the controller internally works in terms of **Tool0 relative to the Base frame**.

## Roadmap of Topics Covered in the Course

The course develops the following chain of topics, each building on the previous:

### 1. Description of position and orientation (spatial description)

Location of objects in 3-D space is of fundamental importance in robotics. Objects of interest include parts, tools, the end-effector and the manipulator itself. The course begins with mathematical tools to describe the **position** and **orientation** of frames (vectors, rotation matrices, homogeneous transforms, leading-superscript notation ${}^{A}P$, etc.).

### 2. Forward kinematics

Given the **joint-space** parameters (angles $\theta_i$ for revolute joints, offsets $d_i$ for prismatic joints), determine the **position and orientation** of the end-effector in **Cartesian space**.

$$\text{joint space} \;\longrightarrow\; \text{Cartesian space}$$

### 3. Inverse kinematics

Given the desired **position and orientation of the end-effector** in Cartesian space, find the corresponding **joint-space** parameters.

$$\text{Cartesian space} \;\longrightarrow\; \text{joint space}$$

### 4. Jacobians — velocities and static forces

The **Jacobian** captures two related linear relationships at a given configuration:

- Between **joint velocities** $\dot{\theta}_i$ and **Cartesian velocities** of the end-effector ($\dot{X}, \dot{Y}, \dot{Z}$ and angular).
- Between **joint torques** $\tau_i$ and the **static force** ($F_X, F_Y, F_Z$ and moments) applied by the end-effector on a work surface.

### 5. Manipulator dynamics

How much **torque** is required to **accelerate** the manipulator from rest to a constant velocity, and then back to a stop? Dynamics yields the **equations of motion** of the manipulator, which are used both for simulation and for control design. Notation introduced here involves second derivatives $\ddot{\theta}_i$ and corresponding Cartesian accelerations $\ddot{X}, \ddot{Y}, \ddot{Z}$.

### 6. Trajectory planning

Design of a **time profile** — i.e. the joint or Cartesian variables as functions of time — for the manipulator to follow between specified waypoints.

### 7. Control of the robotic manipulator

Control the **torque of the motors at the joints** so that the manipulator **executes the planned trajectory**.

### 8. Robotic offline programming

Use offline programming software (**RoboDK**) to program industrial robots without occupying the physical hardware.

### 9. Build-your-own-robot project

Students build a small manipulator and use it to perform a pick-and-place task, applying forward kinematics, inverse kinematics and trajectory planning.

<!-- transcription-audit:
- Dropped: slide 1 (title slide — module/lecturer/email boilerplate).
- Dropped: course-administration slides 33-40 (Lectures, Tutorials, Workshops, Schedule table, Assignments with % splits and deadlines, Peer Assessment formulas, Communication / office hours) — per orchestrator instructions these are not transcript-worthy.
- Dropped: slide 41 (Textbooks and References) — Craig "Introduction to Robotics: Mechanics and Control" (3rd or 4th ed., ISBN 9780133489835) is the primary reference and is already noted in the orchestrator's context; Lynch & Park "Modern Robotics" (1st ed., ISBN 9781107156302) is the secondary reference. Retained here in the audit comment for completeness.
- Dropped: slide 42 (Activities — "read up about history of robots", share in Moodle forum) — admin/exhortation, no technical content.
- Dropped: slide 43 (Thank-you / Q&A slide).
- Dropped: slides 44-46 (References list — image attribution URLs).
- Dropped: most decorative photographs of specific robots; product names and example categories retained as text only because the categorical taxonomy is the actual information.
- Dropped: external YouTube links to demo videos of Kangaroo Robot and BigDog (decorative supplementary material).
- Warnings: none — all figures in the technical portion of the deck are reproducible from labels alone (joint-axis diagrams, frame diagrams, robot kinematic schematics). The robot photographs are illustrative, not informational.
- Ambiguities: The slide on 3-DOF examples poses the rhetorical question "Which DOFs do these robots have?" without answering. The transcript states the joint type sequence (3R, RRP) and leaves analysis to the kinematics chapters. The slide also notes that question "what does DOF mean / how many DOFs in free space" is deferred to the lecture video — the standard answer (6 DOFs for a free rigid body) has been inserted as a margin note.
- Suspected source errors (added on verifier pass):
  1. Slide 9 ISO 8373 quote: uses "programmable…programmable" instead of the standard's "reprogrammable…programmable". Inline flag added. Substantive content unaffected.
  2. Slide 19 6-DOF anthropomorphic-arm figure labels seven z-axes for six joints and places them at unusual anatomical locations. Inline `caveat-on-source-figure` flag added directing readers to Week-4 for the authoritative axis-numbering recipe.
- Transcription divergences from source (now annotated):
  - Right-hand rule: the slide depicts the *three-finger orthogonal* form. The transcript originally paraphrased it as the *curl-rule*; now both are mentioned with the slide's form named first.
  - "A 6-DOF arm is the minimum required to position and orient the end-effector arbitrarily in 3-D space": editorial addition not on the slide, now flagged inline. Standard pedagogical fact, exam-relevant.
- Silent stylistic fixes: source "made by links" → "made of links"; "Which DOFs do these robot have" → "do these robots have"; "axis of joint" image label paraphrased as prose.
-->

# Spatial Description and Transformation (Week 2, Part 1)

Robotic manipulation requires moving parts and tools around in space, so we need a way to **describe** the position and orientation of objects, **map** descriptions between coordinate frames, and combine those mappings via **transformation arithmetic**.

## Description of position and orientation

### Position of a point

To describe the position of a point $P$ in space we must first choose a **reference frame** (coordinate system). For example, the same physical point could be described as

- 15 cm from the left edge of a screen, 10 cm from the bottom edge, 0 cm out of the plane of the screen, **or**
- 5 m from the left wall of a classroom, 2 m from the front wall, 1.5 m above the floor.

Both descriptions refer to the same point — they only differ in the frame chosen.

Any point can be described with respect to any coordinate system using a $3 \times 1$ **position vector**. Using the leading-superscript frame notation, the position of $P$ expressed in frame $\{A\}$ is

$$
{}^{A}P = \begin{bmatrix} {}^{A}P_{x} \\ {}^{A}P_{y} \\ {}^{A}P_{z} \end{bmatrix}.
$$

The same physical point can be expressed in multiple frames. For a robot manipulator, the position of point $P$ with respect to the **robot base frame** $\{0\}$ is ${}^{0}P$, and with respect to the **end-effector frame** $\{E\}$ is ${}^{E}P$. These are the same point described in different frames.

### Position of a rigid body

A rigid body does not have a single "position" until we attach a **frame** to it. We pick the **origin** of that body-attached frame as the representative point. If the body is labelled $B$ and its attached frame has origin $P_{BORG}$, then in some reference frame $\{A\}$ the body's position is the position vector

$$
{}^{A}P_{BORG}.
$$

As with a point, the same body has different position vectors when expressed in different frames (e.g. ${}^{0}P_{BORG}$ in the robot base frame and ${}^{E}P_{BORG}$ in the end-effector frame).

### Orientation of a rigid body

Position alone is not enough to locate a rigid body — we also need its **orientation**. Attach a frame $\{B\}$ to the body and consider it relative to a reference frame $\{A\}$. Ignore translation by letting the two origins coincide, and scale the axes of each frame so they are unit vectors $\hat{X}, \hat{Y}, \hat{Z}$.

The orientation of $\{B\}$ with respect to $\{A\}$ is then captured by the **rotation matrix**

$$
{}^{A}_{B}R = \begin{bmatrix}
\hat{X}_{B} \cdot \hat{X}_{A} & \hat{Y}_{B} \cdot \hat{X}_{A} & \hat{Z}_{B} \cdot \hat{X}_{A} \\
\hat{X}_{B} \cdot \hat{Y}_{A} & \hat{Y}_{B} \cdot \hat{Y}_{A} & \hat{Z}_{B} \cdot \hat{Y}_{A} \\
\hat{X}_{B} \cdot \hat{Z}_{A} & \hat{Y}_{B} \cdot \hat{Z}_{A} & \hat{Z}_{B} \cdot \hat{Z}_{A}
\end{bmatrix}.
$$

Each entry is the dot product of a unit axis of $\{B\}$ with a unit axis of $\{A\}$, i.e. the **projection** of a $\{B\}$-axis onto an $\{A\}$-axis. The columns of ${}^{A}_{B}R$ are therefore the unit axes of $\{B\}$ expressed in $\{A\}$.

#### Elementary rotation matrices

Specialising the general formula to a rotation through an angle $\theta$ about a single axis (right-hand rule) gives the three elementary rotation matrices.

Rotation about the $x$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
1 & 0 & 0 \\
0 & \cos\theta & -\sin\theta \\
0 & \sin\theta & \cos\theta
\end{bmatrix}.
$$

Rotation about the $y$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & 0 & \sin\theta \\
0 & 1 & 0 \\
-\sin\theta & 0 & \cos\theta
\end{bmatrix}.
$$

Rotation about the $z$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & -\sin\theta & 0 \\
\sin\theta & \cos\theta & 0 \\
0 & 0 & 1
\end{bmatrix}.
$$

#### Properties of the rotation matrix

The rotation matrix is **orthonormal**:

- Each column (and each row) has unit magnitude.
- Each column is orthogonal (90 degrees) to the other columns, i.e. the dot product between any two distinct columns is zero.

A quick check on the $z$-rotation example above confirms this. As a consequence, the **inverse equals the transpose**:

$$
{}^{B}_{A}R = {}^{A}_{B}R^{-1} = {}^{A}_{B}R^{T}.
$$

### Description of a frame

To completely specify the whereabouts of a tool or object we need **both** position and orientation. A frame $\{B\}$ relative to a reference frame is therefore specified by a rotation matrix **and** the position vector of its origin:

$$
\{B\} = \left\{ {}^{A}_{B}R,\; {}^{A}P_{Borg} \right\}.
$$

For a manipulator the same body can be described relative to different reference frames, e.g.

$$
\{B\} = \left\{ {}^{0}_{B}R,\; {}^{0}P_{Borg} \right\}, \qquad \{B\} = \left\{ {}^{E}_{B}R,\; {}^{E}P_{Borg} \right\}.
$$

## Mapping between frames

**Mapping** answers: given a point $P$ already described in frame $\{B\}$ (so ${}^{B}P$ is known), what is its description ${}^{A}P$ in frame $\{A\}$? The point itself is not changed — only its description is changed.

### Pure translation

If frames $\{A\}$ and $\{B\}$ differ only by a translation (their axes are parallel), then

$$
{}^{A}P = {}^{B}P + {}^{A}P_{Borg}.
$$

**Caution:** vector addition is allowed only if the two frames have the **same orientation**.

### Pure rotation

If the frames share an origin but differ by a rotation, then

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P.
$$

The notation is useful for tracking which frame a quantity is expressed in: the "B" superscript on $P$ and the "B" subscript on $R$ cancel, leaving a quantity expressed in $\{A\}$.

#### Worked example — pure rotation

Frame $\{B\}$ is obtained by rotating $\{A\}$ about the $z$-axis by $30^{\circ}$. In frame $\{B\}$ the point $P$ has coordinates $[1, 1, 0]^{T}$. Find its coordinates in $\{A\}$.

First, build the rotation matrix using the general dot-product form, which for a $z$-rotation gives

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & -\sin\theta & 0 \\
\sin\theta & \cos\theta & 0 \\
0 & 0 & 1
\end{bmatrix}
= \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}.
$$

Then compute

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P
= \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix} 1 \\ 1 \\ 0 \end{bmatrix}
= \begin{bmatrix} 0.366 \\ 1.366 \\ 0 \end{bmatrix}.
$$

This agrees with the geometric picture.

### General mapping: translation and rotation

If $\{A\}$ and $\{B\}$ differ by **both** translation and rotation, first re-express ${}^{B}P$ in a frame whose orientation matches $\{A\}$ (using the rotation matrix), and then add the translation. This gives the compound mapping

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}.
$$

Using the previous numerical example with an added translation ${}^{A}P_{Borg} = [4, 2, 0]^{T}$:

$$
{}^{A}P = \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix} 1 \\ 1 \\ 0 \end{bmatrix}
+ \begin{bmatrix} 4 \\ 2 \\ 0 \end{bmatrix}
= \begin{bmatrix} 4.366 \\ 3.366 \\ 0 \end{bmatrix}.
$$

### Homogeneous transformation matrix

The mixed form ${}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}$ is not very appealing because it is not a single matrix product. We would like to write

$$
{}^{A}P = {}^{A}_{B}T \cdot {}^{B}P,
$$

i.e. apply a single matrix operator. This is achieved by augmenting the $3 \times 1$ position vectors with a trailing $1$ and packing rotation and translation into a $4 \times 4$ block matrix:

$$
\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix}
=
\left[
\begin{array}{ccc|c}
& {}^{A}_{B}R & & {}^{A}P_{Borg} \\
\hline
0 & 0 & 0 & 1
\end{array}
\right]
\begin{bmatrix} {}^{B}P \\ 1 \end{bmatrix}.
$$

The $4 \times 4$ matrix operator is called the **homogeneous transformation** (HTM), denoted ${}^{A}_{B}T$.

For the example above:

$$
\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix}
=
\left[
\begin{array}{ccc|c}
0.866 & -0.5 & 0 & 4 \\
0.5 & 0.866 & 0 & 2 \\
0 & 0 & 1 & 0 \\
\hline
0 & 0 & 0 & 1
\end{array}
\right]
\begin{bmatrix} 1 \\ 1 \\ 0 \\ 1 \end{bmatrix}
= \begin{bmatrix} 4.366 \\ 3.366 \\ 0 \\ 1 \end{bmatrix}.
$$

The trailing $1$ in the result is discarded to recover the ordinary $3 \times 1$ position vector.

## Transformation arithmetic

### Compound transformations

A robot typically has several joints and links, giving a chain of frames. Suppose ${}^{E}P$ is known and the relative transformations along the chain $\{A\} \leftarrow \{B\} \leftarrow \{C\} \leftarrow \{D\} \leftarrow \{E\}$ are all known. What is ${}^{A}P$?

Apply mapping step by step:

$$
{}^{D}P = {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
{}^{C}P = {}^{C}_{D}T \cdot {}^{D}P = {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
{}^{B}P = {}^{B}_{C}T \cdot {}^{C}P = {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
\boxed{{}^{A}P = {}^{A}_{B}T \cdot {}^{B}P = {}^{A}_{B}T \cdot {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P.}
$$

The notation makes the chain easy to track: the "inner" subscripts and superscripts cancel pairwise, leaving the desired $A \leftarrow E$ mapping.

### Transform equations

A common scenario: a robot whose base frame $\{A\}$ is connected to its end-effector $\{E\}$ through known link transforms ${}^{A}_{B}T,\; {}^{B}_{C}T,\; {}^{C}_{D}T,\; {}^{D}_{E}T$, and which is reaching for an object $\{G\}$ that sits on a table $\{F\}$, with the base-to-table and table-to-object transforms ${}^{A}_{F}T,\; {}^{F}_{G}T$ known. What is the end-effector-to-object transform ${}^{E}_{G}T$?

The same compound transform ${}^{A}_{G}T$ can be written along either path:

$$
{}^{A}_{G}T \;=\; {}^{A}_{B}T \cdot {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T \;=\; {}^{A}_{F}T \cdot {}^{F}_{G}T.
$$

Solve for the unknown ${}^{E}_{G}T$ by left-multiplying both sides by inverses, peeling off one transform at a time:

$$
{}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
{}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
{}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{C}_{D}T^{-1} \cdot {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
\boxed{{}^{E}_{G}T = {}^{D}_{E}T^{-1} \cdot {}^{C}_{D}T^{-1} \cdot {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T.}
$$

How to compute the inverse of a $4 \times 4$ HTM efficiently (without doing a generic matrix inversion) is treated in the next lecture.

<!-- transcription-audit:
- Dropped: slide 1 (title slide) — boilerplate.
- Dropped: slide 2 (module schedule table) — administrative, not lecture content.
- Dropped: slides 3, 4, 21, 32 (agenda / content-progress slides) — replaced by the section headings of this transcript.
- Dropped: slide 37 ("Thank you for your attention!") — boilerplate.
- Dropped: decorative manipulator/cube cartoon imagery on slides 5, 9, 10 — illustrative only; the textual content already states the point.
- Dropped: right-hand-rule hand cartoons on slides 16-18 — purely a mnemonic; the sign convention is already encoded in the elementary rotation matrices.
- Dropped: page-number footers throughout.
- Merged: slides 6-8 into a single "Position of a point" sub-section; slides 9-12 into "Position of a rigid body"; slides 13-19 into "Orientation of a rigid body" (with elementary rotations as one sub-block and orthonormality as another); slides 22-23 into "Pure translation"; slides 24-27 into "Pure rotation" with the worked example inline; slides 28-31 into "General mapping" plus the "Homogeneous transformation matrix" sub-section; slides 33-34 into "Compound transformations"; slides 35-36 into "Transform equations".
- Warnings: none — all figures used in the deck were either decorative or reproducible as text/equations.
- Ambiguities: the compact frame description box on slide 20 is written as `{B} = {AR_B, AP_Borg}`; the slide does have a comma (verifier pass corrected this audit note — the original ambiguity claim was overstated). Transcribed as the unambiguous pair `{ ^A_B R, ^A P_Borg }`.
- Suspected source errors: none in substantive math (the elementary rotation matrices, inverse-equals-transpose claim, HTM block structure, compound transform order, and the 30° worked-example arithmetic all check out).
- Silent stylistic fixes applied on verifier pass: source "rotating along the z-axis" → "about the z-axis"; "Frames {B} is" → "Frame {B} is"; "coordinate of P" → "coordinates"; "Homogeneous Transform" rendered as "homogeneous transformation matrix (HTM)". `P_{BORG}` capitalisation in the source drifts between `BORG` and `Borg`; the transcript uses `Borg` consistently. None of these change the technical content.
-->

# Week 3 — Spatial Description and Transformation (Part 2)

ELEC0129 Introduction to Robotics. Dr. Chow Yin Lai.

This deck builds on the Week 2 spatial-description material (point/frame description and the forward $4\times4$ homogeneous transformation matrix). It covers:

1. Closed-form inverse of the homogeneous transformation matrix.
2. Four alternative parameterisations of the $3\times3$ rotation matrix:
   - XYZ fixed angles (roll–pitch–yaw),
   - ZYX Euler angles,
   - Equivalent angle–axis,
   - Euler parameters (unit quaternions).

For each parameterisation the deck gives both directions of the mapping (parameters $\to$ matrix and matrix $\to$ parameters) and notes the singular cases.

---

## Inverse of the Homogeneous Transformation Matrix

### Problem and motivation

Given
$$
{}^{A}_{B}T = \begin{bmatrix} {}^{A}_{B}R & {}^{A}P_{Borg} \\ 0\;0\;0 & 1 \end{bmatrix},
$$
we want a closed form for the inverse ${}^{B}_{A}T = {}^{A}_{B}T^{-1}$. We could brute-force it via determinants/adjuncts or by software, but that ignores structure we already have, namely that the rotation block ${}^{A}_{B}R$ is orthonormal.

### Derivation

A point $P$ written in both frames satisfies
$$
\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix}
= \begin{bmatrix} {}^{A}_{B}R & {}^{A}P_{Borg} \\ 0\;0\;0 & 1 \end{bmatrix}
\begin{bmatrix} {}^{B}P \\ 1 \end{bmatrix},
$$
which reduces to
$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}.
$$

Solving for ${}^{B}P$:
$$
{}^{B}P = {}^{A}_{B}R^{-1}\bigl({}^{A}P - {}^{A}P_{Borg}\bigr).
$$

Because the rotation matrix is orthonormal, ${}^{A}_{B}R^{-1} = {}^{A}_{B}R^{T}$ (established in the Week 2 material), so
$$
{}^{B}P = {}^{A}_{B}R^{T}\bigl({}^{A}P - {}^{A}P_{Borg}\bigr).
$$

### Closed form

$$
\boxed{\;{}^{A}_{B}T^{-1} = {}^{B}_{A}T = \begin{bmatrix} {}^{A}_{B}R^{T} & -\,{}^{A}_{B}R^{T} \cdot {}^{A}P_{Borg} \\ 0\;0\;0 & 1 \end{bmatrix}\;}
$$

The inverse never requires a general $4\times4$ matrix inverse — only a transpose of the rotation block and one matrix–vector product for the translation.

### Worked example

Frame $\{B\}$ is rotated relative to $\{A\}$ about the $z$-axis by $30^{\circ}$, then translated $4$ units along $X_{A}$ and $3$ units along $Y_{A}$.

$$
{}^{A}_{B}T =
\begin{bmatrix}
0.866 & -0.5 & 0 & 4 \\
0.5 & 0.866 & 0 & 3 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}.
$$

Applying the closed form,
$$
{}^{B}_{A}T =
\begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}^{T}
\;\Big|\;
-\begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}^{T}\!
\begin{bmatrix} 4 \\ 3 \\ 0 \end{bmatrix}
=
\begin{bmatrix}
0.866 & 0.5 & 0 & -4.964 \\
-0.5 & 0.866 & 0 & -0.598 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}.
$$

(Easily verified in MATLAB.)

---

## Alternative Representations of Orientation

### Why look beyond the rotation matrix

The $3\times3$ rotation matrix
$$
{}^{A}_{B}R = \begin{bmatrix}
\hat{X}_{B}\!\cdot\!\hat{X}_{A} & \hat{Y}_{B}\!\cdot\!\hat{X}_{A} & \hat{Z}_{B}\!\cdot\!\hat{X}_{A} \\
\hat{X}_{B}\!\cdot\!\hat{Y}_{A} & \hat{Y}_{B}\!\cdot\!\hat{Y}_{A} & \hat{Z}_{B}\!\cdot\!\hat{Y}_{A} \\
\hat{X}_{B}\!\cdot\!\hat{Z}_{A} & \hat{Y}_{B}\!\cdot\!\hat{Z}_{A} & \hat{Z}_{B}\!\cdot\!\hat{Z}_{A}
\end{bmatrix}
$$
is hard to *visualise* — given e.g.
$$
{}^{A}_{B}R = \begin{bmatrix} 0.8373 & -0.4063 & 0.3659 \\ 0.5365 & 0.7397 & -0.4063 \\ -0.1055 & 0.5365 & 0.8373 \end{bmatrix},
$$
sketching the frames is not obvious.

It also has 9 numbers subject to 6 constraints (three unit-length axes, three mutual orthogonalities):
$$
|\hat{X}|=1,\;|\hat{Y}|=1,\;|\hat{Z}|=1,\quad \hat{X}\!\cdot\!\hat{Y}=0,\;\hat{X}\!\cdot\!\hat{Z}=0,\;\hat{Y}\!\cdot\!\hat{Z}=0,
$$
so 3 parameters are sufficient in principle. We seek parameterisations
$$
{}^{A}_{B}R = \begin{bmatrix} f_{11}(a,b,c) & f_{12}(a,b,c) & f_{13}(a,b,c) \\ f_{21}(a,b,c) & f_{22}(a,b,c) & f_{23}(a,b,c) \\ f_{31}(a,b,c) & f_{32}(a,b,c) & f_{33}(a,b,c) \end{bmatrix}
$$
in 3 (or 4) parameters, together with recipes to recover those parameters from a given numeric ${}^{A}_{B}R$.

---

### XYZ Fixed Angles (roll, pitch, yaw)

#### Convention

Starting with $\{B\}$ aligned with $\{A\}$, rotate $\{B\}$ about the **fixed** axes of $\{A\}$:

1. About $X_{A}$ by angle $\gamma$,
2. then about $Y_{A}$ by angle $\beta$,
3. then about $Z_{A}$ by angle $\alpha$.

All three rotations are taken about axes of the **fixed** reference frame $\{A\}$.

#### Parameters $\to$ matrix

The composite rotation is built by multiplying the elementary rotations from right to left (each subsequent fixed-axis rotation pre-multiplies):
$$
{}^{A}_{B}R = R_{Z}(\alpha)\,R_{Y}(\beta)\,R_{X}(\gamma)
$$
$$
= \begin{bmatrix} c\alpha & -s\alpha & 0 \\ s\alpha & c\alpha & 0 \\ 0 & 0 & 1 \end{bmatrix}
\begin{bmatrix} c\beta & 0 & s\beta \\ 0 & 1 & 0 \\ -s\beta & 0 & c\beta \end{bmatrix}
\begin{bmatrix} 1 & 0 & 0 \\ 0 & c\gamma & -s\gamma \\ 0 & s\gamma & c\gamma \end{bmatrix}
$$
$$
\boxed{\;
{}^{A}_{B}R = \begin{bmatrix}
c\alpha\,c\beta & c\alpha\,s\beta\,s\gamma - s\alpha\,c\gamma & c\alpha\,s\beta\,c\gamma + s\alpha\,s\gamma \\
s\alpha\,c\beta & s\alpha\,s\beta\,s\gamma + c\alpha\,c\gamma & s\alpha\,s\beta\,c\gamma - c\alpha\,s\gamma \\
-s\beta & c\beta\,s\gamma & c\beta\,c\gamma
\end{bmatrix}\;}
$$
with $c\cdot \equiv \cos\cdot$ and $s\cdot \equiv \sin\cdot$.

#### Matrix $\to$ parameters

Given a numerical matrix
$$
{}^{A}_{B}R = \begin{bmatrix} r_{11} & r_{12} & r_{13} \\ r_{21} & r_{22} & r_{23} \\ r_{31} & r_{32} & r_{33} \end{bmatrix},
$$
solve element-wise. From $r_{11}^{2} + r_{21}^{2} = c^{2}\beta\,(c^{2}\alpha + s^{2}\alpha) = c^{2}\beta$, hence $c\beta = \sqrt{r_{11}^{2} + r_{21}^{2}}$. Then:
$$
\boxed{\;
\begin{aligned}
\beta &= \operatorname{atan2}\!\Big(-r_{31},\,\sqrt{r_{11}^{2}+r_{21}^{2}}\Big), \\
\alpha &= \operatorname{atan2}\!\Big(\tfrac{r_{21}}{c\beta},\,\tfrac{r_{11}}{c\beta}\Big), \\
\gamma &= \operatorname{atan2}\!\Big(\tfrac{r_{32}}{c\beta},\,\tfrac{r_{33}}{c\beta}\Big).
\end{aligned}\;}
$$

**Singularity.** The recipes for $\alpha$ and $\gamma$ both divide by $c\beta$, so when $c\beta = 0$ (i.e. $\beta = \pm 90^{\circ}$) they fail — only the sum/difference $\alpha\pm\gamma$ is determined. This is the well-known gimbal-lock degeneracy of any three-parameter Euler-/fixed-angle scheme.

<!-- pedagogical-omission: slides 17 and 20 give only the `+√(r₁₁² + r₂₁²)` branch for β. Craig acknowledges the symmetric `−√` branch as a second valid solution — yielding a second (α, β, γ) triple with $\beta' = \pi - \beta$. The slides also state the singularity at $c\beta = 0$ as "we can't solve for α, γ" without noting that the sum (or difference) is still recoverable; the prose above adds that clarification. -->

The same construction applies to the ZYX Euler convention below — it produces the same rotation matrix as XYZ-fixed under the intrinsic-vs-extrinsic equivalence, so identical recovery formulas and identical two-branch / singularity caveats apply.

---

### ZYX Euler Angles

#### Convention

Starting with $\{B\}$ aligned with $\{A\}$, rotate $\{B\}$ about its **own moving** axes:

1. About $Z_{B}$ by angle $\alpha$,
2. then about the **new** $Y_{B}$ by angle $\beta$,
3. then about the **new** $X_{B}$ by angle $\gamma$.

This differs from the fixed-angle convention in that each subsequent rotation is taken about an axis that has already been moved by the previous rotations.

#### Parameters $\to$ matrix

Each moving-frame rotation is post-multiplied (left-to-right in writing order):
$$
{}^{A}_{B}R = R_{Z}(\alpha)\,R_{Y}(\beta)\,R_{X}(\gamma)
$$
$$
= \begin{bmatrix} c\alpha & -s\alpha & 0 \\ s\alpha & c\alpha & 0 \\ 0 & 0 & 1 \end{bmatrix}
\begin{bmatrix} c\beta & 0 & s\beta \\ 0 & 1 & 0 \\ -s\beta & 0 & c\beta \end{bmatrix}
\begin{bmatrix} 1 & 0 & 0 \\ 0 & c\gamma & -s\gamma \\ 0 & s\gamma & c\gamma \end{bmatrix}
$$
$$
{}^{A}_{B}R = \begin{bmatrix}
c\alpha\,c\beta & c\alpha\,s\beta\,s\gamma - s\alpha\,c\gamma & c\alpha\,s\beta\,c\gamma + s\alpha\,s\gamma \\
s\alpha\,c\beta & s\alpha\,s\beta\,s\gamma + c\alpha\,c\gamma & s\alpha\,s\beta\,c\gamma - c\alpha\,s\gamma \\
-s\beta & c\beta\,s\gamma & c\beta\,c\gamma
\end{bmatrix}.
$$

**Key identity.** The ZYX moving-axis result is identical to the XYZ fixed-axis result above: three rotations taken in **the opposite order about fixed axes** give the same matrix as three rotations about moving axes. So a ZYX Euler-angle triple $(\alpha,\beta,\gamma)$ produces exactly the same ${}^{A}_{B}R$ as the XYZ fixed-angle triple $(\alpha,\beta,\gamma)$ used above.

#### Matrix $\to$ parameters

Because the matrix is identical, the recovery formulas are identical:
$$
\begin{aligned}
\beta &= \operatorname{atan2}\!\Big(-r_{31},\,\sqrt{r_{11}^{2}+r_{21}^{2}}\Big), \\
\alpha &= \operatorname{atan2}\!\Big(\tfrac{r_{21}}{c\beta},\,\tfrac{r_{11}}{c\beta}\Big), \\
\gamma &= \operatorname{atan2}\!\Big(\tfrac{r_{32}}{c\beta},\,\tfrac{r_{33}}{c\beta}\Big),
\end{aligned}
$$
with the same singularity at $c\beta = 0$.

---

### Note on Axis-Order Combinations

The pair {XYZ fixed, ZYX Euler} is just one example. In general there are 24 valid three-axis rotation orderings (12 fixed-angle conventions and 12 Euler-angle conventions):

| Fixed Angles | Fixed Angles | Euler Angles | Euler Angles |
|---|---|---|---|
| X-Y-Z | X-Y-X | Z'-Y'-X' | X'-Y'-X' |
| X-Z-Y | X-Z-X | Y'-Z'-X' | X'-Z'-X' |
| Y-X-Z | Y-X-Y | Z'-X'-Y' | Y'-X'-Y' |
| Y-Z-X | Y-Z-Y | X'-Z'-Y' | Y'-Z'-Y' |
| Z-X-Y | Z-X-Z | Y'-X'-Z' | Z'-X'-Z' |
| Z-Y-X | Z-Y-Z | X'-Y'-Z' | Z'-Y'-Z' |

The primed axes in the Euler columns denote moving (intermediate) frames. Each row in the Fixed-Angles columns has a corresponding (reversed-order) Euler convention that produces the same matrix.

---

### Equivalent Angle–Axis Representation

#### Convention

Any rotation can be realised as a single rotation by angle $\theta$ about a single axis $\hat{K}$ passing through the origin (Euler's rotation theorem). To describe $\{B\}$: start aligned with $\{A\}$ and rotate $\{B\}$ about the vector ${}^{A}\hat{K}$ by $\theta$, using the right-hand rule.

#### Parameter count

Let
$$
\hat{K} = \begin{bmatrix} k_{x} & k_{y} & k_{z} \end{bmatrix}^{T}, \quad k_{x}^{2} + k_{y}^{2} + k_{z}^{2} = 1.
$$
The unit-length constraint makes one of the axis components redundant: 2 free parameters for the direction plus the angle $\theta$ gives **3 parameters in total**, but the constraint is enforced naturally rather than implicitly.

#### Parameters $\to$ matrix

With $c\theta \equiv \cos\theta$, $s\theta \equiv \sin\theta$ and $v\theta \equiv 1 - \cos\theta$ (the *versine*),
$$
\boxed{\;
{}^{A}_{B}R = \begin{bmatrix}
k_{x}^{2}\,v\theta + c\theta & k_{x}k_{y}\,v\theta - k_{z}\,s\theta & k_{x}k_{z}\,v\theta + k_{y}\,s\theta \\
k_{x}k_{y}\,v\theta + k_{z}\,s\theta & k_{y}^{2}\,v\theta + c\theta & k_{y}k_{z}\,v\theta - k_{x}\,s\theta \\
k_{x}k_{z}\,v\theta - k_{y}\,s\theta & k_{y}k_{z}\,v\theta + k_{x}\,s\theta & k_{z}^{2}\,v\theta + c\theta
\end{bmatrix}\;}
$$
(the Rodrigues formula).

#### Matrix $\to$ parameters

**Angle.** Summing the diagonal:
$$
r_{11} + r_{22} + r_{33} = (k_{x}^{2}+k_{y}^{2}+k_{z}^{2})\,v\theta + 3c\theta = v\theta + 3c\theta = 1 + 2c\theta.
$$
Hence
$$
\boxed{\;\theta = \arccos\!\frac{r_{11} + r_{22} + r_{33} - 1}{2}\;}
$$

**Axis.** Subtracting off-diagonal pairs (which differ only in the $\pm s\theta$ terms) gives
$$
\boxed{\;
\hat{K} = \frac{1}{2\sin\theta}\begin{bmatrix} r_{32} - r_{23} \\ r_{13} - r_{31} \\ r_{21} - r_{12} \end{bmatrix}\;}
$$

**Notes / singularities.**
- $\arccos$ returns $\theta \in [0,180^{\circ}]$ only.
- The pair $(\hat{K},\theta)$ and $(-\hat{K},-\theta)$ describe the same rotation — the parameterisation is not unique.
- The axis formula fails when $\sin\theta = 0$, i.e. $\theta = 0^{\circ}$ (no rotation, axis arbitrary) or $\theta = 180^{\circ}$ (axis must be extracted from the symmetric part of $R$ instead).
- **Fallback for $\theta = 180^{\circ}$** (not on the slide; Craig §2.8 provides it): at $\theta = \pi$, $R$ is symmetric and one can read $k_i^2 = (r_{ii} + 1)/2$ from the diagonal. The signs of $k_x, k_y, k_z$ are then fixed (up to the overall $(\hat K, \theta) \leftrightarrow (-\hat K, -\theta)$ ambiguity) by the off-diagonal entries $r_{ij} = 2 k_i k_j$ for $i \ne j$.

<!-- pedagogical-omission: slide 27 says the axis formula "fails if θ = 0 or θ = 180°" but does not give a recovery procedure for the θ = π case. The diagonal-based fallback above is the standard Craig recipe; useful if a past-paper question lands at θ = 180°. -->

#### Worked example

A frame $\{B\}$, initially coincident with $\{A\}$, is rotated about ${}^{A}\hat{K} = [0.707,\,0.707,\,0]^{T}$ (passing through the origin) by $30^{\circ}$.

With $c\theta = 0.866$, $s\theta = 0.5$, $v\theta = 1 - 0.866 = 0.134$:
$$
{}^{A}_{B}R = \begin{bmatrix} 0.933 & 0.067 & 0.354 \\ 0.067 & 0.933 & -0.354 \\ -0.354 & 0.354 & 0.866 \end{bmatrix}.
$$

---

### Euler Parameters / Quaternions

#### Motivation

Every 3-parameter scheme has a singularity. Using 4 parameters (with one constraint) eliminates this. Euler parameters (a.k.a. unit quaternions) are the standard such representation.

#### Definition

From the equivalent angle–axis $(\hat{K},\theta)$, define
$$
\boxed{\;
\varepsilon_{1} = k_{x}\sin(\theta/2),\quad
\varepsilon_{2} = k_{y}\sin(\theta/2),\quad
\varepsilon_{3} = k_{z}\sin(\theta/2),\quad
\varepsilon_{4} = \cos(\theta/2).
\;}
$$
They are not independent — they satisfy
$$
\varepsilon_{1}^{2} + \varepsilon_{2}^{2} + \varepsilon_{3}^{2} + \varepsilon_{4}^{2} = 1.
$$

#### Parameters $\to$ matrix

$$
\boxed{\;
{}^{A}_{B}R = \begin{bmatrix}
1 - 2\varepsilon_{2}^{2} - 2\varepsilon_{3}^{2} & 2(\varepsilon_{1}\varepsilon_{2} - \varepsilon_{3}\varepsilon_{4}) & 2(\varepsilon_{1}\varepsilon_{3} + \varepsilon_{2}\varepsilon_{4}) \\
2(\varepsilon_{1}\varepsilon_{2} + \varepsilon_{3}\varepsilon_{4}) & 1 - 2\varepsilon_{1}^{2} - 2\varepsilon_{3}^{2} & 2(\varepsilon_{2}\varepsilon_{3} - \varepsilon_{1}\varepsilon_{4}) \\
2(\varepsilon_{1}\varepsilon_{3} - \varepsilon_{2}\varepsilon_{4}) & 2(\varepsilon_{2}\varepsilon_{3} + \varepsilon_{1}\varepsilon_{4}) & 1 - 2\varepsilon_{1}^{2} - 2\varepsilon_{2}^{2}
\end{bmatrix}\;}
$$

#### Matrix $\to$ parameters

**Primary recipe.** Trace and unit-norm constraint:
$$
r_{11} + r_{22} + r_{33} = 3 - 4(\varepsilon_{1}^{2}+\varepsilon_{2}^{2}+\varepsilon_{3}^{2}) = 3 - 4(1 - \varepsilon_{4}^{2}),
$$
so
$$
\varepsilon_{4} = \tfrac{1}{2}\sqrt{1 + r_{11} + r_{22} + r_{33}}.
$$
Then from the antisymmetric off-diagonals,
$$
\boxed{\;
\varepsilon_{1} = \frac{r_{32}-r_{23}}{4\varepsilon_{4}},\quad
\varepsilon_{2} = \frac{r_{13}-r_{31}}{4\varepsilon_{4}},\quad
\varepsilon_{3} = \frac{r_{21}-r_{12}}{4\varepsilon_{4}}.
\;}
$$

**Edge case.** If $\varepsilon_{4} = 0$ the primary recipe divides by zero. Despite the original promise that Euler parameters always admit a solution, this particular formula breaks down — use the alternative below instead.

**Alternative recipe.** From the diagonal alone, mixing signs:
$$
\boxed{\;
\begin{aligned}
r_{11} - r_{22} - r_{33} = -1 + 4\varepsilon_{1}^{2} &\;\Rightarrow\; \varepsilon_{1} = \tfrac{1}{2}\sqrt{1 + r_{11} - r_{22} - r_{33}}, \\
-r_{11} + r_{22} - r_{33} = -1 + 4\varepsilon_{2}^{2} &\;\Rightarrow\; \varepsilon_{2} = \tfrac{1}{2}\sqrt{1 - r_{11} + r_{22} - r_{33}}, \\
-r_{11} - r_{22} + r_{33} = -1 + 4\varepsilon_{3}^{2} &\;\Rightarrow\; \varepsilon_{3} = \tfrac{1}{2}\sqrt{1 - r_{11} - r_{22} + r_{33}}.
\end{aligned}\;}
$$
This allows $\varepsilon_{1},\varepsilon_{2},\varepsilon_{3}$ to be obtained without first knowing $\varepsilon_{4}$.

---

## Tutorial Questions

### Question 1

A position vector in frame $\{B\}$ is
$$
{}^{B}P = \begin{bmatrix} 10 \\ 20 \\ 30 \end{bmatrix}.
$$
The origin of frame $\{B\}$ is at $[11,\,-3,\,9]$ with respect to frame $\{A\}$. Frame $\{B\}$ is rotated by $30^{\circ}$ about the $z$-axis of frame $\{A\}$.

Find the position vector of the point in frame $\{A\}$, and write down the homogeneous transformation matrix.

### Question 2

Give the value of ${}^{A}_{B}T$ from the geometry shown:
- $\{A\}$ at the left, with $X_{A}$ pointing right (along the floor), $Y_{A}$ pointing into the page (drawn as an arrow toward lower-right in the diagram, the standard perspective projection of a depth axis), and $Z_{A}$ pointing up.
- $\{B\}$ at the right, displaced $3$ units along $X_{A}$, with $X_{B}$ pointing **back** toward $\{A\}$ (i.e. along $-X_{A}$), $Y_{B}$ pointing in the same sense as $Y_{A}$ (the same "into-the-page" arrow), and $Z_{B}$ pointing up (parallel to $Z_{A}$).

<!-- figure-note: Q2 frame orientation comes from a 2.5D sketch; the reader should re-derive from the picture rather than the prose if exam materials clarify. -->

### Question 3

A vector ${}^{A}P$ is rotated about $Z_{A}$ by $\theta$ degrees, then subsequently about $X_{A}$ by $\Phi$ degrees. Give the rotation matrix that accomplishes these rotations in the specified order.

### Question 4

A vector ${}^{A}P$ is rotated about $Y_{A}$ by $30^{\circ}$, then subsequently about $X_{A}$ by $45^{\circ}$. Give the rotation matrix.

### Question 5

A frame $\{B\}$ is originally coincident with $\{A\}$. We first rotate $\{B\}$ about $Z_{B}$ by $\theta$ degrees, then rotate the resulting frame about $X_{B}$ (the new $X_{B}$) by $\Phi$ degrees. Give the rotation matrix that converts vector descriptions from ${}^{B}P$ to ${}^{A}P$.

### Question 6

The axis of a particular rotation is $K = [2,\,1,\,2]$ (not yet a unit vector). The axis passes through the origin. The angle of rotation is $45^{\circ}$. Derive the rotation matrix using the equivalent angle–axis representation.

### Question 7

For the same rotation as in Question 6, derive the rotation matrix using Euler parameters.

### Question 8

A rotation matrix is given by
$$
R = \begin{bmatrix} 0.8373 & -0.4063 & 0.3659 \\ 0.5365 & 0.7397 & -0.4063 \\ -0.1055 & 0.5365 & 0.8373 \end{bmatrix}.
$$
Find all the parameters in terms of:
- X-Y-Z fixed angles,
- Z-Y-X Euler angles,
- equivalent angle–axis representation,
- Euler parameters.

### Question 9

Given
$$
{}^{U}_{A}T = \begin{bmatrix} 0.866 & -0.5 & 0 & 11 \\ 0.5 & 0.866 & 0 & -1 \\ 0 & 0 & 1 & 8 \\ 0 & 0 & 0 & 1 \end{bmatrix},\quad
{}^{B}_{A}T = \begin{bmatrix} 1 & 0 & 0 & 0 \\ 0 & 0.866 & -0.5 & 10 \\ 0 & 0.5 & 0.866 & -20 \\ 0 & 0 & 0 & 1 \end{bmatrix},
$$
$$
{}^{C}_{U}T = \begin{bmatrix} 0.866 & -0.5 & 0 & -3 \\ 0.433 & 0.75 & -0.5 & -3 \\ 0.25 & 0.433 & 0.866 & 3 \\ 0 & 0 & 0 & 1 \end{bmatrix}.
$$
Solve for ${}^{B}_{C}T$.

<!-- transcription-audit:
- Dropped: slide 1 (title slide — institutional boilerplate, instructor/email kept in H1 intro).
- Dropped: slides 2, 3, 9, 34 (agenda / section-marker slides — structure captured by markdown headings).
- Dropped: slide 44 ("Thank you for your attention!").
- Dropped: per-slide visual diagrams on slides 14, 18, 22 — these illustrate the sequential build-up of a multi-step rotation (frame coincident -> after rotation 1 -> after rotation 2 -> after rotation 3). The information is fully captured by the textual step list; the diagrams are pedagogical aids, not new content.
- Merged: slides 4-7 condensed into a single "Inverse of the Homogeneous Transformation Matrix" derivation. Slides 5-6 are a single multi-step derivation. Slide 7 is a summary box restated inline.
- Merged: XYZ-Fixed slides 14-17, ZYX-Euler slides 18-20, Equivalent Angle-Axis slides 22-28, Euler Parameters slides 29-33 each compressed into a single subsection per representation.
- Warnings:
  - Question 2 (slide 36) relies on a 3D frame sketch where axis directions are read off arrowheads. The prose description is my best interpretation; the orchestrator may wish to retain the original figure for unambiguous review.
- Ambiguities:
  - Slide 19 states "multiplying ... from the left to the right" but writes the same product order as slide 15 ("from the right to the left"). Verifier pass confirmed: **both phrasings are correct in context** — slide 15's "right-to-left" describes the temporal order of *fixed-axis* rotations (rightmost factor is applied first, by pre-multiplication), and slide 19's "left-to-right" describes the temporal order of *moving-axis* rotations (leftmost factor is applied first, by post-multiplication). The resulting matrix is the same; this is the standard intrinsic-vs-extrinsic equivalence. Originally flagged as an audit ambiguity, now resolved.
- Suspected source errors: none in the main mathematical content. Pedagogical omissions worth noting (added on verifier pass), each with an inline `<!-- pedagogical-omission -->` flag:
  1. Slides 17 and 20 (XYZ-fixed / ZYX-Euler β recovery): only the `+√` branch is given; Craig also acknowledges the `−√` branch yielding a second valid triple.
  2. Slide 17 / 20 gimbal-lock note: the slide says "can't solve for α, γ" without noting that the sum / difference α ± γ remains recoverable. Transcript adds that clarification.
  3. Slide 27 (angle-axis recovery): the slide notes the formula fails at $\theta = 0, \pi$ but provides no recovery for the $\theta = \pi$ case. Transcript adds Craig's diagonal-based fallback.
- Transcription corrections (verifier pass):
  - Q2 prose description (slide 36): `Y_A` direction corrected from "upper-right" to "lower-right" (matches the slide's depth-axis perspective projection).
- Stylistic normalisations applied silently: source `artan2` → `\operatorname{atan2}`; "arcos" → "arccos".
-->

# Week 4 – Forward Kinematics

ELEC0129 Introduction to Robotics. Dr. Chow Yin Lai.

## Introduction

Kinematics is the study of motion without regard to forces which cause it. Of interest are position, velocity, acceleration, and higher-order derivatives.

This lecture treats position and orientation in static situations:

- Given the **joint-space** parameters (angles for revolute joints, or offsets for prismatic joints), and
- Given the dimensions of the links,
- What is the position and orientation of the end-effector in **Cartesian space**?

### Recall: robot joints

Industrial robots are mostly made of **links** connected by **joints**. Joints are either **revolute (R)** or **prismatic (P)**.

2D schematic symbols:

- Revolute, axis in plane: a small rectangle on the dashed axis line.
- Revolute, axis out of plane: a dot inside a circle.
- Prismatic, axis in plane: a bow-tie (two triangles tip-to-tip) on the dashed axis line.

### A simple planar example (motivation)

Consider a 3-link planar robot with link lengths $L_1, L_2, L_3$ and joint angles $\theta_1, \theta_2, \theta_3$ (each $\theta_i$ measured from the previous link's direction). By trigonometry the end-effector position is

$$
\begin{aligned}
x &= L_1 \cos\theta_1 + L_2 \cos(\theta_1+\theta_2) + L_3 \cos(\theta_1+\theta_2+\theta_3) \\
y &= L_1 \sin\theta_1 + L_2 \sin(\theta_1+\theta_2) + L_3 \sin(\theta_1+\theta_2+\theta_3)
\end{aligned}
$$

and the end-effector orientation is $\theta_{\text{total}} = \theta_1 + \theta_2 + \theta_3$.

For more general (especially non-planar) robots this ad-hoc trigonometric approach does not scale. We need a **systematic method**:

1. Attach frames $\{0\}, \{1\}, \dots, \{n\}$ to the links of the mechanism.
2. Find the link-to-link transforms ${}^{0}_{1}T, {}^{1}_{2}T, \dots, {}^{n-1}_{n}T$.
3. Compose them: ${}^{0}_{n}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdots {}^{n-1}_{n}T$.
4. Map any point ${}^{n}P$ on the end-effector to the base frame via ${}^{0}P = {}^{0}_{n}T \cdot {}^{n}P$.

## Denavit–Hartenberg Parameters

### Why four parameters

A general rigid transformation between two frames has **six** degrees of freedom (three position + three orientation). In a robot manipulator certain quantities are fixed:

- Link geometry fixes the distance between the origins of consecutive frames (e.g. the link length between joints).
- Each joint provides only **1 DOF**.

So the link-to-link transform is constrained, and only **four** parameters are required:

- **Link length** $a_{i-1}$
- **Link twist** $\alpha_{i-1}$
- **Joint angle** $\theta_i$
- **Link offset** $d_i$

These are the **Denavit–Hartenberg (DH) parameters** (Craig's modified convention is used throughout this lecture). The next sections develop these definitions through worked examples.

### Recipe for assigning frames and reading off DH parameters

This recipe is applied identically in every worked example below.

1. **Draw the joint axes.** For a revolute joint, the axis is the rotation axis; for a prismatic joint, it is the translation axis. The direction (arrow) of each axis is arbitrary, but once chosen must be kept fixed.
2. **Draw the mutually perpendicular line between each consecutive pair of axes**, going from the lower-numbered axis to the higher. Special cases:
   - If two axes are **parallel**, the common perpendicular is not unique — pick any convenient one.
   - If two axes **intersect**, the common perpendicular is the line perpendicular to the plane the two axes define, located at their intersection. Its direction (into or out of the plane) is arbitrary.
   - If two axes are **collinear** (the same line), the perpendicular is again arbitrary; place it conveniently.
3. **Attach frames $\{1\}$ through $\{n-1\}$:**
   - $\hat{Z}_i$ points along the $i$-th joint axis.
   - $\hat{X}_i$ points along the mutual perpendicular drawn from axis $i$ to axis $i+1$.
   - $\hat{Y}_i$ completes the right-handed system.
4. **Attach frame $\{0\}$:** set $\{0\}$ equal to $\{1\}$ **when the first joint variable is zero**. (So $\hat{Z}_0$ lies along axis 1, and $\hat{X}_0$ is positioned at the value $\hat{X}_1$ takes when $\theta_1 = 0$ (or $d_1 = 0$ for a prismatic first joint).)
5. **Attach frame $\{n\}$:** $\hat{Z}_n$ along the $n$-th joint axis; $\hat{X}_n$ is chosen so that **when the $n$-th joint variable is zero, $\hat{X}_n$ is aligned with $\hat{X}_{n-1}$**.
6. **Link lengths $a_{i-1}$.** Definition: $a_{i-1}$ = distance from $\hat{Z}_{i-1}$ to $\hat{Z}_i$ measured along $\hat{X}_{i-1}$.
7. **Link twists $\alpha_{i-1}$.** Definition: $\alpha_{i-1}$ = angle from $\hat{Z}_{i-1}$ to $\hat{Z}_i$ measured about $\hat{X}_{i-1}$ (right-hand rule).
8. **Link offsets $d_i$.** Definition: $d_i$ = distance from $\hat{X}_{i-1}$ to $\hat{X}_i$ measured along $\hat{Z}_i$.
9. **Joint angles $\theta_i$.** Definition: $\theta_i$ = angle from $\hat{X}_{i-1}$ to $\hat{X}_i$ measured about $\hat{Z}_i$.
10. **Transfer the results into a DH table** with columns $i, \alpha_{i-1}, a_{i-1}, d_i, \theta_i$.

Note: kinematic analysis always terminates at the last joint axis (frame $\{n\}$). Any final offset from frame $\{n\}$ to the end-effector (e.g. an additional rigid link beyond the last joint) does **not** appear in the DH table; it is handled separately as a constant ${}^{n}P$.

**Variable vs. constant entries.** $a_{i-1}$ and $\alpha_{i-1}$ are always constants. $d_i$ is the joint variable for a prismatic joint, otherwise constant (but not necessarily zero). $\theta_i$ is the joint variable for a revolute joint, otherwise constant (but not necessarily zero).

### Link transformation from DH parameters

Each link-to-link transform decomposes into four elementary sub-transforms:

$$
{}^{i-1}_{i}T \;=\; R_x(\alpha_{i-1}) \cdot D_x(a_{i-1}) \cdot R_z(\theta_i) \cdot D_z(d_i)
$$

Writing out the factors:

$$
{}^{i-1}_{i}T =
\begin{bmatrix}
1 & 0 & 0 & a_{i-1} \\
0 & c\alpha_{i-1} & -s\alpha_{i-1} & 0 \\
0 & s\alpha_{i-1} & c\alpha_{i-1} & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
\cdot
\begin{bmatrix}
c\theta_i & -s\theta_i & 0 & 0 \\
s\theta_i & c\theta_i & 0 & 0 \\
0 & 0 & 1 & d_i \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Multiplying gives the standard Craig-convention link transform:

$$
{}^{i-1}_{i}T =
\begin{bmatrix}
c\theta_i & -s\theta_i & 0 & a_{i-1} \\
c\alpha_{i-1} s\theta_i & c\alpha_{i-1} c\theta_i & -s\alpha_{i-1} & -s\alpha_{i-1} d_i \\
s\alpha_{i-1} s\theta_i & s\alpha_{i-1} c\theta_i & c\alpha_{i-1} & c\alpha_{i-1} d_i \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Here $c\theta_i = \cos\theta_i$, $s\theta_i = \sin\theta_i$, etc. The full chain is

$$
{}^{0}_{n}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdots {}^{n-1}_{n}T,
$$

and the position of any constant body-frame point ${}^{n}P$ in base coordinates is

$$
{}^{0}P = {}^{0}_{n}T \cdot {}^{n}P.
$$

## Example 1: 3-link RRR planar robot

Three revolute joints in a plane with link lengths $L_1, L_2, L_3$ and joint angles $\theta_1, \theta_2, \theta_3$. The three joint axes are parallel (all out of the page).

**Frames.** All three $\hat{Z}_i$ point out of the page. Because the axes are parallel, mutual perpendiculars are placed conveniently along the links themselves. $\hat{X}_1$ lies along link 1 (at $\theta_1=0$), $\hat{X}_2$ along link 2, $\hat{X}_3$ along link 3.

- $\{0\}$ coincides with $\{1\}$ when $\theta_1 = 0$.
- $\{3\}$: $\hat{Z}_3$ along axis 3; $\hat{X}_3$ chosen so that at $\theta_3 = 0$ it aligns with $\hat{X}_2$.

**DH parameters.** Working through the definitions:

- $a_0$: distance from $\hat{Z}_0$ to $\hat{Z}_1$ along $\hat{X}_0 = 0$ (axes 0 and 1 coincide).
- $a_1 = L_1$, $a_2 = L_2$.
- All $\alpha_{i-1} = 0$ (all $\hat{Z}$ axes parallel).
- All $d_i = 0$ (no offset along $\hat{Z}_i$).
- $\theta_1, \theta_2, \theta_3$ are the joint variables.

**DH table.**

| i | $\alpha_{i-1}$ | $a_{i-1}$ | $d_i$ | $\theta_i$ |
|---|----------------|-----------|-------|------------|
| 1 | 0              | 0         | 0     | $\theta_1$ |
| 2 | 0              | $L_1$     | 0     | $\theta_2$ |
| 3 | 0              | $L_2$     | 0     | $\theta_3$ |

Note: $L_3$ does **not** appear in the table — it is the constant offset from frame $\{3\}$ to the end-effector and is handled in the final step.

**Link transforms.**

$$
{}^{0}_{1}T =
\begin{bmatrix}
c\theta_1 & -s\theta_1 & 0 & 0 \\
s\theta_1 & c\theta_1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{1}_{2}T =
\begin{bmatrix}
c\theta_2 & -s\theta_2 & 0 & L_1 \\
s\theta_2 & c\theta_2 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{2}_{3}T =
\begin{bmatrix}
c\theta_3 & -s\theta_3 & 0 & L_2 \\
s\theta_3 & c\theta_3 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

**Chained transform.** With $\theta_{12} = \theta_1 + \theta_2$ and $\theta_{123} = \theta_1 + \theta_2 + \theta_3$,

$$
{}^{0}_{3}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdot {}^{2}_{3}T =
\begin{bmatrix}
c\theta_{123} & -s\theta_{123} & 0 & L_2 c\theta_{12} + L_1 c\theta_1 \\
s\theta_{123} & c\theta_{123} & 0 & L_2 s\theta_{12} + L_1 s\theta_1 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

**End-effector position.** The end-effector sits a constant $L_3$ along $\hat{X}_3$, so ${}^{3}P = [L_3,\ 0,\ 0]^T$ (in homogeneous form $[L_3,\ 0,\ 0,\ 1]^T$). Therefore

$$
{}^{0}P = {}^{0}_{3}T \cdot {}^{3}P =
\begin{bmatrix}
L_3 c\theta_{123} + L_2 c\theta_{12} + L_1 c\theta_1 \\
L_3 s\theta_{123} + L_2 s\theta_{12} + L_1 s\theta_1 \\
0 \\
1
\end{bmatrix}
$$

This matches the trigonometric result given earlier; the systematic DH approach was unnecessary here but generalises to non-planar mechanisms.

## Example 2: 3-link RPR robot

Joint 1 revolute (vertical axis); joint 2 prismatic (horizontal axis, perpendicular to joint 1, intersecting it); joint 3 revolute (collinear with joint 2's translation direction in the shown configuration — axes 2 and 3 are the same line).

**Axis layout (side view).** Axis 1 is vertical; axes 2 and 3 are horizontal and collinear, meeting axis 1 at a common point.

**Frames.**

- Axes 1 and 2 intersect — perpendicular at that intersection, chosen out of the page (this defines $\hat{X}_1$).
- Axes 2 and 3 are collinear — perpendicular arbitrary; placed at joint 2, also out of the page (this defines $\hat{X}_2$, and accordingly $\hat{X}_3$).
- $\hat{Z}_1$ along axis 1 (up); $\hat{Z}_2$ along axis 2 (right); $\hat{Z}_3$ along axis 3 (right).
- $\{0\}$ matches $\{1\}$ when $\theta_1 = 0$.
- $\{3\}$: $\hat{X}_3$ aligned with $\hat{X}_2$ when $\theta_3 = 0$.

**DH parameters.**

- $a_0 = 0$, $a_1 = 0$ (axes 1 and 2 intersect), $a_2 = 0$ (axes 2 and 3 intersect / coincide).
- $\alpha_0 = 0$; $\alpha_1 = -90^\circ$ (rotating $\hat{Z}_1$ vertical down to $\hat{Z}_2$ horizontal about $\hat{X}_1$); $\alpha_2 = 0$.
- $d_1 = 0$; $d_2$ = variable (prismatic joint); $d_3 = 0$.
- $\theta_1$ = variable; $\theta_2 = 0$ (fixed, since joint 2 is prismatic); $\theta_3$ = variable.

**DH table.**

| i | $\alpha_{i-1}$ | $a_{i-1}$ | $d_i$ | $\theta_i$ |
|---|----------------|-----------|-------|------------|
| 1 | 0              | 0         | 0     | $\theta_1$ |
| 2 | $-90^\circ$    | 0         | $d_2$ | 0          |
| 3 | 0              | 0         | 0     | $\theta_3$ |

**Link transforms.**

$$
{}^{0}_{1}T =
\begin{bmatrix}
c\theta_1 & -s\theta_1 & 0 & 0 \\
s\theta_1 & c\theta_1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{1}_{2}T =
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 0 & 1 & d_2 \\
0 & -1 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{2}_{3}T =
\begin{bmatrix}
c\theta_3 & -s\theta_3 & 0 & 0 \\
s\theta_3 & c\theta_3 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

**Chained transform.**

$$
{}^{0}_{3}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdot {}^{2}_{3}T =
\begin{bmatrix}
c\theta_1 c\theta_3 & -c\theta_1 s\theta_3 & -s\theta_1 & -d_2 s\theta_1 \\
s\theta_1 c\theta_3 & -s\theta_1 s\theta_3 & c\theta_1 & d_2 c\theta_1 \\
-s\theta_3 & -c\theta_3 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

**End-effector position.** The end-effector lies at ${}^{3}P = [0,\ 0,\ L_2 + L_3]^T$ (constants $L_2$ and $L_3$ are the rigid offsets from frame $\{3\}$ along its $\hat{Z}_3$). Then

$$
{}^{0}P = {}^{0}_{3}T \cdot {}^{3}P =
\begin{bmatrix}
-(L_2 + L_3 + d_2)\, s\theta_1 \\
(L_2 + L_3 + d_2)\, c\theta_1 \\
0 \\
1
\end{bmatrix}
$$

Sanity check: at $\theta_1 = 0$ the position is $[0,\ L_2+L_3+d_2,\ 0,\ 1]^T$, which makes sense — the end-effector lies along the $\hat{Y}_0$ direction at distance $(L_2+L_3+d_2)$.

## Example 3: 4-link RPRR non-planar robot

Joint 1 revolute (vertical axis); joint 2 prismatic (horizontal axis, perpendicular to and intersecting axis 1, with sliding distance $d_2$); joint 3 revolute (axis perpendicular to the plane of axes 1 and 2, drawn out of the page); joint 4 revolute (horizontal axis parallel to axis 2, offset above it). Geometry sizes $L_2, L_4, L_5$ appear in the schematic; $d_2$ is the prismatic variable.

**Axes.** Axis 1 vertical (going up from the base); axis 2 horizontal (perpendicular to axis 1, drawn going right in the schematic, with prismatic slide $d_2$ along it); axis 3 horizontal (perpendicular to the plane of axes 1 and 2, drawn out of the page); axis 4 horizontal (parallel to axis 2, in the plane of axes 1 and 2).

**Mutual perpendiculars.**

- Axes 1 and 2 are perpendicular and intersect — common perpendicular collapses to the intersection point.
- Axes 2 and 3 are perpendicular and intersect at distance $L_2$ along axis 2 from the prior intersection — the common perpendicular runs along axis 2 itself ($\hat{X}_2$, blue, in the slide).
- Axes 3 and 4 are perpendicular and intersect — common perpendicular pointing up ($\hat{X}_3$, green).

**Frames.**

- $\hat{Z}_1$ up; $\hat{X}_1$ horizontal (toward axis 2).
- $\hat{Z}_2$ along axis 2 (horizontal right); $\hat{X}_2$ horizontal (into the page, perpendicular to both axes 2 and 3).
- $\hat{Z}_3$ along axis 3 (out of page); $\hat{X}_3$ up.
- $\hat{Z}_4$ along axis 4 (horizontal, parallel to $\hat{Z}_2$); $\hat{X}_4 = \hat{X}_3$ when $\theta_4 = 0$.
- $\{0\}$ matches $\{1\}$ at $\theta_1 = 0$.

**DH parameters.**

- $a_0 = 0$; $a_1 = 0$ (axes 1 and 2 intersect); $a_2 = L_2$; $a_3 = 0$ (axes 3 and 4 intersect).
- $\alpha_0 = 0$; $\alpha_1 = -90^\circ$ (vertical $\hat{Z}_1$ rotated by $-90°$ about $\hat{X}_1$ to align with horizontal $\hat{Z}_2$); $\alpha_2 = -90^\circ$ (horizontal $\hat{Z}_2$ rotated to out-of-page $\hat{Z}_3$); $\alpha_3 = 90^\circ$ (out-of-page $\hat{Z}_3$ rotated to horizontal $\hat{Z}_4$).
- $d_1 = 0$; $d_2$ = variable; $d_3 = 0$; $d_4 = 0$.
- $\theta_1$ variable; $\theta_2 = -90^\circ$ (constant, since the prismatic joint's perpendicular frame is oriented relative to the previous frame by a fixed offset); $\theta_3$ variable; $\theta_4$ variable.

**DH table.**

| i | $\alpha_{i-1}$ | $a_{i-1}$ | $d_i$ | $\theta_i$ |
|---|----------------|-----------|-------|------------|
| 1 | 0              | 0         | 0     | $\theta_1$ |
| 2 | $-90^\circ$    | 0         | $d_2$ | $-90^\circ$ |
| 3 | $-90^\circ$    | $L_2$     | 0     | $\theta_3$ |
| 4 | $90^\circ$     | 0         | 0     | $\theta_4$ |

**Link transforms.** Using shorthand $c_i = \cos\theta_i$, $s_i = \sin\theta_i$:

$$
{}^{0}_{1}T =
\begin{bmatrix}
c_1 & -s_1 & 0 & 0 \\
s_1 & c_1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{1}_{2}T =
\begin{bmatrix}
0 & 1 & 0 & 0 \\
0 & 0 & 1 & d_2 \\
1 & 0 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
{}^{2}_{3}T =
\begin{bmatrix}
c_3 & -s_3 & 0 & L_2 \\
0 & 0 & 1 & 0 \\
-s_3 & -c_3 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{3}_{4}T =
\begin{bmatrix}
c_4 & -s_4 & 0 & 0 \\
0 & 0 & -1 & 0 \\
s_4 & c_4 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

**Chained transform.**

$$
{}^{0}_{4}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdot {}^{2}_{3}T \cdot {}^{3}_{4}T =
\begin{bmatrix}
c_1 s_4 + s_1 s_3 c_4 & -s_1 s_3 s_4 + c_1 c_4 & -s_1 c_3 & -d_2 s_1 \\
-c_1 s_3 c_4 + s_1 s_4 & c_1 s_3 s_4 + s_1 c_4 & c_1 c_3 & d_2 c_1 \\
c_3 c_4 & -c_3 s_4 & s_3 & L_2 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

<!-- suspected-source-error: slide 68 writes the (1,1) entry as "$s_1 s_3 s_4 + c_1 s_4$" — the second term should pair $s_3$ with $c_4$, not $s_4$. Reconstructed from the DH table and link-transform matrices on slides 67–68, the correct entry is $c_1 s_4 + s_1 s_3 c_4$. The slide's own sanity check on slide 71 (which sets $\theta_4 = 0$, hence $s_4 = 0$) collapses both forms to $s_1 s_3 \cdot 1$ and $s_1 s_3 \cdot 0$ — both give zero at the chosen configuration, so the typo escapes the lecturer's check. The (2,1) entry on the same slide ($-c_1 s_3 c_4 + s_1 s_4$) is consistent with my recomputation. Fixed in this transcript. -->

**End-effector position.** Based on the figure ${}^{4}P = [-L_4,\ 0,\ L_5]^T$ (homogeneous: append 1). Then

$$
{}^{0}P = {}^{0}_{4}T \cdot {}^{4}P =
\begin{bmatrix}
-L_4(c_1 s_4 + s_1 s_3 c_4) - L_5 s_1 c_3 - d_2 s_1 \\
-L_4(-c_1 s_3 c_4 + s_1 s_4) + L_5 c_1 c_3 + d_2 c_1 \\
-L_4 c_3 c_4 + L_5 s_3 + L_2 \\
1
\end{bmatrix}
$$

**Sanity check** (configuration as drawn): $\theta_1 = 0$, $\theta_2 = -90^\circ$ (constant), $\theta_3 = 0$, $\theta_4 = 0$. Substituting,

$$
{}^{0}P =
\begin{bmatrix}
0 \\
L_5 + d_2 \\
-L_4 + L_2 \\
1
\end{bmatrix}
$$

The end-effector then sits at horizontal offset $(L_5 + d_2)$ along $\hat{Y}_0$ and height $(L_2 - L_4)$ along $\hat{Z}_0$, which matches the schematic.

## Example 4: 6-link Stanford Scheinman robot

Six joints in the order R, R, P, R, R, R (joints 1, 2, 4, 5, 6 revolute; joint 3 prismatic). The schematic shows a Stanford-arm-style manipulator with a vertical base axis, a shoulder pitch, a prismatic extension, and a 3-DOF spherical wrist. Only $L_2$ (an offset between the first two joints) and $L_6$ (end-effector offset along the wrist) appear as link constants in the analysis.

**Axes.**

- Axis 1: vertical (base rotation).
- Axis 2: horizontal (shoulder pitch), perpendicular to and intersecting axis 1.
- Axis 3: prismatic, along the boom; perpendicular to axis 2.
- Axes 3 and 4 are **collinear** (axis 4 is the boom's own roll axis).
- Axis 5: perpendicular to and intersecting axis 4 (wrist pitch).
- Axis 6: perpendicular to and intersecting axis 5 (wrist roll).

**Mutual perpendiculars.**

- Axes 1 and 2 intersect → perpendicular out of plane (green arrow).
- Axes 2 and 3 intersect → perpendicular out of plane (blue arrow).
- Axes 3 and 4 collinear → arbitrary; chosen along axes 4–5 direction (orange arrow).
- Axes 4 and 5 intersect → perpendicular (orange arrow, same direction).
- Axes 5 and 6 intersect → perpendicular (purple arrow).

**Frames.**

- $\hat{Z}_1$ along axis 1 (up); $\hat{X}_1$ along green arrow.
- $\hat{Z}_2$ along axis 2; $\hat{X}_2$ vertical up (blue).
- $\hat{Z}_3$ along axis 3 (boom direction); $\hat{X}_3$ orange (perpendicular to wrist).
- $\hat{Z}_4 = \hat{Z}_3$ direction; $\hat{X}_4$ orange (aligned with $\hat{X}_3$).
- $\hat{Z}_5$ along axis 5 (purple direction); $\hat{X}_5$ perpendicular.
- $\hat{Z}_6$ along axis 6.
- $\{0\}$ matches $\{1\}$ at $\theta_1 = 0$.
- $\{6\}$: $\hat{X}_6$ chosen so that $\hat{X}_6 = \hat{X}_5$ at $\theta_6 = 0$.

**DH parameters.**

- $a_0 = 0$, $a_1 = 0$ (axes 1–2 intersect), $a_2 = 0$ (axes 2–3 intersect), $a_3 = 0$, $a_4 = 0$ (axes 4–5 intersect), $a_5 = 0$ (axes 5–6 intersect).
- $\alpha_0 = 0$, $\alpha_1 = -90^\circ$, $\alpha_2 = -90^\circ$, $\alpha_3 = 0$, $\alpha_4 = 90^\circ$, $\alpha_5 = -90^\circ$.
- $d_1 = 0$, $d_2 = L_2$, $d_3$ = variable (prismatic), $d_4 = 0$, $d_5 = 0$, $d_6 = 0$.
- $\theta_1, \theta_2, \theta_4, \theta_5, \theta_6$ variable; $\theta_3 = 0$.

**DH table.**

| i | $\alpha_{i-1}$ | $a_{i-1}$ | $d_i$ | $\theta_i$ |
|---|----------------|-----------|-------|------------|
| 1 | 0              | 0         | 0     | $\theta_1$ |
| 2 | $-90^\circ$    | 0         | $L_2$ | $\theta_2$ |
| 3 | $-90^\circ$    | 0         | $d_3$ | 0          |
| 4 | 0              | 0         | 0     | $\theta_4$ |
| 5 | $90^\circ$     | 0         | 0     | $\theta_5$ |
| 6 | $-90^\circ$    | 0         | 0     | $\theta_6$ |

**Link transforms** (with $c_i = \cos\theta_i$, $s_i = \sin\theta_i$):

$$
{}^{0}_{1}T =
\begin{bmatrix}
c_1 & -s_1 & 0 & 0 \\
s_1 & c_1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{1}_{2}T =
\begin{bmatrix}
c_2 & -s_2 & 0 & 0 \\
0 & 0 & 1 & L_2 \\
-s_2 & -c_2 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{2}_{3}T =
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 0 & 1 & d_3 \\
0 & -1 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

$$
{}^{3}_{4}T =
\begin{bmatrix}
c_4 & -s_4 & 0 & 0 \\
s_4 & c_4 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{4}_{5}T =
\begin{bmatrix}
c_5 & -s_5 & 0 & 0 \\
0 & 0 & -1 & 0 \\
s_5 & c_5 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix},\quad
{}^{5}_{6}T =
\begin{bmatrix}
c_6 & -s_6 & 0 & 0 \\
0 & 0 & 1 & 0 \\
-s_6 & -c_6 & 0 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Then ${}^{0}_{6}T = \prod_{i=1}^{6} {}^{i-1}_{i}T$. The explicit symbolic expression is large and is omitted here.

**End-effector position.** With ${}^{6}P = [0,\ 0,\ L_6]^T$,

$$
{}^{0}P = {}^{0}_{6}T \cdot \begin{bmatrix} 0 \\ 0 \\ L_6 \\ 1 \end{bmatrix}.
$$

**Sanity check** (configuration as drawn): $\theta_1 = 0$, $\theta_2 = -90^\circ$, $\theta_3 = 0$ (constant), $\theta_4 = 0$, $\theta_5 = 90^\circ$, $\theta_6 = 0$. Substituting yields

$$
{}^{0}P =
\begin{bmatrix}
d_3 \\
L_2 \\
-L_6 \\
1
\end{bmatrix},
$$

which matches the schematic.

## Tutorial Questions

1. **3-link RRR (vertical base, two horizontal links).** A robot with a vertical revolute joint ($\theta_1$), then two coplanar revolute joints ($\theta_2$, $\theta_3$) at the end of horizontal links of lengths $L_1$ and $L_2$. Derive the DH parameters, sketch the frames, calculate the transform matrix, and locate the end-effector.

2. **3-DOF wrist (spherical-style).** A wrist mechanism with three revolute joints $\theta_4$, $\theta_5$ (with an angle $\phi$ labelled between the axes), and $\theta_6$ in series; their axes intersect at a point. Derive the DH parameters, sketch the frames, calculate the transform matrix, and locate the end-effector.

3. **Planar RPR.** A robot with a revolute base ($\theta_1$), a prismatic joint ($d_2$) along the boom, and a revolute wrist ($\theta_3$). Derive the DH parameters, sketch the frames, calculate the transform matrix, and locate the end-effector.

4. **Cartesian RPP-style stage.** A robot with two prismatic translations $d_1, d_2$ (perpendicular horizontal directions) and a vertical prismatic translation $d_3$. Derive the DH parameters, sketch the frames, calculate the transform matrix, and locate the end-effector.

<!-- transcription-audit:
- Dropped: title slide (slide 1) — author/email kept inline as one line; institutional logo dropped.
- Dropped: course schedule table (slide 2) — administrative boilerplate (which week the lecture sits in is already in the file context).
- Dropped: per-section "Content" recap slides (slides 3, 4, 14, 19, 40, 92) — table-of-contents/progress markers, captured by the heading structure.
- Dropped: revolute/prismatic joint recap slides (slides 7, 8) — reduced to a short "Recall" subsection because the same material is covered in the spatial-description deck.
- Dropped: motivational "Link Length (1)/(2)" and "Link Twist" slides (20-22) — they are rhetorical setup ("what is the length of this link?") with the actual definitions given later in the DH recipe.
- Dropped: "Halfway Summary" slide (34) — pure recap of what was just stated.
- Dropped: final "Thank you" slide (97).
- Dropped: per-step illustrations on slides 24-32, 42-51, 57-66, 73-86: the textual recipe captures the procedure, and the per-example summary (DH table + transforms) captures all results. Drawings of the same robot at each step are deduplicated.
- Warnings: Examples 2-4 rely heavily on 3D spatial reasoning from schematics. The DH parameter assignments depend on the conventions and arrow directions the lecturer chose by inspection; the transcript reproduces the values and tables verbatim but the original schematics may help the reader visualise why each α and a takes the value it does. Suggest retaining the original slides 41-91 alongside the transcript for Example 4 (Stanford-Scheinman) in particular.
- Suspected source errors:
  1. Example 3 ⁰₄T (1,1) entry (slide 68): the slide writes "$s_1 s_3 s_4 + c_1 s_4$" — independent recomputation from the deck's own DH table and per-link matrices gives "$c_1 s_4 + s_1 s_3 c_4$" (the second term must pair $s_3$ with $c_4$, not $s_4$). The slide-71 sanity check sets $\theta_4 = 0$, so both forms collapse to zero and the typo is masked. **Fixed in this transcript** at the chained-transform matrix and in the subsequent ⁰P substitution; inline `<!-- suspected-source-error -->` flag records the correction.
- Ambiguities:
  - "Where is the end-effector?" tutorial questions show only the schematic with labels; my prose descriptions of the four tutorial robots are inferred from those schematics plus the file-context hints (RRR, 3-DOF wrist, planar RPR, Cartesian RPP-style). The labels (θ_i, L_i, d_i) are reproduced exactly from the slides.
  - In Example 3, the slide colour-codes mutual perpendiculars (blue, green, orange, purple). Colour-coding is captured in prose as "(blue arrow)", "(green arrow)" etc. so the reader can still follow the lecture's references.
- Earlier audit revision: a transcriber-flagged "suspected source error" claiming α_1 should be 0 (because axis 2 was misread as vertical) was investigated and overturned — axis 2 is in fact horizontal per slides 57–60, and α_1 = −90° is geometrically correct. The Example 3 geometry prose has been rewritten to reflect the actual axis orientations.
-->

# Week 5 — Inverse Kinematics

## Introduction to Inverse Kinematics

The forward kinematics problem (covered in the previous lecture) takes joint-space parameters — angles for revolute joints, offsets for prismatic joints — and computes the position and orientation of the end-effector in Cartesian space.

The **inverse kinematics problem** is the reverse and is substantially more difficult: given a desired position and orientation of the tool in Cartesian space, what set of joint angles is required to achieve it?

### Problem formulation

For a 6-link robot, the homogeneous transform from base to link 6 is a function of all six joint variables:

$$
{}^{0}_{6}T =
\begin{bmatrix}
f_{11}(q_1,\dots,q_6) & f_{12}(q_1,\dots,q_6) & f_{13}(q_1,\dots,q_6) & f_{14}(q_1,\dots,q_6) \\
f_{21}(q_1,\dots,q_6) & f_{22}(q_1,\dots,q_6) & f_{23}(q_1,\dots,q_6) & f_{24}(q_1,\dots,q_6) \\
f_{31}(q_1,\dots,q_6) & f_{32}(q_1,\dots,q_6) & f_{33}(q_1,\dots,q_6) & f_{34}(q_1,\dots,q_6) \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

We want to place the last frame at a desired pose:

$$
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Equating these gives a system of simultaneous (nonlinear) equations from which the joint parameters $q_1,\dots,q_6$ must be obtained.

### Counting equations and unknowns

The right-hand-side matrix contains 12 non-trivial values. Of the 9 rotation entries only 3 are independent (a rotation matrix has 3 degrees of freedom); the position contributes 3 more. There are therefore **6 independent equations** for **6 unknowns** — solvable in principle, but **not always easy to obtain in closed form**.

### End-effector vs. last frame

$p_x, p_y, p_z$ may refer either to the last frame's origin or to the end-effector's position. To target the end-effector, use $f_{14}, f_{24}, f_{34}$ derived for the end-effector via

$$
{}^{0}P = {}^{0}_{n}T \cdot {}^{n}P
$$

**Assumption:** the orientation of the end-effector equals the orientation of the last frame.

---

## Existence and Uniqueness of Solutions

The kinematics equations are nonlinear, so two fundamental questions must be addressed:

1. **Existence** of solutions.
2. **Uniqueness / multiplicities** of solutions.

### Existence — workspace

> If the target point lies within the manipulator's workspace, then there exists at least one set of joint angles that achieves it.

Roughly, the **workspace** is the volume of space the end-effector can reach.

**Example — two-link planar manipulator with $L_1 = L_2$.**
Workspace: a disc of radius $L_1 + L_2$ centred on the base.

**Example — two-link planar manipulator with $L_1 \neq L_2$.**
Workspace: an annulus (ring) with outer radius $L_1 + L_2$ and inner radius $|L_1 - L_2|$.

#### Orientations within the workspace

- For interior points of the workspace, there is usually **more than one** orientation by which the end-effector can reach them.
- For points on the **boundary** of the workspace, there is **only one** orientation.

#### Effect of joint limits

The above assumes joints can rotate a full 360°. In real robots, joint angles are usually limited, with one of two consequences:

- The workspace **volume shrinks**, or
- The **number of possible orientations** per reachable point is reduced.

For example, with the unequal-length two-link manipulator and $\theta_2$ restricted to $0$ to $180°$, the workspace volume is unchanged but only one orientation is available per point.

<!-- The lecture uses the term "workspace" without separating Craig's reachable workspace from dexterous workspace, but the distinction is exactly what the two preceding paragraphs describe: the dexterous workspace is the subset where multiple orientations are achievable; the reachable workspace also includes boundary points where only one orientation is possible. -->

### Multiplicities of solutions

Multiple distinct joint-space configurations may yield the same end-effector pose.

- **3-link RRR planar manipulator:** typically **2** solutions for one given end-effector position and orientation (elbow-up / elbow-down).
- **PUMA robot:** **8** solutions for one position and orientation. The first 4 correspond to four arm configurations; the other 4 are obtained by **flipping the wrist**, applying

$$
\theta_4' = \theta_4 + 180°,\qquad \theta_5' = -\theta_5,\qquad \theta_6' = \theta_6 + 180°
$$

#### Degrees of freedom

- A manipulator needs **at least 6 DOF** to place its end-effector at an arbitrary position with an arbitrary orientation in space.
- If a manipulator has **more than 6 DOF**, there are **infinitely many** solutions — such a manipulator is called a **redundant manipulator** (e.g. elephant-trunk / snake-arm robots).

#### Advantages and disadvantages of multiple solutions

- **Advantage — collision avoidance.** With multiple IK solutions for the same target pose, the planner can pick a configuration that routes around obstacles where another configuration would collide.
- **Disadvantage — choice.** The control system must actively select one solution from many. If there are no obstacles, a reasonable heuristic is to pick the **"closest"** solution — i.e. the one whose joints move least from the current configuration. Example: when moving the end-effector from pose A to pose B, prefer the configuration in which all joints rotate by smaller amounts.

---

## Methods of Solution

Inverse-kinematics solution methods split into:

- **Closed-form** methods
  - **Algebraic**
  - **Geometric**
- **Numerical** methods

Only **closed-form** methods are treated. **There is no general algorithm** for inverse kinematics: solutions must be derived on a **case-by-case** basis. A method that works for one robot will not generally transfer to another.

---

## Geometric Solution

**Worked example — 3-link RRR planar manipulator.**
Link lengths $L_1, L_2, L_3$ with joint angles $\theta_1, \theta_2, \theta_3$ (each measured from the previous link's axis). The desired end-effector pose is given as planar position $(x, y)$ and orientation $\phi$ of the last frame.

### Solve for $\theta_2$ — cosine rule

The triangle formed by the base, the elbow joint and the wrist has sides $L_1$, $L_2$ and $\sqrt{x^2 + y^2}$, with the interior angle at the elbow equal to $180° - \theta_2$. Applying the law of cosines:

$$
x^2 + y^2 = L_1^2 + L_2^2 - 2 L_1 L_2 \cos(180° - \theta_2) = L_1^2 + L_2^2 + 2 L_1 L_2 \cos(\theta_2)
$$

Therefore:

$$
\theta_2 = \arccos\!\left(\frac{x^2 + y^2 - L_1^2 - L_2^2}{2 L_1 L_2}\right)
$$

By symmetry, the "elbow-up" alternative is

$$
\theta_2' = -\theta_2
$$

### Solve for $\theta_1$

Define

$$
\beta = \operatorname{atan2}(y, x)
$$

$$
\cos\psi = \frac{L_1^2 + x^2 + y^2 - L_2^2}{2 L_1 \sqrt{x^2 + y^2}}
$$

where $\psi$ is the interior angle at the base between link 1 and the line from the base to the wrist. Then

$$
\theta_1 = \beta - \psi
$$

and for "elbow-up"

$$
\theta_1' = \beta + \psi
$$

### Solve for $\theta_3$

The three joint angles of a planar revolute chain sum to the final orientation:

$$
\theta_1 + \theta_2 + \theta_3 = \phi \quad\Longrightarrow\quad \theta_3 = \phi - \theta_1 - \theta_2
$$

For elbow-up:

$$
\theta_3' = \phi - \theta_1' - \theta_2'
$$

### Caveat

The geometric trick used for the planar RRR robot will **not** transfer to non-planar manipulators; each robot requires its own derivation.

---

## Algebraic Solution

The geometric approach is awkward for non-planar manipulators. The algebraic approach attempts to solve the simultaneous equations directly. There is still no general algorithm, so derivations remain case-by-case, but **two techniques are broadly useful**:

1. **Square and sum.**
2. **Trigonometric substitution.**

### Worked example — 3-link RRR planar manipulator (algebraic)

The general homogeneous transform from base to frame {3} (derived via forward kinematics, using $c_i = \cos\theta_i$, $s_i = \sin\theta_i$, $c_{12} = \cos(\theta_1+\theta_2)$, $s_{123} = \sin(\theta_1+\theta_2+\theta_3)$, etc.) is

$$
{}^{0}_{3}T =
\begin{bmatrix}
c\theta_{123} & -s\theta_{123} & 0 & L_2 c\theta_{12} + L_1 c\theta_1 \\
s\theta_{123} & c\theta_{123} & 0 & L_2 s\theta_{12} + L_1 s\theta_1 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

The desired pose of the last frame is

$$
\begin{bmatrix}
c\phi & -s\phi & 0 & x \\
s\phi & c\phi & 0 & y \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Equating corresponding entries gives four scalar equations:

$$
\begin{aligned}
c\phi &= c\theta_{123} = \cos(\theta_1 + \theta_2 + \theta_3) \\
s\phi &= s\theta_{123} = \sin(\theta_1 + \theta_2 + \theta_3) \\
x &= L_1 c_1 + L_2 c_{12} \\
y &= L_1 s_1 + L_2 s_{12}
\end{aligned}
$$

**Aim:** solve for $\theta_1, \theta_2, \theta_3$ from known $\phi, x, y$.

#### Step 1 — square and sum to find $\theta_2$

Squaring the $x$ and $y$ equations:

$$
\begin{aligned}
x^2 &= L_1^2 c_1^2 + 2 L_1 L_2 c_1 c_{12} + L_2^2 c_{12}^2 \\
y^2 &= L_1^2 s_1^2 + 2 L_1 L_2 s_1 s_{12} + L_2^2 s_{12}^2 \\
x^2 + y^2 &= L_1^2 + 2 L_1 L_2 (c_1 c_{12} + s_1 s_{12}) + L_2^2
\end{aligned}
$$

Applying the identity $\cos(A - B) = \cos A \cos B + \sin A \sin B$:

$$
c_1 c_{12} + s_1 s_{12} = \cos\!\bigl(\theta_1 - (\theta_1 + \theta_2)\bigr) = \cos(-\theta_2) = \cos(\theta_2)
$$

so

$$
x^2 + y^2 = L_1^2 + 2 L_1 L_2 c_2 + L_2^2
$$

and therefore

$$
c_2 = \frac{x^2 + y^2 - L_1^2 - L_2^2}{2 L_1 L_2}
$$

For a solution to exist, $|c_2| \le 1$. To preserve the **multiplicities** (elbow-up / elbow-down), also write

$$
s_2 = \pm\sqrt{1 - c_2^2}
$$

where the sign selects elbow-up or elbow-down. Then

$$
\theta_2 = \operatorname{atan2}(s_2, c_2)
$$

#### Step 2 — trigonometric substitution to find $\theta_1$

Expand $c_{12}$ and $s_{12}$:

$$
\begin{aligned}
x &= L_1 c_1 + L_2 c_{12} = L_1 c_1 + L_2 c_1 c_2 - L_2 s_1 s_2 = (L_1 + L_2 c_2) c_1 - (L_2 s_2) s_1 \\
y &= L_1 s_1 + L_2 s_{12} = L_1 s_1 + L_2 s_1 c_2 + L_2 c_1 s_2 = (L_1 + L_2 c_2) s_1 + (L_2 s_2) c_1
\end{aligned}
$$

Introduce constants (known because $L_1$, $L_2$, $c_2$, $s_2$ are all known):

$$
K_1 = L_1 + L_2 c_2,\qquad K_2 = L_2 s_2
$$

so that

$$
x = K_1 c_1 - K_2 s_1,\qquad y = K_1 s_1 + K_2 c_1
$$

Now apply **trigonometric substitution**: set

$$
r = +\sqrt{K_1^2 + K_2^2},\qquad \gamma = \operatorname{atan2}(K_2, K_1)
$$

so that $K_1 = r\cos\gamma$ and $K_2 = r\sin\gamma$. Substituting:

$$
\begin{aligned}
x &= r\cos\gamma\, c_1 - r\sin\gamma\, s_1 \\
y &= r\cos\gamma\, s_1 + r\sin\gamma\, c_1
\end{aligned}
$$

Dividing by $r$:

$$
\frac{x}{r} = \cos\gamma\cos\theta_1 - \sin\gamma\sin\theta_1 = \cos(\gamma + \theta_1)
$$

$$
\frac{y}{r} = \cos\gamma\sin\theta_1 + \sin\gamma\cos\theta_1 = \sin(\gamma + \theta_1)
$$

Hence

$$
\gamma + \theta_1 = \operatorname{atan2}\!\left(\frac{y}{r}, \frac{x}{r}\right)
$$

$$
\boxed{\;\theta_1 = \operatorname{atan2}\!\left(\frac{y}{r}, \frac{x}{r}\right) - \gamma = \operatorname{atan2}\!\left(\frac{y}{r}, \frac{x}{r}\right) - \operatorname{atan2}(K_2, K_1)\;}
$$

#### Step 3 — find $\theta_3$

From $c\phi = c\theta_{123}$ and $s\phi = s\theta_{123}$:

$$
\theta_1 + \theta_2 + \theta_3 = \operatorname{atan2}(s\phi, c\phi)
$$

so

$$
\theta_3 = \operatorname{atan2}(s\phi, c\phi) - \theta_1 - \theta_2
$$

---

<!-- not-examinable: 6DOF Robot content per Moodle schedule. The PUMA 560 worked example below is the substantial 6DOF inverse-kinematics derivation flagged as optional / non-examinable. Transcribed in full for completeness; it is **not** part of the 3-technique examinable core. The "General Notes" subsection that distils the isolation technique applies generally and is more broadly useful for revision. -->

## Another Example — PUMA 560 Manipulator (non-examinable)

**The Moodle schedule flags the 6DOF-robot content (Tasks 5.6-5.9) as optional and not examinable.** The 24-step PUMA 560 derivation below is preserved in full for completeness, but is not part of the examinable core.

### Setup

The link parameters (modified DH, Craig convention) for the PUMA 560 manipulator are:

| $i$ | $\alpha_{i-1}$ | $a_{i-1}$ | $d_i$ | $\theta_i$ |
|-----|----------------|-----------|-------|------------|
| 1 | 0 | 0 | 0 | $\theta_1$ |
| 2 | $-90°$ | 0 | 0 | $\theta_2$ |
| 3 | 0 | $a_2$ | $d_3$ | $\theta_3$ |
| 4 | $-90°$ | $a_3$ | $d_4$ | $\theta_4$ |
| 5 | $90°$ | 0 | 0 | $\theta_5$ |
| 6 | $-90°$ | 0 | 0 | $\theta_6$ |

From the DH table, first compute the individual link transforms

$$
{}^{0}_{1}T(\theta_1),\ {}^{1}_{2}T(\theta_2),\ {}^{2}_{3}T(\theta_3),\ {}^{3}_{4}T(\theta_4),\ {}^{4}_{5}T(\theta_5),\ {}^{5}_{6}T(\theta_6)
$$

and the cumulative tail products

$$
{}^{1}_{6}T = {}^{1}_{2}T(\theta_2)\cdot {}^{2}_{3}T(\theta_3)\cdot {}^{3}_{4}T(\theta_4)\cdot {}^{4}_{5}T(\theta_5)\cdot {}^{5}_{6}T(\theta_6)
$$

$$
\vdots
$$

$$
{}^{4}_{6}T = {}^{4}_{5}T(\theta_5)\cdot {}^{5}_{6}T(\theta_6)
$$

along with the inverses of the cumulative head transforms ${}^{0}_{1}T^{-1},\ {}^{0}_{2}T^{-1},\ {}^{0}_{3}T^{-1},\ {}^{0}_{4}T^{-1},\ {}^{0}_{5}T^{-1}$.

The last frame is required to be at

$$
{}^{0}_{6}T^{\text{desired}} =
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

and the task is to compute the six joint angles $\theta_i$.

### Solving for $\theta_1$

Equate the desired and general expressions, then move $\theta_1$ to the left-hand side:

$$
{}^{0}_{6}T^{\text{desired}} = {}^{0}_{1}T(\theta_1)\cdot {}^{1}_{2}T(\theta_2)\cdot {}^{2}_{3}T(\theta_3)\cdot {}^{3}_{4}T(\theta_4)\cdot {}^{4}_{5}T(\theta_5)\cdot {}^{5}_{6}T(\theta_6)
$$

$$
\bigl[{}^{0}_{1}T(\theta_1)\bigr]^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{1}_{2}T(\theta_2)\cdot {}^{2}_{3}T(\theta_3)\cdot {}^{3}_{4}T(\theta_4)\cdot {}^{4}_{5}T(\theta_5)\cdot {}^{5}_{6}T(\theta_6) = {}^{1}_{6}T
$$

Expanding (LHS has $\theta_1$ only; RHS is ${}^{1}_{6}T$ in terms of $\theta_2,\dots,\theta_6$, with several constant entries):

$$
\begin{bmatrix}
c_1 & s_1 & 0 & 0 \\
-s_1 & c_1 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
\cdot
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
=
{}^{1}_{6}T
=
\begin{bmatrix}
* & * & * & a_2 c_2 + a_3 c_{23} - d_4 s_{23} \\
* & * & * & d_3 \\
* & * & * & -a_2 s_2 - a_3 s_{23} - d_4 c_{23} \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Equating the $(2,4)$ element gives an equation involving only $\theta_1$:

$$
-s_1 p_x + c_1 p_y = d_3 \quad\text{(known constant)}
$$

Apply trigonometric substitution. Introduce

$$
\rho = +\sqrt{p_x^2 + p_y^2},\qquad \phi = \operatorname{atan2}(p_y, p_x)
$$

so that $p_x = \rho\cos\phi$ and $p_y = \rho\sin\phi$. Substituting:

$$
-s_1 \cos\phi + c_1 \sin\phi = \frac{d_3}{\rho}
$$

The left-hand side equals $\sin(\phi - \theta_1)$, so

$$
\sin(\phi - \theta_1) = \frac{d_3}{\rho},\qquad \cos(\phi - \theta_1) = \pm\sqrt{1 - \frac{d_3^2}{\rho^2}}
$$

Therefore

$$
\phi - \theta_1 = \operatorname{atan2}\!\left(\frac{d_3}{\rho},\ \pm\sqrt{1 - \frac{d_3^2}{\rho^2}}\right)
$$

$$
\boxed{\;\theta_1 = \phi - \operatorname{atan2}\!\left(\frac{d_3}{\rho},\ \pm\sqrt{1 - \frac{d_3^2}{\rho^2}}\right) = \operatorname{atan2}(p_y, p_x) - \operatorname{atan2}\!\left(d_3,\ \pm\sqrt{p_x^2 + p_y^2 - d_3^2}\right)\;}
$$

The $\pm$ gives **two possible values** of $\theta_1$.

### Solving for $\theta_3$

From the same matrix equation, equate the $(1,4)$, $(2,4)$ and $(3,4)$ elements:

$$
\begin{aligned}
c_1 p_x + s_1 p_y &= a_2 c_2 + a_3 c_{23} - d_4 s_{23} \\
-s_1 p_x + c_1 p_y &= d_3 \\
-p_z &= a_2 s_2 + a_3 s_{23} + d_4 c_{23}
\end{aligned}
$$

Applying **square and sum** to the three equations (squaring each side and adding):

$$
p_x^2 + p_y^2 + p_z^2 = a_2^2 + a_3^2 + d_3^2 + d_4^2 + 2 a_2 a_3 c_3 - 2 d_4 a_2 s_3
$$

Rearranging:

$$
a_3 c_3 - d_4 s_3 = \frac{p_x^2 + p_y^2 + p_z^2 - a_2^2 - a_3^2 - d_3^2 - d_4^2}{2 a_2} \equiv K\quad\text{(known constant)}
$$

Apply trigonometric substitution again. Introduce

$$
\tau = +\sqrt{a_3^2 + d_4^2},\qquad \xi = \operatorname{atan2}(a_3, d_4)
$$

so that $a_3 = \tau\sin\xi$ and $d_4 = \tau\cos\xi$. Substituting:

$$
\tau\sin\xi\, c_3 - \tau\cos\xi\, s_3 = \tau\sin(\xi - \theta_3) = K
$$

Hence

$$
\sin(\xi - \theta_3) = \frac{K}{\tau},\qquad \cos(\xi - \theta_3) = \pm\sqrt{1 - \frac{K^2}{\tau^2}}
$$

$$
\xi - \theta_3 = \operatorname{atan2}\!\left(\frac{K}{\tau},\ \pm\sqrt{1 - \frac{K^2}{\tau^2}}\right)
$$

$$
\boxed{\;\theta_3 = \xi - \operatorname{atan2}\!\left(\frac{K}{\tau},\ \pm\sqrt{1 - \frac{K^2}{\tau^2}}\right) = \operatorname{atan2}(a_3, d_4) - \operatorname{atan2}\!\left(K,\ \pm\sqrt{a_3^2 + d_4^2 - K^2}\right)\;}
$$

<!-- suspected-source-error: slide 56 displays the boxed result as "$\theta_3 = \xi = \operatorname{atan2}(a_3, d_4) - \operatorname{atan2}(K, \pm\sqrt{a_3^2 + d_4^2 - K^2})$" — the literal "$= \xi =$" in the middle is a typo (should be "$− \operatorname{atan2}(K/\tau, \pm\sqrt{1−K^2/\tau^2}) =$"). The line immediately above ($\xi - \theta_3 = \operatorname{atan2}(K/\tau, \pm\sqrt{1−K^2/\tau^2})$) gives the right relation, so the final RHS is right; only the middle of the boxed display is broken. Silently corrected in the transcript. Note: this is in the non-examinable PUMA 560 section. -->

Two solutions for $\theta_3$.

### Solving for $\theta_2$

With $\theta_1$ and $\theta_3$ known, isolate $\theta_2$ by pre-multiplying the desired transform by $\bigl[{}^{0}_{1}T(\theta_1)\cdot {}^{1}_{2}T(\theta_2)\cdot {}^{2}_{3}T(\theta_3)\bigr]^{-1}$:

$$
{}^{0}_{3}T^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{3}_{6}T
$$

Expanding:

$$
\begin{bmatrix}
c_1 c_{23} & s_1 c_{23} & -s_{23} & -a_2 c_3 \\
-c_1 s_{23} & -s_1 s_{23} & -c_{23} & a_2 s_3 \\
-s_1 & c_1 & 0 & -d_3 \\
0 & 0 & 0 & 1
\end{bmatrix}
\cdot
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
=
\begin{bmatrix}
* & * & -c_4 s_5 & a_3 \\
* & * & * & d_4 \\
* & * & s_4 s_5 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Equating the $(1,4)$ and $(2,4)$ elements:

$$
\begin{aligned}
c_1 c_{23} p_x + s_1 c_{23} p_y - s_{23} p_z - a_2 c_3 &= a_3 \\
-c_1 s_{23} p_x - s_1 s_{23} p_y - c_{23} p_z + a_2 s_3 &= d_4
\end{aligned}
$$

Only $\theta_2$ is unknown. Rewrite as

$$
\begin{aligned}
c_{23}(c_1 p_x + s_1 p_y) - s_{23} p_z &= a_3 + a_2 c_3 \\
-s_{23}(c_1 p_x + s_1 p_y) - c_{23} p_z &= d_4 - a_2 s_3
\end{aligned}
$$

and apply trigonometric substitution. The final answer is

$$
\theta_2 = \operatorname{atan2}(c_1 p_x + s_1 p_y,\ p_z) - \operatorname{atan2}\!\left(\frac{a_3 + a_2 c_3}{\sqrt{(c_1 p_x + s_1 p_y)^2 + p_z^2}},\ \frac{a_2 s_3 - d_4}{\sqrt{(c_1 p_x + s_1 p_y)^2 + p_z^2}}\right) - \theta_3
$$

There are **4 solutions**, one for each $\pm$ combination of $\theta_1$ and $\theta_3$. (Once $\theta_1$ and $\theta_3$ are fixed, $\theta_2$ is determined.)

### Solving for $\theta_4$

From the same equation ${}^{0}_{3}T^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{3}_{6}T$, equate the $(1,3)$ and $(3,3)$ elements:

$$
\begin{aligned}
c_1 c_{23} r_{13} + s_1 c_{23} r_{23} - s_{23} r_{33} &= -c_4 s_5 \\
-s_1 r_{13} + c_1 r_{23} &= s_4 s_5
\end{aligned}
$$

If $s_5 \neq 0$:

$$
\begin{aligned}
c_4 &= \frac{-c_1 c_{23} r_{13} - s_1 c_{23} r_{23} + s_{23} r_{33}}{s_5} \\
s_4 &= \frac{-s_1 r_{13} + c_1 r_{23}}{s_5}
\end{aligned}
$$

giving

$$
\theta_4 = \operatorname{atan2}\!\left(-s_1 r_{13} + c_1 r_{23},\ -c_1 c_{23} r_{13} - s_1 c_{23} r_{23} + s_{23} r_{33}\right)
$$

Again 4 solutions per the $\pm$ combinations of $\theta_1$ and $\theta_3$ ($\theta_2$ is no longer independent).

#### Degenerate case $s_5 = 0$

If $s_5 = 0$ (i.e. $\theta_5 = 0$), axes 4 and 6 line up, and joints 4 and 6 jointly determine the final orientation. Only $(\theta_4 + \theta_6)$ or $(\theta_4 - \theta_6)$ can be solved; one of them is chosen arbitrarily and the other computed afterwards.

<!-- pedagogical-hedge: slide 62 writes "(θ_4 + θ_6) or (θ_4 − θ_6)" as if both options were independently valid. In fact, for the PUMA's specific DH (α_4 = −90°, α_5 = +90°), the cumulative rotation from frame {3} to frame {5} at θ_5 = 0 aligns Ẑ_4 and Ẑ_6 with a definite sign — the correct combination is uniquely fixed by the convention. Transcribed verbatim because this section is non-examinable; the disjunction is harmless but misleading. -->

### Solving for $\theta_5$

With $\theta_1,\dots,\theta_4$ known, isolate $\theta_5$ via

$$
\bigl[{}^{0}_{1}T(\theta_1)\cdot {}^{1}_{2}T(\theta_2)\cdot {}^{2}_{3}T(\theta_3)\cdot {}^{3}_{4}T(\theta_4)\bigr]^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{4}_{5}T(\theta_5)\cdot {}^{5}_{6}T(\theta_6) = {}^{4}_{6}T
$$

or equivalently

$$
{}^{0}_{4}T^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{4}_{6}T
$$

Expanding (LHS has $\theta_1,\dots,\theta_4$ known; RHS is ${}^{4}_{6}T$):

$$
\begin{bmatrix}
c_1 c_{23} c_4 + s_1 s_4 & s_1 c_{23} c_4 - c_1 s_4 & -s_{23} c_4 & -a_2 c_3 c_4 + d_3 s_4 - a_3 c_4 \\
-c_1 c_{23} s_4 + s_1 c_4 & -s_1 c_{23} s_4 - c_1 c_4 & s_{23} s_4 & a_2 c_3 s_4 + d_3 c_4 + a_3 s_4 \\
-c_1 s_{23} & -s_1 s_{23} & -c_{23} & a_2 s_3 - d_4 \\
0 & 0 & 0 & 1
\end{bmatrix}
\cdot
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
=
\begin{bmatrix}
* & * & -s_5 & 0 \\
* & * & * & 0 \\
* & * & c_5 & 0 \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

Equating the $(1,3)$ and $(3,3)$ elements:

$$
\begin{aligned}
-(c_1 c_{23} c_4 + s_1 s_4) r_{13} - (s_1 c_{23} c_4 - c_1 s_4) r_{23} + s_{23} c_4 r_{33} &= s_5 \\
-(c_1 s_{23}) r_{13} + (-s_1 s_{23}) r_{23} - c_{23} r_{33} &= c_5
\end{aligned}
$$

Hence

$$
\theta_5 = \operatorname{atan2}(s_5, c_5)
$$

4 solutions (the same 4 $\pm$-combinations of $\theta_1$ and $\theta_3$; $\theta_2$ and $\theta_4$ are not independent).

### Solving for $\theta_6$

Apply the same isolation technique once more:

$$
{}^{0}_{5}T^{-1}\cdot {}^{0}_{6}T^{\text{desired}} = {}^{5}_{6}T
$$

After expansion, the $(1,3)$ and $(3,3)$ elements yield (in terms of all previously computed angles and the desired $r_{ij}$):

$$
\begin{aligned}
\bigl((c_1 c_{23} c_4 + s_1 s_4) c_5 - c_1 s_{23} s_5\bigr) r_{11} + \bigl((s_1 c_{23} c_4 - c_1 s_4) c_5 - s_1 s_{23} s_5\bigr) r_{21} + (-s_{23} c_4 c_5) r_{31} &= c_6 \\
-(c_1 c_{23} s_4 - s_1 c_4) r_{11} - (s_1 c_{23} s_4 + c_1 c_4) r_{21} + (s_{23} s_4) r_{31} &= s_6
\end{aligned}
$$

Therefore

$$
\theta_6 = \operatorname{atan2}(s_6, c_6)
$$

4 solutions (the 4 $\pm$-combinations of $\theta_1$ and $\theta_3$; $\theta_2$, $\theta_4$ and $\theta_5$ are not independent).

### Wrist-flip alternatives — full 8 solutions

Apart from the four $\theta$ solutions just computed, **four more** can be obtained by **flipping the wrist** of the manipulator:

$$
\theta_4' = \theta_4 + 180°,\qquad \theta_5' = -\theta_5,\qquad \theta_6' = \theta_6 + 180°
$$

giving the full 8 inverse-kinematics solutions for the PUMA 560.

### General technique — isolating one joint at a time

The PUMA 560 example illustrates one widely-useful algebraic technique: **isolate one joint variable at a time**. The pattern is:

1. Pre-multiply the desired transform by the inverse of the cumulative head transform up to the joint already solved:

$$
\bigl[{}^{0}_{1}T(q_1)\bigr]^{-1}\cdot {}^{0}_{n}T^{\text{desired}} = {}^{1}_{2}T(q_2)\cdot {}^{2}_{3}T(q_3)\cdots {}^{n-2}_{n-1}T(q_{n-1})\cdot {}^{n-1}_{n}T(q_n) = {}^{1}_{n}T
$$

2. Look for **constant elements** in ${}^{1}_{n}T$ (entries that do not depend on the remaining joint variables).
3. Equate corresponding entries $\text{LHS}(i,j) = \text{RHS}(i,j)$ and solve for $q_1$.
4. Isolate the next variable:

$$
\bigl[{}^{1}_{2}T(q_2)\bigr]^{-1}\cdot \bigl[{}^{0}_{1}T(q_1)\bigr]^{-1}\cdot {}^{0}_{n}T^{\text{desired}} = {}^{2}_{3}T(q_3)\cdots {}^{n-2}_{n-1}T(q_{n-1})\cdot {}^{n-1}_{n}T(q_n) = {}^{2}_{n}T
$$

5. Look for constant elements in ${}^{2}_{n}T$, equate, solve for $q_2$.
6. Repeat until $q_n$ is found.

This isolation pattern, together with the square-and-sum and trigonometric-substitution techniques, is the workhorse of closed-form algebraic inverse kinematics.

---

## Tutorial Questions

### Question 1 — Workspace sketch

Sketch the workspace of the manipulator with $L_1 = 15$, $L_2 = 10$, $L_3 = 3$. The manipulator has a vertical revolute first joint $\theta_1$, then a horizontal first link of length $L_1$, then a revolute joint $\theta_2$, then link $L_2$, then a revolute joint $\theta_3$, then link $L_3$.

### Question 2 — Inverse kinematics for a 3-link manipulator

For the same 3-link manipulator shown in Question 1, the last frame is required to be at

$$
\begin{bmatrix}
r_{11} & r_{12} & r_{13} & p_x \\
r_{21} & r_{22} & r_{23} & p_y \\
r_{31} & r_{32} & r_{33} & p_z \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

What should the joint angles be?

### Question 3 — Solution multiplicity

Given a desired position and orientation of the hand of a three-link planar rotary-jointed manipulator, there are two possible solutions. If one more rotational joint is added (while the arm is still planar), how many solutions are there?

### Question 4 — Reachable workspace with joint limits

For the two-link planar robot with $L_1 = 2 L_2$ (i.e. the second link is half as long as the first) and joint range limits

$$
0 < \theta_1 < 180°,\qquad -90° < \theta_2 < 180°
$$

sketch the approximate reachable workspace of the tip of link 2.

### Question 5 — 4R manipulator, find $\theta_3$ (i)

For the 4R manipulator shown (Craig DH convention), the non-zero link parameters are

$$
a_1 = 1,\quad \alpha_2 = 45°,\quad d_3 = \sqrt{2},\quad a_3 = \sqrt{2}
$$

The reference configuration is $\theta_1 = 0$, $\theta_2 = 90°$, $\theta_3 = -90°$, $\theta_4 = 0°$. Each joint has limits $\pm 180°$. Find all values of $\theta_3$ such that

$$
{}^{0}P_{4\,\text{ORG}} = \begin{bmatrix} 1.1 & 1.5 & 1.707 \end{bmatrix}^{T}
$$

### Question 6 — 4R manipulator, find $\theta_3$ (ii)

For the 4R manipulator shown (different geometry from Q5), the non-zero link parameters are

$$
\alpha_1 = -90°,\quad \alpha_2 = 45°,\quad d_2 = 1,\quad d_3 = 1,\quad a_3 = 1
$$

The reference configuration is $\theta_1 = 0$, $\theta_2 = 0°$, $\theta_3 = 90°$, $\theta_4 = 0°$. Each joint has limits $\pm 180°$. Find all values of $\theta_3$ such that

$$
{}^{0}P_{4\,\text{ORG}} = \begin{bmatrix} 0 & 1 & 1.414 \end{bmatrix}^{T}
$$

<!-- transcription-audit:
- Dropped: title slide (slide 1) — boilerplate (lecturer/course identifiers).
- Dropped: schedule slide (slide 2) — module-schedule boilerplate; not lecture content.
- Dropped: section-break "Content" recap slides (slides 3, 4, 10, 22, 30, 44, 70) — agenda/TOC slides; structure is already captured by the heading hierarchy.
- Dropped: "Thank you for your attention" slide (slide 77) — boilerplate.
- Dropped: photograph of the Elephant Trunk Robotic Arm on slide 19 — decorative; the textual point about "redundant manipulator" is preserved. Wikipedia source link omitted as decorative attribution.
- Dropped: PUMA-robot stick-figure illustrations on slide 18 — they illustrate the existence of 4 solutions but carry no information beyond what is stated textually (8 solutions; wrist-flip relations).
- Dropped: PUMA 560 photograph/CAD on slide 45 — decorative; the DH table is preserved.
- Workspace illustrations on slides 13-16, 20-21, 71-74 — described in prose; the disc/annulus geometry is fully captured textually.
- Multi-slide structures dissolved: the "Existence of Solution (1-5)" block, "Multiplicities of Solutions (1-5)" block, "Geometric Solution (1-5)" block, "Algebraic Solution (1-13)" block and "PUMA 560 Manipulator (1-24)" block were each treated as one logical section rather than transcribed slide-by-slide.
- 6DOF non-examinable flag applied to the entire PUMA 560 worked example (slides 45-69) per Moodle schedule. The "General Notes" subsection (slide 69) describing the isolation technique was retained inside the non-examinable section because it is presented there in context; learners may still find it useful conceptually.
- Warnings: Question 5 and Question 6 figures (slides 75, 76) are PUMA-style frame-and-axis line drawings indicating where each ${}^{i}\hat{Z}$, ${}^{i}\hat{X}$ axis points, with distance annotations (e.g. "1", "$\sqrt{2}$", "$45°$") between joint origins. The text-only transcription captures the symbolic DH parameters and the target ${}^{0}P_{4\,\text{ORG}}$ but loses the spatial axis-orientation cues a student would normally use to verify the parameter table. Recommend retaining the original PDF for these two questions when revising.
- Ambiguities: Slide 28 writes "$\theta_3' = \phi - \theta_1' - \theta_2'$" with primes on every angle for the elbow-up case. Slide 26 separately defines $\theta_2' = -\theta_2$ and slide 27 gives $\theta_1' = \beta + \psi$, so the elbow-up $\theta_3$ should indeed substitute the primed $\theta_1, \theta_2$; transcribed as written.
- Suspected source errors (added on verifier pass):
  1. Slide 56 boxed θ₃ result contains a literal "$\theta_3 = \xi = \operatorname{atan2}(\ldots)$" — the middle "$= \xi =$" is a typo. Silently corrected to the proper "$\xi - \operatorname{atan2}(\ldots)$" form; inline flag near the boxed equation. (Non-examinable PUMA section.)
  2. Slide 62 phrases the s₅ = 0 degeneracy as "$(\theta_4 + \theta_6)$ or $(\theta_4 - \theta_6)$" — the disjunction is misleading; the correct combination is uniquely determined by the DH convention. Transcribed verbatim with an inline `pedagogical-hedge` flag. (Non-examinable PUMA section.)
- Pedagogical omissions worth knowing for the examinable core:
  - Slides 41–42 and 51–52, 56 apply the trig substitution `r cos(θ − γ) = c` but don't restate the existence condition `|c| ≤ r`. The `±` in `±√(1 − …²)` implicitly enforces it; just be aware.
  - Slides 25–28 implicitly use the convention that each θ_i is measured from the previous link's axis (Craig modified DH). This is needed for the relation `θ₁+θ₂+θ₃ = φ`. The slides don't say so explicitly.
- Stylistic normalisations applied silently throughout: source `artan2` rendered as `\operatorname{atan2}`; minor English typos cleaned up.
-->

# Week 07 — Jacobians

## Introduction

This lecture studies two related relationships in a manipulator:

- The relationship between **joint velocity** $\dot{\boldsymbol{\theta}}$ and **Cartesian velocity** of the end-effector.
- The relationship between **joint torques** $\boldsymbol{\tau}$ and the **static force** $\boldsymbol{F}$ applied by the end-effector onto a work surface.

Both relationships are mediated by the same matrix — the Jacobian $J(\boldsymbol{\theta})$.

## Velocity Propagation

A robotic manipulator is a chain of bodies, each capable of moving relative to its neighbour. The velocity of each link can therefore be computed in order, link by link, starting from the base:

> Velocity of link $i+1$ = Velocity of link $i$ + new components due to joint $i+1$.

### Notation — rotational velocities

A clear distinction is made between **relative** and **absolute** angular velocity:

- ${}^{i}\Omega_{i+1}$ — angular speed of joint $i+1$ with respect to joint $i$ (i.e. **relative**), expressed in frame $\{i\}$. It is a $3\times 1$ vector whose direction is the instantaneous axis of rotation and whose magnitude is the speed.
- $\omega_i, \omega_{i+1}$ — **absolute** angular velocities, i.e. with respect to the fixed base frame $\{0\}$.

The reference frame in which an angular velocity is **expressed** can be changed using the rotation matrix:

$${}^{i+1}\Omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\Omega_{i+1}$$

Changing the frame of expression to $\{0\}$ gives the absolute velocity:

$${}^{0}\Omega_{i+1} = {}^{0}_{i}R \cdot {}^{i}\Omega_{i+1} \triangleq \omega_{i+1}$$

The absolute velocity can itself be re-expressed in any frame, e.g.

$${}^{i+1}\omega_{i+1} = {}^{i+1}\left({}^{0}\Omega_{i+1}\right) = {}^{i+1}_{0}R \cdot {}^{0}\Omega_{i+1} = {}^{i+1}_{0}R \cdot \omega_{i+1}$$

### Notation — linear velocities

Analogously for linear velocity:

- ${}^{i}V_{i+1}$ — linear speed of joint $i+1$ with respect to joint $i$ ("relative"), expressed in frame $\{i\}$.
- $v_i, v_{i+1}$ — "absolute" velocities with respect to frame $\{0\}$.

If ${}^{i}P_{i+1}$ is the position of frame $\{i+1\}$ in frame $\{i\}$, the relative linear velocity is

$$\frac{d}{dt}\left({}^{i}P_{i+1}\right) = {}^{i}V_{i+1}$$

Frame-of-expression change works the same way:

$${}^{i+1}V_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}V_{i+1}$$

$${}^{0}V_{i+1} = {}^{0}_{i}R \cdot {}^{i}V_{i+1} \triangleq v_{i+1}$$

$${}^{i+1}v_{i+1} = {}^{i+1}\left({}^{0}V_{i+1}\right) = {}^{i+1}_{0}R \cdot {}^{0}V_{i+1} = {}^{i+1}_{0}R \cdot v_{i+1}$$

### Derivation — propagation from link $i$ to link $i+1$

Given the velocities of frame $\{i\}$ and the joint variable $i+1$, we derive the velocities of frame $\{i+1\}$ as the sum of:

- Velocities of the previous frame $\{i\}$, plus
- New velocity contributed by joint $i+1$.

#### Rotational velocity propagation

**Revolute joint $i+1$.** Angular velocities can be added when expressed in a common frame. Working in frame $\{i\}$:

$${}^{i}\omega_{i+1} = {}^{i}\omega_i + {}^{i}_{i+1}R \cdot {}^{i+1}\Omega_{i+1} = {}^{i}\omega_i + {}^{i}_{i+1}R \cdot \dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}$$

where $\dot{\theta}_{i+1}$ is a scalar and ${}^{i+1}\hat{Z}_{i+1} = [0 \; 0 \; 1]^T$, so

$$\dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1} = [0 \; 0 \; \dot{\theta}_{i+1}]^T.$$

Premultiplying by ${}^{i+1}_{i}R$ to lift the left-hand-side superscript to $i+1$ (useful for the iteration):

$$\boxed{\,{}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i + \dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\,}$$

**Prismatic joint $i+1$.** No new rotational velocity is contributed by the joint, so

$$\boxed{\,{}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i\,}$$

#### Linear velocity propagation

**Revolute joint $i+1$.** There is no relative translation between the two frames, but the rotation of link $i$ creates a tangential linear velocity at frame $\{i+1\}$:

$${}^{i}v_{i+1} = {}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}$$

Premultiplying by ${}^{i+1}_{i}R$:

$$\boxed{\,{}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \left({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\right)\,}$$

**Prismatic joint $i+1$.** The propagated linear velocity is the sum of the tangential contribution (caused by rotation of the previous joint) and the radial contribution from the prismatic joint $i+1$:

$$\boxed{\,{}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \left({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\right) + \dot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\,}$$

### Algorithm summary

Start with ${}^{0}\omega_0$ and ${}^{0}v_0$ (typically zero for a fixed base). Calculate recursively from link to link:

**Revolute joints:**

$${}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i + \dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}$$

$${}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \left({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\right)$$

**Prismatic joints:**

$${}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i$$

$${}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \left({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\right) + \dot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}$$

Continue until ${}^{n}\omega_n$ and ${}^{n}v_n$.

**End-effector.** If the end-effector $\{e\}$ is of interest, propagate one more step from the last link $\{n\}$. The end-effector is usually fixed to the last link with no relative motion, so:

$${}^{n}\omega_e = {}^{n}\omega_n$$

$${}^{n}v_e = {}^{n}v_n + {}^{n}\omega_n \times {}^{n}P_e$$

**Transform to base frame.** Finally, express in $\{0\}$:

$${}^{0}v_n = {}^{0}_{n}R \cdot {}^{n}v_n, \qquad {}^{0}\omega_n = {}^{0}_{n}R \cdot {}^{n}\omega_n$$

$${}^{0}v_e = {}^{0}_{n}R \cdot {}^{n}v_e, \qquad {}^{0}\omega_e = {}^{0}_{n}R \cdot {}^{n}\omega_e$$

### Worked example — planar 2-link robot

A planar two-link robot with revolute joints $\theta_1, \theta_2$ and link lengths $L_1, L_2$. Frame $\{0\}$ at the base, frame $\{1\}$ at joint 2, frame $\{2\}$ at the tip. The transforms are

$${}^{0}_{1}T = \begin{bmatrix} c_1 & -s_1 & 0 & 0 \\ s_1 & c_1 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 1 \end{bmatrix}, \qquad {}^{1}_{2}T = \begin{bmatrix} c_2 & -s_2 & 0 & L_1 \\ s_2 & c_2 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 1 \end{bmatrix}$$

(notation: $c_i = \cos\theta_i$, $s_i = \sin\theta_i$, $c_{12} = \cos(\theta_1+\theta_2)$, etc.)

Starting from ${}^{0}\omega_0 = \mathbf{0}$, ${}^{0}v_0 = \mathbf{0}$:

**Frame {1}:**

$${}^{1}\omega_1 = {}^{1}_{0}R \cdot {}^{0}\omega_0 + \dot{\theta}_1 \cdot {}^{1}\hat{Z}_1 = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 \end{bmatrix}$$

$${}^{1}v_1 = {}^{1}_{0}R \cdot \left({}^{0}v_0 + {}^{0}\omega_0 \times {}^{0}P_1\right) = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}$$

(Frame $\{1\}$ has no linear velocity — it is at the base pivot.)

**Frame {2}:**

$${}^{2}\omega_2 = {}^{2}_{1}R \cdot {}^{1}\omega_1 + \dot{\theta}_2 \cdot {}^{2}\hat{Z}_2 = {}^{1}_{2}R^T \cdot {}^{1}\omega_1 + \dot{\theta}_2 \cdot {}^{2}\hat{Z}_2 = \begin{bmatrix} c_2 & s_2 & 0 \\ -s_2 & c_2 & 0 \\ 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 \end{bmatrix} + \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_2 \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 + \dot{\theta}_2 \end{bmatrix}$$

$${}^{2}v_2 = {}^{2}_{1}R \cdot \left({}^{1}v_1 + {}^{1}\omega_1 \times {}^{1}P_2\right) = \begin{bmatrix} c_2 & s_2 & 0 \\ -s_2 & c_2 & 0 \\ 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 0 \\ L_1\dot{\theta}_1 \\ 0 \end{bmatrix} = \begin{bmatrix} L_1 s_2 \dot{\theta}_1 \\ L_1 c_2 \dot{\theta}_1 \\ 0 \end{bmatrix}$$

where ${}^{1}\omega_1 \times {}^{1}P_2$ was evaluated by determinant expansion with ${}^{1}P_2 = [L_1, 0, 0]^T$.

**End-effector** (taking ${}^{2}P_e = [L_2, 0, 0]^T$):

$${}^{2}\omega_e = {}^{2}\omega_2 = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 + \dot{\theta}_2 \end{bmatrix}$$

$${}^{2}v_e = {}^{2}v_2 + {}^{2}\omega_2 \times {}^{2}P_e = \begin{bmatrix} L_1 s_2 \dot{\theta}_1 \\ L_1 c_2 \dot{\theta}_1 + L_2(\dot{\theta}_1 + \dot{\theta}_2) \\ 0 \end{bmatrix}$$

**Transform back to base frame:**

$${}^{0}\omega_e = {}^{0}_{2}R \cdot {}^{2}\omega_e = \begin{bmatrix} c_{12} & -s_{12} & 0 \\ s_{12} & c_{12} & 0 \\ 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 + \dot{\theta}_2 \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 + \dot{\theta}_2 \end{bmatrix}$$

$${}^{0}v_e = {}^{0}_{2}R \cdot {}^{2}v_e = \begin{bmatrix} -L_1 s_1 \dot{\theta}_1 - L_2 s_{12}(\dot{\theta}_1 + \dot{\theta}_2) \\ L_1 c_1 \dot{\theta}_1 + L_2 c_{12}(\dot{\theta}_1 + \dot{\theta}_2) \\ 0 \end{bmatrix}$$

**Matrix form.** Collecting these:

$$\begin{bmatrix} ({}^{0}\omega_e)_x \\ ({}^{0}\omega_e)_y \\ ({}^{0}\omega_e)_z \end{bmatrix} = \begin{bmatrix} 0 & 0 \\ 0 & 0 \\ 1 & 1 \end{bmatrix} \begin{bmatrix} \dot{\theta}_1 \\ \dot{\theta}_2 \end{bmatrix} \qquad \Longrightarrow \qquad {}^{0}\omega_e = J_\omega \dot{\boldsymbol{\theta}}$$

$$\begin{bmatrix} \dot{x} \\ \dot{y} \\ \dot{z} \end{bmatrix} = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \\ 0 & 0 \end{bmatrix} \begin{bmatrix} \dot{\theta}_1 \\ \dot{\theta}_2 \end{bmatrix} \qquad \Longrightarrow \qquad \dot{\boldsymbol{x}} = J_v \dot{\boldsymbol{\theta}}$$

$J_\omega$ and $J_v$ are the rotational and linear Jacobians respectively.

<!-- suspected-source-error: slide 34 labels the third row of the rotational Jacobian block as $({}^{0}\omega_e)_y$ instead of $({}^{0}\omega_e)_z$. Transcribed as $z$ in the prose since the surrounding equations make it unambiguous that the third component is the z-component. -->

## Linear Jacobian via Direct Differentiation

An alternative, more systematic way to derive the linear Jacobian: differentiate the forward kinematics directly.

### Generalised joint coordinate

Introduce a generalised joint coordinate that uniformly handles revolute and prismatic joints:

$$q_i = \begin{cases} \theta_i & \text{if revolute} \\ d_i & \text{if prismatic} \end{cases}$$

The joint coordinate vector is $\boldsymbol{q} = [q_1, q_2, \dots, q_n]$. The Cartesian position of the tip is

$$\begin{bmatrix} x \\ y \\ z \end{bmatrix} = \begin{bmatrix} f_x(\boldsymbol{q}) \\ f_y(\boldsymbol{q}) \\ f_z(\boldsymbol{q}) \end{bmatrix}$$

### Differentiation

Differentiating with the chain rule:

$$\dot{x} = \frac{\partial f_x}{\partial q_1}\dot{q}_1 + \cdots + \frac{\partial f_x}{\partial q_n}\dot{q}_n$$

$$\dot{y} = \frac{\partial f_y}{\partial q_1}\dot{q}_1 + \cdots + \frac{\partial f_y}{\partial q_n}\dot{q}_n$$

$$\dot{z} = \frac{\partial f_z}{\partial q_1}\dot{q}_1 + \cdots + \frac{\partial f_z}{\partial q_n}\dot{q}_n$$

In matrix form:

$$\begin{bmatrix} \dot{x} \\ \dot{y} \\ \dot{z} \end{bmatrix} = \begin{bmatrix} \dfrac{\partial f_x}{\partial q_1} & \dfrac{\partial f_x}{\partial q_2} & \cdots & \dfrac{\partial f_x}{\partial q_n} \\[6pt] \dfrac{\partial f_y}{\partial q_1} & \dfrac{\partial f_y}{\partial q_2} & \cdots & \dfrac{\partial f_y}{\partial q_n} \\[6pt] \dfrac{\partial f_z}{\partial q_1} & \dfrac{\partial f_z}{\partial q_2} & \cdots & \dfrac{\partial f_z}{\partial q_n} \end{bmatrix} \begin{bmatrix} \dot{q}_1 \\ \dot{q}_2 \\ \vdots \\ \dot{q}_n \end{bmatrix}$$

i.e.

$$\dot{\boldsymbol{x}} = J_v(\boldsymbol{q})\,\dot{\boldsymbol{q}}$$

where $J_v$ is the linear Jacobian matrix.

### Remarks

- This direct-differentiation method gives the **linear** velocity Jacobian only. It is not directly suitable for rotational velocity (orientation cannot in general be obtained by differentiating a position-like quantity).
- The Jacobian is **linear in $\dot{\boldsymbol{q}}$ but time-varying in $\boldsymbol{q}$**. The relationship between joint rates and tip velocity is linear, but only instantaneously: at the next instant, $J(\boldsymbol{q})$ has changed.

### 2-link robot via direct differentiation

For the same 2-link example, the tip position from forward kinematics is

$${}^{0}P = \begin{bmatrix} L_1 c_1 + L_2 c_{12} \\ L_1 s_1 + L_2 s_{12} \\ 0 \end{bmatrix}$$

Differentiating with respect to time:

$$\frac{d}{dt}\left({}^{0}P\right) = \begin{bmatrix} (-L_1 s_1 - L_2 s_{12})\dot{\theta}_1 - L_2 s_{12} \dot{\theta}_2 \\ (L_1 c_1 + L_2 c_{12})\dot{\theta}_1 + L_2 c_{12} \dot{\theta}_2 \\ 0 \end{bmatrix} = \begin{bmatrix} -L_1 s_1 \dot{\theta}_1 - L_2 s_{12}(\dot{\theta}_1 + \dot{\theta}_2) \\ L_1 c_1 \dot{\theta}_1 + L_2 c_{12}(\dot{\theta}_1 + \dot{\theta}_2) \\ 0 \end{bmatrix}$$

In matrix form:

$$\begin{bmatrix} \dot{x} \\ \dot{y} \\ \dot{z} \end{bmatrix} = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \\ 0 & 0 \end{bmatrix} \begin{bmatrix} \dot{q}_1 \\ \dot{q}_2 \end{bmatrix}$$

— identical to the result from velocity propagation, as expected.

## Singularities

A **kinematic singularity** occurs when the end-effector loses the ability to move (or rotate) in some direction.

**Example — two-link planar arm.** With the arm folded into a generic non-collinear configuration, the tip can instantaneously move in any direction. With the arm fully stretched (both links collinear), the tip cannot instantaneously move in the radial direction (away from / towards the base along the arm) — it has lost a Cartesian degree of freedom.

**Example — spherical wrist.** The last three joints of a typical robot wrist (axes 4, 5, 6). In a generic configuration the wrist can rotate the end-effector about any axis. When axes 4 and 6 become collinear (wrist singularity), the wrist loses the ability to rotate about an axis perpendicular to the common axis.

<!-- suspected-source-error: slide 46 states the lost DOF as "rotate about the axis" — back-to-front. When wrist axes 4 and 6 are collinear, joints 4 and 6 actuate the *same* rotation axis (that rotation is, if anything, redundantly retained); the DOF that's lost is the ability to rotate about an axis *perpendicular* to the collinear pair (the third orientation DOF that joint 5 was providing in combination with the others). The text above corrects the slide's wording in line with the standard treatment (Craig §5.8); read this paragraph as the authoritative version. The slide's incorrect wording, retained here for reference: "when axes 4 and 6 are collinear, the end-effector loses ability to rotate about the axis." -->

### Mathematical condition

Mathematically, singularities occur when the Jacobian becomes non-invertible / singular (or, for a non-square Jacobian on a redundant manipulator, rank-deficient).

Starting from $\boldsymbol{v} = J(\boldsymbol{q})\dot{\boldsymbol{q}}$, the **inverse** problem asks: given a required end-effector velocity $\boldsymbol{v}$, what joint rate $\dot{\boldsymbol{q}}$ is needed? This requires

$$\dot{\boldsymbol{q}} = J^{-1}(\boldsymbol{q})\,\boldsymbol{v}$$

If $J$ is not invertible (or is ill-conditioned, $\det(J)$ close to zero), then near singularity, producing finite $\boldsymbol{v}$ in the lost direction would require an infinitely large joint rate — neither possible nor practical.

### 2-link example

For the 2-link robot Jacobian (ignoring the zero last row):

$$J_v = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \end{bmatrix}$$

$$\det(J_v) = -L_1 L_2 s_1 c_{12} - L_2^2 s_{12} c_{12} + L_1 L_2 c_1 s_{12} + L_2^2 s_{12} c_{12} = L_1 L_2 s_2$$

The determinant is zero (Jacobian becomes singular) when $s_2 = 0$, i.e.

$$\theta_2 = k\pi$$

— the arm is fully stretched ($\theta_2 = 0$) or fully folded back ($\theta_2 = \pi$). At these configurations the arm reaches a workspace-boundary or fold singularity.

## Static Forces in Manipulators

**Problem.** A robot is either holding an object (e.g. exerting an upward force $mg$ to support a weight) or pushing the environment with force $\boldsymbol{F}$. What joint torques are required to keep the system in **static equilibrium**?

**Result.** The same Jacobian governs the duality between joint torques and end-effector force:

$$\begin{bmatrix} \tau_1 \\ \tau_2 \\ \vdots \\ \tau_n \end{bmatrix} = {}^{0}J_v^T \cdot \begin{bmatrix} F_x \\ F_y \\ F_z \end{bmatrix}$$

Or compactly:

$$\boxed{\,\boldsymbol{\tau} = {}^{0}J_v^T \cdot {}^{0}\boldsymbol{F}\,}$$

<!-- pedagogical-simplification: slide 51 states the duality using only the *linear* Jacobian ${}^{0}J_v$ and a 3-vector force, implicitly assuming no end-effector moment. The fully general Craig form is $\boldsymbol{\tau} = J^T \boldsymbol{\mathcal F}$ with $J$ the 6×n Jacobian (linear + rotational blocks) and $\boldsymbol{\mathcal F} = [F_x, F_y, F_z, n_x, n_y, n_z]^T$ a 6-vector wrench. For the planar 2-link example below, no tip moment arises, so the simplified form is correct. If an exam question involves a tip moment, you need the rotational-Jacobian columns as well. -->

### Worked example — 2-link robot pushing a wall

The same 2-link robot. An external force $F_{\text{external}}$ acts horizontally on the tip (with respect to $\{0\}$) pointing to the left. To maintain static equilibrium, the robot exerts an equal and opposite force $F_{\text{by robot}}$ pointing to the right.

$$\begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix} = {}^{0}J_v^T \cdot \begin{bmatrix} {}^{0}F_x \\ {}^{0}F_y \end{bmatrix} = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & L_1 c_1 + L_2 c_{12} \\ -L_2 s_{12} & L_2 c_{12} \end{bmatrix} \begin{bmatrix} F_{\text{by robot}} \\ 0 \end{bmatrix} = \begin{bmatrix} (-L_1 s_1 - L_2 s_{12}) F_{\text{by robot}} \\ (-L_2 s_{12}) F_{\text{by robot}} \end{bmatrix}$$

**Numerical case.** With $\theta_1 = 30°$, $\theta_2 = 30°$, $F_{\text{by robot}} = 10\,\text{N}$, $L_1 = L_2 = 1\,\text{m}$:

$$\begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix} = \begin{bmatrix} (-0.5 - 0.866)\,\text{m} \cdot 10\,\text{N} \\ -0.866\,\text{m} \cdot 10\,\text{N} \end{bmatrix} = \begin{bmatrix} -13.66\,\text{Nm} \\ -8.66\,\text{Nm} \end{bmatrix}$$

The negative signs make physical sense: the motor torques are clockwise so that the robot force points to the right.

### Singularity and static forces

The same Jacobian appearing in $\boldsymbol{\tau} = J^T \boldsymbol{F}$ means singular configurations have a dual interpretation: **at a singularity, no torque is needed to withstand a force in certain directions — mechanical advantage**.

**Case 1.** Same robot, $\theta_1 = 0°$, $\theta_2 = 60°$, robot force $= 1\,\text{N}$ supporting a $1\,\text{N}$ object weight (force in $+y$ direction):

$$\begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix} = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & L_1 c_1 + L_2 c_{12} \\ -L_2 s_{12} & L_2 c_{12} \end{bmatrix} \begin{bmatrix} 0 \\ 1\,\text{N} \end{bmatrix} = \begin{bmatrix} (L_1 c_1 + L_2 c_{12})\,1\,\text{N} \\ (L_2 c_{12})\,1\,\text{N} \end{bmatrix} = \begin{bmatrix} (1 + 0.5)\,\text{m} \cdot 1\,\text{N} \\ 0.5\,\text{m} \cdot 1\,\text{N} \end{bmatrix} = \begin{bmatrix} 1.5\,\text{Nm} \\ 0.5\,\text{Nm} \end{bmatrix}$$

**Case 2 (at singularity).** $\theta_1 = 90°$, $\theta_2 = 0°$ — arm pointing straight up, fully extended; robot force $= 1000\,\text{N}$ supporting an object weight of $1000\,\text{N}$:

$$\begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix} = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & L_1 c_1 + L_2 c_{12} \\ -L_2 s_{12} & L_2 c_{12} \end{bmatrix} \begin{bmatrix} 0 \\ 1000\,\text{N} \end{bmatrix} = \begin{bmatrix} (L_1 c_1 + L_2 c_{12})\,1000\,\text{N} \\ (L_2 c_{12})\,1000\,\text{N} \end{bmatrix} = \begin{bmatrix} 0\,\text{Nm} \\ 0\,\text{Nm} \end{bmatrix}$$

At this singularity, zero joint torque is required to withstand a $1000\,\text{N}$ load — the structure carries the force directly through the links.

## Tutorial Questions

**Question 1.** Find the Jacobian of the 3-DOF manipulator shown (the robot used in earlier tutorials), with joints $\theta_1, \theta_2, \theta_3$ and link lengths $L_1, L_2$. Write the Jacobian:

- In terms of frame $\{3\}$ at the wrist of the robot — using both
  - the velocity-propagation method, and
  - direct differentiation of the kinematic equations.
- Also in terms of frame $\{4\}$ at the tip of the hand, with the same orientation as $\{3\}$.

**Question 2.** A 2-link manipulator has the linear Jacobian

$${}^{0}J_v = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \end{bmatrix}$$

Ignoring gravity, what joint torques are required so that the manipulator applies a static force

$${}^{0}\boldsymbol{F} = 10\,\hat{X}_0\quad ?$$

<!-- transcription-audit:
- Dropped: title slide (page 1) — institutional boilerplate; title preserved as H1.
- Dropped: schedule slide (page 2) — module-level boilerplate identifying this as the Week 7 lecture; not lecture content.
- Dropped: agenda/section-divider "Content" slides (pages 3, 4, 6, 35, 44, 49, 57) — six recurrences of the same TOC with highlighting denoting the current section. Sectioning preserved via heading hierarchy.
- Dropped: closing "Thank you for your attention!" slide (page 60) — boilerplate.
- Dropped: decorative chain-of-bodies figure on page 7 (frames {0}-{n} along an arrow) — purely illustrative of "the manipulator is a chain of bodies", which is stated in text.
- Dropped: figures on pages 8, 12, 16, 17, 18, 19, 20, 21, 22, 24 illustrating frame {i}/{i+1} with omega/v/P decorations — purely diagrammatic restatements of the algebra; all symbols defined in surrounding text.
- Dropped: 2-link robot diagram repeated on pages 26-33, 36, 48, 52-56 — same diagram with annotation tweaks; the geometry (planar arm with theta1, theta2, L1, L2) is described once in the example introduction.
- Dropped: small tangential-vs-radial-velocity callout figure on pages 20, 22 — its content ("rotation of previous joint creates tangential velocity; prismatic joint creates radial velocity") is captured in the text.
- Dropped: introduction figure on page 5 (the two robot poses showing joint rates and force vectors) — captured in the text statement of the lecture's two themes.
- Dropped: kinematic-singularity figures (pages 45, 46) — verbal description preserved.
- Dropped: tutorial Question 1 robot figure (page 58) — described in text (3-DOF, theta1 base rotation, theta2 shoulder, theta3 elbow, link lengths L1, L2); the parameters are what matter for the answer.
- Warnings: none — all figures were illustrative supports for algebra/geometry that is fully captured textually; no information loss expected from omitting them.
- Suspected source errors:
  1. Slide 34 labels the third row of the angular-velocity matrix as "(omega_e)_y" instead of "(omega_e)_z" (typo). Transcribed as z in the prose since context is unambiguous; flagged inline.
  2. Slide 46 spherical-wrist singularity wording is back-to-front ("loses ability to rotate about the axis" — should be perpendicular to it). **Inline `<!-- suspected-source-error -->` flag preserved with the slide's original wording quoted; the prose above the flag is the corrected statement.**
  3. Slide 56 Case-2 worked example displays "1N" in an intermediate step despite stating the load is 1000 N just above; final answer is `0 Nm` either way (the factor multiplies a zero matrix entry). **Silently corrected to "1000 N" in the transcript.**
  4. Slide 47 typo "Jabobian" → silently corrected to "Jacobian".
  5. Slide 59 typo "2-ink manipulator" → silently corrected to "2-link".
- Pedagogical notes added by the transcriber (not present on the slides):
  - The static-forces duality (slide 51) is stated using only the *linear* Jacobian. The general form involves the full 6×n Jacobian and a wrench (force + moment). Flagged inline above the boxed equation; harmless for the planar 2-link example.
  - The singularity-definition slide (47) uses "non-invertible" without distinguishing square / non-square cases. Transcript clarifies that for a redundant (non-square) Jacobian the proper notion is rank deficiency.
- Ambiguities: The lecturer's convention on a few sub/superscripts was inferred from context (e.g. consistent left-pre-superscript for frame of expression, left-pre-subscript and right-subscript on R for "from-frame to-frame", per Craig). No content-level ambiguities.
-->

# Trajectory Planning

## Introduction

Trajectory planning means designing a **time profile** of position, velocity and acceleration of a movement. For example, a car driving from A to B: the velocity starts from $0$, increases to $V_{\text{constant}}$ and stays constant for some time; as it approaches the target, the velocity decreases down to $0$. Similarly, a robot arm moving from an initial position toward an object accelerates at the start and decelerates at the end.

Trajectory planning is **not** about designing the "geographical" path — it is not about how to plan a route through a city, nor about how to plan an obstacle-avoiding path for a robot. It is about the **time profile** of the motion.

The designed time profile is expressed as mathematical functions:

$$u = f(t), \quad \dot u = f'(t), \quad \ddot u = f''(t)$$

From these functions, the computer can extract numerical values of $u, \dot u, \ddot u$ at any given $t$. These numerical values at different times $t$ are passed to the control system as **reference values** for the system (car, robot) to follow:

```
[u(0), u(0.1), u(0.2), ...]  →  R (reference) → (Σ) → Controller → System → Y (output)
                                                ↑_______________________________|
```

The task of this lecture is, given:

- the **current** position and orientation of the robot / end-effector,
- the desired **goal** position and orientation for the end-effector,
- the **time** to reach the goal position,
- the general **shape** of the path (straight line, polynomial, etc.),

write the function $u = f(t)$. Velocity $\dot u = f'(t)$ and acceleration $\ddot u = f''(t)$ then follow naturally by differentiation.

## Cartesian Space Schemes vs. Joint Space Schemes

### Cartesian space schemes

A Cartesian space scheme specifies the trajectory directly through the **position and orientation of the end-effector**:

$$x = f_x(t),\quad y = f_y(t),\quad z = f_z(t),\quad r_x = f_{rx}(t),\quad r_y = f_{ry}(t),\quad r_z = f_{rz}(t)$$

For example, to move the end-effector from $(x_A, y_A)$ to $(x_B, y_B)$, one designs $x = f_x(t)$ and $y = f_y(t)$ that smoothly interpolate between the start and end values.

**Advantages.** The shape of the geometrical path can be enforced (e.g. a straight line), and the orientation of the end-effector can be enforced (e.g. maintained constant throughout the motion).

**Disadvantages.**

1. **Computationally expensive.** Inverse kinematics must be solved at every time step (update rate) to convert the Cartesian reference into joint angles before passing them to the controller:

   ```
   [x(0),y(0); x(0.1),y(0.1); ...]  →  Inverse Kinematics  →  [q1*(0),q2*(0); ...]  →  (Σ) → Controller → System → Joint angles
                                                                                          ↑___________________________________|
   ```

2. **Prone to problems related to workspace and singularities.** Three failure modes:
   - intermediate points along the Cartesian path may be **outside the workspace** (unreachable) even when start and end are reachable;
   - start and end points may be reachable but only in **different inverse-kinematic configurations**, requiring a configuration change mid-path;
   - **high joint rates near singularities** can occur when the Cartesian path passes close to a singular configuration.

### Joint space schemes

A joint space scheme specifies the trajectory directly through the **joint angles**:

$$\theta_1 = f_{\theta 1}(t),\ \theta_2 = f_{\theta 2}(t),\ \theta_3 = f_{\theta 3}(t),\ \theta_4 = f_{\theta 4}(t),\ \theta_5 = f_{\theta 5}(t),\ \theta_6 = f_{\theta 6}(t)$$

For example, $\theta_1$ goes from $80°$ to $30°$ while $\theta_2$ goes from $-30°$ to $-10°$, with each $\theta_i = f_{\theta i}(t)$ designed as a smooth time profile.

**Advantages.**

- Easy to compute — the joint-space reference is fed directly to the controller, no inverse kinematics needed at each step:

   ```
   [q1*(0),q2*(0); q1*(0.1),q2*(0.1); ...]  →  (Σ) → Controller → System → Joint angles
                                                ↑___________________________________|
   ```

- No issue with singularities.

**Disadvantages.** The Cartesian path will not be linear (joints interpolate linearly in joint space, not in task space). This may be a problem if there are possible collisions along the resulting Cartesian path.

### Common notation

Regardless of whether the trajectory is specified in Cartesian space or joint space, the design process — i.e. the form of the mathematical function — is the same. The remainder of the lecture uses $u(t)$ to represent the trajectory variable, standing in for any Cartesian coordinate or joint angle:

$$u = f_u(t)$$

### The general problem

Given:

- the start position $u_0$,
- the end position $u_f$,
- the time $t_f$ to reach the final position,

generate a trajectory $u = f_u(t)$ for the robot to follow.

## Straight Line

The simplest trajectory is a straight time profile between start and end:

$$u(t) = \begin{cases} \dfrac{u_f - u_0}{t_f}\, t + u_0 & t < t_f \\[2pt] u_f & t \ge t_f \end{cases}$$

**Disadvantage:** velocities are **discontinuous** at the start and end points. The resulting rough, jerky motion causes vibrations due to resonance modes, and increases wear and tear.

## Cubic Polynomial

To ensure zero velocity at the start and end points, use a cubic polynomial:

$$u(t) = \begin{cases} a_0 + a_1 t + a_2 t^2 + a_3 t^3 & t < t_f \\ u_f & t \ge t_f \end{cases}$$

### Coefficients from boundary conditions

The four parameters $a_0, a_1, a_2, a_3$ are fixed by **four constraints** (boundary conditions):

$$u(0) = u_0, \qquad u(t_f) = u_f, \qquad \dot u(0) = 0, \qquad \dot u(t_f) = 0$$

The velocity is

$$\dot u(t) = \frac{d}{dt}\big(a_0 + a_1 t + a_2 t^2 + a_3 t^3\big) = a_1 + 2 a_2 t + 3 a_3 t^2$$

Writing out the four simultaneous equations:

$$\begin{aligned}
u(0) &= a_0 = u_0 \\
u(t_f) &= a_0 + a_1 t_f + a_2 t_f^2 + a_3 t_f^3 = u_f \\
\dot u(0) &= a_1 = 0 \\
\dot u(t_f) &= a_1 + 2 a_2 t_f + 3 a_3 t_f^2 = 0
\end{aligned}$$

Solving gives:

$$\boxed{\;a_0 = u_0, \qquad a_1 = 0, \qquad a_2 = \frac{3}{t_f^2}(u_f - u_0), \qquad a_3 = -\frac{2}{t_f^3}(u_f - u_0)\;}$$

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

$$\begin{aligned}
a_0 &= 15 \\
a_1 &= 0 \\
a_2 &= \frac{3}{3^2}(75 - 15) = 20 \\
a_3 &= -\frac{2}{3^3}(75 - 15) = -4.44
\end{aligned}$$

The trajectory is

$$u(t) = \begin{cases} 15 + 20 t^2 - 4.44\, t^3 & t < 3 \\ 75 & t \ge 3 \end{cases}$$

### Profile shape

Position rises smoothly from $u_0$ to $u_f$ in an S-curve; velocity is a symmetric parabolic hump that starts and ends at $0$ with a peak near the midpoint; acceleration is a straight line decreasing from a positive value at $t = 0$ through zero at the midpoint to an equal-magnitude negative value at $t = t_f$.

**Note:** the **accelerations at start and end are not zero** (they are $2 a_2$ and $2 a_2 + 6 a_3 t_f$ respectively). This produces a discontinuity in acceleration at the trajectory boundaries and may create jerky motion.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions %
%%%%%%%%%%%%%%%%%%%%%%%

u0 = 15;
uf = 75;
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%
% Create Time Array %
%%%%%%%%%%%%%%%%%%%%%%

t = 0:0.001:tf;   % array of time from 0 to tf in steps of 0.001
t = t';           % make the time array into column vector

%%%%%%%%%%%%%%%%%%%%%%%
% Cubic Polynomial %
%%%%%%%%%%%%%%%%%%%%%%%

a0 = u0;
a1 = 0;
a2 = 3/tf^2*(uf-u0);
a3 = -2/tf^3*(uf-u0);

uCubic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3;
uDotCubic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2;
uDoubleDotCubic = 2*a2*ones(length(t),1) + 6*a3*t;

figure, sgtitle('Cubic')
subplot(1,3,1), plot(t,uCubic),         title('Position')
subplot(1,3,2), plot(t,uDotCubic),      title('Velocity')
subplot(1,3,3), plot(t,uDoubleDotCubic), title('Acceleration')
```

## Quintic Polynomial

The cubic polynomial has only 4 parameters and so can only satisfy 4 constraints, $u(0), u(t_f), \dot u(0), \dot u(t_f)$ — leaving the start/end accelerations uncontrolled. To additionally constrain accelerations at the boundaries, $\ddot u(0)$ and $\ddot u(t_f)$, we need 6 parameters: the **quintic polynomial**.

$$u(t) = \begin{cases} a_0 + a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5 & t < t_f \\ u_f & t \ge t_f \end{cases}$$

### Coefficients from boundary conditions

With $\dot u(0) = \dot u(t_f) = 0$ and $\ddot u(0) = \ddot u(t_f) = 0$, the six simultaneous equations from

$$\begin{aligned}
u(t)        &= a_0 + a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5 \\
\dot u(t)   &= a_1 + 2 a_2 t + 3 a_3 t^2 + 4 a_4 t^3 + 5 a_5 t^4 \\
\ddot u(t)  &= 2 a_2 + 6 a_3 t + 12 a_4 t^2 + 20 a_5 t^3
\end{aligned}$$

are

$$\begin{aligned}
u(0) &= a_0 = u_0 \\
u(t_f) &= a_0 + a_1 t_f + a_2 t_f^2 + a_3 t_f^3 + a_4 t_f^4 + a_5 t_f^5 = u_f \\
\dot u(0) &= a_1 = 0 \\
\dot u(t_f) &= a_1 + 2 a_2 t_f + 3 a_3 t_f^2 + 4 a_4 t_f^3 + 5 a_5 t_f^4 = 0 \\
\ddot u(0) &= 2 a_2 = 0 \\
\ddot u(t_f) &= 2 a_2 + 6 a_3 t_f + 12 a_4 t_f^2 + 20 a_5 t_f^3 = 0
\end{aligned}$$

Solving gives:

$$\boxed{\;
a_0 = u_0,\quad a_1 = 0,\quad a_2 = 0,\quad
a_3 = \frac{10}{t_f^3}(u_f - u_0),\quad
a_4 = -\frac{15}{t_f^4}(u_f - u_0),\quad
a_5 = \frac{6}{t_f^5}(u_f - u_0)
\;}$$

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

$$\begin{aligned}
a_0 &= 15,\quad a_1 = 0,\quad a_2 = 0 \\
a_3 &= \frac{10}{3^3}(75 - 15) = 22.22 \\
a_4 &= -\frac{15}{3^4}(75 - 15) = -11.11 \\
a_5 &= \frac{6}{3^5}(75 - 15) = 1.48148
\end{aligned}$$

$$u(t) = \begin{cases} 15 + 22.22\, t^3 - 11.11\, t^4 + 1.48148\, t^5 & t < 3 \\ 75 & t \ge 3 \end{cases}$$

### Profile shape

Position again rises in an S-curve. Velocity is a smooth hump that starts at $0$, peaks near the midpoint, and returns to $0$. **Acceleration is now continuous at the start and end** — it begins at $0$, rises to a positive peak, crosses zero near the midpoint, falls to a symmetric negative peak, and returns to $0$ at $t_f$.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial %
%%%%%%%%%%%%%%%%%%%%%%%

a0 = u0;
a1 = 0;
a2 = 0;
a3 =  10/tf^3*(uf-u0);
a4 = -15/tf^4*(uf-u0);
a5 =   6/tf^5*(uf-u0);

uQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
uDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
uDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('Quintic')
subplot(1,3,1), plot(t,uQuintic),         title('Position')
subplot(1,3,2), plot(t,uDotQuintic),      title('Velocity')
subplot(1,3,3), plot(t,uDoubleDotQuintic), title('Acceleration')
```

## Linear Function with Parabolic Blends

### Motivation

The cubic and quintic polynomials, while smooth, are not the most natural profile when you think of a real motion. Driving from A to B, you would **not** slowly increase speed, reach maximum velocity exactly halfway, and then slowly decrease — instead you would:

- increase speed smoothly but rapidly up to a maximum velocity (e.g. 70 mph),
- maintain the maximum velocity (constant) for a long time,
- decrease speed to zero smoothly but rapidly as you reach the destination.

This is the **linear function with parabolic blends** (sometimes called bang-bang or LSPB):

- a **first parabolic blend** during $[0, t_b]$ with constant acceleration $\ddot u$,
- a **linear (constant-velocity) segment** during $[t_b, t_f - t_b]$,
- a **second parabolic blend** during $[t_f - t_b, t_f]$ with constant deceleration $-\ddot u$.

### Required inputs and assumptions

Four pieces of information are needed: the start position $u_0$, the end position $u_f$, the final time $t_f$, and the acceleration $\ddot u$ of the first blend portion.

Three assumptions are made:

- **A1.** Both parabolic blends have the **same time duration** $t_b$. Hence the deceleration of the second blend equals $-\ddot u$.
- **A2.** The solution is **symmetric** about the halfway point in time $t_h$ and position $u_h$.
- **A3.** The **velocity at the end of the first blend** equals the velocity along the linear region.

### Velocity and position in the blend region

In the first blend $\ddot u$ is constant. Starting from $\dot u(0) = 0$:

$$\dot u(t) = \int \ddot u \, dt = \underbrace{\dot u_0}_{0} + \ddot u\, t = \ddot u\, t$$

Integrating once more, with $u(0) = u_0$:

$$u(t) = \int \dot u \, dt = u_0 + \tfrac{1}{2} \ddot u\, t^2$$

### Piecewise trajectory

The full trajectory, given the blend endpoint $(t_b, u_b)$ and halfway point $(t_h, u_h)$, is

$$u(t) = \begin{cases}
u_0 + \dfrac{1}{2} \ddot u\, t^2 & t < t_b \\[6pt]
\dfrac{u_h - u_b}{t_h - t_b}(t - t_b) + u_b & t_b \le t < (t_f - t_b) \\[6pt]
u_f - \dfrac{1}{2} \ddot u\, (t_f - t)^2 & t \ge (t_f - t_b)
\end{cases}$$

<!-- pedagogical-omission: slides 49 and 55 write the third branch with no upper bound on `t`. For the trajectory to remain at `u_f` after `t_f`, the branch should terminate at `t = t_f` and a constant `u_f` should follow for `t > t_f`. Plugging `t > t_f` into the third branch (the parabola is symmetric about `t_f`) makes the position fall back below `u_f`. The cubic and quintic earlier in this deck do include the `t ≥ t_f → u_f` cap, so this is internally inconsistent. Harmless in practice since you stop sampling at `t = t_f`; just a missing terminal case. -->

The unknowns are $u_b$ and $t_b$.

### Solving for $t_b$ and $u_b$

From **A3**, the velocity at the end of the first blend equals the slope of the linear segment:

$$\ddot u\, t_b = \frac{u_h - u_b}{t_h - t_b} \qquad (1)$$

Express $u_b$ in terms of $t_b$ using the blend-region position formula:

$$u_b = u_0 + \tfrac{1}{2}\, \ddot u\, t_b^2 \qquad (2)$$

The symmetry assumption **A2** gives:

$$u_h = \tfrac{1}{2}(u_0 + u_f) \qquad (3)$$
$$t_h = \tfrac{1}{2}\, t_f \qquad (4)$$

Substituting (2), (3), (4) into (1):

$$\ddot u\, t_b = \frac{\tfrac{1}{2}(u_0 + u_f) - u_0 - \tfrac{1}{2}\, \ddot u\, t_b^2}{\tfrac{1}{2}\, t_f - t_b}
\quad\Longrightarrow\quad
\ddot u\, t_b^2 - \ddot u\, t_f\, t_b + (u_f - u_0) = 0$$

This is a quadratic in $t_b$. Solving:

$$t_b = \frac{\ddot u\, t_f - \sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}
     = \frac{t_f}{2} - \frac{\sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}$$

Only the **minus** sign for the square root is kept, because $t_b \le t_f / 2$. Then substitute $t_b$ back into $u_b = u_0 + \tfrac{1}{2} \ddot u\, t_b^2$ to obtain $u_b$.

### Constraint on the chosen acceleration

The acceleration $\ddot u$ must be **high enough** for a solution to $t_b$ to exist. If $\ddot u$ is too small, the linear region shrinks; if it is too small still, there is no linear region at all and no real solution.

A real solution requires the discriminant in $t_b$ to be non-negative:

$$\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0) \ge 0
\quad\Longrightarrow\quad
\ddot u^2 t_f^2 \ge 4\, \ddot u\, (u_f - u_0)
\quad\Longrightarrow\quad
\boxed{\;\ddot u \ge 4\, \dfrac{u_f - u_0}{t_f^2}\;}$$

### Summary of the procedure

Given $u_0$, $u_f$, $t_f$:

1. Choose desired acceleration $\ddot u$ satisfying $\ddot u \ge 4\,(u_f - u_0)/t_f^2$.
2. Compute
   $$t_b = \frac{t_f}{2} - \frac{\sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}, \qquad
   u_b = u_0 + \tfrac{1}{2} \ddot u\, t_b^2$$
3. Form the piecewise trajectory
   $$u(t) = \begin{cases}
   u_0 + \tfrac{1}{2} \ddot u\, t^2 & t < t_b \\[4pt]
   \dfrac{u_h - u_b}{t_h - t_b}(t - t_b) + u_b & t_b \le t < (t_f - t_b) \\[4pt]
   u_f - \tfrac{1}{2} \ddot u\, (t_f - t)^2 & t \ge (t_f - t_b)
   \end{cases}$$
   with $u_h = \tfrac{1}{2}(u_0 + u_f)$ and $t_h = \tfrac{1}{2} t_f$.

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

Minimum acceleration:

$$\ddot u \ge 4\,\frac{u_f - u_0}{t_f^2} = 4\,\frac{75 - 15}{3^2} = 26.6666$$

Choose $\ddot u = 100$. Then

$$t_b = \frac{3}{2} - \frac{\sqrt{100^2 \cdot 3^2 - 4 \cdot 100 \cdot (75 - 15)}}{2 \cdot 100} = 0.2155$$

$$u_b = 15 + \tfrac{1}{2} \cdot 100 \cdot 0.2155^2 = 17.3215$$

The trajectory then follows the standard three-piece form above.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions %
%%%%%%%%%%%%%%%%%%%%%%%

u0 = 15;
uf = 75;
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear with Parabolic Blend %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AccMin = 4*(uf-u0)/tf^2;
Acc    = round(4*AccMin/100)*100;   % Assume 4 x AccMin, round to closest 100
tb = tf/2 - sqrt(Acc^2*tf^2 - 4*Acc*(uf-u0))/2/Acc;
ub = u0 + 0.5*Acc*tb^2;
uh = 0.5*(u0+uf);
th = 0.5*tf;

% First blend
tBlend1 = 0:0.001:tb;
tBlend1 = tBlend1';
uBlend1 = u0*ones(length(tBlend1),1) + 0.5*Acc*tBlend1.^2;

% Linear portion
tLinear = tb+0.001:0.001:(tf-tb);
tLinear = tLinear';
uLinear = (uh-ub)/(th-tb)*(tLinear-tb) + ub;

% Second blend
tBlend2 = (tf-tb+0.001):0.001:tf;
tBlend2 = tBlend2';
uBlend2 = uf*ones(length(tBlend2),1) - 0.5*Acc*(tf-tBlend2).^2;

% Combine
tCombine = [tBlend1; tLinear; tBlend2];
uCombine = [uBlend1; uLinear; uBlend2];
figure, plot(tCombine, uCombine), title('Linear with Parabolic Blend - Position')
```

Plotting the result gives a position curve that is parabolic at both ends and linear in the middle, rising from $15$ to $75$ over $[0, 3]$ seconds.

## Trajectories with Multiple Segments

The MATLAB code above generates a trajectory for a **single move** only. When several moves are required, for example:

- move from $15°$ to $75°$ at $t = 0$ with duration $3$ seconds;
- stay at $75°$ until the next move;
- move from $75°$ to $50°$ at $t = 7$ with duration $3$ seconds;
- stay at $50°$ until the next move;
- move from $50°$ to $90°$ at $t = 15$ with duration $3$ seconds;
- etc.

each move can be generated with the per-segment formulae above and the segments concatenated in time. The corresponding position curve has alternating ramp-like and flat (dwell) regions; velocity is non-zero during each move and zero during dwells; acceleration has spikes at the move boundaries (cubic) or smoother bumps (quintic), with zero between moves.

This multi-segment construction is left as a coding exercise — it is required for the robot workshop.

<!-- transcription-audit:
- Dropped: title slide (slide 1) — boilerplate.
- Dropped: schedule slide (slide 2) — administrative, no lecture content.
- Dropped: top-level content/agenda slides and their progressive-highlight repeats (slides 3, 4, 12, 24, 34, 42, 61) — duplicated by the heading hierarchy of this transcript.
- Dropped: closing "Thank you" slide (slide 66) — boilerplate.
- Dropped: car-illustration and arm-illustration decorative cartoons (slides 5, 6, 44) — content is in the prose.
- Dropped: maze/obstacle decorative images (slide 7) — point made in text.
- Dropped: zigzag arm-trajectory figure (slide 21) — decorative; "non-linear Cartesian path" point captured in text.
- Dropped: position/velocity/acceleration example graphs that merely illustrate the equations already given (slides 8, 31, 40, 53, 60, 64, 65) — described in prose where they communicate something new (profile shape, near-degenerate LSPB), otherwise omitted. The multi-segment plots on slides 64–65 are summarised in prose only.
- Dropped: control-loop block-diagram on slide 10 — represented as inline ASCII once; later repeats (slides 16, 20) likewise represented inline at the points they appear.
- Warnings: none — figures are either reproducible from the equations or purely illustrative.
- Ambiguities: the LSPB MATLAB snippet uses `Acc = round(4*AccMin/100)*100`, which despite the comment "Assume 4 x AccMin" does NOT generally yield 4*AccMin (it rounds 4*AccMin/100 to the nearest integer then multiplies by 100). For the example values (AccMin = 26.67, so 4*AccMin/100 = 1.0667 → round to 1 → Acc = 100), the result happens to match the lecture's chosen Acc = 100, so this is transcribed verbatim without flagging as a source error.
- Suspected source errors (added on verifier pass):
  1. LSPB piecewise on slides 49 and 55 lacks a `t ≤ t_f` cap on the third branch (and the constant-after-t_f extension that the cubic and quintic versions of this deck do include). Inline `<!-- pedagogical-omission -->` flag near the piecewise definition. Harmless in practice; just internally inconsistent.
  2. Slide 58 MATLAB comment "Assume 4 x AccMin" mislabels what the code actually computes; transcribed verbatim and noted in the Ambiguities entry above.
- Stylistic normalisation (silent): the source uses `x = f(t), \dot x, \ddot x` in the Introduction (slides 5–11) before switching to the unified notation `u(t)` at slide 22; the transcript uses `u(t)` from the start to avoid the notation switch mid-document. No content change.
-->

# Week 9 — Manipulator Dynamics

## Introduction

**Manipulator dynamics** addresses two related questions:

- How much torque is needed to accelerate the manipulator from rest to constant velocity, and then back to a stop?
- What model (equations of motion) describes the robot for simulation and control design?

## Joint-Space Dynamic Equations: Canonical Form

The manipulator's joint-space dynamic equation takes the form:

$$M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau$$

For comparison, the well-known mass-spring-damper system is:

$$m\ddot{x} + b\dot{x} + kx = F$$

There are similarities — the manipulator equation generalises this idea to a multi-DOF rigid body system.

### Mass Matrix $M(q)$

$M(q)$ is the $n \times n$ **mass matrix** of the manipulator. It depends on the generalised joint coordinates $q$ (angles for revolute joints / displacements for prismatic joints).

The mass matrix encodes the "perceived inertia" at each joint. For a two-link planar robot, the perceived inertia at joint 1 is larger when the second link is extended away from joint 1 than when it is folded back near joint 1 — because the same joint-1 acceleration moves the distal mass through different effective lever arms.

Perceived inertia also depends on the mass contribution and length of the links.

### Velocity-Coupling Term $V(q,\dot{q})$

$V(q,\dot{q})$ is an $n \times 1$ vector consisting of:

- **Centrifugal force**: a "fictitious" force acting away from the axis of rotation (e.g. whirling a stone on a string).
- **Coriolis force**: a "fictitious" force that acts on objects in motion within a frame of reference that rotates with respect to an inertial frame.

(In an inertial frame, a body with zero net force acting upon it does not accelerate — hence the "fictitious" qualifier when these terms are written in a rotating frame.)

Properties:

- $V(q,\dot{q})$ depends on $q$ as well as the joint velocities $\dot{q}$.
- It is zero if velocities are zero.
- $V(q,\dot{q})$ can be derived from $M(q)$.
- It is also zero if $M(q)$ is a constant matrix.

### Gravity Vector $G(q)$

$G(q)$ is the $n \times 1$ vector of **gravity terms**. It depends on the joint coordinates / configuration of the robot.

For example, a single revolute link pinned at one end: with the link held horizontally, gravity acts on the distal mass with a lever arm — joint torque must be nonzero to hold the configuration. With the link vertical (mass directly above the pivot), gravity passes through the pivot — joint torque is zero.

### Generalized Forces $\tau$

$\tau$ is the vector of **generalised forces** (force or torque) at each joint.

- For a 3R robot, $\tau$ means torque–torque–torque.
- For an RRP robot, $\tau$ means torque–torque–force.

---

## Newton-Euler Formulation

### Newton's Second Law

In an inertial frame of reference, the vector sum ($F$) of the forces ($f_i$) on an object is equal to the mass ($m$) of that object multiplied by the acceleration ($a$):

$$F = \sum_i f_i = ma$$

### Euler's Equation

For rotary motion, a rigid body rotates with angular velocity $\omega$ and angular acceleration $\dot{\omega}$. The moment $N$ which must be acting on the body to cause this motion is:

$$N = {}^{C}I\,\dot{\omega} + \omega \times {}^{C}I\,\omega$$

where ${}^{C}I$ is the **inertia tensor** of the body written in frame $\{C\}$ whose origin is located at the centre of mass.

The first term is analogous to $F = ma$: ${}^{C}I$ plays the role of "mass" but for rotary motion.

### Strategy of the Newton-Euler Recursion

The strategy parallels velocity propagation from forward kinematics, but extends it to accelerations and then to forces/moments:

1. Acceleration can be propagated from a lower frame to an upper frame (frame $i$ to frame $i+1$), just like velocity propagation.
2. The acceleration at frame $i+1$ can be propagated to the centre of mass of link $i+1$.
3. Once the acceleration at the centre of mass is known, the net force acting there follows from $F = ma$.
4. That net force is created by the forces/torques applied by the motors at both ends of the link, plus any contact force at the end-effector. This means: knowing the net $F$ on each link, we can solve back inwards for the joint forces/torques.

This gives a two-pass algorithm: an **outward iteration** computing kinematics (and per-link net forces/moments) from base to tip, followed by an **inward iteration** computing inter-link forces/moments from tip back to base.

### Outward Iteration

Start with the base conditions:

$${}^{0}\omega_0 = 0, \quad {}^{0}\dot{\omega}_0 = 0, \quad {}^{0}\dot{v}_0 = \text{depends}$$

The base linear acceleration ${}^{0}\dot{v}_0$ is normally zero, but is used as a "trick" to include gravity (see below).

For each link, calculate the angular velocity, angular acceleration, and linear acceleration of frame $\{i+1\}$:

$${}^{i+1}\omega_{i+1} = \left({}^{i+1}_{i}R \cdot {}^{i}\omega_i\right) + \left(\dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\right)$$

$${}^{i+1}\dot{\omega}_{i+1} = \left({}^{i+1}_{i}R \cdot {}^{i}\dot{\omega}_i\right) + \left(\left({}^{i+1}_{i}R \cdot {}^{i}\omega_i\right) \times \left(\dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\right)\right) + \left(\ddot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\right)$$

$${}^{i+1}\dot{v}_{i+1} = \left({}^{i+1}_{i}R \cdot {}^{i}\dot{v}_i\right) + \left(2\,{}^{i+1}\omega_{i+1} \times \left(\dot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\right)\right) + \left(\ddot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\right) + {}^{i+1}_{i}R\left(\left({}^{i}\dot{\omega}_i \times {}^{i}P_{i+1}\right) + \left({}^{i}\omega_i \times \left({}^{i}\omega_i \times {}^{i}P_{i+1}\right)\right)\right)$$

Propagate the linear acceleration from the frame origin to the centre of mass of the link:

$${}^{i+1}\dot{v}_{C_{i+1}} = \left({}^{i+1}\dot{v}_{i+1}\right) + \left({}^{i+1}\dot{\omega}_{i+1} \times {}^{i+1}P_{C_{i+1}}\right) + \left({}^{i+1}\omega_{i+1} \times \left({}^{i+1}\omega_{i+1} \times {}^{i+1}P_{C_{i+1}}\right)\right)$$

Calculate the net force and net moment at the centre of mass of the link:

$${}^{i+1}F_{i+1} = m_{i+1}\,{}^{i+1}\dot{v}_{C_{i+1}}$$

$${}^{i+1}N_{i+1} = \left({}^{C_{i+1}}I_{i+1} \cdot {}^{i+1}\dot{\omega}_{i+1}\right) + \left({}^{i+1}\omega_{i+1} \times \left({}^{C_{i+1}}I_{i+1} \cdot {}^{i+1}\omega_{i+1}\right)\right)$$

Continue until link $n$.

### Inclusion of Gravity Force

The effect of gravity can be included by setting:

$${}^{0}\dot{v}_0 = G$$

where $G$ has the magnitude of the gravity vector but **points in the opposite direction**. This can be interpreted as the base moving upwards with $1g$ acceleration — a standard trick that automatically propagates gravity through every link.

### Inward Iteration

Start with the force and torque at the robot tip ${}^{n}f_n$, ${}^{n}n_n$. If the end-effector is not in contact with the environment, these are zero.

Calculate the force and torque transmitted across the proximal end of each link, working from tip back to base:

$${}^{i}f_i = \left({}^{i}_{i+1}R \cdot {}^{i+1}f_{i+1}\right) + {}^{i}F_i$$

$${}^{i}n_i = \left({}^{i}_{i+1}R \cdot {}^{i+1}n_{i+1}\right) + \left({}^{i}P_{C_i} \times {}^{i}F_i\right) + \left({}^{i}P_{i+1} \times \left({}^{i}_{i+1}R \cdot {}^{i+1}f_{i+1}\right)\right) + {}^{i}N_i$$

Continue until $i = 1$.

Finally, extract the joint (motor) torques or forces by projecting onto the joint axis:

$$\tau_i = {}^{i}n_i^T \cdot {}^{i}\hat{Z}_i \quad \text{if revolute}$$
$$\tau_i = {}^{i}f_i^T \cdot {}^{i}\hat{Z}_i \quad \text{if prismatic}$$

---

## Worked Example: Two-Link Planar Robot

Consider a two-link planar robot where the mass of each link is a point mass at the **end** of the link. Joints 1 and 2 are revolute, with angles $\theta_1$, $\theta_2$, link lengths $L_1$, $L_2$, and point masses $m_1$, $m_2$ located at the tip of links 1 and 2 respectively.

The vectors locating the centre of mass for each link are:

$${}^{1}P_{C_1} = L_1\hat{X}_1, \quad {}^{2}P_{C_2} = L_2\hat{X}_2$$

Because each link's mass is a point mass, the inertia tensor at the centre of mass is zero:

$${}^{C_1}I_1 = 0, \quad {}^{C_2}I_2 = 0$$

Rotation matrices between successive frames (planar, rotation about $\hat{Z}$):

$${}^{i}_{i+1}R = \begin{bmatrix} c_{i+1} & -s_{i+1} & 0 \\ s_{i+1} & c_{i+1} & 0 \\ 0 & 0 & 1 \end{bmatrix}, \quad {}^{i+1}_{i}R = \begin{bmatrix} c_{i+1} & s_{i+1} & 0 \\ -s_{i+1} & c_{i+1} & 0 \\ 0 & 0 & 1 \end{bmatrix}$$

### Outward Iteration — Link 1

Initial conditions (with gravity included by setting the base linear acceleration to $g\hat{Y}_0$, i.e. opposite to gravity if gravity points along $-\hat{Y}_0$):

$${}^{0}\omega_0 = 0, \quad {}^{0}\dot{\omega}_0 = 0, \quad {}^{0}\dot{v}_0 = g\hat{Y}_0$$

Angular velocity of frame {1}:

$${}^{1}\omega_1 = \left({}^{1}_{0}R \cdot \underbrace{{}^{0}\omega_0}_{0}\right) + \left(\dot{\theta}_1 \cdot {}^{1}\hat{Z}_1\right) = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 \end{bmatrix}$$

Angular acceleration of frame {1}:

$${}^{1}\dot{\omega}_1 = \left({}^{1}_{0}R \cdot \underbrace{{}^{0}\dot{\omega}_0}_{0}\right) + \left(\left({}^{1}_{0}R \cdot \underbrace{{}^{0}\omega_0}_{0}\right) \times \left(\dot{\theta}_1 \cdot {}^{1}\hat{Z}_1\right)\right) + \left(\ddot{\theta}_1 \cdot {}^{1}\hat{Z}_1\right) = \begin{bmatrix} 0 \\ 0 \\ \ddot{\theta}_1 \end{bmatrix}$$

Linear acceleration of frame {1} origin (joint 1 is revolute, so $\dot{d}_1 = \ddot{d}_1 = 0$; ${}^{0}P_1 = 0$ since the joint coincides with frame {0}):

$${}^{1}\dot{v}_1 = {}^{1}_{0}R \cdot {}^{0}\dot{v}_0 = \begin{bmatrix} c_1 & s_1 & 0 \\ -s_1 & c_1 & 0 \\ 0 & 0 & 1 \end{bmatrix}\begin{bmatrix} 0 \\ g \\ 0 \end{bmatrix} = \begin{bmatrix} g s_1 \\ g c_1 \\ 0 \end{bmatrix}$$

Propagate to the centre of mass of link 1:

$${}^{1}\dot{v}_{C_1} = {}^{1}\dot{v}_1 + \left({}^{1}\dot{\omega}_1 \times {}^{1}P_{C_1}\right) + \left({}^{1}\omega_1 \times \left({}^{1}\omega_1 \times {}^{1}P_{C_1}\right)\right) = \begin{bmatrix} g s_1 \\ g c_1 \\ 0 \end{bmatrix} + \begin{bmatrix} 0 \\ L_1 \ddot{\theta}_1 \\ 0 \end{bmatrix} + \begin{bmatrix} -L_1 \dot{\theta}_1^2 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} g s_1 - L_1 \dot{\theta}_1^2 \\ g c_1 + L_1 \ddot{\theta}_1 \\ 0 \end{bmatrix}$$

Net force and moment at link 1's centre of mass:

$${}^{1}F_1 = m_1\,{}^{1}\dot{v}_{C_1} = \begin{bmatrix} m_1 g s_1 - m_1 L_1 \dot{\theta}_1^2 \\ m_1 g c_1 + m_1 L_1 \ddot{\theta}_1 \\ 0 \end{bmatrix}$$

$${}^{1}N_1 = \left(\underbrace{{}^{C_1}I_1}_{0} \cdot {}^{1}\dot{\omega}_1\right) + \left({}^{1}\omega_1 \times \left(\underbrace{{}^{C_1}I_1}_{0} \cdot {}^{1}\omega_1\right)\right) = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}$$

### Outward Iteration — Link 2

Angular velocity of frame {2}:

$${}^{2}\omega_2 = \left({}^{2}_{1}R \cdot {}^{1}\omega_1\right) + \left(\dot{\theta}_2 \cdot {}^{2}\hat{Z}_2\right) = \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 + \dot{\theta}_2 \end{bmatrix}$$

Angular acceleration of frame {2}:

$${}^{2}\dot{\omega}_2 = \left({}^{2}_{1}R \cdot {}^{1}\dot{\omega}_1\right) + \left(\left({}^{2}_{1}R \cdot {}^{1}\omega_1\right) \times \left(\dot{\theta}_2 \cdot {}^{2}\hat{Z}_2\right)\right) + \left(\ddot{\theta}_2 \cdot {}^{2}\hat{Z}_2\right) = \begin{bmatrix} 0 \\ 0 \\ \ddot{\theta}_1 + \ddot{\theta}_2 \end{bmatrix}$$

(The cross-product term vanishes because $({}^{2}_{1}R \cdot {}^{1}\omega_1)$ is along $\hat{Z}_2$ and so is $\dot{\theta}_2 \hat{Z}_2$.)

Linear acceleration of frame {2} origin (using ${}^{1}P_2 = L_1 \hat{X}_1$):

$${}^{2}\dot{v}_2 = \left({}^{2}_{1}R \cdot {}^{1}\dot{v}_1\right) + {}^{2}_{1}R\left(\left({}^{1}\dot{\omega}_1 \times {}^{1}P_2\right) + \left({}^{1}\omega_1 \times \left({}^{1}\omega_1 \times {}^{1}P_2\right)\right)\right)$$

$$= \begin{bmatrix} c_2 & s_2 & 0 \\ -s_2 & c_2 & 0 \\ 0 & 0 & 1 \end{bmatrix}\begin{bmatrix} g s_1 \\ g c_1 \\ 0 \end{bmatrix} + \begin{bmatrix} c_2 & s_2 & 0 \\ -s_2 & c_2 & 0 \\ 0 & 0 & 1 \end{bmatrix}\left(\begin{bmatrix} 0 \\ 0 \\ \ddot{\theta}_1 \end{bmatrix} \times \begin{bmatrix} L_1 \\ 0 \\ 0 \end{bmatrix} + \begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 \end{bmatrix} \times \left(\begin{bmatrix} 0 \\ 0 \\ \dot{\theta}_1 \end{bmatrix} \times \begin{bmatrix} L_1 \\ 0 \\ 0 \end{bmatrix}\right)\right)$$

$$= \begin{bmatrix} -L_1 c_2 \dot{\theta}_1^2 + L_1 s_2 \ddot{\theta}_1 + g s_{12} \\ L_1 s_2 \dot{\theta}_1^2 + L_1 c_2 \ddot{\theta}_1 + g c_{12} \\ 0 \end{bmatrix}$$

Propagate to centre of mass of link 2 (using ${}^{2}P_{C_2} = L_2 \hat{X}_2$):

$${}^{2}\dot{v}_{C_2} = {}^{2}\dot{v}_2 + \left({}^{2}\dot{\omega}_2 \times {}^{2}P_{C_2}\right) + \left({}^{2}\omega_2 \times \left({}^{2}\omega_2 \times {}^{2}P_{C_2}\right)\right) = \begin{bmatrix} -L_1 c_2 \dot{\theta}_1^2 + L_1 s_2 \ddot{\theta}_1 + g s_{12} - L_2 (\dot{\theta}_1 + \dot{\theta}_2)^2 \\ L_1 s_2 \dot{\theta}_1^2 + L_1 c_2 \ddot{\theta}_1 + g c_{12} + L_2 (\ddot{\theta}_1 + \ddot{\theta}_2) \\ 0 \end{bmatrix}$$

Net force and moment at link 2's centre of mass:

$${}^{2}F_2 = m_2\,{}^{2}\dot{v}_{C_2} = \begin{bmatrix} -m_2 L_1 c_2 \dot{\theta}_1^2 + m_2 L_1 s_2 \ddot{\theta}_1 + m_2 g s_{12} - m_2 L_2 (\dot{\theta}_1 + \dot{\theta}_2)^2 \\ m_2 L_1 s_2 \dot{\theta}_1^2 + m_2 L_1 c_2 \ddot{\theta}_1 + m_2 g c_{12} + m_2 L_2 (\ddot{\theta}_1 + \ddot{\theta}_2) \\ 0 \end{bmatrix}$$

$${}^{2}N_2 = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}$$

The outward iteration is complete.

### Inward Iteration

The end-effector is not in contact with the environment, so:

$${}^{3}f_3 = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}, \quad {}^{3}n_3 = \begin{bmatrix} 0 \\ 0 \\ 0 \end{bmatrix}$$

Force at the proximal end of link 2 (denote the components of ${}^{2}F_2$ as ${}^{2}F_{2x}$, ${}^{2}F_{2y}$, ${}^{2}F_{2z} = 0$ symbolically, to keep expressions compact):

$${}^{2}f_2 = \left({}^{2}_{3}R \cdot \underbrace{{}^{3}f_3}_{0}\right) + {}^{2}F_2 = \begin{bmatrix} {}^{2}F_{2x} \\ {}^{2}F_{2y} \\ 0 \end{bmatrix}$$

Moment at the proximal end of link 2 (with ${}^{2}P_{C_2} = L_2 \hat{X}_2$, ${}^{2}P_3 = L_2 \hat{X}_2$, ${}^{3}n_3 = 0$, ${}^{3}f_3 = 0$, ${}^{2}N_2 = 0$):

$${}^{2}n_2 = \left({}^{2}_{3}R \cdot \underbrace{{}^{3}n_3}_{0}\right) + \left({}^{2}P_{C_2} \times {}^{2}F_2\right) + \left({}^{2}P_3 \times \left({}^{2}_{3}R \cdot \underbrace{{}^{3}f_3}_{0}\right)\right) + \underbrace{{}^{2}N_2}_{0} = \begin{bmatrix} L_2 \\ 0 \\ 0 \end{bmatrix} \times \begin{bmatrix} {}^{2}F_{2x} \\ {}^{2}F_{2y} \\ 0 \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ L_2\,{}^{2}F_{2y} \end{bmatrix}$$

Force at the proximal end of link 1 (denote the components of ${}^{1}F_1$ as ${}^{1}F_{1x}$, ${}^{1}F_{1y}$):

$${}^{1}f_1 = \left({}^{1}_{2}R \cdot {}^{2}f_2\right) + {}^{1}F_1 = \begin{bmatrix} c_2 & -s_2 & 0 \\ s_2 & c_2 & 0 \\ 0 & 0 & 1 \end{bmatrix}\begin{bmatrix} {}^{2}F_{2x} \\ {}^{2}F_{2y} \\ 0 \end{bmatrix} + \begin{bmatrix} {}^{1}F_{1x} \\ {}^{1}F_{1y} \\ 0 \end{bmatrix} = \begin{bmatrix} c_2\,{}^{2}F_{2x} - s_2\,{}^{2}F_{2y} + {}^{1}F_{1x} \\ s_2\,{}^{2}F_{2x} + c_2\,{}^{2}F_{2y} + {}^{1}F_{1y} \\ 0 \end{bmatrix}$$

Moment at the proximal end of link 1 (with ${}^{1}P_{C_1} = L_1 \hat{X}_1$, ${}^{1}P_2 = L_1 \hat{X}_1$, ${}^{1}N_1 = 0$):

$${}^{1}n_1 = \left({}^{1}_{2}R \cdot {}^{2}n_2\right) + \left({}^{1}P_{C_1} \times {}^{1}F_1\right) + \left({}^{1}P_2 \times \left({}^{1}_{2}R \cdot {}^{2}f_2\right)\right) + \underbrace{{}^{1}N_1}_{0}$$

After computing each cross product and the rotation of ${}^{2}n_2$ into frame {1}, the third component is:

$${}^{1}n_1 = \begin{bmatrix} 0 \\ 0 \\ L_2\,{}^{2}F_{2y} + L_1\,{}^{1}F_{1y} + L_1\left(s_2\,{}^{2}F_{2x} + c_2\,{}^{2}F_{2y}\right) \end{bmatrix}$$

### Extracting Joint Torques

Both joints are revolute, so $\tau_i = {}^{i}n_i^T \cdot {}^{i}\hat{Z}_i$ — i.e. the third row of ${}^{i}n_i$.

For $\tau_2$:

$$\tau_2 = \text{3rd row of } {}^{2}n_2 = L_2\,{}^{2}F_{2y} = L_2\left(m_2 L_1 s_2 \dot{\theta}_1^2 + m_2 L_1 c_2 \ddot{\theta}_1 + m_2 g c_{12} + m_2 L_2 (\ddot{\theta}_1 + \ddot{\theta}_2)\right)$$

$$\tau_2 = m_2 L_1 L_2 s_2 \dot{\theta}_1^2 + m_2 L_1 L_2 c_2 \ddot{\theta}_1 + m_2 g L_2 c_{12} + m_2 L_2^2 (\ddot{\theta}_1 + \ddot{\theta}_2)$$

For $\tau_1$, substitute the explicit forms of ${}^{1}F_{1y}$, ${}^{2}F_{2x}$, ${}^{2}F_{2y}$ and simplify:

$$\tau_1 = \text{3rd row of } {}^{1}n_1 = L_2\,{}^{2}F_{2y} + L_1\,{}^{1}F_{1y} + L_1\left(s_2\,{}^{2}F_{2x} + c_2\,{}^{2}F_{2y}\right)$$

$$\tau_1 = m_2 L_2^2 (\ddot{\theta}_1 + \ddot{\theta}_2) + m_2 L_1 L_2 c_2 (2\ddot{\theta}_1 + \ddot{\theta}_2) + (m_1 + m_2) L_1^2 \ddot{\theta}_1 - m_2 L_1 L_2 s_2 \dot{\theta}_2^2 - 2 m_2 L_1 L_2 s_2 \dot{\theta}_1 \dot{\theta}_2 + m_2 g L_2 c_{12} + (m_1 + m_2) g L_1 c_1$$

---

## Structure of Manipulator Dynamics

The two joint torque expressions for the worked example can be matched onto the canonical form

$$M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau$$

by grouping terms multiplied by $\ddot{\theta}_j$ (mass matrix), terms quadratic in $\dot{\theta}$ (centrifugal/Coriolis), and gravity-only terms:

$$\underbrace{\begin{bmatrix} m_2 L_2^2 + 2 m_2 L_1 L_2 c_2 + (m_1 + m_2) L_1^2 & m_2 L_2^2 + m_2 L_1 L_2 c_2 \\ m_2 L_2^2 + m_2 L_1 L_2 c_2 & m_2 L_2^2 \end{bmatrix}}_{M(q)}\begin{bmatrix} \ddot{\theta}_1 \\ \ddot{\theta}_2 \end{bmatrix}$$

$$+ \underbrace{\underbrace{\begin{bmatrix} -m_2 L_1 L_2 s_2 \dot{\theta}_2^2 \\ m_2 L_1 L_2 s_2 \dot{\theta}_1^2 \end{bmatrix}}_{\text{Centrifugal}} + \underbrace{\begin{bmatrix} -2 m_2 L_1 L_2 s_2 \dot{\theta}_1 \dot{\theta}_2 \\ 0 \end{bmatrix}}_{\text{Coriolis}}}_{V(q,\dot{q})} + \underbrace{\begin{bmatrix} m_2 g L_2 c_{12} + (m_1 + m_2) g L_1 c_1 \\ m_2 g L_2 c_{12} \end{bmatrix}}_{G(q)} = \begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix}$$

This grouped form is useful for simulation (see the Simulation section).

---

## Inclusion of Friction Force

All mechanisms are affected by friction. The effect of friction on the manipulator's dynamics can be included as follows:

$$M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau - \tau_{\text{friction}}$$

It appears on the right-hand side with a minus sign because, intuitively, friction slows down the robot.

Several common friction models:

- **Viscous friction**: friction is proportional to velocity.

$$\tau_{\text{friction}} = k\dot{q}$$

The plot of viscous friction vs. speed is a straight line through the origin with positive slope $k$.

- **Coulomb friction**: friction is constant in magnitude but its sign depends on the sign of velocity.

$$\tau_{\text{friction}} = c \cdot \mathrm{sgn}(\dot{q})$$

The plot is a step function: $+c$ for positive speeds, $-c$ for negative speeds, jumping discontinuously through the origin.

- **Combined viscous + Coulomb**: a more accurate representation,

$$\tau_{\text{friction}} = c \cdot \mathrm{sgn}(\dot{q}) + k\dot{q}$$

The plot is two parallel sloped lines, offset by $\pm c$ from the origin.

More accurate models such as those including **Stribeck friction** (which adds a dip in friction at low non-zero speeds) exist but are not discussed further here.

---

## Manipulator Dynamics in Cartesian Space

### Motivation

Rather than asking how joint torques accelerate the links in joint space, we can ask how a force acting on the end-effector accelerates the robot in Cartesian space. This view is useful for force-control operations such as polishing, where the natural quantities of interest are end-effector force and end-effector motion in task space.

### Derivation

The dynamics in Cartesian space takes the form:

$$M_x(q)\ddot{x} + V_x(q,\dot{q}) + G_x(q) = F$$

This can be derived from the joint-space form $M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau$ using two facts from Jacobian analysis (Week 7):

- The relationship between end-effector force $F$ and joint torques $\tau$:

$$\tau = J^T(q)F \quad \text{or equivalently} \quad J^{-T}(q)\tau = F$$

- The relationship between joint velocities and end-effector velocity:

$$\dot{x} = J(q)\dot{q}$$

Premultiply the joint-space equation by $J^{-T}(q)$:

$$J^{-T}(q)M(q)\ddot{q} + J^{-T}(q)V(q,\dot{q}) + J^{-T}(q)G(q) = J^{-T}(q)\tau = F$$

Differentiating $\dot{x} = J(q)\dot{q}$:

$$\ddot{x} = \dot{J}(q)\dot{q} + J(q)\ddot{q} \quad \Rightarrow \quad \ddot{q} = J^{-1}(q)\ddot{x} - J^{-1}(q)\dot{J}(q)\dot{q}$$

Substituting back:

$$\underbrace{J^{-T} M(q) J^{-1}}_{M_x}\ddot{x} + \underbrace{J^{-T}\left(V(q,\dot{q}) - M(q) J^{-1}\dot{J}\dot{q}\right)}_{V_x} + \underbrace{J^{-T}G(q)}_{G_x} = F$$

### Use the End-Effector Jacobian

Rather than using ${}^{0}J_v$, it is advantageous to use the Jacobian with respect to the **end-effector frame** ${}^{e}J_v$. This is because we often want the force to act along a particular end-effector axis (e.g. the $\hat{Z}$ axis of the tool), regardless of the end-effector's current position and orientation. With ${}^{e}J_v$, the end-effector force $F$ is expressed directly in the tool frame.

${}^{e}J_v$ can be calculated from ${}^{0}J_v$ as:

$${}^{e}J_v = {}^{e}_{0}R \cdot {}^{0}J_v$$

### Cartesian-Space Worked Example (Two-Link Robot)

For the two-link example used earlier, the Jacobian with respect to the base frame is:

$${}^{0}J_v = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \end{bmatrix}$$

The Jacobian with respect to the end-effector frame:

$${}^{e}J_v = {}^{e}_{0}R \cdot {}^{0}J_v = \begin{bmatrix} c_{12} & s_{12} \\ -s_{12} & c_{12} \end{bmatrix}\begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \end{bmatrix} = \begin{bmatrix} L_1 s_2 & 0 \\ L_1 c_2 + L_2 & L_2 \end{bmatrix}$$

Its inverse:

$${}^{e}J_v^{-1} = \frac{1}{L_1 L_2 s_2}\begin{bmatrix} L_2 & 0 \\ -L_1 c_2 - L_2 & L_1 s_2 \end{bmatrix}$$

Its time derivative:

$${}^{e}\dot{J}_v = \begin{bmatrix} L_1 c_2 \dot{\theta}_2 & 0 \\ -L_1 s_2 \dot{\theta}_2 & 0 \end{bmatrix}$$

Substituting into the Cartesian dynamics formula yields:

$$M_x(q) = \begin{bmatrix} m_2 + \dfrac{m_1}{s_2^2} & 0 \\ 0 & m_2 \end{bmatrix}$$

$$V_x(q,\dot{q}) = \begin{bmatrix} -(m_2 L_1 c_2 + m_2 L_2)\dot{\theta}_1^2 - m_2 L_2 \dot{\theta}_2^2 - \left(2 m_2 L_2 + m_2 L_1 c_2 + m_1 L_1 \dfrac{c_2}{s_2^2}\right)\dot{\theta}_1 \dot{\theta}_2 \\ m_2 L_1 s_2 \dot{\theta}_1^2 + m_2 L_1 s_2 \dot{\theta}_1 \dot{\theta}_2 \end{bmatrix}$$

$$G_x(q) = \begin{bmatrix} m_1 g \dfrac{c_1}{s_2} + m_2 g s_{12} \\ m_2 g c_{12} \end{bmatrix}$$

---

## Inertia Tensor

### Motivation

The dynamics derivations above assumed the inertia tensor ${}^{C_i}I_i$ of each link is known. What is the inertia tensor, and how can we compute it from a link's geometry?

By analogy with $F = ma$: a small mass yields a large acceleration for a given force, while a large mass yields a small acceleration. Mass presents a "resistance" to linear motion.

For rotation about a single fixed axis, the **moment of inertia** plays the same role — a resistance to rotational motion. Its value depends on the shape and mass distribution of the object, and on the axis of rotation. (A solid cylinder spun about its symmetry axis presents a different moment of inertia than the same cylinder spun about a perpendicular axis through its centre, and a thin rectangular block spun about its long axis differs again.)

For a rigid body free to move in 3D, there are infinitely many possible rotation axes. The **inertia tensor** generalises the moment of inertia to handle all of them simultaneously.

### Definition

For one object, placing a frame $\{A\}$ at a particular location, the inertia tensor is:

$${}^{A}I = \begin{bmatrix} I_{xx} & -I_{xy} & -I_{xz} \\ -I_{xy} & I_{yy} & -I_{yz} \\ -I_{xz} & -I_{yz} & I_{zz} \end{bmatrix}$$

The elements are integrals over the body volume $V$ (where $\rho$ is the local density and $dV$ a differential volume element at position $(x,y,z)$ in frame $\{A\}$):

**Mass moments of inertia** (diagonal):

$$I_{xx} = \iiint_V (y^2 + z^2)\rho\,dV, \quad I_{yy} = \iiint_V (x^2 + z^2)\rho\,dV, \quad I_{zz} = \iiint_V (x^2 + y^2)\rho\,dV$$

**Mass products of inertia** (off-diagonal):

$$I_{xy} = \iiint_V xy\,\rho\,dV, \quad I_{xz} = \iiint_V xz\,\rho\,dV, \quad I_{yz} = \iiint_V yz\,\rho\,dV$$

### Principal Axes

The elements depend on the position and orientation of the frame:

- If the frame is at a "special" orientation, the products of inertia can be zero.
- In this case the axes of the frame are called **principal axes**, and the diagonal moments of inertia are called **principal moments of inertia**.

For manipulator dynamics, we put the frame at the centre of mass of each link, hence ${}^{C_i}I_i$.

### Worked Example: Inertia Tensor of a Rectangular Block

A rectangular block of length $l$, width $w$, height $h$, with a frame at the centre of the block (axes aligned with the edges):

$$I_{xx} = \iiint_V (y^2 + z^2)\rho\,dV = \int_{-h/2}^{h/2}\int_{-l/2}^{l/2}\int_{-w/2}^{w/2}(y^2 + z^2)\rho\,dx\,dy\,dz$$

$$= \int_{-h/2}^{h/2}\int_{-l/2}^{l/2}(y^2 + z^2) w \rho\,dy\,dz = \int_{-h/2}^{h/2}\left(\frac{l^3}{12} + z^2 l\right) w \rho\,dz$$

$$= \left(\frac{l^3 h}{12} + \frac{h^3 l}{12}\right)w\rho = \left(\frac{l^2}{12} + \frac{h^2}{12}\right)\underbrace{h l w \rho}_{m} = \frac{m}{12}(l^2 + h^2)$$

By symmetry:

$$I_{yy} = \frac{m}{12}(w^2 + h^2), \quad I_{zz} = \frac{m}{12}(w^2 + l^2)$$

For the product of inertia $I_{xy}$:

$$I_{xy} = \iiint_V xy\,\rho\,dV = \int_{-h/2}^{h/2}\int_{-l/2}^{l/2}\int_{-w/2}^{w/2} xy\,\rho\,dx\,dy\,dz = \int_{-h/2}^{h/2}\int_{-l/2}^{l/2}\left.\frac{x^2}{2}\right|_{x=-w/2}^{w/2} y\rho\,dy\,dz = 0$$

By symmetry, $I_{xz} = 0$ and $I_{yz} = 0$ as well.

The inertia tensor for the rectangular block with respect to a frame at its centre, with axes aligned with its edges, is:

$${}^{C}I = \begin{bmatrix} \dfrac{m}{12}(l^2 + h^2) & 0 & 0 \\ 0 & \dfrac{m}{12}(w^2 + h^2) & 0 \\ 0 & 0 & \dfrac{m}{12}(w^2 + l^2) \end{bmatrix}$$

---

## MATLAB Simulation

### Idea

The dynamics provide equations of motion for simulation and control design. The simulation question is: given joint torques, how does the robot move?

Starting from $M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau$, solve for the highest derivative:

$$\ddot{q} = M^{-1}(q)\bigl(\tau - V(q,\dot{q}) - G(q)\bigr)$$

### Time-Stepping Procedure

Given initial joint values $q_{T0}$, $\dot{q}_{T0}$:

1. Compute $M(q_{T0})$, $V(q_{T0},\dot{q}_{T0})$, $G(q_{T0})$.
2. With the input torque $\tau_{T0}$ at the initial instant, compute the joint acceleration:

$$\ddot{q}_{T0} = M^{-1}(q_{T0})\bigl(\tau_{T0} - V(q_{T0},\dot{q}_{T0}) - G(q_{T0})\bigr)$$

3. Assuming the acceleration is constant for a duration $T$ (the integration time step), the new velocity and position at the end of the step are:

$$\dot{q}_{T1} = \dot{q}_{T0} + \ddot{q}_{T0} T$$
$$q_{T1} = q_{T0} + \dot{q}_{T0} T + \tfrac{1}{2} \ddot{q}_{T0} T^2$$

4. Repeat: using $q_{T1}$, $\dot{q}_{T1}$, compute $M$, $V$, $G$ at the new state, get $\ddot{q}_{T1}$, advance to $q_{T2}$, $\dot{q}_{T2}$, and so on:

$$\ddot{q}_{T1} = M^{-1}(q_{T1})\bigl(\tau_{T1} - V(q_{T1},\dot{q}_{T1}) - G(q_{T1})\bigr)$$

$$\dot{q}_{T2} = \dot{q}_{T1} + \ddot{q}_{T1} T$$
$$q_{T2} = q_{T1} + \dot{q}_{T1} T + \tfrac{1}{2} \ddot{q}_{T1} T^2$$

This is implemented as a `for` loop.

### Two-Link Robot Simulation in MATLAB

Using the canonical two-link form derived earlier:

$$\underbrace{\begin{bmatrix} m_2 L_2^2 + 2 m_2 L_1 L_2 c_2 + (m_1 + m_2) L_1^2 & m_2 L_2^2 + m_2 L_1 L_2 c_2 \\ m_2 L_2^2 + m_2 L_1 L_2 c_2 & m_2 L_2^2 \end{bmatrix}}_{M(q)}\begin{bmatrix} \ddot{\theta}_1 \\ \ddot{\theta}_2 \end{bmatrix} + V(q,\dot{q}) + G(q) = \begin{bmatrix} \tau_1 \\ \tau_2 \end{bmatrix}$$

**Robot parameters and torque arrays:**

```matlab
%%%%%%%%%%%%%%%%%%%%
% Robot Parameters %
%%%%%%%%%%%%%%%%%%%%

m1 = 3;   % kg
m2 = 2;   % m
L1 = 3;   % kg
L2 = 2;   % m
g = 9.8;  % m/s^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Torque Arrays and Time Interval %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tau1 = ones(10000,1)*0.1;    % constant torque with value = multiplier
Tau2 = ones(10000,1)*0.1;    % constant torque with value = multiplier
T = 1e-3;                    % time interval for integration
```

<!-- suspected-source-error: the inline comments on `m2`, `L1`, `L2` swap units (`m`/`kg`) between mass and length variables relative to the variable names. Transcribed verbatim from slide 72. -->

**Initial conditions and result arrays:**

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Conditions %
%%%%%%%%%%%%%%%%%%%%%%%%

q1 = 0;     % joint 1 angle
q1Dot = 0;  % joint 1 angular velocity
q2 = 0;     % joint 2 angle
q2Dot = 0;  % joint 2 angular velocity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Acceleration and Update Positions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1DoubleDotRecord = [];
q2DoubleDotRecord = [];
q1DotRecord = [];
q2DotRecord = [];
q1Record = [];
q2Record = [];
```

**Main loop — compute $M$, $V$, $G$ for the current state, then accelerations, then update velocity and position:**

```matlab
for i=1:length(Tau1)

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate M, V, G %
    %%%%%%%%%%%%%%%%%%%%%%%%

    m11 = m2*L2^2 + 2*m2*L1*L2*cos(q2) + (m1+m2)*L1^2;
    m12 = m2*L2^2 + m2*L1*L2*cos(q2);
    m21 = m12;
    m22 = m2*L2^2;
    M = [m11,m12;m21,m22];

    v1 = -m2*L1*L2*sin(q2)*q2Dot^2 - 2*m2*L1*L2*sin(q2)*q1Dot*q2Dot;
    v2 = m2*L1*L2*sin(q2)*q1Dot^2;
    V = [v1;v2];

    g1 = m2*g*L2*cos(q1+q2) + (m1+m2)*g*L1*cos(q1);
    g2 = m2*g*L2*cos(q1+q2);
    G = [g1;g2];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Acceleration %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    qDoubleDot = inv(M)*([Tau1(i);Tau2(i)]-V-G);
    q1DoubleDot = qDoubleDot(1);
    q2DoubleDot = qDoubleDot(2);

    q1DoubleDotRecord = [q1DoubleDotRecord;q1DoubleDot];
    q2DoubleDotRecord = [q2DoubleDotRecord;q2DoubleDot];

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Velocity %
    %%%%%%%%%%%%%%%%%%%%%%%%

    q1Dot = q1Dot + q1DoubleDot*T;
    q2Dot = q2Dot + q2DoubleDot*T;

    q1DotRecord = [q1DotRecord;q1Dot];
    q2DotRecord = [q2DotRecord;q2Dot];

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Position %
    %%%%%%%%%%%%%%%%%%%%%%%%

    q1 = q1 + q1Dot*T + 1/2*q1DoubleDot*T^2;
    q2 = q2 + q2Dot*T + 1/2*q2DoubleDot*T^2;

    q1Record = [q1Record;q1];
    q2Record = [q2Record;q2];

end
```

**Animate the robot motion using forward kinematics:**

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%
% Show Robot Motion %
%%%%%%%%%%%%%%%%%%%%%%%%

x1 = L1*cos(q1Record);              % These are kinematic
y1 = L1*sin(q1Record);              % equation of the
x2 = x1 + L2*cos(q1Record+q2Record); % 2 link robot
y2 = y1 + L2*sin(q1Record+q2Record);

for i = 1:100:length(x1)    % Plot every 100th data
    clf;             % Clear figure before new plot
    plot([0 x1(i)],[0 y1(i)]);
    axis([-(L1+L2+0.2) (L1+L2+0.2) -(L1+L2+0.2) (L1+L2+0.2)]);
    hold on,plot([x1(i) x2(i)],[y1(i) y2(i)]);
    pause(0.1);
end
```

Running the code produces an animation of the two-link robot falling and swinging under gravity and the constant joint torques. The torque array can be changed (e.g. to a sinusoid) to see different responses.

---

## Tutorial Questions

### Question 1

Find the inertia tensor of a right cylinder of homogeneous density, with respect to a frame with origin at the centre of mass of the body.

### Question 2

Consider the robot shown with:

$${}^{C_1}I_1 = \begin{bmatrix} I_{xx1} & 0 & 0 \\ 0 & I_{yy1} & 0 \\ 0 & 0 & I_{zz1} \end{bmatrix}, \quad {}^{C_2}I_2 = \begin{bmatrix} I_{xx2} & 0 & 0 \\ 0 & I_{yy2} & 0 \\ 0 & 0 & I_{zz2} \end{bmatrix}$$

Derive its dynamic equations.

The robot is an RP manipulator in a vertical plane (gravity $g$ acts downward in the figure): joint 1 is revolute with angle $\theta_1$, joint 2 is prismatic with displacement $d_2$. Link 1 has mass $m_1$ at distance $L_1$ from joint 1 along the link; link 2 has mass $m_2$ at the prismatic-joint tip, distance $d_2$ from joint 1 along the same link direction.

<!-- transcription-audit:
- Dropped: title slide (page 1) — boilerplate (lecturer name, email, module code). Title preserved as the H1.
- Dropped: module schedule table (page 2) — administrative, not content. Week 9 row highlighted in the source but identical info is in the title.
- Dropped: agenda/"Content" slides (pages 3, 4, 12, 41, 45, 54, 64, 79) — table of contents; the document headings serve this role.
- Dropped: closing "Thank you for your attention!" slide (page 82) — boilerplate.
- Dropped: decorative manipulator illustrations on pages 5, 11, 46 — content is captured in the prose.
- Dropped: red mass-spring-damper diagram on page 6 — decorative; the equation is what carries information.
- Dropped: two-configuration manipulator sketch on page 7 — illustrative aid for "perceived inertia"; prose captures the point.
- Dropped: Coriolis Wikipedia figure on page 8 — decorative; attribution to Hubi / Wikimedia commons not preserved (drop per attribution-link rule).
- Dropped: gravity configuration diagrams on page 10 — illustrative; prose captures the two cases (horizontal vs vertical link).
- Dropped: schematic arrows on pages 15-18 (acceleration/velocity propagation arrows along a chain) — these are aids to the recursive narrative, dissolved into prose in the "Strategy of the Newton-Euler Recursion" section.
- Dropped: small red sketches on pages 23, 56 (cylinder/cube rotation axes for moment of inertia) — illustrative, prose captures the dependence on shape and axis.
- Dropped: three end-effector tool poses cartoon on page 49 — illustrative aid for "force always along end-effector z-axis"; prose preserved.
- Dropped: frame-with-volume-element sketch on page 57 — illustrative.
- Dropped: four robot-pose snapshots on pages 65 and 78 — animation thumbnails; prose mentions the animation outcome.
- Dropped: rectangular-block sketch repeated on pages 60-63 — single mention sufficient.
- Multi-slide unit collapsed: pages 6-11 ("Manipulator's Dynamic Equations (1)..(6)") fused into a single subsection on the canonical form. Pages 13-21 (Newton-Euler basic ideas + recursion summary) fused into the "Newton-Euler Formulation" section with one heading for ideas and one for the recursion equations. Pages 23-38 (the two-link worked example, sub-numbered 10 outward + 6 inward + 2 extraction slides) fused into one structured "Worked Example" section. Pages 46-53 (Cartesian dynamics 1-3 + example 1-4) fused.
- Warnings: none.
- Suspected source errors:
  1. Slide 72 MATLAB code comments — unit annotations `% m` and `% kg` are swapped between length and mass variables. Flagged inline. (Code itself runs correctly; only the comments are wrong.)
  2. Slide 12 agenda lists the upcoming section as "Inclusion of Non-Rigid Body Effects", but every later ToC (pages 41, 45, 54, 64, 79) and the section heading on page 42 call it "Inclusion of Friction Force". The slide-12 title is a stale title from an earlier deck revision (likely when joint flexibility / backlash was once covered). Since the transcript drops all ToC slides per policy, this inconsistency is only noted here.
- All Newton-Euler recursion equations, the two-link `τ_1, τ_2` final answers (slides 37–38), `M(q)` symmetry, the Cartesian dynamics derivation `M_x = J^{-T} M J^{-1}`, the inertia-tensor definition with leading negative on off-diagonals, and the rectangular-block worked example were independently verified on a second pass — all consistent with Craig Chapter 6.
- Ambiguities: in slide 25 the source writes ${}^{1}\omega_1 = ({}^{1}_{0}R \cdot {}^{0}\omega_0) + (\dot\theta_1 \cdot {}^{1}\hat Z_1) = (\dot\theta_1 \cdot {}^{1}\hat Z_1)$ before showing the column-vector result; this is a trivial restatement of the same equation, collapsed in transcript. Slide 22 uses notation `${}^{0}\dot v_0 = G$` where `G` here is the gravity-direction vector (magnitude $g$, opposite to gravity), unrelated to the gravity term `G(q)` of the dynamics; clarified in prose.
-->

# Control of Manipulators

## Introduction

In trajectory planning we discussed the trajectory that the robot is required to follow. In this lecture we study how to control the robot (or joints) so that they follow the desired trajectory.

Two different techniques are available:

1. **Individual-joint control.** The nonlinear, coupled manipulator is approximated as a few linear and decoupled joints/links, and each joint is controlled individually. The structure is

   ```
   x_target → J^{-1} → q_target,i → (−) → Ctrl → Joint i → q_i
                                      ↑________________________|
   ```

   one such loop per joint $i = 1, \dots, n$.

2. **Complete-manipulator control.** The manipulator is viewed as a whole; joint readings are taken as a vector and the control signal is generated also as a vector. Performance is better because the nonlinearities and coupling are taken into consideration.

   ```
   x_target → J^{-1} → q_target → (−) → Ctrl → [Joint 1 … Joint n] → q
                                    ↑__________________________________|
   ```

The lecture builds the individual-joint case first (for its simplicity), then generalises to the complete manipulator.

## Second-Order Linear Systems

### Mass-spring system (frictionless)

A mass $m$ attached to a spring of stiffness $k$ on a frictionless surface, with equilibrium at $x = 0$. If the mass is perturbed and released, it oscillates indefinitely.

Newton's second law gives

$$m\ddot{x} = \sum \text{forces} = -kx \quad\Rightarrow\quad m\ddot{x} + kx = 0.$$

Solving this differential equation:

$$x = C_1 \cos\!\left(\sqrt{\tfrac{k}{m}}\,t\right) + C_2 \sin\!\left(\sqrt{\tfrac{k}{m}}\,t\right),$$

where $\omega_n = \sqrt{k/m}$ is the **natural frequency**.

### Mass-spring-damper system

Now add viscous friction $b$ (a damper). The surface is no longer frictionless; equilibrium is still $x = 0$. Perturbing and releasing the mass produces one of **three responses** depending on $m,\, b,\, k$: overdamped, underdamped, or critically damped.

The governing ODE is

$$m\ddot{x} = -b\dot{x} - kx \quad\Rightarrow\quad m\ddot{x} + b\dot{x} + kx = 0.$$

Its **characteristic equation** is

$$m\lambda^2 + b\lambda + k = 0,$$

with roots

$$\lambda_1 = \frac{-b + \sqrt{b^2 - 4mk}}{2m}, \qquad \lambda_2 = \frac{-b - \sqrt{b^2 - 4mk}}{2m}.$$

#### Overdamped response

If $b^2 > 4mk$ the roots are real and unequal. The general solution is

$$x(t) = c_1 e^{\lambda_1 t} + c_2 e^{\lambda_2 t}.$$

The mass returns to equilibrium ($x=0$) very slowly, monotonically.

#### Underdamped response

If $b^2 < 4mk$ the roots are complex,

$$\lambda_{1,2} = \frac{-b \pm \sqrt{b^2 - 4mk}}{2m} = p \pm qi.$$

The general solution is

$$x(t) = c_1 e^{p t} \cos(qt) + c_2 e^{p t} \sin(qt),$$

an oscillatory response with decaying amplitude.

#### Critically damped response

If $b^2 = 4mk$ the roots are real and equal,

$$\lambda_{1,2} = \lambda = \frac{-b}{2m}.$$

The general solution is

$$x(t) = (c_1 + c_2 t) e^{\lambda t}.$$

The system reaches equilibrium rapidly and without oscillation — **the highly desirable response**.

### Determining $c_1$ and $c_2$ from initial conditions

The general solutions contain two parameters $c_1$ and $c_2$, determined from the initial conditions of the system.

**Worked example.** Mass-spring-damper with $m = 1$, $b = 5$, $k = 6$, released from rest at $x = -1$.

Since $b^2 = 25 > 24 = 4mk$, the roots are real and unequal:

$$\lambda_1 = \frac{-5 + \sqrt{25 - 24}}{2} = -2, \qquad \lambda_2 = \frac{-5 - \sqrt{25 - 24}}{2} = -3.$$

The general solution and its derivative are

$$x(t) = c_1 e^{-2t} + c_2 e^{-3t}, \qquad \dot{x}(t) = -2 c_1 e^{-2t} - 3 c_2 e^{-3t}.$$

Applying the initial conditions:

$$x(0) = c_1 + c_2 = -1, \qquad \dot{x}(0) = -2 c_1 - 3 c_2 = 0.$$

Solving: $c_1 = -3$, $c_2 = 2$, so

$$x(t) = -3 e^{-2t} + 2 e^{-3t}.$$

## Control of Second-Order Linear Systems

### Control of a pure mass

A mass on a frictionless surface is driven by a force $F$ towards a desired position. Designing $F$ to be **proportional to $x$ and $\dot{x}$** makes the controlled system behave like a mass-spring-damper.

Newton's law: $m\ddot{x} = F$. Choose

$$F = -k_v \dot{x} - k_p x.$$

The closed-loop equation is

$$m\ddot{x} + k_v \dot{x} + k_p x = 0,$$

which has the same form as the natural mass-spring-damper system with $b \leftrightarrow k_v$, $k \leftrightarrow k_p$.

<!-- suspected-source-error: slide 25 writes the equivalence as "$m\ddot x + k_v \dot x + k_p x = 0  \leftrightarrow  m\ddot x + b\dot x + bx = 0$" — the stiffness term on the right-hand side is `bx`, which is a typo for `kx`. The intended mapping is `k_v ↔ b` (damping) and `k_p ↔ k` (stiffness). Corrected silently in the prose above ("$b \leftrightarrow k_v, k \leftrightarrow k_p$"); raised here so a reader comparing to the PDF doesn't get confused. -->

To obtain the critically damped response (preferred), choose

1. any $k_p$ according to the **desired stiffness** of the system, then
2. $k_v$ from $k_v^2 = 4 m k_p$, i.e. $k_v = 2\sqrt{m k_p}$.

### Control of a mass-spring-damper

Now the plant already has natural parameters $m, b, k$, but their ratio is not of critical damping (e.g. $b$ too small so the response is oscillatory). A force $F$ is again applied to obtain a critically damped response.

Newton's law: $m\ddot{x} = -b\dot{x} - kx + F$. Choose $F = -k_v \dot{x} - k_p x$. Closed loop:

$$m\ddot{x} + (b + k_v)\dot{x} + (k + k_p) x = 0.$$

To obtain critically damped response:

1. Set $k_p$ such that $(k + k_p)$ matches the desired stiffness of the system.
2. Calculate $k_v$ from $(b + k_v)^2 = 4 m (k + k_p)$, i.e.

   $$k_v = 2\sqrt{m(k + k_p)} - b.$$

### PD controller and its implementation

The control law $F = -k_v \dot{x} - k_p x$ is implemented by a sensor that measures $x$ and $\dot{x}$, feeding a controller block that drives an actuator. This is the **Proportional-Derivative (PD) controller**.

```
[Sensor: measures x, ẋ] ──► [Controller: −k_v ẋ − k_p x] ──► [Actuator] ──F──► plant (m, b, k)
              ▲                                                                       │
              └───────────────────── feedback ────────────────────────────────────────┘
```

## Control Law Partitioning

### Motivation

Without partitioning, $k_v$ and $k_p$ must be changed whenever the system dynamics $(m, b, k)$ change. We can make $k_v$ and $k_p$ **independent of the system parameters** by splitting the controller into two portions:

- A **model-based compensator** that cancels off the system dynamics and reduces the system to a unit mass.
- A **servo controller** in which $k_v$ and $k_p$ are independent of $m, b, k$.

### Procedure (for a scalar second-order plant)

Given system dynamics

$$m\ddot{x} + b\dot{x} + kx = F,$$

design the **model-based compensator** as

$$F = m\underline{f} + b\dot{x} + kx,$$

where $\underline{f}$ is the (yet-to-be-designed) servo command. Substituting reduces the system to a **unit mass**:

$$\ddot{x} = f.$$

Then design the **servo portion** as

$$f = -k_v \dot{x} - k_p x,$$

where $k_p$ determines the stiffness and $k_v = 2\sqrt{k_p}$ (note: no $m$ inside the square root because the inner plant is now unit mass).

### Closed-loop equation

$$\begin{aligned}
m\ddot{x} + b\dot{x} + kx &= F \\
&= m f + b\dot{x} + kx \\
&= m\bigl(-k_v \dot{x} - k_p x\bigr) + b\dot{x} + kx.
\end{aligned}$$

The system thus reduces to

$$\ddot{x} + k_v \dot{x} + k_p x = 0,$$

which, with the choice $k_v = 2\sqrt{k_p}$, gives a critically damped response with stiffness $k_p$.

### Worked example

Given $m = 10$, $b = 20$, $k = 10$. Find gains $k_v, k_p$ so that the system becomes critically damped with stiffness of 16.

- System: $10\ddot{x} + 20\dot{x} + 10 x = F$.
- Model-based compensator: $F = 10\underline{f} + 20\dot{x} + 10 x$.
- Servo controller: $f = -k_v \dot{x} - k_p x$.
- Let $k_p = 16$.
- Then $k_v = 2\sqrt{16} = 8$.

### Implementation block diagram

```
[Sensor: measures x, ẋ]
              │
              ├──► [Model:  bẋ + kx ]──────────┐
              │                                 ▼
              └──► [Servo: −k_v ẋ − k_p x]─f─►[ ×m ]──►(+)──►[Actuator]──F──► plant (m, b, k)
              ▲                                                                     │
              └───────────────────────── feedback ──────────────────────────────────┘
```

The control-law partitioning technique will be used for **all subsequent control design in this lecture**.

### Why is this still a PD controller?

Expanding the actual force,

$$\begin{aligned}
F &= m\bigl(-k_v \dot{x} - k_p x\bigr) + b\dot{x} + kx \\
  &= (-m k_v + b)\dot{x} + (-m k_p + k)x.
\end{aligned}$$

The controller is still a PD-type controller in terms of $x$ and $\dot{x}$ — the control-law partitioning technique merely makes the **design** of those PD gains much easier.

## Trajectory Following

### Regulation to a non-zero position

So far we have only stabilised the mass at $x_d = 0$. To move it to a different position $x_d \neq 0$, think of the natural mass-spring-damper as having its wall (and hence equilibrium) offset by $x_d$: the equilibrium of the spring shifts to $x_d$, so the mass moves there.

Mathematically:

$$m\ddot{x} = -b\dot{x} - k\,\underline{(x - x_d)}.$$

To achieve regulation using control, follow the partitioned design:

- System: $m\ddot{x} + b\dot{x} + kx = F$.
- Model-based compensator: $F = m\underline{f} + b\dot{x} + kx$.
- Servo controller: $f = -k_v \dot{x} - k_p\,\underline{(x - x_d)}$.
- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Trajectory following

Same idea, but now the target keeps moving — $x_d = x_d(t)$, with $\dot{x}_d(t)$ and $\ddot{x}_d(t)$ also available from the trajectory plan.

- System: $m\ddot{x} + b\dot{x} + kx = F$.
- Model-based compensator: $F = m\underline{f} + b\dot{x} + kx$.
- Servo controller:

  $$f = \underline{\ddot{x}_d} - k_v\bigl(\underline{\dot{x} - \dot{x}_d}\bigr) - k_p\bigl(\underline{x - x_d}\bigr).$$

- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Why this works — closed-loop tracking error

Substituting the design into the plant:

$$\begin{aligned}
m\ddot{x} + b\dot{x} + kx &= F = m f + b\dot{x} + kx \\
&= m\bigl(\ddot{x}_d - k_v(\dot{x} - \dot{x}_d) - k_p(x - x_d)\bigr) + b\dot{x} + kx.
\end{aligned}$$

This simplifies to

$$(\ddot{x}_d - \ddot{x}) + k_v(\dot{x}_d - \dot{x}) + k_p(x_d - x) = 0.$$

Defining the **tracking error** $e = x_d - x$, the closed-loop equation becomes

$$\ddot{e} + k_v \dot{e} + k_p e = 0,$$

the same form as in the regulation case. Since $e$ decays to zero, $x$ tracks $x_d$ eventually.

## Modelling and Control of a Single Joint

### Joint model overview

Each joint has an **electrical** part (a DC motor) and a **mechanical** part (shaft, gear, load). The electrical part creates a torque on the mechanical part; the mechanical part also induces a back EMF on the electrical part.

Components (Craig-style picture):

- Armature circuit: resistance $R_a$, inductance $L_a$, armature current $I_a$, applied voltage $V_a$, back-EMF $V_{emf}$.
- Motor side: inertia $I_m$, motor-side friction $b_m\dot{\theta}_m$, motor torque $\tau_m$, motor angle $\theta_m$.
- Gear pair with radii $r_1$ (motor side) and $r_2$ (load side); contact force $F$ between the gears.
- Load side: inertia $I$, load-side viscous friction $b\dot{\theta}$, load torque $\tau$, load angle $\theta$.
- Gear ratio $\eta$ relates the two sides.

### Electrical equations

For a permanent-magnet DC motor, the torque produced is proportional to armature current,

$$\tau_m = k_m i_a,$$

where $k_m$ is the **torque constant** of the motor. The back EMF is proportional to rotor speed,

$$V_{emf} = k_e \dot{\theta}_m,$$

where $k_e$ is the **electrical constant** of the motor.

KVL around the armature circuit:

$$L_a \frac{di_a}{dt} + R_a i_a = V_a - V_{emf} = V_a - k_e \dot{\theta}_m.$$

**Assumption: the armature inductance $L_a$ is negligible**, giving the algebraic relation

$$R_a i_a = V_a - k_e \dot{\theta}_m.$$

### Mechanical equations and gear coupling

From free-body analysis: the motor-side gear pushes the load-side gear with a contact force $F$; the load-side gear creates an equal-and-opposite reaction on the motor-side gear.

**Motor-side dynamics:**

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - F r_1. \tag{1}$$

**Load-side dynamics:**

$$I \ddot{\theta} = F r_2 - b \dot{\theta}. \tag{2}$$

Define the load-side torque

$$\tau = F r_2. \tag{3}$$

Then (2) becomes

$$I\ddot{\theta} = \tau - b\dot{\theta} \quad\Rightarrow\quad \tau = I\ddot{\theta} + b\dot{\theta}. \tag{4}$$

From (3), $F = \tau / r_2$, so (1) becomes

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - \frac{r_1}{r_2}\tau. \tag{5}$$

Substituting (4) into (5):

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - \frac{r_1}{r_2}\bigl(I \ddot{\theta} + b \dot{\theta}\bigr). \tag{6}$$

### Reduction to load-side variables

Define the **gear ratio**

$$\eta = \frac{r_2}{r_1}. \tag{7}$$

The gear ratio increases the torque seen at the load but reduces the load speed:

$$\tau = \eta \tau_m, \tag{8}$$
$$\dot{\theta} = \frac{1}{\eta}\dot{\theta}_m \quad(\text{equivalently } \ddot{\theta}_m = \eta\ddot{\theta},\ \dot{\theta}_m = \eta\dot{\theta}). \tag{9}$$

Substituting (7)–(9) into (6):

$$I_m \eta \ddot{\theta} = \frac{1}{\eta}\tau - b_m \eta \dot{\theta} - \frac{1}{\eta}\bigl(I\ddot{\theta} + b\dot{\theta}\bigr).$$

Rearranging gives the **load-side joint model**:

$$\bigl(I + I_m \eta^2\bigr)\ddot{\theta} + \bigl(b + b_m \eta^2\bigr)\dot{\theta} = \tau. \tag{10}$$

This has the same form as $m\ddot{x} + b\dot{x} + kx = F$ (with no stiffness term, since there is no spring-like restoring torque on a free joint) and will be used directly for control design.

### Control of a single joint (control-law partitioning)

Summary of the load dynamics:

$$(I + I_m \eta^2)\ddot{\theta} + (b + b_m \eta^2)\dot{\theta} = \tau.$$

Apply control-law partitioning for trajectory following with desired joint angle $\theta_d(t)$:

- Model-based compensator:

  $$\tau = (I + I_m \eta^2)\underline{f} + (b + b_m \eta^2)\dot{\theta}.$$

- Servo controller:

  $$f = \underline{\ddot{\theta}_d} - k_v\bigl(\underline{\dot{\theta} - \dot{\theta}_d}\bigr) - k_p\bigl(\underline{\theta - \theta_d}\bigr).$$

- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Translating load-side torque to motor voltage

The control law above computes the required load-side torque $\tau$. The motor must actually produce it. Using $\tau = \eta \tau_m$, the required motor-side torque is

$$\tau_m = \frac{1}{\eta}\tau.$$

Since $\tau_m = k_m i_a$, the required armature current follows; and since $R_a i_a = V_a - k_e \dot{\theta}_m$, the controller commands the corresponding **armature voltage** $V_a$.

### Lab demonstration

Single-joint control was demonstrated on a 1-DOF arm driving a load disc through a gear, with three controller tunings showing overdamped, underdamped, and critically damped responses respectively; a fourth video showed the same individual-joint scheme applied to both joints of the 2-DOF arm.

<!-- transcription-warning: slides 57–60 are still frames from demonstration videos showing the physical setup (a 2-link arm driven by a National Instruments-branded controller, with a metal load disc). The information content is the qualitative response category (overdamped / underdamped / critically damped / two-joint operation), which is preserved above; the visual setup itself carries no further technical detail. -->

## Modelling and Control of the Complete Manipulator

### Why individual-joint control is insufficient

The individual-joint analysis assumed that (i) each joint is independent of the others and (ii) the inertia seen by each joint actuator is constant. Neither holds for a real manipulator: the joints/links are highly coupled and the inertia (and other) matrices are **not** constant. For example, a 2-link planar arm presents large inertia about joint 1 when the second link is extended outward and small inertia when the second link is folded back.

Applying a fixed linear controller therefore yields undesirable results — e.g. the damping is **not uniform throughout the workspace**.

### Multi-input-multi-output partitioned control

Treat the robot as a MIMO system. With the manipulator dynamic model (from the dynamics lecture)

$$M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau,$$

design the **model-based compensator** as

$$\tau = M(q)\,\underline{f} + V(q,\dot{q}) + G(q),$$

which decouples all the individual joint dynamics to

$$\ddot{q} = f, \qquad \text{or}\qquad \begin{bmatrix}\ddot{q}_1 \\ \ddot{q}_2 \\ \vdots\end{bmatrix} = \begin{bmatrix} f_1 \\ f_2 \\ \vdots\end{bmatrix}.$$

The **servo controller** $f$ is then designed component-wise as

$$f = \ddot{q}_d - K_v(\dot{q} - \dot{q}_d) - K_p(q - q_d),$$

where $K_v$ and $K_p$ are (typically diagonal) matrices. Explicitly:

$$\begin{bmatrix} f_1 \\ f_2 \\ f_3 \\ \vdots \end{bmatrix}
=
\begin{bmatrix} \ddot{q}_{d1} \\ \ddot{q}_{d2} \\ \ddot{q}_{d3} \\ \vdots \end{bmatrix}
-
\begin{bmatrix}
k_{v1} & 0 & 0 & \cdots \\
0 & k_{v2} & 0 & \cdots \\
0 & 0 & k_{v3} & \cdots \\
\vdots & \vdots & \vdots & \ddots
\end{bmatrix}
\begin{bmatrix} \dot{q}_1 - \dot{q}_{d1} \\ \dot{q}_2 - \dot{q}_{d2} \\ \dot{q}_3 - \dot{q}_{d3} \\ \vdots \end{bmatrix}
-
\begin{bmatrix}
k_{p1} & 0 & 0 & \cdots \\
0 & k_{p2} & 0 & \cdots \\
0 & 0 & k_{p3} & \cdots \\
\vdots & \vdots & \vdots & \ddots
\end{bmatrix}
\begin{bmatrix} q_1 - q_{d1} \\ q_2 - q_{d2} \\ q_3 - q_{d3} \\ \vdots \end{bmatrix}.$$

The model-based compensator cancels off the robot's dynamics and decouples each joint; the servo controllers are then designed for each joint individually using the scalar critical-damping rules above.

## MATLAB Simulation

We now combine the previously-written code that (a) simulated robot motion under pre-set torques and (b) generated trajectories, but here the pre-set torques are replaced by **torques computed by the controller**. The complete-manipulator approach is used (the full robot model is available). The trajectory is planned in Cartesian space, so inverse kinematics is required at each step; equivalently one could plan directly in joint space.

### Robot and control parameters

```matlab
%%%%%%%%%%%%%%%%%%%%%%
% Robot Parameters %
%%%%%%%%%%%%%%%%%%%%%%

m1 = 3;   % kg
m2 = 2;   % m
L1 = 3;   % kg
L2 = 2;   % m
g  = 9.8; % m/s^2

%%%%%%%%%%%%%%%%%%%%%%%%
% Control Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%

Kp = diag([100 100]);                       % diagonal matrix Kp
Kv = diag([2*sqrt(100) 2*sqrt(100)]);       % diagonal matrix Kv
                                            % Critical damping. You may try other values
                                            % to see different responses.
```

<!-- suspected-source-error: slide 71 labels m2 with the unit "m" and L1 with the unit "kg"; these are clearly transposed (m2 should be kg, L1 should be m). Transcribed verbatim from the source. -->

### Boundary conditions and time array

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions       %
% Must be within Workspace  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = 2; % x initial
y0 = 3; % y initial
xf = 4; % x target
yf = 1; % y target
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%%%
% Create Time Array   %
%%%%%%%%%%%%%%%%%%%%%%%%

T = 1e-3;     % time interval for integration
t = 0:T:tf;   % array of time from 0 to tf in steps of 0.001
t = t';       % make the time array into column vector
```

### Quintic trajectory for x

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial for x %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a0 = x0;
a1 = 0;
a2 = 0;
a3 = 10/tf^3*(xf-x0);
a4 = -15/tf^4*(xf-x0);
a5 = 6/tf^5*(xf-x0);

xQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
xDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
xDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('x Quintic')
subplot(1,3,1), plot(t,xQuintic), title('Position')
subplot(1,3,2), plot(t,xDotQuintic), title('Velocity')
subplot(1,3,3), plot(t,xDoubleDotQuintic), title('Acceleration')
```

### Quintic trajectory for y

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial for y %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a0 = y0;
a1 = 0;
a2 = 0;
a3 = 10/tf^3*(yf-y0);
a4 = -15/tf^4*(yf-y0);
a5 = 6/tf^5*(yf-y0);

yQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
yDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
yDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('y Quintic')
subplot(1,3,1), plot(t,yQuintic), title('Position')
subplot(1,3,2), plot(t,yDotQuintic), title('Velocity')
subplot(1,3,3), plot(t,yDoubleDotQuintic), title('Acceleration')
```

### Inverse kinematics at each step

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Kinematics at Each Step %
% See notes of Geometrical Method  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(t)
    theta2Quintic(i) = acos((xQuintic(i)^2 + yQuintic(i)^2 - L1^2 - L2^2)/(2*L1*L2));
    beta  = atan2(yQuintic(i), xQuintic(i));
    psi   = acos((L1^2 + xQuintic(i)^2 + yQuintic(i)^2 - L2^2) / ...
                 (2*L1*sqrt(xQuintic(i)^2 + yQuintic(i)^2)));
    theta1Quintic(i) = beta - psi;
end

figure, sgtitle('Theta Quintic')
subplot(1,2,1), plot(t,theta1Quintic), title('Theta 1')
subplot(1,2,2), plot(t,theta2Quintic), title('Theta 2')
```

### Robot initial conditions and recording arrays

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robot Initial Conditions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1    = theta1Quintic(1);   % joint 1 angle
q1Dot = 0;                  % joint 1 angular velocity
q2    = theta2Quintic(1);   % joint 2 angle
q2Dot = 0;                  % joint 2 angular velocity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable Declaration and Memory Placeholder %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1DoubleDotRecord = [];
q2DoubleDotRecord = [];
q1DotRecord       = [];
q2DotRecord       = [];
q1Record          = [];
q2Record          = [];
q1dot = 0;
q2dot = 0;
```

### Main simulation loop — robot dynamics, control, integration

```matlab
for i = 1:length(t)

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate M, V, G %
    %%%%%%%%%%%%%%%%%%%%%%

    m11 = m2*L2^2 + 2*m2*L1*L2*cos(q2) + (m1+m2)*L1^2;
    m12 = m2*L2^2 + m2*L1*L2*cos(q2);
    m21 = m12;
    m22 = m2*L2^2;
    M   = [m11, m12; m21, m22];

    v1 = -m2*L1*L2*sin(q2)*q2Dot^2 - 2*m2*L1*L2*sin(q2)*q1Dot*q2Dot;
    v2 =  m2*L1*L2*sin(q2)*q1Dot^2;
    V  = [v1; v2];

    g1 = m2*g*L2*cos(q1+q2) + (m1+m2)*g*L1*cos(q1);
    g2 = m2*g*L2*cos(q1+q2);
    G  = [g1; g2];

    %%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Control  %
    %%%%%%%%%%%%%%%%%%%%%%%

    servoControl = -Kv*[q1dot; q2dot] - Kp*[q1 - theta1Quintic(i); q2 - theta2Quintic(i)];
    % Note velocity and acceleration trajectory are set as zero
    % Because we are doing regulation, not trajectory tracking

    modelControl = M*servoControl + V + G;

    Tau1(i) = modelControl(1);
    Tau2(i) = modelControl(2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Acceleration  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    qDoubleDot = inv(M) * ([Tau1(i); Tau2(i)] - V - G);
    q1DoubleDot = qDoubleDot(1);
    q2DoubleDot = qDoubleDot(2);

    q1DoubleDotRecord = [q1DoubleDotRecord; q1DoubleDot];
    q2DoubleDotRecord = [q2DoubleDotRecord; q2DoubleDot];

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate Velocity %
    %%%%%%%%%%%%%%%%%%%%%%

    q1Dot = q1Dot + q1DoubleDot*T;
    q2Dot = q2Dot + q2DoubleDot*T;

    q1DotRecord = [q1DotRecord; q1Dot];
    q2DotRecord = [q2DotRecord; q2Dot];

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate Position %
    %%%%%%%%%%%%%%%%%%%%%%

    q1 = q1 + q1Dot*T + 1/2*q1DoubleDot*T^2;
    q2 = q2 + q2Dot*T + 1/2*q2DoubleDot*T^2;

    q1Record = [q1Record; q1];
    q2Record = [q2Record; q2];
end
```

The servo command uses only the position error (the desired velocity and acceleration terms have been omitted), so this is **regulation along a sequence of set points**, not true trajectory tracking — as noted in the inline comment. Note also the case-sensitivity bug flagged below: the velocity-feedback term is silently dead too, so the displayed simulation is effectively **proportional-only**.

<!-- suspected-source-error: slide 78 has two distinct problems with the controller.
  (a) Missing feedforward — `servoControl` uses only position error, dropping the `q̈_d − K_v(q̇_d − q̇)` terms from the partitioned-control law derived earlier (f = q̈_d + K_v(q̇_d − q̇) + K_p(q_d − q)). The slide's own inline comment acknowledges this and frames it as regulation.
  (b) Case-sensitivity bug NOT acknowledged on the slide. The variables `q1dot, q2dot` (lowercase, used in `servoControl` line 626) are initialised to 0 on lines 595–596 and **never updated anywhere**. The velocity that *is* integrated each loop iteration is `q1Dot, q2Dot` (capital D, lines 581/583, 650/651). MATLAB identifiers are case-sensitive, so the velocity-feedback term in the controller is **permanently zero** for the entire simulation. Combined with (a), the simulation runs a pure proportional controller, not the PD partitioned controller the lecture is illustrating.
  Code transcribed verbatim from the slide so a reader cross-checking against the PDF sees the same listing. Do not propagate this MATLAB snippet to your own implementations without correcting both issues. -->

### Visualisation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%
% Show Robot Motion   %
%%%%%%%%%%%%%%%%%%%%%%%%

x1 = L1*cos(q1Record);                          % These are kinematic
y1 = L1*sin(q1Record);                          % equation of the
x2 = x1 + L2*cos(q1Record + q2Record);          % 2 link robot
y2 = y1 + L2*sin(q1Record + q2Record);

figure
for i = 1:100:length(x1)        % Plot every 100th data
    clf;                        % Clear figure before new plot
    plot([0 x1(i)], [0 y1(i)]);
    axis([-(L1+L2+0.2) (L1+L2+0.2) -(L1+L2+0.2) (L1+L2+0.2)]);
    hold on, plot([x1(i) x2(i)], [y1(i) y2(i)]);
    hold on, plot(x0, y0, 'xr');
    hold on, plot(xf, yf, 'xr');
    pause(0.1);
end
```

The animation shows the 2-link planar arm reaching from the initial point $(x_0, y_0)$ to the target $(x_f, y_f)$ inside a workspace bounded approximately by $\pm(L_1 + L_2)$.

## Tutorial Questions

**Question 1.** Determine the motion of a mass-spring-damper system if $m = 2$, $b = 6$, $k = 4$, and the mass (initially at rest) is released from position $x = 1$.

**Question 2.** Determine the motion of a mass-spring-damper system if $m = 1$, $b = 2$, $k = 1$, and the mass (initially at rest) is released from position $x = 4$.

**Question 3.** Determine the motion of a mass-spring-damper system if $m = 1$, $b = 4$, $k = 5$, and the mass (initially at rest) is released from position $x = 2$.

**Question 4.** Give the nonlinear control equations for the system

$$\bigl(2\sqrt{\theta} + 1\bigr)\ddot{\theta} + 3\dot{\theta}^2 - \sin(\theta) = \tau.$$

Choose gains so that this system is always critically damped with closed-loop stiffness of 10.

**Question 5.** Design a trajectory-following control system for a system with the following dynamic equations:

$$\begin{aligned}
m_1 l_1^2 \ddot{\theta}_1 + m_1 l_1 l_2 \dot{\theta}_1 \dot{\theta}_2 &= \tau_1, \\
m_2 l_2^2\bigl(\ddot{\theta}_1 + \ddot{\theta}_2\bigr) + v_2 \dot{\theta}_2 &= \tau_2.
\end{aligned}$$

Additional question: what is wrong with this robot model?

<!-- transcription-audit:
- Dropped: title slide (p.1), schedule table (p.2), table-of-contents recap slides (p.3, 4, 8, 22, 30, 37, 44, 61, 68, 83), and closing "Thank you" slide (p.89) — boilerplate / navigation.
- Dropped: decorative red-blob arm illustrations on the introduction slides (p.5) — purely illustrative of trajectory-following intent.
- Dropped: per-slide page numbers and the "(1)/(2)/(3)..." subtitle suffixes throughout; consecutive build-up slides were merged into single logical sections (e.g. the 10-slide "Modeling of a Single Joint" sequence became one derivation; the 14-slide MATLAB walkthrough became one annotated script).
- Warnings: pages 57–60 are still photos extracted from demo videos (single-joint arm with NI controller). The qualitative response label (over/under/critically damped, both joints) is preserved; the underlying dynamic behaviour is not recoverable from still frames and would require the original videos to fully transcribe.
- Suspected source errors:
  1. Slide 25 (Control of a Mass): the equivalence "$m\ddot x + k_v \dot x + k_p x = 0 \leftrightarrow m\ddot x + b\dot x + \mathbf{b}x = 0$" mistypes the stiffness term as `bx` rather than `kx`. **Silently corrected** in the closed-loop equation immediately above the mapping `$b \leftrightarrow k_v, k \leftrightarrow k_p$`; inline `<!-- suspected-source-error -->` flag added.
  2. Slide 71: MATLAB Robot Parameters block labels `m2` with unit "m" and `L1` with unit "kg" — units transposed.
  3. Slide 78: TWO problems with the simulation controller —
     (a) Missing feedforward (zero velocity/acceleration target terms in `servoControl`). The slide's own inline comment frames this as "regulation, not trajectory tracking".
     (b) **Case-sensitivity bug not acknowledged on the slide.** Lowercase `q1dot, q2dot` (used in `servoControl`) are initialised to 0 and never updated; the actually-integrated velocity is `q1Dot, q2Dot` (capital D). Since MATLAB identifiers are case-sensitive, the velocity-feedback term in the controller is permanently zero — the simulation runs proportional-only, not the PD partitioned controller the lecture is teaching. The MATLAB listing is transcribed verbatim; the inline flag warns readers not to propagate the code as-is.
- Ambiguities:
  - The deck mixes scalar notation $x$ (mass-spring-damper) and $\theta$ (joint angle) for the same generic second-order plant; the transcript keeps both, following the slide that introduces each formula.
  - The "stiffness of 16 / stiffness of 10" in the worked examples and Q4 is interpreted as the closed-loop $k_p$ in $\ddot{e} + k_v\dot{e} + k_p e = 0$ (so $\omega_n = \sqrt{k_p}$), per the slide deck's usage.
- Ingestion: native multimodal — diagrams, circuit pictures, equations, and code blocks all directly perceivable.
-->
