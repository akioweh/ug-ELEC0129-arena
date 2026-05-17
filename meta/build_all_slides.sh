#!/usr/bin/env bash
# Deterministically builds materials/ALL_SLIDES.md by concatenating
# all eight lecture transcripts (with `> Source:` first lines stripped).
# Spatial Description spans Weeks 2 + 3 — two transcripts; the rest is
# one transcript per topic. Lectures are emitted in the canonical
# dependency order (intro → spatial → FK → IK → Jacobians → trajectory
# → dynamics → control).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRANSCRIBED="$SCRIPT_DIR/slides_transcribed"
OUTPUT="$SCRIPT_DIR/../materials/ALL_SLIDES.md"

# Lecture decks in canonical order.
DECKS=(
    "ELEC0129_02_intro"
    "ELEC0129_02_spatial"
    "ELEC0129_03_spatial"
    "ELEC0129_04_forward_kinematics"
    "ELEC0129_05_inverse_kinematics"
    "ELEC0129_07_jacobians"
    "ELEC0129_08_trajectory_planning"
    "ELEC0129_09_dynamics"
    "ELEC0129_10_control"
)

: > "$OUTPUT"

LAST_INDEX=$(( ${#DECKS[@]} - 1 ))
for i in "${!DECKS[@]}"; do
    name="${DECKS[$i]}"
    src="$TRANSCRIBED/${name}.md"
    if [[ ! -f "$src" ]]; then
        echo "ERROR: missing $src" >&2
        exit 1
    fi

    # Drop the leading "> Source: ..." line and the blank line after it.
    # The source line is always line 1; line 2 is always blank.
    tail -n +3 "$src"

    # Blank line between lectures (except after the last).
    if [[ "$i" -ne "$LAST_INDEX" ]]; then
        echo ""
    fi
done >> "$OUTPUT"

echo "Built $OUTPUT ($(wc -l < "$OUTPUT") lines, $(wc -c < "$OUTPUT") bytes)"
