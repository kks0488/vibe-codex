---
name: vc-agent-teams
description: Codex-native Agent Teams orchestration using file mailboxes and `vc teams` commands for create/send/status/prune workflows.
metadata:
  short-description: Codex-native team lifecycle + mailbox protocol.
---

# VC Agent Teams

## Purpose

Use this skill when the task needs multi-agent coordination in Codex with explicit team lifecycle control.

This skill maps Claude-style team concepts into Codex-native operations:
- Team lifecycle: create/delete
- Membership: add/remove members
- Messaging protocol: direct, broadcast, shutdown, plan approvals
- Mailbox runtime: file-backed JSON inboxes under `~/.vc/teams`

## Command Surface

Use the `vc teams` command group:

```bash
vc teams create --name my-project --description "research + implementation"
vc teams add-member --team my-project --name researcher --agent-type researcher
vc teams add-member --team my-project --name implementer --agent-type coder
vc teams send --team my-project --type message --from team-lead --recipient researcher --content "Analyze architecture"
vc teams send --team my-project --type broadcast --from team-lead --content "Status update"
vc teams status --team my-project
vc teams watch --team my-project --interval-ms 500 --max-iterations 5
vc teams read --team my-project --agent researcher --unread
vc teams await --team my-project --agent team-lead --request-id <id> --timeout-ms 15000 --json
vc teams prune --team my-project --days 7
vc teams delete --name my-project --force true
```

## Mailbox Layout

```text
~/.vc/teams/{team-name}/
├── config.json
├── inboxes/
│   ├── team-lead.json
│   ├── researcher.json
│   └── implementer.json
└── tasks/
```

## Protocol Mapping

`vc teams send --type ...` supports:
- `message`
- `broadcast`
- `shutdown_request`
- `shutdown_response`
- `shutdown_approved`
- `shutdown_rejected`
- `plan_approval_request`
- `plan_approval_response`

For request/response safety:
- `shutdown_request` and `plan_approval_request` generate `requestId` automatically if omitted.
- `shutdown_response` and `plan_approval_response` require both `--request-id` and `--approve <true|false>`.
- Responses fail if there is no matching pending request.

## Execution Rules

1. Keep the lead as coordinator; members handle narrow scopes.
2. Prefer direct messages over broad broadcasts.
3. Mark processed inbox entries as read to avoid duplicate work.
4. Prune stale read messages periodically.
5. Delete teams only after removing non-lead members (or use `--force true`).
