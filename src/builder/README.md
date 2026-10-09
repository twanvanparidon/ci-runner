# builder

Builder image used as the fetch stage of every other image. Not a runner.

## Images

| Image | Adds |
|---|---|
| `builder` | aqua, `aqua_bootstrap` (installs `./aqua.yaml`, copies the binaries to `/out`) |
