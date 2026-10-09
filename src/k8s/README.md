# k8s

Kubernetes manifest building, validation and GitOps image updates.

## Images

| Image | Adds |
|---|---|
| `k8s` | kustomize, kube-linter, kubeconform, yq, git |

## Scripts

| Command | Does |
|---|---|
| `kustomize_build_all [dir]` | Builds every kustomization under `dir` (skips components), fails on any error. `OUT=<dir>` keeps the rendered output. |
| `gitops_set_image <overlay> <image>...` | `kustomize edit set image` in a checked out GitOps repo, checks the overlay still builds, commits and pushes (rebase and retry on conflict). `BRANCH`, `PUSH=false`. Image refs are not validated. |

Validate what gets deployed:

```sh
OUT=rendered kustomize_build_all apps
kubeconform -strict -summary rendered  # schemas; CRDs need -ignore-missing-schemas or a CRD schema location
kube-linter lint rendered              # best practices
```

## CI

Pipeline examples per provider in `ci/github/` and `ci/gitlab/`.
