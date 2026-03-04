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

Install Opus-default workflow:

```bash
bash scripts/install-into-project.sh /path/to/target-project https://github.com/dioKR/react-review-skills.git opus
```

Then in the target repository settings:

1. OpenAI workflow: add secret `OPENAI_API_KEY` and optional variable `OPENAI_MODEL`
2. Opus workflow: add secret `ANTHROPIC_API_KEY` and optional variable `ANTHROPIC_MODEL` (default `claude-opus-4-1-20250805`)
3. Optional variable `REACT_REVIEW_REQUIRE_BOT_PR=true` to only review bot-authored PRs

Commit and push workflow in target project.
After that, write `/react-review` in a PR comment.
