# Hardened general runner: alpine + task + jq + git, non-root, nothing else.
# Scopes extend this image and add only what they need.

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.2.1
ARG ALPINE=alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
# scripts* is optional: a scope without scripts still builds.
COPY aqua.yaml aqua-checksums.json scripts* /work/
RUN aqua_bootstrap

FROM ${ALPINE}
ARG VERSION=1.4.1
LABEL org.opencontainers.image.version=${VERSION}
RUN apk upgrade --no-cache \
 && apk add --no-cache ca-certificates git \
 && git config --system --add safe.directory '*' \
 && addgroup -g 10001 ci \
 && adduser -D -u 10001 -G ci -s /bin/sh ci \
 && find / -xdev -perm /6000 -type f -exec chmod a-s {} + \
 && rm -rf /var/cache/apk/* /tmp/*
COPY --from=fetch /out/ /usr/local/bin/

USER 10001:10001
WORKDIR /workspace
ENTRYPOINT []
CMD ["task", "--list"]
