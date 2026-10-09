# docker

Building, linting, signing and scanning images.

## Images

| Image | Adds |
|---|---|
| `docker` | docker CLI, buildx, hadolint, cosign, syft, grype |

No daemon is included: point buildx at a builder, see [builders](../../docs/builders.md).

## Tasks

| Task | Does |
|---|---|
| `ci:docker:lint` | hadolint every Dockerfile (or `DOCKERFILES`), fails after checking all |
| `ci:docker:build` | `docker buildx build` with `IMAGE`, `DOCKERFILE`, `CONTEXT`, `BUILD_ARGS` |

See [ci](../../docs/ci.md).

## CI

Pipeline examples per provider in `ci/<provider>/`.
