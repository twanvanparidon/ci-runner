# Releasing

Each image is versioned on its own via `ARG VERSION` in its Dockerfile.

## Flow

1. Change an image and bump its `ARG VERSION` (semver).
2. PR: `task images:check` fails if an image directory changed but its version is already published. `task security:scan` must pass.
3. Merge to main: `task images:release` builds, pushes and signs every image whose version is missing from the registry. Published versions are never overwritten. A rerun finishes a release that stopped halfway (signs and tags an already pushed version).

## Tags

| Tag | Moves |
|---|---|
| `1.2.0` | never |
| `1`, `latest` | on every release |
| `sha-<commit>` | never |

Git tag `<image>/v<version>` marks the released commit.

## Dependent images

Images pin their dependencies exactly (`ARG BUILDER_VERSION`, `ARG GENERAL_VERSION`).
Bumping `builder` or `general` means bumping the pin, which forces a version bump of the dependent image too.
This can happen in two phases: bump `builder`, release, then move the pins. Until then the old pin is pulled from GHCR, so build with `REGISTRY=ghcr.io/twanvanparidon/ci-runner` (CI does).

## Supply chain

Every push carries a BuildKit SBOM and provenance attestation, and the image is signed keyless with cosign.

```sh
cosign verify ghcr.io/twanvanparidon/ci-runner/general:1.0.0 \
  --certificate-identity-regexp 'https://github.com/twanvanparidon/ci-runner/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
docker buildx imagetools inspect ghcr.io/twanvanparidon/ci-runner/general:1.0.0 --format '{{json .SBOM}}'
```

## Security patches

Alpine patches only land on rebuild. When the nightly scan flags one, bump the patch version.
