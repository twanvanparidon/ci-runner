#!/bin/sh
# One entry point for CI steps, the same in the pipeline and locally.
# Usage: ci [--list]               list project and image tasks
#        ci <task> [VAR=value...]  run a task:
#          ci:<scope>:<name> runs the image's task (ci: is reserved for images),
#          anything else runs the project's own Taskfile.
# Scopes install their Taskfile as /usr/local/share/ci-runner/<scope>.yml.
# Tasks always run in the current directory.
set -eu

share="${CI_RUNNER_TASKS:-/usr/local/share/ci-runner}"
cmd="${CI_RUNNER_PREFIX:-ci }" # how listings show a task; lcir sets "task lcir:"

project_taskfile() {
  for f in Taskfile.yml taskfile.yml Taskfile.yaml taskfile.yaml \
    Taskfile.dist.yml taskfile.dist.yml Taskfile.dist.yaml taskfile.dist.yaml; do
    [ -f "$f" ] && return 0
  done
  return 1
}

# tasks <prefix> [task flags]: print "ci <prefix><name>  <desc>" per task.
# lcir: and pipeline: tasks are host-only (they start containers), so they are not listed.
tasks() {
  prefix="$1"
  shift
  task "$@" --list --json | jq -r --arg c "$cmd" --arg p "$prefix" \
    '.tasks[] | select(.name | test("^(lcir|pipeline):") | not) | "  \($c)\($p)\(.name)\t\(.desc)"'
}

list() {
  echo "usage: $cmd<task> [VAR=value...]"
  seen="$(mktemp)"
  if project_taskfile; then
    echo "project:"
    tasks '' | tee "$seen"
  fi
  # Image tasks the project already includes are listed once, under project.
  for file in "$share"/*.yml; do
    [ -e "$file" ] || continue
    scope="$(basename "$file" .yml)"
    lines="$(tasks "ci:$scope:" -t "$file" -d "$PWD")"
    # busybox grep -v drops everything with an empty pattern file, so only filter when needed.
    if [ -s "$seen" ]; then lines="$(printf '%s\n' "$lines" | grep -vxF -f "$seen" || true)"; fi
    if [ -n "$lines" ]; then printf 'image (%s):\n%s\n' "$scope" "$lines"; fi
  done
  if [ ! -s "$seen" ] && ! ls "$share"/*.yml > /dev/null 2>&1; then
    echo "no tasks found: no project Taskfile here and no image tasks in $share"
  fi
  rm -f "$seen"
}

case "${1:---list}" in
  --list | -l | --help | -h)
    list
    exit 0
    ;;
esac

case "$1" in
  ci:*:*)
    rest="${1#ci:}"
    scope="${rest%%:*}"
    name="${rest#*:}"
    shift
    if [ ! -f "$share/$scope.yml" ]; then
      echo "no image tasks for scope '$scope' here; run it in the $scope image" >&2
      list >&2
      exit 2
    fi
    # -d: run in the caller's directory, so paths and outputs land in the project.
    exec task -t "$share/$scope.yml" -d "$PWD" "$name" "$@"
    ;;
esac
if project_taskfile; then
  exec task "$@"
fi
echo "no project Taskfile here for: $1" >&2
list >&2
exit 2
