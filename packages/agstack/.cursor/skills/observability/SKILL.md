---
name: observability
description: "Make a system's behaviour visible: structured logs, metrics for rates and latency, and traces across calls, with the rules for what to record and what never to record. Use when adding a service or endpoint, when debugging something only visible in production, or when a change needs a signal to confirm it works."
---

# Observability

A system that cannot be observed cannot be verified after release, and cannot be debugged when it fails. This skill sets what to record, how, and what to keep out of the record.

## Record

- **Logs:** structured (one event per line, with fields), at a level that means something. An error log has the error, the operation, and the identifier needed to find the request.
- **Metrics:** a counter for each outcome of a significant operation, and a histogram for latency. Use a label only for a small, fixed set of values.
- **Traces:** one span per call across a process boundary, with the operation name and the status.

## Do not record

- Secrets, tokens, passwords, keys, and session cookies, in any field, even on error.
- Personal data beyond the identifiers the operation needs. Log a user id, not an email or a name.
- Request or response bodies by default. Log their size, and their content only behind a flag that is off in production.
- Unbounded values as metric labels (a user id, a URL path with ids). They explode the metric count.

## Steps

1. **Name the questions** the signal must answer. "Is the endpoint slow for one tenant?" needs a latency histogram with a tenant label of bounded cardinality.
2. **Add the signal** at the operation boundary, not in every helper.
3. **Test the signal.** A test asserts the log line or the counter increments for both success and failure. A signal nobody tests is removed on the next refactor.
4. **Check the signal in a run.** Trigger the operation and show the output (`skills/claim-evidence`).

## Rules

- A change to a signal (a renamed field, a removed metric) is a breaking change for dashboards and alerts. Note it in the changelog.
- Logs are not a substitute for an error return. Errors are returned to the caller and logged once, at the layer that handles them.
- Alerts are written with their trigger, their owner, and the action to take. An alert without an action is removed.
