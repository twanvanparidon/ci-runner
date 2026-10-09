# Builders

The `docker` image has the docker CLI and buildx but no daemon. Point buildx at a builder:

| Builder | Risk | Use when |
|---|---|---|
| Remote BuildKit over mTLS | job can only build | own runners; recommended |
| dind service | privileged service container | GitLab, quick start |
| Host socket | job is root on the host | throwaway hosted runners only |

## Remote BuildKit

Run `buildkitd` on a dedicated, hardened VM with mTLS on `tcp://<host>:1234`. Its cache persists between jobs.

```sh
docker buildx create --name remote --driver remote \
  --driver-opt cacert=ca.pem,cert=cert.pem,key=key.pem \
  tcp://<host>:1234 --use
docker buildx build --push -t <image> .
```

Expose BuildKit, not `dockerd`: a Docker daemon over TCP lets any client run privileged containers on the VM.
