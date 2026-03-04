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

1. Clone and install/update this skill:

```bash
git clone https://github.com/dioKR/react-review-skills.git
cd react-review-skills
bash scripts/install-skill.sh
```

2. In the React/Next project you want to review, run one command:

```bash
~/.codex/skills/react-review-skills/scripts/review-local.sh origin/main
```

For Claude Code:

```bash
~/.codex/skills/react-review-skills/scripts/review-local-claude.sh origin/main
```

Then copy the printed prompt and paste it into your agent.

## Codex Usage

Use skill name: `$react-review-skills`

## Claude Code Usage

Use:

```bash
~/.codex/skills/react-review-skills/scripts/review-local-claude.sh <base-ref>
```

This prints a ready-to-paste prompt that points Claude Code to this pack's `CLAUDE.md`, `SKILL.md`, references, and templates.
