# Project Integration Guide

This repository is a reusable review pack.
Actual PR command automation must be installed in each target project.

## A) Local project review (manual trigger)

Run inside the target project:

```bash
react-review-codex
# or
react-review-claude
```

Default base ref is current branch upstream. You can override:

```bash
react-review-codex origin/main
```

## B) GitHub PR command review (`/react-review`)

Install workflow into target project:

```bash
bash scripts/install-into-project.sh /path/to/target-project
```

Then in the target repository settings:

1. Add secret `OPENAI_API_KEY`
2. Optional variable `OPENAI_MODEL` (default `gpt-5-mini`)
3. Optional variable `REACT_REVIEW_REQUIRE_BOT_PR=true` to only review bot-authored PRs

Commit and push workflow in target project.
After that, write `/react-review` in a PR comment.
