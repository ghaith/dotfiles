# Shared Agent Context

This directory is the tool-agnostic source of truth for assistant context.

## Goals

- Keep preferences, environment docs, agent role definitions, and reusable skills in one place
- Reuse the same guidance across Codex, Pi, Claude Code, Antigravity, and other coding tools
- Avoid drift between duplicated prompt files

## Structure

- `preferences.md` — communication and behavior preferences
- `environment/*.md` — reference docs for specific domains
- `agents/*.md` — reusable specialist agent role definitions
- `skills/*/SKILL.md` — reusable task-specific playbooks, loaded only when relevant

## Adapters

- Codex: `~/.codex/AGENTS.md`; skills are discovered directly from `~/.agents/skills/`
- Pi: `~/.pi/agent/AGENTS.md` + `~/.pi/agent/skills/*`
- Claude Code: `~/.claude/CLAUDE.md`
- Antigravity: `~/.gemini/GEMINI.md` + `~/.gemini/config/skills/*`

Adapters should stay thin and point back here for canonical details.

General preferences can be always-on. Domain-specific skills should be loaded lazily when the task actually matches.
