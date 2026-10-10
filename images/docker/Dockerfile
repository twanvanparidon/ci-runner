# Docker tooling: general runner + docker CLI, buildx, hadolint, cosign, syft, grype.
# No daemon: point buildx at a builder (remote BuildKit, dind service or socket).

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.2.1
ARG GENERAL_VERSION=1.4.0

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
# scripts* is optional: a scope without scripts still builds.
COPY aqua.yaml aqua-checksums.json scripts* /work/
# The docker package also ships dockerd and containerd; keep only the CLI.
RUN aqua_bootstrap docker docker-cli-plugin-docker-buildx hadolint cosign syft grype \
 && mkdir /plugins \
 && mv /out/docker-cli-plugin-docker-buildx /plugins/docker-buildx

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.3.1
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /out/ /usr/local/bin/
COPY --from=fetch /plugins/ /usr/local/lib/docker/cli-plugins/
