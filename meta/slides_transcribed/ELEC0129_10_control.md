> Source: [ELEC0129\_10\_control.pdf](../slides_original/ELEC0129_10_control.pdf)

# Control of Manipulators

## Introduction

In trajectory planning we discussed the trajectory that the robot is required to follow. In this lecture we study how to control the robot (or joints) so that they follow the desired trajectory.

Two different techniques are available:

1. **Individual-joint control.** The nonlinear, coupled manipulator is approximated as a few linear and decoupled joints/links, and each joint is controlled individually. The structure is

   ```
   x_target → J^{-1} → q_target,i → (−) → Ctrl → Joint i → q_i
                                      ↑________________________|
   ```

   one such loop per joint $i = 1, \dots, n$.

2. **Complete-manipulator control.** The manipulator is viewed as a whole; joint readings are taken as a vector and the control signal is generated also as a vector. Performance is better because the nonlinearities and coupling are taken into consideration.

   ```
   x_target → J^{-1} → q_target → (−) → Ctrl → [Joint 1 … Joint n] → q
                                    ↑__________________________________|
   ```

The lecture builds the individual-joint case first (for its simplicity), then generalises to the complete manipulator.

## Second-Order Linear Systems

### Mass-spring system (frictionless)

A mass $m$ attached to a spring of stiffness $k$ on a frictionless surface, with equilibrium at $x = 0$. If the mass is perturbed and released, it oscillates indefinitely.

Newton's second law gives

$$m\ddot{x} = \sum \text{forces} = -kx \quad\Rightarrow\quad m\ddot{x} + kx = 0.$$

Solving this differential equation:

$$x = C_1 \cos\!\left(\sqrt{\tfrac{k}{m}}\,t\right) + C_2 \sin\!\left(\sqrt{\tfrac{k}{m}}\,t\right),$$

where $\omega_n = \sqrt{k/m}$ is the **natural frequency**.

### Mass-spring-damper system

Now add viscous friction $b$ (a damper). The surface is no longer frictionless; equilibrium is still $x = 0$. Perturbing and releasing the mass produces one of **three responses** depending on $m,\, b,\, k$: overdamped, underdamped, or critically damped.

The governing ODE is

$$m\ddot{x} = -b\dot{x} - kx \quad\Rightarrow\quad m\ddot{x} + b\dot{x} + kx = 0.$$

Its **characteristic equation** is

$$m\lambda^2 + b\lambda + k = 0,$$

with roots

$$\lambda_1 = \frac{-b + \sqrt{b^2 - 4mk}}{2m}, \qquad \lambda_2 = \frac{-b - \sqrt{b^2 - 4mk}}{2m}.$$

#### Overdamped response

If $b^2 > 4mk$ the roots are real and unequal. The general solution is

$$x(t) = c_1 e^{\lambda_1 t} + c_2 e^{\lambda_2 t}.$$

The mass returns to equilibrium ($x=0$) very slowly, monotonically.

#### Underdamped response

If $b^2 < 4mk$ the roots are complex,

$$\lambda_{1,2} = \frac{-b \pm \sqrt{b^2 - 4mk}}{2m} = p \pm qi.$$

The general solution is

$$x(t) = c_1 e^{p t} \cos(qt) + c_2 e^{p t} \sin(qt),$$

an oscillatory response with decaying amplitude.

#### Critically damped response

If $b^2 = 4mk$ the roots are real and equal,

$$\lambda_{1,2} = \lambda = \frac{-b}{2m}.$$

The general solution is

$$x(t) = (c_1 + c_2 t) e^{\lambda t}.$$

The system reaches equilibrium rapidly and without oscillation — **the highly desirable response**.

### Determining $c_1$ and $c_2$ from initial conditions

The general solutions contain two parameters $c_1$ and $c_2$, determined from the initial conditions of the system.

**Worked example.** Mass-spring-damper with $m = 1$, $b = 5$, $k = 6$, released from rest at $x = -1$.

Since $b^2 = 25 > 24 = 4mk$, the roots are real and unequal:

$$\lambda_1 = \frac{-5 + \sqrt{25 - 24}}{2} = -2, \qquad \lambda_2 = \frac{-5 - \sqrt{25 - 24}}{2} = -3.$$

The general solution and its derivative are

$$x(t) = c_1 e^{-2t} + c_2 e^{-3t}, \qquad \dot{x}(t) = -2 c_1 e^{-2t} - 3 c_2 e^{-3t}.$$

Applying the initial conditions:

$$x(0) = c_1 + c_2 = -1, \qquad \dot{x}(0) = -2 c_1 - 3 c_2 = 0.$$

Solving: $c_1 = -3$, $c_2 = 2$, so

$$x(t) = -3 e^{-2t} + 2 e^{-3t}.$$

## Control of Second-Order Linear Systems

### Control of a pure mass

A mass on a frictionless surface is driven by a force $F$ towards a desired position. Designing $F$ to be **proportional to $x$ and $\dot{x}$** makes the controlled system behave like a mass-spring-damper.

Newton's law: $m\ddot{x} = F$. Choose

$$F = -k_v \dot{x} - k_p x.$$

The closed-loop equation is

$$m\ddot{x} + k_v \dot{x} + k_p x = 0,$$

which has the same form as the natural mass-spring-damper system with $b \leftrightarrow k_v$, $k \leftrightarrow k_p$.

<!-- suspected-source-error: slide 25 writes the equivalence as "$m\ddot x + k_v \dot x + k_p x = 0  \leftrightarrow  m\ddot x + b\dot x + bx = 0$" — the stiffness term on the right-hand side is `bx`, which is a typo for `kx`. The intended mapping is `k_v ↔ b` (damping) and `k_p ↔ k` (stiffness). Corrected silently in the prose above ("$b \leftrightarrow k_v, k \leftrightarrow k_p$"); raised here so a reader comparing to the PDF doesn't get confused. -->

To obtain the critically damped response (preferred), choose

1. any $k_p$ according to the **desired stiffness** of the system, then
2. $k_v$ from $k_v^2 = 4 m k_p$, i.e. $k_v = 2\sqrt{m k_p}$.

### Control of a mass-spring-damper

Now the plant already has natural parameters $m, b, k$, but their ratio is not of critical damping (e.g. $b$ too small so the response is oscillatory). A force $F$ is again applied to obtain a critically damped response.

Newton's law: $m\ddot{x} = -b\dot{x} - kx + F$. Choose $F = -k_v \dot{x} - k_p x$. Closed loop:

$$m\ddot{x} + (b + k_v)\dot{x} + (k + k_p) x = 0.$$

To obtain critically damped response:

1. Set $k_p$ such that $(k + k_p)$ matches the desired stiffness of the system.
2. Calculate $k_v$ from $(b + k_v)^2 = 4 m (k + k_p)$, i.e.

   $$k_v = 2\sqrt{m(k + k_p)} - b.$$

### PD controller and its implementation

The control law $F = -k_v \dot{x} - k_p x$ is implemented by a sensor that measures $x$ and $\dot{x}$, feeding a controller block that drives an actuator. This is the **Proportional-Derivative (PD) controller**.

```
[Sensor: measures x, ẋ] ──► [Controller: −k_v ẋ − k_p x] ──► [Actuator] ──F──► plant (m, b, k)
              ▲                                                                       │
              └───────────────────── feedback ────────────────────────────────────────┘
```

## Control Law Partitioning

### Motivation

Without partitioning, $k_v$ and $k_p$ must be changed whenever the system dynamics $(m, b, k)$ change. We can make $k_v$ and $k_p$ **independent of the system parameters** by splitting the controller into two portions:

- A **model-based compensator** that cancels off the system dynamics and reduces the system to a unit mass.
- A **servo controller** in which $k_v$ and $k_p$ are independent of $m, b, k$.

### Procedure (for a scalar second-order plant)

Given system dynamics

$$m\ddot{x} + b\dot{x} + kx = F,$$

design the **model-based compensator** as

$$F = m\underline{f} + b\dot{x} + kx,$$

where $\underline{f}$ is the (yet-to-be-designed) servo command. Substituting reduces the system to a **unit mass**:

$$\ddot{x} = f.$$

Then design the **servo portion** as

$$f = -k_v \dot{x} - k_p x,$$

where $k_p$ determines the stiffness and $k_v = 2\sqrt{k_p}$ (note: no $m$ inside the square root because the inner plant is now unit mass).

### Closed-loop equation

$$\begin{aligned}
m\ddot{x} + b\dot{x} + kx &= F \\
&= m f + b\dot{x} + kx \\
&= m\bigl(-k_v \dot{x} - k_p x\bigr) + b\dot{x} + kx.
\end{aligned}$$

The system thus reduces to

$$\ddot{x} + k_v \dot{x} + k_p x = 0,$$

which, with the choice $k_v = 2\sqrt{k_p}$, gives a critically damped response with stiffness $k_p$.

### Worked example

Given $m = 10$, $b = 20$, $k = 10$. Find gains $k_v, k_p$ so that the system becomes critically damped with stiffness of 16.

- System: $10\ddot{x} + 20\dot{x} + 10 x = F$.
- Model-based compensator: $F = 10\underline{f} + 20\dot{x} + 10 x$.
- Servo controller: $f = -k_v \dot{x} - k_p x$.
- Let $k_p = 16$.
- Then $k_v = 2\sqrt{16} = 8$.

### Implementation block diagram

```
[Sensor: measures x, ẋ]
              │
              ├──► [Model:  bẋ + kx ]──────────┐
              │                                 ▼
              └──► [Servo: −k_v ẋ − k_p x]─f─►[ ×m ]──►(+)──►[Actuator]──F──► plant (m, b, k)
              ▲                                                                     │
              └───────────────────────── feedback ──────────────────────────────────┘
```

The control-law partitioning technique will be used for **all subsequent control design in this lecture**.

### Why is this still a PD controller?

Expanding the actual force,

$$\begin{aligned}
F &= m\bigl(-k_v \dot{x} - k_p x\bigr) + b\dot{x} + kx \\
  &= (-m k_v + b)\dot{x} + (-m k_p + k)x.
\end{aligned}$$

The controller is still a PD-type controller in terms of $x$ and $\dot{x}$ — the control-law partitioning technique merely makes the **design** of those PD gains much easier.

## Trajectory Following

### Regulation to a non-zero position

So far we have only stabilised the mass at $x_d = 0$. To move it to a different position $x_d \neq 0$, think of the natural mass-spring-damper as having its wall (and hence equilibrium) offset by $x_d$: the equilibrium of the spring shifts to $x_d$, so the mass moves there.

Mathematically:

$$m\ddot{x} = -b\dot{x} - k\,\underline{(x - x_d)}.$$

To achieve regulation using control, follow the partitioned design:

- System: $m\ddot{x} + b\dot{x} + kx = F$.
- Model-based compensator: $F = m\underline{f} + b\dot{x} + kx$.
- Servo controller: $f = -k_v \dot{x} - k_p\,\underline{(x - x_d)}$.
- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Trajectory following

Same idea, but now the target keeps moving — $x_d = x_d(t)$, with $\dot{x}_d(t)$ and $\ddot{x}_d(t)$ also available from the trajectory plan.

- System: $m\ddot{x} + b\dot{x} + kx = F$.
- Model-based compensator: $F = m\underline{f} + b\dot{x} + kx$.
- Servo controller:

  $$f = \underline{\ddot{x}_d} - k_v\bigl(\underline{\dot{x} - \dot{x}_d}\bigr) - k_p\bigl(\underline{x - x_d}\bigr).$$

- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Why this works — closed-loop tracking error

Substituting the design into the plant:

$$\begin{aligned}
m\ddot{x} + b\dot{x} + kx &= F = m f + b\dot{x} + kx \\
&= m\bigl(\ddot{x}_d - k_v(\dot{x} - \dot{x}_d) - k_p(x - x_d)\bigr) + b\dot{x} + kx.
\end{aligned}$$

This simplifies to

$$(\ddot{x}_d - \ddot{x}) + k_v(\dot{x}_d - \dot{x}) + k_p(x_d - x) = 0.$$

Defining the **tracking error** $e = x_d - x$, the closed-loop equation becomes

$$\ddot{e} + k_v \dot{e} + k_p e = 0,$$

the same form as in the regulation case. Since $e$ decays to zero, $x$ tracks $x_d$ eventually.

## Modelling and Control of a Single Joint

### Joint model overview

Each joint has an **electrical** part (a DC motor) and a **mechanical** part (shaft, gear, load). The electrical part creates a torque on the mechanical part; the mechanical part also induces a back EMF on the electrical part.

Components (Craig-style picture):

- Armature circuit: resistance $R_a$, inductance $L_a$, armature current $I_a$, applied voltage $V_a$, back-EMF $V_{emf}$.
- Motor side: inertia $I_m$, motor-side friction $b_m\dot{\theta}_m$, motor torque $\tau_m$, motor angle $\theta_m$.
- Gear pair with radii $r_1$ (motor side) and $r_2$ (load side); contact force $F$ between the gears.
- Load side: inertia $I$, load-side viscous friction $b\dot{\theta}$, load torque $\tau$, load angle $\theta$.
- Gear ratio $\eta$ relates the two sides.

### Electrical equations

For a permanent-magnet DC motor, the torque produced is proportional to armature current,

$$\tau_m = k_m i_a,$$

where $k_m$ is the **torque constant** of the motor. The back EMF is proportional to rotor speed,

$$V_{emf} = k_e \dot{\theta}_m,$$

where $k_e$ is the **electrical constant** of the motor.

KVL around the armature circuit:

$$L_a \frac{di_a}{dt} + R_a i_a = V_a - V_{emf} = V_a - k_e \dot{\theta}_m.$$

**Assumption: the armature inductance $L_a$ is negligible**, giving the algebraic relation

$$R_a i_a = V_a - k_e \dot{\theta}_m.$$

### Mechanical equations and gear coupling

From free-body analysis: the motor-side gear pushes the load-side gear with a contact force $F$; the load-side gear creates an equal-and-opposite reaction on the motor-side gear.

**Motor-side dynamics:**

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - F r_1. \tag{1}$$

**Load-side dynamics:**

$$I \ddot{\theta} = F r_2 - b \dot{\theta}. \tag{2}$$

Define the load-side torque

$$\tau = F r_2. \tag{3}$$

Then (2) becomes

$$I\ddot{\theta} = \tau - b\dot{\theta} \quad\Rightarrow\quad \tau = I\ddot{\theta} + b\dot{\theta}. \tag{4}$$

From (3), $F = \tau / r_2$, so (1) becomes

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - \frac{r_1}{r_2}\tau. \tag{5}$$

Substituting (4) into (5):

$$I_m \ddot{\theta}_m = \tau_m - b_m \dot{\theta}_m - \frac{r_1}{r_2}\bigl(I \ddot{\theta} + b \dot{\theta}\bigr). \tag{6}$$

### Reduction to load-side variables

Define the **gear ratio**

$$\eta = \frac{r_2}{r_1}. \tag{7}$$

The gear ratio increases the torque seen at the load but reduces the load speed:

$$\tau = \eta \tau_m, \tag{8}$$
$$\dot{\theta} = \frac{1}{\eta}\dot{\theta}_m \quad(\text{equivalently } \ddot{\theta}_m = \eta\ddot{\theta},\ \dot{\theta}_m = \eta\dot{\theta}). \tag{9}$$

Substituting (7)–(9) into (6):

$$I_m \eta \ddot{\theta} = \frac{1}{\eta}\tau - b_m \eta \dot{\theta} - \frac{1}{\eta}\bigl(I\ddot{\theta} + b\dot{\theta}\bigr).$$

Rearranging gives the **load-side joint model**:

$$\bigl(I + I_m \eta^2\bigr)\ddot{\theta} + \bigl(b + b_m \eta^2\bigr)\dot{\theta} = \tau. \tag{10}$$

This has the same form as $m\ddot{x} + b\dot{x} + kx = F$ (with no stiffness term, since there is no spring-like restoring torque on a free joint) and will be used directly for control design.

### Control of a single joint (control-law partitioning)

Summary of the load dynamics:

$$(I + I_m \eta^2)\ddot{\theta} + (b + b_m \eta^2)\dot{\theta} = \tau.$$

Apply control-law partitioning for trajectory following with desired joint angle $\theta_d(t)$:

- Model-based compensator:

  $$\tau = (I + I_m \eta^2)\underline{f} + (b + b_m \eta^2)\dot{\theta}.$$

- Servo controller:

  $$f = \underline{\ddot{\theta}_d} - k_v\bigl(\underline{\dot{\theta} - \dot{\theta}_d}\bigr) - k_p\bigl(\underline{\theta - \theta_d}\bigr).$$

- Set the desired stiffness $k_p$, then $k_v = 2\sqrt{k_p}$.

### Translating load-side torque to motor voltage

The control law above computes the required load-side torque $\tau$. The motor must actually produce it. Using $\tau = \eta \tau_m$, the required motor-side torque is

$$\tau_m = \frac{1}{\eta}\tau.$$

Since $\tau_m = k_m i_a$, the required armature current follows; and since $R_a i_a = V_a - k_e \dot{\theta}_m$, the controller commands the corresponding **armature voltage** $V_a$.

### Lab demonstration

Single-joint control was demonstrated on a 1-DOF arm driving a load disc through a gear, with three controller tunings showing overdamped, underdamped, and critically damped responses respectively; a fourth video showed the same individual-joint scheme applied to both joints of the 2-DOF arm.

<!-- transcription-warning: slides 57–60 are still frames from demonstration videos showing the physical setup (a 2-link arm driven by a National Instruments-branded controller, with a metal load disc). The information content is the qualitative response category (overdamped / underdamped / critically damped / two-joint operation), which is preserved above; the visual setup itself carries no further technical detail. -->

## Modelling and Control of the Complete Manipulator

### Why individual-joint control is insufficient

The individual-joint analysis assumed that (i) each joint is independent of the others and (ii) the inertia seen by each joint actuator is constant. Neither holds for a real manipulator: the joints/links are highly coupled and the inertia (and other) matrices are **not** constant. For example, a 2-link planar arm presents large inertia about joint 1 when the second link is extended outward and small inertia when the second link is folded back.

Applying a fixed linear controller therefore yields undesirable results — e.g. the damping is **not uniform throughout the workspace**.

### Multi-input-multi-output partitioned control

Treat the robot as a MIMO system. With the manipulator dynamic model (from the dynamics lecture)

$$M(q)\ddot{q} + V(q,\dot{q}) + G(q) = \tau,$$

design the **model-based compensator** as

$$\tau = M(q)\,\underline{f} + V(q,\dot{q}) + G(q),$$

which decouples all the individual joint dynamics to

$$\ddot{q} = f, \qquad \text{or}\qquad \begin{bmatrix}\ddot{q}_1 \\ \ddot{q}_2 \\ \vdots\end{bmatrix} = \begin{bmatrix} f_1 \\ f_2 \\ \vdots\end{bmatrix}.$$

The **servo controller** $f$ is then designed component-wise as

$$f = \ddot{q}_d - K_v(\dot{q} - \dot{q}_d) - K_p(q - q_d),$$

where $K_v$ and $K_p$ are (typically diagonal) matrices. Explicitly:

$$\begin{bmatrix} f_1 \\ f_2 \\ f_3 \\ \vdots \end{bmatrix}
=
\begin{bmatrix} \ddot{q}_{d1} \\ \ddot{q}_{d2} \\ \ddot{q}_{d3} \\ \vdots \end{bmatrix}
-
\begin{bmatrix}
k_{v1} & 0 & 0 & \cdots \\
0 & k_{v2} & 0 & \cdots \\
0 & 0 & k_{v3} & \cdots \\
\vdots & \vdots & \vdots & \ddots
\end{bmatrix}
\begin{bmatrix} \dot{q}_1 - \dot{q}_{d1} \\ \dot{q}_2 - \dot{q}_{d2} \\ \dot{q}_3 - \dot{q}_{d3} \\ \vdots \end{bmatrix}
-
\begin{bmatrix}
k_{p1} & 0 & 0 & \cdots \\
0 & k_{p2} & 0 & \cdots \\
0 & 0 & k_{p3} & \cdots \\
\vdots & \vdots & \vdots & \ddots
\end{bmatrix}
\begin{bmatrix} q_1 - q_{d1} \\ q_2 - q_{d2} \\ q_3 - q_{d3} \\ \vdots \end{bmatrix}.$$

The model-based compensator cancels off the robot's dynamics and decouples each joint; the servo controllers are then designed for each joint individually using the scalar critical-damping rules above.

## MATLAB Simulation

We now combine the previously-written code that (a) simulated robot motion under pre-set torques and (b) generated trajectories, but here the pre-set torques are replaced by **torques computed by the controller**. The complete-manipulator approach is used (the full robot model is available). The trajectory is planned in Cartesian space, so inverse kinematics is required at each step; equivalently one could plan directly in joint space.

### Robot and control parameters

```matlab
%%%%%%%%%%%%%%%%%%%%%%
% Robot Parameters %
%%%%%%%%%%%%%%%%%%%%%%

m1 = 3;   % kg
m2 = 2;   % m
L1 = 3;   % kg
L2 = 2;   % m
g  = 9.8; % m/s^2

%%%%%%%%%%%%%%%%%%%%%%%%
% Control Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%

Kp = diag([100 100]);                       % diagonal matrix Kp
Kv = diag([2*sqrt(100) 2*sqrt(100)]);       % diagonal matrix Kv
                                            % Critical damping. You may try other values
                                            % to see different responses.
```

<!-- suspected-source-error: slide 71 labels m2 with the unit "m" and L1 with the unit "kg"; these are clearly transposed (m2 should be kg, L1 should be m). Transcribed verbatim from the source. -->

### Boundary conditions and time array

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary Conditions       %
% Must be within Workspace  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = 2; % x initial
y0 = 3; % y initial
xf = 4; % x target
yf = 1; % y target
tf = 3;

%%%%%%%%%%%%%%%%%%%%%%%%
% Create Time Array   %
%%%%%%%%%%%%%%%%%%%%%%%%

T = 1e-3;     % time interval for integration
t = 0:T:tf;   % array of time from 0 to tf in steps of 0.001
t = t';       % make the time array into column vector
```

### Quintic trajectory for x

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial for x %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a0 = x0;
a1 = 0;
a2 = 0;
a3 = 10/tf^3*(xf-x0);
a4 = -15/tf^4*(xf-x0);
a5 = 6/tf^5*(xf-x0);

xQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
xDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
xDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('x Quintic')
subplot(1,3,1), plot(t,xQuintic), title('Position')
subplot(1,3,2), plot(t,xDotQuintic), title('Velocity')
subplot(1,3,3), plot(t,xDoubleDotQuintic), title('Acceleration')
```

### Quintic trajectory for y

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quintic Polynomial for y %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a0 = y0;
a1 = 0;
a2 = 0;
a3 = 10/tf^3*(yf-y0);
a4 = -15/tf^4*(yf-y0);
a5 = 6/tf^5*(yf-y0);

yQuintic         = a0*ones(length(t),1) + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;
yDotQuintic      = a1*ones(length(t),1) + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
yDoubleDotQuintic = 2*a2*ones(length(t),1) + 6*a3*t + 12*a4*t.^2 + 20*a5*t.^3;

figure, sgtitle('y Quintic')
subplot(1,3,1), plot(t,yQuintic), title('Position')
subplot(1,3,2), plot(t,yDotQuintic), title('Velocity')
subplot(1,3,3), plot(t,yDoubleDotQuintic), title('Acceleration')
```

### Inverse kinematics at each step

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Kinematics at Each Step %
% See notes of Geometrical Method  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(t)
    theta2Quintic(i) = acos((xQuintic(i)^2 + yQuintic(i)^2 - L1^2 - L2^2)/(2*L1*L2));
    beta  = atan2(yQuintic(i), xQuintic(i));
    psi   = acos((L1^2 + xQuintic(i)^2 + yQuintic(i)^2 - L2^2) / ...
                 (2*L1*sqrt(xQuintic(i)^2 + yQuintic(i)^2)));
    theta1Quintic(i) = beta - psi;
end

figure, sgtitle('Theta Quintic')
subplot(1,2,1), plot(t,theta1Quintic), title('Theta 1')
subplot(1,2,2), plot(t,theta2Quintic), title('Theta 2')
```

### Robot initial conditions and recording arrays

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robot Initial Conditions %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1    = theta1Quintic(1);   % joint 1 angle
q1Dot = 0;                  % joint 1 angular velocity
q2    = theta2Quintic(1);   % joint 2 angle
q2Dot = 0;                  % joint 2 angular velocity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable Declaration and Memory Placeholder %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q1DoubleDotRecord = [];
q2DoubleDotRecord = [];
q1DotRecord       = [];
q2DotRecord       = [];
q1Record          = [];
q2Record          = [];
q1dot = 0;
q2dot = 0;
```

### Main simulation loop — robot dynamics, control, integration

```matlab
for i = 1:length(t)

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate M, V, G %
    %%%%%%%%%%%%%%%%%%%%%%

    m11 = m2*L2^2 + 2*m2*L1*L2*cos(q2) + (m1+m2)*L1^2;
    m12 = m2*L2^2 + m2*L1*L2*cos(q2);
    m21 = m12;
    m22 = m2*L2^2;
    M   = [m11, m12; m21, m22];

    v1 = -m2*L1*L2*sin(q2)*q2Dot^2 - 2*m2*L1*L2*sin(q2)*q1Dot*q2Dot;
    v2 =  m2*L1*L2*sin(q2)*q1Dot^2;
    V  = [v1; v2];

    g1 = m2*g*L2*cos(q1+q2) + (m1+m2)*g*L1*cos(q1);
    g2 = m2*g*L2*cos(q1+q2);
    G  = [g1; g2];

    %%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Control  %
    %%%%%%%%%%%%%%%%%%%%%%%

    servoControl = -Kv*[q1dot; q2dot] - Kp*[q1 - theta1Quintic(i); q2 - theta2Quintic(i)];
    % Note velocity and acceleration trajectory are set as zero
    % Because we are doing regulation, not trajectory tracking

    modelControl = M*servoControl + V + G;

    Tau1(i) = modelControl(1);
    Tau2(i) = modelControl(2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Acceleration  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    qDoubleDot = inv(M) * ([Tau1(i); Tau2(i)] - V - G);
    q1DoubleDot = qDoubleDot(1);
    q2DoubleDot = qDoubleDot(2);

    q1DoubleDotRecord = [q1DoubleDotRecord; q1DoubleDot];
    q2DoubleDotRecord = [q2DoubleDotRecord; q2DoubleDot];

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate Velocity %
    %%%%%%%%%%%%%%%%%%%%%%

    q1Dot = q1Dot + q1DoubleDot*T;
    q2Dot = q2Dot + q2DoubleDot*T;

    q1DotRecord = [q1DotRecord; q1Dot];
    q2DotRecord = [q2DotRecord; q2Dot];

    %%%%%%%%%%%%%%%%%%%%%%
    % Calculate Position %
    %%%%%%%%%%%%%%%%%%%%%%

    q1 = q1 + q1Dot*T + 1/2*q1DoubleDot*T^2;
    q2 = q2 + q2Dot*T + 1/2*q2DoubleDot*T^2;

    q1Record = [q1Record; q1];
    q2Record = [q2Record; q2];
end
```

The servo command uses only the position error (the desired velocity and acceleration terms have been omitted), so this is **regulation along a sequence of set points**, not true trajectory tracking — as noted in the inline comment. Note also the case-sensitivity bug flagged below: the velocity-feedback term is silently dead too, so the displayed simulation is effectively **proportional-only**.

<!-- suspected-source-error: slide 78 has two distinct problems with the controller.
  (a) Missing feedforward — `servoControl` uses only position error, dropping the `q̈_d − K_v(q̇_d − q̇)` terms from the partitioned-control law derived earlier (f = q̈_d + K_v(q̇_d − q̇) + K_p(q_d − q)). The slide's own inline comment acknowledges this and frames it as regulation.
  (b) Case-sensitivity bug NOT acknowledged on the slide. The variables `q1dot, q2dot` (lowercase, used in `servoControl` line 626) are initialised to 0 on lines 595–596 and **never updated anywhere**. The velocity that *is* integrated each loop iteration is `q1Dot, q2Dot` (capital D, lines 581/583, 650/651). MATLAB identifiers are case-sensitive, so the velocity-feedback term in the controller is **permanently zero** for the entire simulation. Combined with (a), the simulation runs a pure proportional controller, not the PD partitioned controller the lecture is illustrating.
  Code transcribed verbatim from the slide so a reader cross-checking against the PDF sees the same listing. Do not propagate this MATLAB snippet to your own implementations without correcting both issues. -->

### Visualisation

```matlab
%%%%%%%%%%%%%%%%%%%%%%%%
% Show Robot Motion   %
%%%%%%%%%%%%%%%%%%%%%%%%

x1 = L1*cos(q1Record);                          % These are kinematic
y1 = L1*sin(q1Record);                          % equation of the
x2 = x1 + L2*cos(q1Record + q2Record);          % 2 link robot
y2 = y1 + L2*sin(q1Record + q2Record);

figure
for i = 1:100:length(x1)        % Plot every 100th data
    clf;                        % Clear figure before new plot
    plot([0 x1(i)], [0 y1(i)]);
    axis([-(L1+L2+0.2) (L1+L2+0.2) -(L1+L2+0.2) (L1+L2+0.2)]);
    hold on, plot([x1(i) x2(i)], [y1(i) y2(i)]);
    hold on, plot(x0, y0, 'xr');
    hold on, plot(xf, yf, 'xr');
    pause(0.1);
end
```

The animation shows the 2-link planar arm reaching from the initial point $(x_0, y_0)$ to the target $(x_f, y_f)$ inside a workspace bounded approximately by $\pm(L_1 + L_2)$.

## Tutorial Questions

**Question 1.** Determine the motion of a mass-spring-damper system if $m = 2$, $b = 6$, $k = 4$, and the mass (initially at rest) is released from position $x = 1$.

**Question 2.** Determine the motion of a mass-spring-damper system if $m = 1$, $b = 2$, $k = 1$, and the mass (initially at rest) is released from position $x = 4$.

**Question 3.** Determine the motion of a mass-spring-damper system if $m = 1$, $b = 4$, $k = 5$, and the mass (initially at rest) is released from position $x = 2$.

**Question 4.** Give the nonlinear control equations for the system

$$\bigl(2\sqrt{\theta} + 1\bigr)\ddot{\theta} + 3\dot{\theta}^2 - \sin(\theta) = \tau.$$

Choose gains so that this system is always critically damped with closed-loop stiffness of 10.

**Question 5.** Design a trajectory-following control system for a system with the following dynamic equations:

$$\begin{aligned}
m_1 l_1^2 \ddot{\theta}_1 + m_1 l_1 l_2 \dot{\theta}_1 \dot{\theta}_2 &= \tau_1, \\
m_2 l_2^2\bigl(\ddot{\theta}_1 + \ddot{\theta}_2\bigr) + v_2 \dot{\theta}_2 &= \tau_2.
\end{aligned}$$

Additional question: what is wrong with this robot model?

<!-- transcription-audit:
- Dropped: title slide (p.1), schedule table (p.2), table-of-contents recap slides (p.3, 4, 8, 22, 30, 37, 44, 61, 68, 83), and closing "Thank you" slide (p.89) — boilerplate / navigation.
- Dropped: decorative red-blob arm illustrations on the introduction slides (p.5) — purely illustrative of trajectory-following intent.
- Dropped: per-slide page numbers and the "(1)/(2)/(3)..." subtitle suffixes throughout; consecutive build-up slides were merged into single logical sections (e.g. the 10-slide "Modeling of a Single Joint" sequence became one derivation; the 14-slide MATLAB walkthrough became one annotated script).
- Warnings: pages 57–60 are still photos extracted from demo videos (single-joint arm with NI controller). The qualitative response label (over/under/critically damped, both joints) is preserved; the underlying dynamic behaviour is not recoverable from still frames and would require the original videos to fully transcribe.
- Suspected source errors:
  1. Slide 25 (Control of a Mass): the equivalence "$m\ddot x + k_v \dot x + k_p x = 0 \leftrightarrow m\ddot x + b\dot x + \mathbf{b}x = 0$" mistypes the stiffness term as `bx` rather than `kx`. **Silently corrected** in the closed-loop equation immediately above the mapping `$b \leftrightarrow k_v, k \leftrightarrow k_p$`; inline `<!-- suspected-source-error -->` flag added.
  2. Slide 71: MATLAB Robot Parameters block labels `m2` with unit "m" and `L1` with unit "kg" — units transposed.
  3. Slide 78: TWO problems with the simulation controller —
     (a) Missing feedforward (zero velocity/acceleration target terms in `servoControl`). The slide's own inline comment frames this as "regulation, not trajectory tracking".
     (b) **Case-sensitivity bug not acknowledged on the slide.** Lowercase `q1dot, q2dot` (used in `servoControl`) are initialised to 0 and never updated; the actually-integrated velocity is `q1Dot, q2Dot` (capital D). Since MATLAB identifiers are case-sensitive, the velocity-feedback term in the controller is permanently zero — the simulation runs proportional-only, not the PD partitioned controller the lecture is teaching. The MATLAB listing is transcribed verbatim; the inline flag warns readers not to propagate the code as-is.
- Ambiguities:
  - The deck mixes scalar notation $x$ (mass-spring-damper) and $\theta$ (joint angle) for the same generic second-order plant; the transcript keeps both, following the slide that introduces each formula.
  - The "stiffness of 16 / stiffness of 10" in the worked examples and Q4 is interpreted as the closed-loop $k_p$ in $\ddot{e} + k_v\dot{e} + k_p e = 0$ (so $\omega_n = \sqrt{k_p}$), per the slide deck's usage.
- Ingestion: native multimodal — diagrams, circuit pictures, equations, and code blocks all directly perceivable.
-->
