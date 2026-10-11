# ansible

Ansible tooling. Python packages are no aqua tools, so this image adds Python from Alpine and installs them in a venv from a hash-locked `requirements.txt`.

## Images

| Image | Adds |
|---|---|
| `ansible` | python, ansible-core, ansible-lint |

## Requirements

Pin the top-level packages in `requirements.in`, then run `task images:lock` to write `requirements.txt` with every dependency and its hashes. The build installs wheels only (`--only-binary`), so the image needs no compiler.

## Pipelines

- [`pipelines/ansible/lint`](../../pipelines/ansible/lint): ansible-lint
