# tofu

OpenTofu tooling: lint, and decrypt SOPS secrets for plan and apply.

## Images

| Image | Adds |
|---|---|
| `tofu` | tofu, tflint, sops, age |

## Pipelines

- [`pipelines/tofu/lint`](../../pipelines/tofu/lint): fmt, tflint, validate
