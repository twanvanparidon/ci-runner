# ci

Run the same CI steps in the pipeline and on your laptop. Full example: [`examples/docker-app`](../examples/docker-app).

## 1. In CI

Use a ci-runner image and call `ci <task>`:

- `ci ci:<scope>:<task>` runs a built-in task shipped in the image (`ci:` is reserved for these).
- `ci <task>` runs a task from your own `Taskfile.yml`, so you can add any step.

```yaml
lint:
  image: ghcr.io/twanvanparidon/ci-runner/docker:<version>
  script: [ci lint]                # your task
```

```yaml
# Taskfile.yml
version: "3"
tasks:
  lint:
    cmds: [ci ci:docker:lint]      # built-in task, plus anything you add
```

`ci` lists what is available; tasks run in the current directory and take `VAR=value` arguments.

## 2. Locally

Copy [`taskfiles/lcir.yml`](../taskfiles/lcir.yml) (local ci runner) to `.taskfiles/lcir.yml` and include it with the pipeline's image:

```yaml
includes:
  lcir:
    taskfile: .taskfiles/lcir.yml
    optional: true # host only; the container does not need it
    vars: { IMAGE: ghcr.io/twanvanparidon/ci-runner/docker:<version> }
```

```sh
task lcir                        # list the steps
task lcir:lint                   # run a step in that image
task lcir:ci:docker:lint -- DOCKERFILES=Dockerfile
```

It mounts the project at the same path, runs as your user and passes the Docker socket. Needs Docker and Task.

## 3. Advanced: mirror the whole pipeline

`lcir:run` runs any step in any image, so a pipeline with several jobs can be mirrored in Task, see [`pipeline.yml`](../examples/docker-app/.taskfiles/pipeline.yml):

```yaml
lint:
  cmds:
    - task: :lcir:run
      vars: { IMAGE: ghcr.io/twanvanparidon/ci-runner/docker:<version>, STEP: lint }
```

Include it as `pipeline` and run `task pipeline` (or `task pipeline:<job>`). Tasks under `lcir:` and `pipeline:` start containers, so `ci` hides them inside the image.

## Shipping tasks in a scope

Add `src/<scope>/tasks.yml` and copy it in the final stage of the scope's Dockerfile:

```dockerfile
COPY tasks.yml /usr/local/share/ci-runner/<scope>.yml
```
