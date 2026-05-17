> Source: [ELEC0129\_04\_forward\_kinematics.pdf](../slides_original/ELEC0129_04_forward_kinematics.pdf)

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
