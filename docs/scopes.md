# Adding a scope

1. `cp -r src/_scope src/<name>`
2. Add `src/<name>/images/Dockerfile` (copy `src/k8s/images/Dockerfile`): pin `ARG BUILDER_VERSION` and `ARG GENERAL_VERSION`, set `ARG VERSION=1.0.0`.
3. List the tools in `src/<name>/images/aqua.yaml` and run `task images:lock`; `aqua_bootstrap` copies every tool, or only the commands you name.
4. Put shared CI scripts in `src/<name>/scripts/*.sh`; they land on `PATH` without `.sh`. Tasks go in `src/<name>/tasks.yml`, see [ci](ci.md).
5. Add the Dockerfile to `IMAGES` in `Taskfile.yml`, after its base. It is published as `<name>`.
6. Put pipeline examples in `src/<name>/ci/<provider>/`.
7. Fill in `src/<name>/README.md`.

The build context is `src/<name>/`, allowlisted by its `.dockerignore` (aqua lock and scripts only).
The version check watches `images/` and `scripts/`, so images in one scope bump together.
