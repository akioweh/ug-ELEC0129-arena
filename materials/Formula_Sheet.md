> Source: [Formula\_Sheet.pdf](../meta/formula_sheet/Formula_Sheet.pdf)

# ELEC0129 Formula Sheet

This file is a verbatim text-only reproduction of the official ELEC0129 (Introduction to Robotics) formula sheet (3-page PDF). It is the in-exam reference document supplied to every candidate.

**Note to students:**

1. This is a list of formulae which you do **NOT** need to memorize.
2. However, they will not appear in the exam as a separate page.
3. Instead, they will appear in the particular question where required. For e.g. "Given the rotation matrix, calculate the Euler parameters. Hint: Formula is …."

---

## Spatial Description and Transformation

<!-- note: the sheet's heading reads "Spacial Description and Transformation" (typo for "Spatial"); corrected here. -->

### Equivalent Angle-Axis representation of rotation

$$
{}^{A}_{B}R = \begin{bmatrix}
k_x^2 v\theta + c\theta & k_x k_y v\theta - k_z s\theta & k_x k_z v\theta + k_y s\theta \\
k_x k_y v\theta + k_z s\theta & k_y^2 v\theta + c\theta & k_y k_z v\theta - k_x s\theta \\
k_x k_z v\theta - k_y s\theta & k_y k_z v\theta + k_x s\theta & k_z^2 v\theta + c\theta
\end{bmatrix}
$$

Where $v\theta = 1 - c\theta$.

<!-- note: the sheet uses the shorthand $c\theta = \cos\theta$, $s\theta = \sin\theta$, and the "versine" $v\theta = 1 - \cos\theta$. -->

### Euler Parameters

$$
\varepsilon_1 = k_x \sin(\theta/2),\quad \varepsilon_2 = k_y \sin(\theta/2),\quad \varepsilon_3 = k_z \sin(\theta/2),\quad \varepsilon_4 = \cos(\theta/2)
$$

$$
{}^{A}_{B}R = \begin{bmatrix}
1 - 2\varepsilon_2^2 - 2\varepsilon_3^2 & 2(\varepsilon_1\varepsilon_2 - \varepsilon_3\varepsilon_4) & 2(\varepsilon_1\varepsilon_3 + \varepsilon_2\varepsilon_4) \\
2(\varepsilon_1\varepsilon_2 + \varepsilon_3\varepsilon_4) & 1 - 2\varepsilon_1^2 - 2\varepsilon_3^2 & 2(\varepsilon_2\varepsilon_3 - \varepsilon_1\varepsilon_4) \\
2(\varepsilon_1\varepsilon_3 - \varepsilon_2\varepsilon_4) & 2(\varepsilon_2\varepsilon_3 + \varepsilon_1\varepsilon_4) & 1 - 2\varepsilon_1^2 - 2\varepsilon_2^2
\end{bmatrix}
$$

---

## Forward Kinematics

### Transformation from frame $\{i-1\}$ to $\{i\}$ from the DH-Table

$$
{}^{i-1}_{i}T = \begin{bmatrix}
c\theta_i & -s\theta_i & 0 & a_{i-1} \\
c\alpha_{i-1} s\theta_i & c\alpha_{i-1} c\theta_i & -s\alpha_{i-1} & -s\alpha_{i-1} d_i \\
s\alpha_{i-1} s\theta_i & s\alpha_{i-1} c\theta_i & c\alpha_{i-1} & c\alpha_{i-1} d_i \\
0 & 0 & 0 & 1
\end{bmatrix}
$$

<!-- note: this is the Craig "modified" DH per-link transform, using parameters in the order $\alpha_{i-1}, a_{i-1}, d_i, \theta_i$. -->

---

## Inverse Kinematics

None.

---

## Jacobians

### Velocity propagation

Start with ${}^{0}\omega_0$, ${}^{0}v_0$.

Calculate recursively from link to link:

**For revolute joints:**

$$
{}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i + \dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}
$$

$$
{}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \bigl({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\bigr)
$$

**For prismatic joints:**

$$
{}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R \cdot {}^{i}\omega_i
$$

$$
{}^{i+1}v_{i+1} = {}^{i+1}_{i}R \cdot \bigl({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\bigr) + \dot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}
$$

Continue until ${}^{n}\omega_n$, ${}^{n}v_n$.

The velocity of the end-effector is thus simply:

$$
\begin{aligned}
{}^{n}\omega_e &= {}^{n}\omega_n \\
{}^{n}v_e &= {}^{n}v_n + {}^{n}\omega_n \times {}^{n}P_e
\end{aligned}
$$

---

## Trajectory Planning

### Linear trajectory with parabolic blends

Calculate

$$
t_b = \frac{t_f}{2} - \frac{\sqrt{\ddot{u}^2 t_f^2 - 4\ddot{u}(u_f - u_0)}}{2\ddot{u}}
$$

and

$$
u_b = u_0 + \frac{1}{2}\ddot{u}\, t_b^2
$$

The trajectory is then:

$$
u(t) = \begin{cases}
u_0 + \dfrac{1}{2}\ddot{u}\, t^2 & t < t_b \\[6pt]
\dfrac{u_h - u_b}{t_h - t_b}(t - t_b) + u_b & t_b \le t < (t_f - t_b) \\[6pt]
u_f - \dfrac{1}{2}\ddot{u}\,(t_f - t)^2 & t \ge (t_f - t_b)
\end{cases}
$$

<!-- note: the symbols $u_h$ and $t_h$ in the middle (constant-velocity) segment are not defined elsewhere on the sheet. In the standard LSPB formulation these would normally be $u_f$ and $t_f$ (or, equivalently, the values at the end of the blend on the far side: $u_f - u_b$ over $t_f - 2t_b$ giving slope $(u_f - 2u_b + u_0)/(t_f - 2t_b)$ — but with $u_0 + u_f = 2u_h$ if $u_h$ is the midpoint, the two are consistent). Transcribed verbatim. -->

---

## Dynamics

### Newton-Euler Formula

#### Outward iteration

Start with ${}^{0}\omega_0 = 0$, ${}^{0}\dot{\omega}_0 = 0$, ${}^{0}\dot{v}_0 = \text{depends}$.

<!-- note: "${}^{0}\dot{v}_0 = $ depends" indicates that the base linear acceleration is set to $-G$ (the negative of gravity) to fold gravity into the recursion; the exact value depends on the orientation of frame {0} relative to gravity. -->

Calculate velocities and accelerations of frames:

$$
{}^{i+1}\omega_{i+1} = \bigl({}^{i+1}_{i}R \cdot {}^{i}\omega_i\bigr) + \bigl(\dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\bigr)
$$

$$
{}^{i+1}\dot{\omega}_{i+1} = \bigl({}^{i+1}_{i}R \cdot {}^{i}\dot{\omega}_i\bigr) + \Bigl(\bigl({}^{i+1}_{i}R \cdot {}^{i}\omega_i\bigr) \times \bigl(\dot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\bigr)\Bigr) + \bigl(\ddot{\theta}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\bigr)
$$

$$
\begin{aligned}
{}^{i+1}\dot{v}_{i+1} ={} & \bigl({}^{i+1}_{i}R \cdot {}^{i}\dot{v}_i\bigr) + \Bigl(2\,{}^{i+1}\omega_{i+1} \times \bigl(\dot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\bigr)\Bigr) + \bigl(\ddot{d}_{i+1} \cdot {}^{i+1}\hat{Z}_{i+1}\bigr) \\
& + {}^{i+1}_{i}R\Bigl(\bigl({}^{i}\dot{\omega}_i \times {}^{i}P_{i+1}\bigr) + \bigl({}^{i}\omega_i \times ({}^{i}\omega_i \times {}^{i}P_{i+1})\bigr)\Bigr)
\end{aligned}
$$

<!-- note: as written verbatim from the sheet, the prismatic-joint terms ($2\,{}^{i+1}\omega_{i+1}\times \dot d_{i+1}\hat Z_{i+1}$ and $\ddot d_{i+1}\hat Z_{i+1}$) are included unconditionally; for an all-revolute manipulator these drop out automatically since $\dot d = \ddot d = 0$. -->

Propagate accelerations from frames to centre of mass:

$$
{}^{i+1}\dot{v}_{ci+1} = \bigl({}^{i+1}\dot{v}_{i+1}\bigr) + \bigl({}^{i+1}\dot{\omega}_{i+1} \times {}^{i+1}P_{ci+1}\bigr) + \Bigl({}^{i+1}\omega_{i+1} \times \bigl({}^{i+1}\omega_{i+1} \times {}^{i+1}P_{ci+1}\bigr)\Bigr)
$$

Calculate the force and moment at the centre of mass:

$$
{}^{i+1}F_{i+1} = m_{i+1}\, {}^{i+1}\dot{v}_{ci+1}
$$

$$
{}^{i+1}N_{i+1} = \bigl({}^{ci+1}I_{i+1} \cdot {}^{i+1}\dot{\omega}_{i+1}\bigr) + \Bigl({}^{i+1}\omega_{i+1} \times \bigl({}^{ci+1}I_{i+1} \cdot {}^{i+1}\omega_{i+1}\bigr)\Bigr)
$$

Do until the $n$th link.

#### Inward iteration

Start with force and torque at robot tip ${}^{n}f_n$, ${}^{n}n_n$.

Calculate force and torque at the starting end of each link:

$$
{}^{i}f_i = \bigl({}^{i}_{i+1}R \cdot {}^{i+1}f_{i+1}\bigr) + {}^{i}F_i
$$

$$
{}^{i}n_i = \bigl({}^{i}_{i+1}R \cdot {}^{i+1}n_{i+1}\bigr) + \bigl({}^{i}P_{ci} \times {}^{i}F_i\bigr) + \Bigl({}^{i}P_{i+1} \times \bigl({}^{i}_{i+1}R \cdot {}^{i+1}f_{i+1}\bigr)\Bigr) + {}^{i}N_i
$$

Do until $i = 1$.

Finally, extract the joint (motor) torques or forces:

$$
\begin{cases}
\tau_i = {}^{i}n_i^{T} \cdot {}^{i}\hat{Z}_i & \text{if revolute} \\
\tau_i = {}^{i}f_i^{T} \cdot {}^{i}\hat{Z}_i & \text{if prismatic}
\end{cases}
$$

### Dynamics in Cartesian Space

$$
\begin{aligned}
& J^{-T}(q) M(q)\bigl(J^{-1}(q)\ddot{x} - J^{-1}(q)\dot{J}(q)\dot{q}\bigr) + J^{-T}(q) V(q,\dot{q}) + J^{-T}(q) G(q) \\
&= \underbrace{J^{-T} M(q) J^{-1}}_{M_x}\ddot{x} + \underbrace{J^{-T}\bigl(V(q,\dot{q}) - M(q) J^{-1}\dot{J}\dot{q}\bigr)}_{V_x} + \underbrace{J^{-T} G(q)}_{G_x} = F
\end{aligned}
$$

<!-- note: $G(q)$ here is the joint-space gravity vector (not the gravity-direction vector). $M_x$, $V_x$, $G_x$ are the Cartesian-space mass matrix, velocity-product term, and gravity term respectively. -->

### Inertia Tensor

$$
{}^{A}I = \begin{bmatrix}
I_{xx} & -I_{xy} & -I_{xz} \\
-I_{xy} & I_{yy} & -I_{yz} \\
-I_{xz} & -I_{yz} & I_{zz}
\end{bmatrix}
$$

**Mass moment of inertia:**

$$
I_{xx} = \iiint_V (y^2 + z^2)\,\rho\, dV,\qquad I_{yy} = \iiint_V (x^2 + z^2)\,\rho\, dV,\qquad I_{zz} = \iiint_V (x^2 + y^2)\,\rho\, dV
$$

**Mass product of inertia:**

$$
I_{xy} = \iiint_V xy\,\rho\, dV,\qquad I_{xz} = \iiint_V xz\,\rho\, dV,\qquad I_{yz} = \iiint_V yz\,\rho\, dV
$$

---

## Control

None.

<!-- transcription-audit:
- Dropped: page headers "ELEC0129 Formula Sheet" repeated on each of the 3 pages — boilerplate.
- Dropped: page number "21" visible on page 2 in the lower-right of the boxed inward-iteration block — appears to be a leftover slide number from the source slide deck, not exam-sheet content.
- Dropped: horizontal rule decorations between sections (preserved structurally as `---`).
- Warnings: none — sheet is all formulae and short headings, no diagrams, no colour-coded annotations carrying information. The cyan boxes around formulae are purely decorative (they delimit each formula); preserved structurally via display-math blocks.
- Ambiguities:
  - The piecewise LSPB middle segment uses symbols `u_h` and `t_h` that are not defined on the sheet (see inline note); flagged but transcribed verbatim.
  - The outward Newton-Euler `${}^{i+1}\dot v_{i+1}$` recursion on the sheet writes the prismatic-joint Coriolis/translation terms ($2\,{}^{i+1}\omega_{i+1}\times\dot d_{i+1}\hat Z_{i+1}$ and $\ddot d_{i+1}\hat Z_{i+1}$) inline rather than as a piecewise revolute/prismatic split. Transcribed verbatim; for an all-revolute robot these terms vanish automatically.
  - "${}^{0}\dot v_0 = $ depends" — sheet leaves the base linear acceleration to the question; clarified inline.
- Suspected source errors: none.
  - Cross-checked the equivalent angle-axis matrix against Craig (3e) eq. (2.80): matches exactly.
  - Cross-checked the Craig modified-DH per-link transform against Craig (3e) eq. (3.6): matches (factor ordering $c\alpha_{i-1}s\theta_i$ vs. $s\theta_i c\alpha_{i-1}$ is commutative for scalars).
  - Cross-checked the Euler-parameter rotation matrix against Craig (3e) eq. (2.91): matches.
  - Minor typo in section heading: "Spacial" → corrected to "Spatial" inline (flagged).
-->
