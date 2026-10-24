---
name: pixel-perfect-ui
description: "Implement a UI so it matches its design reference pixel for pixel: tokens over literals, a fixed capture size, screenshot diffs against the Stitch export, and a threshold that fails the run. Use when code must match a design or a baseline screenshot."
---

# Pixel-Perfect UI

A screen matches its design when a capture of the running app, at the design's size, differs from the reference by less than the agreed threshold. Fidelity is measured, not judged by eye.

## Inputs

- The design reference from `ui-design-stitch`: `.verify/artifacts/design/<screen>/screenshot.png` and the HTML.
- The design tokens: the same palette, type, radius, and spacing set in Stitch, mirrored in the repository's theme file.
- The URL of the running screen, and the viewport the design was exported at.

## Steps

1. **Pin the viewport.** Capture at the exact width and height of the design export. A different viewport invalidates every comparison.
2. **Map tokens before writing markup.** Every colour, font size, radius, and spacing value comes from the theme. A literal value that is not in the theme is a defect, because it will drift from the design system.
3. **Build the component from the repository's primitives.** Keep the layout the design shows: the same column and row structure, the same order, the same alignment. Do not invent layout to fill a gap.
4. **Capture and diff.** Run the capture against the reference:
   - `agent-eyes capture <url>` for the current render
   - `agent-eyes diff <reference.png> <capture.png>` for the pixel comparison
   - `eyes_diff_screenshots` through agent-body with `url`, `baseline`, and `threshold` when the app is served locally
   Write the diff image to `.verify/artifacts/ui/<screen>/`.
5. **Iterate on the diff, not on the screenshot.** Find the regions the diff highlights. Fix the cause (a token, a margin, a font weight), then capture again.
6. **Set the threshold deliberately.** The default one-percent pixel threshold passes sub-pixel anti-aliasing differences. Tighten it for a screen where the design is fixed, and record the value in the verification config. Never loosen it to make a run pass. That is test weakening.
7. **Commit the baseline.** Once the diff is within threshold, save the capture as the baseline for the regression suite under `.verify/`. Fixtures under `verify/` stay read-only.

## Rules

- A changed baseline is a design change. Update it only when the design changed, and say so in the PR.
- Fonts and images must be loaded from the repository, not from a CDN that can change the render between runs.
- Animations are disabled for capture. Freeze the first frame.
- A failed comparison blocks completion. Report the diff image path and the percentage.
