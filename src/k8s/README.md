# k8s

Kubernetes manifest building, validation and GitOps image updates.

## Images

| Image | Adds |
|---|---|
| `k8s` | kustomize, kube-linter, kubeconform, yq |

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

The examples pass `$K8S_DIR/.kube-linter.yaml` to kube-linter when it exists (override with `KUBE_LINTER_CONFIG`); kube-linter only auto-loads it from the working directory.

## CI

| Example | Does |
|---|---|
| [`ci/gitlab/k8s-validate.gitlab-ci.yml`](ci/gitlab/k8s-validate.gitlab-ci.yml) | Render all overlays, then kubeconform and kube-linter on the output. CI only, no deploy. Copy it or `include: remote:` its raw URL. |
| [`ci/github/k8s-validate.yml`](ci/github/k8s-validate.yml) | Same checks as steps of one container job (runner uid, not root). Copy to `.github/workflows/`. Not yet run on GitHub. |
