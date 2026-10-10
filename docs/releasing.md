# Releasing

Each image is versioned on its own via `ARG VERSION` in its Dockerfile.

## Flow

1. Change an image and bump its `ARG VERSION` (semver).
2. PR: `task images:check` fails if an image changed (Dockerfile, aqua files, `scripts/`, `.dockerignore`) but its version is already published. `task security:scan` must pass.
3. Merge to main: `task images:release` builds, pushes and signs every image whose version is missing from the registry. Published versions are never overwritten. A rerun finishes a release that stopped halfway (signs and tags an already pushed version).

CI runs in this repo's own `docker` image, pinned to the last release, so a broken new release cannot break the pipeline that fixes it. CI only runs when image files change, and only builds, lints and scans the images whose Dockerfile, aqua files, `scripts/` or `.dockerignore` changed (all images when shared files like Taskfiles or `.grype.yaml` change). Locally every task covers all images; add `CHANGED_ONLY=true` to narrow it.

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

## Renovate

Renovate (the Mend GitHub App, config in `.github/renovate.json5`) opens PRs on Monday mornings for:

- `aqua.yaml` tools, the aqua registry ref and the aqua CLI (`ARG AQUA_VERSION`), as one `aqua` PR
- GitHub Action SHAs, as one `github actions` PR
- the Alpine digest (`ARG ALPINE`)
- this repo's own images, at any time: `ARG BUILDER_VERSION`, `ARG GENERAL_VERSION`, and the runner pins in the workflows, `pipelines/` and the README

On each Renovate PR, `.github/workflows/renovate.yml` runs `task images:lock` and `task images:bump` and commits the result, so `images:check` passes. Releases cascade: a new `builder` release gets a PR moving the pins in the other images, which bumps those, and so on.

It needs the secret `RENOVATE_GLUE_TOKEN`: a fine-grained token with `contents: write` on this repo, so its push triggers `images.yml`.

## Supply chain

Every push carries a BuildKit SBOM and provenance attestation, and the image is signed keyless with cosign.

```sh
cosign verify ghcr.io/twanvanparidon/ci-runner/general:1.0.0 \
  --certificate-identity-regexp 'https://github.com/twanvanparidon/ci-runner/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
docker buildx imagetools inspect ghcr.io/twanvanparidon/ci-runner/general:1.0.0 --format '{{json .SBOM}}'
```

## Security patches

Alpine patches only land on rebuild. When the weekly scan flags one, bump the patch version.
