---
name: design-to-code
description: "Convert a UI design into code and prove the match. Takes a Stitch screen (over MCP) or an HTML file, renders each screen as a reference at its exact viewport, builds the UI, screenshots every screen, scores it against the reference, and feeds the diff back until the match reaches the target (98% by default, 100% on request). Use whenever code must reproduce a design."
---

# Design to code

A design is only converted when a measured match says so. This skill is the loop: render the reference, build, capture, score, read the diff, fix, repeat. The loop ends on the score, not on the agent's judgement.

Companion skills: `ui-design-stitch` creates the design, `pixel-perfect-ui` holds the token and capture rules, `responsive-ui` holds the breakpoint rules, `ui-testing` holds the layers. Run this skill when a design exists and code must match it.

## Inputs

Take one of these, and state which one you used in the evidence:

- **Stitch:** a screen name `projects/{project}/screens/{screen}`, read through `route_to_mcp` with server `stitch`.
- **HTML:** an HTML file the user supplied, or one exported under `.verify/artifacts/design/<screen>/`.

Load `references/input-sources.md` to turn the input into one HTML file and one viewport per screen.

## Steps

1. **Resolve the inputs.** For each screen, get its HTML file and its width and height. Stop and ask only when the input is missing. Do not guess a viewport.
2. **Render the references.** Run `sh scripts/render.sh <absolute html path> <width> <height> <out.png>` for each screen. Save the PNG to `.verify/artifacts/design/<screen>/reference.png`. Check the PNG size matches the viewport.
3. **Set the threshold before building.** Use 98 unless the user asked for another value. Write it into the verification config, and do not change it during the loop.
4. **Map tokens.** Find the palette, type, radius, and spacing in the design HTML. Put each into the repository's theme. A literal value that is not in the theme is a defect (`pixel-perfect-ui`).
5. **Build each screen** from the repository's primitives, at the design's layout: the same rows, columns, and order. Do not add layout the design does not show.
6. **Start the app** and note its URL. The URL must serve the screen at the exact viewport.
7. **Write the manifest.** One row per screen, tab separated: `name`, `url`, `width`, `height`, `reference.png`. Keep it at `.verify/artifacts/design-loop/manifest.tsv`.
8. **Score.** Run `OUT_DIR=.verify/artifacts/design-loop/iter-<n> sh scripts/score.sh <manifest> <threshold>`. The script screenshots each URL, diffs it against its reference, and prints `match=<percent>`. Exit 0 means every screen met the threshold.
9. **Read the feedback.** For each screen below the threshold, open the reference, the candidate, and the diff image with the Read tool. Use `references/feedback-loop.md` to name each differing region and its cause.
10. **Fix the cause, then go to step 8.** One change set per iteration. Fix the cause the diff shows, not the screenshot.
11. **Stop.** The loop ends when every screen meets the threshold, when it reaches 8 iterations, or when two iterations in a row gain less than 0.5 points on the lowest screen. A stop at 8 or at a stall is a blocker. Report it with the diff images.
12. **Record the evidence.** Keep the manifest, each iteration's JSON and diff images, and the final captures under `.verify/artifacts/design-loop/`. Record the screen ids, the threshold, the final match per screen, and the iteration count in the screen's feature map entry.
13. **Verify.** Run `verification`. A design match is evidence only when it is recorded through `agent-brain verify`, so allowlist the score command.

## Rules

- The threshold is fixed before the first iteration. Lowering it to pass is test weakening.
- The match is pixel-exact. Two renders from the same renderer can score 100. A cross-renderer or cross-machine comparison may score lower for font antialiasing alone. Say so in the report when that is the cause.
- Hide or freeze content that changes between runs: timestamps, random avatars, animations. Do not hide content to pass a diff.
- Do not copy Stitch HTML into production code. Rebuild it from the repository's components and tokens.
- Do not put `STITCH_API_KEY` in the repository or in the manifest.
- Each iteration must read the three images. A score alone does not show where the difference is.
