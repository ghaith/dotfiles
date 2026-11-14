# Shared Agent Context

This directory is the tool-agnostic source of truth for assistant context.

## Goals

- Keep preferences, environment docs, agent role definitions, and reusable skills in one place
- Reuse the same guidance across coding tools (currently Claude Code)
- Avoid drift between duplicated prompt files

## Structure

- `preferences.md` — communication and behavior preferences
- `environment/*.md` — reference docs for specific domains
- `agents/*.md` — reusable specialist agent role definitions
- `skills/*/SKILL.md` — reusable task-specific playbooks, loaded only when relevant

## Adapters

- Claude Code: `~/.claude/CLAUDE.md`

Adapters should stay thin and point back here for canonical details.

General preferences can be always-on. Domain-specific skills should be loaded lazily when the task actually matches.
