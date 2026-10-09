# Adding a scope

1. `cp -r images/_scope images/<name>`
2. Add `images/<name>/Dockerfile` (copy `images/k8s/Dockerfile`): pin `ARG BUILDER_VERSION` and `ARG GENERAL_VERSION`, set `ARG VERSION=1.0.0`.
3. List the tools in `images/<name>/aqua.yaml` and run `task images:lock`; `aqua_bootstrap` copies every tool, or only the commands you name.
4. Put shared CI scripts in `images/<name>/scripts/*.sh`; they land on `PATH` without `.sh`. Tasks go in `images/<name>/tasks.yml`, see [ci](ci.md).
5. Add the Dockerfile to `IMAGES` in `Taskfile.yml`, after its base. It is published as `<name>`.
6. Put pipeline examples in `images/<name>/ci/<provider>/`.
7. Fill in `images/<name>/README.md`.

The build context is `images/<name>/`, allowlisted by its `.dockerignore` (aqua lock and scripts only).
The version check watches `images/` and `scripts/`, so images in one scope bump together.
