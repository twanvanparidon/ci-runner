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

## CI

| Example | Does |
|---|---|
| [`ci/gitlab/k8s-validate.gitlab-ci.yml`](ci/gitlab/k8s-validate.gitlab-ci.yml) | Render all overlays, then kubeconform and kube-linter on the output. CI only, no deploy. Copy it or `include: remote:` its raw URL. |
| [`ci/github/k8s-validate.yml`](ci/github/k8s-validate.yml) | Same checks as steps of one container job (runner uid, not root). Copy to `.github/workflows/`. Not yet run on GitHub. |
