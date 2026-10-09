#!/bin/sh
# Print provider agnostic CI variables as export lines.
# Usage: eval "$(ci_env)"   (run without eval to just see the values)
# Mapping and caveats: docs/ci-env.md. Variables GitLab already defines
# (CI_DEFAULT_BRANCH, CI_REGISTRY, CI_REGISTRY_IMAGE) keep their own value there.
# Every provider exports the same names, empty when unknown, so `set -u` is safe.
set -eu

emit() {
  printf "export %s='%s'\n" "$1" "$(printf '%s' "$2" | sed "s/'/'\\\\''/g")"
}

# Read a field from the GitHub event payload, empty if unavailable.
event() {
  if [ -n "${GITHUB_EVENT_PATH:-}" ] && [ -f "$GITHUB_EVENT_PATH" ] && command -v jq > /dev/null; then
    jq -r "$1 // empty" "$GITHUB_EVENT_PATH"
  fi
}

if [ "${GITHUB_ACTIONS:-}" = true ]; then
  provider=github
  sha="$GITHUB_SHA"
  branch='' tag='' pr='' target=''
  case "$GITHUB_EVENT_NAME" in
    pull_request | pull_request_target)
      branch="$GITHUB_HEAD_REF"
      target="$GITHUB_BASE_REF"
      pr="$(event .pull_request.number)"
      [ -n "$pr" ] || pr="$(printf '%s' "$GITHUB_REF" | sed -n 's|^refs/pull/\([0-9]*\)/merge$|\1|p')"
      ;;
    *)
      if [ "${GITHUB_REF_TYPE:-}" = tag ]; then tag="$GITHUB_REF_NAME"; else branch="$GITHUB_REF_NAME"; fi
      ;;
  esac
  case "$GITHUB_EVENT_NAME" in
    push) evt='push' ;;
    pull_request | pull_request_target) evt='pr' ;;
    schedule) evt='schedule' ;;
    workflow_dispatch) evt='manual' ;;
    *) evt='other' ;;
  esac
  repo_url="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY"
  emit CI_PROVIDER "$provider"
  emit CI_EVENT "$evt"
  emit CI_SHA "$sha"
  emit CI_SHORT_SHA "$(printf '%.8s' "$sha")"
  emit CI_BRANCH "$branch"
  emit CI_TAG "$tag"
  emit CI_DEFAULT_BRANCH "$(event .repository.default_branch)"
  emit CI_PR "$pr"
  emit CI_PR_TARGET "$target"
  emit CI_REPO "$GITHUB_REPOSITORY"
  emit CI_REPO_URL "$repo_url"
  emit CI_RUN_URL "$repo_url/actions/runs/$GITHUB_RUN_ID"
  emit CI_ACTOR "$GITHUB_ACTOR"
  emit CI_WORKSPACE "$GITHUB_WORKSPACE"
  emit CI_REGISTRY ghcr.io
  emit CI_REGISTRY_IMAGE "ghcr.io/$(printf '%s' "$GITHUB_REPOSITORY" | tr '[:upper:]' '[:lower:]')"

elif [ "${GITLAB_CI:-}" = true ]; then
  case "$CI_PIPELINE_SOURCE" in
    push) evt='push' ;;
    merge_request_event | external_pull_request_event) evt='pr' ;;
    schedule) evt='schedule' ;;
    web) evt='manual' ;;
    *) evt='other' ;;
  esac
  emit CI_PROVIDER gitlab
  emit CI_EVENT "$evt"
  emit CI_SHA "$CI_COMMIT_SHA"
  emit CI_SHORT_SHA "$CI_COMMIT_SHORT_SHA"
  emit CI_BRANCH "${CI_COMMIT_BRANCH:-${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-}}"
  emit CI_TAG "${CI_COMMIT_TAG:-}"
  emit CI_DEFAULT_BRANCH "${CI_DEFAULT_BRANCH:-}"
  emit CI_PR "${CI_MERGE_REQUEST_IID:-}"
  emit CI_PR_TARGET "${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-}"
  emit CI_REPO "$CI_PROJECT_PATH"
  emit CI_REPO_URL "$CI_PROJECT_URL"
  emit CI_RUN_URL "$CI_PIPELINE_URL"
  emit CI_ACTOR "${GITLAB_USER_LOGIN:-}"
  emit CI_WORKSPACE "$CI_PROJECT_DIR"
  emit CI_REGISTRY "${CI_REGISTRY:-}"
  emit CI_REGISTRY_IMAGE "${CI_REGISTRY_IMAGE:-}"

else
  # Local: best effort from git, empty where git is missing.
  git_() { command -v git > /dev/null && git "$@" 2> /dev/null || true; }
  sha="$(git_ rev-parse HEAD)"
  emit CI_PROVIDER local
  emit CI_EVENT other
  emit CI_SHA "$sha"
  emit CI_SHORT_SHA "$(printf '%.8s' "$sha")"
  emit CI_BRANCH "$(git_ branch --show-current)"
  emit CI_TAG "$(git_ describe --tags --exact-match)"
  emit CI_DEFAULT_BRANCH ''
  emit CI_PR ''
  emit CI_PR_TARGET ''
  emit CI_REPO ''
  emit CI_REPO_URL ''
  emit CI_RUN_URL ''
  emit CI_ACTOR "${USER:-}"
  ws="$(git_ rev-parse --show-toplevel)"
  emit CI_WORKSPACE "${ws:-$PWD}"
  emit CI_REGISTRY ''
  emit CI_REGISTRY_IMAGE ''
fi
