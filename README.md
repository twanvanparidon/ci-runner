# ci-runner

Commonly used CI/CD pipelines plus hardened CI images.

Images are published to `ghcr.io/twanvanparidon/ci-runner/<image>`.
Pipelines run [Task](https://taskfile.dev), so the CI provider only calls `task <name>`.
The `general` image is a minimal, hardened runner; each scope (e.g. `k8s`) extends it with only the tools it needs.

## Layout

| Path | Purpose |
|---|---|
| `general/` | Hardened base runner: alpine, Task, non-root |
| `k8s/` | Kubernetes scope: kustomize, kube-linter |
| `docker/` | Docker scope: hadolint |
| `_scope/` | Template for a new scope |
| `docs/` | Extra documentation |

## Usage

```sh
task images:build     # build all images
task security:sbom    # build + write SBOMs to sbom/
task security:scan    # sbom + vulnerability scan
task lint:dockerfiles # hadolint every image Dockerfile
task --list           # everything else
```

## Docs

- [Hardening](docs/hardening.md)
- [SBOM](docs/sbom.md)
- [Releasing](docs/releasing.md)
- [Adding a scope](docs/scopes.md)
