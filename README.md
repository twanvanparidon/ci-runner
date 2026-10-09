# ci-runner

Commonly used CI/CD pipelines plus hardened CI images.

Images are published to `ghcr.io/twanvanparidon/ci-runner/<image>`.
Pipelines run [Task](https://taskfile.dev), so the CI provider only calls `task <name>`.
The `general` image is a minimal, hardened runner; each scope (e.g. `k8s`) extends it with only the tools it needs.

## Layout

| Path | Purpose |
|---|---|
| `src/builder/` | Builder image: aqua + `aqua_bootstrap`, the fetch stage of every image |
| `src/general/` | Hardened base runner: alpine, Task, jq, git, non-root |
| `src/k8s/` | Kubernetes scope: kustomize, kube-linter, kubeconform, yq, git |
| `src/docker/` | Docker scope: docker CLI, buildx, hadolint, cosign, syft, grype |
| `src/_scope/` | Template for a new scope |
| `taskfiles/` | Taskfiles for projects to copy, e.g. `lcir.yml` |
| `examples/` | Example projects using the images, e.g. `docker-app` |
| `docs/` | Extra documentation |

## Usage

```sh
task images:build     # build all images
task security:sbom    # build + write SBOMs to sbom/
task security:scan    # sbom + vulnerability scan
task lint:dockerfiles # hadolint every image Dockerfile
task --list           # everything else
```

To run CI steps locally in the same images, include [`taskfiles/lcir.yml`](taskfiles/lcir.yml), see [ci](docs/ci.md).

## Docs

- [Hardening](docs/hardening.md)
- [SBOM](docs/sbom.md)
- [Releasing](docs/releasing.md)
- [Builders](docs/builders.md)
- [Adding a scope](docs/scopes.md)
- [CI env](docs/ci-env.md)
- [ci tasks](docs/ci.md)

## License

[MIT](LICENSE)
