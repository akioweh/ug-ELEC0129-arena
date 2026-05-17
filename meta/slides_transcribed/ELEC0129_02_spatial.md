> Source: [ELEC0129\_02\_spatial.pdf](../slides_original/ELEC0129_02_spatial.pdf)

# Spatial Description and Transformation (Week 2, Part 1)

Robotic manipulation requires moving parts and tools around in space, so we need a way to **describe** the position and orientation of objects, **map** descriptions between coordinate frames, and combine those mappings via **transformation arithmetic**.

## Description of position and orientation

### Position of a point

To describe the position of a point $P$ in space we must first choose a **reference frame** (coordinate system). For example, the same physical point could be described as

- 15 cm from the left edge of a screen, 10 cm from the bottom edge, 0 cm out of the plane of the screen, **or**
- 5 m from the left wall of a classroom, 2 m from the front wall, 1.5 m above the floor.

Both descriptions refer to the same point — they only differ in the frame chosen.

Any point can be described with respect to any coordinate system using a $3 \times 1$ **position vector**. Using the leading-superscript frame notation, the position of $P$ expressed in frame $\{A\}$ is

$$
{}^{A}P = \begin{bmatrix} {}^{A}P_{x} \\ {}^{A}P_{y} \\ {}^{A}P_{z} \end{bmatrix}.
$$

The same physical point can be expressed in multiple frames. For a robot manipulator, the position of point $P$ with respect to the **robot base frame** $\{0\}$ is ${}^{0}P$, and with respect to the **end-effector frame** $\{E\}$ is ${}^{E}P$. These are the same point described in different frames.

### Position of a rigid body

A rigid body does not have a single "position" until we attach a **frame** to it. We pick the **origin** of that body-attached frame as the representative point. If the body is labelled $B$ and its attached frame has origin $P_{BORG}$, then in some reference frame $\{A\}$ the body's position is the position vector

$$
{}^{A}P_{BORG}.
$$

As with a point, the same body has different position vectors when expressed in different frames (e.g. ${}^{0}P_{BORG}$ in the robot base frame and ${}^{E}P_{BORG}$ in the end-effector frame).

### Orientation of a rigid body

Position alone is not enough to locate a rigid body — we also need its **orientation**. Attach a frame $\{B\}$ to the body and consider it relative to a reference frame $\{A\}$. Ignore translation by letting the two origins coincide, and scale the axes of each frame so they are unit vectors $\hat{X}, \hat{Y}, \hat{Z}$.

The orientation of $\{B\}$ with respect to $\{A\}$ is then captured by the **rotation matrix**

$$
{}^{A}_{B}R = \begin{bmatrix}
\hat{X}_{B} \cdot \hat{X}_{A} & \hat{Y}_{B} \cdot \hat{X}_{A} & \hat{Z}_{B} \cdot \hat{X}_{A} \\
\hat{X}_{B} \cdot \hat{Y}_{A} & \hat{Y}_{B} \cdot \hat{Y}_{A} & \hat{Z}_{B} \cdot \hat{Y}_{A} \\
\hat{X}_{B} \cdot \hat{Z}_{A} & \hat{Y}_{B} \cdot \hat{Z}_{A} & \hat{Z}_{B} \cdot \hat{Z}_{A}
\end{bmatrix}.
$$

Each entry is the dot product of a unit axis of $\{B\}$ with a unit axis of $\{A\}$, i.e. the **projection** of a $\{B\}$-axis onto an $\{A\}$-axis. The columns of ${}^{A}_{B}R$ are therefore the unit axes of $\{B\}$ expressed in $\{A\}$.

#### Elementary rotation matrices

Specialising the general formula to a rotation through an angle $\theta$ about a single axis (right-hand rule) gives the three elementary rotation matrices.

Rotation about the $x$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
1 & 0 & 0 \\
0 & \cos\theta & -\sin\theta \\
0 & \sin\theta & \cos\theta
\end{bmatrix}.
$$

Rotation about the $y$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & 0 & \sin\theta \\
0 & 1 & 0 \\
-\sin\theta & 0 & \cos\theta
\end{bmatrix}.
$$

Rotation about the $z$-axis only:

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & -\sin\theta & 0 \\
\sin\theta & \cos\theta & 0 \\
0 & 0 & 1
\end{bmatrix}.
$$

#### Properties of the rotation matrix

The rotation matrix is **orthonormal**:

- Each column (and each row) has unit magnitude.
- Each column is orthogonal (90 degrees) to the other columns, i.e. the dot product between any two distinct columns is zero.

A quick check on the $z$-rotation example above confirms this. As a consequence, the **inverse equals the transpose**:

$$
{}^{B}_{A}R = {}^{A}_{B}R^{-1} = {}^{A}_{B}R^{T}.
$$

### Description of a frame

To completely specify the whereabouts of a tool or object we need **both** position and orientation. A frame $\{B\}$ relative to a reference frame is therefore specified by a rotation matrix **and** the position vector of its origin:

$$
\{B\} = \left\{ {}^{A}_{B}R,\; {}^{A}P_{Borg} \right\}.
$$

For a manipulator the same body can be described relative to different reference frames, e.g.

$$
\{B\} = \left\{ {}^{0}_{B}R,\; {}^{0}P_{Borg} \right\}, \qquad \{B\} = \left\{ {}^{E}_{B}R,\; {}^{E}P_{Borg} \right\}.
$$

## Mapping between frames

**Mapping** answers: given a point $P$ already described in frame $\{B\}$ (so ${}^{B}P$ is known), what is its description ${}^{A}P$ in frame $\{A\}$? The point itself is not changed — only its description is changed.

### Pure translation

If frames $\{A\}$ and $\{B\}$ differ only by a translation (their axes are parallel), then

$$
{}^{A}P = {}^{B}P + {}^{A}P_{Borg}.
$$

**Caution:** vector addition is allowed only if the two frames have the **same orientation**.

### Pure rotation

If the frames share an origin but differ by a rotation, then

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P.
$$

The notation is useful for tracking which frame a quantity is expressed in: the "B" superscript on $P$ and the "B" subscript on $R$ cancel, leaving a quantity expressed in $\{A\}$.

#### Worked example — pure rotation

Frame $\{B\}$ is obtained by rotating $\{A\}$ about the $z$-axis by $30^{\circ}$. In frame $\{B\}$ the point $P$ has coordinates $[1, 1, 0]^{T}$. Find its coordinates in $\{A\}$.

First, build the rotation matrix using the general dot-product form, which for a $z$-rotation gives

$$
{}^{A}_{B}R = \begin{bmatrix}
\cos\theta & -\sin\theta & 0 \\
\sin\theta & \cos\theta & 0 \\
0 & 0 & 1
\end{bmatrix}
= \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}.
$$

Then compute

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P
= \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix} 1 \\ 1 \\ 0 \end{bmatrix}
= \begin{bmatrix} 0.366 \\ 1.366 \\ 0 \end{bmatrix}.
$$

This agrees with the geometric picture.

### General mapping: translation and rotation

If $\{A\}$ and $\{B\}$ differ by **both** translation and rotation, first re-express ${}^{B}P$ in a frame whose orientation matches $\{A\}$ (using the rotation matrix), and then add the translation. This gives the compound mapping

$$
{}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}.
$$

Using the previous numerical example with an added translation ${}^{A}P_{Borg} = [4, 2, 0]^{T}$:

$$
{}^{A}P = \begin{bmatrix}
0.866 & -0.5 & 0 \\
0.5 & 0.866 & 0 \\
0 & 0 & 1
\end{bmatrix}
\begin{bmatrix} 1 \\ 1 \\ 0 \end{bmatrix}
+ \begin{bmatrix} 4 \\ 2 \\ 0 \end{bmatrix}
= \begin{bmatrix} 4.366 \\ 3.366 \\ 0 \end{bmatrix}.
$$

### Homogeneous transformation matrix

The mixed form ${}^{A}P = {}^{A}_{B}R \cdot {}^{B}P + {}^{A}P_{Borg}$ is not very appealing because it is not a single matrix product. We would like to write

$$
{}^{A}P = {}^{A}_{B}T \cdot {}^{B}P,
$$

i.e. apply a single matrix operator. This is achieved by augmenting the $3 \times 1$ position vectors with a trailing $1$ and packing rotation and translation into a $4 \times 4$ block matrix:

$$
\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix}
=
\left[
\begin{array}{ccc|c}
& {}^{A}_{B}R & & {}^{A}P_{Borg} \\
\hline
0 & 0 & 0 & 1
\end{array}
\right]
\begin{bmatrix} {}^{B}P \\ 1 \end{bmatrix}.
$$

The $4 \times 4$ matrix operator is called the **homogeneous transformation** (HTM), denoted ${}^{A}_{B}T$.

For the example above:

$$
\begin{bmatrix} {}^{A}P \\ 1 \end{bmatrix}
=
\left[
\begin{array}{ccc|c}
0.866 & -0.5 & 0 & 4 \\
0.5 & 0.866 & 0 & 2 \\
0 & 0 & 1 & 0 \\
\hline
0 & 0 & 0 & 1
\end{array}
\right]
\begin{bmatrix} 1 \\ 1 \\ 0 \\ 1 \end{bmatrix}
= \begin{bmatrix} 4.366 \\ 3.366 \\ 0 \\ 1 \end{bmatrix}.
$$

The trailing $1$ in the result is discarded to recover the ordinary $3 \times 1$ position vector.

## Transformation arithmetic

### Compound transformations

A robot typically has several joints and links, giving a chain of frames. Suppose ${}^{E}P$ is known and the relative transformations along the chain $\{A\} \leftarrow \{B\} \leftarrow \{C\} \leftarrow \{D\} \leftarrow \{E\}$ are all known. What is ${}^{A}P$?

Apply mapping step by step:

$$
{}^{D}P = {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
{}^{C}P = {}^{C}_{D}T \cdot {}^{D}P = {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
{}^{B}P = {}^{B}_{C}T \cdot {}^{C}P = {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P,
$$

$$
\boxed{{}^{A}P = {}^{A}_{B}T \cdot {}^{B}P = {}^{A}_{B}T \cdot {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}P.}
$$

The notation makes the chain easy to track: the "inner" subscripts and superscripts cancel pairwise, leaving the desired $A \leftarrow E$ mapping.

### Transform equations

A common scenario: a robot whose base frame $\{A\}$ is connected to its end-effector $\{E\}$ through known link transforms ${}^{A}_{B}T,\; {}^{B}_{C}T,\; {}^{C}_{D}T,\; {}^{D}_{E}T$, and which is reaching for an object $\{G\}$ that sits on a table $\{F\}$, with the base-to-table and table-to-object transforms ${}^{A}_{F}T,\; {}^{F}_{G}T$ known. What is the end-effector-to-object transform ${}^{E}_{G}T$?

The same compound transform ${}^{A}_{G}T$ can be written along either path:

$$
{}^{A}_{G}T \;=\; {}^{A}_{B}T \cdot {}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T \;=\; {}^{A}_{F}T \cdot {}^{F}_{G}T.
$$

Solve for the unknown ${}^{E}_{G}T$ by left-multiplying both sides by inverses, peeling off one transform at a time:

$$
{}^{B}_{C}T \cdot {}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
{}^{C}_{D}T \cdot {}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
{}^{D}_{E}T \cdot {}^{E}_{G}T = {}^{C}_{D}T^{-1} \cdot {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T,
$$

$$
\boxed{{}^{E}_{G}T = {}^{D}_{E}T^{-1} \cdot {}^{C}_{D}T^{-1} \cdot {}^{B}_{C}T^{-1} \cdot {}^{A}_{B}T^{-1} \cdot {}^{A}_{F}T \cdot {}^{F}_{G}T.}
$$

How to compute the inverse of a $4 \times 4$ HTM efficiently (without doing a generic matrix inversion) is treated in the next lecture.

<!-- transcription-audit:
- Dropped: slide 1 (title slide) — boilerplate.
- Dropped: slide 2 (module schedule table) — administrative, not lecture content.
- Dropped: slides 3, 4, 21, 32 (agenda / content-progress slides) — replaced by the section headings of this transcript.
- Dropped: slide 37 ("Thank you for your attention!") — boilerplate.
- Dropped: decorative manipulator/cube cartoon imagery on slides 5, 9, 10 — illustrative only; the textual content already states the point.
- Dropped: right-hand-rule hand cartoons on slides 16-18 — purely a mnemonic; the sign convention is already encoded in the elementary rotation matrices.
- Dropped: page-number footers throughout.
- Merged: slides 6-8 into a single "Position of a point" sub-section; slides 9-12 into "Position of a rigid body"; slides 13-19 into "Orientation of a rigid body" (with elementary rotations as one sub-block and orthonormality as another); slides 22-23 into "Pure translation"; slides 24-27 into "Pure rotation" with the worked example inline; slides 28-31 into "General mapping" plus the "Homogeneous transformation matrix" sub-section; slides 33-34 into "Compound transformations"; slides 35-36 into "Transform equations".
- Warnings: none — all figures used in the deck were either decorative or reproducible as text/equations.
- Ambiguities: the compact frame description box on slide 20 is written as `{B} = {AR_B, AP_Borg}`; the slide does have a comma (verifier pass corrected this audit note — the original ambiguity claim was overstated). Transcribed as the unambiguous pair `{ ^A_B R, ^A P_Borg }`.
- Suspected source errors: none in substantive math (the elementary rotation matrices, inverse-equals-transpose claim, HTM block structure, compound transform order, and the 30° worked-example arithmetic all check out).
- Silent stylistic fixes applied on verifier pass: source "rotating along the z-axis" → "about the z-axis"; "Frames {B} is" → "Frame {B} is"; "coordinate of P" → "coordinates"; "Homogeneous Transform" rendered as "homogeneous transformation matrix (HTM)". `P_{BORG}` capitalisation in the source drifts between `BORG` and `Borg`; the transcript uses `Borg` consistently. None of these change the technical content.
-->
