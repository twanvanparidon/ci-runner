# k8s

Kubernetes manifest building and linting.

## Images

| Image | Adds |
|---|---|
| `k8s` | kustomize, kube-linter, yq |

## Scripts

| Command | Does |
|---|---|
| `kustomize_build_all [dir]` | Builds every kustomization under `dir` (skips components), fails on any error. `OUT=<dir>` keeps the rendered output, e.g. for `kube-linter lint`. |

## CI

Pipeline examples per provider in `ci/github/` and `ci/gitlab/`.
