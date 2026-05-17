# Issues found in the ELEC0129 lecture material

This document used to be a registry of every problem found in the source slides. Most of those have now been **addressed in-place** — either silently corrected in the transcripts under `meta/slides_transcribed/` or annotated with an inline `<!-- suspected-source-error -->` / `<!-- pedagogical-omission -->` / `<!-- caveat-on-source-figure -->` flag. The transcripts' `<!-- transcription-audit -->` blocks at the end of each file enumerate the per-deck corrections.

This file now keeps only the residual items that are **not** annotated inline, plus a short index of where the in-place fixes live for cross-reference.

---

## Residual items (not annotated in any transcript)

None. Every substantive source-level issue surfaced by the verifier pass is either:

- silently corrected in the transcript, with the correction noted in the deck's audit block, **or**
- left in place verbatim (because faithfulness to source matters) with an inline `<!-- suspected-source-error -->` / `<!-- pedagogical-omission -->` flag adjacent to the affected passage, **or**
- a stylistic / grammatical slip below the noise threshold (typos like "Jabobian" → "Jacobian", "2-ink" → "2-link", "artan2" → "atan2", "slowy" → "slowly", "rotating along" → "rotating about", inconsistent `P_{BORG}` / `P_{Borg}` casing) that has been silently fixed without ceremony.

If you find a new issue while revising, prefer to log it as an inline flag in the affected transcript rather than re-growing this file.

---

## Index of in-place corrections

The four findings the verifier called Major are summarised here so they don't get lost in the transcript audit blocks. Each row links the source slide, the affected transcript, and the form the fix takes.

| Slide | Issue | Transcript | Resolution |
| --- | --- | --- | --- |
| W4 slide 68 | Chained transform `⁰₄T(1,1)` reads `s₁·s₃·s₄ + c₁·s₄` — should be `c₁·s₄ + s₁·s₃·c₄` (`c₄`, not `s₄`, in the second term). Slide-71 sanity check (θ₄=0) masks the typo. | `ELEC0129_04_forward_kinematics.md`, Example 3 ⁰₄T section | **Silently fixed**; inline `<!-- suspected-source-error -->` flag explains the correction and the recomputation. Audit block updated. The transcriber's earlier (now-overturned) flag about α₁=−90° has also been removed; the Example 3 geometry prose was rewritten to match the actual schematic (axis 2 is horizontal, not vertical). |
| W7 slide 46 | Spherical-wrist singularity wording inverted: slide says "loses ability to rotate about the axis"; correct is *perpendicular* to the collinear axis. | `ELEC0129_07_jacobians.md`, Singularities → Example (spherical wrist) | Prose **rewritten to the correct physics**; inline `<!-- suspected-source-error -->` flag quotes the slide's incorrect wording verbatim for cross-reference. |
| W10 slide 25 | Closed-loop equivalence written as `mẍ + bẋ + bx = 0`; stiffness term should be `kx`. | `ELEC0129_10_control.md`, Control of a pure mass | **Silently fixed** to `mẍ + k_v ẋ + k_p x = 0` and the mapping `b ↔ k_v, k ↔ k_p`; inline `<!-- suspected-source-error -->` flag preserved next to the corrected closed-loop line. |
| W10 slide 78 | MATLAB simulation has two bugs: (a) missing `q̈_d, q̇_d` feedforward (acknowledged on the slide as "regulation"), and (b) **case-sensitivity bug not acknowledged on the slide** — lowercase `q1dot`/`q2dot` (used in `servoControl`) are initialised to 0 and never updated; the actually-integrated velocity is `q1Dot`/`q2Dot`, so the velocity-feedback term is permanently zero and the simulation is effectively pure-P, not PD. | `ELEC0129_10_control.md`, Main simulation loop | MATLAB **kept verbatim** (source-faithful). The pre-existing transcriber flag was expanded into a two-part `<!-- suspected-source-error -->` block covering both (a) and (b), and a sentence was added above the MATLAB listing telling the reader the demo is misleading as a PD-vs-P illustration. |

Additional minor issues that are now flagged inline in their respective transcripts (no central documentation needed):

- W2 intro — slide 9 ISO 8373 quote uses "programmable" twice instead of "reprogrammable" / "programmable"; slide 19 6-DOF figure labels seven z-axes for six joints; right-hand-rule prose corrected to mention the slide's actual three-finger depiction.
- W3 spatial — slides 17/20 give only the `+√` branch of the β recovery; gimbal-lock note silently augmented to mention recoverable α±γ; slide 27 angle-axis-recovery section now includes the diagonal-based fallback for θ=π that the slide omits; Q2 prose direction corrected from "upper-right" to "lower-right".
- W5 inverse kinematics — slide 56 boxed θ₃ typo silently fixed; slide 62 s₅=0 disjunction (`θ₄+θ₆` *or* `θ₄−θ₆`) annotated as a misleading hedge; both inside the non-examinable PUMA section.
- W7 Jacobians — slide 34 angular-velocity row label `(ω_e)_y` silently corrected to `_z`; slide 56 Case-2 worked example "1N" silently corrected to "1000 N"; static-force duality annotated as Jacobian-linear-block-only (general form is full 6×n with a wrench); singularity definition annotated as needing rank-deficiency interpretation for non-square J.
- W8 trajectory planning — LSPB piecewise on slides 49/55 lacks an upper bound on the third branch; flagged inline near the piecewise definition.
- W9 dynamics — slide 12 agenda's "Non-Rigid Body Effects" title is stale relative to the actual "Friction Force" section on slide 42; noted in audit block since ToC slides were dropped anyway.

## Pre-existing transcriber flags that the verifier pass overturned

These are no longer in the transcripts (the misleading flags were removed and the transcripts updated to reflect the verifier's finding):

- W3 spatial: "left-to-right" vs "right-to-left" phrasing was originally flagged as a source inconsistency. Verified to be **two equally correct phrasings** of the intrinsic / extrinsic rotation-product convention. Resolution note left in the W3 audit block.
- W4 forward kinematics: the transcriber suspected Example 3 had α₁ = 0 (instead of the slide's −90°) based on a misreading of the schematic. Verifier reconstructed the geometry and confirmed the slide's α₁ = −90° is **correct** — axis 2 is horizontal, not vertical. The flag has been removed from the transcript and the geometry-description prose rewritten to match the actual axis layout.

## Bottom line for exam revision

Read each lecture's transcript audit block (the `<!-- transcription-audit -->` HTML comment at the end of the file) for a complete list of corrections and pedagogical augmentations applied per deck. The four major source defects above are worth memorising verbatim before the exam — everything else is either non-examinable, locally self-correcting, or below the noise threshold.
