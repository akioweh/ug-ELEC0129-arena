> Source: [ELEC0129\_08\_trajectory\_planning.pdf](../slides_original/ELEC0129_08_trajectory_planning.pdf)

# Trajectory Planning

## Introduction

Trajectory planning means designing a **time profile** of position, velocity and acceleration of a movement. For example, a car driving from A to B: the velocity starts from $0$, increases to $V_{\text{constant}}$ and stays constant for some time; as it approaches the target, the velocity decreases down to $0$. Similarly, a robot arm moving from an initial position toward an object accelerates at the start and decelerates at the end.

Trajectory planning is **not** about designing the "geographical" path — it is not about how to plan a route through a city, nor about how to plan an obstacle-avoiding path for a robot. It is about the **time profile** of the motion.

The designed time profile is expressed as mathematical functions:

$$u = f(t), \quad \dot u = f'(t), \quad \ddot u = f''(t)$$

From these functions, the computer can extract numerical values of $u, \dot u, \ddot u$ at any given $t$. These numerical values at different times $t$ are passed to the control system as **reference values** for the system (car, robot) to follow:

```
[u(0), u(0.1), u(0.2), ...]  →  R (reference) → (Σ) → Controller → System → Y (output)
                                                ↑_______________________________|
```

The task of this lecture is, given:

- the **current** position and orientation of the robot / end-effector,
- the desired **goal** position and orientation for the end-effector,
- the **time** to reach the goal position,
- the general **shape** of the path (straight line, polynomial, etc.),

write the function $u = f(t)$. Velocity $\dot u = f'(t)$ and acceleration $\ddot u = f''(t)$ then follow naturally by differentiation.

## Cartesian Space Schemes vs. Joint Space Schemes

### Cartesian space schemes

A Cartesian space scheme specifies the trajectory directly through the **position and orientation of the end-effector**:

$$x = f_x(t),\quad y = f_y(t),\quad z = f_z(t),\quad r_x = f_{rx}(t),\quad r_y = f_{ry}(t),\quad r_z = f_{rz}(t)$$

For example, to move the end-effector from $(x_A, y_A)$ to $(x_B, y_B)$, one designs $x = f_x(t)$ and $y = f_y(t)$ that smoothly interpolate between the start and end values.

**Advantages.** The shape of the geometrical path can be enforced (e.g. a straight line), and the orientation of the end-effector can be enforced (e.g. maintained constant throughout the motion).

**Disadvantages.**

1. **Computationally expensive.** Inverse kinematics must be solved at every time step (update rate) to convert the Cartesian reference into joint angles before passing them to the controller:

   ```
   [x(0),y(0); x(0.1),y(0.1); ...]  →  Inverse Kinematics  →  [q1*(0),q2*(0); ...]  →  (Σ) → Controller → System → Joint angles
                                                                                          ↑___________________________________|
   ```

2. **Prone to problems related to workspace and singularities.** Three failure modes:
   - intermediate points along the Cartesian path may be **outside the workspace** (unreachable) even when start and end are reachable;
   - start and end points may be reachable but only in **different inverse-kinematic configurations**, requiring a configuration change mid-path;
   - **high joint rates near singularities** can occur when the Cartesian path passes close to a singular configuration.

### Joint space schemes

A joint space scheme specifies the trajectory directly through the **joint angles**:

$$\theta_1 = f_{\theta 1}(t),\ \theta_2 = f_{\theta 2}(t),\ \theta_3 = f_{\theta 3}(t),\ \theta_4 = f_{\theta 4}(t),\ \theta_5 = f_{\theta 5}(t),\ \theta_6 = f_{\theta 6}(t)$$

For example, $\theta_1$ goes from $80°$ to $30°$ while $\theta_2$ goes from $-30°$ to $-10°$, with each $\theta_i = f_{\theta i}(t)$ designed as a smooth time profile.

**Advantages.**

- Easy to compute — the joint-space reference is fed directly to the controller, no inverse kinematics needed at each step:

   ```
   [q1*(0),q2*(0); q1*(0.1),q2*(0.1); ...]  →  (Σ) → Controller → System → Joint angles
                                                ↑___________________________________|
   ```

- No issue with singularities.

**Disadvantages.** The Cartesian path will not be linear (joints interpolate linearly in joint space, not in task space). This may be a problem if there are possible collisions along the resulting Cartesian path.

### Common notation

Regardless of whether the trajectory is specified in Cartesian space or joint space, the design process — i.e. the form of the mathematical function — is the same. The remainder of the lecture uses $u(t)$ to represent the trajectory variable, standing in for any Cartesian coordinate or joint angle:

$$u = f_u(t)$$

### The general problem

Given:

- the start position $u_0$,
- the end position $u_f$,
- the time $t_f$ to reach the final position,

generate a trajectory $u = f_u(t)$ for the robot to follow.

## Straight Line

The simplest trajectory is a straight time profile between start and end:

$$u(t) = \begin{cases} \dfrac{u_f - u_0}{t_f}\, t + u_0 & t < t_f \\[2pt] u_f & t \ge t_f \end{cases}$$

**Disadvantage:** velocities are **discontinuous** at the start and end points. The resulting rough, jerky motion causes vibrations due to resonance modes, and increases wear and tear.

## Cubic Polynomial

To ensure zero velocity at the start and end points, use a cubic polynomial:

$$u(t) = \begin{cases} a_0 + a_1 t + a_2 t^2 + a_3 t^3 & t < t_f \\ u_f & t \ge t_f \end{cases}$$

### Coefficients from boundary conditions

The four parameters $a_0, a_1, a_2, a_3$ are fixed by **four constraints** (boundary conditions):

$$u(0) = u_0, \qquad u(t_f) = u_f, \qquad \dot u(0) = 0, \qquad \dot u(t_f) = 0$$

The velocity is

$$\dot u(t) = \frac{d}{dt}\big(a_0 + a_1 t + a_2 t^2 + a_3 t^3\big) = a_1 + 2 a_2 t + 3 a_3 t^2$$

Writing out the four simultaneous equations:

$$\begin{aligned}
u(0) &= a_0 = u_0 \\
u(t_f) &= a_0 + a_1 t_f + a_2 t_f^2 + a_3 t_f^3 = u_f \\
\dot u(0) &= a_1 = 0 \\
\dot u(t_f) &= a_1 + 2 a_2 t_f + 3 a_3 t_f^2 = 0
\end{aligned}$$

Solving gives:

$$\boxed{\;a_0 = u_0, \qquad a_1 = 0, \qquad a_2 = \frac{3}{t_f^2}(u_f - u_0), \qquad a_3 = -\frac{2}{t_f^3}(u_f - u_0)\;}$$

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

$$\begin{aligned}
a_0 &= 15 \\
a_1 &= 0 \\
a_2 &= \frac{3}{3^2}(75 - 15) = 20 \\
a_3 &= -\frac{2}{3^3}(75 - 15) = -4.44
\end{aligned}$$

The trajectory is

$$u(t) = \begin{cases} 15 + 20 t^2 - 4.44\, t^3 & t < 3 \\ 75 & t \ge 3 \end{cases}$$

### Profile shape

Position rises smoothly from $u_0$ to $u_f$ in an S-curve; velocity is a symmetric parabolic hump that starts and ends at $0$ with a peak near the midpoint; acceleration is a straight line decreasing from a positive value at $t = 0$ through zero at the midpoint to an equal-magnitude negative value at $t = t_f$.

**Note:** the **accelerations at start and end are not zero** (they are $2 a_2$ and $2 a_2 + 6 a_3 t_f$ respectively). This produces a discontinuity in acceleration at the trajectory boundaries and may create jerky motion.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions %
%%%%%%%%%%%%%%%%%%%%%%%

u0 = 15;
uf = 75;
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%
% Create Time Array %
%%%%%%%%%%%%%%%%%%%%%%

t = 0:0.001:tf;   % array of time from 0 to tf in steps of 0.001
t = t';           % make the time array into column vector

%%%%%%%%%%%%%%%%%%%%%%%
% Cubic Polynomial %
%%%%%%%%%%%%%%%%%%%%%%%

a0 = u0;
a1 = 0;
a2 = 3/tf^2*(uf-u0);
a3 = -2/tf^3*(uf-u0);

uCubic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3;
uDotCubic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2;
uDoubleDotCubic = 2*a2*ones(length(t),1) + 6*a3*t;

figure, sgtitle('Cubic')
subplot(1,3,1), plot(t,uCubic),         title('Position')
subplot(1,3,2), plot(t,uDotCubic),      title('Velocity')
subplot(1,3,3), plot(t,uDoubleDotCubic), title('Acceleration')
```

## Quintic Polynomial

The cubic polynomial has only 4 parameters and so can only satisfy 4 constraints, $u(0), u(t_f), \dot u(0), \dot u(t_f)$ — leaving the start/end accelerations uncontrolled. To additionally constrain accelerations at the boundaries, $\ddot u(0)$ and $\ddot u(t_f)$, we need 6 parameters: the **quintic polynomial**.

$$u(t) = \begin{cases} a_0 + a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5 & t < t_f \\ u_f & t \ge t_f \end{cases}$$

### Coefficients from boundary conditions

With $\dot u(0) = \dot u(t_f) = 0$ and $\ddot u(0) = \ddot u(t_f) = 0$, the six simultaneous equations from

$$\begin{aligned}
u(t)        &= a_0 + a_1 t + a_2 t^2 + a_3 t^3 + a_4 t^4 + a_5 t^5 \\
\dot u(t)   &= a_1 + 2 a_2 t + 3 a_3 t^2 + 4 a_4 t^3 + 5 a_5 t^4 \\
\ddot u(t)  &= 2 a_2 + 6 a_3 t + 12 a_4 t^2 + 20 a_5 t^3
\end{aligned}$$

are

$$\begin{aligned}
u(0) &= a_0 = u_0 \\
u(t_f) &= a_0 + a_1 t_f + a_2 t_f^2 + a_3 t_f^3 + a_4 t_f^4 + a_5 t_f^5 = u_f \\
\dot u(0) &= a_1 = 0 \\
\dot u(t_f) &= a_1 + 2 a_2 t_f + 3 a_3 t_f^2 + 4 a_4 t_f^3 + 5 a_5 t_f^4 = 0 \\
\ddot u(0) &= 2 a_2 = 0 \\
\ddot u(t_f) &= 2 a_2 + 6 a_3 t_f + 12 a_4 t_f^2 + 20 a_5 t_f^3 = 0
\end{aligned}$$

Solving gives:

$$\boxed{\;
a_0 = u_0,\quad a_1 = 0,\quad a_2 = 0,\quad
a_3 = \frac{10}{t_f^3}(u_f - u_0),\quad
a_4 = -\frac{15}{t_f^4}(u_f - u_0),\quad
a_5 = \frac{6}{t_f^5}(u_f - u_0)
\;}$$

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

$$\begin{aligned}
a_0 &= 15,\quad a_1 = 0,\quad a_2 = 0 \\
a_3 &= \frac{10}{3^3}(75 - 15) = 22.22 \\
a_4 &= -\frac{15}{3^4}(75 - 15) = -11.11 \\
a_5 &= \frac{6}{3^5}(75 - 15) = 1.48148
\end{aligned}$$

$$u(t) = \begin{cases} 15 + 22.22\, t^3 - 11.11\, t^4 + 1.48148\, t^5 & t < 3 \\ 75 & t \ge 3 \end{cases}$$

### Profile shape

Position again rises in an S-curve. Velocity is a smooth hump that starts at $0$, peaks near the midpoint, and returns to $0$. **Acceleration is now continuous at the start and end** — it begins at $0$, rises to a positive peak, crosses zero near the midpoint, falls to a symmetric negative peak, and returns to $0$ at $t_f$.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial %
%%%%%%%%%%%%%%%%%%%%%%%

a0 = u0;
a1 = 0;
a2 = 0;
a3 =  10/tf^3*(uf-u0);
a4 = -15/tf^4*(uf-u0);
a5 =   6/tf^5*(uf-u0);

uQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
uDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
uDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('Quintic')
subplot(1,3,1), plot(t,uQuintic),         title('Position')
subplot(1,3,2), plot(t,uDotQuintic),      title('Velocity')
subplot(1,3,3), plot(t,uDoubleDotQuintic), title('Acceleration')
```

## Linear Function with Parabolic Blends

### Motivation

The cubic and quintic polynomials, while smooth, are not the most natural profile when you think of a real motion. Driving from A to B, you would **not** slowly increase speed, reach maximum velocity exactly halfway, and then slowly decrease — instead you would:

- increase speed smoothly but rapidly up to a maximum velocity (e.g. 70 mph),
- maintain the maximum velocity (constant) for a long time,
- decrease speed to zero smoothly but rapidly as you reach the destination.

This is the **linear function with parabolic blends** (sometimes called bang-bang or LSPB):

- a **first parabolic blend** during $[0, t_b]$ with constant acceleration $\ddot u$,
- a **linear (constant-velocity) segment** during $[t_b, t_f - t_b]$,
- a **second parabolic blend** during $[t_f - t_b, t_f]$ with constant deceleration $-\ddot u$.

### Required inputs and assumptions

Four pieces of information are needed: the start position $u_0$, the end position $u_f$, the final time $t_f$, and the acceleration $\ddot u$ of the first blend portion.

Three assumptions are made:

- **A1.** Both parabolic blends have the **same time duration** $t_b$. Hence the deceleration of the second blend equals $-\ddot u$.
- **A2.** The solution is **symmetric** about the halfway point in time $t_h$ and position $u_h$.
- **A3.** The **velocity at the end of the first blend** equals the velocity along the linear region.

### Velocity and position in the blend region

In the first blend $\ddot u$ is constant. Starting from $\dot u(0) = 0$:

$$\dot u(t) = \int \ddot u \, dt = \underbrace{\dot u_0}_{0} + \ddot u\, t = \ddot u\, t$$

Integrating once more, with $u(0) = u_0$:

$$u(t) = \int \dot u \, dt = u_0 + \tfrac{1}{2} \ddot u\, t^2$$

### Piecewise trajectory

The full trajectory, given the blend endpoint $(t_b, u_b)$ and halfway point $(t_h, u_h)$, is

$$u(t) = \begin{cases}
u_0 + \dfrac{1}{2} \ddot u\, t^2 & t < t_b \\[6pt]
\dfrac{u_h - u_b}{t_h - t_b}(t - t_b) + u_b & t_b \le t < (t_f - t_b) \\[6pt]
u_f - \dfrac{1}{2} \ddot u\, (t_f - t)^2 & t \ge (t_f - t_b)
\end{cases}$$

<!-- pedagogical-omission: slides 49 and 55 write the third branch with no upper bound on `t`. For the trajectory to remain at `u_f` after `t_f`, the branch should terminate at `t = t_f` and a constant `u_f` should follow for `t > t_f`. Plugging `t > t_f` into the third branch (the parabola is symmetric about `t_f`) makes the position fall back below `u_f`. The cubic and quintic earlier in this deck do include the `t ≥ t_f → u_f` cap, so this is internally inconsistent. Harmless in practice since you stop sampling at `t = t_f`; just a missing terminal case. -->

The unknowns are $u_b$ and $t_b$.

### Solving for $t_b$ and $u_b$

From **A3**, the velocity at the end of the first blend equals the slope of the linear segment:

$$\ddot u\, t_b = \frac{u_h - u_b}{t_h - t_b} \qquad (1)$$

Express $u_b$ in terms of $t_b$ using the blend-region position formula:

$$u_b = u_0 + \tfrac{1}{2}\, \ddot u\, t_b^2 \qquad (2)$$

The symmetry assumption **A2** gives:

$$u_h = \tfrac{1}{2}(u_0 + u_f) \qquad (3)$$
$$t_h = \tfrac{1}{2}\, t_f \qquad (4)$$

Substituting (2), (3), (4) into (1):

$$\ddot u\, t_b = \frac{\tfrac{1}{2}(u_0 + u_f) - u_0 - \tfrac{1}{2}\, \ddot u\, t_b^2}{\tfrac{1}{2}\, t_f - t_b}
\quad\Longrightarrow\quad
\ddot u\, t_b^2 - \ddot u\, t_f\, t_b + (u_f - u_0) = 0$$

This is a quadratic in $t_b$. Solving:

$$t_b = \frac{\ddot u\, t_f - \sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}
     = \frac{t_f}{2} - \frac{\sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}$$

Only the **minus** sign for the square root is kept, because $t_b \le t_f / 2$. Then substitute $t_b$ back into $u_b = u_0 + \tfrac{1}{2} \ddot u\, t_b^2$ to obtain $u_b$.

### Constraint on the chosen acceleration

The acceleration $\ddot u$ must be **high enough** for a solution to $t_b$ to exist. If $\ddot u$ is too small, the linear region shrinks; if it is too small still, there is no linear region at all and no real solution.

A real solution requires the discriminant in $t_b$ to be non-negative:

$$\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0) \ge 0
\quad\Longrightarrow\quad
\ddot u^2 t_f^2 \ge 4\, \ddot u\, (u_f - u_0)
\quad\Longrightarrow\quad
\boxed{\;\ddot u \ge 4\, \dfrac{u_f - u_0}{t_f^2}\;}$$

### Summary of the procedure

Given $u_0$, $u_f$, $t_f$:

1. Choose desired acceleration $\ddot u$ satisfying $\ddot u \ge 4\,(u_f - u_0)/t_f^2$.
2. Compute
   $$t_b = \frac{t_f}{2} - \frac{\sqrt{\ddot u^2 t_f^2 - 4\, \ddot u\, (u_f - u_0)}}{2\, \ddot u}, \qquad
   u_b = u_0 + \tfrac{1}{2} \ddot u\, t_b^2$$
3. Form the piecewise trajectory
   $$u(t) = \begin{cases}
   u_0 + \tfrac{1}{2} \ddot u\, t^2 & t < t_b \\[4pt]
   \dfrac{u_h - u_b}{t_h - t_b}(t - t_b) + u_b & t_b \le t < (t_f - t_b) \\[4pt]
   u_f - \tfrac{1}{2} \ddot u\, (t_f - t)^2 & t \ge (t_f - t_b)
   \end{cases}$$
   with $u_h = \tfrac{1}{2}(u_0 + u_f)$ and $t_h = \tfrac{1}{2} t_f$.

### Worked example

With $u_0 = 15°$, $u_f = 75°$, $t_f = 3\,\text{sec}$:

Minimum acceleration:

$$\ddot u \ge 4\,\frac{u_f - u_0}{t_f^2} = 4\,\frac{75 - 15}{3^2} = 26.6666$$

Choose $\ddot u = 100$. Then

$$t_b = \frac{3}{2} - \frac{\sqrt{100^2 \cdot 3^2 - 4 \cdot 100 \cdot (75 - 15)}}{2 \cdot 100} = 0.2155$$

$$u_b = 15 + \tfrac{1}{2} \cdot 100 \cdot 0.2155^2 = 17.3215$$

The trajectory then follows the standard three-piece form above.

### MATLAB implementation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions %
%%%%%%%%%%%%%%%%%%%%%%%

u0 = 15;
uf = 75;
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear with Parabolic Blend %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AccMin = 4*(uf-u0)/tf^2;
Acc    = round(4*AccMin/100)*100;   % Assume 4 x AccMin, round to closest 100
tb = tf/2 - sqrt(Acc^2*tf^2 - 4*Acc*(uf-u0))/2/Acc;
ub = u0 + 0.5*Acc*tb^2;
uh = 0.5*(u0+uf);
th = 0.5*tf;

% First blend
tBlend1 = 0:0.001:tb;
tBlend1 = tBlend1';
uBlend1 = u0*ones(length(tBlend1),1) + 0.5*Acc*tBlend1.^2;

% Linear portion
tLinear = tb+0.001:0.001:(tf-tb);
tLinear = tLinear';
uLinear = (uh-ub)/(th-tb)*(tLinear-tb) + ub;

% Second blend
tBlend2 = (tf-tb+0.001):0.001:tf;
tBlend2 = tBlend2';
uBlend2 = uf*ones(length(tBlend2),1) - 0.5*Acc*(tf-tBlend2).^2;

% Combine
tCombine = [tBlend1; tLinear; tBlend2];
uCombine = [uBlend1; uLinear; uBlend2];
figure, plot(tCombine, uCombine), title('Linear with Parabolic Blend - Position')
```

Plotting the result gives a position curve that is parabolic at both ends and linear in the middle, rising from $15$ to $75$ over $[0, 3]$ seconds.

## Trajectories with Multiple Segments

The MATLAB code above generates a trajectory for a **single move** only. When several moves are required, for example:

- move from $15°$ to $75°$ at $t = 0$ with duration $3$ seconds;
- stay at $75°$ until the next move;
- move from $75°$ to $50°$ at $t = 7$ with duration $3$ seconds;
- stay at $50°$ until the next move;
- move from $50°$ to $90°$ at $t = 15$ with duration $3$ seconds;
- etc.

each move can be generated with the per-segment formulae above and the segments concatenated in time. The corresponding position curve has alternating ramp-like and flat (dwell) regions; velocity is non-zero during each move and zero during dwells; acceleration has spikes at the move boundaries (cubic) or smoother bumps (quintic), with zero between moves.

This multi-segment construction is left as a coding exercise — it is required for the robot workshop.

<!-- transcription-audit:
- Dropped: title slide (slide 1) — boilerplate.
- Dropped: schedule slide (slide 2) — administrative, no lecture content.
- Dropped: top-level content/agenda slides and their progressive-highlight repeats (slides 3, 4, 12, 24, 34, 42, 61) — duplicated by the heading hierarchy of this transcript.
- Dropped: closing "Thank you" slide (slide 66) — boilerplate.
- Dropped: car-illustration and arm-illustration decorative cartoons (slides 5, 6, 44) — content is in the prose.
- Dropped: maze/obstacle decorative images (slide 7) — point made in text.
- Dropped: zigzag arm-trajectory figure (slide 21) — decorative; "non-linear Cartesian path" point captured in text.
- Dropped: position/velocity/acceleration example graphs that merely illustrate the equations already given (slides 8, 31, 40, 53, 60, 64, 65) — described in prose where they communicate something new (profile shape, near-degenerate LSPB), otherwise omitted. The multi-segment plots on slides 64–65 are summarised in prose only.
- Dropped: control-loop block-diagram on slide 10 — represented as inline ASCII once; later repeats (slides 16, 20) likewise represented inline at the points they appear.
- Warnings: none — figures are either reproducible from the equations or purely illustrative.
- Ambiguities: the LSPB MATLAB snippet uses `Acc = round(4*AccMin/100)*100`, which despite the comment "Assume 4 x AccMin" does NOT generally yield 4*AccMin (it rounds 4*AccMin/100 to the nearest integer then multiplies by 100). For the example values (AccMin = 26.67, so 4*AccMin/100 = 1.0667 → round to 1 → Acc = 100), the result happens to match the lecture's chosen Acc = 100, so this is transcribed verbatim without flagging as a source error.
- Suspected source errors (added on verifier pass):
  1. LSPB piecewise on slides 49 and 55 lacks a `t ≤ t_f` cap on the third branch (and the constant-after-t_f extension that the cubic and quintic versions of this deck do include). Inline `<!-- pedagogical-omission -->` flag near the piecewise definition. Harmless in practice; just internally inconsistent.
  2. Slide 58 MATLAB comment "Assume 4 x AccMin" mislabels what the code actually computes; transcribed verbatim and noted in the Ambiguities entry above.
- Stylistic normalisation (silent): the source uses `x = f(t), \dot x, \ddot x` in the Introduction (slides 5–11) before switching to the unified notation `u(t)` at slide 22; the transcript uses `u(t)` from the start to avoid the notation switch mid-document. No content change.
-->
