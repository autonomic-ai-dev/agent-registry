# Input sources

Load this file in step 1 of `design-to-code`. Its job is to produce, for each screen, one absolute HTML path and one viewport (`width`, `height`).

## Stitch screen

Stitch is reached with `route_to_mcp` and server `stitch`. Read a tool's schema with the same call and `describe_tool: true` before you call it.

1. **Find the screen.** `list_screens` for the project lists its screens. Pick the screen by title. Use `get_screen` if you already have the name.
2. **Read the screen.** `get_screen` with `name` set to `projects/{project}/screens/{screen}`. It returns:
   - `width` and `height`: strings, in CSS pixels. These are the viewport.
   - `deviceType`: `MOBILE`, `TABLET`, `DESKTOP`, or `AGNOSTIC`. Use it to choose the viewport when the screen is `AGNOSTIC`, and state the choice in the evidence.
   - `htmlCode.name`: the resource name of the HTML file.
   - `screenshot.name`: the resource name of the screenshot. Do not use it as the reference (see below).
3. **Download the HTML.** `download_file` with `name` set to `htmlCode.name`. The response field `html` holds the raw HTML as text. Write it with the Write tool to `.verify/artifacts/design/<screen>/design.html`, then use that absolute path.
4. **Do not use the screenshot as the reference.** `download_file` returns image bytes as base64 inside the response, and that is not practical to write to a file. Render the reference from the HTML with `scripts/render.sh` instead. The render uses the screen's own `width` and `height`, so it matches what Stitch shows.

If the HTML loads images from remote URLs, those images must load during the render. If they cannot, the reference is wrong for that region. Record the region in the Gotchas section of the screen's map, and do not hide it in the diff.

## HTML supplied by the user

1. Use the file path the user gave. Copy it into `.verify/artifacts/design/<screen>/design.html` so the evidence stays with the run.
2. The viewport is the design's own width and height. Look for a fixed `width` in the page's root element, or a viewport the user states. If the file gives no size, stop and ask for the width and height. Do not assume 1280 or 1440.

## Responsive screens

A design with more than one device type needs one row in the manifest per device. Use the three breakpoints from `responsive-ui` (390×844, 834×1112, 1440×900) when the design has no breakpoint of its own. Each row has its own reference, rendered at that viewport from the same HTML. Stitch produces one HTML per screen, so the other breakpoints are the same HTML rendered at other widths. A breakpoint whose layout differs from the design is a design gap, and it goes back to Stitch through `edit_screens`.
