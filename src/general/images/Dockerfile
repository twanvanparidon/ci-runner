# Hardened general runner: alpine + task + jq, non-root, nothing else.
# Scopes extend this image and add only what they need.

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.2.0
ARG ALPINE=alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
# scripts* is optional: a scope without scripts still builds.
COPY images/aqua.yaml images/aqua-checksums.json scripts* /work/
RUN aqua_bootstrap

FROM ${ALPINE}
ARG VERSION=1.2.0
LABEL org.opencontainers.image.version=${VERSION}
RUN apk upgrade --no-cache \
 && apk add --no-cache ca-certificates \
 && addgroup -g 10001 ci \
 && adduser -D -u 10001 -G ci -s /bin/sh ci \
 && find / -xdev -perm /6000 -type f -exec chmod a-s {} + \
 && rm -rf /var/cache/apk/* /tmp/*
COPY --from=fetch /out/ /usr/local/bin/

USER 10001:10001
WORKDIR /workspace
ENTRYPOINT []
CMD ["task", "--list"]
