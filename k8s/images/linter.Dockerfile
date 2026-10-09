# k8s linting: general runner + kustomize + kube-linter.

ARG REGISTRY=ci-runner
ARG GENERAL_VERSION=1.0.1
ARG ALPINE=alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

FROM ${ALPINE} AS fetch
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG TARGETARCH
ARG KUSTOMIZE_VERSION=5.8.3
ARG KUSTOMIZE_SHA256_amd64=cb9e31198d3f63b44848bd0afc4c8efc56e6cfef9c93a4a39a211940e6decd61
ARG KUSTOMIZE_SHA256_arm64=9867b76482cfc6d25b546abc1d2b5a32bd137505aba640649b4b378f64f6d68f
ARG KUBE_LINTER_VERSION=0.8.3
ARG KUBE_LINTER_ASSET_amd64=kube-linter-linux
ARG KUBE_LINTER_ASSET_arm64=kube-linter-linux_arm64
ARG KUBE_LINTER_SHA256_amd64=1a6d8419b11971372971fdbc22682b684ebfb7cf1c39591662d1b6ca736c41df
ARG KUBE_LINTER_SHA256_arm64=802e1b09eabd08f6f0a060a6b8ab2bf7bc7e6bf4f673bb2692303704c84b3e22
# sha and asset are assigned via eval
# hadolint ignore=SC2154
RUN apk add --no-cache curl \
 && eval "sha=\$KUSTOMIZE_SHA256_${TARGETARCH}" \
 && curl -fsSLo /tmp/kustomize.tgz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${TARGETARCH}.tar.gz" \
 && echo "${sha}  /tmp/kustomize.tgz" | sha256sum -c - \
 && tar -xzf /tmp/kustomize.tgz -C /usr/local/bin kustomize \
 && eval "asset=\$KUBE_LINTER_ASSET_${TARGETARCH} sha=\$KUBE_LINTER_SHA256_${TARGETARCH}" \
 && curl -fsSLo /tmp/kube-linter.tgz "https://github.com/stackrox/kube-linter/releases/download/v${KUBE_LINTER_VERSION}/${asset}.tar.gz" \
 && echo "${sha}  /tmp/kube-linter.tgz" | sha256sum -c - \
 && tar -xzf /tmp/kube-linter.tgz -C /usr/local/bin kube-linter

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.0.1
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /usr/local/bin/kustomize /usr/local/bin/kube-linter /usr/local/bin/
