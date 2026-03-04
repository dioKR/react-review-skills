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
react-review-codex origin/main
```

- Claude Code prompt helper
```bash
react-review-claude origin/main
```

Then copy the printed prompt and paste it into your agent.

## Codex Skill Install (Optional)

If you want Codex native skill loading via `$react-review-skills`:

```bash
bash scripts/install-skill.sh
```

## Claude Code Usage

Use `react-review-claude <base-ref>`.  
This is tool-agnostic and does not require installing into `~/.codex`.
