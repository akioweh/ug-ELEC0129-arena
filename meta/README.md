# Meta

Plumbing for **meta tasks** — workflows that maintain or extend the project itself rather than draw on the module content. Distinct from the project's actual purpose of equipping the agent with module knowledge.

## Scope

Only **lecture content** (theory for the 40% closed-book in-person exam) is in scope. Robot-building workshops, RoboDK / offline-programming coursework, MATLAB implementation tasks, demo schedules, and team-list artefacts have been removed.

## Layout

Each material type has a pair of folders: **originals → extracted/transcribed content** (token-inefficient PDFs → dense markdown).

- `slides_original/` — lecture-note PDFs from Moodle, one per lecture, renamed `ELEC0129_WW_topic.pdf` where `WW` is the week number.
- `slides_transcribed/` — faithful, lossless markdown transcripts of the lectures. **Prefer these over the originals.**
- `exercise_sheets/` — tutorial question sheets and model answers per week (`WeekN_questions.pdf` / `WeekN_solutions.pdf`); plus the supplementary derivation exercise `Week4_example2_derivation.pdf`.
- `exercise_sheets_transcribed/` — markdown transcripts of the exercise sheets (TBD).
- `past_papers/` — original past exam papers + model solutions: `ELEC0129_YYYY_paper.pdf` / `ELEC0129_YYYY_solutions.pdf` for 21/22, 22/23, 23/24, plus the 20/21 paper (taken from a sister module `ELEC0140`, with Q5 explicitly out of scope per Moodle).
- `past_papers_transcribed/` — markdown transcripts of the past papers (TBD).
- `formula_sheet/Formula_Sheet.pdf` — the official formula sheet provided in the exam.
- `_moodle_source/` — raw Moodle course-page HTML + assets as scraped; preserved for reference, not actively consumed.

## Transcription workflow

Slide decks are transcribed by a generic **transcriber** subagent (`.claude/agents/transcriber.md` for Claude Code, `.opencode/agents/transcriber.md` for opencode); a `/transcribe` slash command is available for human use. A **transcription skill** (`.claude/skills/transcription/SKILL.md` / `.opencode/skills/transcription/SKILL.md`) provides a decision framework for when and how to pre-process token-heavy documents.

## Source-file mapping

The originals on Moodle were labelled as numbered "Tasks". The mapping to current filenames:

| Original Moodle file | New name |
| --- | --- |
| Task 2.3 Reading Lecture Notes — Introduction to the Course | `slides_original/ELEC0129_02_intro.pdf` |
| Task 2.7 Read Lecture Notes — Spatial Description and Transformation | `slides_original/ELEC0129_02_spatial.pdf` |
| Task 3.8 Read Lecture Notes — Spacial Description and Transformation | `slides_original/ELEC0129_03_spatial.pdf` |
| Task 4.13 Read Lecture Notes — Forward Kinematics | `slides_original/ELEC0129_04_forward_kinematics.pdf` |
| Task 5.10 Read Lecture Notes — Inverse Kinematics | `slides_original/ELEC0129_05_inverse_kinematics.pdf` |
| Task 7.12 Read Lecture Notes — Jacobians | `slides_original/ELEC0129_07_jacobians.pdf` |
| Task 8.8 Read lecture notes — Trajectory Planning | `slides_original/ELEC0129_08_trajectory_planning.pdf` |
| Task 9.14 Read lecture notes — Manipulator Dynamics | `slides_original/ELEC0129_09_dynamics.pdf` |
| Task 10.10 Read lecture notes — Control of Manipulator | `slides_original/ELEC0129_10_control.pdf` |
| Tasks N.x Tutorial Questions / Check Your Solutions | `exercise_sheets/WeekN_questions.pdf` / `WeekN_solutions.pdf` |
| Task 4.8 Try Deriving the Position of End-Effector in Example 2 | `exercise_sheets/Week4_example2_derivation.pdf` |
| 20/21 — 23/24 Exams (zip) | `past_papers/ELEC0129_YYYY_paper.pdf` + `_solutions.pdf` (20/21 prefixed `ELEC0140`) |
| Formula Sheet | `formula_sheet/Formula_Sheet.pdf` |
