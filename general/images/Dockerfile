# Hardened general runner: alpine + task, non-root, nothing else.
# Scopes extend this image and add only what they need.

ARG ALPINE=alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

# Fetch stage: download tooling lives here, never in the final image.
FROM ${ALPINE} AS fetch
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG TARGETARCH
ARG TASK_VERSION=3.54.0
ARG TASK_SHA256_amd64=680859dbb4d881a9c72d4d9a8f510825450849af8567deacd7302c01124416fb
ARG TASK_SHA256_arm64=d7189d439d4a6058e39e1b2acd7c8b27acd4856691b408f23b242e4294e1df5b
# sha is assigned via eval
# hadolint ignore=SC2154
RUN apk add --no-cache curl \
 && eval "sha=\$TASK_SHA256_${TARGETARCH}" \
 && curl -fsSLo /tmp/task.tgz "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_${TARGETARCH}.tar.gz" \
 && echo "${sha}  /tmp/task.tgz" | sha256sum -c - \
 && tar -xzf /tmp/task.tgz -C /usr/local/bin task

FROM ${ALPINE}
ARG VERSION=1.0.1
LABEL org.opencontainers.image.version=${VERSION}
RUN apk upgrade --no-cache \
 && apk add --no-cache ca-certificates \
 && addgroup -g 10001 ci \
 && adduser -D -u 10001 -G ci -s /bin/sh ci \
 && find / -xdev -perm /6000 -type f -exec chmod a-s {} + \
 && rm -rf /var/cache/apk/* /tmp/*
COPY --from=fetch /usr/local/bin/task /usr/local/bin/task

USER 10001:10001
WORKDIR /workspace
ENTRYPOINT []
CMD ["task", "--list"]
