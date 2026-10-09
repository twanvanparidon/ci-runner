# general

Hardened base runner every scope builds on. See [hardening](../../docs/hardening.md).

## Images

| Image | Adds |
|---|---|
| `general` | alpine, ca-certificates, Task, jq, git |

## Scripts

| Command | Does |
|---|---|
| `ci` | Run project and image tasks the same in CI and locally. See [ci](../../docs/ci.md). |
| `ci_env` | Provider agnostic CI variables: `eval "$(ci_env)"`. See [CI env](../../docs/ci-env.md). |

## CI

Pipeline examples per provider in `ci/<provider>/`.
