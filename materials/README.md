# Materials

Curated bundle of materials covering the full ELEC0129 module.

Currently contains:

- `ALL_SLIDES.md` — complete transcript of the lecture slides for the eight examinable lectures (W2 intro, W2 spatial, W3 spatial, W4 forward kinematics, W5 inverse kinematics, W7 Jacobians, W8 trajectory planning, W9 manipulator dynamics, W10 manipulator control). Built deterministically by `../meta/build_all_slides.sh` from the per-lecture transcripts in `../meta/slides_transcribed/`.
- `Formula_Sheet.pdf` — the formula sheet that will be provided during the (in-person, closed-book) exam. Carries the rotation-matrix forms, Craig modified-DH transform, velocity-propagation equations, Newton-Euler iteration, polynomial-trajectory coefficient tables, and Cartesian/joint-space dynamics.
- `LORE.md` — information from outside the verbatim slides (exam format, scope notes, known source-slide errors). Treat as required reading alongside the lectures.

## Additional materials (read on demand)

These are not part of the default reading bundle. Consult them when directly relevant — e.g. when working through past-paper practice questions.

- `past_papers/` — past exam papers + model solutions, transcribed to markdown. **`ELEC0129_2324.md` is the canonical reference** — it matches the upcoming in-person, closed-book exam format. The earlier years (`ELEC0129_2122.md`, `ELEC0129_2223.md`) were online open-book and read very differently in question shape (long uninterrupted derivations rather than the 23/24 mix of short recall + two big set-pieces). `ELEC0140_2021.md` is from the sister module ELEC0140 — Q5 (image moments / blob analysis) is explicitly out of scope for ELEC0129; the remaining questions parallel ELEC0129 topics and are good practice.

## Not yet bundled

- **Exercise sheets** — tutorial Q+A PDFs live in `../meta/exercise_sheets/` (one Q+A pair per week for W3, W4, W5, W7, W9, W10, plus a W4 supplementary derivation). Not yet transcribed to markdown.

## Rebuilding `ALL_SLIDES.md`

If a transcript in `../meta/slides_transcribed/` is updated, regenerate the bundle:

```bash
./meta/build_all_slides.sh
```

The script concatenates the eight transcripts in canonical dependency order, stripping each one's leading `> Source: …` line.
