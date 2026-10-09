#!/bin/sh
# Install the tools locked in ./aqua.yaml and copy their real binaries
# (not the aqua-proxy links) to $OUT, default /out.
# Pass command names to copy only those; default is every command.
# Scripts in ./*.sh are installed to $OUT without the .sh suffix.
set -eu

out="${OUT:-/out}"
aqua install
mkdir -p "$out"
if [ "$#" -eq 0 ]; then
  for link in "$AQUA_ROOT_DIR"/bin/*; do
    [ -e "$link" ] || continue
    set -- "$@" "$(basename "$link")"
  done
fi
for cmd in "$@"; do
  cp "$(aqua which "$cmd")" "$out/$cmd"
done
for script in ./*.sh; do
  [ -e "$script" ] || continue
  install -m 755 "$script" "$out/$(basename "$script" .sh)"
done
