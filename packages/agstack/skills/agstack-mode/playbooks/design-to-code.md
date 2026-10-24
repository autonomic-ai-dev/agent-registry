# Design to Code

Use this playbook when code must reproduce a Stitch screen or an HTML design. It ends when every screen's measured match reaches the threshold, or when the loop reports a blocker.

Skills used: `design-to-code`, `ui-design-stitch` (Stitch inputs), `pixel-perfect-ui`, `responsive-ui`, `ui-testing`, `verification`.

1. [ ] Step 1: Resolve the inputs. For each screen, get its HTML file and its width and height from Stitch (`get_screen`, `download_file`) or from the user. Ask for the viewport if the input does not state it.
2. [ ] Step 2: Render each reference. Run `sh scripts/render.sh <absolute html> <width> <height> .verify/artifacts/design/<screen>/reference.png`. Check each PNG's size matches its viewport.
3. [ ] Step 3: Fix the threshold. Use 98 unless the user asked for another value. Record it in the verification config before the first iteration, and do not change it during the loop.
4. [ ] Step 4: Map the tokens. Take the palette, type scale, radius, and spacing from the design HTML into the repository's theme. A literal value not in the theme is a defect.
5. [ ] Step 5: Build each screen with the repository's primitives, at the design's layout: the same rows, columns, and order.
6. [ ] Step 6: Start the app and note its URL. Write the manifest at `.verify/artifacts/design-loop/manifest.tsv`, one row per screen: name, URL, width, height, reference path.
7. [ ] Step 7: Score. Run `OUT_DIR=.verify/artifacts/design-loop/iter-<n> sh scripts/score.sh .verify/artifacts/design-loop/manifest.tsv <threshold>`. Exit 0 means every screen met the threshold.
8. [ ] Step 8: Read the feedback for each screen below the threshold. Read the reference, the candidate, and the diff PNG. Write down each red region, what differs, and its cause in the code (`references/feedback-loop.md`).
9. [ ] Step 9: Fix the causes in the order the feedback loop gives: size, missing or extra elements, position, typography, colour, images. Then return to step 7. One change set per iteration.
10. [ ] Step 10: Stop when every screen meets the threshold, at 8 iterations, or after two iterations in a row that gain less than 0.5 points on the lowest screen. A cap or a stall is a blocker. Report it with the last diff images.
11. [ ] Step 11: Check the responsive breakpoints. Repeat steps 2 and 7 at each breakpoint the design defines, and at 390×844, 834×1112, and 1440×900 when it defines none. Every breakpoint must meet the threshold.
12. [ ] Step 12: Run the layers through the allowlist: the flow test, `ui-testing`'s accessibility check, and the score command. Each must pass through `agent-brain verify`.
13. [ ] Step 13: Record the evidence. Keep the manifest, each iteration's JSON and diff PNGs, and the final captures under `.verify/artifacts/design-loop/`. Record the Stitch project and screen ids, the threshold, the final match per screen, and the iteration count in the feature map.
14. [ ] Step 14: Run `verification` and write the evidence record. Do not claim completion without the match numbers and the artifact paths.
