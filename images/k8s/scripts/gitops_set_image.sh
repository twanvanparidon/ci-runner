#!/bin/sh
# Set image(s) in a kustomize overlay of a checked out GitOps repo, then commit and push.
# Usage: gitops_set_image <overlay-dir> <image>...
#   image: name=newName:tag, name:tag or name@sha256:digest (kustomize edit set image)
# Run from the GitOps repo root; the pipeline handles clone and credentials.
# Env: BRANCH (default: current branch), PUSH=false to skip pushing,
#      GIT_AUTHOR_NAME / GIT_AUTHOR_EMAIL (default: ci-runner).
set -eu

if [ "$#" -lt 2 ]; then
  echo "usage: gitops_set_image <overlay-dir> <image>..." >&2
  exit 2
fi
overlay="$1"
shift

branch="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
if [ "$branch" = HEAD ]; then
  echo "detached HEAD: set BRANCH to push to" >&2
  exit 2
fi
export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-ci-runner}"
export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-ci-runner@localhost}"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

(cd "$overlay" && kustomize edit set image "$@")
kustomize build "$overlay" > /dev/null

if git diff --quiet -- "$overlay"; then
  echo "no change in $overlay"
  exit 0
fi
git add -- "$overlay"
git commit -q -m "chore($overlay): set image $*"
echo "committed: set image $* in $overlay"

[ "${PUSH:-true}" = false ] && exit 0
# Other pipelines may push in between: rebase and retry.
for attempt in 1 2 3; do
  if git push -q origin "HEAD:$branch"; then
    echo "pushed to $branch"
    exit 0
  fi
  echo "push failed (attempt $attempt), rebasing" >&2
  git pull -q --rebase origin "$branch"
done
echo "push failed after 3 attempts" >&2
exit 1
