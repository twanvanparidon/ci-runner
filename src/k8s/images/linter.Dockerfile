# k8s linting: general runner + kustomize + kube-linter.

ARG REGISTRY=ci-runner
ARG BUILDER_VERSION=1.0.0
ARG GENERAL_VERSION=1.0.2

FROM ${REGISTRY}/builder:${BUILDER_VERSION} AS fetch
COPY aqua.yaml aqua-checksums.json /work/
RUN aqua_bootstrap

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.0.2
LABEL org.opencontainers.image.version=${VERSION}
COPY --from=fetch /out/ /usr/local/bin/
