# CONTROL_GUIDE — ELEC0129 Manipulator Control (W10)

Step-by-step problem-solving recipes for every control archetype that has shown up in the W10 tutorials and the four past papers. **Critical caveat**: the official formula sheet lists **"None"** under Control — *nothing* in this guide will be supplied in the exam. Memorise the canonical mass-spring-damper ODE, the three damping cases, the critical-damping rule $k_v = 2\sqrt{m k_p}$, and the model-based-compensator / servo split.

## What to know — archetype table

| # | Archetype | Typical question | Source examples |
|---|---|---|---|
| 1 | Mass-spring-damper free response | "Determine $x(t)$ given $m, b, k$ and ICs." | W10 Q1, Q2, Q3; 23/24 Q27 |
| 2 | Classify the damping case | "Under what condition is the system overdamped?" | 23/24 Q28 |
| 3 | PD-gain design on a known plant | Pick $k_p$ for stiffness, then $k_v$ for critical damping | W10 slide 33 worked example |
| 4 | Control-law partitioning, scalar nonlinear plant | "Give the nonlinear control equations… critically damped, stiffness X." | W10 Q4 |
| 5 | Trajectory-following with partitioning | Feedforward + error feedback; derive tracking-error ODE | 21/22 Q5(a); 23/24 Q30 |
| 6 | Single-joint DC-motor + load partitioning | Use $(I+I_m\eta^2)$, $(b+b_m\eta^2)$, possibly $+k$ from friction | 21/22 Q5(a) |
| 7 | Closed-loop error response from a designed controller | Solve $\ddot e + k_v\dot e + k_p e = 0$ for $e(t)$, then $\theta(t) = \theta_d - e(t)$ | 21/22 Q5(b) |
| 8 | Effect of changing stiffness on the response category | Decrease/increase $k_p$ → walk through underdamped→critical→overdamped | 21/22 Q5(c) |
| 9 | MIMO partitioned control of the full manipulator | Use $M(q)f + V + G$, diagonal $K_p, K_v$ | W10 Q5; ELEC0140 21 Q4(c) |
| 10 | Robot control block diagrams | Cartesian → IK → independent joint loops, or → MIMO servo | 23/24 Q26; 21/22 Q5; ELEC0140 21 Q4(c) |
| 11 | Conceptual: why does $x\to x_d$? Why is independent linear control bad? | One-line answers worth 0.75–1 mark each | 23/24 Q29, Q30 |

**Errata to keep in mind** (from `materials/LORE.md`):
- **W10 slide 25 has a typo**: it writes the closed-loop equivalence as $m\ddot x + k_v\dot x + k_p x = 0 \leftrightarrow m\ddot x + b\dot x + bx = 0$ — the stiffness term on the right is **wrong** ($b$ instead of $k$). The correct mapping is $k_v \leftrightarrow b$ (damping) and $k_p \leftrightarrow k$ (stiffness). Memorise the canonical $m\ddot x + b\dot x + kx$, not the typo.
- **W10 slide 78 MATLAB demo is silently pure-P, not PD** (case-sensitivity bug between `q1dot` and `q1Dot`, plus missing feedforward). The theoretical structure on slides 36/67 is correct; don't reproduce the demo code from memory.
- 21/22 Q5(c) solution text says "Because the roots are equal, we will have overdamped response" for the stiffness-3 case — but the roots are $-1, -3$ (distinct). The classification is right; the reasoning sentence is a typo. Phrase your answer as "real and **distinct** roots → overdamped".

---

## Archetype 1 — Free response of a mass-spring-damper

**Plant:** $m\ddot x + b\dot x + kx = 0$, with given $x(0)$, $\dot x(0)$. Find $x(t)$.

### Step 1 — Write the characteristic equation

$$m\lambda^2 + b\lambda + k = 0 \quad\Rightarrow\quad \lambda_{1,2} = \frac{-b \pm \sqrt{b^2 - 4mk}}{2m}.$$

### Step 2 — Classify by the sign of the discriminant $b^2 - 4mk$

| Sign | Case | Roots | General solution |
|---|---|---|---|
| $> 0$ | **Overdamped** | real, distinct $\lambda_1 \ne \lambda_2$ | $x(t) = c_1 e^{\lambda_1 t} + c_2 e^{\lambda_2 t}$ |
| $= 0$ | **Critically damped** | real, equal $\lambda = -b/(2m)$ | $x(t) = (c_1 + c_2 t)\,e^{\lambda t}$ |
| $< 0$ | **Underdamped** | complex $p \pm qi$ with $p = -b/(2m)$, $q = \sqrt{4mk-b^2}/(2m)$ | $x(t) = e^{p t}(c_1 \cos qt + c_2 \sin qt)$ |

### Step 3 — Pin down $c_1, c_2$ from initial conditions

Write $\dot x(t)$ by differentiating the chosen general solution (product rule on every exponential-times-something). Then substitute $t=0$ into both $x(t)$ and $\dot x(t)$. Solve the 2-by-2 linear system in $c_1, c_2$.

**Tip — "initially at rest"** means $\dot x(0) = 0$. The release position is $x(0)$.

### Mini-example A — overdamped (W10 tutorial Q1)

$m = 2, b = 6, k = 4$, released from rest at $x(0) = 1$.

Characteristic equation $2\lambda^2 + 6\lambda + 4 = 0 \Rightarrow \lambda^2 + 3\lambda + 2 = 0$, so $\lambda = -1, -2$ (overdamped: $36 > 32$).

$x(t) = c_1 e^{-t} + c_2 e^{-2t}$, $\dot x(t) = -c_1 e^{-t} - 2 c_2 e^{-2t}$.

Apply ICs: $c_1 + c_2 = 1$ and $-c_1 - 2c_2 = 0$, giving $c_1 = 2, c_2 = -1$. So

$$x(t) = 2 e^{-t} - e^{-2t}.$$

### Mini-example B — critically damped (W10 tutorial Q2)

$m = 1, b = 2, k = 1$, released from rest at $x(0) = 4$.

$\lambda^2 + 2\lambda + 1 = 0 \Rightarrow \lambda = -1$ (repeated, $b^2 = 4mk$).

$x(t) = (c_1 + c_2 t)e^{-t}$, $\dot x(t) = (-c_1 + c_2 - c_2 t)e^{-t}$.

ICs: $c_1 = 4$, $-c_1 + c_2 = 0 \Rightarrow c_2 = 4$. So

$$x(t) = (4 + 4t)\,e^{-t}.$$

### Mini-example C — underdamped (W10 tutorial Q3)

$m = 1, b = 4, k = 5$, released from rest at $x(0) = 2$.

$\lambda^2 + 4\lambda + 5 = 0$, discriminant $16 - 20 = -4$, so $\lambda = -2 \pm i$.

$x(t) = e^{-2t}(c_1 \cos t + c_2 \sin t)$.

$\dot x(t) = e^{-2t}\bigl(-2(c_1 \cos t + c_2 \sin t) + (-c_1 \sin t + c_2 \cos t)\bigr)$.

ICs: $c_1 = 2$, $-2 c_1 + c_2 = 0 \Rightarrow c_2 = 4$. So

$$x(t) = e^{-2t}(2\cos t + 4 \sin t).$$

### Mini-example D — underdamped, ugly numbers (23/24 Q27)

$m = 3, b = 2, k = 4$, released from rest at $x(0) = 2$.

Characteristic equation $3\lambda^2 + 2\lambda + 4 = 0$, $\lambda = (-2 \pm \sqrt{4 - 48})/6 = -\tfrac{1}{3} \pm i\tfrac{\sqrt{11}}{3}$.

$x(t) = e^{-t/3}\!\bigl(c_1 \cos(\tfrac{\sqrt{11}}{3} t) + c_2 \sin(\tfrac{\sqrt{11}}{3} t)\bigr)$.

When you differentiate, the chain rule pulls a factor of $\sqrt{11}/3$ out of the trig derivatives. The 23/24 model solution sloppily drops that factor when applying the ICs, but its final answer absorbs it into $c_2$:

$x(0) = c_1 = 2$ and (after the model's shortcut) $\dot x(0) = -\tfrac{1}{3}c_1 + c_2 = 0 \Rightarrow c_2 = \tfrac{2}{3}$. Result:

$$x(t) = 2 e^{-t/3}\cos(\tfrac{\sqrt{11}}{3} t) + \tfrac{2}{3} e^{-t/3}\sin(\tfrac{\sqrt{11}}{3} t).$$

The exam marking scheme accepts this; under time pressure, follow it. (The mathematically clean answer differentiates properly and gets $c_2 = \tfrac{2}{\sqrt{11}}$ in front of the $\sin$ with the $\tfrac{\sqrt{11}}{3}$ factor, which is the same total amplitude.)

---

## Archetype 2 — Classify the damping condition (1-liner)

**Q.** "What condition makes a mass-spring-damper overdamped?" (23/24 Q28)

Answer: **$b^2 > 4mk$**. Equivalently: damping is high relative to mass and stiffness. The marking scheme penalises "damping is high" alone — you must reference mass and stiffness, or quote the inequality.

For completeness:
- Critically damped $\iff b^2 = 4mk$.
- Underdamped $\iff b^2 < 4mk$.

---

## Archetype 3 — PD-gain design on a known plant

### 3a. Plant is a pure mass

Plant: $m\ddot x = F$. Choose $F = -k_v \dot x - k_p x$. Closed-loop:

$$m\ddot x + k_v \dot x + k_p x = 0.$$

Recipe:
1. Pick $k_p$ to hit the desired closed-loop stiffness (this **defines** stiffness for the closed-loop ODE — it is just the coefficient on $x$).
2. Critically damp: $k_v^2 = 4 m k_p \Rightarrow \boxed{k_v = 2\sqrt{m k_p}}$.

### 3b. Plant already has natural $b$ and $k$

Plant: $m\ddot x + b\dot x + kx = F$, $F = -k_v \dot x - k_p x$. Closed-loop coefficients **add**:

$$m\ddot x + (b + k_v)\dot x + (k + k_p) x = 0.$$

Recipe:
1. Choose $k_p$ so that $(k + k_p)$ matches the desired stiffness.
2. $k_v = 2\sqrt{m(k + k_p)} - b$.

**Trap.** $k_v$ is the **damping** gain, $k_p$ is the **stiffness** gain — the subscripts $v$/$p$ stand for "velocity" / "position" (they multiply $\dot x$ and $x$). If you swap them you get a sign-confusing mess. Memorise: $k_v \leftrightarrow$ damping, $k_p \leftrightarrow$ stiffness.

### Mini-example — W10 slide 33

$m = 10, b = 20, k = 10$. Want critically damped, stiffness 16.

Without partitioning: pick $k_p$ so that $k + k_p = 16 \Rightarrow k_p = 6$. Then $k_v = 2\sqrt{10 \cdot 16} - 20 = 2\sqrt{160} - 20 \approx 5.30$. *(This is what naive PD gives; partitioning, below, will be cleaner and the slide example actually does the partitioning route. See Archetype 4.)*

---

## Archetype 4 — Control-law partitioning (scalar nonlinear plant)

This is the **default exam pattern** ("Give the nonlinear control equations…"). Always reach for partitioning unless the question explicitly forbids it.

### Step 1 — Identify $m, b, k$ in the plant (the "mass", "damping", "stiffness" coefficients)

For a plant of the form $A(\theta)\ddot\theta + B(\theta, \dot\theta) = \tau$, you may need to be clever about what counts as the "mass". Convention:
- Anything that multiplies $\ddot\theta$ → the **inertia/mass** term $m$. It can depend on $\theta$.
- Everything else on the LHS (velocity terms, gravity, nonlinear coupling) → lump into a single **"plant residual"** term that the compensator will cancel.

### Step 2 — Write the model-based compensator

If plant is $m(\theta)\ddot\theta + h(\theta, \dot\theta) = \tau$, design

$$\tau = m(\theta)\,f + h(\theta, \dot\theta).$$

Substituting reduces the inner plant to **unit mass**:

$$\ddot\theta = f.$$

This is the key insight: **the compensator's job is to make the inner plant look like $\ddot\theta = f$**. Everything that was there gets cancelled, and the unit mass means $k_v = 2\sqrt{k_p}$ — no factor of $m$.

### Step 3 — Write the servo controller

For **regulation to $\theta_d = 0$**: $f = -k_v\dot\theta - k_p\theta$.

For **regulation to constant $\theta_d \ne 0$**: $f = -k_v\dot\theta - k_p(\theta - \theta_d)$.

For **trajectory tracking** (general): $f = \ddot\theta_d - k_v(\dot\theta - \dot\theta_d) - k_p(\theta - \theta_d)$. (See Archetype 5.)

### Step 4 — Pick the gains

Closed-loop becomes $\ddot\theta + k_v\dot\theta + k_p\theta = 0$ (regulation) or $\ddot e + k_v\dot e + k_p e = 0$ (tracking, with $e = \theta_d - \theta$).

- $k_p =$ desired closed-loop stiffness (just read off the question).
- $k_v = 2\sqrt{k_p}$ for critical damping (unit-mass inner plant!).

### Mini-example — W10 tutorial Q4

System: $(2\sqrt\theta + 1)\ddot\theta + 3\dot\theta^2 - \sin\theta = \tau$. Want critically damped, closed-loop stiffness 10.

- Identify $m(\theta) = 2\sqrt\theta + 1$ and $h = 3\dot\theta^2 - \sin\theta$.
- Model-based compensator: $\tau = (2\sqrt\theta + 1)\,f + 3\dot\theta^2 - \sin\theta$.
- Servo (regulation form here, since no $\theta_d$ specified): $f = -k_v \dot\theta - k_p \theta$.
- Gains: $k_p = 10$, $k_v = 2\sqrt{10}$.

That's the complete answer for this question class. **No $m$ inside the square root** — that is the entire payoff of partitioning, and the W10 deck emphasises it on slide 35.

### Mini-example — 23/24 Q26 / W10 slide 33 partitioned route

For the slide-33 numbers ($m = 10, b = 20, k = 10$, want stiffness 16):
- Compensator: $\tau = 10 f + 20\dot\theta + 10\theta$.
- Servo: $f = -k_v\dot\theta - k_p\theta$.
- $k_p = 16$, $k_v = 2\sqrt{16} = 8$ (compare with the awkward $\approx 5.30$ without partitioning).

---

## Archetype 5 — Trajectory-following design

Plant: $m\ddot x + b\dot x + kx = F$. Trajectory $x_d(t), \dot x_d(t), \ddot x_d(t)$ known.

### Step 1 — Model-based compensator (same as regulation)

$$F = m\,f + b\dot x + kx.$$

Inner plant: $\ddot x = f$.

### Step 2 — Servo with feedforward

$$f = \ddot x_d - k_v(\dot x - \dot x_d) - k_p(x - x_d).$$

The three pieces:
- $\ddot x_d$ — **feedforward**: tells the controller what acceleration the trajectory itself demands.
- $-k_v(\dot x - \dot x_d)$ — velocity-error damping.
- $-k_p(x - x_d)$ — position-error spring.

### Step 3 — Tracking-error closed loop

Substitute into the plant and collect. Defining $e = x_d - x$ (sign convention: target minus actual):

$$\ddot e + k_v \dot e + k_p e = 0.$$

This is the **same ODE as in regulation**, with the same gain rule $k_v = 2\sqrt{k_p}$ for critical damping. Since $e \to 0$, the actual state $x$ tracks the desired $x_d$. This is the answer to 23/24 Q30 ("why does $x \to x_d$?"): because the tracking error obeys the same exponentially-decaying second-order ODE we already know how to drive to zero.

### Sign-convention warning

Different textbooks (and even different past papers) flip the sign of $e$:
- W10 slides, 23/24 Q30, this guide: $e = x_d - x$, $f = \ddot x_d - k_v(\dot x - \dot x_d) - k_p(x - x_d)$.
- 21/22 Q5(a), W10 Q5: $e = \theta_d - \theta$, $f = \ddot\theta_d + k_v(\dot\theta_d - \dot\theta) + k_p(\theta_d - \theta)$.

These are **algebraically identical**: $-(\dot x - \dot x_d) = (\dot x_d - \dot x)$. Just be consistent within one answer. The closed-loop tracking-error ODE is $\ddot e + k_v \dot e + k_p e = 0$ in either convention.

### Mini-example — 21/22 Q5(a) — joint with viscous friction

Plant (after absorbing the viscous-friction term $\tau_\text{fric} = k\dot\theta$ into the LHS):

$$(I + I_m\eta^2)\ddot\theta + (b + b_m\eta^2 + k)\dot\theta = \tau$$

with $I=10, I_m=1, b=5, b_m=1, \eta=5, k=0.2$. Want stiffness $k_p = 5$ and damping $k_v = 4$ (these are given; the question does **not** ask for critical damping in this case).

- Compensator: $\tau = (I + I_m\eta^2) f + (b + b_m\eta^2 + k)\dot\theta = 35 f + 30.2\,\dot\theta$.
- Servo (tracking): $f = \ddot\theta_d + k_v(\dot\theta_d - \dot\theta) + k_p(\theta_d - \theta)$.
- Pick $k_p = 5, k_v = 4$ as required (note: this gives $k_v^2 = 16 < 20 = 4 k_p$, so the closed loop is **underdamped**, not critical — see Archetype 7).

**Block diagram (prose form):** trajectory $(\theta_d, \dot\theta_d, \ddot\theta_d)$ → servo block computing $f$ → multiplied by $(I + I_m\eta^2)$ → summed with $(b + b_m\eta^2 + k)\dot\theta$ → output $\tau$ drives joint → sensor returns $\theta, \dot\theta$ to the servo block. See the ASCII diagrams in `materials/past_papers/ELEC0129_2122.md` Q5(a).

---

## Archetype 6 — Single-joint DC-motor + load

The full single-joint model reduces to a load-side ODE with the same structure as a mass-damper (no spring):

$$\bigl(I + I_m\eta^2\bigr)\ddot\theta + \bigl(b + b_m\eta^2\bigr)\dot\theta = \tau.$$

- $I$: load inertia. $I_m$: motor-rotor inertia. $\eta = r_2/r_1$: gear ratio (load-radius over motor-radius).
- $b$: load-side viscous friction. $b_m$: motor-side viscous friction.
- $\tau$: load-side joint torque ($= \eta\tau_m$ where $\tau_m$ is motor torque).

**Memorise** the $\eta^2$ pattern: motor-side inertia and damping reflect through the gear as $\eta^2$ times themselves. Velocities reflect as $\dot\theta_m = \eta\dot\theta$; torques reflect as $\tau = \eta\tau_m$ (load-side torque is amplified relative to motor torque, but at the cost of being slower).

### Translating control output to motor voltage

If the controller asks for load torque $\tau$, the motor needs to supply $\tau_m = \tau/\eta$. Then $\tau_m = k_m i_a$ gives the armature current, and the (neglecting-$L_a$) circuit equation

$$R_a i_a = V_a - k_e \dot\theta_m$$

gives the armature voltage:

$$V_a = R_a i_a + k_e \dot\theta_m = R_a (\tau_m / k_m) + k_e \eta\dot\theta.$$

You probably won't be asked for the voltage in a closed-form derivation; the chain is enough to know.

---

## Archetype 7 — Solving the closed-loop error ODE (21/22 Q5(b))

If the controller has been **designed correctly** (per Archetypes 4 or 5), the error ODE is $\ddot e + k_v\dot e + k_p e = 0$. Solve as in Archetype 1, then recover $\theta(t) = \theta_d - e(t)$ if needed.

### Mini-example — 21/22 Q5(b)

$k_p = 5, k_v = 4$. ICs: $e(0) = 4, \dot e(0) = 0$.

1. Characteristic equation: $\lambda^2 + 4\lambda + 5 = 0$, $\lambda = -2 \pm i$. **Underdamped**.
2. $e(t) = e^{-2t}(c_1 \cos t + c_2 \sin t)$.
3. $\dot e(t) = e^{-2t}\bigl(-2(c_1\cos t + c_2\sin t) + (-c_1\sin t + c_2\cos t)\bigr)$.
4. ICs: $c_1 = 4$, $-2 c_1 + c_2 = 0 \Rightarrow c_2 = 8$.
5. $e(t) = 4 e^{-2t}(\cos t + 2\sin t)$.

**Optional single-sinusoid form** ($A\sin(t + \varphi)$ with $A\cos\varphi = 2, A\sin\varphi = 1$): $A = \sqrt 5, \varphi = \text{atan}(1/2)$.

$$e(t) = 4\sqrt 5 \, e^{-2t} \sin\!\bigl(t + \text{atan}(1/2)\bigr).$$

**For $\theta_d = 4$ (constant):** $\theta(t) = 4 - e(t)$ starts at $\theta(0) = 0$ and rises rapidly to $\theta = 4$ — the response settles within roughly the first second; visible oscillation is suppressed by the fast exponential envelope. Sketch: a rapid first-order-like rise from 0 to 4 with a small overshoot.

---

## Archetype 8 — How does the response change with stiffness?

This is the 21/22 Q5(c) question type — keep $k_v$ fixed, ask what happens to the response as $k_p$ (closed-loop stiffness) varies.

### Recipe

For a fixed $k_v$, the error ODE is $\ddot e + k_v \dot e + k_p e = 0$, characteristic equation $\lambda^2 + k_v \lambda + k_p = 0$. Discriminant: $k_v^2 - 4 k_p$.

- $k_p < k_v^2 / 4$: real, distinct roots → **overdamped**.
- $k_p = k_v^2 / 4$: real, equal roots → **critically damped**.
- $k_p > k_v^2 / 4$: complex roots → **underdamped**.

So as $k_p$ **decreases** from above $k_v^2/4$ to below it, the response goes **underdamped → critically damped → overdamped**. As $k_p$ **increases**, it's the reverse.

### Mini-example — 21/22 Q5(c)

With $k_v = 4$ (so $k_v^2/4 = 4$):
- $k_p = 5$ → discriminant $-4 < 0$ → underdamped ($\lambda = -2 \pm i$).
- $k_p = 4$ → discriminant $0$ → critical ($\lambda = -2$ repeated).
- $k_p = 3$ → discriminant $+4 > 0$ → overdamped (real, distinct $\lambda = -1, -3$).

**Conclusion:** as stiffness decreases, the response goes **underdamped → critically damped → overdamped**.

(Errata watch: the 21/22 model solution says "Because the roots are equal" for the $k_p = 3$ case, which is wrong — the roots there are distinct. Write "real and distinct → overdamped" in your answer.)

---

## Archetype 9 — MIMO partitioned control of the full manipulator

Plant (from W9 dynamics): $M(q)\ddot q + V(q,\dot q) + G(q) = \tau$.

### Step 1 — Model-based compensator (vector form)

$$\tau = M(q)\,f + V(q,\dot q) + G(q).$$

Substituting cancels everything and leaves $\ddot q = f$ — i.e. each joint behaves like an **independent unit mass**.

### Step 2 — Servo controller (vector form)

$$\boxed{f = \ddot q_d - K_v(\dot q - \dot q_d) - K_p(q - q_d),}$$

with $K_p, K_v$ **diagonal** matrices. Per-joint critical damping:

$$K_p = \operatorname{diag}(k_{p1}, k_{p2}, \ldots),\qquad K_v = \operatorname{diag}(2\sqrt{k_{p1}}, 2\sqrt{k_{p2}}, \ldots).$$

Each joint then satisfies the scalar error ODE $\ddot e_i + k_{vi}\dot e_i + k_{pi} e_i = 0$ independently.

### Step 3 — If there's friction

Include $\tau_\text{friction}$ in the compensator just like $V$ and $G$:

$$\tau = M(q)\,f + V(q,\dot q) + G(q) + \tau_\text{friction}(\dot q).$$

(See ELEC0140 21 Q4(c).)

### Mini-example — W10 tutorial Q5

System:
$$m_1 l_1^2 \ddot\theta_1 + m_1 l_1 l_2 \dot\theta_1 \dot\theta_2 = \tau_1,$$
$$m_2 l_2^2 (\ddot\theta_1 + \ddot\theta_2) + v_2 \dot\theta_2 = \tau_2.$$

In canonical form $M\ddot q + V = \tau$:
$$M = \begin{bmatrix} m_1 l_1^2 & 0 \\ m_2 l_2^2 & m_2 l_2^2 \end{bmatrix},\quad V = \begin{bmatrix} m_1 l_1 l_2 \dot\theta_1\dot\theta_2 \\ v_2 \dot\theta_2 \end{bmatrix}.$$

Compensator: $\tau = M f + V$.

Servo: $f = \ddot q_d + K_d(\dot q_d - \dot q) + K_p(q_d - q)$ with $K_p = \text{diag}(k_{p1}, k_{p2})$ and $K_d = \text{diag}(2\sqrt{k_{p1}}, 2\sqrt{k_{p2}})$ for critical damping.

**"What's wrong with this robot model?"** — $M$ is **not symmetric** (the $(1,2)$ entry is $0$ but the $(2,1)$ entry is $m_2 l_2^2 \ne 0$). A valid mass matrix from Lagrangian dynamics is always symmetric positive-definite; this one isn't, so the model is non-physical. (Memorise this as the standard W9-dynamics sanity check: $M(q)$ must be symmetric.)

### Mini-example — ELEC0140 21/22 Q4(c)

Plant $M(q)\ddot q + V + G = \tau - \tau_\text{friction}$. Want critical damping with per-joint stiffness $k_{p1}, k_{p2}$.

- Compensator: $\tau = M(q) f + V(q,\dot q) + G(q) + \tau_\text{friction}$.
- Servo: $f = \ddot q_d - K_v(\dot q - \dot q_d) - K_p(q - q_d)$.
- $K_p = \text{diag}(k_{p1}, k_{p2})$, $K_v = \text{diag}(2\sqrt{k_{p1}}, 2\sqrt{k_{p2}})$.

Block-diagram requirement: if the trajectory comes in **Cartesian** space, prepend an **inverse-kinematics** block to get joint-space $(q_d, \dot q_d, \ddot q_d)$ before the servo controller. The full pipeline is

$$xy\text{ trajectory} \;\to\; [\text{IK}] \;\to\; [\text{Servo: } f] \;\to\; [\times M(q)] \;\to\; [+V + G + \tau_\text{fric}] \;\to\; \tau \;\to\; \text{Robot} \;\to\; q.$$

The robot's $q, \dot q$ feed back into the servo (negative feedback on position and velocity errors).

---

## Archetype 10 — Block diagrams

### Cartesian reference, individual joint control (23/24 Q26)

```
x_target → [J^{-1} or IK] → q_target,1 → (○-) → [Ctrl] → [Joint 1] → q_1
                            q_target,n → (○-) → [Ctrl] → [Joint n] → q_n
                                          ▲                            │
                                          └────── feedback ────────────┘
```

One independent feedback loop per joint $i = 1\ldots n$. Each summing junction takes its own joint reference and its own measured $q_i$.

### Cartesian reference, MIMO complete-manipulator control (ELEC0140 21 Q4(c))

```
xy → [IK] → (q_d, q̇_d, q̈_d) → [Servo: f] → [×M(q)] → (+) → τ → [Robot] → q
                  ▲                                      ▲              │
                  └ feedback q, q̇ ──────────────────────┘              │
                                                  [V + G + τ_fric] ←────┘
```

The servo block computes the auxiliary $f$. The compensator multiplies by $M(q)$ and adds the nonlinear compensation $V + G + \tau_\text{fric}$. The robot's measured state feeds back into both the servo (for error) and the compensator (because $M, V, G$ are functions of $q, \dot q$).

### Individual joint with partitioning (21/22 Q5(a))

```
(θ_d, θ̇_d, θ̈_d) ──► [Servo: f = θ̈_d + k_v(θ̇_d − θ̇) + k_p(θ_d − θ)]
                          │ f
                          ▼
                  [×(I + I_m η²)] ── (+) ──► τ ──► [Joint]
                                       ▲                 │
                  [×(b + b_m η² + k)·θ̇]                 │
                                       ▲                 │
                  [Sensor: θ, θ̇] ◄──── feedback ─────────┘
```

---

## Archetype 11 — Conceptual short-answer prompts

These are 0.75–1 mark each in the 23/24 paper. Memorise the snappy version.

### "Why does trajectory-following control yield $x \to x_d$?" (23/24 Q30)

Define $e = x_d - x$. The partitioned controller substitution gives the closed-loop tracking error
$$\ddot e + k_v \dot e + k_p e = 0.$$
This is a stable second-order ODE (positive gains), so $e \to 0$ exponentially, which means $x \to x_d$. Sketch: $e(t)$ decays to zero on the left → $x(t)$ converges to $x_d(t)$ on the right.

### "What happens if linear control is applied to each joint independently?" (23/24 Q29)

The independent-joint assumption ignores coupling and configuration-dependent inertia. Result: undesirable behaviour, e.g. **damping is not uniform across the workspace** (a robot tuned to be critically damped in one pose can be under- or overdamped in another, because the perceived inertia at each joint actually depends on $q$).

### "Sketch a block diagram, Cartesian reference, joint-level control" (23/24 Q26)

See Archetype 10 first diagram. The structure is IK → independent per-joint loops.

### Common false-friend gotchas

- "Stiffness X" in the question = the **closed-loop $k_p$** in $\ddot e + k_v\dot e + k_p e = 0$, not the natural plant stiffness $k$. Always.
- "Critically damped" with no additional info → use $k_v = 2\sqrt{k_p}$ (unit-mass inner plant) or $k_v = 2\sqrt{m k_p}$ (raw plant, no partitioning). Read the question to see which they're after — if they ask for "control equations" they want partitioning.
- "Damping X" with $X \ne 2\sqrt{k_p}$ → the question is **not** asking for critical damping. Just plug in whatever $k_v$ they specify (21/22 Q5 does this: $k_v = 4$ with $k_p = 5$).

---

## One-page checklist (revise from this)

1. Mass-spring-damper free response: characteristic equation → discriminant → three cases → ICs.
2. The three damping conditions and their general-solution forms (memorise the table in §1).
3. Critical-damping rule: $k_v = 2\sqrt{m k_p}$ (raw plant); $k_v = 2\sqrt{k_p}$ (after partitioning).
4. Control-law partitioning: $\tau = m(\theta) f + h(\theta, \dot\theta)$, then $\ddot\theta = f$.
5. Regulation servo: $f = -k_v\dot\theta - k_p(\theta - \theta_d)$. Tracking servo: $f = \ddot\theta_d - k_v(\dot\theta - \dot\theta_d) - k_p(\theta - \theta_d)$ (or with all signs flipped on the error using $\theta_d - \theta$ convention — pick one and stick with it).
6. Tracking error ODE: $\ddot e + k_v\dot e + k_p e = 0$. Memorise this as the "why does the controller work" sentence.
7. Single-joint load-side dynamics: $(I + I_m\eta^2)\ddot\theta + (b + b_m\eta^2)\dot\theta = \tau$. The $\eta^2$ pattern is non-obvious — memorise it.
8. Add viscous friction by lumping $k\dot\theta$ into the damping coefficient on the LHS (21/22 Q5).
9. MIMO: $\tau = M(q) f + V + G$ (+ $\tau_\text{fric}$ if present); diagonal $K_p, K_v$; per-joint critical damping.
10. Block diagram patterns: independent-joint vs MIMO; remember to prepend IK when the reference is Cartesian.
11. Errata: slide-25 typo ($bx$ should be $kx$); 21/22 Q5(c) "equal" should be "distinct"; slide-78 MATLAB demo is silently pure-P. None of this affects the answers you give in the exam if you trust the canonical formulas in this guide.

Nothing here is on the formula sheet. Memorise all of it.
