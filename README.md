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
- `scripts/collect-pr-context.sh`

## Prerequisite

- Run this repository as a Git working tree (`git init` or cloned repo). `scripts/collect-pr-context.sh` requires Git history and refs.

## Quick Start (Easier)

1. Install/update this skill to your local Codex skills folder:

```bash
bash /Users/yh/MyProject/react-review-skills/scripts/install-skill.sh
```

2. In the React/Next project you want to review, run:

```bash
~/.codex/skills/react-review-skills/scripts/review-local.sh origin/main
```

Then copy the printed prompt and paste it into Codex.

## Codex Usage

Use skill name: `$react-review-skills`

## Claude Code Usage

Use `CLAUDE.md` in this repository root as the execution guide, and follow the same workflow and templates in this repository.
