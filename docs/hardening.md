# Hardening

Less is more: the base ships only what every job needs. Scopes add the rest.

- Base pinned by tag and digest (`alpine:3.24.2@sha256:...`).
- Tools downloaded in a throwaway `fetch` stage; curl never reaches the final image.
- Every download is verified against a sha256 pinned in the Dockerfile.
- Runs as non-root `ci` (uid 10001).
- setuid/setgid bits stripped; apk cache removed.

## Gotchas

- GitHub Actions `container:` jobs may need `options: --user root` because the workspace is root owned.
- To install packages in a scope, switch to `USER root` and back to `USER 10001:10001`.

## Bumping versions

Update the tool version and both `*_SHA256_*` args, bump the image's `ARG VERSION`, then run `task security:scan`.
