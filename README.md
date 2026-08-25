# teaching-taste

Slides for **Teaching Taste to an Agent** — a talk presented at the HK Web Dev (HKWD) meetup, August 2026.

A single self-contained HTML deck showing how style is taught to an AI image pipeline: 4,096 ink paintings generated from the Jiaoshi Yilin (焦氏易林), distilled through iterative human judgment into a reusable skill.

## Files

- `teaching-taste.html` — the deck. Open directly in a browser (arrow keys / scroll / swipe to navigate; press `E` to edit slides in place).
- `img/` — all talk images, bundled locally so the deck works offline.
- Root-level assets: speaker portrait, QR codes, verse screenshot, taste cartoon (`taste-elitism.webp`).
- `docs/` — background research notes (e.g. `jiao-yanshou-shao-yong.md`, the intellectual lineage behind the corpus).

## Key controls

- Next/prev: arrow keys, space, PageUp/Down, scroll, or swipe
- `E`: toggle inline edit mode (edits persist in localStorage; `Ctrl+S` exports an updated copy)
- `+` / `-`: scale all text up or down in 10% steps; `0` resets to 100%. The choice persists in
  localStorage, so set it once on the venue projector and it stays. 100% is tuned to fill a 1080p
  frame without clipping — a few dense slides (the "What Is Taste?" and "Style Is Not a Suffix"
  slides first) start to clip above 110%, since slides are fixed-height with `overflow: hidden`.

Layout and copy editing happen live in the HTML; the slide progress bar and dot nav are auto-generated.