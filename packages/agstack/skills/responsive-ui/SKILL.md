---
name: responsive-ui
description: "Make a UI hold at phone, tablet, and desktop widths: capture each breakpoint, reject horizontal scroll, keep a 16px side gutter at phone width, and verify reflow rather than only the desktop view. Use whenever a screen or component changes layout."
---

# Responsive UI

A layout is responsive when it works at every width it will be shown at, not only at the width it was designed on. The check is a set of captures at fixed breakpoints, each with measured properties.

## Breakpoints

Check at least these widths, and add the design's own breakpoints when it defines them:

| Name | Width | Height |
|---|---|---|
| phone | 390 | 844 |
| tablet | 834 | 1112 |
| desktop | 1440 | 900 |

## Steps

1. **Capture each breakpoint.** `agent-eyes capture <url>` at each width. Save to `.verify/artifacts/responsive/<screen>/<name>.png`.
2. **Check the measurable rules.** For every breakpoint:
   - the document has no horizontal scroll (`scrollWidth` equals the viewport width)
   - no element extends past the viewport
   - text does not overflow its container at the phone width
   - touch targets are at least 44 by 44 CSS pixels at phone and tablet widths
   - the side gutter is at least 16 px at phone width
3. **Check reflow.** Compare the phone capture with the desktop capture. The same content should be present in the same order, rearranged into fewer columns. Missing or duplicated content is a defect.
4. **Fix the cause at the layout level.** Use flexible units and wrapping containers. Do not add a fixed width to make one breakpoint pass. That breaks the next one.
5. **Record the result.** Write the breakpoint table, the measured rule results, and the capture paths into the run's artifacts. A failed rule blocks completion.

## Rules

- A component that works only at one width is not finished, even when the design shows only one width.
- Hover-only controls must have a touch equivalent at phone width.
- Do not hide content at phone width to pass the overflow check. Move it, collapse it, or wrap it.
