# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.

These are common instructions for Hung's agents across all scenarios.

## About me
- I'm an analytics engineer. My stack is dbt (Core + Cloud), BigQuery on GCP, and Looker (LookML).
- I know SQL and dbt very well. Skip the basics and explain trade-offs, not syntax.
- Optimize for: correct numbers first, then readable models, then query cost, then speed.

## Hung's opinions
When you are working on something that would benefit from my viewpoints, read @OPINIONS.md to understand my viewpoints and references.

## Messages to me
- I am working on something else while reading your response, so open with the conclusion first, then outline your reasonings leading to that conclusion.
- Follow ASD-STE100 Simplified Technical English Standard for all of your responses to me.
- Say plainly when you haven't run or validated something. Don't present untested SQL as working.

## General guidelines
- When writing commit messages, NEVER auto-add your agent name as co-author
- When a metric definition is ambiguous (e.g. "active user", "revenue"), ask. Don't guess.
- Prefer small, reviewable changes (less than 500 lines) over large refactors unless I ask for one.
- Follow project conventions for SQL, dbt and LookML unless I explicitly said otherwise
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- Follow KISS, DRY, YAGNI, and SOLID principles of software engineering.
- Favor Looker API over Looker MCP.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.

## BigQuery and GCP: cost and safety
- Dry-run (`bq query --dry_run` or `--dry-run` in the MCP) before running ad-hoc queries on large tables, and tell me the bytes scanned if it's over 10 GB.
- Always filter on partition columns. `LIMIT` doesn't reduce bytes scanned.
- Default to read-only. Ask me first before any DDL/DML, `bq rm`, `bq cp` overwrites, IAM changes, or writes to prod datasets.
- Use dev/sandbox datasets for testing. Never point a dev run at prod targets.
- Prefer `gcloud`/`bq` CLI over the console. Never print or echo service-account keys or credentials.

## Data handling
- Treat customer data as sensitive. Don't paste raw PII rows into chat output. Aggregate or mask instead.
- When validating, show row counts, distinct keys, and null rates rather than raw records.

## Minimum validation checklist (before saying "done")
1. Compiled SQL reviewed
2. Tests pass on the changed models and their direct children
3. Row counts and key metrics compared before vs. after for changed marts
