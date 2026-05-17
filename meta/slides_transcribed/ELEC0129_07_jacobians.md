> Source: [ELEC0129\_07\_jacobians.pdf](../slides_original/ELEC0129_07_jacobians.pdf)

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
