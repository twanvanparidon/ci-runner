#!/bin/sh
# Build every kustomization under a directory to check that it renders.
# Usage: kustomize_build_all [dir]  (default: .)
# Components (kind: Component) are skipped; they only build inside an overlay.
# Set OUT=<dir> to also write each rendered overlay to OUT/<path>.yaml,
# e.g. for `kube-linter lint "$OUT"`.
set -eu

root="${1:-.}"
count=0
failed=0
list="$(mktemp)"
trap 'rm -f "$list"' EXIT

find "$root" -type f \( -name kustomization.yaml -o -name kustomization.yml -o -name Kustomization \) \
  -not -path '*/.git/*' | sort > "$list"

while IFS= read -r file; do
  grep -q '^kind: Component' "$file" && continue
  dir="$(dirname "$file")"
  count=$((count + 1))
  target=/dev/null
  if [ -n "${OUT:-}" ]; then
    rel="${dir#./}"
    target="$OUT/${rel#/}.yaml"
    mkdir -p "$(dirname "$target")"
  fi
  if kustomize build "$dir" > "$target"; then
    echo "ok    $dir"
  else
    echo "FAIL  $dir" >&2
    failed=$((failed + 1))
  fi
done < "$list"

if [ "$count" -eq 0 ]; then
  echo "no kustomizations found under $root" >&2
  exit 1
fi
echo "$count built, $failed failed"
[ "$failed" -eq 0 ]
