# Jacobians — Step-by-Step Problem-Solving Guide (W7)

## What to know

The Jacobian $J(\boldsymbol q)$ is the single matrix that links **joint rates** to **end-effector velocity** and (by duality) **joint torques** to **end-effector forces**. ELEC0129 Jacobian questions almost always reduce to one of the archetypes below, and **the velocity-propagation recurrences are supplied on the formula sheet** — your job is to apply them quickly, not memorise them. What is NOT supplied: direct differentiation, the frame-transform rule ${}^{e}J = {}^{e}_{0}R\cdot {}^{0}J$, the static-force duality $\boldsymbol\tau = J^T \boldsymbol F$, and the singularity condition $\det J = 0$.

| # | Archetype | Where it shows up | Typical method |
|---|---|---|---|
| 1 | Linear Jacobian by **direct differentiation** of FK | 23/24 Q18 (13 marks, the big set-piece); 22/23 Q2(b); 20/21 (ELEC0140) Q2(b) | Differentiate ${}^{0}P(\boldsymbol q)$ entry-wise |
| 2 | Rotational / linear Jacobian by **velocity propagation** | 21/22 Q2(b); Week 7 tutorial Q1(A); W7 lecture worked example | Run the recursive ${}^{i+1}\omega$, ${}^{i+1}v$ recipe from the sheet |
| 3 | Re-express Jacobian in a **different frame** | Week 7 tutorial Q1 (frames $\{3\}$ vs $\{4\}$); lecture worked example | Apply ${}^{B}J = {}^{B}_{A}R \cdot {}^{A}J$; shift origin via $v_e = v_n + \omega_n\times P_e$ |
| 4 | **Singularity** identification via $\det J = 0$ | 23/24 Q17 (definition, 1 mark) + Q18; 21/22 Q2(b); W7 lecture | Compute $\det J$, factor, set equal to zero, list configurations |
| 5 | **Static force / torque duality** $\boldsymbol\tau = J^T \boldsymbol F$ | 22/23 Q2(b); Week 7 tutorial Q2; W7 lecture | Transpose $J$, multiply by the **resisting** force vector |

Throughout this guide we follow Craig's modified-DH conventions and the leading-superscript frame notation (${}^{A}_{B}R$, ${}^{i}P_{i+1}$, etc.). Definitions of $J_v$, $J_\omega$, $\dot q_i$ etc. are as in `STUDY_FORMULAS.md` §4 — refer back for the bare formulae; here we focus on procedure.

---

## 1. Linear Jacobian by Direct Differentiation

This is the **default method when you are given (or can write down) the closed-form forward kinematics ${}^{0}P(\boldsymbol q)$.** It is the fastest route to the linear Jacobian and is what the 23/24 exam tested in its 13-mark set-piece (Q18).

### 1.1 Recipe

1. **Write the FK in component form** in the base frame:
   $${}^{0}P = \begin{bmatrix} f_x(\boldsymbol q) \\ f_y(\boldsymbol q) \\ f_z(\boldsymbol q) \end{bmatrix}.$$
2. **Identify the generalised joint coordinates** $q_i$ — $\theta_i$ for revolute, $d_i$ for prismatic. They become the columns of $J$.
3. **Build the $3\times n$ Jacobian** by partial differentiation:
   $$J_v = \begin{bmatrix} \dfrac{\partial f_x}{\partial q_1} & \cdots & \dfrac{\partial f_x}{\partial q_n} \\[3pt] \dfrac{\partial f_y}{\partial q_1} & \cdots & \dfrac{\partial f_y}{\partial q_n} \\[3pt] \dfrac{\partial f_z}{\partial q_1} & \cdots & \dfrac{\partial f_z}{\partial q_n} \end{bmatrix}.$$
4. **Sanity check** at a home configuration ($\theta_i = 0$): the structure of the Jacobian should match the geometry of the arm (e.g. for a planar arm the third row should vanish).

### 1.2 Common pitfalls

- **Chain rule on $\sin(\theta_1 + \theta_2)$**: $\partial/\partial\theta_1$ AND $\partial/\partial\theta_2$ both produce $\cos(\theta_1+\theta_2)$ (different sign on the $-s_{12}$ derivative). Don't drop one of them.
- **Mixed revolute–prismatic columns** are fine — just differentiate w.r.t. whichever $q_i$ that column corresponds to. The derivative of a position w.r.t. a translation variable is dimensionless (entries are pure trig); the derivative w.r.t. a rotation is a length (entries scale with $L_i$ or $d_i$). Mixing units across columns is **expected** — do not "fix" it.
- **Frame**: by default this gives ${}^{0}J_v$. To get ${}^{e}J_v$ apply the frame-transform rule from §3.

### 1.3 Worked mini-example — 23/24 Q18

Given (from the exam):
$${}^{0}P = \begin{bmatrix} L_1 c_1 s_{12} + L_2 c_2 \\ d_3 \\ L_1 c_1 c_{12} + d_3 s_2 \end{bmatrix},\qquad \boldsymbol q = (\theta_1, \theta_2, d_3)^T.$$

Column-by-column:

- Column 1 ($\partial / \partial\theta_1$): $x$ uses product rule, $\partial(c_1 s_{12})/\partial\theta_1 = -s_1 s_{12} + c_1 c_{12}$; $y$ has no $\theta_1$; $z$ similarly.
- Column 2 ($\partial / \partial\theta_2$): only the $s_{12}$, $c_{12}$, $c_2$, $s_2$ factors carry $\theta_2$. So $\partial x/\partial\theta_2 = L_1 c_1 c_{12} - L_2 s_2$ (the $L_2 c_2$ contributes a $-L_2 s_2$).
- Column 3 ($\partial / \partial d_3$): $d_3$ appears explicitly in $y$ (giving $1$) and in $z$ (giving $s_2$).

$$J = \begin{bmatrix} L_1 c_1 c_{12} - L_1 s_1 s_{12} & L_1 c_1 c_{12} - L_2 s_2 & 0 \\ 0 & 0 & 1 \\ -L_1 c_1 s_{12} - L_1 s_1 c_{12} & -L_1 c_1 s_{12} + d_3 c_2 & s_2 \end{bmatrix}.$$

This single derivation was worth 4 of the 13 marks. The remaining 9 marks were the singularity analysis (§4 below).

### 1.4 Worked mini-example — 22/23 Q2(b)

With ${}^{0}P = [(L_2+L_3)c_2 - d_3 s_2 + L_1,\ 0,\ -(L_2+L_3)s_2 - d_3 c_2 + d_1]^T$ and $\boldsymbol q = (d_1, \theta_2, d_3)^T$:

$${}^{0}J = \begin{bmatrix} 0 & -(L_2+L_3)s_2 - d_3 c_2 & -s_2 \\ 0 & 0 & 0 \\ 1 & -(L_2+L_3)c_2 + d_3 s_2 & -c_2 \end{bmatrix}.$$

Note how the $d_1$ column ($q_1$ is prismatic, along $z$) is the pure unit vector $[0,0,1]^T$ — the linear stage just shifts the tip vertically. This is a useful sanity-check pattern: a prismatic column of $J_v$ is the **direction in which that joint translates the tip**.

---

## 2. Jacobian via Velocity Propagation

Use this method when:

- the question explicitly asks for it (Week 7 tutorial Q1; 21/22 Q2(b));
- you need the **rotational** Jacobian $J_\omega$ (direct differentiation can't get this);
- you don't have ${}^{0}P$ in closed form but you do have the per-link transforms.

The recurrences themselves are on the **formula sheet** — for a revolute joint
$${}^{i+1}\omega_{i+1} = {}^{i+1}_{i}R\cdot {}^{i}\omega_i + \dot\theta_{i+1} \cdot {}^{i+1}\hat Z_{i+1},$$
$${}^{i+1}v_{i+1} = {}^{i+1}_{i}R\cdot \bigl({}^{i}v_i + {}^{i}\omega_i \times {}^{i}P_{i+1}\bigr).$$
For a prismatic joint, drop the $\dot\theta\hat Z$ term from $\omega$ and add a $\dot d_{i+1}\hat Z_{i+1}$ term to $v$. **You do not need to memorise these — but you must apply them under time pressure.**

### 2.1 Recipe

1. **Set up**: read the per-link transforms ${}^{i-1}_{i}T$ off the DH table. Extract from each $T$ the rotation block ${}^{i-1}_{i}R$ (top-left $3\times 3$) and the translation ${}^{i-1}P_i$ (top-right $3\times 1$).
2. **Pre-invert the rotation** to get ${}^{i+1}_{i}R = {}^{i}_{i+1}R^T$. This is the rotation that appears in the recurrence (lifts a frame-$i$ vector into frame $i+1$). For each link, write down ${}^{i}_{i+1}R^T$ once.
3. **Initialise**: ${}^{0}\omega_0 = \boldsymbol 0$, ${}^{0}v_0 = \boldsymbol 0$ for a fixed base.
4. **Iterate outward**, link by link. At each step compute first ${}^{i+1}\omega_{i+1}$, then use it to compute ${}^{i+1}v_{i+1}$ — order matters because $v$ does not feed back into $\omega$ but $\omega$ feeds forward into the next $v$.
5. **Carry $\dot\theta_i$ / $\dot d_i$ symbolically** through all the algebra. Don't substitute numbers until the very end. The columns of $J$ are the coefficients of each $\dot q_i$ in the final expressions.
6. **End-effector step** (if frame $\{n\}$ is not at the tip): apply
   $${}^{n}\omega_e = {}^{n}\omega_n,\qquad {}^{n}v_e = {}^{n}v_n + {}^{n}\omega_n \times {}^{n}P_e.$$
7. **Pack into matrix form**. Each $\dot q_i$ scalar collects a column. With the result expressed in frame $\{n\}$ you have ${}^{n}J$. Re-express via §3 if needed.

### 2.2 Common pitfalls

- **Frame of expression vs. frame of reference.** ${}^{i}\omega_i$ is the *absolute* angular velocity of frame $i$ (w.r.t. the base), but *expressed* in the components of frame $i$. The pre-superscript is the frame of expression. Don't confuse it with the relative-velocity quantity ${}^{i}\Omega_{i+1}$ (joint $i+1$ rate, expressed in frame $i$).
- **${}^{i+1}\hat Z_{i+1}$ is always $[0,0,1]^T$** — by definition the $z$-axis in its own frame.
- **Cross product**: $\omega \times P$ — use the determinant formula. For the common case $\omega = [0,0,w]^T$ and $P = [p_x, p_y, 0]^T$,
  $$\omega \times P = [-w\,p_y,\ w\,p_x,\ 0]^T.$$
  (See `STUDY_FORMULAS.md` §8 for the cross-product reference card.)
- **Don't forget the cross-product term in $v$** even when the previous frame has $v_i = 0$ — the $\omega_i\times P_{i+1}$ contribution is what creates tangential tip velocity from a rotating shoulder joint.

### 2.3 Worked mini-example — 2-link planar (from W7 lecture)

DH and transforms as in the lecture: $\theta_1, \theta_2$ revolute, link lengths $L_1, L_2$, frame $\{1\}$ at joint 2, frame $\{2\}$ at the wrist. So ${}^{1}P_2 = [L_1, 0, 0]^T$.

**Frame {1}.**
$${}^{1}\omega_1 = \underbrace{{}^{1}_{0}R\cdot{}^{0}\omega_0}_{=0} + \dot\theta_1\hat Z_1 = [0,0,\dot\theta_1]^T,\qquad {}^{1}v_1 = \boldsymbol 0$$
(no velocity at the base pivot).

**Frame {2}.**
$${}^{2}\omega_2 = {}^{2}_{1}R\cdot{}^{1}\omega_1 + \dot\theta_2\hat Z_2 = [0,0,\dot\theta_1+\dot\theta_2]^T$$
(${}^{2}_{1}R$ rotates the $z$-axis component to itself since rotation is about $z$).

$${}^{2}v_2 = {}^{2}_{1}R\cdot \bigl({}^{1}v_1 + {}^{1}\omega_1\times {}^{1}P_2\bigr) = \begin{bmatrix} c_2 & s_2 & 0\\ -s_2 & c_2 & 0\\ 0 & 0 & 1\end{bmatrix}\begin{bmatrix} 0 \\ L_1\dot\theta_1 \\ 0\end{bmatrix} = \begin{bmatrix} L_1 s_2 \dot\theta_1 \\ L_1 c_2 \dot\theta_1 \\ 0\end{bmatrix}.$$

**End-effector** ${}^{2}P_e = [L_2, 0, 0]^T$:
$${}^{2}v_e = {}^{2}v_2 + {}^{2}\omega_2\times {}^{2}P_e = \begin{bmatrix} L_1 s_2 \dot\theta_1 \\ L_1 c_2 \dot\theta_1 + L_2(\dot\theta_1+\dot\theta_2) \\ 0\end{bmatrix}.$$

**Transform to base** via ${}^{0}v_e = {}^{0}_{2}R\cdot{}^{2}v_e$ (rotation by $\theta_1+\theta_2$ about $z$):
$${}^{0}v_e = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12} \\ 0 & 0\end{bmatrix}\begin{bmatrix}\dot\theta_1\\ \dot\theta_2\end{bmatrix},\qquad {}^{0}\omega_e = \begin{bmatrix} 0\\ 0\\ \dot\theta_1+\dot\theta_2\end{bmatrix}.$$

This $2\times 2$ block (dropping the all-zero last row) is the canonical $J_v$ you should be able to write from memory.

### 2.4 Worked mini-example — 3-DOF rotational wrist (21/22 Q2(b))

A human wrist modelled as three pure revolute joints (pronation/supination → deviation → flexion/extension). The DH table has all $a_{i-1} = 0$, $d_i = 0$, with $\alpha_0=0, \alpha_1=90°, \alpha_2=90°$, all three $\theta_i$ variable.

Starting from ${}^{0}\omega_0 = \boldsymbol 0$ and propagating:

$${}^{1}\omega_1 = [0,0,\dot\theta_1]^T,\qquad {}^{2}\omega_2 = [s_2\dot\theta_1,\ c_2\dot\theta_1,\ \dot\theta_2]^T,$$
$${}^{3}\omega_3 = [s_2 c_3 \dot\theta_1 + s_3\dot\theta_2,\ -s_2 s_3\dot\theta_1 + c_3\dot\theta_2,\ -c_2\dot\theta_1 + \dot\theta_3]^T.$$

Transform back to frame $\{0\}$ via ${}^{0}\omega_3 = {}^{0}_{3}R\cdot {}^{3}\omega_3$. After cancellation:

$${}^{0}J_\omega = \begin{bmatrix} 0 & s_1 & c_1 s_2 \\ 0 & -c_1 & s_1 s_2 \\ 1 & 0 & -c_2\end{bmatrix}.$$

The structure to spot here: column $j$ of $J_\omega$ (for an all-revolute manipulator) is the joint-$j$ axis expressed in frame $\{0\}$ — column 1 is $\hat Z_0 = [0,0,1]^T$ (the pronation axis), column 2 is $\hat Z_1$ expressed in $\{0\}$, etc. **This is a powerful sanity check**: if you can identify the joint axes in the base frame by inspection, you can write $J_\omega$ down directly without propagating.

Singularity follows in §4.

### 2.5 When to prefer propagation over differentiation

| Situation | Method |
|---|---|
| You need $J_\omega$ (rotational) | Propagation only — differentiation of position can't give it |
| You only need $J_v$ and you have ${}^{0}P$ | Differentiation — much faster |
| The exam question explicitly asks for one method | Use that one |
| You want both $J_v$ and $J_\omega$ in one pass | Propagation gives you both for the same work |

---

## 3. Re-expressing the Jacobian in a Different Frame

A Jacobian has a **frame of expression** (the leading superscript). The same physical Jacobian — same physics, same singularities — can be written in $\{0\}$, $\{n\}$, $\{e\}$, or any intermediate frame, and they differ by a rotation. The question "find the Jacobian in frame $\{k\}$" is therefore a 30-second rotation application — provided you already have it in some frame.

### 3.1 The frame-transform rule (memorise — not on the sheet)

For both linear and rotational Jacobians:

$${}^{B}J_v = {}^{B}_{A}R\cdot {}^{A}J_v,\qquad {}^{B}J_\omega = {}^{B}_{A}R\cdot {}^{A}J_\omega.$$

This works because $J$ is a $3\times n$ matrix whose columns are velocity vectors expressed in frame $A$; rotating each column into frame $B$ rotates the whole matrix from the left.

### 3.2 Shifting the reference point (origin of $\{e\}$ vs $\{n\}$)

Frame transform alone is not enough if the **origin** also moves (e.g. frame $\{4\}$ at the tip vs frame $\{3\}$ at the wrist with the same orientation). Use the end-effector recurrence to add the lever-arm term:

$${}^{n}v_e = {}^{n}v_n + {}^{n}\omega_n \times {}^{n}P_e,\qquad {}^{n}\omega_e = {}^{n}\omega_n.$$

Substitute the existing column-by-column expressions for ${}^{n}v_n$ and ${}^{n}\omega_n$ (i.e. ${}^{n}J_v$ and ${}^{n}J_\omega$) and read off the new columns of ${}^{n}J_v$-at-tip.

### 3.3 Recipe

1. Identify the current frame of expression and origin of the Jacobian.
2. If the **frame of expression** changes (origin same), left-multiply by ${}^{B}_{A}R$.
3. If the **origin** changes (frame same), use $v_e = v_n + \omega_n\times P_e$ — that is, for each column $j$ of $J_v$, add the cross product $({\rm column\ }j{\rm\ of\ }J_\omega) \times P_e$.
4. Combine both if both change.

### 3.4 Worked mini-example — Week 7 tutorial Q1, $\{3\}$ → $\{4\}$

Tutorial Q1 derives a 3-DOF arm's Jacobian in frame $\{3\}$ (at the wrist), then asks for the Jacobian "in frame $\{4\}$ at the tip of the hand, with the same orientation as $\{3\}$". Same orientation → no rotation factor; only the origin shifts by ${}^{3}P_4 = [L_3, 0, 0]^T$ (the tutorial uses ${}^{3}P_4 = [L_3, 0, 0]^T$).

Given (from the propagation): ${}^{3}\omega_3 = [s_{23}\dot\theta_1,\ c_{23}\dot\theta_1,\ \dot\theta_2 + \dot\theta_3]^T$, ${}^{3}v_3$ expressions in $\dot\theta_1, \dot\theta_2$.

Apply: ${}^{3}v_e = {}^{3}v_3 + {}^{3}\omega_3 \times {}^{3}P_4$. With $P_4 = [L_3, 0, 0]^T$,
$${}^{3}\omega_3 \times {}^{3}P_4 = \begin{bmatrix} 0 \\ L_3(\dot\theta_2 + \dot\theta_3) \\ -L_3 c_{23}\dot\theta_1 \end{bmatrix}.$$

Add column-wise to ${}^{3}v_3$; the new linear Jacobian is the matrix of coefficients of $\dot\theta_1, \dot\theta_2, \dot\theta_3$ in this sum.

### 3.5 Pitfall — which Jacobian goes where

In the **static-force duality** $\boldsymbol\tau = J^T \boldsymbol F$, the frame of $J$ must match the frame in which $\boldsymbol F$ is expressed. If $\boldsymbol F$ is given in frame $\{0\}$ (as on 22/23 Q2(b)), use ${}^{0}J^T$. If it's given in the tool frame, use ${}^{e}J^T$. Mismatching frames is a common error.

---

## 4. Kinematic Singularities — $\det J = 0$

A kinematic singularity is a configuration where the Jacobian loses rank — the end-effector cannot instantaneously move (or rotate) in some Cartesian direction (23/24 Q17, 1 mark, asks exactly this).

**Mathematical condition**: $J(\boldsymbol q)$ is non-invertible. For a square Jacobian this is $\det J(\boldsymbol q) = 0$; for non-square (redundant) it is rank deficiency.

Note: every Jacobian question on a square problem in past papers reduces to a determinant calculation. **Take the determinant of the matrix you already wrote down.** No new physics.

### 4.1 Recipe

1. **Get $J$** (any frame — singularities are frame-invariant) and **make it square** if it isn't already by dropping all-zero rows (if the manipulator is planar, the third row of $J_v$ is identically zero; drop it together with the corresponding "missing" Cartesian DOF).
2. **Compute $\det J$.** For $2\times 2$ use $ad-bc$; for $3\times 3$ expand along the row/column with the most zeros (often there is one — see worked examples below). Use Rule of Sarrus or cofactor expansion (see `STUDY_FORMULAS.md` §8).
3. **Simplify ruthlessly** using $s_A c_B \pm c_A s_B = s(A\pm B)$ etc. The simplified determinant should factor into something like $L_a L_b \sin(\cdot)$ or $L_a L_b \cos(\cdot)$.
4. **Set $\det J = 0$**. State each root as a configuration in terms of joint variables.
5. **Interpret physically** if the question asks: e.g. "arm fully stretched" ($\theta_2 = 0$), "arm fully folded back" ($\theta_2 = \pi$), "wrist axes 4 & 6 collinear".

### 4.2 Common pitfalls

- **Don't expand the full polynomial blindly.** Expanding a $3\times 3$ via cofactors along the row with a 1 and two zeros (as 23/24 Q18's row 2 does) cuts work by two-thirds.
- **Trig collapse**: every Jacobian determinant in past papers eventually simplifies dramatically. If your expression stays messy after one round of identity-application, you've made an algebra slip — go back.
- **Wrist singularity wording is back-to-front in the W7 slide deck** (slide 46). The slide says the wrist "loses ability to rotate about the [collinear] axis" — wrong. At a wrist singularity (axes 4 and 6 collinear) the lost DOF is the rotation about an axis **perpendicular** to the collinear pair. The collinear-axis rotation is, if anything, redundantly retained. **Phrase your exam answer using the corrected statement** (per Craig §5.8 and `LORE.md`).
- **Mechanical advantage**: at a singularity, certain external forces require zero joint torque (because $J^T$ has a non-trivial null vector). See the W7 worked example with arm straight-up holding a 1000 N load — joint torques are exactly zero.

### 4.3 Worked mini-example — 2-link planar arm

From §2.3, $J_v = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12}\end{bmatrix}$. Expanding:

$$\det J_v = (-L_1 s_1 - L_2 s_{12})(L_2 c_{12}) - (-L_2 s_{12})(L_1 c_1 + L_2 c_{12})$$
$$= -L_1 L_2 s_1 c_{12} - L_2^2 s_{12}c_{12} + L_1 L_2 s_{12} c_1 + L_2^2 s_{12} c_{12}$$
$$= L_1 L_2 (s_{12} c_1 - s_1 c_{12}) = L_1 L_2 \sin(\theta_1 + \theta_2 - \theta_1) = L_1 L_2 s_2.$$

Singular when $s_2 = 0$, i.e. $\theta_2 = k\pi$ — arm fully stretched ($\theta_2 = 0$) or fully folded back ($\theta_2 = \pi$). Memorise this configuration — it appears as a sanity-check pattern across exam questions.

### 4.4 Worked mini-example — 23/24 Q18 (extension of §1.3)

Given the $3\times 3$ Jacobian derived in §1.3. Row 2 is $[0,\ 0,\ 1]$ — one entry, two zeros. Expand $\det J$ along row 2:

$$\det J = (-1)^{2+3}\cdot 1 \cdot \det\!\underbrace{\begin{bmatrix} J_{11} & J_{12} \\ J_{31} & J_{32}\end{bmatrix}}_{2\times 2\text{ minor}} \cdot (-1)\quad =\quad -\det\!\begin{bmatrix}J_{11} & J_{12} \\ J_{31} & J_{32}\end{bmatrix}.$$

(The sign depends on cofactor convention; what matters is that you reduce a $3\times 3$ to a $2\times 2$ in one stroke.) After algebra (using $c_A c_B - s_A s_B = c(A+B)$, $c_A s_B + s_A c_B = s(A+B)$):

$$\det J = L_1 d_3 c_2 \cos(2\theta_1 + \theta_2) + L_1^2 s_1 c_1 - L_1 L_2 s_2 \sin(2\theta_1 + \theta_2).$$

Setting $\det J = 0$ requires special-casing — the model solution substitutes $d_3 = L_2$ then exhibits two example singular configurations ($\theta_1 = 0°, \theta_2 = 45°$ and $\theta_1 = 90°, \theta_2 = 45°$). The exam awarded 3 marks just for **listing** valid singular configurations, not for a general solution.

### 4.5 Worked mini-example — 21/22 Q2(b), wrist Jacobian

From §2.4, ${}^{0}J_\omega = \begin{bmatrix} 0 & s_1 & c_1 s_2 \\ 0 & -c_1 & s_1 s_2 \\ 1 & 0 & -c_2\end{bmatrix}$.

Expand along column 1 (just one non-zero entry, $J_{31} = 1$):

$$\det J_\omega = 1\cdot \det\begin{bmatrix} s_1 & c_1 s_2 \\ -c_1 & s_1 s_2\end{bmatrix} = s_1^2 s_2 + c_1^2 s_2 = s_2 (s_1^2 + c_1^2) = s_2.$$

Singular when $s_2 = 0$, i.e. $\theta_2 = 0, \pm\pi$ — the deviation joint is in its straight or fully-folded position, and pronation/extension axes become aligned (the classic wrist singularity).

---

## 5. Static-Force / Torque Duality — $\boldsymbol\tau = J^T \boldsymbol F$

The same Jacobian governs the static dual: if the end-effector applies a force $\boldsymbol F$ to the environment, the joint torques required to hold the manipulator in **static equilibrium** are
$$\boldsymbol\tau = J^T(\boldsymbol q)\,\boldsymbol F.$$

This is the most algorithmic question type in the syllabus — you literally transpose, multiply, simplify.

### 5.1 Recipe

1. **Decide whose force goes in.** If the question says an *external* force $\boldsymbol F_{\rm ext}$ acts on the tip, the manipulator must apply $\boldsymbol F_{\rm robot} = -\boldsymbol F_{\rm ext}$ to balance it; substitute $\boldsymbol F_{\rm robot}$ into the duality. If the question says the *robot applies* $\boldsymbol F$, use $\boldsymbol F$ directly.
2. **Match frames**: ${}^{0}J^T$ multiplies a force expressed in $\{0\}$; ${}^{e}J^T$ multiplies a force in $\{e\}$. If frames don't match, rotate the force first via ${}^{B}\boldsymbol F = {}^{B}_{A}R\cdot {}^{A}\boldsymbol F$ (cheaper than re-expressing $J$).
3. **Use the linear-only form** $J = J_v$ (3×n, force is 3-vector) unless the question specifies an end-effector **moment** as well — then use the full $6\times n$ Jacobian and the 6-vector wrench $[F_x, F_y, F_z, n_x, n_y, n_z]^T$.
4. **Compute** $\boldsymbol\tau = J^T \boldsymbol F$. The output has one entry per joint; the units differ by joint type — N·m for revolute, N for prismatic.
5. **Sanity check the sign**: at a sensible configuration, does the torque direction match intuition? (e.g. pushing left with a planar arm should give a negative shoulder torque if positive shoulder rotation lifts the arm anti-clockwise.)

### 5.2 Common pitfalls

- **External vs. applied force**: the W7 lecture's wall-push example flips the sign — read the question carefully. "External force on the tip" and "force the robot applies to the wall" differ by a sign.
- **Units in the output vector**: do NOT report "N" for every entry. A revolute joint's $\tau_i$ is in **N·m**; a prismatic joint's $\tau_i$ is in **N**. The 22/23 mark scheme awards a half-mark for getting units right.
- **At a singularity** $J$ is rank-deficient → $J^T$ has a non-trivial null space → certain external forces lead to $\boldsymbol\tau = \boldsymbol 0$ ("mechanical advantage"). If a problem asks "is there a configuration where the robot can hold this load with zero torque?", that's a singularity question in disguise.

### 5.3 Worked mini-example — Week 7 tutorial Q2

Given ${}^{0}J_v = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & -L_2 s_{12} \\ L_1 c_1 + L_2 c_{12} & L_2 c_{12}\end{bmatrix}$ and ${}^{0}\boldsymbol F = 10\hat X_0 = [10, 0]^T$:

$$\boldsymbol\tau = J^T \boldsymbol F = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & L_1 c_1 + L_2 c_{12} \\ -L_2 s_{12} & L_2 c_{12}\end{bmatrix} \begin{bmatrix} 10 \\ 0 \end{bmatrix} = \begin{bmatrix} -10(L_1 s_1 + L_2 s_{12}) \\ -10 L_2 s_{12}\end{bmatrix}\ {\rm N\cdot m}.$$

Both torques have units N·m (both joints revolute).

### 5.4 Worked mini-example — 22/23 Q2(b)

External force ${}^{0}\boldsymbol F = [-1, 0, -1]^T$ N → robot must apply ${}^{0}\boldsymbol F_{\rm robot} = [1, 0, 1]^T$ N.

With the linear Jacobian from §1.4:

$$\boldsymbol\tau = J^T \boldsymbol F_{\rm robot} = \begin{bmatrix} 0 & 0 & 1 \\ -(L_2+L_3)s_2 - d_3 c_2 & 0 & -(L_2+L_3)c_2 + d_3 s_2 \\ -s_2 & 0 & -c_2\end{bmatrix}\begin{bmatrix} 1 \\ 0 \\ 1\end{bmatrix}.$$

Substitute $d_1 = 1$, $\theta_2 = -90°$ ($s_2 = -1$, $c_2 = 0$), $d_3 = 0$:

$$\boldsymbol\tau = \begin{bmatrix} 1 \\ (L_2 + L_3) \\ 1\end{bmatrix},\qquad \text{units: } [{\rm N},\ {\rm N\cdot m},\ {\rm N}].$$

(Joints 1 and 3 are prismatic → N; joint 2 is revolute → N·m.)

### 5.5 Worked mini-example — singular configuration, no torque needed

W7 lecture "Case 2": arm $\theta_1 = 90°$, $\theta_2 = 0°$ (straight up, fully extended → singular). Robot supports a 1000 N load vertically (${}^{0}\boldsymbol F_{\rm robot} = [0, 1000]^T$).

$$\boldsymbol\tau = \begin{bmatrix} -L_1 s_1 - L_2 s_{12} & L_1 c_1 + L_2 c_{12} \\ -L_2 s_{12} & L_2 c_{12}\end{bmatrix}\begin{bmatrix} 0 \\ 1000\end{bmatrix} = \begin{bmatrix} (L_1 c_1 + L_2 c_{12}) \cdot 1000 \\ L_2 c_{12} \cdot 1000\end{bmatrix}.$$

At $\theta_1 = 90°, \theta_2 = 0°$: $c_1 = 0$, $c_{12} = c_1 = 0$ → $\boldsymbol\tau = [0, 0]^T$. **The structure carries the load directly through the links** — motors do no work. This is the mechanical-advantage interpretation of singularities.

---

## 6. Computing End-Effector Velocity Given Joint Rates (and the Inverse)

A natural sub-archetype that didn't make it to its own section: $\boldsymbol v = J(\boldsymbol q)\,\dot{\boldsymbol q}$ and the inverse $\dot{\boldsymbol q} = J^{-1}(\boldsymbol q)\,\boldsymbol v$.

- **Forward**: given $J$ and $\dot{\boldsymbol q}$, multiply — done.
- **Inverse**: invert $J$ (use the $2\times 2$ inverse $\frac{1}{\det J}\begin{bmatrix} d & -b \\ -c & a\end{bmatrix}$ for planar arms; for $3\times 3$, use $A^{-1} = \operatorname{adj}(A)/\det(A)$). Near a singularity $\det J$ approaches zero and $\dot{\boldsymbol q}$ blows up — the inverse is ill-conditioned. Quote this in any answer about "what happens near a singularity".

No past-paper question in the four available papers asks for a numeric forward/inverse velocity calculation, but this remains within scope — be ready to do it in 3 minutes if it appears.

---

## 7. Strategy and Time Budget

The Jacobian section is consistently ~14% of marks across past papers (every year). On 23/24 it appeared as:

- **1 mark** (Q17): definition + condition for singularity (1-sentence recall).
- **13 marks** (Q18): direct differentiation + symbolic determinant + list singular configurations (~25 min — see `EXAM_ANALYSIS.md`).

Drill the 23/24 Q18 procedure end-to-end at least three times: it's pure mechanical algebra and very high marks per minute. If a 22/23-style question appears (smaller-mark Jacobian + numeric static-force), the procedure is identical but shorter; budget ~10 min.

**Marks are awarded per intermediate step**, not just for the final answer. Lay out:

1. The position-vector components ${}^{0}P = [f_x, f_y, f_z]^T$ (1–2 marks).
2. The Jacobian as an explicit symbolic matrix of partial derivatives (4–5 marks).
3. The determinant computation, with each algebraic simplification step (4–6 marks).
4. The singular configurations listed in joint-variable form (2–3 marks).

A single sign error halfway through does not cost more than 1 mark if the **structure** of your work is visible.

---

## 8. Quick Reference Card

- **Linear Jacobian (direct diff):** $J_v = \partial f / \partial \boldsymbol q$, entry-wise.
- **Velocity propagation (on sheet):** outward $\omega, v$ recursion; remember end-effector step $v_e = v_n + \omega_n \times P_e$.
- **Frame transform (not on sheet):** ${}^{B}J = {}^{B}_{A}R \cdot {}^{A}J$ (both blocks).
- **Singularity:** $\det J = 0$ (square case); end-effector loses an instantaneous DOF.
- **Static duality (not on sheet):** $\boldsymbol\tau = J^T \boldsymbol F$, frame-matched, sign-checked (robot's applied vs external).
- **Mechanical advantage:** at singular $\boldsymbol q$, certain external forces give $\boldsymbol\tau = \boldsymbol 0$.
- **W7 errata to remember:** wrist-singularity wording in slide 46 is reversed (lost DOF is **perpendicular** to the collinear axis, not along it); slide-34 Jacobian-block row label says $y$ where it should say $z$.
- **Units in $\boldsymbol\tau$:** N·m for revolute joints, N for prismatic joints. Report them.
