# Builder image: verified aqua + aqua_bootstrap. Room for more build tooling. Used as the fetch stage of
# every other image; never shipped as a runner.

ARG ALPINE=alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

FROM ${ALPINE}
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG TARGETARCH
ARG AQUA_VERSION=2.64.0
ARG AQUA_CHECKSUMS_SHA256=651d4378614e8506c5814d3bed0c5643eea74b957e491601427ad8ebf241fa02
ARG VERSION=1.2.1
LABEL org.opencontainers.image.version=${VERSION}
ENV AQUA_ROOT_DIR=/opt/aqua
WORKDIR /tmp/aqua
RUN apk upgrade --no-cache \
 && url="https://github.com/aquaproj/aqua/releases/download/v${AQUA_VERSION}" \
 && wget -q "${url}/aqua_${AQUA_VERSION}_checksums.txt" \
 && wget -q "${url}/aqua_linux_${TARGETARCH}.tar.gz" \
 && echo "${AQUA_CHECKSUMS_SHA256}  aqua_${AQUA_VERSION}_checksums.txt" | sha256sum -c - \
 && grep " aqua_linux_${TARGETARCH}.tar.gz$" "aqua_${AQUA_VERSION}_checksums.txt" | sha256sum -c - \
 && tar -xzf "aqua_linux_${TARGETARCH}.tar.gz" --no-same-owner -C /usr/local/bin aqua \
 && rm -rf /tmp/aqua /var/cache/apk/*
COPY scripts/aqua_bootstrap.sh /usr/local/bin/aqua_bootstrap
WORKDIR /work
