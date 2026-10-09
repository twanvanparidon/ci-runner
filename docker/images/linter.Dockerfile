# Dockerfile linting: general runner + hadolint.

ARG REGISTRY=ci-runner
ARG GENERAL_VERSION=1.0.0
ARG ALPINE=alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

FROM ${ALPINE} AS fetch
ARG TARGETARCH
ARG HADOLINT_VERSION=2.15.1
ARG HADOLINT_ASSET_amd64=hadolint-linux-x86_64
ARG HADOLINT_ASSET_arm64=hadolint-linux-arm64
ARG HADOLINT_SHA256_amd64=c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507
ARG HADOLINT_SHA256_arm64=f6198ef8090f404dbb771abfee086eb8c48ac177f30da7fd3510aca35b344b5d
RUN apk add --no-cache curl \
 && eval "asset=\$HADOLINT_ASSET_${TARGETARCH} sha=\$HADOLINT_SHA256_${TARGETARCH}" \
 && curl -fsSLo /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/${asset}" \
 && echo "${sha}  /usr/local/bin/hadolint" | sha256sum -c - \
 && chmod 755 /usr/local/bin/hadolint

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.0.0
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /usr/local/bin/hadolint /usr/local/bin/
