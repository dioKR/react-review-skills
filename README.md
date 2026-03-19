# react-review-skills

Single-skill repository for reviewing React/Next.js PRs with consistent quality gates.

## Review Gates

6-gate workflow with self-check:

1. **Scope & Strategy** — Diff 크기별 리뷰 깊이 조절 (small/medium/large)
2. **Convention** — 프로젝트 컨벤션 준수 여부 (CLAUDE.md, 기존 코드 패턴 기반)
3. **Performance** — Vercel/Next.js 아키텍처 및 성능 (waterfall, client boundary, bundle)
4. **Code Quality** — Toss 코드 품질 (readability, predictability, cohesion, coupling)
5. **Accessibility** — 시맨틱 HTML, 키보드, 포커스, 레이블링
6. **Test Coverage** — 테스트 누락, 미수정, 구현 결합 검출

모든 finding은 제출 전 **self-check** (diff 근거, fix 컴파일, severity 정확성, 중복, actionability)를 거칩니다.

## Severity & Confidence

| Severity | 기준 |
|----------|------|
| P0 | broken behavior, security/privacy, severe a11y blocker, large perf regression |
| P1 | significant maintainability/readability/perf risk |
| P2 | improvement suggestions and local cleanups |

| Confidence | 기준 |
|------------|------|
| high | diff에서 직접 확인 가능 |
| medium | 주변 컨텍스트에 의존, 문제 가능성 높음 |
| low | 추측성 제안, 별도 섹션으로 분리, P0 불가 |

## Primary Files

- `SKILL.md` — source of truth
- `CLAUDE.md` — Claude Code 실행 가이드
- `AGENTS.md` — Codex 에이전트 지침
- `references/vercel-react-rules.md` — 성능/아키텍처 체크 기준
- `references/toss-code-quality.md` — 코드 품질 체크 기준
- `references/a11y-pr-checklist.md` — 접근성 체크리스트
- `references/lint-tooling-map.md` — ESLint/Biome 룰 매핑
- `references/common-findings.md` — 반복 패턴 레지스트리
- `assets/templates/pr-review-comment.md` — 개별 finding 템플릿
- `assets/templates/pr-summary.md` — 리뷰 요약 템플릿 (Implementation Checklist 포함)
- `scripts/collect-pr-context.sh` — PR 컨텍스트 수집
- `scripts/install-into-project.sh` — 프로젝트별 워크플로우 설치

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
