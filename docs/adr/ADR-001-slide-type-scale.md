# ADR-001: Slides Use One Type Scale, and Stats Never Outrank Headings

**Status:** Accepted
**Date:** 2026-08-24
**Tags:** typography, slides, design-system
**Applies to:** `teaching-taste.html`

---

## Context

The deck defines six type tokens in `:root`:

| Token | Value | At 1920×1080 |
|---|---|---|
| `--title-size` | `clamp(2.2rem, 6vw, 5rem)` | 80px |
| `--h2-size` | `clamp(1.8rem, 4.5vw, 3.5rem)` | 56px |
| `--h3-size` | `clamp(1.3rem, 3vw, 2.5rem)` | 40px |
| `--body-size` | `clamp(1rem, 2.2vw, 1.75rem)` | 28px |
| `--small-size` | `clamp(0.85rem, 1.6vw, 1.35rem)` | 22px |
| `--code-size` | `clamp(0.85rem, 1.5vw, 1.2rem)` | 19px |

A measurement of every text-bearing element at 1920×1080 found the deck was
rendering **18 distinct pixel sizes in 47 size+family+weight combinations** —
three times the token set. Slide 07 alone carried 11 distinct styles across 7
sizes; slide 08 carried 9 across 6.

Two causes:

1. **~28 inline `font-size: clamp(...)` declarations** bypassing the tokens,
   each hand-tuned and none matching another. Six variants sat between 1.15rem
   and 1.5rem at the low end alone.

2. **`.stat-number` was `clamp(2rem, 5vw, 4rem)` — 64px — while `--h2-size` is
   56px.** Every statistic on the deck rendered *larger than the heading above
   it*. On slides 07 and 08 the eye landed on the number first and had to search
   for the title. This is what made those slides read as noise rather than as a
   claim with evidence.

## Research

Presentation-typography guidance converges on a small set of steps and a firm
floor:

- **At most three font sizes on any one slide**, and two to three typefaces
  across the deck — [Beautiful.ai](https://www.beautiful.ai/blog/what-font-size-is-best-for-presentations),
  [AiPPT](https://learn.aippt.com/best-practices-for-powerpoint-typography-and-text-readability/)
- **Titles 32–44pt, subtitles ~28pt, body 18–24pt**, never below 18pt for
  anything the audience must read — [Presentations.ai](https://www.presentations.ai/blog/what-font-size-is-best-for-presentations),
  [Superchart](https://www.superchart.io/blog/presentation-font-size)
- Anything that has to be smaller than the floor "belongs in a handout, not on
  the slide" — [BrightCarbon](https://www.brightcarbon.com/blog/presentation-font-size/)
- A **modular scale** derives every step from one base and one ratio, and you
  select only the steps you need rather than inventing sizes per use —
  [Imperavi](https://imperavi.com/books/ui-typography/principles/modular-scale/),
  [Typography Master](https://www.typographymaster.com/guide/type-scale-systems)

The deck already had a modular scale. It simply was not being used.

## Decision

### 1. The six tokens are the whole scale

No slide may introduce a new `font-size` value. Inline sizing is permitted only
as an `em` multiple of an inherited token — superscripts, the `BCE` in `~40 BCE`
— because those stay locked to their parent step.

### 2. Stats sit at `--h3-size`, never above it

`.stat-number` is now `var(--h3-size)`. A statistic is evidence for a heading,
not a replacement for one, so it ranks below `--h2-size`. Its prominence comes
from weight (700), the display face, and clay — not from out-sizing the title.

This matched what the "Four Rounds" slide had already done by hand: four inline
`clamp(1.5rem, 3vw, 2.5rem)` overrides, which is `--h3-size` spelled out. Those
overrides are removed; the token now does it everywhere.

### 3. Four steps per slide, descending

A slide should read top-down in descending size. The target is heading →
lead/stat → body → label, i.e. 56 → 40 → 28 → 22. Three is better than four;
five means the slide is doing too much.

### 4. Four typefaces, each with one job

`Cormorant Garamond` (display/headings), `Source Sans 3` (body), `Noto Serif TC`
(Chinese), `JetBrains Mono` (code, keys, axis labels). This exceeds the
two-to-three-typeface guidance, and that is accepted: the Chinese and monospace
faces are semantic, not decorative. Substituting either would be worse than the
extra family costs.

### 5. Nothing below `--code-size`

19px at 1920×1080 is the floor for anything the audience is expected to read.

## Consequences

Measured after the change: **44 combinations, maximum 6 sizes on one slide**,
and no slide renders a stat larger than its heading.

The deck is not yet fully compliant. Nine slides still exceed four sizes:

| Slide | Sizes | Cause |
|---|---|---|
| 03 I-Ching | 22, 23, 24, 40, 51, 56 | hexagram captions and CJK glyph labels |
| 05 A reading is a move | 22, 28, 35, 40, 51, 56 | CJK hexagram names at three optical sizes |
| 06 Every pair | 22, 24, 28, 30, 40, 56 | matrix axis ticks (24) and corner labels (30) |
| 09 The Iterative Loop | 22, 28, 40, 48, 56 | loop-node titles at a bespoke 48 |
| 23 Running It | 19, 22, 28, 35, 40, 56 | `entropy < 2.0` shrunk to fit its column |
| 25 What Is a Skill? | 15, 22, 28, 40, 56 | code block below the floor |
| 27 Thank You | 22, 28, 29, 40, 64 | title-slide `h1` override |

Two notes on those. **CJK glyphs legitimately need a larger optical size than
Latin at the same rank** — 為 at 28px reads smaller than "for" at 28px — so the
CJK steps are a real exception, not drift. The rest (the bespoke 48 on the loop
diagram, the 15px code block on slide 25, the 30px matrix corners) are drift and
should collapse into the token scale.

This was deliberately not done the night before the talk: each change risks a
reflow on a slide already verified against four projector resolutions. The
audit above is the work list for afterwards.

## Verification

`scripts/` has no test for this. The check is a headless-Chrome sweep that walks
every slide, collects the computed `font-size` of every text-bearing element,
and reports distinct values per slide and deck-wide. Re-run it after any type
change and compare against the table in Consequences.

Overflow is verified separately at 1920×1080, 1366×768, 1280×720 and 1024×768:
no element may extend past its slide's bounds.
