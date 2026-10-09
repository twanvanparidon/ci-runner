# docker-app

A minimal project using ci-runner: built-in lint and build steps, one project step (`smoke`) and a local mirror.

| File | Role |
|---|---|
| `Taskfile.yml` | Project steps that are not built in: `smoke` runs the built image and checks its output |
| `.github/workflows/ci.yml` | The pipeline: `ci ci:docker:lint`, `ci ci:docker:build`, `ci smoke` in the ci-runner docker image |
| `.taskfiles/lcir.yml` | Symlink to [`taskfiles/lcir.yml`](../../taskfiles/lcir.yml); in your project, copy the file instead |
| `.taskfiles/pipeline.yml` | Optional local mirror of the whole workflow |

```sh
task lcir                       # list steps
task lcir:ci:docker:lint        # a built-in step
task lcir:smoke                 # the project step
task pipeline                   # the whole pipeline, like CI
```

Not yet run on GitHub: the container job options (`--user 1001`, Docker socket for `build`) may need adjusting.
