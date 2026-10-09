# Pipelines

Images ship tools and CI-only scripts (`ci_env`, `gitops_set_image`). Pipeline steps are plain Taskfiles in [`pipelines/`](../pipelines) that you copy into a project. Full example: [`examples/docker-app`](../examples/docker-app).

## 1. In CI

Copy the steps you need to `.taskfiles/` and include them; add your own tasks next to them:

```yaml
# Taskfile.yml
version: "3"
includes:
  docker: .taskfiles/docker.yml    # copy of pipelines/docker/docker.yml
tasks:
  smoke:
    cmds: [docker run --rm myapp:dev]
```

Run the tasks in a ci-runner image:

```yaml
lint:
  image: ghcr.io/twanvanparidon/ci-runner/docker:<version>
  script: [task docker:lint]
```

Ready-made pipelines: [`pipelines/k8s/github`](../pipelines/k8s/github), [`pipelines/k8s/gitlab`](../pipelines/k8s/gitlab).

## 2. Locally

Copy [`pipelines/lcir.yml`](../pipelines/lcir.yml) (local ci runner) to `.taskfiles/lcir.yml` and include it with the pipeline's image:

```yaml
includes:
  lcir:
    taskfile: .taskfiles/lcir.yml
    optional: true # host only; the container does not need it
    vars: { IMAGE: ghcr.io/twanvanparidon/ci-runner/docker:<version> }
```

```sh
task lcir:docker:lint                         # a task, in the CI image
task lcir:docker:lint -- DOCKERFILES=Dockerfile
```

It mounts the git repository root at the same path, runs from the current directory as your user and passes the Docker socket. Needs Docker and Task.

## 3. Advanced: mirror the whole pipeline

`lcir:run` runs any task in any image, so a pipeline with several jobs and images can be mirrored, see [`pipeline.yml`](../examples/docker-app/.taskfiles/pipeline.yml):

```yaml
lint:
  cmds:
    - task: :lcir:run
      vars: { IMAGE: ghcr.io/twanvanparidon/ci-runner/docker:<version>, STEP: docker:lint }
```

Include it as `pipeline` and run `task pipeline` or `task pipeline:<job>`.

Variables in included Taskfiles are shared, so keep them per task or give them unique names.
