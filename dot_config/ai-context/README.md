# Shared AI Context

This directory is the tool-agnostic source of truth for assistant context.

## Goals

- Keep preferences, environment docs, and agent role definitions in one place
- Reuse the same guidance across Pi, Claude Code, and other coding tools
- Avoid drift between duplicated prompt files

## Structure

- `preferences.md` — communication and behavior preferences
- `environment/chezmoi.md` — dotfiles and Pi config management
- `environment/nixos.md` — NixOS flake structure and workflows
- `agents/*.md` — reusable specialist agent role definitions

## Adapters

- Pi adapter: `~/.pi/agent/AGENTS.md` + `~/.pi/agent/skills/*`
- Claude Code adapter: `~/.claude/CLAUDE.md`

Adapters should stay thin and point back here for canonical details.
