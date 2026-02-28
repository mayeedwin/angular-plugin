<!-- Source of truth: CLAUDE.md — keep in sync -->

# angular-plugin — GitHub Copilot Instructions

You are contributing to an open-source Claude Code plugin for Angular developers.
This repo is primarily markdown — skills, commands, and agent definitions read by Claude at runtime.

## Repo structure

| Directory | Purpose |
|---|---|
| `commands/` | User-invoked `/ng:*` slash commands |
| `skills/` | Auto-invoked `SKILL.md` files |
| `agents/` | Subagent persona definitions |
| `hooks/` | PostToolUse event handlers |
| `docs/STRUCTURE.md` | Canonical Angular project structure reference |
| `.claude-plugin/` | Plugin manifest only |

## Rules

- Arrow functions only
- `description` frontmatter: one line
- No unnecessary comments
- All Angular patterns reference https://angular.dev/llms.txt
- Angular 20 defaults: `{name}.ts` for components (no `.component.` suffix), `standalone: true`, `OnPush`, `inject()`

## Commit format

```
type(scope): description
```

Types: `feat | fix | docs | style | refactor | test | chore | perf | ci | build | hotfix`
Scopes: `skills | commands | agents | hooks | docs | plugin | scripts | readme`
