# Pipelines

Images ship tools and CI-only scripts (`ci_env`, `gitops_set_image`). Pipeline steps are plain Taskfiles in [`pipelines/`](../pipelines), one folder per purpose:

| Pipeline | Image | Run |
|---|---|---|
| [`docker/lint`](../pipelines/docker/lint) | docker | `task docker:lint` |
| [`docker/build`](../pipelines/docker/build) | docker | `task docker:build IMAGE=<name:tag>` |
| [`k8s/lint`](../pipelines/k8s/lint) | k8s | `task k8s:lint` (or `:render`, `:schema`, `:kube-linter`) |
| [`k8s/gitops`](../pipelines/k8s/gitops) | k8s | `task k8s:gitops DIR=… OVERLAY=… IMAGES=…` |

Each folder has a `Taskfile.yml` plus `github.yml` and `gitlab-ci.yml` examples.

## Using a pipeline

Copy the `Taskfile.yml` to `.taskfiles/<scope>/<purpose>/Taskfile.yml` and include it under the same path as namespace; add your own tasks next to it:

```yaml
# Taskfile.yml
version: "3"
includes:
  docker:lint: .taskfiles/docker/lint
  k8s:lint: .taskfiles/k8s/lint
tasks:
  smoke:
    cmds: [docker run --rm myapp:dev]
```

Then copy the matching CI example. Every step is `task <name>` in a ci-runner image.

## Locally

Run the same tasks with the tools installed, or in the CI image:

```sh
docker run --rm -v "$PWD:$PWD" -w "$PWD" --user "$(id -u):$(id -g)" \
  ghcr.io/twanvanparidon/ci-runner/k8s:<version> task k8s:lint
```

## Conventions

- `.taskfiles/<path>/Taskfile.yml`, included as `<path>` with `:` between folders.
- Each pipeline's main step is its `default` task, so `task <path>` runs it.
- Variables live per task: included Taskfiles share file-level variables, so they would collide.
