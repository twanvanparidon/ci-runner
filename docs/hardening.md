# Hardening

Less is more: the base ships only what every job needs. Scopes add the rest.

- Base pinned by tag and digest (`alpine:3.24.2@sha256:...`).
- Tools installed with [aqua](https://aquaproj.github.io) in a throwaway `fetch` stage; only the binaries reach the final image.
- Every download is verified against the committed `aqua-checksums.json` lock (and cosign where the tool signs releases).
- aqua itself is verified against its pinned checksums file, once, in the `builder` image.
- Runs as non-root `ci` (uid 10001).
- setuid/setgid bits stripped; apk cache removed.

## Gotchas

- GitHub Actions `container:` jobs may need `options: --user root` because the workspace is root owned.
- To install packages in a scope, switch to `USER root` and back to `USER 10001:10001`.

## Bumping versions

Edit the version in the image directory's `aqua.yaml`, run `task images:lock`, bump the image's `ARG VERSION`, then run `task security:scan`.
