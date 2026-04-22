# Shared AI Context

This directory is the tool-agnostic source of truth for assistant context.

## Goals

- Keep preferences, environment docs, agent role definitions, and reusable skills in one place
- Reuse the same guidance across Pi, Claude Code, and other coding tools
- Avoid drift between duplicated prompt files

## Structure

- `preferences.md` — communication and behavior preferences
- `environment/*.md` — reference docs for specific domains
- `agents/*.md` — reusable specialist agent role definitions
- `skills/*.md` — reusable task-specific playbooks, loaded only when relevant

## Adapters

- Pi adapter: `~/.pi/agent/AGENTS.md` + `~/.pi/agent/skills/*`
- Claude Code adapter: `~/.claude/CLAUDE.md`

Adapters should stay thin and point back here for canonical details.

General preferences can be always-on. Domain-specific skills should be loaded lazily when the task actually matches.
