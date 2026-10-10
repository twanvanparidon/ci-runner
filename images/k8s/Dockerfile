# k8s tooling: general runner + kustomize + kube-linter + kubeconform + yq.

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.2.1
ARG GENERAL_VERSION=1.4.0

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
# scripts* is optional: a scope without scripts still builds.
COPY aqua.yaml aqua-checksums.json scripts* /work/
RUN aqua_bootstrap

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.4.1
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /out/ /usr/local/bin/
