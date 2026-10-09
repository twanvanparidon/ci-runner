# Adding a scope

A scope is an image in `images/<name>/`, plus its steps in `pipelines/<name>/`.

1. `cp -r images/_example images/<name>`
2. Add `images/<name>/Dockerfile` (copy `images/k8s/Dockerfile`): pin `ARG BUILDER_VERSION` and `ARG GENERAL_VERSION`, set `ARG VERSION=1.0.0`.
3. List the tools in `images/<name>/aqua.yaml` and run `task images:lock`; `aqua_bootstrap` copies every tool, or only the commands you name.
4. CI-only scripts (logins, GitOps pushes, provider plumbing) go in `images/<name>/scripts/*.sh` and land on `PATH` without `.sh`. Pipeline steps do not: they go in `pipelines/<name>/<name>.yml`, see [Pipelines](pipelines.md).
5. Add the Dockerfile to `IMAGES` in `Taskfile.yml`, after its base. It is published as `<name>`.
6. Put CI examples in `pipelines/<name>/<provider>/`.
7. Fill in `images/<name>/README.md`.

The build context is `images/<name>/`, allowlisted by its `.dockerignore` (aqua lock and scripts only).
The version check watches the Dockerfile, aqua files, `scripts/` and `.dockerignore`; README changes need no bump.
