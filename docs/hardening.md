# Hardening

Less is more: the base ships only what every job needs. Scopes add the rest.

- Base pinned by tag and digest (`alpine:3.24.2@sha256:...`).
- Tools installed with [aqua](https://aquaproj.github.io) in a throwaway `fetch` stage; only the binaries reach the final image.
- Every download is verified against the committed `aqua-checksums.json` lock (and cosign where the tool signs releases).
- aqua itself is verified against its pinned checksums file, once, in the `builder` image.
- Build context allowlisted per scope via `.dockerignore`.
- Runner images run as non-root `ci` (uid 10001); only the `builder` stage runs as root.
- git trusts every directory (`safe.directory = *`): checkouts are owned by another user (GitLab clones as root, a local `docker run` mounts yours) and a CI container has no other users to guard against.
- setuid/setgid bits stripped; apk cache removed.

## Gotchas

- GitHub Actions `container:` jobs: use `options: --user 1001:1001`, the runner's user, which owns the workspace. Add `--group-add 118` (the docker socket group on GitHub's Ubuntu runners) when the job uses Docker.
- To install packages in a scope, switch to `USER 0` and back to `USER 10001:10001` (numeric, so hadolint is happy).

## Bumping versions

Renovate does this weekly (see [Releasing](releasing.md#renovate)). By hand: edit the version in the image directory's `aqua.yaml`, run `task images:lock`, bump the image's `ARG VERSION` (or run `task images:bump`), then run `task security:scan`.
