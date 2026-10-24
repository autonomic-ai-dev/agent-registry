# Feedback loop

Load this file at step 9 of `design-to-code`. It says how to read one iteration's output and what to change next.

## What the score means

- `match = 100 - diff_percent`, from `score.sh`. `diff_percent` is the share of pixels whose colour differs from the reference.
- The comparison is exact per pixel. Any colour difference counts, so a 98% target allows 2% of pixels to differ, and 100% allows none.
- If the candidate and reference differ in size, `score.sh` fails the screen with a size mismatch and does not report a match. `agent-eyes` itself compares only the overlapping area, so a size mismatch is not visible in the diff image. Check the size first.

## What each file tells you

Read these three for every screen below the threshold. Use the Read tool on each PNG:

1. **Reference** (`.verify/artifacts/design/<screen>/reference.png`): the target.
2. **Candidate** (`<iter>/<name>.png`): what the build renders.
3. **Diff** (`<iter>/<name>.diff.png`): differing pixels are solid red. Matching pixels show the reference.

From the diff, write down, for each red region:

- where it is (the element it sits on, not only its coordinates),
- what differs (position, size, colour, text, font, missing element, extra element),
- the cause in the code (the token, the margin, the component, the image URL).

## Order of fixes

Fix in this order. Each step changes what the next step shows, so do not fix a colour before the geometry is right.

1. **Size.** A size mismatch fails the screen before any pixel is compared. Fix the page size first, then score again.
2. **Missing or extra elements.** A region of red the size of a whole component is a missing or extra component.
3. **Position.** A component shifted by a few pixels paints two thin bands. Fix its margin or the container's alignment.
4. **Typography.** Text that differs everywhere in its box is a font, weight, size, or line height. Check the theme's type scale against the design.
5. **Colour.** A flat fill that differs is a token. Compare the hex value in the design HTML with the theme.
6. **Images.** A missing image paints its box red. Check that the image loads at the render time.

## Stall and stop

- Record the match of the lowest screen in each iteration. A gain under 0.5 points for two iterations in a row is a stall. Stop and report the blocker with the last diff images.
- At 8 iterations, stop and report. Do not keep iterating past the cap.
- A screen that matches at 100 in one iteration and falls in the next was broken by the latest change. Revert that change first.

## What not to do

- Do not change the threshold, the viewport, or the reference to make a score pass.
- Do not hide the differing region with CSS, a mask, or a `display: none`.
- Do not change the design tokens in the theme to match a wrong build. The design is the source of truth.
- Do not fix the score by adding a wrapper or a background that covers the page.
