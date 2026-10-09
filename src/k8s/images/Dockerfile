# k8s tooling: general runner + kustomize + kube-linter + kubeconform + yq + git.

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.2.0
ARG GENERAL_VERSION=1.1.0

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
# scripts* is optional: a scope without scripts still builds.
COPY images/aqua.yaml images/aqua-checksums.json scripts* /work/
RUN aqua_bootstrap

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.2.0
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /out/ /usr/local/bin/

# git for gitops_set_image; no static release exists, so it comes from apk.
USER 0
RUN apk add --no-cache git \
 && rm -rf /var/cache/apk/*
USER 10001:10001
