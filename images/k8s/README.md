# k8s

Kubernetes tooling and GitOps image updates. Validation steps live in [`pipelines/k8s`](../../pipelines/k8s).

## Images

| Image | Adds |
|---|---|
| `k8s` | kustomize, kube-linter, kubeconform, yq |

## Scripts

| Command | Does |
|---|---|
| `gitops_set_image <overlay> <image>...` | `kustomize edit set image` in a checked out GitOps repo, checks the overlay still builds, commits and pushes (rebase and retry on conflict). `BRANCH`, `PUSH=false`. Image refs are not validated. |

## Pipelines

Steps (`k8s:validate`: render, kubeconform, kube-linter) and CI examples live in [`pipelines/k8s`](../../pipelines/k8s).
