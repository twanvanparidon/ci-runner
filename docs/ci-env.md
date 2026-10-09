# CI env

`ci_env` (in every image) maps each provider's variables to one set, so scripts work on any CI.

```sh
eval "$(ci_env)"
echo "$CI_BRANCH $CI_SHORT_SHA"
```

Every name is always exported, empty when unknown, so `set -u` is safe.

| Variable | Meaning | GitHub Actions | GitLab CI |
|---|---|---|---|
| `CI_PROVIDER` | `github`, `gitlab` or `local` | `GITHUB_ACTIONS=true` | `GITLAB_CI=true` |
| `CI_EVENT` | `push`, `pr`, `schedule`, `manual` or `other` | `GITHUB_EVENT_NAME` | `CI_PIPELINE_SOURCE` |
| `CI_SHA` | Commit being built | `GITHUB_SHA` ¹ | `CI_COMMIT_SHA` |
| `CI_SHORT_SHA` | First 8 characters of `CI_SHA` | from `GITHUB_SHA` | `CI_COMMIT_SHORT_SHA` |
| `CI_BRANCH` | Branch; source branch on PRs; empty on tags | `GITHUB_REF_NAME`, `GITHUB_HEAD_REF` on PRs ² | `CI_COMMIT_BRANCH`, `CI_MERGE_REQUEST_SOURCE_BRANCH_NAME` on MRs |
| `CI_TAG` | Tag; empty otherwise | `GITHUB_REF_NAME` when `GITHUB_REF_TYPE=tag` | `CI_COMMIT_TAG` |
| `CI_DEFAULT_BRANCH` | Default branch | event payload `repository.default_branch` | `CI_DEFAULT_BRANCH` (kept) |
| `CI_PR` | PR / MR number | event payload `pull_request.number`, else `GITHUB_REF` | `CI_MERGE_REQUEST_IID` |
| `CI_PR_TARGET` | PR / MR target branch | `GITHUB_BASE_REF` | `CI_MERGE_REQUEST_TARGET_BRANCH_NAME` |
| `CI_REPO` | `owner/name` | `GITHUB_REPOSITORY` | `CI_PROJECT_PATH` |
| `CI_REPO_URL` | Repository URL | `GITHUB_SERVER_URL/GITHUB_REPOSITORY` | `CI_PROJECT_URL` |
| `CI_RUN_URL` | Link to this run | `…/actions/runs/GITHUB_RUN_ID` | `CI_PIPELINE_URL` |
| `CI_ACTOR` | Who started it | `GITHUB_ACTOR` | `GITLAB_USER_LOGIN` |
| `CI_WORKSPACE` | Checkout directory | `GITHUB_WORKSPACE` | `CI_PROJECT_DIR` |
| `CI_REGISTRY` | Container registry host | `ghcr.io` | `CI_REGISTRY` (kept) |
| `CI_REGISTRY_IMAGE` | Image base for this repo | `ghcr.io/<repo, lowercase>` | `CI_REGISTRY_IMAGE` (kept) |

(kept): GitLab already defines it; `ci_env` re-exports GitLab's own value.

| `CI_EVENT` | GitHub `GITHUB_EVENT_NAME` | GitLab `CI_PIPELINE_SOURCE` |
|---|---|---|
| `push` | `push` (branches and tags) | `push` (branches and tags) |
| `pr` | `pull_request`, `pull_request_target` | `merge_request_event`, `external_pull_request_event` |
| `schedule` | `schedule` | `schedule` |
| `manual` | `workflow_dispatch` | `web` |
| `other` | anything else | anything else (`api`, `trigger`, `pipeline`, ...) |

1. On `pull_request`, `GITHUB_SHA` is GitHub's temporary merge commit, not the PR head. GitLab MR pipelines build the source branch commit.
2. On PRs `GITHUB_REF_NAME` is `<number>/merge`, so the branch comes from `GITHUB_HEAD_REF`.

Locally (`CI_PROVIDER=local`) SHA, branch and tag come from git when available; `CI_WORKSPACE` falls back to the current directory.

Sources, checked 2026-10-09:
[GitHub variables](https://docs.github.com/en/actions/reference/workflows-and-actions/variables),
[GitHub events](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows),
[GitLab predefined variables](https://docs.gitlab.com/ci/variables/predefined_variables/),
[GitLab pipeline sources](https://docs.gitlab.com/ci/jobs/job_rules/).
