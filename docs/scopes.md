# Adding a scope

1. `cp -r _scope <name>`
2. Add `<name>/images/<image>.Dockerfile` (see `k8s/images/linter.Dockerfile`): pin the base with `ARG GENERAL_VERSION` and set `ARG VERSION=1.0.0` in the final stage.
3. Add the Dockerfile to `IMAGES` in `Taskfile.yml`, after its base. It is published as `<name>-<image>`.
4. Put pipeline examples in `<name>/ci/<provider>/`.
5. Fill in `<name>/README.md`.

Dockerfiles must be self-contained: the version check only watches the Dockerfile itself.
