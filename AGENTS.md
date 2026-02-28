<!-- Source of truth: CLAUDE.md — keep in sync -->

# angular-plugin — AI Agent Guidelines

You are contributing to an **open-source Claude Code plugin for Angular developers**.
This repo contains skills, commands, and agent definitions — primarily markdown files that Claude reads at runtime.

## What this repo is

| Directory | Purpose |
|---|---|
| `commands/` | User-invoked `/ng:*` slash commands |
| `skills/` | Model-invoked `SKILL.md` files — auto-triggered by Claude |
| `agents/` | Subagent persona definitions |
| `hooks/` | Event handler config (`hooks.json`) |
| `scripts/` | Shell utilities |
| `docs/` | Reference — `STRUCTURE.md` is the canonical Angular project structure |
| `.claude-plugin/` | Plugin manifest (`plugin.json`) only |

## Always-apply rules

- Arrow functions only — never `function` keyword
- `description` frontmatter: one line only
- No comments in skill/command files unless non-obvious
- All Angular decisions reference **https://angular.dev/llms.txt**
- `docs/STRUCTURE.md` is the single source of truth for Angular conventions
- Commit format: `type(scope): description`

## Commit format

```
type(scope): description
```

Types: `feat | fix | docs | style | refactor | test | chore | perf | ci | build | hotfix`
Scopes: `skills | commands | agents | hooks | docs | plugin | scripts | readme`

## Engineer setup (once after clone)

```bash
bash scripts/install-hooks.sh
```

## Reference docs

- [Opinionated Angular structure](docs/STRUCTURE.md)
- [Plugin manifest](/.claude-plugin/plugin.json)
- [Contributing guide](CONTRIBUTING.md)
- [Angular documentation](https://angular.dev/llms.txt)
