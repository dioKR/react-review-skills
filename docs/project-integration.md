# Project Integration Guide

This repository is a reusable review pack.
Actual PR command automation must be installed in each target project.

## Review Gates

The skill runs 6 gates + self-check:

1. Scope & Strategy (diff size adaptation)
2. Convention (project-local rules)
3. Performance (Vercel/Next.js)
4. Code Quality (Toss fundamentals)
5. Accessibility
6. Test Coverage

See `SKILL.md` for full details.

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

### Convention Gate Setup

To get the most out of the convention gate, ensure your target project has one of:

- `CLAUDE.md` with project instructions and conventions
- `CONVENTIONS.md` with explicit coding standards
- Configured linter (`eslint.config.*`, `biome.json`) — enforced rules imply conventions

If none exist, the reviewer will infer conventions from existing code patterns.

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

## C) Using the Implementation Checklist

The review summary includes an **Implementation Checklist** at the end. This is designed to be copied to the implementation agent:

1. Review agent leaves comments + summary with checklist
2. Copy the checklist to the implementation agent
3. Tell the agent: "모든 항목을 반영하고, 각 항목별 반영/스킵 여부를 리스트로 보고해"
4. Implementation agent checks off each item with ✅ (fixed) or ⏭️ (skipped with reason)
