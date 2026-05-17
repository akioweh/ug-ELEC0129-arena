> Source: [ELEC0129\_09\_dynamics.pdf](../slides_original/ELEC0129_09_dynamics.pdf)

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
