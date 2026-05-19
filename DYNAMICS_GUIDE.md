# Manipulator Dynamics — Exam Problem-Solving Guide (Week 9)

This guide is a procedure manual for the dynamics-flavoured exam questions in ELEC0129. The Newton-Euler iteration formulae, the Cartesian-dynamics formula, and the inertia-tensor integrals are **all on the official Formula Sheet** (supplied with the relevant question). What is **not** supplied — and what this guide teaches — is the *application*: how to set up frames, identify the position vectors, push through the cross products, and group the result into $M(q)\ddot q + V(q,\dot q) + G(q) = \tau$. Every dynamics question on the last four past papers reduces to one of the archetypes below.

## What to know — problem archetypes

| Archetype | Sources | Approx. share |
|---|---|---|
| A. Compute inertia tensor by triple integration | 23/24 Q25 (block, $I_{xx}$); 21/22 Q3 (triangular rod); W9 tutorial Q1 (cylinder) | recurring small-to-medium question |
| B. Full Newton-Euler outward + inward iteration on a 2-link / RP robot, then group into $M, V, G$ | 22/23 Q4 (RP, $\alpha = 45°$); 20/21 Q3 (RP); W9 tutorial Q2 (RP vertical); W9 lecture worked example (2R planar) | the canonical big-mark dynamics question (10–25 marks) |
| C. "General idea of N-E" — short verbal recall | 23/24 Q22 | 2–3 marks |
| D. Spot-the-error in a printed dynamics expression | 23/24 Q23 | 3 marks |
| E. Friction recall + use in dynamics | 23/24 Q24 | 0.5–1 mark |
| F. Cartesian-space dynamics $M_x, V_x, G_x$ — apply the sheet's formula | W9 lecture (2-link) | possible (small) |
| G. Computed-torque / partitioned MIMO control from $M, V, G$ | 20/21 Q4(c) — bridge to W10 | reuses $M, V, G$ as inputs |

Read the question first to decide which archetype it is. For A, B, F you spend almost all your time pushing algebra: be ruthlessly tidy.

---

## A. Inertia tensor by integration

The integrals are supplied; the **setup** (frame placement, limits, symmetry argument for the off-diagonals) is what the marks are paid for.

### A.1 Recipe

1. Place a frame at the centre of mass with axes aligned to the body's symmetry (so the off-diagonals vanish — see step 5 below).
2. Sketch the body with the chosen axes. Identify the $x, y, z$ limits of integration. For a non-rectangular cross-section the limits will depend on the outer variables — write the inner limits as functions of the outer.
3. Pick the appropriate integral from the sheet for the entry you want (e.g. $I_{xx} = \iiint_V (y^2 + z^2)\rho\, dV$ for the diagonal entries — note each $I_{ii}$ omits the squared coordinate along its own axis).
4. Integrate inner-to-outer, peeling one variable at a time. For separable polynomial integrands over rectangular regions, the integrals factor — exploit that immediately.
5. **For each off-diagonal $I_{xy} = \iiint xy\,\rho\,dV$:** if either axis is an axis of symmetry of the body (passing through the C.O.M.), the integrand $xy$ is odd in one variable and the integral over the symmetric range vanishes. State this symmetry argument once and quote the result $I_{xy} = I_{xz} = I_{yz} = 0$ — do not do three integrals.
6. Recognise $\iiint_V \rho\,dV = m$ at the end. The "convert volume × density → mass" step is often worth its own mark (21/22 Q3 awards 2 marks for this step alone).
7. Write the final tensor in the matrix form on the sheet:

$${}^{C}I = \begin{bmatrix} I_{xx} & -I_{xy} & -I_{xz} \\ -I_{xy} & I_{yy} & -I_{yz} \\ -I_{xz} & -I_{yz} & I_{zz} \end{bmatrix}.$$

The **leading minus signs on the off-diagonals** are a regular memory trap.

### A.2 Worked mini-example: $I_{xx}$ of a rectangular block (23/24 Q25, 5 marks)

Length $l$ along $\hat X$, width $w$ along $\hat Y$, height $h$ along $\hat Z$, frame at the geometric centre.

$$I_{xx} = \int_{-h/2}^{h/2}\!\int_{-l/2}^{l/2}\!\int_{-w/2}^{w/2} (y^2 + z^2)\,\rho\, dx\, dy\, dz.$$

Inner $x$-integral: the integrand is independent of $x$, so $\int_{-w/2}^{w/2} dx = w$.

$$= \int_{-h/2}^{h/2}\!\int_{-l/2}^{l/2} (y^2 + z^2)\, w\, \rho\, dy\, dz.$$

$y$-integral: $\int_{-l/2}^{l/2} y^2\, dy = \tfrac{l^3}{12}$, and $\int_{-l/2}^{l/2} z^2\, dy = z^2 l$. So

$$= \int_{-h/2}^{h/2} \left(\tfrac{l^3}{12} + z^2 l\right) w\, \rho\, dz = \left(\tfrac{l^3 h}{12} + \tfrac{h^3 l}{12}\right) w\, \rho = \underbrace{lwh\rho}_{m}\,\tfrac{l^2 + h^2}{12}.$$

$$\boxed{\;I_{xx} = \tfrac{m}{12}(l^2 + h^2).\;}$$

By the same symmetry argument $I_{xy} = I_{xz} = I_{yz} = 0$, and by relabelling:

$$I_{yy} = \tfrac{m}{12}(w^2 + h^2),\qquad I_{zz} = \tfrac{m}{12}(w^2 + l^2).$$

Mnemonic: **each $I_{ii}$ has the squared lengths along the *other two* axes** — the diagonal "skips" its own axis.

### A.3 Worked mini-example: cylinder along $\hat Y$ (W9 Tutorial Q1)

Right cylinder, radius $r$, length $\ell$ along $\hat Y$, C.O.M. at the centre. The trap is that **$x$ and $z$ are coupled** by the circular cross-section: $x^2 + z^2 \le r^2$. For each $y$-level (and for the whole length, since the cross-section is constant), $x$ ranges over $\pm\sqrt{r^2 - z^2}$.

$$I_{yy} = \iiint (x^2 + z^2)\,\rho\, dV.$$

Convert the $x$-$z$ slice to polar: $x = \tilde r\cos\phi$, $z = \tilde r\sin\phi$, $dx\,dz = \tilde r\, d\tilde r\, d\phi$, $x^2 + z^2 = \tilde r^2$.

$$I_{yy} = \int_{-\ell/2}^{\ell/2}\!\int_0^{2\pi}\!\int_0^r \tilde r^2 \cdot \tilde r\, d\tilde r\, d\phi\, dy \cdot \rho = \ell \cdot 2\pi \cdot \tfrac{r^4}{4}\cdot \rho = \tfrac{1}{2}\underbrace{\pi r^2 \ell \rho}_{m} r^2 = \tfrac{1}{2} m r^2.$$

For $I_{xx} = \iiint (y^2 + z^2)\rho\,dV$: split into the two terms.

- $\iiint y^2 \rho\,dV = \rho\,(\text{area of circle})\,\int_{-\ell/2}^{\ell/2} y^2\,dy = \rho \pi r^2 \cdot \tfrac{\ell^3}{12} = \tfrac{m\ell^2}{12}$.
- $\iiint z^2 \rho\,dV = \rho\,\ell \cdot \int z^2\,dA_{xz}$. In polar, $\int z^2\, dA = \int_0^{2\pi}\!\int_0^r \tilde r^2 \sin^2\phi\,\tilde r\, d\tilde r\,d\phi = \tfrac{\pi r^4}{4}$. So this gives $\tfrac{m r^2}{4}$.

$$\boxed{\;I_{xx} = \tfrac{m\ell^2}{12} + \tfrac{m r^2}{4} = \tfrac{m}{12}(\ell^2 + 3r^2).\;}$$

By the symmetry $x \leftrightarrow z$ about the cylinder axis, $I_{zz} = I_{xx}$. The off-diagonals vanish by the same odd-integrand argument.

### A.4 Worked mini-example: equilateral-triangle rod (21/22 Q3)

This one is examined when the integration limits depend on the outer variable. Rod of length $l$ along $\hat Z$; triangular cross-section in $x$-$y$, point-up, side $s$, centroid at origin.

Key setup steps (where the marks are):

1. Geometry: apex on $+\hat Y$ at $y = \tfrac{\sqrt 3}{3}s$; base at $y = -\tfrac{\sqrt 3}{6}s$. Slant edges $y = \pm\sqrt 3\, x + \tfrac{1}{\sqrt 3}s$. Hence for a given $y$ the $x$-limits are $x \in [\tfrac{1}{\sqrt 3}(y - \tfrac{1}{\sqrt 3}s),\ -\tfrac{1}{\sqrt 3}(y - \tfrac{1}{\sqrt 3}s)]$, i.e. the slice width is $-\tfrac{2}{\sqrt 3}(y - \tfrac{1}{\sqrt 3}s)$.
2. Write each integral $I_{xx}, I_{yy}$ with the limits in the correct order — outermost $z$, then $y$, then $x$ (since $x$-limits depend on $y$).
3. Inner $x$-integral pulls out the slice-width factor; then the $y$-integral; then the (trivial) $z$-integral.
4. At the end recognise area-of-triangle $\times$ length $\times$ density = mass: $\tfrac{\sqrt 3}{4}s^2 \cdot l \cdot \rho = m$. Both moments collapse to

$$I_{xx} = I_{yy} = m\!\left(\tfrac{1}{24}s^2 + \tfrac{1}{12}l^2\right).$$

By the 3-fold symmetry of the equilateral triangle in the $x$-$y$ plane, the cross-section has equal moments about any in-plane axis through the centroid — consistent with $I_{xx} = I_{yy}$.

### A.5 What to do under time pressure if integration is heavy

- If the body is one of the primitives in `STUDY_FORMULAS.md §6`, you can **quote** the result and write down the matrix, then justify in one line ("standard result; the integrals are on the sheet"). But the marker pays for the integration — only skip it if the question says "state" / "write down".
- If the body is a composite (rod + block, two cylinders), compute each piece's inertia tensor in its own frame, then **parallel-axis-shift** to the body C.O.M.: $I_{\text{new}} = I_{\text{C.O.M.}} + m d^2$ in each diagonal entry, using the perpendicular distance to the shifted axis.

---

## B. Newton-Euler outward + inward + canonical-form grouping

This is the canonical 20-25-mark dynamics question. The Newton-Euler iteration equations are **on the formula sheet** (revolute and prismatic). The work is:

1. Set up frames + DH + the rotation matrices $\,{}^{i+1}_{i}R\,$ and the C.O.M. / next-frame position vectors ${}^{i}P_{C_i}, {}^{i}P_{i+1}$.
2. Outward iteration: compute, for each link $i = 1\ldots n$:
   - ${}^{i}\omega_i$, ${}^{i}\dot\omega_i$, ${}^{i}\dot v_i$, ${}^{i}\dot v_{C_i}$ (in frame $\{i\}$),
   - ${}^{i}F_i = m_i\,{}^{i}\dot v_{C_i}$,
   - ${}^{i}N_i = {}^{C_i}I_i\,{}^{i}\dot\omega_i + {}^{i}\omega_i \times \bigl({}^{C_i}I_i\,{}^{i}\omega_i\bigr)$.
3. Inward iteration: starting from ${}^{n+1}f_{n+1} = 0, {}^{n+1}n_{n+1} = 0$, compute ${}^{i}f_i$ and ${}^{i}n_i$ for $i = n, n-1, \ldots, 1$.
4. Extract joint torques/forces: revolute → $\tau_i = (\,{}^{i}n_i)_z$; prismatic → $\tau_i = (\,{}^{i}f_i)_z$.
5. Group the resulting $\tau_i$ expressions into $M(q)\ddot q + V(q,\dot q) + G(q) = \tau$.

### B.1 Pre-flight checklist (do this on a corner of the page before integrating)

Write down, for each frame:

- The rotation matrix between adjacent frames. For a planar revolute joint about $\hat Z$:

$${}^{i+1}_{i}R = \begin{bmatrix} c_{i+1} & s_{i+1} & 0 \\ -s_{i+1} & c_{i+1} & 0 \\ 0 & 0 & 1 \end{bmatrix},\qquad {}^{i}_{i+1}R = \bigl(\,{}^{i+1}_{i}R\bigr)^T.$$

- ${}^{i}P_{i+1}$ — origin of frame $\{i+1\}$ as seen from frame $\{i\}$. For point-mass-at-tip links: $\,{}^{i}P_{i+1} = L_i\,\hat X_i$ if the link runs along $\hat X_i$.
- ${}^{i}P_{C_i}$ — C.O.M. of link $i$ as seen from frame $\{i\}$. **For point-mass-at-tip:** $\,{}^{i}P_{C_i} = L_i\,\hat X_i$ (the C.O.M. coincides with the joint $i+1$ origin). For a uniform link of length $L_i$ with C.O.M. at the centre: $\,{}^{i}P_{C_i} = (L_i/2)\,\hat X_i$.
- ${}^{C_i}I_i$ — the link's inertia tensor at C.O.M. For a point mass this is **zero**, which kills the $N_i$ term entirely.
- The base initial conditions: ${}^{0}\omega_0 = 0$, ${}^{0}\dot\omega_0 = 0$. Apply the **gravity trick**: ${}^{0}\dot v_0 = G$ where $G$ has magnitude $g$ and points **opposite** to gravity. For gravity along $-\hat Y_0$, set ${}^{0}\dot v_0 = g\,\hat Y_0$. For gravity along $-\hat Z_0$, set ${}^{0}\dot v_0 = g\,\hat Z_0$. **Sign trap:** the base "accelerates upward" — this is opposite to the direction gravity *pulls*.

### B.2 Frame-of-expression — the silent error source

Every vector in the N-E recursion has a **leading superscript** telling you which frame it lives in. Mistakes happen when you cross-product two vectors expressed in different frames. The rule, drilled from the sheet:

- Rotate the lower-frame quantities into the upper frame **first** via ${}^{i+1}_{i}R$, **then** do the cross-product with quantities already in the upper frame.
- The sheet's $\,{}^{i+1}\dot v_{i+1}$ formula is already arranged this way — the $\,{}^{i+1}_{i}R\bigl({}^{i}\dot\omega_i\times{}^{i}P_{i+1} + \ldots\bigr)$ block rotates the lower-frame cross-products as a unit.

### B.3 Simplifications that kill terms (use them aggressively)

- **All-revolute manipulator:** $\dot d_{i+1} = \ddot d_{i+1} = 0$, so the prismatic Coriolis term $2\,{}^{i+1}\omega_{i+1}\times\dot d_{i+1}\,{}^{i+1}\hat Z_{i+1}$ and the slide-acceleration term $\ddot d_{i+1}\,{}^{i+1}\hat Z_{i+1}$ drop out of $\,{}^{i+1}\dot v_{i+1}$.
- **Point-mass link:** $\,{}^{C_i}I_i = 0$, so $\,{}^{i}N_i = 0$ identically. Saves three lines per link.
- **Planar 2-link in $\hat X$-$\hat Y$:** every $\omega$ and $\dot\omega$ has only a $\hat Z$ component. Use the cheat from the math primer:

$$\begin{bmatrix}0\\0\\w\end{bmatrix}\times\begin{bmatrix}p_x\\p_y\\0\end{bmatrix} = \begin{bmatrix}-w p_y\\ w p_x\\ 0\end{bmatrix},\qquad \begin{bmatrix}0\\0\\w\end{bmatrix}\times\!\left(\!\begin{bmatrix}0\\0\\w\end{bmatrix}\!\times\!\begin{bmatrix}p_x\\p_y\\0\end{bmatrix}\!\right) = -w^2\begin{bmatrix}p_x\\p_y\\0\end{bmatrix}.$$

- **Adjacent-frame parallel $\hat Z$:** the cross-product term $({}^{i+1}_{i}R\cdot{}^{i}\omega_i)\times(\dot\theta_{i+1}\,{}^{i+1}\hat Z_{i+1})$ in $\,{}^{i+1}\dot\omega_{i+1}$ vanishes, because the rotated $\omega$ is also along $\hat Z$. Holds for any planar manipulator.

### B.4 Worked mini-example: 2-link planar RR (lecture worked example)

Two revolute joints in the $\hat X_0$-$\hat Y_0$ plane, link lengths $L_1, L_2$, **point masses** $m_1, m_2$ at link tips. Gravity along $-\hat Y_0$.

Pre-flight:

$${}^{1}P_{C_1} = L_1\hat X_1, \quad {}^{2}P_{C_2} = L_2\hat X_2, \quad {}^{1}P_2 = L_1\hat X_1, \quad {}^{C_1}I_1 = {}^{C_2}I_2 = 0,\quad {}^{0}\dot v_0 = g\hat Y_0.$$

**Outward, link 1.** $\,{}^{1}\omega_1 = \dot\theta_1\hat Z$, $\,{}^{1}\dot\omega_1 = \ddot\theta_1\hat Z$. Then $\,{}^{1}\dot v_1 = {}^{1}_{0}R\cdot{}^{0}\dot v_0 = [g s_1,\ g c_1,\ 0]^T$. Using the planar cheat:

$$\,{}^{1}\dot v_{C_1} = \begin{bmatrix} g s_1 - L_1\dot\theta_1^2 \\ g c_1 + L_1\ddot\theta_1 \\ 0 \end{bmatrix},\qquad \,{}^{1}F_1 = m_1\,{}^{1}\dot v_{C_1},\qquad \,{}^{1}N_1 = 0.$$

**Outward, link 2.** $\,{}^{2}\omega_2 = (\dot\theta_1 + \dot\theta_2)\hat Z$, $\,{}^{2}\dot\omega_2 = (\ddot\theta_1 + \ddot\theta_2)\hat Z$ (the planar cross-product term vanishes). Rotate $\,{}^{1}\dot v_1$ into frame $\{2\}$ via $\,{}^{2}_{1}R$, and add the bracketed propagation term:

$$\,{}^{2}\dot v_2 = \begin{bmatrix} -L_1 c_2 \dot\theta_1^2 + L_1 s_2 \ddot\theta_1 + g s_{12} \\ L_1 s_2 \dot\theta_1^2 + L_1 c_2 \ddot\theta_1 + g c_{12} \\ 0 \end{bmatrix}.$$

Propagating to C.O.M. of link 2 (point mass at tip, $\,{}^{2}P_{C_2} = L_2\hat X_2$):

$$\,{}^{2}\dot v_{C_2} = {}^{2}\dot v_2 + \underbrace{\begin{bmatrix}0\\ L_2(\ddot\theta_1+\ddot\theta_2)\\0\end{bmatrix}}_{\dot\omega_2\times P_{C_2}} + \underbrace{\begin{bmatrix}-L_2(\dot\theta_1+\dot\theta_2)^2\\ 0\\ 0\end{bmatrix}}_{\omega_2\times(\omega_2\times P_{C_2})}.$$

Hence $\,{}^{2}F_2 = m_2\,{}^{2}\dot v_{C_2}$, $\,{}^{2}N_2 = 0$.

**Inward.** ${}^{3}f_3 = 0$, $\,{}^{3}n_3 = 0$.

Link 2: $\,{}^{2}f_2 = {}^{2}F_2$. Moment $\,{}^{2}n_2 = \,{}^{2}P_{C_2}\times{}^{2}F_2 = L_2\hat X\times{}^{2}F_2 = [0,\ 0,\ L_2\,{}^{2}F_{2y}]^T$.

So $\tau_2 = (\,{}^{2}n_2)_z = L_2\,{}^{2}F_{2y}$, i.e.

$$\boxed{\;\tau_2 = m_2 L_2^2(\ddot\theta_1 + \ddot\theta_2) + m_2 L_1 L_2 c_2 \ddot\theta_1 + m_2 L_1 L_2 s_2 \dot\theta_1^2 + m_2 g L_2 c_{12}.\;}$$

Link 1: $\,{}^{1}f_1 = {}^{1}_{2}R\,{}^{2}f_2 + {}^{1}F_1$. The $\hat Z$ component of $\,{}^{1}n_1$ collects three pieces:

- $({}^{1}_{2}R\,{}^{2}n_2)_z = L_2\,{}^{2}F_{2y}$ (the planar rotation preserves the $\hat Z$ component).
- $({}^{1}P_{C_1}\times{}^{1}F_1)_z = L_1\,{}^{1}F_{1y}$.
- $({}^{1}P_2\times{}^{1}_{2}R\,{}^{2}f_2)_z = L_1(s_2\,{}^{2}F_{2x} + c_2\,{}^{2}F_{2y})$.

Substituting the force components and simplifying:

$$\tau_1 = m_2 L_2^2(\ddot\theta_1 + \ddot\theta_2) + m_2 L_1 L_2 c_2 (2\ddot\theta_1 + \ddot\theta_2) + (m_1 + m_2) L_1^2 \ddot\theta_1$$
$$\qquad\ \ - m_2 L_1 L_2 s_2 \dot\theta_2^2 - 2 m_2 L_1 L_2 s_2 \dot\theta_1\dot\theta_2 + m_2 g L_2 c_{12} + (m_1 + m_2) g L_1 c_1.$$

### B.5 Canonical-form grouping

Read off three buckets from each $\tau_i$:

- **$M(q)$ row $i$ column $j$** = coefficient of $\ddot\theta_j$ in $\tau_i$.
- **$V(q,\dot q)$ row $i$** = the sum of all terms quadratic in $\dot\theta$ (so containing $\dot\theta_j^2$ or $\dot\theta_j\dot\theta_k$). Sub-classify into centrifugal ($\dot\theta_j^2$) and Coriolis ($\dot\theta_j\dot\theta_k$, $j\ne k$).
- **$G(q)$ row $i$** = the sum of all terms containing $g$ but no $\dot\theta$ or $\ddot\theta$.

For the 2R example:

$$M(q) = \begin{bmatrix} m_2 L_2^2 + 2 m_2 L_1 L_2 c_2 + (m_1+m_2) L_1^2 & m_2 L_2^2 + m_2 L_1 L_2 c_2 \\ m_2 L_2^2 + m_2 L_1 L_2 c_2 & m_2 L_2^2 \end{bmatrix},$$

$$V(q,\dot q) = \underbrace{\begin{bmatrix}-m_2 L_1 L_2 s_2 \dot\theta_2^2 \\ m_2 L_1 L_2 s_2 \dot\theta_1^2 \end{bmatrix}}_{\text{centrifugal}} + \underbrace{\begin{bmatrix}-2 m_2 L_1 L_2 s_2 \dot\theta_1\dot\theta_2 \\ 0\end{bmatrix}}_{\text{Coriolis}},\qquad G(q) = \begin{bmatrix} m_2 g L_2 c_{12} + (m_1+m_2) g L_1 c_1 \\ m_2 g L_2 c_{12} \end{bmatrix}.$$

**Sanity checks** (one mark each in spot-the-error questions — and free if you do them):

- $M(q)$ is **symmetric**: $M_{12} = M_{21}$. Always.
- $M(q)$ is **configuration-dependent** (entries contain $c_2$ here) — but **diagonal entries depend only on shape/length parameters that contribute "extra" perceived inertia from the distal links**. $M_{22}$ here is just $m_2 L_2^2$ — the inertia link 2 sees is independent of $\theta_2$ (intuitive: rotating joint 2 doesn't move link 2's reach beyond its own length).
- Every term in $V(q,\dot q)$ is **quadratic in $\dot\theta$**. No $\ddot\theta$, no isolated $\dot\theta$, no $g$.
- Every term in $G(q)$ contains $g$, no $\dot\theta$ or $\ddot\theta$.

### B.6 Worked mini-example: RP robot, 22/23 Q4 / W9 tutorial Q2 family

A robot with revolute joint 1 (axis $\hat Z_1$) and prismatic joint 2 (slide $d_2$). 22/23 Q4 has the two joint axes tilted at $45°$ ($\alpha_1 = -45°$). The W9 tutorial has them perpendicular ($\alpha_1 = 90°$). Same procedure; only the rotation matrix $\,{}^{2}_{1}R$ and the position vectors change.

Key features that distinguish this archetype from the 2R planar:

1. **Joint 2 is prismatic, joint 1 is revolute** — $\,{}^{2}\omega_2 = {}^{2}_{1}R\,{}^{1}\omega_1$ (no added $\dot\theta_2$ term). And the linear-acceleration formula for link 2 picks up the **two prismatic-joint terms**: $+ 2\,{}^{2}\omega_2\times\dot d_2\hat Z_2 + \ddot d_2\hat Z_2$. **These are easy to forget** because they vanish for revolute joints — always check the joint type before writing $\,{}^{i+1}\dot v_{i+1}$.
2. **Inertia tensors are non-zero diagonal** — so $\,{}^{i}N_i \ne 0$. The cross-product term $\omega\times I\omega$ can still vanish if $\omega$ is along a principal axis (an axis with a diagonal $I$ entry); check that on each link.
3. **The C.O.M. of link 2 is often at the slide tip** — i.e. $\,{}^{2}P_{C_2} = 0$ when the frame $\{2\}$ origin is placed at the C.O.M. (22/23 Q4 explicitly places it there). Then $\,{}^{2}\dot v_{C_2} = \,{}^{2}\dot v_2$, no extra propagation.
4. **The C.O.M. of link 1 is along the link, not on the rotation axis** — so $\,{}^{1}P_{C_1}$ has a non-zero component, and the centripetal term in $\,{}^{1}\dot v_{C_1}$ is non-zero.
5. **Joint torque/force extraction:**
   - $\tau_1$ is the **revolute** torque at joint 1 → $\tau_1 = (\,{}^{1}n_1)_z$.
   - $\tau_2$ is the **prismatic** force at joint 2 → $\tau_2 = (\,{}^{2}f_2)_z$.

Final shape (20/21 Q3 answer):

$$M = \begin{bmatrix} I_{YY2} + m_1 L_{c1}^2 + m_2 L_1^2 + m_2 d_2^2 + I_{ZZ1} & m_2 L_1 \\ m_2 L_1 & m_2 \end{bmatrix},$$
$$V(q,\dot q) = \begin{bmatrix} 2 m_2 d_2 \dot\theta_1\dot d_2 \\ -m_2 d_2 \dot\theta_1^2 \end{bmatrix},\qquad G(q) = \begin{bmatrix} m_1 L_{c1} c_1 g + m_2 L_1 c_1 g - m_2 d_2 s_1 g \\ m_2 c_1 g \end{bmatrix}.$$

Two structural lessons that travel to any RP question:

- The $(1,1)$ entry of $M$ contains $m_2 d_2^2$ — joint 1's perceived inertia **grows quadratically** as the prismatic link extends. Intuitive: the further out the mass, the harder it is to spin.
- The Coriolis term $2 m_2 d_2 \dot\theta_1 \dot d_2$ appears in $\tau_1$: rotation + simultaneous extension generates a Coriolis joint torque. **This is the term that vanishes if you forget the prismatic Coriolis bit** ($2\,{}^{2}\omega_2\times\dot d_2\hat Z_2$) in the outward iteration.

> **Erratum / suspected-source-error to be aware of (LORE.md):** the 22/23 model solution has an internal sign inconsistency in the centripetal contribution of $\,{}^{1}\dot v_{C_1}$ (page 19 of the handwritten scan) — the $(1/\sqrt 2)L_{c1}\dot\theta_1^2$ term is placed in the $y$-component, but a strict $\omega\times(\omega\times r)$ with the given vectors puts it in the $x$-component. Compute it strictly and trust your own algebra; if your final $M, V, G$ end up matching the handwritten boxed answer to within a sign on the cross-term, that is the answer the marker is looking for.

---

## C. "General idea of Newton-Euler" — verbal recall (23/24 Q22, 2.5 marks)

Five bullets, in this order:

1. Propagate velocity and acceleration from lower frame to upper frame (outward).
2. Propagate the acceleration of each frame to the centre of mass of each link.
3. With the C.O.M. acceleration and the link mass, compute the net force on the link via $F = m a$ (and the net moment via Euler's equation $N = {}^{C}I\dot\omega + \omega\times{}^{C}I\omega$).
4. Propagate joint forces and torques from higher frame to lower frame (inward).
5. The force/torque on each link relates to the joint forces/torques; projecting onto the joint axis gives the joint torques (revolute) or forces (prismatic) — the dynamic equations.

---

## D. Spot-the-error in a printed dynamics expression (23/24 Q23, 3 marks)

You are shown a 2-link $\tau_1, \tau_2$ expression and asked to flag bugs. Three categories cover most planted bugs:

1. **Wrong power on $\ddot\theta$ or $\dot\theta$.** $M$-matrix terms must be linear in $\ddot\theta$ (so any $\ddot\theta^2$ is wrong). $V$-terms must be quadratic in $\dot\theta$ (so a lone $\dot\theta$ without a partner is wrong — typically the partner $\dot\theta$ is missing).
2. **Asymmetry of $M(q)$.** Read off $M_{12}$ from $\tau_1$ (coefficient of $\ddot\theta_2$) and $M_{21}$ from $\tau_2$ (coefficient of $\ddot\theta_1$) — they must be equal. If not, flag it.
3. **Missing Coriolis cross-term.** $V$ of $\tau_1$ usually contains $\dot\theta_1\dot\theta_2$ (with the factor $-2 m_2 L_1 L_2 s_2$ for the 2R planar). If the printed expression has only centrifugal terms ($\dot\theta_j^2$), the cross-term has been dropped.

Other minor checks: gravity terms contain $g$ exactly once each; signs of $c_1, c_{12}$ match the canonical worked example (use the gravity-down convention $\,{}^{0}\dot v_0 = +g\hat Y_0$ so all gravity terms come out positive in $G$).

---

## E. Friction (23/24 Q24, 0.5 marks; possibly more)

Three models, equations only — memorise the equations, name them with one phrase each:

- **Viscous:** $\tau_{\text{friction}} = k\dot q$. (Linear, through origin.)
- **Coulomb:** $\tau_{\text{friction}} = c\cdot\mathrm{sgn}(\dot q)$. (Constant magnitude, sign tracks velocity.)
- **Combined viscous + Coulomb:** $\tau_{\text{friction}} = c\cdot\mathrm{sgn}(\dot q) + k\dot q$.

Friction enters the dynamics with a **minus** sign on the right-hand side (intuitively, friction opposes motion / steals torque):

$$M(q)\ddot q + V(q,\dot q) + G(q) = \tau - \tau_{\text{friction}}.$$

Computed-torque controllers must **add** $\tau_{\text{friction}}$ back into the model-compensator: $\tau = M(q) f + V(q,\dot q) + G(q) + \tau_{\text{friction}}$ (20/21 Q4(c)).

---

## F. Cartesian-space dynamics

The formula is supplied:

$$\underbrace{J^{-T} M(q) J^{-1}}_{M_x}\ddot x + \underbrace{J^{-T}\bigl(V(q,\dot q) - M(q) J^{-1}\dot J\dot q\bigr)}_{V_x} + \underbrace{J^{-T} G(q)}_{G_x} = F.$$

### F.1 Recipe

1. Start from the joint-space $M, V, G$ (from B above).
2. Compute the Jacobian $J(q)$. Use the **end-effector frame** Jacobian $\,{}^{e}J_v = {}^{e}_{0}R\cdot{}^{0}J_v$ if forces are naturally expressed along tool axes — it usually simplifies dramatically (see the 2R example: $\,{}^{e}J_v = \begin{bmatrix} L_1 s_2 & 0 \\ L_1 c_2 + L_2 & L_2 \end{bmatrix}$ is much sparser than the base-frame Jacobian).
3. Compute $J^{-1}$ — use the 2×2 closed form $\frac{1}{ad-bc}\begin{bmatrix} d & -b \\ -c & a \end{bmatrix}$ to avoid algebra mistakes. Then $J^{-T} = (J^{-1})^T$.
4. Compute $\dot J$ by differentiating $J(q)$ entry-by-entry with respect to time (use the chain rule: each $c_2$ becomes $-s_2\dot\theta_2$, etc.).
5. Plug into the supplied formula. Simplify with the 2R-end-effector example as a worked sanity check:

$$M_x = \begin{bmatrix} m_2 + m_1/s_2^2 & 0 \\ 0 & m_2 \end{bmatrix}.$$

The **diagonal** structure of $M_x$ when expressed in the end-effector frame is a generic feature for this 2R example — Cartesian-space inertia couples differently than joint-space, and singular configurations ($s_2 \to 0$) blow up $M_x$ (consistent with the joint becoming non-invertible).

---

## G. Bridge to control: computed-torque (partitioned MIMO) — for completeness

When a question chains "derive $M, V, G$" with "design a controller", you reuse the just-derived dynamics in the model-based compensator:

$$\tau = M(q)\,f + V(q,\dot q) + G(q) + \tau_{\text{friction}}.$$

The servo command is

$$f = \ddot q_d - K_v(\dot q - \dot q_d) - K_p(q - q_d),$$

with **diagonal** $K_p, K_v$. Critical damping per joint:

$$K_v = \mathrm{diag}\bigl(2\sqrt{k_{p,1}},\ 2\sqrt{k_{p,2}},\ \ldots\bigr).$$

This collapses the joint-error dynamics to $\ddot e + K_v\dot e + K_p e = 0$, decoupled. (This belongs to Week 10 but is sometimes the back half of a Week 9 dynamics question — see 20/21 Q4(c). Memorise the form.)

---

## Common pitfalls — last 60 seconds before pressing the pen down

- **Frame of expression.** Each $\omega, v, F$ has a leading-superscript frame. The sheet's iteration formulas have the rotation matrix already placed — don't add an extra one.
- **Gravity-trick sign.** ${}^{0}\dot v_0 = G$ is **opposite** the gravity vector. For gravity along $-\hat Y_0$, use $+g\hat Y_0$. For gravity along $-\hat Z_0$, use $+g\hat Z_0$. Get this wrong and every gravity term in $G(q)$ flips sign.
- **Prismatic-joint Coriolis.** $\,{}^{i+1}\dot v_{i+1}$ has the extra $2\,{}^{i+1}\omega_{i+1}\times\dot d_{i+1}\hat Z + \ddot d_{i+1}\hat Z$ block — drop it for revolute joints but **keep it for prismatic**.
- **Point-mass $I = 0$.** For point-mass-at-tip links, ${}^{C_i}I_i = 0$ and $\,{}^{i}N_i = 0$. Don't add inertia tensor terms that aren't there.
- **${}^{i}P_{C_i}$ vs. ${}^{i}P_{i+1}$.** For point-mass-at-tip these coincide ($= L_i\hat X_i$); for distributed-mass links they don't. Read the figure carefully.
- **Inertia tensor sign convention.** Off-diagonals carry a **leading minus** when assembled into ${}^{A}I$: $-I_{xy}, -I_{xz}, -I_{yz}$. The six $\iiint$ integrals on the sheet are positive scalars — the minus is in the assembly.
- **$M(q)$ symmetry.** If after grouping $M_{12} \ne M_{21}$, you have an algebra error somewhere in the inward iteration. Recheck before writing the boxed answer.
- **$\tau$ projection axis.** Revolute → $\tau_i = ({}^{i}n_i)_z = (\,{}^{i}n_i)^T\,{}^{i}\hat Z_i$. Prismatic → $\tau_i = ({}^{i}f_i)_z$. In Craig modified DH, $\hat Z_i$ is along joint $i$ — so always the **$z$-component** in frame $\{i\}$.
- **Centrifugal vs. Coriolis.** $\dot\theta_j^2$ = centrifugal; $\dot\theta_j\dot\theta_k$ ($j\ne k$) = Coriolis. The 23/24 spot-the-error and the W9 lecture grouping both depend on you classifying them correctly.
- **Sanity-check $G(q)$ against the static configuration.** At rest with the link horizontal, the gravity torque at joint 1 should be $m g \cdot (\text{horizontal lever arm})$ — for the 2R worked example, $(m_1 + m_2) g L_1 c_1 + m_2 g L_2 c_{12}$, both with $c$'s (cosines of angles from the gravity-perpendicular). At vertical-up configurations ($\theta = \pi/2$), each cosine should evaluate to zero and the gravity torque should vanish.
- **MATLAB-simulation sign convention** (only relevant if a coding question appears): the sheet writes $M\ddot q + V + G = \tau$, so the simulation solves $\ddot q = M^{-1}(\tau - V - G)$. **Subtract** $V$ and $G$ before inverting $M$ — sign mistakes here are the classic bug.
