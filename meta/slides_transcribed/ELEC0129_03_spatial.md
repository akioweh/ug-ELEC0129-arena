> Source: [ELEC0129\_03\_spatial.pdf](../slides_original/ELEC0129_03_spatial.pdf)

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
