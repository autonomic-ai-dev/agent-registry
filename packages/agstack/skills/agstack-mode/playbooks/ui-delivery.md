# UI Delivery

Use this playbook for any task that adds or changes a user interface. It takes a design from Stitch to code that matches it pixel for pixel, holds at every breakpoint, and is proven by layered tests.

Skills used: `ui-design-stitch`, `pixel-perfect-ui`, `responsive-ui`, `ui-testing`, `verification`.

1. [ ] Step 1: Confirm the design exists. Find the Stitch project and screen for this UI. If none exists, create it with `ui-design-stitch` before writing code.
2. [ ] Step 2: Export the reference. Save the screenshot and HTML under `.verify/artifacts/design/<screen>/`.
3. [ ] Step 3: Map the tokens. Confirm the repository's theme matches the Stitch design system. Add any missing token before writing markup.
4. [ ] Step 4: Write the failing flow test. Cover the user action the screen exists for. Run it through the gate and confirm it fails for the right reason.
5. [ ] Step 5: Build the component from the repository's primitives, at the design's viewport, with tokens only.
6. [ ] Step 6: Run the pixel comparison with `pixel-perfect-ui`. Iterate on the diff until it is within the threshold.
7. [ ] Step 7: Run the responsive checks with `responsive-ui` at phone, tablet, and desktop. Every measured rule must pass.
8. [ ] Step 8: Run the accessibility layer and the functional flow through the allowlist, per `ui-testing`.
9. [ ] Step 9: Run `verification`: the allowlisted suite, the artifact record, and the evidence matrix. Do not claim completion without the artifacts.
10. [ ] Step 10: Update the feature map and knowledge base for the screen, with the Stitch ids and the baseline path.
