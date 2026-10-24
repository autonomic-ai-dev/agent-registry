---
name: tool-selection
description: "Pick the right tool for each step and avoid wasteful or bypassing calls. Use at the start of a task, when a tool call fails or returns too much output, and before a native read, grep, or shell command where a routed agent-brain or agent-body tool exists."
---

# Tool selection

The same step can be done with several tools, and the wrong one costs context, bypasses routing, or runs unverified commands. This skill sets the default for each kind of step.

## Defaults

| Step | Use | Not |
|---|---|---|
| Find a symbol or string | `grep_search`, `search_symbols` | a full-file read to find it |
| Read part of a file | `read_file_head`, `read_file_tail`, or a native read with `offset` and `limit` | a whole large file |
| Summarise a file | `file_summary` first | reading it to check its size |
| Run a build, test, or shell command | the routed execution tool in `suggested_tools` | a raw shell command when a routed one exists |
| Run a verification command | `agent-brain verify -- <cmd>` | a bare command, which is not recorded as evidence |
| Call an upstream MCP server | `route_to_mcp` after `route_task` names it | guessing the tool's name |
| Git history or diff | `brain_git_log`, `brain_git_diff` | raw `git log` output dumps |

## Steps

1. **Read `suggested_tools` and `must_apply`** from `route_task` before the first call of a task.
2. **For each step, pick the default in the table.** Use the native tool only when no routed tool fits, and say so once.
3. **If a call fails,** read the error. A route-gate denial means call `route_task` again. A missing tool means check the tool list and `agent-brain mcp list` before saying it is unavailable.
4. **If output is too large,** narrow the call (a pattern, a range, `head`) instead of retrying the same call.
5. **Record the tool in the evidence** when it matters: a verification run, a measurement, a generated artifact.

## Rules

- Do not call the same tool with the same arguments twice in a task. Keep the first result.
- Do not batch unrelated calls into one long command. Independent calls can run in parallel, and each one should be small.
- Do not use a shell pipeline to execute code produced by another source. Read it first.
- A tool that is available but not needed for the step is not a reason to call it.
