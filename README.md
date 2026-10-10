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
| `images/_example/` | Template for a new image |
| `pipelines/<scope>/<purpose>/` | Taskfile plus GitHub and GitLab examples to copy, e.g. `k8s/lint`, `k8s/gitops` |
| `docs/` | Extra documentation |

## Usage

The tasks run inside this repo's own `docker` image, like CI does (it ships syft, grype, hadolint):

```sh
alias in-ci='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --group-add "$(stat -Lc %g /var/run/docker.sock 2>/dev/null || stat -Lf %g /var/run/docker.sock)" -v "$PWD:$PWD" -w "$PWD" --user "$(id -u):$(id -g)" -e HOME=/tmp ghcr.io/twanvanparidon/ci-runner/docker:1.3.2'
in-ci task images:build     # build all images
in-ci task security:sbom    # build + write SBOMs to sbom/
in-ci task security:scan    # sbom + vulnerability scan
in-ci task lint:dockerfiles # hadolint every image Dockerfile
in-ci task --list           # everything else
```

`task images:lock` and `task images:release` run on the host (they start containers with mounts, or need buildx and cosign set up).

To use the pipelines in a project, see [Pipelines](docs/pipelines.md).

## Docs

Images: [Hardening](docs/hardening.md), [SBOM](docs/sbom.md), [Releasing](docs/releasing.md), [Builders](docs/builders.md), [Adding a scope](docs/scopes.md)

Pipelines: [Pipelines](docs/pipelines.md), [CI env](docs/ci-env.md)

## License

[MIT](LICENSE)
