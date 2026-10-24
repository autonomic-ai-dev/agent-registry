---
name: ui-design-stitch
description: "Design screens with the Stitch MCP server: create a project, set a design system from DESIGN.md or tokens, generate and edit screens from text, pull HTML and screenshots back into the repo as the reference for implementation. Use when a task starts from a UI design or changes a screen's look."
---

# UI Design with Stitch

Stitch produces the design. The repository implements it. The design is the source of truth for layout, spacing, colour, and type, so the implementation reads it rather than guessing. This skill covers the design half: create the project, set the system, generate screens, and export the references that `pixel-perfect-ui` and `responsive-ui` will check against.

## Stitch tools

All reached through `route_to_mcp` with server `stitch`:

| Tool | Use |
|---|---|
| `create_project` | Start a project for the product |
| `list_projects`, `get_project` | Find an existing project before creating one |
| `create_design_system`, `update_design_system` | Set colours, typography, corner shape, light and dark appearance |
| `upload_design_md`, `create_design_system_from_design_md` | Build the design system from a DESIGN.md file |
| `generate_screen_from_text` | Create a screen from a prompt |
| `edit_screens`, `generate_variants` | Change or vary existing screens |
| `list_screens`, `get_screen` | Read screen metadata and status |
| `download_file` | Fetch a screen's HTML or screenshot (use this, not the `download_url`) |
| `delete_project` | Destructive. Confirm with the user first. |

## Steps

1. **Anchor the project.** Find the Stitch project for this product with `list_projects`. Create one only when none matches.
2. **Set the design system first.** Tokens (palette, type, radius, light and dark backgrounds) apply to every screen, so set them before generating screens. Keep the same tokens in the repository's theme file.
3. **Generate the screen.** Call `generate_screen_from_text` with a prompt that names the screen, its states, and the breakpoints it must hold at. Generation can take minutes. Do not retry on timeout. Poll `get_screen` every 30 seconds, up to ten times.
4. **Iterate, do not regenerate.** Use `edit_screens` for a change to an existing screen. Use `generate_variants` to explore alternatives. Keep the chosen screen's id.
5. **Export the reference.** `download_file` for the screenshot and the HTML. Save both under `.verify/artifacts/design/<screen>/`. The screenshot is the pixel reference. The HTML is the structural reference.
6. **Record the link.** Write the Stitch project id, screen id, and design-system version into the feature map's `## Code` or knowledge base entry for the screen, so a later change can find its design.

## Rules

- The screenshot is evidence of intent, not a contract on its own. The implementation must still pass `pixel-perfect-ui` and `responsive-ui`.
- Do not copy Stitch HTML into production code as is. Rebuild it with the repository's components and tokens.
- Do not put API keys in the repository. `STITCH_API_KEY` stays in the environment.
- Ask before `delete_project` or any change that replaces a screen the user already approved.
