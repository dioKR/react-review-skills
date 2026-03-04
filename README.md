# react-review-skills

Single-skill repository for reviewing React/Next.js PRs with consistent quality gates.

## Primary Files

- `SKILL.md`
- `agents/openai.yaml`
- `references/vercel-react-rules.md`
- `references/toss-code-quality.md`
- `references/a11y-pr-checklist.md`
- `references/lint-tooling-map.md`
- `assets/templates/pr-review-comment.md`
- `assets/templates/pr-summary.md`
- `assets/templates/project/workflows/react-review-command.yml`
- `assets/templates/project/workflows/react-review-command-opus.yml`
- `scripts/collect-pr-context.sh`
- `scripts/install-into-project.sh`

## Prerequisite

- Run this repository as a Git working tree (`git init` or cloned repo). `scripts/collect-pr-context.sh` requires Git history and refs.

## Quick Start (Tool-agnostic)

1. Clone and install commands:

```bash
git clone https://github.com/dioKR/react-review-skills.git
cd react-review-skills
bash scripts/install-cli.sh
```

2. In the React/Next project you want to review:

- Codex prompt helper
```bash
react-review-codex
```

- Claude Code prompt helper
```bash
react-review-claude
```

Then copy the printed prompt and paste it into your agent.
Default base ref is auto-detected from the current branch upstream.  
You can override with `react-review-codex <base-ref>` or `react-review-claude <base-ref>`.

## Codex Skill Install (Optional)

If you want Codex native skill loading via `$react-review-skills`:

```bash
bash scripts/install-skill.sh
```

## Claude Code Usage

Use `react-review-claude <base-ref>`.  
This is tool-agnostic and does not require installing into `~/.codex`.

## Per-Project Setup

This repository is a reusable pack.  
If you want `/react-review` command in GitHub PR comments, install workflow into each target project:

```bash
bash scripts/install-into-project.sh /path/to/target-project
```

Opus default model workflow:

```bash
bash scripts/install-into-project.sh /path/to/target-project https://github.com/dioKR/react-review-skills.git opus
```

Then in the target project repository:

1. OpenAI workflow: secret `OPENAI_API_KEY`, optional variable `OPENAI_MODEL`
2. Opus workflow: secret `ANTHROPIC_API_KEY`, optional variable `ANTHROPIC_MODEL` (default `claude-opus-4-1-20250805`)
3. Optional Actions variable `REACT_REVIEW_REQUIRE_BOT_PR=true` (only bot-authored PRs)
4. Commit/push the workflow and run `/react-review` in PR comments

See full guide: `docs/project-integration.md`.
