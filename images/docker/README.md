# docker

Building, linting, signing and scanning images.

## Images

| Image | Adds |
|---|---|
| `docker` | docker CLI, buildx, hadolint, cosign, syft, grype |

No daemon is included: point buildx at a builder, see [builders](../../docs/builders.md).

## CI

Pipeline examples per provider in `ci/<provider>/`.
