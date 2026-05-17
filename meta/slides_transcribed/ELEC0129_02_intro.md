> Source: [ELEC0129\_02\_intro.pdf](../slides_original/ELEC0129_02_intro.pdf)

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
