# ci-runner

Commonly used CI/CD pipelines plus hardened CI images.

- **Images** (`images/`): a minimal, hardened `general` runner, extended per scope (e.g. `k8s`) with only the tools it needs. Published to `ghcr.io/twanvanparidon/ci-runner/<image>`.
- **Pipelines** (`pipelines/`): plain [Task](https://taskfile.dev) steps and CI examples to copy into projects, so the CI provider only calls `task <name>`.

## Layout

| Path | Purpose |
|---|---|
| `images/builder/` | Builder image: aqua + `aqua_bootstrap`, the fetch stage of every image |
| `images/general/` | Hardened base runner: alpine, Task, jq, git, non-root |
| `images/k8s/` | Kubernetes scope: kustomize, kube-linter, kubeconform, yq |
| `images/docker/` | Docker scope: docker CLI, buildx, hadolint, cosign, syft, grype |
| `images/_scope/` | Template for a new scope |
| `pipelines/` | Steps (`docker.yml`, `k8s.yml`), CI examples and `lcir.yml` to copy into projects |
| `examples/` | Example projects using both, e.g. `docker-app` |
| `docs/` | Extra documentation |

## Usage

```sh
task images:build     # build all images
task security:sbom    # build + write SBOMs to sbom/
task security:scan    # sbom + vulnerability scan
task lint:dockerfiles # hadolint every image Dockerfile
task --list           # everything else
```

To use the pipelines in a project, and run them locally in the same images, see [Pipelines](docs/pipelines.md).

## Docs

- [Hardening](docs/hardening.md)
- [SBOM](docs/sbom.md)
- [Releasing](docs/releasing.md)
- [Builders](docs/builders.md)
- [Adding a scope](docs/scopes.md)
- [CI env](docs/ci-env.md)
- [Pipelines](docs/pipelines.md)

## License

[MIT](LICENSE)
