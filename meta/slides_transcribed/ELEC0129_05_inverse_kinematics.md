> Source: [ELEC0129\_05\_inverse\_kinematics.pdf](../slides_original/ELEC0129_05_inverse_kinematics.pdf)

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
