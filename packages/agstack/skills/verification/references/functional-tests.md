# Functional tests

Load this file when you add or review a functional suite for a repository surface. Write a suite only for a surface the repository actually exposes: an HTTP API, a CLI, a library's public interface, a message consumer, or a UI. A repository with no such surface has no functional suite.

## Rules

1. **Assert the outcome of every invocation.** For HTTP, assert the status code. For a CLI, assert the exit code. For a library, assert the return value. Use an exact value where one is defined, and a range only when the contract allows one.
2. **Assert what the feature promises.** Check the output the caller sees: the response body or headers, stdout or stderr, files written, or messages published.
3. **Capture what later steps need.** Keep created identifiers and reuse them in later steps. Scope captures to one suite.
4. **Clean up what you create.** End the scenario by removing the resources it created, unless the feature has no delete operation. If none exists, say so in the feature map under Gotchas.
5. **Keep runs independent of order.** Give each request or invocation an identifier unique to the run, so a repeat run does not collide with earlier data.
6. **Cover the negative cases.** For each validation rule, add an invocation that breaks the rule and assert the rejection. A rule with no negative case is untested.

## Examples

HTTP surfaces can use Hurl (`hurl --test .verify/functional/<feature>.hurl`):

```hurl
POST {{base_url}}/api/v1/jobs
Content-Type: application/json
{ "name": "backup" }
HTTP 201
[Captures]
job_id: jsonpath "$.id"
[Asserts]
header "Content-Type" contains "application/json"

GET {{base_url}}/api/v1/jobs/{{job_id}}
HTTP 200
[Asserts]
jsonpath "$.status" == "queued"
```

A CLI surface can use a shell script that checks the exit code and the output:

```sh
set -eu
out="$(agent-brain feature-graph .verify/features)"
printf '%s' "$out" | grep -q '"nodes"'
```

The variables come from the environment file, from captures, or from the script. Commands in the feature map name the literal file or command.
