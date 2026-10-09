# general

Hardened base runner every scope builds on. See [hardening](../../docs/hardening.md).

## Images

| Image | Adds |
|---|---|
| `general` | alpine, ca-certificates, Task, jq, git |

## Scripts

| Command | Does |
|---|---|
| `ci_env` | Provider agnostic CI variables: `eval "$(ci_env)"`. See [CI env](../../docs/ci-env.md). |

## CI

Pipeline examples per provider in `ci/<provider>/`.
