# ELEC0129 — Study Formula Sheet

Everything you have to **remember** for the in-person closed-book exam — i.e. the union of (lecture content) ∖ (official Formula\_Sheet.pdf). The official sheet's formulae are supplied inline as question hints; the formulae below are **not**, so commit them to memory.

Conventions:

- $c\cdot \equiv \cos$, $s\cdot \equiv \sin$, $v\cdot \equiv 1 - \cos$ (versine); $c_i \equiv \cos\theta_i$, $s_{12} \equiv \sin(\theta_1+\theta_2)$.
- Frames: ${}^{A}P$, ${}^{A}_{B}R$, ${}^{A}_{B}T$ (Craig). Modified DH throughout.
- $\operatorname{atan2}(y, x)$ returns the four-quadrant angle of the point $(x, y)$.

---

## 1. Spatial Description and Transformation (W2 + W3)

### Elementary rotation matrices

$$R_x(\theta) = \begin{bmatrix} 1 & 0 & 0 \\ 0 & c\theta & -s\theta \\ 0 & s\theta & c\theta \end{bmatrix},\quad R_y(\theta) = \begin{bmatrix} c\theta & 0 & s\theta \\ 0 & 1 & 0 \\ -s\theta & 0 & c\theta \end{bmatrix},\quad R_z(\theta) = \begin{bmatrix} c\theta & -s\theta & 0 \\ s\theta & c\theta & 0 \\ 0 & 0 & 1 \end{bmatrix}.$$

(Only $R_y$ has the $+s\theta$ in the top-right corner; the other two follow the $\cos\ {-}\sin\ /\ \sin\ \cos$ pattern.)

### Rotation matrix is orthonormal

Columns and rows are mutually orthonormal, so $R^{-1} = R^T$ and $\det(R) = +1$.

$${}^{B}_{A}R = {}^{A}_{B}R^{-1} = {}^{A}_{B}R^{T}.$$

### Mapping a point between frames (rotation + translation)

$${}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}.$$

### Homogeneous transformation matrix (block form)

$${}^{A}_{B}T = \begin{bmatrix} {}^{A}_{B}R & {}^{A}P_{Borg} \\ 0\;0\;0 & 1 \end{bmatrix}\quad (4\times 4).$$

Apply via $\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix} = {}^{A}_{B}T \cdot \begin{bmatrix} {}^{B}P \\ 1 \end{bmatrix}$.

### HTM inverse — closed form (do NOT do a generic 4×4 inverse)

$${}^{A}_{B}T^{-1} = {}^{B}_{A}T = \begin{bmatrix} {}^{A}_{B}R^{T} & -\,{}^{A}_{B}R^{T}\,{}^{A}P_{Borg} \\ 0\;0\;0 & 1 \end{bmatrix}.$$

### Chained transforms

$${}^{0}_{n}T = {}^{0}_{1}T \cdot {}^{1}_{2}T \cdots {}^{n-1}_{n}T,\qquad {}^{0}P = {}^{0}_{n}T \cdot {}^{n}P.$$

To peel off one factor, left-multiply by its inverse. "Inner" sub/superscripts cancel pairwise.

### Composition rule — fixed vs. moving axes

- **Fixed-axis (extrinsic) rotations** about reference-frame axes: each new rotation **pre-multiplies** (write right-to-left in the order applied).
- **Moving-axis (intrinsic / Euler) rotations** about the body's current axes: each new rotation **post-multiplies** (write left-to-right in the order applied).
- **Equivalence:** XYZ fixed angles $(\gamma, \beta, \alpha)$ produce the **same** ${}^{A}_{B}R$ as ZYX Euler angles $(\alpha, \beta, \gamma)$.

### XYZ Fixed Angles (≡ ZYX Euler) — parameters → matrix

Rotate about $X$ by $\gamma$, then $Y$ by $\beta$, then $Z$ by $\alpha$ (all about fixed axes):

$${}^{A}_{B}R = R_Z(\alpha)\,R_Y(\beta)\,R_X(\gamma) = \begin{bmatrix} c\alpha\,c\beta & c\alpha\,s\beta\,s\gamma - s\alpha\,c\gamma & c\alpha\,s\beta\,c\gamma + s\alpha\,s\gamma \\ s\alpha\,c\beta & s\alpha\,s\beta\,s\gamma + c\alpha\,c\gamma & s\alpha\,s\beta\,c\gamma - c\alpha\,s\gamma \\ -s\beta & c\beta\,s\gamma & c\beta\,c\gamma \end{bmatrix}.$$

### XYZ Fixed (≡ ZYX Euler) — matrix → parameters

$$\beta = \operatorname{atan2}\!\Bigl(-r_{31},\;\pm\sqrt{r_{11}^{2}+r_{21}^{2}}\Bigr),\qquad \alpha = \operatorname{atan2}\!\Bigl(\tfrac{r_{21}}{c\beta},\tfrac{r_{11}}{c\beta}\Bigr),\qquad \gamma = \operatorname{atan2}\!\Bigl(\tfrac{r_{32}}{c\beta},\tfrac{r_{33}}{c\beta}\Bigr).$$

**Singularity** at $c\beta = 0$ ($\beta = \pm 90°$): gimbal lock — only $\alpha \pm \gamma$ is recoverable.

### Angle-axis (Rodrigues) — $(\hat K, \theta) \to R$ is ON the sheet. Recovery is NOT:

$$\theta = \arccos\!\frac{r_{11}+r_{22}+r_{33}-1}{2},\qquad \hat K = \frac{1}{2\sin\theta}\begin{bmatrix} r_{32}-r_{23} \\ r_{13}-r_{31} \\ r_{21}-r_{12} \end{bmatrix}.$$

- $\arccos$ returns $\theta \in [0°, 180°]$; the pair $(\hat K, \theta)$ and $(-\hat K, -\theta)$ describe the same rotation.
- Axis formula fails when $\sin\theta = 0$: at $\theta = 0$ axis is arbitrary; at $\theta = \pi$, read $k_i^2 = (r_{ii}+1)/2$ from the diagonal and fix signs from off-diagonals $r_{ij} = 2\,k_i k_j$.

### Euler parameters — definition (link to angle-axis)

$$\varepsilon_1 = k_x \sin\!\tfrac{\theta}{2},\quad \varepsilon_2 = k_y \sin\!\tfrac{\theta}{2},\quad \varepsilon_3 = k_z \sin\!\tfrac{\theta}{2},\quad \varepsilon_4 = \cos\!\tfrac{\theta}{2};\qquad \varepsilon_1^2+\varepsilon_2^2+\varepsilon_3^2+\varepsilon_4^2 = 1.$$

The $R(\varepsilon)$ matrix is on the official sheet.

### Euler parameters — matrix → parameters

**Primary:**

$$\varepsilon_4 = \tfrac{1}{2}\sqrt{1 + r_{11}+r_{22}+r_{33}},\quad \varepsilon_1 = \frac{r_{32}-r_{23}}{4\varepsilon_4},\quad \varepsilon_2 = \frac{r_{13}-r_{31}}{4\varepsilon_4},\quad \varepsilon_3 = \frac{r_{21}-r_{12}}{4\varepsilon_4}.$$

**Alternative** (if $\varepsilon_4 = 0$): for the diagonal entry of axis $i$,

$$\varepsilon_i = \tfrac{1}{2}\sqrt{1 + r_{ii} - r_{jj} - r_{kk}}.$$

---

## 2. Forward Kinematics (W4)

### Modified-DH parameter definitions (memorise the four)

| Parameter | Definition |
|---|---|
| $a_{i-1}$ (link length) | distance from $\hat Z_{i-1}$ to $\hat Z_i$ measured **along $\hat X_{i-1}$** |
| $\alpha_{i-1}$ (link twist) | angle from $\hat Z_{i-1}$ to $\hat Z_i$ measured **about $\hat X_{i-1}$** (RHR) |
| $d_i$ (link offset) | distance from $\hat X_{i-1}$ to $\hat X_i$ measured **along $\hat Z_i$** |
| $\theta_i$ (joint angle) | angle from $\hat X_{i-1}$ to $\hat X_i$ measured **about $\hat Z_i$** (RHR) |

For a **revolute** joint $\theta_i$ is variable, all others constant. For a **prismatic** joint $d_i$ is variable, all others constant. Both $a$ and $\alpha$ are always constants.

### Frame-attachment recipe (memorise the steps)

1. Draw all joint axes. In modified DH, $\hat Z_i$ is along the axis of joint $i$ (so link $i-1$ has its two endpoint joints $\hat Z_{i-1}$ and $\hat Z_i$, and its DH constants are subscripted $i-1$). Standard DH numbers them off by one — don't confuse the conventions.
2. Common perpendicular from $\hat Z_{i-1}$ to $\hat Z_i$ defines $\hat X_{i-1}$. Special cases: parallel → any convenient; intersecting → out-of-plane direction free; collinear → arbitrary.
3. $\hat Y$ completes the right-handed triad.
4. $\{0\} = \{1\}$ at the zero-configuration. $\{n\}$: $\hat X_n$ aligned with $\hat X_{n-1}$ at the zero of the $n$-th joint variable.
5. Read off the four DH parameters per link; write the DH table with columns $i,\ \alpha_{i-1},\ a_{i-1},\ d_i,\ \theta_i$.

A constant offset from frame $\{n\}$ to the end-effector does **not** appear in the DH table — handle it as a fixed ${}^{n}P_e$.

### The link transform ${}^{i-1}_{i}T$ is ON the sheet, but its four-factor decomposition is not:

$${}^{i-1}_{i}T = R_x(\alpha_{i-1})\,D_x(a_{i-1})\,R_z(\theta_i)\,D_z(d_i).$$

### Chain and end-effector

$${}^{0}_{n}T = \prod_{i=1}^{n} {}^{i-1}_{i}T,\qquad {}^{0}P_e = {}^{0}_{n}T \cdot {}^{n}P_e.$$

---

## 3. Inverse Kinematics (W5) — **none** of this is on the sheet

### Existence, multiplicity, redundancy

- **Reachable workspace:** all points reachable by some orientation.
- **Dexterous workspace:** subset where multiple orientations are achievable. Workspace boundary → only one orientation.
- A 6-DOF arm is the **minimum** to place position + orientation arbitrarily. More than 6 DOF → **redundant**, infinitely many IK solutions.
- 3-link planar RRR: 2 solutions (elbow-up / elbow-down). PUMA: 8 solutions (4 arm configs × 2 wrist flips).
- **Wrist flip** (memorise verbatim):

$$\theta_4' = \theta_4 + 180°,\qquad \theta_5' = -\theta_5,\qquad \theta_6' = \theta_6 + 180°.$$

### Closed-form solution methods (no general algorithm)

Geometric (planar only) and algebraic. Three algebraic techniques:

1. **Square-and-sum** — square pairs of position equations and add to kill cross terms / leave one unknown.
2. **Trigonometric substitution** — given $K_1\,c_\theta - K_2\,s_\theta = c$ and $K_1\,s_\theta + K_2\,c_\theta = s$, set $r = \sqrt{K_1^2 + K_2^2}$, $\gamma = \operatorname{atan2}(K_2, K_1)$; then $\theta = \operatorname{atan2}(s/r,\ c/r) - \gamma$. Existence requires $|c| \le r$.
3. **Isolation pattern** — pre-multiply the desired transform by inverses of the head transforms one at a time; equate constant entries on each side to peel off one joint variable at a time.

### Geometric solution — 3-link planar RRR (memorise verbatim)

Given target $(x, y, \phi)$ with link lengths $L_1, L_2, L_3$:

$$\theta_2 = \arccos\!\frac{x^2 + y^2 - L_1^2 - L_2^2}{2 L_1 L_2}\quad (\text{elbow-down}\ +,\ \text{elbow-up}\ -).$$

$$\beta = \operatorname{atan2}(y, x),\qquad \cos\psi = \frac{L_1^2 + x^2 + y^2 - L_2^2}{2 L_1 \sqrt{x^2 + y^2}}.$$

$$\theta_1 = \beta - \psi\ (\text{elbow-down}),\qquad \theta_1' = \beta + \psi\ (\text{elbow-up}).$$

$$\theta_3 = \phi - \theta_1 - \theta_2.$$

### Algebraic solution — 3-link planar RRR (template; reuse the technique)

From ${}^{0}_{3}T$ vs. desired pose, four scalar equations:

$$c_\phi = c_{123},\quad s_\phi = s_{123},\quad x = L_1 c_1 + L_2 c_{12},\quad y = L_1 s_1 + L_2 s_{12}.$$

**Step 1 — square-and-sum on $x, y$:**

$$c_2 = \frac{x^2 + y^2 - L_1^2 - L_2^2}{2 L_1 L_2},\qquad s_2 = \pm\sqrt{1 - c_2^2},\qquad \theta_2 = \operatorname{atan2}(s_2, c_2).$$

**Step 2 — trig substitution for $\theta_1$:** set $K_1 = L_1 + L_2 c_2$, $K_2 = L_2 s_2$, $r = \sqrt{K_1^2 + K_2^2}$, $\gamma = \operatorname{atan2}(K_2, K_1)$:

$$\theta_1 = \operatorname{atan2}\!\bigl(y/r,\ x/r\bigr) - \gamma.$$

**Step 3:** $\theta_3 = \operatorname{atan2}(s_\phi, c_\phi) - \theta_1 - \theta_2$.

---

## 4. Jacobians (W7) — velocity propagation IS on the sheet; the rest is not

### Direct differentiation (linear Jacobian only)

Generalised joint coord $q_i = \theta_i$ (revolute) or $d_i$ (prismatic). With ${}^{0}P = [f_x, f_y, f_z]^T(q)$,

$$\dot{\boldsymbol x} = J_v(\boldsymbol q)\,\dot{\boldsymbol q},\qquad (J_v)_{kj} = \frac{\partial f_k}{\partial q_j}.$$

The Jacobian is linear in $\dot q$ but time-varying in $q$.

### Kinematic singularity

Configurations where $J(q)$ loses rank — end-effector loses an instantaneous Cartesian DOF. At/near a singularity, $\dot q = J^{-1} v$ blows up for the lost direction.

For a square Jacobian: singular $\iff \det(J) = 0$.

**Worked example to remember:** 2-link planar arm, $\det(J_v) = L_1 L_2 \sin\theta_2$. Singular at $\theta_2 = k\pi$ (arm fully stretched or fully folded).

**Spherical wrist:** axes 4 and 6 collinear → the third orientation DOF (rotation about an axis *perpendicular* to the collinear pair) is lost. NOT "rotation about the collinear axis" — that one is retained (redundantly).

### Jacobian frame transform

$${}^{e}J_v = {}^{e}_{0}R \cdot {}^{0}J_v.$$

Use the end-effector-frame Jacobian when forces/velocities are naturally expressed along tool axes.

### Static-force duality (memorise)

$$\boldsymbol{\tau} = J^{T}(\boldsymbol q)\,\boldsymbol{F}.$$

Linear-only form. With end-effector moments, use the full $6\times n$ Jacobian and a 6-vector wrench $\mathcal F = [F_x, F_y, F_z, n_x, n_y, n_z]^T$.

At a singularity, certain external forces require zero joint torque — **mechanical advantage**.

---

## 5. Trajectory Planning (W8) — only LSPB is on the sheet

### Straight line (jerky — for completeness)

$$u(t) = \frac{u_f - u_0}{t_f}\, t + u_0,\quad t \in [0, t_f].$$

Velocity discontinuous at boundaries.

### Cubic polynomial (zero $\dot u$ at boundaries)

$$u(t) = a_0 + a_1 t + a_2 t^2 + a_3 t^3.$$

$$\boxed{\,a_0 = u_0,\ \ a_1 = 0,\ \ a_2 = \frac{3}{t_f^{2}}(u_f - u_0),\ \ a_3 = -\frac{2}{t_f^{3}}(u_f - u_0).\,}$$

$\ddot u(0), \ddot u(t_f) \ne 0$ in general → acceleration discontinuity at boundaries.

### Quintic polynomial (zero $\dot u$ AND zero $\ddot u$ at boundaries)

$$u(t) = a_0 + a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5.$$

$$\boxed{\,a_0 = u_0,\ a_1 = 0,\ a_2 = 0,\ a_3 = \frac{10}{t_f^{3}}(u_f - u_0),\ a_4 = -\frac{15}{t_f^{4}}(u_f - u_0),\ a_5 = \frac{6}{t_f^{5}}(u_f - u_0).\,}$$

### LSPB — supporting formulae (the piecewise & $t_b, u_b$ are on the sheet)

- Symmetry: $u_h = (u_0 + u_f)/2$, $t_h = t_f/2$.
- **Existence condition (memorise):** for a real $t_b$, need

$$\boxed{\,\ddot u \ge \frac{4(u_f - u_0)}{t_f^{2}}.\,}$$

- The supplied $t_b$ formula uses the minus-sign branch because $t_b \le t_f/2$.

### Cartesian vs. joint-space trajectories

| Aspect | Cartesian-space | Joint-space |
|---|---|---|
| Specify | $x(t), y(t), z(t), r_x(t),\ldots$ | $\theta_1(t), \theta_2(t), \ldots$ |
| Geometric path | enforceable (e.g. straight line) | not enforceable (no linearity in task space) |
| Cost per step | IK at every time step | none — direct to controller |
| Singularity / workspace pitfalls | yes | no |

---

## 6. Manipulator Dynamics (W9) — N-E and inertia tensor are on the sheet

### Canonical joint-space form

$$\boxed{\,M(q)\,\ddot q + V(q,\dot q) + G(q) = \tau.\,}$$

- $M(q)$: $n\times n$ symmetric positive-definite mass matrix (configuration-dependent "perceived inertia").
- $V(q, \dot q)$: $n\times 1$ velocity-product term (Coriolis + centrifugal). Zero if $\dot q = 0$ or if $M(q)$ is constant.
- $G(q)$: $n\times 1$ gravity vector.
- $\tau$: joint generalised forces — torque for revolute, force for prismatic.

### Newton's and Euler's laws (the building blocks)

$$F = m\,a;\qquad N = {}^{C}I\,\dot\omega + \omega \times \bigl({}^{C}I\,\omega\bigr).$$

### Gravity trick

Set ${}^{0}\dot v_0 = G$ where $G$ has magnitude $g$ and **points opposite to gravity**. Gravity is then automatically propagated by the outward N-E iteration.

### Friction models

Enter the dynamics as $\tau - \tau_{\text{friction}} = M(q)\ddot q + V(q,\dot q) + G(q)$.

- Viscous: $\tau_f = k\,\dot q$ (linear, through origin).
- Coulomb: $\tau_f = c\,\operatorname{sgn}(\dot q)$ (step at the origin).
- Combined: $\tau_f = c\,\operatorname{sgn}(\dot q) + k\,\dot q$.

### End-effector Jacobian for Cartesian dynamics

$${}^{e}J_v = {}^{e}_{0}R \cdot {}^{0}J_v\quad\text{(reuse from W7).}$$

### Common inertia tensors (centre-of-mass frame aligned with symmetry axes)

These are integrals you'd otherwise have to redo:

**Rectangular block** of dimensions $l \times w \times h$ (length along $x$, width along $y$, height along $z$):

$${}^{C}I = \frac{m}{12}\operatorname{diag}\bigl(l^2 + h^2,\ w^2 + h^2,\ w^2 + l^2\bigr).$$

(Each $I_{ii}$ lacks the squared length along its **own** axis — its lever arms are the other two.)

**Solid cylinder**, radius $r$, height $h$, axis along $z$:

$${}^{C}I = \operatorname{diag}\!\Bigl(\tfrac{m}{12}(3r^2 + h^2),\ \tfrac{m}{12}(3r^2 + h^2),\ \tfrac{m}{2}r^2\Bigr).$$

**Thin rod**, length $L$ along $x$: $I_{xx} = 0,\ I_{yy} = I_{zz} = mL^2/12$.

**Solid sphere**, radius $r$: $I_{ii} = \tfrac{2}{5} m r^2$ on every diagonal.

**Point mass at distance $r$** from axis: $I = m r^2$ about that axis.

**Parallel-axis theorem** (when you need to shift the frame off the C.O.M. by displacement $d$):

$$I_{\text{new axis}} = I_{\text{C.O.M.}} + m\,d^2.$$

### Simulation update (Euler integration, constant-acceleration assumption per step)

$$\ddot q_k = M^{-1}(q_k)\bigl(\tau_k - V(q_k,\dot q_k) - G(q_k)\bigr),\quad \dot q_{k+1} = \dot q_k + \ddot q_k\,T,\quad q_{k+1} = q_k + \dot q_k T + \tfrac{1}{2}\ddot q_k T^2.$$

---

## 7. Manipulator Control (W10) — **none** of this is on the sheet

### Mass-spring-damper homogeneous ODE

$$m\ddot x + b\dot x + k x = 0;\qquad m\lambda^2 + b\lambda + k = 0;\qquad \lambda = \frac{-b\pm\sqrt{b^2 - 4mk}}{2m}.$$

Natural frequency $\omega_n = \sqrt{k/m}$.

### The three damping cases (memorise)

| Case | Condition | Roots | Solution |
|---|---|---|---|
| Overdamped | $b^2 > 4mk$ | real, distinct $\lambda_1, \lambda_2 < 0$ | $x = c_1 e^{\lambda_1 t} + c_2 e^{\lambda_2 t}$ |
| Critically damped | $b^2 = 4mk$ | real, equal $\lambda = -b/(2m)$ | $x = (c_1 + c_2 t)\, e^{\lambda t}$ |
| Underdamped | $b^2 < 4mk$ | complex $p \pm qi$ | $x = e^{p t}(c_1 \cos qt + c_2 \sin qt)$ |

Critical damping is the **target response** for a controller (fast, no overshoot).

$c_1, c_2$ fixed by initial conditions $x(0), \dot x(0)$.

### Critical-damping design rule

For closed-loop $m\ddot x + k_v \dot x + k_p x = 0$, critical damping requires

$$\boxed{\,k_v = 2\sqrt{m\,k_p}.\,}$$

For a unit-mass plant (after partitioning), $k_v = 2\sqrt{k_p}$.

### PD control on a pure mass ($m\ddot x = F$)

$$F = -k_v \dot x - k_p x\ \Longrightarrow\ m \ddot x + k_v \dot x + k_p x = 0.$$

### PD on a mass-spring-damper ($m\ddot x + b\dot x + k x = F$)

Closed-loop coefficients add: $m\ddot x + (b + k_v)\dot x + (k + k_p) x = 0$. To hit critical damping at desired stiffness $(k + k_p)$:

$$k_v = 2\sqrt{m\,(k + k_p)} - b.$$

### Control-law partitioning (use throughout)

Given $m\ddot x + b\dot x + k x = F$:

- **Model-based compensator:** $F = m\,f + b\,\dot x + k\,x$ (reduces plant to unit mass $\ddot x = f$).
- **Servo controller (regulation to $0$):** $f = -k_v \dot x - k_p x$, with $k_v = 2\sqrt{k_p}$.
- **Servo controller (regulation to $x_d \ne 0$):** $f = -k_v \dot x - k_p (x - x_d)$.
- **Servo controller (trajectory tracking):** $f = \ddot x_d - k_v(\dot x - \dot x_d) - k_p(x - x_d)$ — feedforward + error feedback.

Tracking-error closed-loop dynamics (memorise):

$$\boxed{\,\ddot e + k_v \dot e + k_p e = 0,\quad e \equiv x_d - x.\,}$$

### Single-joint DC motor model

Electrical (with $L_a$ negligible):

$$\tau_m = k_m\,i_a,\qquad V_{\text{emf}} = k_e\,\dot\theta_m,\qquad R_a\,i_a = V_a - k_e\,\dot\theta_m.$$

Mechanical with gear ratio $\eta = r_2 / r_1$:

$$\tau = \eta\,\tau_m,\qquad \dot\theta = \dot\theta_m / \eta\quad (\Leftrightarrow\ \dot\theta_m = \eta\,\dot\theta).$$

**Load-side joint dynamics** (memorise — has the $m\ddot x + b\dot x = F$ shape):

$$\boxed{\,\bigl(I + I_m \eta^{2}\bigr)\ddot\theta + \bigl(b + b_m \eta^{2}\bigr)\dot\theta = \tau.\,}$$

### MIMO partitioned control of the complete manipulator

Plant: $M(q)\ddot q + V(q, \dot q) + G(q) = \tau$.

- **Model-based compensator:** $\tau = M(q)\,f + V(q, \dot q) + G(q)$ → decouples to $\ddot q = f$.
- **Servo controller (trajectory tracking):**

$$\boxed{\,f = \ddot q_d - K_v\,(\dot q - \dot q_d) - K_p\,(q - q_d),\,}$$

with $K_p, K_v$ diagonal. Per-joint critical damping: $k_{v,i} = 2\sqrt{k_{p,i}}$.

---

## 8. General Math Primer

### Cross product (3D)

$$\boldsymbol a \times \boldsymbol b = \det\begin{bmatrix} \hat i & \hat j & \hat k \\ a_1 & a_2 & a_3 \\ b_1 & b_2 & b_3 \end{bmatrix} = \begin{bmatrix} a_2 b_3 - a_3 b_2 \\ a_3 b_1 - a_1 b_3 \\ a_1 b_2 - a_2 b_1 \end{bmatrix}.$$

Properties:

$$\boldsymbol a \times \boldsymbol b = -\boldsymbol b \times \boldsymbol a,\quad \boldsymbol a \times \boldsymbol a = \boldsymbol 0,\quad |\boldsymbol a \times \boldsymbol b| = |\boldsymbol a|\,|\boldsymbol b|\,\sin\theta,\quad \boldsymbol a \cdot (\boldsymbol b \times \boldsymbol c) = \boldsymbol b \cdot (\boldsymbol c \times \boldsymbol a) = \boldsymbol c \cdot (\boldsymbol a \times \boldsymbol b).$$

**Vector triple product** (handy for N-E expansions):

$$\boldsymbol a \times (\boldsymbol b \times \boldsymbol c) = \boldsymbol b\,(\boldsymbol a \cdot \boldsymbol c) - \boldsymbol c\,(\boldsymbol a \cdot \boldsymbol b).$$

A common special case used in propagation: for $\omega = [0, 0, w]^T$ and $P = [p_x, p_y, 0]^T$,

$$\omega \times P = \begin{bmatrix} -w\,p_y \\ w\,p_x \\ 0 \end{bmatrix},\qquad \omega \times (\omega \times P) = -w^2 \begin{bmatrix} p_x \\ p_y \\ 0 \end{bmatrix}.$$

### Determinant and inverse — 2×2

$$\det\begin{bmatrix} a & b \\ c & d \end{bmatrix} = ad - bc,\qquad \begin{bmatrix} a & b \\ c & d \end{bmatrix}^{-1} = \frac{1}{ad - bc}\begin{bmatrix} d & -b \\ -c & a \end{bmatrix}.$$

### Determinant and inverse — 3×3

**Determinant** (cofactor expansion along row 1):

$$\det\begin{bmatrix} a & b & c \\ d & e & f \\ g & h & i \end{bmatrix} = a(ei - fh) - b(di - fg) + c(dh - eg).$$

Equivalent **Rule of Sarrus:** add $aei + bfg + cdh$, subtract $ceg + afh + bdi$.

**Inverse** = adjugate / determinant:

$$A^{-1} = \frac{1}{\det A}\,\operatorname{adj}(A),\qquad \operatorname{adj}(A)_{ij} = (-1)^{i+j}\,M_{ji}\quad (\text{transpose of cofactor matrix; }M_{ji}\text{ is the minor}).$$

For rotation matrices, just take the **transpose** — never compute a numeric $3\times 3$ inverse for $R$.

### atan2 — quadrants

$\operatorname{atan2}(y, x)$ returns the unique angle $\in (-\pi, \pi]$ of the point $(x, y)$. Sign of each argument selects the quadrant; collapses gracefully when one is zero. **Always use it instead of $\arctan(y/x)$** in IK to keep the correct quadrant.

### Trigonometric identities you'll actually need

- **Pythagorean:** $\sin^2\theta + \cos^2\theta = 1$.
- **Addition:** $\cos(A \pm B) = c_A\,c_B \mp s_A\,s_B,\qquad \sin(A \pm B) = s_A\,c_B \pm c_A\,s_B$.
- **Double angle:** $\cos 2\theta = c^2\theta - s^2\theta = 2c^2\theta - 1 = 1 - 2s^2\theta,\qquad \sin 2\theta = 2\,s\theta\,c\theta$.
- **Half angle:** $\cos^2(\theta/2) = (1 + c\theta)/2,\qquad \sin^2(\theta/2) = (1 - c\theta)/2$.
- **Versine:** $v\theta = 1 - c\theta$ (appears in Rodrigues).
- **Law of cosines** (triangle with sides $a, b, c$ opposite angles $A, B, C$):

$$c^2 = a^2 + b^2 - 2 a b \cos C.$$

- **Sum-to-product / product-to-sum** — derivable from addition formulas if needed.
- **The $r\cos(\theta - \gamma) = c$ template** (the "trig substitution" workhorse): with $K_1 = r\,c\gamma$, $K_2 = r\,s\gamma$, an equation of the form $K_1\,c\theta \mp K_2\,s\theta = \cdots$ collapses to $r\,\cos\!/\!\sin(\theta \pm \gamma) = \cdots$. Solve via $\operatorname{atan2}$.

### Solving the homogeneous 2nd-order linear ODE

For $m\ddot x + b\dot x + k x = 0$: write characteristic equation $m\lambda^2 + b\lambda + k = 0$, find roots, pick the case (over / critical / under), then apply initial conditions to get $c_1, c_2$. See §7 table.

### Calculus reminders for trajectory planning

- $\dfrac{d}{dt}(t^n) = n\,t^{n-1}$. Integrate polynomials term-by-term: $\displaystyle\int t^n\, dt = \frac{t^{n+1}}{n+1}$.
- Velocity / acceleration of a polynomial trajectory by differentiating coefficient-by-coefficient. (No surprises — but worth practising once.)
- Constant-acceleration kinematics: $v = v_0 + a t,\quad x = x_0 + v_0 t + \tfrac{1}{2} a t^2,\quad v^2 = v_0^2 + 2 a (x - x_0)$.
