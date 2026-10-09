# Adding a scope

1. `cp -r src/_scope src/<name>`
2. Add `src/<name>/images/<image>.Dockerfile` (copy `src/k8s/images/linter.Dockerfile`): pin `ARG BUILDER_VERSION` and `ARG GENERAL_VERSION`, set `ARG VERSION=1.0.0`.
3. List the tools in `src/<name>/images/aqua.yaml` and run `task images:lock`; `aqua_bootstrap` copies every listed tool into the image.
4. Add the Dockerfile to `IMAGES` in `Taskfile.yml`, after its base. It is published as `<name>-<image>`.
5. Put pipeline examples in `src/<name>/ci/<provider>/`.
6. Fill in `src/<name>/README.md`.

The version check watches the whole `src/<name>/images/` directory, so images in one scope bump together.
