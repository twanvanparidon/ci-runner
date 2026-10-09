# docker-app

A minimal project using ci-runner: shared docker steps, one project step (`smoke`) and a local mirror of the pipeline.

| File | Role |
|---|---|
| `Taskfile.yml` | Includes the shared steps and adds `smoke`: run the built image and check its output |
| `.taskfiles/docker.yml` | Shared steps `docker:lint` and `docker:build`, from [`pipelines/docker`](../../pipelines/docker) |
| `.github/workflows/ci.yml` | The pipeline: `task docker:lint`, `task docker:build`, `task smoke` in the ci-runner docker image |
| `.taskfiles/lcir.yml` | Run tasks locally in the same image, from [`pipelines/lcir.yml`](../../pipelines/lcir.yml) |
| `.taskfiles/pipeline.yml` | Optional local mirror of the whole workflow |

The `.taskfiles` here are symlinks into `pipelines/`; in your project, copy the files instead.

```sh
task lcir                 # list tasks, as the image sees them
task lcir:docker:lint     # one step in the CI image
task lcir:smoke           # the project step
task pipeline             # the whole pipeline, like CI
```

Not yet run on GitHub: the container job options (`--user 1001`, Docker socket for `build`) may need adjusting.
