# Ansible tooling: general runner + python, ansible-core, ansible-lint.
# Python packages are no aqua tools: requirements.txt pins them with hashes instead.

ARG REGISTRY=ci-runner
ARG GENERAL_VERSION=1.4.1

FROM ${REGISTRY}/general:${GENERAL_VERSION}
ARG VERSION=1.0.1
LABEL org.opencontainers.image.version=${VERSION}
USER 0:0
COPY requirements.txt /tmp/
# --only-binary: no compilers in the image, every package must ship a wheel.
RUN apk add --no-cache python3 \
 && python3 -m venv /opt/ansible \
 && /opt/ansible/bin/pip install --no-cache-dir --require-hashes --only-binary=:all: -r /tmp/requirements.txt \
 && find / -xdev -perm /6000 -type f -exec chmod a-s {} + \
 && rm -rf /var/cache/apk/* /tmp/*
ENV PATH=/opt/ansible/bin:$PATH
USER 10001:10001
