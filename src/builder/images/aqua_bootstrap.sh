#!/bin/sh
# Install the tools locked in ./aqua.yaml and copy their real binaries
# (not the aqua-proxy links) to $1, default /out.
set -eu

out="${1:-/out}"
aqua install
mkdir -p "$out"
for link in "$AQUA_ROOT_DIR"/bin/*; do
  [ -e "$link" ] || continue
  cmd="$(basename "$link")"
  cp "$(aqua which "$cmd")" "$out/$cmd"
done
